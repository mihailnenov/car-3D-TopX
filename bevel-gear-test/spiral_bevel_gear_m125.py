"""
Parametric 90-Degree Spiral Bevel Gear Pair (M1.25, 20T, 1:1) - Build123d.
Translated and upgraded from 'Spiral Helical Bevel  Gear M1.25.scad'.

Improvements over the OpenSCAD version:
  1. True spherical-involute tooth flanks (exact for bevel gears) instead of
     the Tredgold back-cone approximation mapped onto a sphere.
  2. Logarithmic tooth trace -> constant spiral angle along the whole face
     ("linear" reproduces the OpenSCAD twist, whose angle drops toward the toe).
  3. Proper back cone (heel) and front cone (toe) perpendicular to the pitch
     cone. The back cone gives a 45 deg underside for support-free printing.
  4. Smooth B-rep surfaces -> clean STEP export, and STL at any resolution.
  5. Supports non 1:1 ratios via `mate_teeth`. The "mesh" mode reports the
     interference volume between the two meshed gears.
"""

import math
from pathlib import Path

from build123d import *
from OCP.BRepBuilderAPI import BRepBuilderAPI_MakeSolid, BRepBuilderAPI_Sewing
from OCP.BRepOffsetAPI import BRepOffsetAPI_ThruSections
from OCP.ShapeFix import ShapeFix_Solid
from OCP.TopoDS import TopoDS

try:
    from ocp_vscode import show
    HAS_VIEWER = True
except ImportError:
    HAS_VIEWER = False

# =============================================================================
# PARAMETERS (same names/values as the .scad unless noted)
# =============================================================================
render_mode = "pair"        # "pair", "RH", "LH", "mesh"

# Gear parameters
module_val = 1.25           # Module (25.0 mm outer pitch diameter for 20T)
teeth = 20                  # Teeth on this gear
mate_teeth = 20             # Teeth on the mating gear (20 -> 1:1, 45 deg cone)
face_width = 8.0            # Tooth face width along the pitch cone (mm)
spiral_angle = 30.0         # Spiral angle (deg), 25-35 typical
pressure_angle = 20.0       # Normal pressure angle (deg)
backlash = 0.12             # Circumferential tooth thinning at heel pitch circle (mm)
spiral_type = "logarithmic" # "logarithmic" (constant angle) or "linear" (as .scad)
addendum_coef = 1.0         # Addendum = coef * module (at heel)
dedendum_coef = 1.2         # Dedendum = coef * module (at heel)

# Hub & bore
bore_dia = 6.0              # Shaft diameter (mm)
bore_clearance = 0.15       # Extra diameter for printed fit (mm)
hub_dia = 20.0              # Rear hub outer diameter (mm)
hub_height = 8.5            # Hub height below the gear back (mm)
front_recess_d = 10.0       # Front pocket diameter (was 14.5 in .scad; that cut
                            # into the tooth toes - auto-clamped to keep a wall)
front_recess_h = 3.0        # Front pocket depth (mm)
set_screw_pilot = 2.6       # Radial pilot hole for tapping M3 in PLA/PETG
edge_chamfer = 0.4          # Bottom chamfer on hub and bore (elephant foot)
min_wall = 1.0              # Minimum wall kept around the front pocket (mm)

# Resolution (B-rep: only affects the accuracy of the surfaces, not facets)
flank_points = 14           # Points per tooth flank curve
cone_sections = 9           # Loft sections across the face width
stl_tolerance = 0.005       # STL linear tolerance (mm)
stl_angular_tolerance = 0.1 # STL angular tolerance (rad)

OUT_DIR = Path(__file__).resolve().parent


# =============================================================================
# SPHERICAL INVOLUTE MATH
# =============================================================================
def sph_involute(psi: float, base_angle: float) -> tuple[float, float]:
    """Point of a spherical involute on the unit sphere at roll angle `psi`.

    A great circle rolls on the base cone (half angle `base_angle`); the
    returned point is (polar angle from gear axis, azimuth)."""
    sb, cb = math.sin(base_angle), math.cos(base_angle)
    a = psi * sb  # arc length unrolled from the base circle
    cx, cy, cz = sb * math.cos(psi), sb * math.sin(psi), cb
    tx, ty = -math.sin(psi), math.cos(psi)
    px = cx * math.cos(a) - tx * math.sin(a)
    py = cy * math.cos(a) - ty * math.sin(a)
    pz = cz * math.cos(a)
    return math.acos(max(-1.0, min(1.0, pz))), math.atan2(py, px)


def psi_for_polar(polar: float, base_angle: float) -> float:
    """Roll angle at which the spherical involute reaches the given polar angle."""
    lo, hi = 0.0, math.pi / math.sin(base_angle)
    for _ in range(80):
        mid = 0.5 * (lo + hi)
        if sph_involute(mid, base_angle)[0] < polar:
            lo = mid
        else:
            hi = mid
    return 0.5 * (lo + hi)


# =============================================================================
# GEAR GEOMETRY
# =============================================================================
class BevelGeometry:
    def __init__(self, z: int, z_mate: int):
        self.z = z
        self.delta = math.atan2(z, z_mate)                       # pitch cone angle
        self.r_po = module_val * z / 2                           # heel pitch radius
        self.cd_o = self.r_po / math.sin(self.delta)             # heel cone distance
        self.cd_i = self.cd_o - face_width                       # toe cone distance
        if self.cd_i <= 0:
            raise ValueError("face_width is larger than the cone distance")
        self.apex_z = hub_height + self.r_po * math.cos(self.delta) / math.sin(self.delta)
        self.theta_a = self.delta + addendum_coef * module_val / self.cd_o  # tip cone
        self.theta_f = self.delta - dedendum_coef * module_val / self.cd_o  # root cone
        self.delta_b = math.asin(math.sin(self.delta) * math.cos(math.radians(pressure_angle)))

        z_virtual = z / math.cos(self.delta)
        z_min = 2 * addendum_coef / math.sin(math.radians(pressure_angle)) ** 2
        if z_virtual < z_min:
            print(f"Warning: {z}T has {z_virtual:.1f} virtual teeth (< {z_min:.1f}); the mate's "
                  "tips may cut into the root (undercut). Use more teeth or a smaller addendum.")
    # --- 2D (r, z) helpers for the revolved envelopes -----------------------
    def cone_point(self, cd: float, polar: float) -> tuple[float, float]:
        return cd * math.sin(polar), self.apex_z - cd * math.cos(polar)

    def cone_x_perp(self, cd: float, polar: float) -> tuple[float, float]:
        """Intersect a cone line (from the apex, `polar`) with the line through
        the pitch point at `cd` perpendicular to the pitch cone (back/front cone)."""
        # Along the pitch generatrix the perpendicular line is at distance cd,
        # so the point at `polar` lies at cd / cos(polar - delta) from the apex.
        return self.cone_point(cd / math.cos(polar - self.delta), polar)

    def perp_axis_z(self, cd: float) -> float:
        """Z where the back/front cone through the pitch point at `cd` meets the axis."""
        r, z = self.cone_point(cd, self.delta)
        return z - r * math.tan(self.delta)

    # --- Tooth section ------------------------------------------------------
    def tooth_profile(self) -> tuple[list[tuple[float, float]], float, float]:
        """Left flank as (polar, azimuth) list from below root to beyond tip,
        tooth centred on azimuth 0. Right flank is the mirror (-azimuth)."""
        m_ang = module_val / self.cd_o
        polar_lo = self.theta_f - 0.5 * m_ang      # buried in the root body
        polar_hi = self.theta_a + 0.3 * m_ang      # trimmed by the tip cone
        half_t = math.pi / (2 * self.z) - (backlash / 2) / self.r_po
        lam_p = sph_involute(psi_for_polar(self.delta, self.delta_b), self.delta_b)[1]
        offset = -lam_p - half_t

        pts = []
        if polar_lo < self.delta_b:
            # Radial (meridian) extension below the base cone, G1 with the involute.
            n_rad = 3
            for k in range(n_rad):
                p = polar_lo + (self.delta_b - polar_lo) * k / n_rad
                pts.append((p, offset))
            psi_lo = 0.0
        else:
            psi_lo = psi_for_polar(polar_lo, self.delta_b)
        psi_hi = psi_for_polar(polar_hi, self.delta_b)
        for k in range(flank_points):
            # Cosine spacing clusters points near both ends.
            u = 0.5 - 0.5 * math.cos(math.pi * k / (flank_points - 1))
            polar, lam = sph_involute(psi_lo + (psi_hi - psi_lo) * u, self.delta_b)
            pts.append((polar, lam + offset))

        if pts[-1][1] >= 0:
            raise ValueError("Tooth becomes pointed: reduce addendum/backlash or add teeth")
        return pts, polar_lo, polar_hi

    def twist(self, cd: float, hand: int) -> float:
        """Rotation (rad) of the tooth section at cone distance `cd` (0 at heel)."""
        k = math.tan(math.radians(spiral_angle)) / math.sin(self.delta)
        if spiral_type == "logarithmic":
            return hand * k * math.log(self.cd_o / cd)
        return hand * k * (self.cd_o - cd) / self.cd_o


def sphere_pt(g: BevelGeometry, cd: float, polar: float, az: float) -> Vector:
    return Vector(
        cd * math.sin(polar) * math.cos(az),
        cd * math.sin(polar) * math.sin(az),
        g.apex_z - cd * math.cos(polar),
    )


def make_tooth(g: BevelGeometry, hand: int) -> Solid:
    flank, polar_lo, polar_hi = g.tooth_profile()
    ext = max(0.5, 0.75 * module_val)
    wires = []
    for s in range(cone_sections):
        cd = (g.cd_o + ext) - (face_width + 2 * ext) * s / (cone_sections - 1)
        tw = g.twist(cd, hand)
        left = [sphere_pt(g, cd, p, a + tw) for p, a in flank]
        right = [sphere_pt(g, cd, p, -a + tw) for p, a in reversed(flank)]
        tip_mid = sphere_pt(g, cd, polar_hi, tw)
        root_mid = sphere_pt(g, cd, polar_lo, tw)
        edges = [
            Edge.make_spline(left),
            Edge.make_three_point_arc(left[-1], tip_mid, right[0]),
            Edge.make_spline(right),
            Edge.make_three_point_arc(right[-1], root_mid, left[0]),
        ]
        wires.append(Wire(edges))

    # The end sections lie on spheres (non-planar), so the loft cannot cap
    # itself: loft an open shell, add filled end caps, sew and make a solid.
    loft_shell = BRepOffsetAPI_ThruSections(False, False)
    for w in wires:
        loft_shell.AddWire(w.wrapped)
    loft_shell.Build()
    sew = BRepBuilderAPI_Sewing(1e-4)
    sew.Add(loft_shell.Shape())
    sew.Add(Face.make_surface(wires[0]).wrapped)
    sew.Add(Face.make_surface(wires[-1]).wrapped)
    sew.Perform()
    fix = ShapeFix_Solid(BRepBuilderAPI_MakeSolid(TopoDS.Shell(sew.SewedShape())).Solid())
    fix.Perform()
    tooth = Solid(TopoDS.Solid(fix.Solid()))
    if not tooth.is_valid or tooth.volume <= 0:
        raise RuntimeError("Tooth loft failed")
    return tooth


def revolve_rz(points: list[tuple[float, float]]) -> Part:
    face = Face(Wire.make_polygon([Vector(r, 0, z) for r, z in points], close=True))
    return revolve(face, axis=Axis.Z)


def make_gear(z: int, z_mate: int, hand: int) -> tuple[Part, BevelGeometry]:
    g = BevelGeometry(z, z_mate)

    heel_tip = g.cone_x_perp(g.cd_o, g.theta_a)
    toe_root = g.cone_x_perp(g.cd_i, g.theta_f)
    toe_tip = g.cone_x_perp(g.cd_i, g.theta_a)
    z_back_axis = g.perp_axis_z(g.cd_o)
    z_top = toe_root[1]  # flat front face at toe-root height

    # Oversized solid filling the root cone; the (oversized) teeth sink into it.
    big = 3 * g.cd_o
    root_cone = revolve_rz([(0, g.apex_z), g.cone_point(big, g.theta_f),
                            (0, g.apex_z - big * math.cos(g.theta_f))])
    tooth = make_tooth(g, hand)
    teeth_solids = [tooth.rotate(Axis.Z, 360 * k / z) for k in range(z)]

    # Single trim by the envelope (back cone, tip cone, front cone, flat front
    # face) avoids coincident faces between separately trimmed parts.
    envelope = revolve_rz([(0, z_back_axis), heel_tip, toe_tip, toe_root, (0, z_top)])
    gear = (root_cone + teeth_solids) & envelope

    # Rear hub with bottom chamfer.
    hub_r = hub_dia / 2
    heel_root_r = g.cone_x_perp(g.cd_o, g.theta_f)[0]
    if hub_r > heel_root_r:
        print(f"Warning: hub_dia {hub_dia} > heel root diameter {2 * heel_root_r:.2f} mm on {z}T; "
              "the hub will hit the mating gear's teeth.")
    c = edge_chamfer
    hub = revolve_rz([(0, 0), (hub_r - c, 0), (hub_r, c), (hub_r, hub_height + 0.5), (0, hub_height + 0.5)])
    gear = gear + hub

    # Clip anything below the print bed.
    gear = gear & (Pos(0, 0, 50) * Box(500, 500, 100))

    # Through bore with bottom chamfer.
    bore_r = (bore_dia + bore_clearance) / 2
    bore = revolve_rz([(0, -1), (bore_r + c + 1, -1), (bore_r, c), (bore_r, z_top + 1), (0, z_top + 1)])
    gear = gear - bore

    # Front recess pocket, clamped to keep `min_wall` under the toe root.
    if front_recess_h > 0 and front_recess_d > 0:
        max_d = 2 * (toe_root[0] - min_wall)
        recess_d = min(front_recess_d, max_d)
        if recess_d < front_recess_d:
            print(f"Note: front_recess_d clamped {front_recess_d} -> {recess_d:.2f} mm")
        recess = Pos(0, 0, z_top - front_recess_h) * Cylinder(
            recess_d / 2, front_recess_h + 1, align=(Align.CENTER, Align.CENTER, Align.MIN))
        gear = gear - recess

    # Radial M3 set-screw pilot hole.
    pilot = Pos(0, 0, hub_height * 0.48) * Rot(0, 90, 0) * Cylinder(
        set_screw_pilot / 2, hub_dia, align=(Align.CENTER, Align.CENTER, Align.MIN))
    gear = gear - pilot

    return gear, g


def export(part: Part, name: str) -> None:
    export_stl(part, str(OUT_DIR / f"{name}.stl"),
               tolerance=stl_tolerance, angular_tolerance=stl_angular_tolerance)
    export_step(part, str(OUT_DIR / f"{name}.step"))
    bb = part.bounding_box().size
    print(f"Exported {name}: {bb.X:.2f} x {bb.Y:.2f} x {bb.Z:.2f} mm, "
          f"volume {part.volume:.1f} mm^3, valid={part.is_valid}")


# =============================================================================
# BUILD
# =============================================================================
if __name__ == "__main__":
    base = f"spiral_bevel_gear_M{module_val:g}_{teeth}T"
    shown, names, colors = [], [], []

    if render_mode in ("RH", "LH"):
        gear, _ = make_gear(teeth, mate_teeth, 1 if render_mode == "RH" else -1)
        export(gear, f"{base}_{render_mode}")
        shown, names, colors = [gear], [render_mode], ["#E6B800"]

    elif render_mode == "pair":
        rh, g = make_gear(teeth, mate_teeth, 1)
        lh, _ = make_gear(teeth, mate_teeth, -1)
        export(rh, f"{base}_RH")
        export(lh, f"{base}_LH")
        dx = g.r_po + 3.5
        shown = [Pos(-dx, 0, 0) * rh, Pos(dx, 0, 0) * lh]
        names, colors = ["RH", "LH"], ["#E6B800", "#3C8DBC"]

    elif render_mode == "mesh":
        g1_part, g1 = make_gear(teeth, mate_teeth, 1)
        g2_part, g2 = make_gear(mate_teeth, teeth, -1)
        # Gear 2 axis along -Y with both pitch apexes coincident. On the line
        # where the pitch cones touch (gear 1 azimuth +90, gear 2 local -90)
        # the phase puts a gear-2 tooth space against a gear-1 tooth.
        pitch2 = 360 / mate_teeth
        frac2 = (0.5 - (teeth / 4) % 1) % 1
        phase = (-90 - frac2 * pitch2) % pitch2
        g2_placed = Pos(0, g2.apex_z, g1.apex_z) * Rot(90, 0, 0) * Rot(0, 0, phase) * g2_part
        clash = (g1_part & g2_placed).volume
        print(f"Mesh check: interference volume = {clash:.4f} mm^3 (should be ~0)")
        shown = [g1_part, g2_placed]
        names, colors = ["Gear 1 (RH)", "Gear 2 (LH)"], ["#E6B800", "#3C8DBC"]

    else:
        raise ValueError(f"Unknown render_mode: {render_mode}")

    if HAS_VIEWER:
        try:
            show(*shown, names=names, colors=colors, port=3939)
        except Exception as e:
            print(f"Viewer notice: {e}")

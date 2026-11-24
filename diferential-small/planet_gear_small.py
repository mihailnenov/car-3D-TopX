"""
Planet (satellite) gears Z=12 - Translated from 'Flanges + Planet Gears.scad'
(module planet_gear_short) to Build123d.

Matches the OpenSCAD geometry:
  1. Helical toothed section, Z=12, m=0.85, x=0.25, beta=20 deg, 14.6 mm long
     (same gear_2d_profile / single_tooth_2d tooth form, same twist).
  2. Neck without teeth: dia 7.40 mm, 2.0 mm long (total length 16.6 mm).
  3. Through bore dia 4.55 mm for the dia 4.40 mm planet pin journal.

  view_mode 5 in .scad -> hand = -1 -> "LH"   (print 3 pcs)
  view_mode 6 in .scad -> hand = +1 -> "RH"   (print 3 pcs)

The helix is an exact helicoidal sweep instead of OpenSCAD's stacked slices,
and circles are true circles instead of $fn polygons.
"""

import math
from pathlib import Path

from build123d import *

try:
    from ocp_vscode import show
    HAS_VIEWER = True
except ImportError:
    HAS_VIEWER = False

# =============================================================================
# PARAMETERS (identical to 'Flanges + Planet Gears.scad')
# =============================================================================
render_mode = "both"        # "both", "LH" (view_mode 5), "RH" (view_mode 6)

m = 0.85                    # Module
alpha = 20.0                # Pressure angle (deg)
beta = 20.0                 # Helix angle (deg)

z_planet = 12               # Teeth
x_planet = 0.25             # Profile shift
planet_gear_len = 14.6      # Toothed section length (mm)
planet_neck_len = 2.0       # Neck without teeth (mm)
planet_neck_od = 7.40       # Neck outer diameter (mm)
planet_total_len = planet_gear_len + planet_neck_len  # 16.6 mm
bore_journal = 4.55         # Bore for the dia 4.40 mm journal (0.15 mm clearance)

r_p_planet = (m * z_planet) / 2  # 5.10 mm

involute_points = 41        # Points on each involute flank (.scad uses 21)
OUT_DIR = Path(__file__).resolve().parent


# =============================================================================
# HELPER: Single tooth wedge - exactly single_tooth_2d() from OpenSCAD
# Polygon: origin -> involute flank -> straight tip chord -> mirrored flank.
# =============================================================================
def single_tooth_face(z: int, x: float, r_p: float, r_b: float, r_a: float, r_d: float) -> Face:
    t_max = math.sqrt((r_a / r_b) ** 2 - 1)
    t_min = math.sqrt((r_d / r_b) ** 2 - 1) if r_d > r_b else 0.0
    t_p = math.sqrt((r_p / r_b) ** 2 - 1)
    inv_p = math.degrees(t_p) - math.degrees(math.atan(t_p))
    s_angle = (180 / z) + (360 * x * math.tan(math.radians(alpha)) / (math.pi * z))
    offset = s_angle / 2 + inv_p

    pts = []
    for i in range(involute_points):
        t = t_min + i * (t_max - t_min) / (involute_points - 1)
        r = r_b * math.sqrt(1 + t * t)
        theta = math.degrees(t) - math.degrees(math.atan(t))
        a = math.radians(offset - theta)
        pts.append(Vector(r * math.cos(a), r * math.sin(a)))
    # Counter-clockwise outline (normal +Z) so it fuses with the root circle.
    mirror_pts = [Vector(p.X, -p.Y) for p in pts]
    origin = Vector(0, 0)
    wire = Wire([
        Edge.make_line(origin, mirror_pts[0]),
        Edge.make_spline(mirror_pts),
        Edge.make_line(mirror_pts[-1], pts[-1]),
        Edge.make_spline(list(reversed(pts))),
        Edge.make_line(pts[0], origin),
    ])
    return Face(wire)


# =============================================================================
# HELPER: Full 2D gear profile - exactly gear_2d_profile() from OpenSCAD
# =============================================================================
def gear_2d_profile(z: int, x: float, mod_val: float) -> Face:
    r_p = (mod_val * z) / 2
    r_b = r_p * math.cos(math.radians(alpha))
    r_a = r_p + mod_val * (1 + x)
    r_d = r_p - mod_val * (1.25 - x)

    tooth = single_tooth_face(z, x, r_p, r_b, r_a, r_d)
    profile = Face(Wire.make_circle(r_d + 0.05))
    for i in range(z):
        profile = profile.fuse(tooth.rotate(Axis.Z, i * 360 / z))
    return profile.clean().faces()[0]


# =============================================================================
# BUILD THE PLANET GEAR - exactly planet_gear_short(hand) from OpenSCAD
# =============================================================================
def planet_gear_short(hand: int = 1) -> Part:
    twist_deg = hand * math.degrees(planet_gear_len * math.tan(math.radians(beta)) / r_p_planet)

    # OpenSCAD's linear_extrude rotates the profile CLOCKWISE (seen from +Z)
    # for a positive twist, hence the minus sign.
    profile = gear_2d_profile(z_planet, x_planet, m)
    teeth = Solid.extrude_linear_with_rotation(
        profile, center=(0, 0, 0), normal=(0, 0, planet_gear_len), angle=-twist_deg)

    neck = Pos(0, 0, planet_gear_len - 0.05) * Cylinder(
        planet_neck_od / 2, planet_neck_len + 0.05, align=(Align.CENTER, Align.CENTER, Align.MIN))
    bore = Pos(0, 0, -1) * Cylinder(
        bore_journal / 2, planet_total_len + 2, align=(Align.CENTER, Align.CENTER, Align.MIN))

    return teeth + neck - bore


def export(part: Part, name: str) -> None:
    export_stl(part, str(OUT_DIR / f"{name}.stl"), tolerance=0.002, angular_tolerance=0.1)
    export_step(part, str(OUT_DIR / f"{name}.step"))
    bb = part.bounding_box().size
    print(f"Exported {name}: {bb.X:.2f} x {bb.Y:.2f} x {bb.Z:.2f} mm, "
          f"volume {part.volume:.1f} mm^3, valid={part.is_valid}")


# =============================================================================
# EXPORTS (STL for 3D Printing, STEP for CAD)
# =============================================================================
if __name__ == "__main__":
    shown, names, colors = [], [], []
    for label, hand, color in (("LH", -1, "LimeGreen"), ("RH", 1, "Gold")):
        if render_mode not in ("both", label):
            continue
        gear = planet_gear_short(hand)
        export(gear, f"planet_gear_z{z_planet}_{label}")
        offset = 0 if render_mode != "both" else (-1 if label == "LH" else 1) * (r_p_planet + 3)
        shown.append(Pos(offset, 0, 0) * gear)
        names.append(f"Planet Z={z_planet} {label}")
        colors.append(color)

    # =========================================================================
    # VISUALIZE IN VS CODE OCP VIEWER
    # =========================================================================
    if HAS_VIEWER:
        try:
            show(*shown, names=names, colors=colors, port=3939)
        except Exception as e:
            print(f"Viewer notice: {e}")

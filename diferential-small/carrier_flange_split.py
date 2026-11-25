"""
Herringbone carrier flange Z=27 - Translated from 'Flanges + Planet Gears.scad'
(module carrier_flange) to Build123d, SPLIT INTO TWO PRINTABLE HALVES.

The herringbone flange (6.0 mm + 1.0 mm bosses) is cut at the chevron apex
(Z = -3.0). Each half is a single helical gear with opposite hand and is
printed with the cut face on the bed. Gluing the two bed faces together gives
exactly the original flange with all holes, seats and steps:

  INNER half (planet side, Z = -3 .. 0, bosses to +1):
      bearing seat dia 15.08 with 0.4 mm lead chamfer, 3 bosses dia 5.40 x 1.0,
      3 pin holes dia 5.00 (+0.15 mm chamfer), 3 tip holes dia 3.00 (+0.25 chamfer)
  OUTER half (Z = -6 .. -3):
      bearing seat dia 15.08 down to Z = -5, 1.00 mm collar with dia 13.00 hole,
      3 pin holes dia 5.00, 3 tip holes dia 3.00

The 3 planet pins (dia 5.05 through the whole 6 mm) and the 3 opposite pin
tips (dia 3.05) pass through both halves and act as alignment dowels while
the glue sets.
"""

import math
from pathlib import Path

from build123d import *

from planet_gear_small import gear_2d_profile

try:
    from ocp_vscode import show
    HAS_VIEWER = True
except ImportError:
    HAS_VIEWER = False

# =============================================================================
# PARAMETERS (identical to 'Flanges + Planet Gears.scad')
# =============================================================================
render_mode = "print"       # "print" (both halves for printing), "assembled", "full"

# Herringbone ring on the flange
ring_m = 1.2
ring_z = 27
ring_x = 0.00
ring_beta = 20.0

# Planet kinematics (only needed for the hole positions)
m = 0.85
z_sun, x_sun = 12, 0.25
z_planet, x_planet = 12, 0.25
planet_boss_h = 1.00
r_p_sun = (m * z_sun) / 2
r_p_planet = (m * z_planet) / 2
a_sp = r_p_sun + r_p_planet + m * (x_sun + x_planet) * 0.85           # 10.561 mm
a_pp = 2 * r_p_planet + m * (2 * x_planet) * 0.85                      # 10.561 mm
pair_angle = math.degrees(2 * math.asin((a_pp / 2) / a_sp))            # 60.00 deg

# Flange and 6700 bearing seat (10x15x4)
flange_thick = 6.0
flange_seat_d = 15.08
seat_depth = 5.00
pass_hole_d = 13.00
flange_boss_od = 5.40
flange_pin_hole = 5.00
flange_tip_hole = 3.00
brg_lead_chamfer = 0.40
tip_lead_chamfer = 0.25

split_z = -flange_thick / 2  # chevron apex = glue plane
OUT_DIR = Path(__file__).resolve().parent


# =============================================================================
# HELPERS
# =============================================================================
def cyl(d: float, z0: float, h: float, x: float = 0.0, ang: float = 0.0) -> Solid:
    """OpenSCAD-style rotate(ang) translate([x,0,z0]) cylinder(d, h)."""
    return (Pos(x, 0, z0) * Solid.make_cylinder(d / 2, h)).rotate(Axis.Z, ang)


def cone(d1: float, d2: float, z0: float, h: float, x: float = 0.0, ang: float = 0.0) -> Solid:
    """OpenSCAD-style rotate(ang) translate([x,0,z0]) cylinder(d1, d2, h)."""
    return (Pos(x, 0, z0) * Solid.make_cone(d1 / 2, d2 / 2, h)).rotate(Axis.Z, ang)


def herringbone_gear_3d(z: int, m_val: float, w: float, beta_val: float,
                        x_val: float = 0.0, hand: int = 1) -> Part:
    """Exactly herringbone_gear_3d() from OpenSCAD, placed at Z = 0 .. w.

    In OpenSCAD each half is linear_extrude(height = w/2 + 0.02, twist = t),
    i.e. the twist rate is t / (w/2 + 0.02); a positive twist turns the
    profile CLOCKWISE going away from the outer faces."""
    r_p = (m_val * z) / 2
    twist_deg = hand * math.degrees((w / 2) * math.tan(math.radians(beta_val)) / r_p)
    half_h = w / 2
    mid_rot = -twist_deg * half_h / (half_h + 0.02)

    profile = gear_2d_profile(z, x_val, m_val)
    lower = Solid.extrude_linear_with_rotation(
        profile, center=(0, 0, 0), normal=(0, 0, half_h), angle=mid_rot)
    upper = Solid.extrude_linear_with_rotation(
        Pos(0, 0, half_h) * profile.rotate(Axis.Z, mid_rot),
        center=(0, 0, half_h), normal=(0, 0, half_h), angle=-mid_rot)
    return lower + upper


# =============================================================================
# FULL FLANGE - exactly carrier_flange() from OpenSCAD (Z = -6 .. 0, bosses to +1)
# =============================================================================
def carrier_flange() -> Part:
    body = Pos(0, 0, -flange_thick) * herringbone_gear_3d(
        ring_z, ring_m, flange_thick, ring_beta, ring_x, hand=1)

    # 3 spacer bosses dia 5.40 x 1.0 mm around the tip holes
    for i in range(3):
        body += cyl(flange_boss_od, -0.1, planet_boss_h + 0.1, a_sp, i * 120 + pair_angle)

    cuts = [
        # A. Through hole dia 13.00 (1.00 mm collar for the bearing outer ring)
        cyl(pass_hole_d, -flange_thick - 0.5, flange_thick + 1.0),
        # B. Bearing seat 6700 dia 15.08, Z = -5.00 .. 0.00
        cyl(flange_seat_d, -seat_depth, seat_depth + 0.1),
        # C. 0.4 mm lead chamfer on the bearing seat entry
        cone(flange_seat_d, flange_seat_d + 0.4, -brg_lead_chamfer, brg_lead_chamfer + 0.05),
    ]
    for i in range(3):
        a_tip = i * 120 + pair_angle
        a_pin = i * 120
        # D. Tip holes dia 3.00 through flange and boss, with lead chamfer
        cuts.append(cyl(flange_tip_hole, -flange_thick - 0.5,
                        flange_thick + planet_boss_h + 1.0, a_sp, a_tip))
        cuts.append(cone(flange_tip_hole, flange_tip_hole + 0.4,
                         planet_boss_h - tip_lead_chamfer, tip_lead_chamfer + 0.05, a_sp, a_tip))
        # E. Pin holes dia 5.00 through, with 0.15 mm inner lead chamfer
        cuts.append(cyl(flange_pin_hole, -flange_thick - 0.5, flange_thick + 1.0, a_sp, a_pin))
        cuts.append(cone(flange_pin_hole, flange_pin_hole + 0.20, -0.15, 0.15 + 0.05, a_sp, a_pin))

    return body - cuts


# =============================================================================
# SPLIT INTO TWO HALVES AND ORIENT FOR PRINTING (glue face on the bed, Z = 0)
# =============================================================================
def split_flange(flange: Part) -> tuple[Part, Part]:
    """Returns (inner, outer) halves in assembly position."""
    big = 100
    inner = flange & Pos(0, 0, split_z) * Box(big, big, big, align=(Align.CENTER, Align.CENTER, Align.MIN))
    outer = flange & Pos(0, 0, split_z) * Box(big, big, big, align=(Align.CENTER, Align.CENTER, Align.MAX))
    return inner, outer


def to_print_pose(inner: Part, outer: Part) -> tuple[Part, Part]:
    inner_p = Pos(0, 0, -split_z) * inner                       # Z = 0 .. 4
    outer_p = Pos(0, 0, -split_z) * Rot(180, 0, 0) * outer      # flipped, Z = 0 .. 3
    outer_p = Pos(0, 0, -outer_p.bounding_box().min.Z) * outer_p
    return inner_p, outer_p


def export(part: Part, name: str) -> None:
    export_stl(part, str(OUT_DIR / f"{name}.stl"), tolerance=0.002, angular_tolerance=0.1)
    export_step(part, str(OUT_DIR / f"{name}.step"))
    bb = part.bounding_box().size
    print(f"Exported {name}: {bb.X:.2f} x {bb.Y:.2f} x {bb.Z:.2f} mm, "
          f"volume {part.volume:.1f} mm^3, valid={part.is_valid}")


# =============================================================================
# BUILD / EXPORT / SHOW
# =============================================================================
if __name__ == "__main__":
    flange = carrier_flange()
    inner, outer = split_flange(flange)

    if render_mode == "print":
        inner_p, outer_p = to_print_pose(inner, outer)
        export(inner_p, "carrier_flange_z27_half_inner")
        export(outer_p, "carrier_flange_z27_half_outer")
        dx = 19.0
        shown = [Pos(-dx, 0, 0) * inner_p, Pos(dx, 0, 0) * outer_p]
        names = ["Inner half (bosses)", "Outer half (collar)"]
        colors = ["LightSteelBlue", "SlateGray"]
    elif render_mode == "assembled":
        shown, names, colors = [inner, outer], ["Inner half", "Outer half"], ["LightSteelBlue", "SlateGray"]
    elif render_mode == "full":
        export(flange, "carrier_flange_z27_full")
        shown, names, colors = [flange], ["Carrier flange"], ["LightSteelBlue"]
    else:
        raise ValueError(f"Unknown render_mode: {render_mode}")

    if HAS_VIEWER:
        try:
            show(*shown, names=names, colors=colors, port=3939)
        except Exception as e:
            print(f"Viewer notice: {e}")

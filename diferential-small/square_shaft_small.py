"""
Stepped Square Shaft - Translated from 'Square shaft small.scad' to Build123d.
Matches the OpenSCAD geometry:
  1. Section 1: 5.65 mm square with 0.35 mm corner chamfers (Z = 0 to 10 mm)
  2. Section 2: 4.24 mm square with 0.35 mm corner chamfers (Z = 10 to 27 mm)
  3. Section 3: 4.0 mm straight rounded triangle (Z = 27 to 31 mm)
                tapered down to a 1.9 mm pyramid apex (Z = 31 to 32.9 mm)
"""

import math
from build123d import *

try:
    from ocp_vscode import show
    HAS_VIEWER = True
except ImportError:
    HAS_VIEWER = False

# =============================================================================
# PARAMETERS (identical to 'Square shaft small.scad')
# =============================================================================
s1 = 5.65           # Section 1 square width (mm)
h1 = 10.0           # Section 1 length (mm)
s2 = 4.24           # Section 2 square width (mm)
h2 = 17.0           # Section 2 length (mm)
corner_clip = 0.35  # Corner chamfer size

# Section 3 (Z = 27 to 33 mm)
h3_straight = 4.0   # Straight rounded triangle height (Z = 27 to 31)
h3_pyramid = 2.0    # Pyramid height (Z = 31 to 33)
tip_z_play = 0.10   # Tip axial play (1.90 mm effective)
pyr_h = h3_pyramid - tip_z_play

top_outer_r = 2.00  # Base outer radius of triangle (Ø4.0 mm)
top_corner_r = 0.40 # Base corner fillet radius
tip_outer_r = 0.60  # Pyramid apex outer radius (Ø1.2 mm)
tip_corner_r = 0.30 # Pyramid apex corner fillet radius


# =============================================================================
# HELPER: Chamfered Square Face (Intersection of square and 45-deg square)
# Exactly replicates chamfered_box() from OpenSCAD
# =============================================================================
def make_chamfered_square_face(s: float, clip: float) -> Face:
    diag_limit = s * math.sqrt(2) - 2 * clip
    with BuildSketch() as sk:
        Rectangle(s, s)
        with BuildSketch(mode=Mode.INTERSECT):
            with Locations(Rotation(0, 0, 45)):
                Rectangle(diag_limit, diag_limit)
    return sk.sketch.faces()[0]


# =============================================================================
# HELPER: Rounded Equilateral Triangle Face
# Matches rounded_polygon_2d(3, outer_r, corner_r) in OpenSCAD
# =============================================================================
def make_rounded_triangle_face(outer_r: float, corner_r: float) -> Face:
    r_center = max(0.05, outer_r - corner_r)
    with BuildSketch() as sk:
        with Locations(
            [(r_center * math.cos(math.radians(90 + i * 120)),
              r_center * math.sin(math.radians(90 + i * 120)))
             for i in range(3)]
        ):
            Circle(radius=corner_r)
        make_hull()
    return sk.sketch.faces()[0]


# =============================================================================
# BUILD THE STEPPED SHAFT
# =============================================================================
# Section 1: Z = 0 to 10 mm
sec1_face = make_chamfered_square_face(s1, corner_clip)
sec1_solid = extrude(sec1_face, amount=h1)

# Section 2: Z = 10 to 27 mm
sec2_face = make_chamfered_square_face(s2, corner_clip)
sec2_solid = extrude(Plane.XY.offset(h1) * sec2_face, amount=h2)

# Section 3A: Z = 27 to 31 mm (Straight rounded triangle)
z_sec3 = h1 + h2
tri_base = make_rounded_triangle_face(top_outer_r, top_corner_r)
sec3a_solid = extrude(Plane.XY.offset(z_sec3) * tri_base, amount=h3_straight)

# Section 3B: Z = 31 to 32.9 mm (Pyramidal tip loft)
z_pyr_base = z_sec3 + h3_straight
tri_mid = Plane.XY.offset(z_pyr_base) * make_rounded_triangle_face(top_outer_r, top_corner_r)
tri_top = Plane.XY.offset(z_pyr_base + pyr_h) * make_rounded_triangle_face(tip_outer_r, tip_corner_r)
sec3b_solid = loft([tri_mid, tri_top])

# Fuse all 4 sections into one single solid part
shaft = sec1_solid + sec2_solid + sec3a_solid + sec3b_solid


# =============================================================================
# EXPORTS (STL for 3D Printing, STEP for CAD)
# =============================================================================
export_stl(shaft, "square_shaft_small.stl")
export_step(shaft, "square_shaft_small.step")
print(f"Exported: Total shaft height = {shaft.bounding_box().size.Z:.2f} mm (Expected: 32.90 mm)")


# =============================================================================
# VISUALIZE IN VS CODE OCP VIEWER
# =============================================================================
if HAS_VIEWER:
    try:
        show(shaft, colors=["#E6B800"], names=["Stepped Square Shaft"], port=3939)
    except Exception as e:
        print(f"Viewer notice: {e}")

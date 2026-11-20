// =========================================================================
// SYMMETRICAL DUAL-BOARD WHEEL DRUM (CUP) - 20MM TOTAL WIDTH (HIGHER BOARDS)
// Outer Boards OD = 30mm (+0.5mm higher) | Drum Bed OD = 27mm | Total Width = 20mm
// =========================================================================

$fn = 100;

/* [Tyre & Rim Dimensions (mm)] */
board_od           = 30.0;   // Outer diameter of both boards (flanges)
drum_bed_od        = 27.0;   // Diameter of cylinder without boards (27mm)
board_thickness    = 2.0;    // Increased by 0.5mm (now 2.0mm each)
transition_cone_h  = 0.8;    // Small symmetrical transition cone height

// ОБЩАТА ширина на целия детайл открай до край е точно 20 мм:
total_width        = 20.0;   

/* [Cup Wall & Bottom Thickness (mm)] */
drum_wall          = 2.0;    // Radial wall thickness under 27mm bed (leaves 23mm ID)
bottom_thickness   = 3.5;    // Thickness of bottom mounting plate

/* [3-Bolt Shaft Mounting Pattern (mm)] */
num_bolts          = 3;      // 3 mini-bolts at 120 degrees
bolt_circle_d      = 15.0;   // Bolt circle diameter (fits inside 23mm ID cavity)
bolt_hole_d        = 3.4;    // Single straight through-hole diameter for M2/M3
center_pilot_d     = 6;    // Center bore (7.1mm)

/* [Between-Bolt Pill Hole (Slot) Windows] */
enable_pill_holes  = true;   // Toggle pill-shaped through-holes between bolts
pill_length        = 5.5;    // Total length of the pill slot
pill_width         = 2.2;    // Width/radius of the pill slot ends

// =========================================================================
// CALCULATED DIMENSIONS
// =========================================================================

channel_width = total_width - (2 * board_thickness); // 20 - 4 = 16.0mm канал
drum_id       = drum_bed_od - 2 * drum_wall;         // 23.0mm inner cup cavity diameter

// =========================================================================
// RENDER WHEEL
// =========================================================================

wheel_drum_symmetrical();

// =========================================================================
// MODULE
// =========================================================================

module wheel_drum_symmetrical() {
    difference() {
        // --- 1. POSITIVE BODY (27mm Drum + Identical 30mm Boards on Both Ends) ---
        union() {
            // Core 27mm Cylindrical Bed
            cylinder(d = drum_bed_od, h = total_width);
            
            // Bottom Board (at Z = 0, OD = 30mm, thickness 2.0mm) + Transition Cone
            cylinder(d = board_od, h = board_thickness);
            translate([0, 0, board_thickness])
                cylinder(d1 = board_od, d2 = drum_bed_od, h = transition_cone_h);
                
            // Top Board (at Z = total_width - 2.0, thickness 2.0mm) + Transition Cone
            translate([0, 0, total_width - board_thickness - transition_cone_h])
                cylinder(d1 = drum_bed_od, d2 = board_od, h = transition_cone_h);
            translate([0, 0, total_width - board_thickness])
                cylinder(d = board_od, h = board_thickness);
        }
        
        // --- 2. CUTOUTS (Inner Cup Cavity, Center Bore, Straight Bolt Holes, and Pill Slots) ---
        
        // Inner Cylindrical Cup Cavity (ID = 23mm, leaves solid bottom floor)
        translate([0, 0, bottom_thickness]) {
            cylinder(d1 = drum_id - 1.2, d2 = drum_id, h = 0.6);
            translate([0, 0, 0.59])
                cylinder(d = drum_id, h = total_width);
        }
        
        // Centering Pilot Bore in the bottom plate (7.1mm)
        translate([0, 0, -0.1])
            cylinder(d = center_pilot_d, h = bottom_thickness + 0.2);
            
        // Three Single-Level Straight Bolt Holes (at 120 degrees)
        for (i = [0 : num_bolts - 1]) {
            rotate([0, 0, i * (360 / num_bolts)]) {
                translate([bolt_circle_d / 2, 0, -0.1]) {
                    cylinder(d = bolt_hole_d, h = bottom_thickness + 0.2);
                }
            }
        }
        
        // Full Through-Hole Pill Slots Between Bolt Holes (on the outer plate)
        if (enable_pill_holes) {
            for (i = [0 : num_bolts - 1]) {
                rotate([0, 0, i * (360 / num_bolts) + (360 / (num_bolts * 2))]) {
                    translate([bolt_circle_d * 0.52, 0, -0.1]) {
                        linear_extrude(height = bottom_thickness + 0.2) {
                            hull() {
                                translate([0, -pill_length/2 + pill_width/2, 0])
                                    circle(d = pill_width);
                                translate([0, pill_length/2 - pill_width/2, 0])
                                    circle(d = pill_width);
                            }
                        }
                    }
                }
            }
        }
    }
}
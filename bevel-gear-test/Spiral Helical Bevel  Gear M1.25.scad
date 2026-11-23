// ============================================================================
// Parametric 90-Degree Spiral Bevel Gear Pair (1.25M, 20T, 1:1 Ratio)
// Designed for support-free FDM 3D printing (hub-down orientation)
// ============================================================================

/* [Render Selection] */
// "pair" renders RH + LH side-by-side; "mesh" shows 90-deg meshing check
render_mode = "pair"; // ["pair", "RH", "LH", "mesh"]

/* [Gear Parameters] */
module_val      = 1.25;   // Module 1.25 (25.0 mm outer pitch diameter)
teeth           = 20;     // Number of teeth (1:1 ratio = 45° pitch cone)
face_width      = 8.0;    // Tooth face width along pitch cone (mm)
spiral_angle    = 30;     // Spiral angle in degrees (25°–35° typical)
pressure_angle  = 20;     // Standard 20° pressure angle
backlash        = 0.12;   // Tooth circumferential clearance for FDM (mm)

/* [Hub & Bore Dimensions] */
bore_dia        = 6.0;    // Target shaft diameter (e.g., 6, 8, or 10 mm)
bore_clearance  = 0.15;   // Extra diameter clearance for 3D printed fit (mm)
hub_dia         = 20.0;   // Rear hub outer diameter (mm)
hub_height      = 8.5;    // Rear hub height below gear back (mm)
front_recess_d  = 14.5;   // Recessed front pocket diameter (mm)
front_recess_h  = 3.0;    // Depth of front pocket (mm)
set_screw_pilot = 2.6;    // 2.6 mm pilot hole for direct M3 tapping in PLA/PETG

/* [Mesh Resolution] */
cone_slices     = 16;     // Axial slices along tooth (14-20 for smooth spiral)
involute_steps  = 7;      // Points per tooth flank

// ============================================================================
// Derived Bevel Geometry (90° Shaft Angle, 1:1 Ratio)
// ============================================================================
pitch_angle     = 45;                               // atan(Z1/Z2) = 45° for 1:1
R_pitch_outer   = (module_val * teeth) / 2;         // 12.5 mm for 1.25M 20T
cone_dist_outer = R_pitch_outer / sin(pitch_angle); // ~17.678 mm
cone_dist_inner = cone_dist_outer - face_width;     // ~9.678 mm
apex_z_global   = hub_height + R_pitch_outer;       // 21.0 mm

// ============================================================================
// Render Output
// ============================================================================
if (render_mode == "RH") {
    spiral_bevel_gear(hand = 1);
} else if (render_mode == "LH") {
    spiral_bevel_gear(hand = -1);
} else if (render_mode == "pair") {
    translate([-R_pitch_outer - 3.5, 0, 0]) spiral_bevel_gear(hand = 1);
    translate([ R_pitch_outer + 3.5, 0, 0]) spiral_bevel_gear(hand = -1);
} else if (render_mode == "mesh") {
    // Meshing verification at 90° shaft intersection (shared apex at [0, 0, apex_z_global])
    spiral_bevel_gear(hand = 1);
    translate([0, apex_z_global, apex_z_global])
        rotate([90, 0, 0])
            rotate([0, 0, 180 / teeth]) // Half-tooth phase alignment
                spiral_bevel_gear(hand = -1);
}

// ============================================================================
// Main Assembly Module
// ============================================================================
module spiral_bevel_gear(hand = 1) {
    apex_z = apex_z_global;
    actual_bore = bore_dia + bore_clearance;

    difference() {
        union() {
            // 1. Rear cylindrical hub
            cylinder(d = hub_dia, h = hub_height + 0.5, $fn = 72);

            // 2. Spiral bevel gear crown (clipped cleanly at hub bottom plane)
            intersection() {
                bevel_crown_polyhedron(hand = hand, apex_z = apex_z);
                cylinder(r = R_pitch_outer + 2 * module_val, h = apex_z, $fn = 96);
            }
        }

        // 3. Through shaft bore
        translate([0, 0, -1])
            cylinder(d = actual_bore, h = apex_z + 2, $fn = 64);

        // 4. Front recessed pocket
        translate([0, 0, hub_height + face_width * sin(pitch_angle) - front_recess_h])
            cylinder(d = front_recess_d, h = front_recess_h + 5, $fn = 64);

        // 5. Radial M3 set-screw pilot hole (2.6 mm for M3 tap)
        translate([0, 0, hub_height * 0.48])
            rotate([0, 90, 0])
                cylinder(d = set_screw_pilot, h = hub_dia, $fn = 32);
    }
}

// ============================================================================
// Spherical/Octoidal Spiral Bevel Crown Generator
// ============================================================================
module bevel_crown_polyhedron(hand = 1, apex_z = 21.0) {
    pts_per_tooth = 2 * involute_steps + 2;
    ring_pts = teeth * pts_per_tooth;

    all_points = [
        for (s = [0 : cone_slices])
            let (
                t = s / cone_slices,
                cd = cone_dist_outer - t * face_width,
                scale_f = cd / cone_dist_outer,
                m_local = module_val * scale_f,
                twist = hand * ((cone_dist_outer - cd) / R_pitch_outer) * tan(spiral_angle) * (180 / PI)
            )
            each spherical_tooth_ring(
                cd = cd,
                m_loc = m_local,
                twist = twist,
                apex_z = apex_z
            )
    ];

    side_faces = [
        for (s = [0 : cone_slices - 1])
            for (i = [0 : ring_pts - 1])
                let (
                    i_next = (i + 1) % ring_pts,
                    r0 = s * ring_pts,
                    r1 = (s + 1) * ring_pts
                )
                [r0 + i, r0 + i_next, r1 + i_next, r1 + i]
    ];

    outer_center_idx = len(all_points);
    inner_center_idx = len(all_points) + 1;

    outer_cap_z = apex_z - cone_dist_outer * cos(pitch_angle);
    inner_cap_z = apex_z - cone_dist_inner * cos(pitch_angle);

    final_points = concat(all_points, [
        [0, 0, outer_cap_z],
        [0, 0, inner_cap_z]
    ]);

    outer_cap_faces = [
        for (i = [0 : ring_pts - 1])
            let (i_next = (i + 1) % ring_pts)
            [outer_center_idx, i_next, i]
    ];

    last_ring_start = cone_slices * ring_pts;
    inner_cap_faces = [
        for (i = [0 : ring_pts - 1])
            let (i_next = (i + 1) % ring_pts)
            [inner_center_idx, last_ring_start + i, last_ring_start + i_next]
    ];

    polyhedron(
        points = final_points,
        faces = concat(side_faces, outer_cap_faces, inner_cap_faces),
        convexity = 10
    );
}

// ============================================================================
// Single Spherical Ring Profile (Mapped onto Cone Sphere of Radius = cd)
// ============================================================================
function spherical_tooth_ring(cd, m_loc, twist, apex_z) =
    let (
        z_v = teeth / cos(pitch_angle),
        r_p = (m_loc * z_v) / 2,
        r_b = r_p * cos(pressure_angle),
        addendum = 1.0 * m_loc,
        dedendum = 1.2 * m_loc,
        r_a = r_p + addendum,
        r_r = max(r_p - dedendum, r_b * 0.92),

        backlash_ang = (backlash / r_p) * (180 / PI),
        half_thick_ang = (90 / z_v) - (backlash_ang / 2),

        inv_p = tan(pressure_angle) * (180 / PI) - pressure_angle,
        base_half_ang = half_thick_ang + inv_p,

        t_max = sqrt(max(0, pow(r_a / r_b, 2) - 1)),
        t_min = sqrt(max(0, pow(r_r / r_b, 2) - 1))
    )
    [
        for (k = [0 : teeth - 1])
            let (tooth_center_ang = k * (360 / teeth) + twist)
            each concat(
                [map_to_sphere(cd, r_r - r_p, tooth_center_ang - (180 / teeth), apex_z)],
                [for (j = [0 : involute_steps - 1])
                    let (
                        u = t_min + (t_max - t_min) * (j / (involute_steps - 1)),
                        r_u = r_b * sqrt(1 + u * u),
                        inv_u = (u - atan(u) * PI / 180) * (180 / PI),
                        ang_offset = (base_half_ang - inv_u) / cos(pitch_angle)
                    )
                    map_to_sphere(cd, r_u - r_p, tooth_center_ang - ang_offset, apex_z)
                ],
                [for (j = [involute_steps - 1 : -1 : 0])
                    let (
                        u = t_min + (t_max - t_min) * (j / (involute_steps - 1)),
                        r_u = r_b * sqrt(1 + u * u),
                        inv_u = (u - atan(u) * PI / 180) * (180 / PI),
                        ang_offset = (base_half_ang - inv_u) / cos(pitch_angle)
                    )
                    map_to_sphere(cd, r_u - r_p, tooth_center_ang + ang_offset, apex_z)
                ],
                [map_to_sphere(cd, r_r - r_p, tooth_center_ang + (180 / teeth), apex_z)]
            )
    ];

function map_to_sphere(cd, dr, theta, apex_z) =
    let (
        d_cone_ang = (dr / cd) * (180 / PI),
        phi = pitch_angle + d_cone_ang,
        r_xy = cd * sin(phi),
        z_pos = apex_z - cd * cos(phi)
    )
    [r_xy * cos(theta), r_xy * sin(theta), z_pos];
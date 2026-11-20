// ============================================================================
// ИЗОЛИРАНИ СЛЪНЧЕВИ КОЛЕЛА (8.0 mm) + СТЪПАЛОВИДЕН ВАЛ
// (Телескопичен щифт и вътрешен отвор на тръбата на точно ф4.10 mm)
// ============================================================================

$fn = 90;

/* [Избор на изглед] */
// 0 = Съосно сглобени
// 1 = Всичко за 3D печат (2 вала + 2 колела едно до друго на Z=0)
// 2 = САМО слънчевите колела за печат (на Z=0)
// 3 = САМО стъпаловидните валове за печат (на Z=0)
view_mode = 2;

/* [Кинематика на СЛЪНЦАТА] */
m              = 1.0;
alpha          = 20;
beta           = 20;

z_sun          = 10;
x_sun          = 0.00;  
sun_total_w    = 8.00;  // Обща ширина 8.00 mm
center_gap     = 10.00; // Разстояние за телескопа
r_p_sun        = (m * z_sun) / 2;

/* [Параметри на ВАЛА] */
s1 = 5.65;
h1 = 10.0;
s2 = 4.24;
h2 = 17.0;
corner_clip = 0.35;

/* [Параметри на вътрешните отвори и телескопа] */
clearance      = 0.10;
s2_depth       = 2.00;  // Дълбочина на квадратния отвор в зъбното колело
spigot_d       = 4.25;  // Щифт на мъжкото слънце: ф4.10 mm
tube_id        = 4.10;  // Вътрешен диаметър на тръбата на женското слънце: ф4.10 mm
tube_od        = 7.2;
spigot_gap     = 0.2;

h3_straight    = 4.0; 
h3_pyramid     = 2.0; 
tip_z_play     = 0.10;
top_outer_r    = 2.00; 
top_corner_r   = 0.40; 
tip_outer_r    = 0.60; 
tip_corner_r   = 0.30;


// ============================================================================
// ГЛАВНО УПРАВЛЕНИЕ НА ИЗГЛЕДИТЕ
// ============================================================================
if (view_mode == 0) {
    color("Goldenrod")
        stepped_square_shaft();
    color("DarkOrange")
        translate([0, 0, h1 + h2 - s2_depth]) 
            sun_gear_male(hand = 1);
            
    top_z = (h1 + h2 - s2_depth) + sun_total_w + center_gap + sun_total_w; 
    
    color("Crimson")
        translate([0, 0, top_z]) 
        rotate([180, 0, 18]) 
            sun_gear_female(hand = -1);
            
    color("Gold")
        translate([0, 0, top_z + (h1 + h2 - s2_depth)]) 
        rotate([180, 0, 0])
            stepped_square_shaft();
} 
else if (view_mode == 1) {
    color("DarkOrange")
        translate([-12, 0, 0]) 
            sun_gear_male(hand = 1);
    color("Crimson")
        translate([12, 0, 0]) 
            sun_gear_female(hand = -1);
    color("Goldenrod")
        translate([-30, 0, 0]) 
            stepped_square_shaft();
    color("Gold")
        translate([30, 0, 0]) 
            stepped_square_shaft();
}
else if (view_mode == 2) {
    color("DarkOrange")
        translate([-8, 0, 0]) 
            sun_gear_male(hand = 1);
    color("Crimson")
        translate([8, 0, 0]) 
            sun_gear_female(hand = -1);
}
else if (view_mode == 3) {
    color("Goldenrod")
        translate([-10, 0, 0]) 
            stepped_square_shaft();
    color("Gold")
        translate([10, 0, 0]) 
            stepped_square_shaft();
}


// ============================================================================
// МОДУЛИ: СЛЪНЧЕВИ КОЛЕЛА С КВАДРАТНА ОСНОВА
// ============================================================================

module gear_internal_bore() {
    eps = 0.05;
    dogbone_square_hole(s2 + clearance, s2_depth + eps, 0.65);
    translate([0, 0, s2_depth - eps])
        tapered_top_section(is_hole = true);
}

module sun_gear_male(hand = 1) {
    twist_deg = hand * (sun_total_w * tan(beta) / r_p_sun) * (180 / PI);
    spigot_len = center_gap - spigot_gap;
    difference() {
        union() {
            linear_extrude(height = sun_total_w, twist = twist_deg, slices = 50, convexity = 10)
                gear_2d_profile(z_sun, x_sun, m);
            // Щифт с диаметър spigot_d = 4.10 mm
            translate([0, 0, sun_total_w - 0.01]) 
                cylinder(d = spigot_d, h = spigot_len - 0.4 + 0.01);
            translate([0, 0, sun_total_w + spigot_len - 0.4 - 0.01]) 
                cylinder(d1 = spigot_d, d2 = spigot_d - 0.8, h = 0.4 + 0.01);
        }
        gear_internal_bore();
    }
}

module sun_gear_female(hand = -1) {
    twist_deg = hand * (sun_total_w * tan(beta) / r_p_sun) * (180 / PI);
    rad_off = clearance / 2; 
    eps = 0.01;
    difference() {
        union() {
            linear_extrude(height = sun_total_w, twist = twist_deg, slices = 50, convexity = 10)
                gear_2d_profile(z_sun, x_sun, m);
            translate([0, 0, sun_total_w - 0.01]) 
                cylinder(d = tube_od, h = center_gap + 0.01);
        }
        union() {
            gear_internal_bore();
            
            hull() {
                translate([0, 0, s2_depth + h3_straight - eps]) 
                    linear_extrude(height = eps) rounded_polygon_2d(3, top_outer_r, top_corner_r, extra_offset = rad_off);
                translate([0, 0, sun_total_w - eps]) 
                    cylinder(d = tube_id, h = eps); // tube_id = 4.10 mm
            }
            translate([0, 0, sun_total_w - eps]) 
                cylinder(d = tube_id, h = center_gap + 1);
            translate([0, 0, sun_total_w + center_gap - 0.4]) 
                cylinder(d1 = tube_id, d2 = tube_id + 0.6, h = 0.41);
        }
    }
}


// ============================================================================
// МОДУЛИ: СТЪПАЛОВИДЕН ВАЛ И ОТВОРИ
// ============================================================================

module dogbone_square_hole(s, h, db_d = 0.65) {
    offset_pos = s / 2 - db_d / (2 * sqrt(2));
    translate([0, 0, -0.5])
    linear_extrude(height = h + 0.51)
    union() {
        square([s, s], center = true);
        for (dx = [-1, 1], dy = [-1, 1])
            translate([dx * offset_pos, dy * offset_pos]) circle(d = db_d, $fn = 24);
    }
}

module chamfered_box(s, h, clip = 0.35) {
    diag_limit = s * sqrt(2) - 2 * clip;
    linear_extrude(height = h)
    intersection() {
        square([s, s], center = true);
        rotate([0, 0, 45]) square([diag_limit, diag_limit], center = true);
    }
}

module stepped_square_shaft() {
    union() {
        chamfered_box(s1, h1, corner_clip);
        translate([0, 0, h1 - 0.01]) 
            chamfered_box(s2, h2 + 0.01, corner_clip);
        translate([0, 0, h1 + h2]) 
            tapered_top_section(is_hole = false);
    }
}


// ============================================================================
// ПОМОЩНИ МОДУЛИ: ЕВОЛВЕНТА И ТРИЪГЪЛЕН ПРОФИЛ
// ============================================================================

module gear_2d_profile(z, x, mod_val) {
    r_p = (mod_val * z) / 2;
    r_b = r_p * cos(alpha);
    r_a = r_p + mod_val * (1 + x);
    r_d = max(r_p - mod_val * (1.25 - x), 0.5);
    union() {
        circle(r = r_d + 0.05, $fn = z * 6);
        for (i = [0 : z - 1]) {
            rotate([0, 0, i * 360 / z])
                single_tooth_2d(z, x, r_p, r_b, r_a, r_d);
        }
    }
}

module single_tooth_2d(z, x, r_p, r_b, r_a, r_d) {
    steps = 20;
    t_max = sqrt(pow(r_a / r_b, 2) - 1);
    t_min = (r_d > r_b) ? sqrt(pow(r_d / r_b, 2) - 1) : 0;
    t_p = sqrt(pow(r_p / r_b, 2) - 1);
    inv_p = (t_p * 180 / PI) - atan(t_p);
    s_angle = (180 / z) + (360 * x * tan(alpha) / (PI * z));
    offset = (s_angle / 2) + inv_p;

    inv_points = [
        for (i = [0 : steps])
            let (t = t_min + i * (t_max - t_min) / steps)
            let (r = r_b * sqrt(1 + t * t))
            let (theta = (t * 180 / PI) - atan(t))
            [r * cos(offset - theta), r * sin(offset - theta)]
    ];
    mirror_points = [
        for (i = [steps : -1 : 0])
            [inv_points[i][0], -inv_points[i][1]]
    ];
    polygon(concat([[0, 0]], inv_points, mirror_points));
}

module rounded_polygon_2d(n_sides, outer_r, corner_r, extra_offset = 0) {
    R_centers = max(0.05, outer_r - corner_r);
    eff_r = corner_r + extra_offset;
    rotate([0, 0, 90])
    hull() {
        for (i = [0 : n_sides - 1])
            rotate([0, 0, i * 360 / n_sides]) translate([R_centers, 0]) circle(r = eff_r, $fn = 36);
    }
}

module tapered_top_section(is_hole = false) {
    rad_off = is_hole ? (clearance / 2) : 0;
    z_bottom_ext = is_hole ? 0.5 : 0.01;
    pyr_h = is_hole ? h3_pyramid : (h3_pyramid - tip_z_play);
    eps = 0.01;
    union() {
        translate([0, 0, -z_bottom_ext])
        linear_extrude(height = h3_straight + z_bottom_ext)
            rounded_polygon_2d(3, top_outer_r, top_corner_r, extra_offset = rad_off);
        hull() {
            translate([0, 0, h3_straight - eps])
            linear_extrude(height = eps) rounded_polygon_2d(3, top_outer_r, top_corner_r, extra_offset = rad_off);
            translate([0, 0, h3_straight + pyr_h - eps])
            linear_extrude(height = eps) rounded_polygon_2d(3, top_outer_r, top_corner_r, extra_offset = rad_off);
        }
    }
}
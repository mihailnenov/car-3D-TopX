// ============================================================================
// ИЗОЛИРАНИ СЛЪНЧЕВИ КОЛЕЛА (8.0 mm) + СТЪПАЛОВИДЕН ВАЛ
// (Телескопичен щифт и вътрешен отвор на тръбата на точно ф4.10 mm)
//
// Кинематиката (m, Z, x, ъгли) идва от "Flanges + Planet Gears.scad", а валът,
// квадратният и триъгълният отвор - от "Square shaft small.scad", за да няма
// разминаване между детайлите.
// ============================================================================

use <Flanges + Planet Gears.scad>
use <Square shaft small.scad>

$fn = 90;

/* [Избор на изглед] */
// 0 = Съосно сглобени
// 1 = Всичко за 3D печат (2 вала + 2 колела едно до друго на Z=0)
// 2 = САМО слънчевите колела за печат (на Z=0)
// 3 = САМО стъпаловидните валове за печат (на Z=0)
view_mode = 2;

/* [Кинематика на СЛЪНЦАТА (от "Flanges + Planet Gears.scad")] */
m              = carrier_param("m");      // 0.85
beta           = carrier_param("beta");

z_sun          = carrier_param("z_sun");  // 12
x_sun          = carrier_param("x_sun");  // +0.25 -> a_sp = 10.561 mm
sun_total_w    = 8.00;  // Обща ширина 8.00 mm
center_gap     = 10.00; // Разстояние за телескопа
r_p_sun        = (m * z_sun) / 2;

/* [Параметри на ВАЛА (от "Square shaft small.scad")] */
h1 = shaft_param("h1");
s2 = shaft_param("s2");
h2 = shaft_param("h2");

/* [Параметри на вътрешните отвори и телескопа] */
clearance      = shaft_param("clearance");
s2_depth       = 2.00;  // Дълбочина на квадратния отвор в зъбното колело
spigot_d       = 4.00;  // Щифт на мъжкото слънце: ф4.00 mm (0.10 mm хлабина в тръбата ф4.10)
tube_id        = 4.10;  // Вътрешен диаметър на тръбата на женското слънце: ф4.10 mm
tube_od        = 7.2;
spigot_gap     = 0.2;

h3_straight    = shaft_param("h3_straight"); // Права част на триъгълния отвор (4.0 mm)

// Достъп до размерите от други файлове
function sun_param(key) =
    let (t = [
        ["sun_total_w", sun_total_w], ["center_gap", center_gap], ["s2_depth", s2_depth]
    ], i = search([key], t)[0])
    assert(is_num(i), str("sun_param: непознат ключ ", key))
    t[i][1];


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
        rotate([180, 0, 180 / z_sun]) 
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
    translate([0, 0, s2_depth])
        tapered_top_section(is_hole = true);
}

module sun_gear_male(hand = 1) {
    twist_deg = hand * (sun_total_w * tan(beta) / r_p_sun) * (180 / PI);
    spigot_len = center_gap - spigot_gap;
    difference() {
        union() {
            linear_extrude(height = sun_total_w, twist = twist_deg, slices = 50, convexity = 10)
                gear_2d_profile(z_sun, x_sun, m);
            // Щифт с диаметър spigot_d = 4.00 mm
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
                    linear_extrude(height = eps) shaft_top_profile_2d(is_hole = true);
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

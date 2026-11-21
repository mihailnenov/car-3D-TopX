// ============================================================================
// ПЪЛНА СГЛОБКА: СПИРАЛЕН ДИФЕРЕНЦИАЛ (TORSEN СТИЛ) + ЗАДВИЖВАЩ ПИНЬОН
//
// Този файл НЕ съдържа собствена геометрия на детайлите – той ВНАСЯ модулите
// директно от детайлните файлове (чрез use <...>), за да остава винаги
// синхронизиран с тях:
//
//   - Flanges + Planet Gears.scad           -> фланци Z=27, отделни оси, сателити Z=10, лагери 6700
//   - Sun Gears -Square + Triangel Holes.scad -> мъжко / женско слънце (8 mm, квадрат + триъгълник)
//   - Square shaft small.scad                -> стъпаловиден вал + обърната втулка за лагерите
//   - Defential Stand Bottom.scad            -> П-образна стойка (по избор)
//
// Тук остават само: разположението на детайлите в сглобката и пиньонът.
// ============================================================================

use <Flanges + Planet Gears.scad>
use <Sun Gears -Square + Triangel Holes.scad>
use <Square shaft small.scad>
use <Defential Stand Bottom.scad>

$fn = 90;

/* [Избор на изглед / Експорт] */
// 0  = Пълна кинематична сглобка
// 1  = 1/2 надлъжен разрез на целия механизъм
// 2  = Разглобен изглед (Exploded View)
// 3  = Шевронен фланец Z=27 - за печат (2 броя)
// 4  = Отделна сателитна ос 40.0 mm - за печат (6 броя)
// 5  = Сателит Z=10 LH - за печат (3 броя)
// 6  = Сателит Z=10 RH - за печат (3 броя)
// 7  = ЛЯВО слънце (ЖЕНСКО, LH) - за печат (1 брой)
// 8  = Стъпаловиден вал - за печат (2 броя)
// 9  = ДЯСНО слънце (МЪЖКО, RH) - за печат (1 брой)
// 10 = Задвижващ ШЕВРОНЕН ПИНЬОН Z=12 - за печат (1 брой)
// 11 = Втулка за лагерите - за печат (2 броя)
// 12 = П-образна стойка - за печат (1 брой)
// 13 = Шевронно колело Z=10 за полуоската (крайна предавка) - за печат (2 броя)
// 14 = Шевронно колело Z=14 за вала на колелото - за печат (2 броя)
view_mode = 0;

show_ground  = true;  // true = показва земята (полупрозрачна равнина)

show_stand   = false; // true = показва и стойката в изгледи 0/1/2
explode_dist = 28.0;  // ТРЯБВА да съвпада с explode_dist във "Flanges + Planet Gears.scad"


// ============================================================================
// РАЗМЕРИ ЗА РАЗПОЛОЖЕНИЕ (копие от детайлните файлове - само за позициониране!)
// ============================================================================

// От "Flanges + Planet Gears.scad"
flange_thick   = 6.0;   // Дебелина на фланеца
carrier_gap    = 28.0;  // Вътрешно разстояние между фланците
ring_m         = 1.2;   // Модул на външния шевронен венец
ring_z         = 27;    // Зъби на фланеца (OD = 34.80 mm)
ring_x         = 0.00;
ring_beta      = 20;

// От "Sun Gears -Square + Triangel Holes.scad"
z_sun          = 10;
sun_total_w    = 8.0;   // Ширина на слънцето
center_gap     = 10.0;  // Разстояние между двете слънца (телескоп)
s2_depth       = 2.0;   // Дълбочина на квадратния отвор в слънцето

// От "Square shaft small.scad"
h1             = 10.0;  // Квадрат 5.65 mm
h2             = 17.0;  // Квадрат 4.24 mm
sleeve_total_h = 15.0;  // Обща дължина на втулката

// Изчислено разположение (локални координати: Z = 0 е вътрешното лице на фланеца)
side_gap   = (carrier_gap - (2 * sun_total_w + center_gap)) / 2; // 1.0 mm между фланеца и слънцето
shaft_z0   = side_gap - (h1 + h2 - s2_depth);                    // -24.0 mm (начало на вала)

/* [Задвижващ ШЕВРОНЕН ПИНЬОН (зацепен за левия фланец)] */
pinion_z        = 12;
pinion_x        = 0.00;
pinion_w        = 6.0;
pinion_hub_d    = 11.0;
pinion_hub_h    = 5.0;
pinion_bore_d   = 5.05;
pinion_flat_t   = 4.05;

// Междуосово разстояние пиньон - фланец Z=27 (23.45 mm)
a_drive = ring_m * ((ring_z + pinion_z) / 2 + (ring_x + pinion_x) * 0.85) + 0.05;

/* [КРАЙНА ПРЕДАВКА: полуоска -> вал на колелото (шевронни, m = 1.2)] */
fd_m          = 1.2;
fd_z_drive    = 10;    // Шевронно колело Z=10 на квадрата 5.65 mm на полуоската
fd_x_drive    = 0.25;  // +0.25 корекция срещу подрязване на зъбите при Z=10
fd_z_wheel    = 14;    // Шевронно колело Z=14 на вала на колелото
fd_x_wheel    = 0.00;
fd_beta       = 20;
fd_w          = 7.0;   // Ширина на зъбните колела (квадратът е 10 mm, 1.9 mm заема прагът на стойката)
s1            = 5.65;  // Квадрат на полуоската (от "Square shaft small.scad")
sq_clearance  = 0.10;
wheel_shaft_d = 5.0;   // Вал на колелото (D-профил)
wheel_shaft_t = 4.5;   // Плоска част на D-профила
wheel_d       = 43.0;  // Външен диаметър на гумата (от "Wheel  Drive Mechanism.scad")

// Междуосово разстояние на крайната предавка (14.655 mm)
a_final  = fd_m * ((fd_z_drive + fd_z_wheel) / 2 + (fd_x_drive + fd_x_wheel) * 0.85);

// ВИСОЧИНИ НАД ЗЕМЯТА (посоката "надолу" в сглобката е +X, валът на колелото е точно под полуоската)
ring_od       = ring_m * (ring_z + 2 + 2 * ring_x);   // 34.80 mm
wheel_axis_h  = wheel_d / 2;                          // 21.50 mm
diff_axis_h   = wheel_axis_h + a_final;               // 36.16 mm
ring_bottom_h = diff_axis_h - ring_od / 2;            // 18.76 mm (2.74 mm под оста на колелото)
fd_z0         = shaft_z0 + 0.5;                       // Външно чело на колелото Z=10 (локално Z = -23.5)

echo(str("Крайна предавка ", fd_z_wheel, "/", fd_z_drive, " = ", fd_z_wheel / fd_z_drive,
         " | Общо: ", (ring_z / pinion_z) * (fd_z_wheel / fd_z_drive), " : 1"));
echo(str("Ос на колелото: ", wheel_axis_h, " mm | Ос на диференциала: ", diff_axis_h,
         " mm | Долен ръб на венеца: ", ring_bottom_h, " mm над земята"));


// ============================================================================
// ГЛАВНО УПРАВЛЕНИЕ НА ИЗГЛЕДИТЕ
// ============================================================================

if      (view_mode == 0)  full_differential_assembly(cutaway = false, exploded = false);
else if (view_mode == 1)  full_differential_assembly(cutaway = true,  exploded = false);
else if (view_mode == 2)  full_differential_assembly(cutaway = false, exploded = true);
else if (view_mode == 3)  translate([0, 0, flange_thick]) carrier_flange();
else if (view_mode == 4)  cantilever_planet_pin();
else if (view_mode == 5)  planet_gear_short(hand = -1);
else if (view_mode == 6)  planet_gear_short(hand = 1);
else if (view_mode == 7)  sun_gear_female(hand = -1);
else if (view_mode == 8)  stepped_square_shaft();
else if (view_mode == 9)  sun_gear_male(hand = 1);
else if (view_mode == 10) drive_pinion();
else if (view_mode == 11) bearing_sleeve();
else if (view_mode == 12) diff_u_stand();
else if (view_mode == 13) final_drive_gear();
else if (view_mode == 14) wheel_gear();


// ============================================================================
// МОДУЛ: ЦЯЛОСТНА СГЛОБКА
// ============================================================================

module full_differential_assembly(cutaway = false, exploded = false) {
    difference() {
        union() {
            // 1. КАСЕТА: 2 фланеца + 6 оси + 6 сателита + 2 лагера 6700
            carrier_planets_assembly(cutaway = false, exploded = exploded);

            // 2. ЛЯВА ПОЛУОСКА: женско слънце (LH) – зацепва десните сателити (RH)
            half_axle(is_male = false, exploded = exploded);

            // 3. ДЯСНА ПОЛУОСКА: мъжко слънце (RH) – зацепва левите сателити (LH)
            translate([0, 0, carrier_gap])
            rotate([180, 0, 180 / z_sun])
                half_axle(is_male = true, exploded = exploded);

            // 4. ЗАДВИЖВАЩ ПИНЬОН (зацепен за левия фланец)
            color("Crimson")
            translate([-a_drive - (exploded ? explode_dist * 0.45 : 0), 0,
                       -flange_thick - (exploded ? explode_dist : 0)])
                drive_pinion();

            // 5. СТОЙКА (по избор) - оста на стойката (X) съвпада с оста на диференциала (Z)
            if (show_stand)
                translate([22.0, 0, carrier_gap / 2])
                rotate([0, -90, 0])
                    diff_u_stand();

            // 6. КРАЙНА ПРЕДАВКА Z=10 -> Z=14 от двете страни (валът на колелото е под полуоската)
            final_drive_side(exploded = exploded);

            translate([0, 0, carrier_gap])
            rotate([180, 0, 0])
                final_drive_side(exploded = exploded);

            // 7. ЗЕМЯ (на diff_axis_h под оста на диференциала)
            if (show_ground)
                color("DarkOliveGreen", 0.25)
                translate([diff_axis_h, -50, -60])
                    cube([0.5, 100, carrier_gap + 120]);
        }

        if (cutaway)
            translate([-80, 0, -100]) cube([160, 80, 230]);
    }
}

// Полуоска в локални координати (Z = 0 е вътрешното лице на фланеца, +Z към центъра)
module half_axle(is_male = true, exploded = false) {
    e_sun   = exploded ? explode_dist * 0.35 : 0;
    e_shaft = exploded ? explode_dist * 1.60 : 0;

    // А. Слънце (от Z = 1.0 до Z = 9.0, телескопът сочи към центъра)
    color(is_male ? "DarkOrange" : "DodgerBlue")
    translate([0, 0, side_gap - e_sun]) {
        if (is_male) sun_gear_male(hand = 1);
        else         sun_gear_female(hand = -1);
    }

    translate([0, 0, shaft_z0 - e_shaft]) {
        // Б. Стъпаловиден вал (локално от Z = -24 до Z = 9)
        color("Gold")
            stepped_square_shaft();

        // В. Обърната втулка (фланецът ф12 опира в слънцето)
        color("SteelBlue")
        translate([0, 0, h1 + sleeve_total_h])
        rotate([180, 0, 0])
            bearing_sleeve();

        // Г. Два лагера MR128 (8x12x3.5) върху шийката ф8.08 на втулката
        color("LightSlateGray", 0.65)
        for (dz = [0, 3.5])
            translate([0, 0, h1 + dz])
                bearing_ring(od = 12.0, id = 8.0, w = 3.45);
    }
}


// ============================================================================
// КРАЙНА ПРЕДАВКА (полуоска Z=10 -> вал на колелото Z=14, m = 1.2)
// ============================================================================

// Една страна в локални координати (като half_axle, но БЕЗ завъртане около оста,
// за да остане валът на колелото винаги точно отдолу, в посока +X)
module final_drive_side(exploded = false) {
    e_shaft = exploded ? explode_dist * 1.60 : 0;
    e_wheel = exploded ? explode_dist * 0.60 : 0;

    // А. Z=10 на квадрата 5.65 mm на полуоската (локално Z = -23.5 .. -16.5)
    color("MediumSeaGreen")
    translate([0, 0, fd_z0 - e_shaft])
        final_drive_gear();

    // Б. Z=14 на вала на колелото + самият вал (полупрозрачен)
    translate([a_final + e_wheel, 0, fd_z0 - e_shaft]) {
        color("Orchid")
        rotate([0, 0, 180 / fd_z_wheel])
            wheel_gear();

        color("Silver", 0.5)
        translate([0, 0, -20])
            cylinder(d = wheel_shaft_d, h = 20 + fd_w + 0.5);
    }
}

// Z=10 с квадратен отвор 5.75 mm (dogbone ъгли) за полуоската
module final_drive_gear() {
    difference() {
        herringbone_gear_3d(z = fd_z_drive, m_val = fd_m, w = fd_w,
                            beta_val = fd_beta, x_val = fd_x_drive, hand = 1);
        dogbone_square_hole(s1 + sq_clearance, fd_w + 1, 0.65);
    }
}

// Z=14 с D-отвор за вала на колелото
module wheel_gear() {
    difference() {
        herringbone_gear_3d(z = fd_z_wheel, m_val = fd_m, w = fd_w,
                            beta_val = fd_beta, x_val = fd_x_wheel, hand = -1);
        translate([0, 0, -0.5])
            linear_extrude(height = fd_w + 1)
                d_shape_2d(d = wheel_shaft_d + sq_clearance, flat_t = wheel_shaft_t + sq_clearance);
    }
}


// ============================================================================
// ЗАДВИЖВАЩ ШЕВРОНЕН ПИНЬОН
// ============================================================================

module drive_pinion() {
    total_h = pinion_w + pinion_hub_h;

    difference() {
        union() {
            herringbone_gear_3d(z = pinion_z, m_val = ring_m, w = pinion_w,
                                beta_val = ring_beta, x_val = pinion_x, hand = -1);

            if (pinion_hub_h > 0)
                translate([0, 0, pinion_w - 0.05])
                    cylinder(d = pinion_hub_d, h = pinion_hub_h + 0.05);
        }

        translate([0, 0, -0.5])
            linear_extrude(height = total_h + 1.0)
                d_shape_2d(d = pinion_bore_d, flat_t = pinion_flat_t);

        if (pinion_hub_h >= 3.5)
            translate([0, 0, pinion_w + pinion_hub_h / 2])
            rotate([-90, 0, 0])
                cylinder(d = 2.7, h = pinion_hub_d);
    }
}

module d_shape_2d(d, flat_t) {
    intersection() {
        circle(d = d);
        translate([-d / 2, -d / 2])
            square([d, flat_t]);
    }
}

// ============================================================================
// ПЪЛНА СГЛОБКА: СПИРАЛЕН ДИФЕРЕНЦИАЛ (TORSEN СТИЛ) + ЗАДВИЖВАЩ ПИНЬОН
//
// Този файл НЕ съдържа собствена геометрия на детайлите – той ВНАСЯ модулите
// директно от детайлните файлове (чрез use <...>), за да остава винаги
// синхронизиран с тях:
//
//   - Flanges + Planet Gears.scad           -> фланци Z=27, отделни оси, сателити Z=12, лагери 6700
//   - Sun Gears -Square + Triangel Holes.scad -> мъжко / женско слънце (8 mm, квадрат + триъгълник)
//   - Square shaft small.scad                -> стъпаловиден вал + обърната втулка за лагерите
//   - Defential Stand Bottom.scad            -> П-образна стойка с удължение (шаси) + скоби + лагерни стойки MR128
//   - ../wheel-and-transmission/...          -> шенкел, полуоска-кучешка кост + колело Z=14 + MR128, главина, джанта
//
// Тук остават само: разположението на детайлите в сглобката, пиньонът и колелото Z=10.
// ============================================================================

use <Flanges + Planet Gears.scad>
use <Sun Gears -Square + Triangel Holes.scad>
use <Square shaft small.scad>
use <Defential Stand Bottom.scad>
use <../wheel-and-transmission/Shenkel.scad>
use <../wheel-and-transmission/Single Dogbone Shaft.scad>
use <../wheel-and-transmission/Wheel Axle with Integrated Drive Cup.scad>
use <../wheel-and-transmission/Wheel Drum.scad>

$fn = 90;

/* [Избор на изглед / Експорт] */
// 0  = Пълна кинематична сглобка
// 1  = 1/2 надлъжен разрез на целия механизъм
// 2  = Разглобен изглед (Exploded View)
// 3  = Шевронен фланец Z=27 - за печат (2 броя)
// 4  = Отделна сателитна ос 39.0 mm - за печат (6 броя)
// 5  = Сателит Z=12 LH - за печат (3 броя)
// 6  = Сателит Z=12 RH - за печат (3 броя)
// 7  = ЛЯВО слънце (ЖЕНСКО, LH) - за печат (1 брой)
// 8  = Стъпаловиден вал - за печат (2 броя)
// 9  = ДЯСНО слънце (МЪЖКО, RH) - за печат (1 брой)
// 10 = Задвижващ ШЕВРОНЕН ПИНЬОН Z=12 - за печат (1 брой)
// 11 = Втулка за лагерите - за печат (2 броя)
// 12 = П-образна стойка с удължение до шенкелите - за печат (1 брой)
// 13 = Шевронно колело Z=10 за полуоската (крайна предавка) - за печат (2 броя)
// 14 = Шевронно колело Z=14 с главина за MR128 (на полуоската-кучешка кост) - за печат (2 броя)
// 15 = Скоба на горната панта L - за печат (1 брой)
// 16 = Скоба на горната панта R (огледална) - за печат (1 брой)
// 17 = Отделна лагерна стойка за MR128 на колелото Z=14 - за печат (2 еднакви броя)
// 18 = Отделна голяма лагерна стойка 2x MR128 на диференциала - за печат (2 еднакви броя)
// 19 = Полукапак (скоба) за 2x MR128 на диференциала - за печат (2 еднакви броя)
view_mode = 0;

show_ground  = true;  // true = показва земята (полупрозрачна равнина)

show_stand   = true; // true = показва и стойката (със скобите) в изгледи 0/1/2
show_wheels  = true; // true = показва шенкелите, полуоските-кучешки кости, главините и колелата
steer_deg    = 0;    // Ъгъл на завиване на колелата (около осите на пантите)


// ============================================================================
// РАЗМЕРИ ЗА РАЗПОЛОЖЕНИЕ (четат се от детайлните файловете чрез *_param() функции)
// ============================================================================

// От "Flanges + Planet Gears.scad"
flange_thick   = carrier_param("flange_thick"); // 6.0  Дебелина на фланеца
carrier_gap    = carrier_param("carrier_gap");  // 28.0 Вътрешно разстояние между фланците
explode_dist   = carrier_param("explode_dist"); // 28.0
ring_m         = carrier_param("ring_m");       // 1.2  Модул на външния шевронен венец
ring_z         = carrier_param("ring_z");       // 27   Зъби на фланеца (OD = 34.80 mm)
ring_x         = carrier_param("ring_x");
ring_beta      = carrier_param("ring_beta");

// От "Sun Gears -Square + Triangel Holes.scad"
z_sun          = carrier_param("z_sun");        // 12
sun_total_w    = sun_param("sun_total_w");      // 8.0  Ширина на слънцето
center_gap     = sun_param("center_gap");       // 10.0 Разстояние между двете слънца (телескоп)
s2_depth       = sun_param("s2_depth");         // 2.0  Дълбочина на квадратния отвор в слънцето

// От "Square shaft small.scad"
h1             = shaft_param("h1");             // 10.0 Квадрат 5.65 mm
h2             = shaft_param("h2");             // 17.0 Квадрат 4.24 mm
sleeve_total_h = shaft_param("sleeve_total_h"); // 15.0 Обща дължина на втулката

// Изчислено разположение (локални координати: Z = 0 е вътрешното лице на фланеца)
side_gap   = (carrier_gap - (2 * sun_total_w + center_gap)) / 2; // 1.0 mm между фланеца и слънцето
shaft_z0   = side_gap - (h1 + h2 - s2_depth);                    // -24.0 mm (начало на вала)

// Фазиране на слънцата: женското (ляво) зацепва десните сателити, мъжкото (дясно) - левите
tooth_pitch    = carrier_param("tooth_pitch");
helix_rate     = carrier_param("helix_rate");
pin_step_h     = carrier_param("pin_step_h");
sun_f_phase    = wrap_angle(tooth_pitch / 2 + 240 + carrier_param("planet_phase_R")
                            - helix_rate * (carrier_gap - pin_step_h - side_gap), tooth_pitch);
sun_m_phase    = wrap_angle(tooth_pitch / 2 + 180 - carrier_param("planet_phase_L")
                            - helix_rate * (carrier_gap - side_gap - pin_step_h), tooth_pitch);

/* [Задвижващ ШЕВРОНЕН ПИНЬОН (зацепен за левия фланец)] */
pinion_z        = 12;
pinion_x        = 0.00;
pinion_w        = 6.0;
pinion_hub_d    = 11.0;
pinion_hub_h    = 5.0;
pinion_bore_d   = 5.05;
pinion_flat_t   = 4.05;
pinion_angle    = 90;    // Позиция около диференциала: 0° = отгоре, +90° = към скобите за шенкела (+Y), -90° = към кормилните рамена (-Y)

// Междуосово разстояние пиньон - фланец Z=27 (23.45 mm)
a_drive = ring_m * ((ring_z + pinion_z) / 2 + (ring_x + pinion_x) * 0.85) + 0.05;

/* [КРАЙНА ПРЕДАВКА: полуоска -> вал на колелото (шевронни, m = 1.2)] */
fd_m          = dogbone_param("fd_m");       // 1.2  (от "Single Dogbone Shaft.scad")
fd_z_drive    = 10;                          // Шевронно колело Z=10 на квадрата 5.65 mm на полуоската
fd_x_drive    = 0.25;                        // +0.25 корекция срещу подрязване на зъбите при Z=10
fd_z_wheel    = dogbone_param("fd_z_wheel"); // 14   Шевронно колело Z=14 (от "Single Dogbone Shaft.scad")
fd_x_wheel    = dogbone_param("fd_x_wheel"); // 0.00
fd_beta       = dogbone_param("fd_beta");    // 20
fd_w          = dogbone_param("fd_w");       // 7.0  Ширина на зъбните колела (от "Single Dogbone Shaft.scad")
s1            = shaft_param("s1");           // 5.65 Квадрат на полуоската
sq_clearance  = 0.10;
wheel_d       = 43.0;                        // Външен диаметър на гумата (от "Wheel  Drive Mechanism.scad")

/* [Колело Z=14 и лагер MR128 на полуоската ("Single Dogbone Shaft.scad")] */
dogbone_len   = dogbone_param("half_len");      // 27.415 mm от центъра на сферата до правия край
wg_shoulder_h = dogbone_param("wg_shoulder_h"); // 1.0 mm
brg_mr128_w   = dogbone_param("brg_mr128_w");   // 3.5 mm

/* [Колело: главина с чашка + джанта ("Wheel Axle with Integrated Drive Cup.scad", "Wheel Drum.scad")] */
hub_kingpin_z   = hub_param("cup_len") / 2; // 4.0  Оста на пантата е в средата на 8-милиметровата секция
hub_face_z      = hub_param("face_z");      // 28.0 Чело на главината (опира в дъното на джантата)
drum_bottom_t   = 3.0;   // Дъно на джантата
drum_w          = 20.0;  // Ширина на джантата
drum_board_t    = 2.0;   // Бордове на джантата
drum_cone_h     = 0.8;   // Преходни конуси до бордовете (гумата е между тях)
drum_bed_d      = 27.0;  // Легло на гумата

// Междуосово разстояние на крайната предавка (14.655 mm)
a_final  = fd_m * ((fd_z_drive + fd_z_wheel) / 2 + (fd_x_drive + fd_x_wheel) * 0.85);

// ВИСОЧИНИ НАД ЗЕМЯТА (посоката "надолу" в сглобката е +X, валът на колелото е точно под полуоската)
ring_od       = ring_m * (ring_z + 2 + 2 * ring_x);   // 34.80 mm
wheel_axis_h  = wheel_d / 2;                          // 21.50 mm
diff_axis_h   = wheel_axis_h + a_final;               // 36.16 mm
ring_bottom_h = diff_axis_h - ring_od / 2;            // 18.76 mm (2.74 mm под оста на колелото)
fd_z0         = shaft_z0 + 0.5;                       // Външно чело на колелото Z=10 (локално Z = -23.5)

// Ос на завиване (шенкел) = център на сферата на полуоската-кучешка кост, чийто прав край
// е наравно с вътрешното чело на колелото Z=14
kingpin_z     = fd_z0 + fd_w - dogbone_len;           // -43.915 (локално)
kingpin_d     = carrier_gap / 2 - kingpin_z;          // 57.915 mm от центъра

echo(str("Крайна предавка ", fd_z_wheel, "/", fd_z_drive, " = ", fd_z_wheel / fd_z_drive,
         " | Общо: ", (ring_z / pinion_z) * (fd_z_wheel / fd_z_drive), " : 1"));
echo(str("Ос на колелото: ", wheel_axis_h, " mm | Ос на диференциала: ", diff_axis_h,
         " mm | Долен ръб на венеца: ", ring_bottom_h, " mm над земята"));
echo(str("Фази: женско слънце ", sun_f_phase, " deg | мъжко слънце ", sun_m_phase,
         " deg | десни сателити ", carrier_param("planet_phase_R"), " deg"));
if (abs(stand_param("wheel_axis_drop") - a_final) > 0.001)
    echo(str("ВНИМАНИЕ: wheel_axis_drop = ", stand_param("wheel_axis_drop"),
             " mm в \"Defential Stand Bottom.scad\" не съвпада с a_final = ", a_final, " mm!"));
echo(str("Стойка: горната повърхност на пода е ", stand_param("stand_center_z") - stand_param("stand_base_h") - a_final,
         " mm под оста на колелото | дъното е ", diff_axis_h - stand_param("stand_center_z"), " mm над земята"));
echo(str("Оси на завиване: ", kingpin_d, " mm от центъра (разстояние ", 2 * kingpin_d,
         " mm) | Следа (центрове на гумите): ", 2 * (kingpin_d + hub_face_z + drum_bottom_t - drum_w / 2 - hub_kingpin_z), " mm"));
if (abs(stand_param("kingpin_from_center") - kingpin_d) > 0.001)
    echo(str("ВНИМАНИЕ: kingpin_from_center = ", stand_param("kingpin_from_center"),
             " mm в \"Defential Stand Bottom.scad\" не съвпада с ", kingpin_d, " mm!"));
if (abs(stand_param("wheel_gear_outer_d") - (carrier_gap / 2 - fd_z0)) > 0.001
    || abs(stand_param("wg_shoulder_h") - wg_shoulder_h) > 0.001)
    echo(str("ВНИМАНИЕ: wheel_gear_outer_d / wg_shoulder_h в \"Defential Stand Bottom.scad\" не съвпадат с ",
             carrier_gap / 2 - fd_z0, " / ", wg_shoulder_h, " mm!"));


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
else if (view_mode == 14) translate([0, 0, fd_w]) rotate([180, 0, 0]) wheel_gear(); // главината нагоре
else if (view_mode == 15) kingpin_bracket_print();
else if (view_mode == 16) mirror([1, 0, 0]) kingpin_bracket_print();
else if (view_mode == 17) wheel_bearing_block_print();
else if (view_mode == 18) diff_bearing_block_print();
else if (view_mode == 19) diff_bearing_cap_print();


// ============================================================================
// МОДУЛ: ЦЯЛОСТНА СГЛОБКА
// ============================================================================

// Вътрешно сглобката е построена с "надолу" = +X (виж бележката по-горе за
// ВИСОЧИНИ НАД ЗЕМЯТА). Тук цялата геометрия (без земята) се завърта така,
// че Z да стане вертикалната ос (Z+ = нагоре), а земята - хоризонтална плоча
// на Z = 0 (с дебелина 1 mm, dX = 250 mm, dY = 250 mm), върху която стъпват
// гумите: старото X = diff_axis_h (контактната точка на гумата със земята)
// се мапва точно на Z = 0.
module full_differential_assembly(cutaway = false, exploded = false) {
    union() {
        translate([0, 0, diff_axis_h])
        rotate([0, 90, 0])
            full_differential_assembly_local(cutaway = cutaway, exploded = exploded);

        // ЗЕМЯ: хоризонтална плоча на Z = 0, 250 x 250 mm, 1 mm дебелина
        if (show_ground)
            color("DarkOliveGreen", 0.25)
            translate([-125, -125, -1])
                cube([250, 250, 1]);
    }
}

// Локална геометрия на сглобката в старата координатна система
// (надолу = +X), преди глобалното завъртане към Z-нагоре по-горе.
module full_differential_assembly_local(cutaway = false, exploded = false) {
    difference() {
        union() {
            // 1. КАСЕТА: 2 фланеца + 6 оси + 6 сателита + 2 лагера 6700
            carrier_planets_assembly(cutaway = false, exploded = exploded);

            // 2. ЛЯВА ПОЛУОСКА: женско слънце (LH) – зацепва десните сателити (RH)
            rotate([0, 0, sun_f_phase])
                half_axle(is_male = false, exploded = exploded);

            // 3. ДЯСНА ПОЛУОСКА: мъжко слънце (RH) – зацепва левите сателити (LH)
            translate([0, 0, carrier_gap])
            rotate([180, 0, sun_m_phase])
                half_axle(is_male = true, exploded = exploded);

            // 4. ЗАДВИЖВАЩ ПИНЬОН (зацепен за левия фланец, завъртян на pinion_angle към скобите +Y)
            color("Crimson")
            rotate([0, 0, -pinion_angle])
            translate([-a_drive - (exploded ? explode_dist * 0.45 : 0), 0,
                       -flange_thick - (exploded ? explode_dist : 0)])
            rotate([0, 0, -pinion_angle * ring_z / pinion_z])
                drive_pinion();

            // 5. СТОЙКА (по избор) - оста на стойката (X) съвпада с оста на диференциала (Z),
            //    горната повърхност на пода е 12.0 mm под оста на колелото
            if (show_stand)
                translate([stand_param("stand_center_z"), 0, carrier_gap / 2])
                rotate([0, -90, 0]) {
                    diff_u_stand();
                    chassis_brackets();
                    translate([0, 0, exploded ? 14 : 0]) {
                        chassis_wheel_bearing_blocks();
                        chassis_diff_bearing_blocks();
                    }
                    translate([0, 0, exploded ? 28 : 0])
                        chassis_diff_bearing_caps();
                }

            // 6. КРАЙНА ПРЕДАВКА Z=10 -> Z=14 от двете страни (валът на колелото е под полуоската)
            //    Колелото Z=10 следва завъртането на квадрата на съответната полуоска.
            //    + полуоска-кучешка кост, главина с чашка и колело (завиват около пантата)
            final_drive_side(exploded = exploded, shaft_rot = sun_f_phase, steer = steer_deg);

            translate([0, 0, carrier_gap])
            rotate([180, 0, 0])
                final_drive_side(exploded = exploded, shaft_rot = -sun_m_phase, steer = steer_deg);

            // 7. ШЕНКЕЛИ (огледални спрямо центъра, кормилните рамена сочат в една и съща посока -Y)
            if (show_wheels) {
                steering_knuckle_side(exploded = exploded, steer = steer_deg);

                translate([0, 0, carrier_gap])
                mirror([0, 0, 1])
                    steering_knuckle_side(exploded = exploded, steer = -steer_deg);
            }

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
// за да остане валът на колелото винаги точно отдолу, в посока +X).
// shaft_rot = завъртане на квадрата на полуоската в тази координатна система.
// steer = ъгъл на завиване около оста на пантата (+X през центъра на сферата).
module final_drive_side(exploded = false, shaft_rot = 0, steer = 0) {
    e_shaft  = exploded ? explode_dist * 1.60 : 0;
    e_wheel  = exploded ? explode_dist * 0.60 : 0;
    e_corner = exploded ? explode_dist * 1.00 : 0;
    wheel_rot = 180 / fd_z_wheel - shaft_rot * fd_z_drive / fd_z_wheel;

    // А. Z=10 на квадрата 5.65 mm на полуоската (локално Z = -23.5 .. -16.5)
    color("MediumSeaGreen")
    translate([0, 0, fd_z0 - e_shaft])
    rotate([0, 0, shaft_rot])
        final_drive_gear();

    // Б. Z=14 с главина в MR128 (от "Single Dogbone Shaft.scad") + полуоската-кучешка кост
    translate([a_final + e_wheel, 0, fd_z0 - e_shaft])
    rotate([0, 0, wheel_rot]) {
        color("Orchid")
            wheel_gear();

        color("LightSlateGray", 0.65)
        translate([0, 0, -wg_shoulder_h - brg_mr128_w - e_corner * 0.3])
            wheel_gear_bearing();

        if (show_wheels)
            translate([0, 0, fd_w - dogbone_len - e_corner * 0.6])
                dogbone_in_gear_frame();
    }

    // В. Главина с чашка + джанта + гума (завиват около оста на пантата)
    //    Главината: z = 0..8 в двата лагера 6700 на шенкела (оста на пантата е при z = 4),
    //    z = 28 - челото (навън). Джантата: кухината ф23 сочи навътре и обхваща основата ф22;
    //    дъното й (3.5 mm) опира в челото, водачът ф5.8 влиза в отвора ф6, "pill" щифтовете - в каналите.
    if (show_wheels)
        translate([a_final + e_wheel, 0, kingpin_z - e_shaft - e_corner])
        rotate([steer, 0, 0])
        rotate([0, 0, wheel_rot])
        rotate([180, 0, 0])                                    // ос Z на главината -> -Z (навън)
        translate([0, 0, -hub_kingpin_z]) {
            exact_wheel_hub_conical();

            translate([0, 0, hub_face_z + drum_bottom_t])
            mirror([0, 0, 1]) {
                color("DimGray")
                    wheel_drum_symmetrical();

                color("DarkSlateGray", 0.45)
                translate([0, 0, drum_board_t + drum_cone_h])
                    difference() {
                        cylinder(d = wheel_d, h = drum_w - 2 * (drum_board_t + drum_cone_h));
                        translate([0, 0, -1])
                            cylinder(d = drum_bed_d + 0.1, h = drum_w);
                    }
            }
        }
}

// Полуоска-кучешка кост в координатите на колелото Z=14: оста й X -> +Z, Y -> X, Z (основата) -> Y.
// Сферата е в началото, правият край е наравно с вътрешното чело на колелото.
module dogbone_in_gear_frame() {
    multmatrix([[0, 1, 0, 0], [0, 0, 1, 0], [1, 0, 0, 0]])
        single_dogbone_shaft_printable();

    // Стоманен щифт ф1.5 x 9.5 mm в сферата (лежи в каналите на чашката)
    color("Crimson")
    rotate([90, 0, 0])
        cylinder(d = 1.5, h = 9.5, center = true);
}

// Шенкел + 2 лагера 6700 + щифт и винт на пантата (локални координати като final_drive_side)
module steering_knuckle_side(exploded = false, steer = 0) {
    e_shaft  = exploded ? explode_dist * 1.60 : 0;
    e_corner = exploded ? explode_dist * 1.00 : 0;
    e_wheel  = exploded ? explode_dist * 0.60 : 0;

    translate([a_final + e_wheel, 0, kingpin_z - e_shaft - e_corner])
    rotate([steer, 0, 0]) {
        // Шенкел: ос на лагерите -> Z, панта -> X (вертикално), рамо -> -Y
        rotate([0, 0, -90])
        translate([0, 0, -4])
            steering_block_printable();

        color("Silver")
        for (z0 = [-4, 0])
            translate([0, 0, z0])
                bearing_ring(od = 15.0, id = 10.0, w = 4.0);
    }

    // Панта (+X = надолу):
    //   долу  - стоманен щифт ф3 x 6, набит в глух отвор в пода (нищо не излиза под пода) -> 3.4 mm в ухото
    //   горе  - винт M3x8 отгоре през рамото на скобата (4 mm резба) -> 3.7 mm в ухото
    fb = stand_param("floor_below_wheel_axis");
    pin_bottom  = fb + stand_param("kp_pin_depth");  // 14.6 mm под оста (дъното на глухия отвор)
    arm_top     = fb + 0.3 + 4.0;                    // 16.3 mm над оста на колелото
    if (show_stand)
        color("DimGray")
        translate([a_final, 0, kingpin_z])
        rotate([0, 90, 0]) {
            translate([0, 0, pin_bottom - stand_param("kp_pin_len")])
                cylinder(d = stand_param("kp_pin_d"), h = stand_param("kp_pin_len"));
            translate([0, 0, -arm_top])          cylinder(d = 3.0, h = 8.0);
            translate([0, 0, -arm_top - 3.0])    cylinder(d = 5.5, h = 3.0);
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

// (Колелото Z=14 wheel_gear() и лагерът wheel_gear_bearing() се внасят директно от
//  "../wheel-and-transmission/Single Dogbone Shaft.scad")


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

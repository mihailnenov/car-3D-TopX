// ============================================================================
// ПЪЛЕН КИНЕМАТИЧЕН МОДЕЛ: СПИРАЛЕН ДИФЕРЕНЦИАЛ (TORSEN СТИЛ)
// Одитиран за нулев луфт, 0.2mm натяг на D-сглобките и 0.1mm плъзгане.
// ============================================================================

$fn = 90;

/* [Избор на изглед / Експорт] */
// 0 = Пълна кинематична сглобка (прозрачен корпус за преглед на зацепването)
// 1 = 1/2 надлъжен разрез на целия механизъм (инспекция на сглобките и натезите)
// 2 = Разглобен изглед на целия възел (Exploded View по съосност)
// 3 = Фланец за печат (принтират се 2 идентични броя)
// 4 = Вертикален сателитен вал за печат (принтират се 6 броя)
// 5 = Сателитно колело Z=10 LH за печат (принтират се 3 броя)
// 6 = Сателитно колело Z=10 RH за печат (принтират се 3 броя)
// 7 = Слънчево колело Z=15 за печат (принтират се 2 броя)
// 8 = Централен стъпаловиден вал за полуоската (вертикален за печат)
// 9 = Къса центроваща ос между двете слънца
view_mode = 5;

/* [Височина на разглобяване за Exploded View] */
explode_dist    = 35.0;

/* [Кинематика на зъбите - Модул 1.2] */
m               = 1.2;
alpha           = 20;
beta            = 20;

// Слънчеви колела (Z=15)
z_sun           = 15;
x_sun           = 0.2;
sun_total_w     = 12.0;
sun_toothed_w   = 8.0;
sun_collar_od   = 15.5;

// Сателитни колела (Z=10)
z_planet        = 10;
x_planet        = 0.4;
planet_gear_len = 22.0;
planet_neck_len = 2.0;
planet_neck_od  = 9.0;
planet_total_len= planet_gear_len + planet_neck_len; // 24.0 mm
bore_journal    = 6.00; // Точен отвор 6.00mm за плъзгане

/* [Междуосово разстояние и разположение] */
r_p_sun         = (m * z_sun) / 2;
r_p_planet      = (m * z_planet) / 2;
a_sp            = r_p_sun + r_p_planet + m * (x_sun + x_planet) * 0.85; // 15.61 mm
pair_angle      = 48.68;

/* [Фланци и лагери 10x15x4 mm] */
flange_thick    = 6.0;
flange_od       = 43.0;

// Лагерно гнездо във фланеца: 14.88mm (затягане 0.12mm за 15mm стоманен лагер)
flange_seat_d   = 14.88;
seat_depth      = 4.2;
lip_thick       = flange_thick - seat_depth; // 1.8 mm
pass_hole_d     = 11.4; // Отвор през борда (без допир във вала)

neck_gap        = 2.0;
center_gap      = 2.0;
carrier_gap     = neck_gap + sun_total_w + center_gap + sun_total_w + neck_gap; // 30.0 mm

/* [Сателитни оси - 42.0 mm общо] */
pin_base_depth  = 6.0;
// Стъпалото е 5.85mm, осигурявайки 30.0 - 5.85 = 24.15mm просвет за 24.0mm сателит (0.15mm луфт)
pin_step_h      = 5.85;
pin_base_d      = 9.00;
pin_flat_t      = 7.50;

// Плъзгаща шийка: 5.90mm срещу 6.00mm отвор -> точно 0.10mm хлабина!
pin_journal_d   = 5.90;
pin_journal_len = planet_total_len + 0.25; // 24.25 mm

// Връх към насрещния фланец (затяга стегнато)
pin_tip_d       = 6.00;
pin_tip_len     = 6.00;

/* [Гнезда във фланеца със затягане] */
// D-гнездо: 8.80mm / 7.30mm (затягане 0.20mm спрямо 9.00 / 7.50mm ос)
flange_d_hole_d = 8.80;
flange_d_hole_t = 7.30;
// Кръгъл насрещен отвор: 5.84mm (затягане 0.16mm спрямо 6.00mm връх)
flange_tip_hole = 5.84;

/* [Централен стъпаловиден вал за полуоската] */
sun_d_shaft_d   = 8.00;  // D-накрайник към слънцето
sun_d_shaft_flat= 6.50;
sun_d_shaft_len = 8.00;

c_collar_d      = 11.60; // Подпира САМО вътрешната гривна на 10x15x4
c_collar_w      = neck_gap;

c_sec1_d        = 10.20; // Затягане (+0.20mm) в 10mm лагер на фланеца
c_sec1_len      = 4.00;

c_trans1_len    = 1.00;  // Конус към 9mm
c_sec2_d        = 9.00;
c_sec2_len      = 4.00;

c_sec3_d        = 8.16;  // Затягане (+0.16mm) в лагер H8 D12x3.5
c_sec3_len      = 4.00;

c_trans2_len    = 1.50;  // Конус към 6mm
c_sec5_d        = 6.00;  // D-вал за зъбно колело
c_sec5_flat_t   = 4.80;
c_sec5_len      = 8.00;

/* [Лагери MR128 и центроващ щифт между слънцата] */
brg_sun_od      = 12.00;
brg_sun_id      = 8.00;
brg_sun_w       = 3.50;
// Гнездо в слънцето: 11.88mm (затягане 0.12mm за 12mm лагер)
sun_brg_seat_d  = 11.88;

// Щифт между слънцата: 8.16mm шийки (затягане 0.16mm в 8mm лагери)
pin_mid_d       = 8.16;
pin_mid_len     = 3.40;
collar_mid_d    = 9.80;  // Подпира вътрешните гривни
collar_mid_w    = center_gap;

// ============================================================================
// ГЛАВНО УПРАВЛЕНИЕ НА ИЗГЛЕДИТЕ
// ============================================================================

if (view_mode == 0) {
    full_differential_assembly(cutaway = false, exploded = false);
}
else if (view_mode == 1) {
    full_differential_assembly(cutaway = true, exploded = false);
}
else if (view_mode == 2) {
    full_differential_assembly(cutaway = false, exploded = true);
}
else if (view_mode == 3) {
    translate([0, 0, flange_thick]) carrier_flange();
}
else if (view_mode == 4) {
    translate([0, 0, pin_base_depth]) vertical_stepped_pin();
}
else if (view_mode == 5) {
    planet_gear_24mm(hand = -1);
}
else if (view_mode == 6) {
    planet_gear_24mm(hand = 1);
}
else if (view_mode == 7) {
    sun_gear_15t(hand = 1);
}
else if (view_mode == 8) {
    translate([0, 0, sun_d_shaft_len + c_collar_w])
    rotate([180, 0, 0])
        corrected_central_shaft();
}
else if (view_mode == 9) {
    center_locating_pin();
}

// ============================================================================
// МОДУЛ: ЦЯЛОСТНА СГЛОБКА
// ============================================================================

module full_differential_assembly(cutaway = false, exploded = false) {
    ez1 = exploded ? -explode_dist : 0;
    ez2 = exploded ? explode_dist : 0;

    difference() {
        union() {
            // ЛЯВА ПОЛОВИНА НА ДИФЕРЕНЦИАЛА (Z = 0)
            translate([0, 0, ez1]) {
                color("LightSteelBlue", 0.65)
                    carrier_flange();

                color("Silver")
                translate([0, 0, -seat_depth])
                    bearing_ring(od = 15.0, id = 10.0, w = 4.0);

                color("DarkOrange")
                translate([0, 0, 0])
                    corrected_central_shaft();

                color("SteelBlue")
                translate([0, 0, -(c_sec1_len + c_trans1_len + c_sec2_len + 4.0)])
                    bearing_ring(od = 12.0, id = 8.0, w = 3.5);

                color("Gold") {
                    for (i = [0 : 2]) {
                        rotate([0, 0, i * 120])
                        translate([a_sp, 0, 0])
                            vertical_stepped_pin();
                    }
                }

                color("LimeGreen") {
                    for (i = [0 : 2]) {
                        rotate([0, 0, i * 120])
                        translate([a_sp, 0, pin_step_h])
                            planet_gear_24mm(hand = -1);
                    }
                }
            }

            // ЦЕНТРАЛНИ СЛЪНЧЕВИ КОЛЕЛА И ЩИФТ
            color("DodgerBlue")
            translate([0, 0, neck_gap + (exploded ? -explode_dist * 0.4 : 0)]) {
                sun_gear_15t(hand = 1);
                color("Silver")
                translate([0, 0, sun_total_w - brg_sun_w])
                    bearing_ring(od = brg_sun_od, id = brg_sun_id, w = brg_sun_w);
            }

            color("Red")
            translate([0, 0, neck_gap + sun_total_w + (center_gap - collar_mid_w)/2])
                center_locating_pin();

            color("RoyalBlue")
            translate([0, 0, carrier_gap - neck_gap + (exploded ? explode_dist * 0.4 : 0)])
            rotate([180, 0, 180 / z_sun]) {
                sun_gear_15t(hand = 1);
                color("Silver")
                translate([0, 0, sun_total_w - brg_sun_w])
                    bearing_ring(od = brg_sun_od, id = brg_sun_id, w = brg_sun_w);
            }

            // ДЯСНА ПОЛОВИНА НА ДИФЕРЕНЦИАЛА (Z = carrier_gap)
            translate([0, 0, carrier_gap + ez2])
            rotate([180, 0, pair_angle]) {
                color("SlateGray", 0.65)
                    carrier_flange();

                color("Silver")
                translate([0, 0, -seat_depth])
                    bearing_ring(od = 15.0, id = 10.0, w = 4.0);

                color("DarkOrange")
                translate([0, 0, 0])
                    corrected_central_shaft();

                color("SteelBlue")
                translate([0, 0, -(c_sec1_len + c_trans1_len + c_sec2_len + 4.0)])
                    bearing_ring(od = 12.0, id = 8.0, w = 3.5);

                color("Gold") {
                    for (i = [0 : 2]) {
                        rotate([0, 0, i * 120])
                        translate([a_sp, 0, 0])
                            vertical_stepped_pin();
                    }
                }

                color("Gold") {
                    for (i = [0 : 2]) {
                        rotate([0, 0, i * 120])
                        translate([a_sp, 0, pin_step_h])
                            planet_gear_24mm(hand = 1);
                    }
                }
            }
        }

        if (cutaway) {
            translate([-60, 0, -50])
                cube([120, 60, 150]);
        }
    }
}

// ============================================================================
// МОДУЛИ ЗА ДЕТАЙЛИТЕ
// ============================================================================

// 1. ФЛАНЕЦ СЪС СТЕГНАТИ ГНЕЗДА
module carrier_flange() {
    difference() {
        translate([0, 0, -flange_thick])
            cylinder(d = flange_od, h = flange_thick);

        // Легло за лагер 10x15x4 с натяг 0.12mm (14.88mm)
        translate([0, 0, -seat_depth])
            cylinder(d = flange_seat_d, h = seat_depth + 0.1);

        // Отвор през 1.8mm борд
        translate([0, 0, -flange_thick - 0.5])
            cylinder(d = pass_hole_d, h = lip_thick + 1.0);

        // 3 преходни D-гнезда със затягане 0.20mm (8.80mm / 7.30mm)
        for (i = [0 : 2]) {
            rotate([0, 0, i * 120])
            translate([a_sp, 0, -flange_thick - 0.5])
                linear_extrude(height = flange_thick + 1.0)
                    d_shape_2d(d = flange_d_hole_d, flat_t = flange_d_hole_t);
        }

        // 3 преходни кръгли отвора със затягане 0.16mm (5.84mm)
        for (i = [0 : 2]) {
            rotate([0, 0, i * 120 + pair_angle])
            translate([a_sp, 0, -flange_thick - 0.5])
                cylinder(d = flange_tip_hole, h = flange_thick + 1.0);
        }

        // 3 отвора за стягащи винтове M3
        for (i = [0 : 2]) {
            rotate([0, 0, i * 120 + pair_angle/2 + 60])
            translate([18.5, 0, -flange_thick - 0.5])
                cylinder(d = 3.2, h = flange_thick + 1.0);
        }
    }
}

// 2. ВЕРТИКАЛЕН САТЕЛИТЕН ВАЛ (42.0 mm)
module vertical_stepped_pin() {
    union() {
        // D-основа и стъпало (затягат с 0.2mm във фланеца)
        translate([0, 0, -pin_base_depth])
            linear_extrude(height = pin_base_depth + pin_step_h)
                d_shape_2d(d = pin_base_d, flat_t = pin_flat_t);

        // Работна шийка 5.90mm (хлабина точно 0.10mm в 6.00mm отвор)
        translate([0, 0, pin_step_h])
            cylinder(d = pin_journal_d, h = pin_journal_len);

        // Центроващ връх 6.00mm с фаска (влиза стегнато в 5.84mm отвор)
        translate([0, 0, pin_step_h + pin_journal_len]) {
            cylinder(d = pin_tip_d, h = pin_tip_len - 0.8);
            translate([0, 0, pin_tip_len - 0.8])
                cylinder(d1 = pin_tip_d, d2 = pin_tip_d - 1.2, h = 0.8);
        }
    }
}

// 3. САТЕЛИТНО КОЛЕЛО (Отвор 6.00 mm за плъзгащ лагер)
module planet_gear_24mm(hand = 1) {
    twist_deg = hand * (planet_gear_len * tan(beta) / r_p_planet) * (180 / PI);
    difference() {
        union() {
            linear_extrude(height = planet_gear_len, twist = twist_deg, slices = planet_gear_len * 8)
                gear_2d_profile(z_planet, x_planet);

            translate([0, 0, planet_gear_len - 0.05])
                cylinder(d = planet_neck_od, h = planet_neck_len + 0.05);
        }
        // Точен отвор 6.00mm за калибриране до 0.1mm хлабина
        translate([0, 0, -1])
            cylinder(d = bore_journal, h = planet_total_len + 2);
    }
}

// 4. ЦЕНТРАЛЕН ВАЛ СЪС ЗАТЯГАНЕ ВЪВ ВСИЧКИ ЗОНИ
module corrected_central_shaft() {
    union() {
        // D-накрайник към слънцето: 8.00mm / 6.50mm (влиза стегнато в 7.80mm легло)
        translate([0, 0, c_collar_w])
            linear_extrude(height = sun_d_shaft_len)
                d_shape_2d(d = sun_d_shaft_d, flat_t = sun_d_shaft_flat);

        // Дистанционен борд 2mm
        cylinder(d = c_collar_d, h = c_collar_w);

        // Лагерна шийка 10.20mm (натяг +0.20mm за лагер H10) с водеща фаска
        translate([0, 0, -c_sec1_len]) {
            cylinder(d1 = 9.60, d2 = c_sec1_d, h = 0.6);
            translate([0, 0, 0.6])
                cylinder(d = c_sec1_d, h = c_sec1_len - 0.6);
        }

        // Конус към 9mm
        translate([0, 0, -(c_sec1_len + c_trans1_len)])
            cylinder(d1 = c_sec2_d, d2 = c_sec1_d, h = c_trans1_len);

        // Междинна шийка 9mm
        translate([0, 0, -(c_sec1_len + c_trans1_len + c_sec2_len)])
            cylinder(d = c_sec2_d, h = c_sec2_len);

        // Лагерна шийка 8.16mm (натяг +0.16mm за лагер H8) с фаска
        translate([0, 0, -(c_sec1_len + c_trans1_len + c_sec2_len + c_sec3_len)]) {
            cylinder(d1 = 7.70, d2 = c_sec3_d, h = 0.6);
            translate([0, 0, 0.6])
                cylinder(d = c_sec3_d, h = c_sec3_len - 0.6);
        }

        // Конус към 6mm
        translate([0, 0, -(c_sec1_len + c_trans1_len + c_sec2_len + c_sec3_len + c_trans2_len)])
            cylinder(d1 = c_sec5_d, d2 = c_sec3_d, h = c_trans2_len);

        // Външен D-вал 6mm към главината
        translate([0, 0, -(c_sec1_len + c_trans1_len + c_sec2_len + c_sec3_len + c_trans2_len + c_sec5_len)])
            linear_extrude(height = c_sec5_len)
                d_shape_2d(d = c_sec5_d, flat_t = c_sec5_flat_t);
    }
}

// 5. СЛЪНЦЕ Z=15 СЪС ЗАТЕГНАТО D-ЛЕГЛО И ЛАГЕРНО ГНЕЗДО
module sun_gear_15t(hand = 1) {
    twist_deg = hand * (sun_toothed_w * tan(beta) / r_p_sun) * (180 / PI);
    difference() {
        union() {
            linear_extrude(height = sun_toothed_w, twist = twist_deg, slices = sun_toothed_w * 8)
                gear_2d_profile(z_sun, x_sun);
            translate([0, 0, sun_toothed_w - 0.1])
                cylinder(d = sun_collar_od, h = (sun_total_w - sun_toothed_w) + 0.1);
        }

        translate([0, 0, -1])
            cylinder(d = 5.0, h = sun_total_w + 2);

        // D-легло 7.80mm / 6.30mm (затягане точно 0.20mm върху 8.00mm вал)
        translate([0, 0, -0.1])
            linear_extrude(height = 8.1)
                d_shape_2d(d = 7.80, flat_t = 6.30);

        // Гнездо за лагер MR128 (8x12x3.5) с натяг 0.12mm (11.88mm)
        translate([0, 0, sun_total_w - brg_sun_w - 0.1])
            cylinder(d = sun_brg_seat_d, h = brg_sun_w + 0.2);
    }
}

// 6. ЩИФТ МЕЖДУ СЛЪНЦАТА (ЗАТЯГА ВЪВ ВЪТРЕШНИТЕ ГРИВНИ НА MR128)
module center_locating_pin() {
    union() {
        translate([0, 0, -pin_mid_len]) {
            cylinder(d1 = 7.5, d2 = pin_mid_d, h = 0.6);
            translate([0, 0, 0.6])
                cylinder(d = pin_mid_d, h = pin_mid_len - 0.6);
        }

        cylinder(d = collar_mid_d, h = collar_mid_w);

        translate([0, 0, collar_mid_w]) {
            cylinder(d = pin_mid_d, h = pin_mid_len - 0.6);
            translate([0, 0, pin_mid_len - 0.6])
                cylinder(d1 = pin_mid_d, d2 = 7.5, h = 0.6);
        }
    }
}

// 7. ПОМОЩНИ МОДУЛИ
module d_shape_2d(d, flat_t) {
    intersection() {
        circle(d = d);
        translate([-d/2, -d/2])
            square([d, flat_t]);
    }
}

module bearing_ring(od, id, w) {
    difference() {
        cylinder(d = od, h = w);
        translate([0, 0, -0.5])
            cylinder(d = id, h = w + 1.0);
    }
}

// 8. ЕВОЛВЕНТЕН ПРОФИЛ
module gear_2d_profile(z, x) {
    r_p = (m * z) / 2;
    r_b = r_p * cos(alpha);
    r_a = r_p + m * (1 + x);
    r_d = r_p - m * (1.25 - x);
    union() {
        circle(r = r_d + 0.05, $fn = z * 4);
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
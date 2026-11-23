// ============================================================================
// ИЗЧИСТЕН МОДЕЛ: КАСЕТА НА ДИФЕРЕНЦИАЛА (ФЛАНЦИ + ОТДЕЛНИ ОСИ + САТЕЛИТИ Z=12)
// СИНХРОНИЗИРАН С ВСИЧКИ КОРЕКЦИИ:
// 1. Вътрешно разстояние между фланците: carrier_gap = 28.0 mm (общо 40.0 mm)
// 2. Отделни сателитни оси (view_mode = 7, 6 бр.): 15 + 17 + 7 = 39.0 mm, фаски 0.5x45°
// 3. Гнезда за осите във фланеца: ф5.50 mm (дълбочина 5.0 mm) + 1.0 mm борд (отвор ф3.55 mm)
// 4. Работна шийка: ф4.40 mm (17.0 mm) + отвор в планетата: ф4.55 mm
// 5. Планети Z=12 (m=0.85): 14.6 mm зъби + 2.0 mm шийка = 16.6 mm (0.4 mm аксиална хлабина)
// 6. Шевронен фланец Z=27 (m=1.2, x=0.0 -> OD=34.80 mm), втулка 1.0 mm, легло 5.00 mm
// ============================================================================

$fn = 90;

/* [Избор на изглед / Експорт] */
// 0 = Сглобка на касетата със сателитите (Z=12), отделните оси и лагерите 6700
// 1 = 1/2 надлъжен разрез на касетата
// 2 = Разглобен изглед (Exploded View)
// 3 = Шевронен фланец Z=27 (x=0.0, OD=34.80mm) БЕЗ конзолни оси - за печат (2 броя)
// 5 = Сателитно колело Z=12 LH - 16.6mm (принтират се 3 броя)
// 6 = Сателитно колело Z=12 RH - 16.6mm (принтират се 3 броя)
// 7 = Единична сателитна ос 39.0mm (вертикално за печат с Brim - 6 броя)
view_mode = 3;

/* [Височина на разглобяване за Exploded View] */
explode_dist     = 28.0;

/* [Параметри за водещите фаски] */
brg_lead_chamfer = 0.40; // 0.4 mm водеща фаска на входа на лагерното легло
tip_lead_chamfer = 0.25; // 0.25 mm водеща фаска на отворите във фланеца
pin_end_chamfer  = 0.50; // 0.5 mm x 45° фаски от двете страни на сателитните оси

/* [Външен ШЕВРОНЕН зъбен венец на фланците - Модул 1.2, БЕЗ КОРЕКЦИЯ] */
ring_m           = 1.2;   // Модул 1.2 за външното задвижване
ring_z           = 27;    // 27 зъба (OD = 34.80 mm, дъно R = 14.70 mm)
ring_x           = 0.00;  // Без корекция
ring_beta        = 20;    // Ъгъл на шеврона

/* [Кинематика на сателитите (Z=12) и слънцето (Z=12) - Модул 0.85] */
// Z ТРЯБВА да се дели на 3: 6-те сателита образуват затворен пръстен (всеки зацепва
// двата си съседа под 60 deg) и пръстенът се затваря само при Z = 3k.
m                = 0.85;
alpha            = 20;
beta             = 20;

// Слънце Z=12
z_sun            = 12;
x_sun            = 0.25;

// Планети Z=12 (14.6 mm зъби + 2.0 mm шийка = 16.6 mm общо)
z_planet         = 12;
x_planet         = 0.25;  
planet_boss_h    = 1.00;  // 1.0 mm дистанционна шайба на фланеца (6 + 1 = 7 mm)
planet_gear_len  = 14.6;  // Зъбна част 14.6 mm (-0.4 mm за аксиална хлабина)
planet_neck_len  = 2.0;   // Шийка без зъби 2.0 mm
planet_neck_od   = 7.40;  // Външен диаметър на шийката на сателита
planet_total_len = planet_gear_len + planet_neck_len; // 16.6 mm
bore_journal     = 4.55;  // Отвор в сателита за шийка ф4.40 mm (0.15 mm хлабина)

// Дистанционна шайба около насрещния отвор във фланеца:
flange_boss_od   = 5.40;  // Изцяло извън лагерното легло ф15.08 mm!

/* [Уравнение за междуосово разстояние при Z_sun=12 и Z_planet=12] */
r_p_sun          = (m * z_sun) / 2;    // 5.10 mm
r_p_planet       = (m * z_planet) / 2; // 5.10 mm
a_sp             = r_p_sun + r_p_planet + m * (x_sun + x_planet) * 0.85; // 10.561 mm
a_pp             = 2 * r_p_planet + m * (2 * x_planet) * 0.85;           // 10.561 mm (60 deg!)
pair_angle       = 2 * asin((a_pp / 2) / a_sp);                          // ТОЧНО 60.00 deg!

/* [Фланци и лагерно гнездо за 6700 (10x15x4 mm)] */
flange_thick     = 6.0;   
flange_seat_d    = 15.08; // Гнездо за 15mm лагер 6700 (R = 7.54 mm, от Z=0 надолу)
seat_depth       = 5.00;  // 5.00 mm дълбочина от Z = 0 до Z = -5.00 mm (лагерът 4 mm + 1 mm за фланеца ф12 на втулката)
c_collar_h       = flange_thick - seat_depth; // 1.00 mm външен праг
pass_hole_d      = 13.00; // ТОЧНО 13.00 mm -> 1.00 mm праг за външната гривна на лагера

// Вътрешно аксиално разстояние между двата фланеца (обща дължина на касетата: 6 + 28 + 6 = 40 mm)
carrier_gap      = 28.0;

/* [Отделни сателитни оси - R = 10.561 mm, обща дължина 15 + 17 + 7 = 39.0 mm] */
pin_step_h       = 10.00; // Височина на основата НАД вътрешното лице на фланеца (5 + 10 = 15.0 mm)
pin_seat_len     = flange_thick - pin_hole_lip_h; // 5.00 mm - дължина на шийката, влизаща в гнездото на фланеца
pin_seat_d       = 5.05;  // ф5.05 mm - шийка с лек натяг за гнездото ф5.00 mm
pin_base_d       = 6.10;  // По-дебела основа ф5.90 mm над фланеца (прави 0.425 mm праг/упор към фланеца)
flange_pin_hole  = 5.00;  // Гнездо във фланеца (дълбочина 5.0 mm)
pin_hole_lip_h   = 1.00;  // 1.0 mm дебел външен борд на гнездото
pin_hole_lip_d   = 3.55;  // Отвор през борда ф3.55 mm
pin_journal_d    = 4.40;  // Работна шийка ф4.40 mm
pin_journal_len  = (carrier_gap - pin_step_h - planet_boss_h); // 28 - 10 - 1 = 17.00 mm

pin_tip_d        = 2.90;  // 2.90 mm връх на оста (за насрещния фланец)
pin_tip_len      = flange_thick + planet_boss_h; // 6.00 + 1.00 = 7.00 mm (наравно с фланеца)
flange_tip_hole  = 3.00;  // 3.15 mm отвор в насрещния фланец

/* [Фазиране на зъбите на сателитите (завъртане около собствената им ос)] */
tooth_pitch      = 360 / z_planet;                       // 30 deg
helix_rate       = tan(beta) / r_p_planet * 180 / PI;    // deg/mm - завъртане на профила по оста
planet_phase_L   = 0;
// Десните сателити се фазират спрямо левите (зацепват се помежду си в зоната Z = 10..18 mm)
planet_phase_R   = wrap_angle(planet_phase_L + helix_rate * (carrier_gap - 2 * pin_step_h)
                              - tooth_pitch / 2, tooth_pitch);

function wrap_angle(a, p) = a - p * floor(a / p);

// Достъп до размерите от други файлове (use <...> внася само модули и функции, не и променливи)
function carrier_param(key) =
    let (t = [
        ["flange_thick", flange_thick], ["carrier_gap", carrier_gap], ["explode_dist", explode_dist],
        ["ring_m", ring_m], ["ring_z", ring_z], ["ring_x", ring_x], ["ring_beta", ring_beta],
        ["m", m], ["alpha", alpha], ["beta", beta],
        ["z_sun", z_sun], ["x_sun", x_sun], ["z_planet", z_planet], ["x_planet", x_planet],
        ["a_sp", a_sp], ["pair_angle", pair_angle], ["pin_step_h", pin_step_h],
        ["tooth_pitch", tooth_pitch], ["helix_rate", helix_rate],
        ["planet_phase_L", planet_phase_L], ["planet_phase_R", planet_phase_R]
    ], i = search([key], t)[0])
    assert(is_num(i), str("carrier_param: непознат ключ ", key))
    t[i][1];

// ============================================================================
// ГЛАВНО УПРАВЛЕНИЕ НА ИЗГЛЕДИТЕ
// ============================================================================

if (view_mode == 0) {
    carrier_planets_assembly(cutaway = false, exploded = false);
}
else if (view_mode == 1) {
    carrier_planets_assembly(cutaway = true, exploded = false);
}
else if (view_mode == 2) {
    carrier_planets_assembly(cutaway = false, exploded = true);
}
else if (view_mode == 3) {
    translate([0, 0, flange_thick]) carrier_flange();
}
else if (view_mode == 5) {
    planet_gear_short(hand = -1);
}
else if (view_mode == 6) {
    planet_gear_short(hand = 1);
}
else if (view_mode == 7) {
    cantilever_planet_pin();
}

// ============================================================================
// МОДУЛ: СГЛОБКА НА ФЛАНЦИТЕ, ОТДЕЛНИТЕ ОСИ, САТЕЛИТИТЕ (Z=12) И ЛАГЕРИТЕ 6700
// ============================================================================

module carrier_planets_assembly(cutaway = false, exploded = false) {
    ez1 = exploded ? -explode_dist : 0;
    ez2 = exploded ? explode_dist : 0;
    epin = exploded ? explode_dist * 0.45 : 0;
    
    brg10_start_z = -seat_depth; // Лагерът опира в прага (Z = -5.0 до -1.0), отгоре го притиска фланецът ф12 на втулката

    difference() {
        union() {
            // 1. ЛЯВ ФЛАНЕЦ С ЛАГЕР 6700, 3 ОТДЕЛНИ ОСИ И 3 САТЕЛИТА Z=12 (LH)
            translate([0, 0, ez1]) {
                color("LightSteelBlue", 0.85)
                    carrier_flange();

                color("Silver")
                translate([0, 0, brg10_start_z])
                    bearing_ring(od = 15.0, id = 10.0, w = 4.0);

                // 3 отделни оси (опират в 1.0 mm външен борд при Z = -5.0 mm)
                color("OrangeRed") {
                    for (i = [0 : 2]) {
                        rotate([0, 0, i * 120])
                        translate([a_sp, 0, -(flange_thick - pin_hole_lip_h) + epin])
                            cantilever_planet_pin();
                    }
                }

                color("LimeGreen") {
                    for (i = [0 : 2]) {
                        rotate([0, 0, i * 120])
                        translate([a_sp, 0, pin_step_h + epin])
                        rotate([0, 0, planet_phase_L])
                            planet_gear_short(hand = -1);
                    }
                }
            }

            // 2. ДЕСЕН ФЛАНЕЦ С ЛАГЕР 6700, 3 ОТДЕЛНИ ОСИ И 3 САТЕЛИТА Z=12 (RH)
            translate([0, 0, carrier_gap + ez2])
            rotate([180, 0, pair_angle]) {
                color("SlateGray", 0.85)
                    carrier_flange();

                color("Silver")
                translate([0, 0, brg10_start_z])
                    bearing_ring(od = 15.0, id = 10.0, w = 4.0);

                // 3 отделни оси (опират в 1.0 mm външен борд при Z = -5.0 mm)
                color("OrangeRed") {
                    for (i = [0 : 2]) {
                        rotate([0, 0, i * 120])
                        translate([a_sp, 0, -(flange_thick - pin_hole_lip_h) + epin])
                            cantilever_planet_pin();
                    }
                }

                color("Gold") {
                    for (i = [0 : 2]) {
                        rotate([0, 0, i * 120])
                        translate([a_sp, 0, pin_step_h + epin])
                        rotate([0, 0, planet_phase_R])
                            planet_gear_short(hand = 1);
                    }
                }
            }
        }

        if (cutaway) {
            translate([-50, 0, -40])
                cube([100, 50, 120]);
        }
    }
}

// ============================================================================
// МОДУЛИ ЗА ДЕТАЙЛИТЕ
// ============================================================================

// 1. ШЕВРОНЕН ФЛАНЕЦ Z=27 (x=0.0 -> OD=34.80mm, плосък за печат с гнезда за осите!)
module carrier_flange() {
    difference() {
        union() {
            // Външен шевронен венец без корекция
            translate([0, 0, -flange_thick])
                herringbone_gear_3d(z = ring_z, m_val = ring_m, w = flange_thick, beta_val = ring_beta, x_val = ring_x, hand = 1);

            // 3 дистанционни шайби (ф5.40mm, височина 1.0mm) около отворите ф3.15mm
            for (i = [0 : 2]) {
                rotate([0, 0, i * 120 + pair_angle])
                translate([a_sp, 0, -0.1])
                    cylinder(d = flange_boss_od, h = planet_boss_h + 0.1);
            }
        }

        // А. ПРОХОДЕН ОТВОР ф13.00 mm през целия фланец (1.00mm праг откъм Z = -6.0)
        translate([0, 0, -flange_thick - 0.5])
            cylinder(d = pass_hole_d, h = flange_thick + 1.0);

        // Б. ЛЕГЛО ЗА ЛАГЕР 6700 (ф15.08 mm, от Z = -5.00 до Z = 0.00)
        translate([0, 0, -seat_depth])
            cylinder(d = flange_seat_d, h = seat_depth + 0.1);

        // В. 0.4 mm водеща фаска на вътрешния вход на лагерното легло (при Z = 0.00)
        translate([0, 0, -brg_lead_chamfer])
            cylinder(d1 = flange_seat_d, d2 = flange_seat_d + 0.4, h = brg_lead_chamfer + 0.05);

        // Г. 3 проходни отвора (ф3.15 mm) за върховете на насрещните оси (ф2.90 mm)
        for (i = [0 : 2]) {
            rotate([0, 0, i * 120 + pair_angle]) {
                translate([a_sp, 0, -flange_thick - 0.5])
                    cylinder(d = flange_tip_hole, h = flange_thick + planet_boss_h + 1.0);
                    
                translate([a_sp, 0, planet_boss_h - tip_lead_chamfer])
                    cylinder(d1 = flange_tip_hole, d2 = flange_tip_hole + 0.4, h = tip_lead_chamfer + 0.05);
            }
        }

        // Д. 3 гнезда (ф5.50 mm, дълбочина 5.0 mm) + 1.0 mm външен борд с отвор ф3.55 mm
        for (i = [0 : 2]) {
            rotate([0, 0, i * 120]) {
                // Гнездо ф5.50 mm (от Z = -5.0 до Z = 0.0)
                translate([a_sp, 0, -(flange_thick - pin_hole_lip_h)])
                    cylinder(d = flange_pin_hole, h = (flange_thick - pin_hole_lip_h) + 0.5);

                // Отвор ф3.55 mm през 1.0 mm борд (от Z = -6.0 до Z = -5.0)
                translate([a_sp, 0, -flange_thick - 0.5])
                    cylinder(d = pin_hole_lip_d, h = pin_hole_lip_h + 1.0);

                // Лека водеща фаска на входа на гнездото (при Z = 0.00)
                translate([a_sp, 0, -tip_lead_chamfer])
                    cylinder(d1 = flange_pin_hole, d2 = flange_pin_hole + 0.4, h = tip_lead_chamfer + 0.05);
            }
        }
    }
}

// 2. ОТДЕЛНА САТЕЛИТНА ОС (15 + 17 + 7 = 39.0 mm, фаски 0.5x45° от двете страни!)
module cantilever_planet_pin() {
    base_total_h = pin_seat_len + pin_step_h; // 5.00 + 10.00 = 15.00 mm
    c = pin_end_chamfer;                      // 0.50 mm x 45°

    union() {
        // 1. Секция, влизаща във фланеца (Z = 0 до 5.00 mm): ф5.05 mm с долна водеща фаска
        cylinder(d1 = pin_seat_d - 2 * c, d2 = pin_seat_d, h = c);
        translate([0, 0, c - 0.05])
            cylinder(d = pin_seat_d, h = pin_seat_len - c + 0.05);

        // 2. По-дебела основа с праг (Z = 5.00 до 15.00 mm): ф5.90 mm (упира се в лицето на фланеца)
        translate([0, 0, pin_seat_len - 0.05])
            cylinder(d = pin_base_d, h = pin_step_h + 0.05);

        // 3. Работна шийка за сателита (Z = 15.00 до 32.00 mm): ф4.40 mm (дължина 17.00 mm)
        translate([0, 0, base_total_h - 0.05])
            cylinder(d = pin_journal_d, h = pin_journal_len + 0.05);

        // 4. Изтънен връх (Z = 32.00 до 39.00 mm): ф2.90 mm (дължина 7.00 mm) с горна фаска 0.5x45°
        translate([0, 0, base_total_h + pin_journal_len]) {
            translate([0, 0, -0.05])
                cylinder(d = pin_tip_d, h = pin_tip_len - c + 0.05);
            translate([0, 0, pin_tip_len - c])
                cylinder(d1 = pin_tip_d, d2 = pin_tip_d - 2 * c, h = c);
        }
    }
}

// 3. САТЕЛИТНО КОЛЕЛО С 12 ЗЪБА (Z=12, 14.6mm зъби + 2.0mm шийка = 16.6mm)
module planet_gear_short(hand = 1) {
    twist_deg = hand * (planet_gear_len * tan(beta) / r_p_planet) * (180 / PI);
    difference() {
        union() {
            linear_extrude(height = planet_gear_len, twist = twist_deg, slices = planet_gear_len * 8)
                gear_2d_profile(z_planet, x_planet, m);

            translate([0, 0, planet_gear_len - 0.05])
                cylinder(d = planet_neck_od, h = planet_neck_len + 0.05);
        }
        translate([0, 0, -1])
            cylinder(d = bore_journal, h = planet_total_len + 2);
    }
}

// 4. ПОМОЩНИ МОДУЛИ И ЕВОЛВЕНТЕН ПРОФИЛ
module herringbone_gear_3d(z, m_val, w, beta_val, x_val = 0, hand = 1) {
    r_p = (m_val * z) / 2;
    twist_deg = hand * ((w / 2) * tan(beta_val) / r_p) * (180 / PI);
    
    union() {
        linear_extrude(height = w / 2 + 0.02, twist = twist_deg, slices = w * 4)
            gear_2d_profile(z, x_val, m_val);
            
        translate([0, 0, w])
            mirror([0, 0, 1])
            linear_extrude(height = w / 2 + 0.02, twist = twist_deg, slices = w * 4)
                gear_2d_profile(z, x_val, m_val);
    }
}

module bearing_ring(od, id, w) {
    difference() {
        cylinder(d = od, h = w);
        translate([0, 0, -0.5])
            cylinder(d = id, h = w + 1.0);
    }
}

module gear_2d_profile(z, x, mod_val) {
    r_p = (mod_val * z) / 2;
    r_b = r_p * cos(alpha);
    r_a = r_p + mod_val * (1 + x);
    r_d = r_p - mod_val * (1.25 - x);
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
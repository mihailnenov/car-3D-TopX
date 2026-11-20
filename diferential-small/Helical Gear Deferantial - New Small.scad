// ============================================================================
// ПЪЛЕН КИНЕМАТИЧЕН МОДЕЛ: СПИРАЛЕН ДИФЕРЕНЦИАЛ (TORSEN СТИЛ) + ПИНЬОН
// ОБНОВЕН С 0.5 mm ВОДЕЩИ ФАСКИ ЗА ЛЕСЕН МОНТАЖ НА ЛАГЕРИТЕ:
// - 0.5 mm водеща фаска на шийката ф10.10 mm (за лагер 6700)
// - 0.5 mm водеща фаска на шийката ф8.08 mm (за двата лагера MR128)
// - 0.5 mm водеща фаска на входа на леглото ф15.05 mm във фланеца (за лагер 6700)
// - Чисти 90-градусови опорни прагове (1.0 mm) и тясна шийка ф7.80 mm до зъбите
// ============================================================================

$fn = 90;

/* [Избор на изглед / Експорт] */
// 0  = Пълна кинематична сглобка (с двойните лагери MR128 и пиньона)
// 1  = 1/2 надлъжен разрез на целия механизъм (виждат се 0.5mm фаски и 1mm прагове)
// 2  = Разглобен изглед на целия възел (Exploded View)
// 3  = Шевронен фланец Z=25 (m=1.2, x=-0.25, OD=31.8mm) с конзолни оси (2 броя)
// 5  = Сателитно колело Z=8 LH - 20.8mm (принтират се 3 броя)
// 6  = Сателитно колело Z=8 RH - 20.8mm (принтират се 3 броя)
// 7  = ЛЯВ монолитен Слънце-Вал (Z=10 + 0.5mm фаски + шийка ф5.05) - за печат (1 брой)
// 9  = ДЕСЕН монолитен Слънце-Вал (Z=10 + 0.5mm фаски + втулка ф8.20/ф5.20) - за печат (1 брой)
// 10 = Задвижващ ШЕВРОНЕН ПИНЬОН Z=12 (m=1.2) - за печат (1 брой)
view_mode = 9;

/* [Височина на разглобяване за Exploded View] */
explode_dist    = 32.0;

/* [Параметър за водещите фаски на лагерите] */
brg_lead_chamfer = 0.50; // 0.5 mm водеща фаска за лесно влизане на лагерите

/* [Външен ШЕВРОНЕН зъбен венец на фланците - Модул 1.2, OD = 31.80 mm] */
ring_m          = 1.2;   // Модул 1.2 за външното задвижване
ring_z          = 25;    // 25 зъба
ring_x          = -0.25; // Отрицателна корекция -> сваля OD от 32.40 на ТОЧНО 31.80 mm
ring_beta       = 20;    // Ъгъл на шеврона

/* [Задвижващ ШЕВРОНЕН ПИНЬОН (зацепен за левия фланец)] */
pinion_z        = 12;    // Брой зъби на пиньона
pinion_x        = 0.00;  // Стандартен некоригиран пиньон
pinion_w        = 6.0;   // Ширина на зъбния венец на пиньона
pinion_hub_d    = 11.0;  // Диаметър на усилената главина за стопорен винт
pinion_hub_h    = 5.0;   // Височина на главината
pinion_bore_d   = 5.05;  // Централен D-отвор за 5mm вал
pinion_flat_t   = 4.05;  // Скосяване на D-отвора

// Междуосово разстояние между диференциала и пиньона (21.95 mm)
a_drive         = ring_m * ((ring_z + pinion_z) / 2 + (ring_x + pinion_x) * 0.85) + 0.05;

/* [Кинематика на вътрешните зъби - Модул 1.0] */
m               = 1.0;
alpha           = 20;
beta            = 20;

// Слънчеви колела (Z=10) - интегрирани директно на валовете
z_sun           = 10;
x_sun           = 0.25;  
sun_total_w     = 10.8;  // Референтна база за общата ширина на касетата
sun_toothed_w   = 6.3;   // Ширина на зъбния венец на слънцето

// Тясна шийка непосредствено до зъбите на слънцето (под дъното на зъбите ф8.00 mm)
sun_root_neck_d = 7.80;  

// Сателитни колела (Z=8) - със защитен клирънс от 0.8mm спрямо външния венец
z_planet        = 8;
x_planet        = 0.2;   
planet_boss_h   = 0.80;  // 0.8mm дистанционна шайба на фланеца
planet_gear_len = 19.0;  // Зъбна част 19.0 mm
planet_neck_len = 1.8;   
planet_neck_od  = 6.85;  // Точно 1.0mm радиално рамо спрямо 4.85mm ос
planet_total_len= planet_gear_len + planet_neck_len; // 20.8 mm
bore_journal    = 5.00;  

/* [Преизчислено междуосово разстояние за Z_sun=10 и Z_planet=8] */
r_p_sun         = (m * z_sun) / 2;    // 5.00 mm
r_p_planet      = (m * z_planet) / 2; // 4.00 mm
a_sp            = r_p_sun + r_p_planet + m * (x_sun + x_planet) * 0.85; // 9.38 mm
a_pp            = 2 * r_p_planet + m * (2 * x_planet) * 0.85;           // 8.34 mm
pair_angle      = 2 * asin((a_pp / 2) / a_sp);                          // ~52.84 deg

/* [Фланци и лагер 6700 (10x15x4 mm) - ТОЧНО 1.0mm праг за външната гривна] */
flange_thick    = 6.0;   
flange_seat_d   = 15.05; // Плавно влизане на ръка за 15mm лагер 6700
seat_depth      = 4.0;   // 4.0 mm дълбочина за самия лагер 6700
lip_thick       = flange_thick - seat_depth; // 2.0 mm дебелина на вътрешния борд на фланеца
pass_hole_d     = 13.00; // ТОЧНО 13.00 mm -> дава (15 - 13)/2 = 1.00 mm праг за външната гривна

// Аксиални разстояния в касетата (общо 27.0 mm)
neck_gap        = 1.8;   
center_gap      = 5.4;   
carrier_gap     = neck_gap + sun_total_w + center_gap + sun_total_w + neck_gap; // 27.0 mm

/* [ДЪЛБОКО ТЕЛЕСКОПИЧНО ЛАГЕРУВАНЕ МЕЖДУ ДВЕТЕ СЛЪНЦА] */
between_suns_span = carrier_gap - 2 * neck_gap - 2 * sun_toothed_w; // 10.80 mm

tele_outer_od   = 8.20;  // Външен диаметър на дясната женска шийка
tele_inner_id   = 5.20;  // Вътрешен отвор на дясната женска шийка (стена 1.50 mm)
tele_male_od    = 5.05;  // Външен диаметър на лявата мъжка шийка (0.15 mm хлабина)
tele_neck_len   = between_suns_span - 0.30; // 10.50 mm дължина и на двете шийки
tele_bore_depth = tele_neck_len + 0.50;     // 11.00 mm дълбочина на отвора в дясното слънце

/* [Интегрирани конзолни сателитни оси към фланеца] */
pin_step_h      = 8.85;  
pin_base_d      = 5.80;  // Оставя здрава стена до корените на зъбите при 31.8mm фланец
pin_journal_d   = 4.85;  // Работна шийка за 5.00mm отвор на сателита
pin_journal_len = (carrier_gap - pin_step_h - planet_boss_h); // 17.35 mm
pin_tip_d       = 4.90;  // Връх към насрещния фланец
pin_tip_len     = 5.00 + planet_boss_h;  
flange_tip_hole = 4.95;  // Отвор във фланеца за насрещния връх

/* [Стъпаловидни валове - ТЯСНА ШИЙКА ДО ЗЪБИТЕ + 1.0 mm ПРАГОВЕ + 0.5 mm ВОДЕЩИ ФАСКИ] */
// 0. Тясна шийка до зъбите на слънцето (от Z = 0 до Z = 1.80 mm): ф7.80 mm
// 1. Опорен праг за вътрешната гривна на лагер 6700 (от Z = -1.80 до Z = 0.00):
c_collar_d      = 12.00; // Дава ТОЧНО (12 - 10)/2 = 1.00 mm праг за лагера 6700
c_collar_h      = 1.80;  // Прибран в отвора на фланеца

// 2. Шийка за лагер 6700 (10x15x4): ф10.10mm, дължина 4.00mm (с 0.5mm водеща фаска на входа!)
c_sec1_d        = 10.10; 
c_sec1_len      = 4.00;  

// 3. Опорен борд за вътрешната гривна на лагерите MR128 (ID = 8mm): ф10.00mm -> 1.00 mm праг!
c_sec2_d        = 10.00; 
c_sec2_len      = 1.20;  

// 4. Шийка за ДВА лагера MR128 (2х 8x12x3.5): ф8.08mm, дължина 7.00 mm (с 0.5mm водеща фаска на входа!)
c_sec3_d        = 8.08;  
c_sec3_len      = 7.00;  

// 5. Външен D-вал за полуоската: ф6.00mm (4.80mm плоска част), дължина 8.50 mm
c_sec5_d        = 6.00;  
c_sec5_flat_t   = 4.80;
c_sec5_len      = 8.50;  

// Обща дължина на външната част на вала под Z=0 остава ТОЧНО 22.50 mm
shaft_ext_len   = c_collar_h + c_sec1_len + c_sec2_len + c_sec3_len + c_sec5_len;

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
else if (view_mode == 5) {
    planet_gear_short(hand = -1);
}
else if (view_mode == 6) {
    planet_gear_short(hand = 1);
}
else if (view_mode == 7) {
    translate([0, 0, shaft_ext_len])
        monolith_sun_shaft_left(hand = 1);
}
else if (view_mode == 9) {
    translate([0, 0, shaft_ext_len])
        monolith_sun_shaft_right(hand = 1);
}
else if (view_mode == 10) {
    drive_pinion();
}

// ============================================================================
// МОДУЛ: ЦЯЛОСТНА СГЛОБКА
// ============================================================================

module full_differential_assembly(cutaway = false, exploded = false) {
    ez1 = exploded ? -explode_dist : 0;
    ez2 = exploded ? explode_dist : 0;
    ex_pinion = exploded ? -explode_dist * 0.45 : 0;

    brg10_start_z = -(c_collar_h + c_sec1_len); // -5.80 mm
    brg8_start_z  = -(c_collar_h + c_sec1_len + c_sec2_len + c_sec3_len); // -14.00 mm

    difference() {
        union() {
            // 1. ЛЯВА ПОЛОВИНА НА КАСЕТАТА, ЛАГЕРИТЕ И ЗАЦЕПЕНИЯ ПИНЬОН
            translate([0, 0, ez1]) {
                color("LightSteelBlue", 0.75)
                    carrier_flange();

                color("Crimson")
                translate([-a_drive + ex_pinion, 0, -flange_thick])
                    drive_pinion();

                color("Silver")
                translate([0, 0, brg10_start_z])
                    bearing_ring(od = 15.0, id = 10.0, w = 4.0);

                color("SteelBlue")
                translate([0, 0, brg8_start_z])
                    bearing_ring(od = 12.0, id = 8.0, w = 3.5);
                    
                color("RoyalBlue")
                translate([0, 0, brg8_start_z + 3.50])
                    bearing_ring(od = 12.0, id = 8.0, w = 3.5);

                color("LimeGreen") {
                    for (i = [0 : 2]) {
                        rotate([0, 0, i * 120])
                        translate([a_sp, 0, pin_step_h])
                            planet_gear_short(hand = -1);
                    }
                }
            }

            // 2. ЛЯВ МОНОЛИТЕН СЛЪНЦЕ-ВАЛ
            color("DodgerBlue")
            translate([0, 0, exploded ? -explode_dist * 0.55 : 0])
                monolith_sun_shaft_left(hand = 1);

            // 3. ДЕСЕН МОНОЛИТЕН СЛЪНЦЕ-ВАЛ
            color("DarkOrange")
            translate([0, 0, carrier_gap + (exploded ? explode_dist * 0.55 : 0)])
            rotate([180, 0, 180 / z_sun])
                monolith_sun_shaft_right(hand = 1);

            // 4. ДЯСНА ПОЛОВИНА НА КАСЕТАТА И ЛАГЕРИТЕ
            translate([0, 0, carrier_gap + ez2])
            rotate([180, 0, pair_angle]) {
                color("SlateGray", 0.75)
                    carrier_flange();

                color("Silver")
                translate([0, 0, brg10_start_z])
                    bearing_ring(od = 15.0, id = 10.0, w = 4.0);

                color("SteelBlue")
                translate([0, 0, brg8_start_z])
                    bearing_ring(od = 12.0, id = 8.0, w = 3.5);
                    
                color("RoyalBlue")
                translate([0, 0, brg8_start_z + 3.50])
                    bearing_ring(od = 12.0, id = 8.0, w = 3.5);

                color("Gold") {
                    for (i = [0 : 2]) {
                        rotate([0, 0, i * 120])
                        translate([a_sp, 0, pin_step_h])
                            planet_gear_short(hand = 1);
                    }
                }
            }
        }

        if (cutaway) {
            translate([-80, 0, -50])
                cube([160, 60, 150]);
        }
    }
}

// ============================================================================
// МОДУЛИ ЗА ДЕТАЙЛИТЕ
// ============================================================================

// 0. ЗАДВИЖВАЩ ШЕВРОНЕН ПИНЬОН
module drive_pinion() {
    total_h = pinion_w + pinion_hub_h;
    
    difference() {
        union() {
            herringbone_gear_3d(
                z        = pinion_z, 
                m_val    = ring_m, 
                w        = pinion_w, 
                beta_val = ring_beta, 
                x_val    = pinion_x, 
                hand     = -1
            );

            if (pinion_hub_h > 0) {
                translate([0, 0, pinion_w - 0.05])
                    cylinder(d = pinion_hub_d, h = pinion_hub_h + 0.05);
            }
        }

        translate([0, 0, -0.5])
            linear_extrude(height = total_h + 1.0)
                d_shape_2d(d = pinion_bore_d, flat_t = pinion_flat_t);

        if (pinion_hub_h >= 3.5) {
            translate([0, 0, pinion_w + pinion_hub_h / 2])
            rotate([-90, 0, 0])
                cylinder(d = 2.7, h = pinion_hub_d);
        }
    }
}

// 1. ЛЯВ МОНОЛИТЕН СЛЪНЦЕ-ВАЛ (Тясна шийка ф7.80 + Z=10 + мъжка шийка ф5.05 с 0.5mm фаска)
module monolith_sun_shaft_left(hand = 1) {
    twist_deg = hand * (sun_toothed_w * tan(beta) / r_p_sun) * (180 / PI);
    
    union() {
        // А. Стъпаловиден вал с 0.5 mm водещи фаски за лагерите и 1.0 mm прагове
        base_stepped_shaft();

        // Б. Слънчев зъбен венец Z=10 (от Z = 1.8 до Z = 8.1)
        translate([0, 0, neck_gap])
            linear_extrude(height = sun_toothed_w, twist = twist_deg, slices = sun_toothed_w * 8)
                gear_2d_profile(z_sun, x_sun, m);

        // В. Дълга телескопична мъжка шийка ф5.05 mm с 0.5 mm водеща фаска на върха
        translate([0, 0, neck_gap + sun_toothed_w - 0.05]) {
            cylinder(d = tele_male_od, h = tele_neck_len - brg_lead_chamfer + 0.05);
            translate([0, 0, tele_neck_len - brg_lead_chamfer])
                cylinder(d1 = tele_male_od, d2 = tele_male_od - 0.8, h = brg_lead_chamfer);
        }
    }
}

// 2. ДЕСЕН МОНОЛИТЕН СЛЪНЦЕ-ВАЛ (Тясна шийка ф7.80 + Z=10 + женска втулка ф8.20/ф5.20 с 0.5mm фаска)
module monolith_sun_shaft_right(hand = 1) {
    twist_deg = hand * (sun_toothed_w * tan(beta) / r_p_sun) * (180 / PI);
    sleeve_top_z = neck_gap + sun_toothed_w + tele_neck_len; // 18.60 mm
    
    difference() {
        union() {
            // А. Стъпаловиден вал с 0.5 mm водещи фаски за лагерите и 1.0 mm прагове
            base_stepped_shaft();

            // Б. Слънчев зъбен венец Z=10 (от Z = 1.8 до Z = 8.1)
            translate([0, 0, neck_gap])
                linear_extrude(height = sun_toothed_w, twist = twist_deg, slices = sun_toothed_w * 8)
                    gear_2d_profile(z_sun, x_sun, m);

            // В. Дълга телескопична женска шийка ф8.20 mm (дължина 10.50 mm)
            translate([0, 0, neck_gap + sun_toothed_w - 0.05])
                cylinder(d = tele_outer_od, h = tele_neck_len + 0.05);
        }

        // Г. Дълбок вътрешен отвор ф5.20 mm (дълбочина 11.00 mm)
        translate([0, 0, sleeve_top_z - tele_bore_depth])
            cylinder(d = tele_inner_id, h = tele_bore_depth + 0.1);

        // Д. 0.5 mm водеща фаска на входа на женската втулка
        translate([0, 0, sleeve_top_z - brg_lead_chamfer])
            cylinder(d1 = tele_inner_id, d2 = tele_inner_id + 0.8, h = brg_lead_chamfer + 0.05);
    }
}

// 3. БАЗОВ СТЪПАЛОВИДЕН ВАЛ (1.0mm прагове + 0.5mm водещи фаски на входа на всяка лагерна шийка!)
module base_stepped_shaft() {
    union() {
        // Стъпало 0: ТЯСНА ШИЙКА ф7.80 mm непосредствено до зъбите на слънцето (от Z = 0 до Z = 1.80 mm)
        cylinder(d = sun_root_neck_d, h = neck_gap + 0.05);

        // Стъпало 1: Опорен фланец ф12.00 mm за вътрешната гривна на лагер 6700 (от Z = -1.80 до Z = 0.00) -> 1.0mm праг
        translate([0, 0, -c_collar_h])
            cylinder(d = c_collar_d, h = c_collar_h + 0.05);

        // Стъпало 2: Шийка ф10.10 mm за лагер 6700 (дължина 4.00 mm) с 0.5 mm водеща фаска отдолу (от ф9.50 към ф10.10)!
        translate([0, 0, -(c_collar_h + c_sec1_len)]) {
            // 0.5 mm водеща фаска за лесно подвеждане на лагера 6700 (ID = 10.00 mm)
            cylinder(d1 = 9.50, d2 = c_sec1_d, h = brg_lead_chamfer);
            // Основна цилиндрична част ф10.10 mm до 90-градусовия праг ф12.00
            translate([0, 0, brg_lead_chamfer - 0.02])
                cylinder(d = c_sec1_d, h = (c_sec1_len - brg_lead_chamfer) + 0.07);
        }

        // Стъпало 3: Опорен праг ф10.00 mm за вътрешната гривна на лагерите MR128 -> 1.00 mm праг!
        translate([0, 0, -(c_collar_h + c_sec1_len + c_sec2_len)])
            cylinder(d = c_sec2_d, h = c_sec2_len + 0.05);

        // Стъпало 4: Шийка ф8.08 mm за ДВА лагера MR128 (7.00 mm) с 0.5 mm водеща фаска отдолу (от ф7.30 към ф8.08)!
        translate([0, 0, -(c_collar_h + c_sec1_len + c_sec2_len + c_sec3_len)]) {
            // 0.5 mm водеща фаска за лесно подвеждане на двата лагера MR128 (ID = 8.00 mm)
            cylinder(d1 = 7.30, d2 = c_sec3_d, h = brg_lead_chamfer);
            // Основна цилиндрична част ф8.08 mm до 90-градусовия праг ф10.00
            translate([0, 0, brg_lead_chamfer - 0.02])
                cylinder(d = c_sec3_d, h = (c_sec3_len - brg_lead_chamfer) + 0.07);
        }

        // Стъпало 5: Външен D-вал ф6.00 mm (дължина 8.50 mm)
        translate([0, 0, -shaft_ext_len])
            linear_extrude(height = c_sec5_len + 0.05)
                d_shape_2d(d = c_sec5_d, flat_t = c_sec5_flat_t);
    }
}

// 4. ЕКСТРЕМНО КОМПАКТЕН ФЛАНЕЦ Z=25 (OD=31.80mm, 1.0mm праг + 0.5mm водеща фаска за лагер 6700)
module carrier_flange() {
    union() {
        difference() {
            union() {
                translate([0, 0, -flange_thick])
                    herringbone_gear_3d(z = ring_z, m_val = ring_m, w = flange_thick, beta_val = ring_beta, x_val = ring_x, hand = 1);

                for (i = [0 : 2]) {
                    rotate([0, 0, i * 120 + pair_angle])
                    translate([a_sp, 0, -0.1])
                        cylinder(d = planet_neck_od, h = planet_boss_h + 0.1);
                }
            }

            // Легло за лагер 10x15x4 (ф15.05 mm, от Z = -6.00 до Z = -1.80)
            translate([0, 0, -flange_thick - 0.1])
                cylinder(d = flange_seat_d, h = (flange_thick - c_collar_h) + 0.1);

            // 0.5 mm водеща фаска на входа на леглото във фланеца (от ф15.80 към ф15.05 mm) за лесно вкарване на лагер 6700!
            translate([0, 0, -flange_thick - 0.05])
                cylinder(d1 = flange_seat_d + 0.75, d2 = flange_seat_d, h = brg_lead_chamfer + 0.05);

            // Проходен отвор ф13.00 mm -> 1.00 mm праг за външната гривна (15mm) и дом за ф12.00 прага на вала
            translate([0, 0, -c_collar_h - 0.1])
                cylinder(d = pass_hole_d, h = c_collar_h + 0.2);

            // 3 преходни кръгли отвора (4.95 mm) за насрещните конзолни оси
            for (i = [0 : 2]) {
                rotate([0, 0, i * 120 + pair_angle])
                translate([a_sp, 0, -flange_thick - 0.5])
                    cylinder(d = flange_tip_hole, h = flange_thick + planet_boss_h + 1.0);
            }
        }

        for (i = [0 : 2]) {
            rotate([0, 0, i * 120])
            translate([a_sp, 0, 0])
                cantilever_planet_pin();
        }
    }
}

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

// 5. КОНЗОЛНА САТЕЛИТНА ОС (Чисти 90-градусови стъпала + 0.5mm водеща фаска на върха)
module cantilever_planet_pin() {
    union() {
        translate([0, 0, -0.2])
            cylinder(d = pin_base_d, h = pin_step_h + 0.2);

        translate([0, 0, pin_step_h - 0.05])
            cylinder(d = pin_journal_d, h = pin_journal_len + 0.05);

        translate([0, 0, pin_step_h + pin_journal_len - 0.05]) {
            cylinder(d = pin_tip_d, h = pin_tip_len - brg_lead_chamfer + 0.05);
            translate([0, 0, pin_tip_len - brg_lead_chamfer])
                cylinder(d1 = pin_tip_d, d2 = pin_tip_d - 0.8, h = brg_lead_chamfer);
        }
    }
}

// 6. САТЕЛИТНО КОЛЕЛО (Z=8, 19.0mm зъби + 1.8mm шийка = 20.8mm)
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
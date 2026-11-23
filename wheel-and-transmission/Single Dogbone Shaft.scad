// =========================================================================
// САМОСТОЯТЕЛЕН OPENSCAD ФАЙЛ: ЕДИНИЧНА ПОЛУОСКА + ЗЪБНО КОЛЕЛО Z=14 + ЛАГЕР MR128
// =========================================================================
// Съдържа:
// - Полуоска със сфера ф5.8 mm и прав край за набиване (дължина 27.42 mm)
// - Шевронно зъбно колело Z=14 (m=1.2, ширина 7.0 mm) с главина за лагер
// - Визуализация на лагера MR128 (8x12x3.5 mm)
//
// Изгледи (view_mode):
// 0 = Сглобка: Полуоска + набито колело Z=14 + лагер MR128
// 1 = Разглобен изглед (Exploded view)
// 2 = Само полуоската (за 3D печат, легнала на плоската страна)
// 3 = Само зъбното колело Z=14 (за 3D печат, с главината нагоре)
// =========================================================================

$fn = 90;

/* [Избор на изглед] */
view_mode = 0;

/* [Разглобяване за Exploded view] */
explode_d = 14.0;

// --- ОСНОВНИ КОНСТАНТИ НА ПОЛУОСКАТА ---
kingpin_x     = 72.0;
diff_cup_x    = 18.0;
dogbone_l     = kingpin_x - diff_cup_x; // 54.0 mm
diff_z_offset = 9.5;
full_len      = sqrt(pow(dogbone_l, 2) + pow(diff_z_offset, 2)); // 54.83 mm
half_len      = full_len / 2;                                    // 27.415 mm

ball_d        = 5.8;  // 5.8 mm сфера за чашката ф6.0 mm
pin_hole_d    = 2.00; // Отвор за стоманен щифт ф1.75 - ф2.0 mm
flat_z        = 2.45; // Разстояние до плоската основа (за печат без подпори)
neck_free_len = 5.2;  // Свободна шийка от центъра на сферата за ъгъл ±20°

// --- ПАРАМЕТРИ НА ЗЪБНОТО КОЛЕЛО Z=14 И ЛАГЕРА MR128 ---
fd_m            = 1.2;
fd_z_wheel      = 14;
fd_x_wheel      = 0.00;
fd_beta         = 20;
fd_w            = 7.0;   // Ширина на зъбния венец
wg_alpha        = 20;

wg_shoulder_d   = 9.4;   // Рамо/упор (опира САМО във вътрешната гривна на лагера)
wg_shoulder_h   = 1.0;   // Височина на рамото 1.0 mm
wg_journal_d    = 8.08;  // Шийка ф8.08 mm за лагер MR128 (вътрешен диаметър 8.0 mm, +1% натяг)
wg_journal_h    = 3.4;   // Дължина на шийката (за лагер с ширина 3.5 mm)
dogbone_fit_clr = 0.05;  // Хлабина за набиване на правия край на полуоската

// --- ЛАГЕР MR128 (8 x 12 x 3.5 mm) ---
brg_mr128_id    = 8.0;
brg_mr128_od    = 12.0;
brg_mr128_w     = 3.5;


// =========================================================================
// ГЛАВНО УПРАВЛЕНИЕ НА ИЗГЛЕДИТЕ
// =========================================================================

if (view_mode == 0) {
    // Сглобка: Полуоската лежи хоризонтално по X (от X=0 до X=half_len)
    // Зъбното колело се набива на правия край (челото му се изравнява с края на полуоската при X=half_len)
    assembly_shaft_gear_bearing(exploded = false);
}
else if (view_mode == 1) {
    // Разглобен изглед
    assembly_shaft_gear_bearing(exploded = true);
}
else if (view_mode == 2) {
    // Само полуоската за печат
    translate([0, 0, flat_z])
        single_dogbone_shaft_printable();
}
else if (view_mode == 3) {
    // Само колелото Z=14 за печат (главината нагоре)
    translate([0, 0, fd_w])
    rotate([180, 0, 0])
        wheel_gear();
}


// =========================================================================
// СГЛОБКА НА ПОЛУОСКАТА С КОЛЕЛОТО И ЛАГЕРА
// =========================================================================

module assembly_shaft_gear_bearing(exploded = false) {
    e_brg  = exploded ? explode_d : 0;
    e_gear = exploded ? explode_d * 2 : 0;

    // 1. Полуоска (сферата е при X = 0, правият край е при X = half_len, плоската база е при Z = -flat_z)
    color("MediumSeaGreen")
        single_dogbone_shaft_printable();

    // 2. Зъбно колело Z=14 (набито на правия край: челото Z=fd_w е наравно с X=half_len,
    //    главината и шийката за лагера сочат назад към сферата (-X), а плоската част на отвора (-Y)
    //    съвпада с плоската база на полуоската (-Z) чрез ротационна матрица [gx, gy, gz] -> [gz, gx, gy])
    color("Orchid")
    translate([half_len - fd_w + e_gear, 0, 0])
    multmatrix([[0, 0, 1, 0], [1, 0, 0, 0], [0, 1, 0, 0]])
        wheel_gear();

    // 3. Лагер MR128 (8x12x3.5 mm) върху шийката ф8.08 mm на колелото
    color("LightSlateGray", 0.65)
    translate([half_len - fd_w + e_brg, 0, 0])
    multmatrix([[0, 0, 1, 0], [1, 0, 0, 0], [0, 1, 0, 0]])
    translate([0, 0, -wg_shoulder_h - brg_mr128_w])
        wheel_gear_bearing();
}


// =========================================================================
// 1. ПОЛУОСКА (ЕДИНИЧНА)
// =========================================================================

module single_dogbone_shaft_printable() {
    color("MediumSeaGreen")
    difference() {
        union() {
            // А) Сфера в левия край (X = 0)
            sphere(d = ball_d);
            
            // Б) Шийка Ф3.5 mm при сферата - свободна зона в първите neck_free_len mm
            rotate([0, 90, 0]) cylinder(d = 3.5, h = neck_free_len + 0.01);

            // Опора до плоската база (Z = -flat_z)
            hull() {
                translate([neck_free_len, 0, 0]) rotate([0, 90, 0]) cylinder(d = 3.5, h = half_len - neck_free_len);
                translate([neck_free_len, -1.2, -flat_z]) cube([half_len - neck_free_len, 2.4, 0.4]);
            }
            
            // В) Усилено централно тяло Ф4.5 mm с плоска основа до края
            hull() {
                translate([6.5, 0, 0]) rotate([0, 90, 0]) cylinder(d = 3.5, h = 0.1);
                translate([9.0, 0, 0]) rotate([0, 90, 0]) cylinder(d = 4.5, h = half_len - 9.0);
                translate([9.0, -1.8, -flat_z]) cube([half_len - 9.0, 3.6, 0.4]);
            }
        }
        
        // Срязване отдолу за плътна равнина за печат
        translate([-10, -10, -flat_z - 10])
            cube([half_len + 20, 20, 10]);
            
        // Симетрично срязване отгоре за баланс
        translate([-10, -10, flat_z])
            cube([half_len + 20, 20, 10]);
            
        // Вертикален отвор за стоманения щифт (Ф2.0 mm) в сферата
        cylinder(d = pin_hole_d, h = 12, center = true);
    }
}

// Напречно сечение на правия край на полуоската за отвора в зъбното колело
module dogbone_body_profile_2d() {
    hull() {
        circle(d = 4.5);
        translate([-1.8, -flat_z]) square([3.6, 0.4]);
    }
}


// =========================================================================
// 2. ШЕВРОННО ЗЪБНО КОЛЕЛО Z=14 С ГЛАВИНА ЗА ЛАГЕР MR128
// =========================================================================

module wheel_gear() {
    hub_h = wg_shoulder_h + wg_journal_h; // 1.0 + 3.4 = 4.4 mm
    difference() {
        union() {
            // А) Шевронен зъбен венец Z=14 (от Z = 0 до Z = fd_w)
            _wg_herringbone_gear_3d(z = fd_z_wheel, m_val = fd_m, w = fd_w,
                                    beta_val = fd_beta, x_val = fd_x_wheel, hand = -1);

            // Б) Опорен праг / рамо ф9.4 mm (от Z = -wg_shoulder_h до Z = 0)
            translate([0, 0, -wg_shoulder_h])
                cylinder(d = wg_shoulder_d, h = wg_shoulder_h + 0.05);

            // В) Шийка ф8.08 mm за лагера MR128 с водеща фаска
            translate([0, 0, -hub_h + 0.25])
                cylinder(d = wg_journal_d, h = wg_journal_h - 0.25 + 0.01);
            translate([0, 0, -hub_h])
                cylinder(d1 = wg_journal_d - 0.5, d2 = wg_journal_d, h = 0.25 + 0.01);
        }

        // Г) Отвор с точния профил на полуоската за плътно набиване
        translate([0, 0, -hub_h - 0.5])
            linear_extrude(height = fd_w + hub_h + 1)
                offset(delta = dogbone_fit_clr)
                    dogbone_body_profile_2d();
    }
}


// =========================================================================
// 3. ЛАГЕР MR128 И ВЪТРЕШНИ ПОМОЩНИ МОДУЛИ (С ПРЕФИКС _wg_, БЕЗ КОНФЛИКТИ)
// =========================================================================

module wheel_gear_bearing() {
    difference() {
        cylinder(d = brg_mr128_od, h = brg_mr128_w - 0.05);
        translate([0, 0, -0.5])
            cylinder(d = brg_mr128_id, h = brg_mr128_w + 1.0);
    }
}

module _wg_herringbone_gear_3d(z, m_val, w, beta_val, x_val = 0, hand = 1) {
    r_p = (m_val * z) / 2;
    twist_deg = hand * ((w / 2) * tan(beta_val) / r_p) * (180 / PI);
    
    union() {
        linear_extrude(height = w / 2 + 0.02, twist = twist_deg, slices = w * 4)
            _wg_gear_2d_profile(z, x_val, m_val);
            
        translate([0, 0, w])
            mirror([0, 0, 1])
            linear_extrude(height = w / 2 + 0.02, twist = twist_deg, slices = w * 4)
                _wg_gear_2d_profile(z, x_val, m_val);
    }
}

module _wg_gear_2d_profile(z, x, mod_val) {
    r_p = (mod_val * z) / 2;
    r_b = r_p * cos(wg_alpha);
    r_a = r_p + mod_val * (1 + x);
    r_d = r_p - mod_val * (1.25 - x);
    union() {
        circle(r = r_d + 0.05, $fn = z * 4);
        for (i = [0 : z - 1]) {
            rotate([0, 0, i * 360 / z])
                _wg_single_tooth_2d(z, x, r_p, r_b, r_a, r_d);
        }
    }
}

module _wg_single_tooth_2d(z, x, r_p, r_b, r_a, r_d) {
    steps = 20;
    t_max = sqrt(pow(r_a / r_b, 2) - 1);
    t_min = (r_d > r_b) ? sqrt(pow(r_d / r_b, 2) - 1) : 0;
    t_p = sqrt(pow(r_p / r_b, 2) - 1);
    inv_p = (t_p * 180 / PI) - atan(t_p);
    s_angle = (180 / z) + (360 * x * tan(wg_alpha) / (PI * z));
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

// Достъп до размерите от други файлове при use <...>
function dogbone_param(key) =
    let (t = [
        ["half_len", half_len], ["ball_d", ball_d],
        ["pin_hole_d", pin_hole_d], ["flat_z", flat_z],
        ["fd_m", fd_m], ["fd_z_wheel", fd_z_wheel], ["fd_x_wheel", fd_x_wheel],
        ["fd_beta", fd_beta], ["fd_w", fd_w],
        ["dogbone_fit_clr", dogbone_fit_clr],
        ["wg_shoulder_d", wg_shoulder_d], ["wg_shoulder_h", wg_shoulder_h],
        ["wg_journal_d", wg_journal_d], ["wg_journal_h", wg_journal_h],
        ["brg_mr128_id", brg_mr128_id], ["brg_mr128_od", brg_mr128_od], ["brg_mr128_w", brg_mr128_w]
    ], i = search([key], t)[0])
    assert(is_num(i), str("dogbone_param: непознат ключ ", key))
    t[i][1];

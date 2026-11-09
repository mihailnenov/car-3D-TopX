// ============================================================================
// КОНИЧЕН ЗЪБЕН ВЕНЕЦ С 3 УШИЧКИ ЗА ВИНТОВЕ М3 (Ø6.0 mm ухо / Ø3.4 mm отвор)
// - Широк на вътрешното чело (Z=0), тесен на външното чело (Z=6)
// - Нахлузва се отвън навътре върху фланец Ø43 x 6 mm
// - 3 ушички на 120° с проходни отвори Ø3.4 mm за винтове M3 (на R = 18.5 mm)
// ============================================================================

$fn = 90;

/* [Избор на изглед / Експорт] */
// 0 = Сглобка: Венец + Фланец (показва съосността на ушичките с отворите на фланеца)
// 1 = 1/2 Разрез през едно от ушите (инспекция на леглото и 3.4mm отвор)
// 2 = Разглобен изглед (посока на монтаж отвън навътре)
// 3 = ЗА ПЕЧАТ: Обърнат върху плоското чело на ушичките (Z=0) -> 0% съпорти!
// 4 = ЗА ПЕЧАТ: Стъпил върху широката основа (Z=0)
view_mode = 0;

/* [Параметри на коничните зъби] */
z_ring          = 36;    // Брой зъби
m_outer         = 1.6;   // Модул на широката страна (делителен диаметър 57.6 mm)
alpha           = 20;    // Ъгъл на профила (20°)
cone_angle      = 45;    // Наклон на конуса (45°)

/* [Геометрия на леглото за фланеца] */
flange_od       = 43.00; // Външен диаметър на фланеца
flange_thick    = 6.00;  // Дебелина на фланеца
pocket_d        = 42.95; // Вътрешен диаметър на леглото (лек прес-фит за Ø43.00 mm)
pocket_depth    = 6.00;  // Пълна дълбочина за фланеца

/* [Опорен праг и ушички за М3] */
lip_thick       = 1.50;  // Дебелина на прага и ушичките (1.5 mm)
rim_lip_w       = 1.20;  // Ширина на периферния праг по целия кръг (1.2 mm)

lug_r_hole      = 18.50; // Радиус на центровете на отворите (18.5 mm от основния модел)
lug_od          = 7.00;  // Външен диаметър на ушичката около отвора (6.0 mm)
m3_hole_d       = 3.80;  // Проходен отвор за винт М3 (3.4 mm)
pair_angle      = 48.68; // Фазов ъгъл на отворите от основния модел

// Обща височина на венеца
ring_total_h    = pocket_depth + lip_thick; // 7.50 mm

// ============================================================================
// УПРАВЛЕНИЕ НА ИЗГЛЕДИТЕ
// ============================================================================

if (view_mode == 0) {
    color("Gold") bevel_ring_m3_lugs();
    color("LightSteelBlue", 0.65) flange_reference();
}
else if (view_mode == 1) {
    // Разрез точно през едното ухо и отвора 3.4 mm
    rot_cut = -(pair_angle/2 + 60);
    difference() {
        rotate([0, 0, rot_cut]) {
            color("Gold") bevel_ring_m3_lugs();
            color("LightSteelBlue", 0.8) flange_reference();
        }
        translate([-50, -50, -10])
            cube([100, 50, 40]);
    }
}
else if (view_mode == 2) {
    color("Gold")
    translate([0, 0, 14])
        bevel_ring_m3_lugs();

    color("LightSteelBlue", 0.8)
        flange_reference();
}
else if (view_mode == 3) {
    // ЗА ПЕЧАТ (Препоръчителен): Лежи върху плоското външно чело с ушичките на Z=0 (без съпорти)
    translate([0, 0, ring_total_h])
    rotate([180, 0, 0])
        bevel_ring_m3_lugs();
}
else if (view_mode == 4) {
    // ЗА ПЕЧАТ (Алтернативен): Лежи върху широката основа на Z=0
    bevel_ring_m3_lugs();
}

// ============================================================================
// МОДУЛ: КОНИЧЕН ВЕНЕЦ С 3 УШИЧКИ (Ø6.0 mm) И ОТВОРИ (Ø3.4 mm)
// ============================================================================

module bevel_ring_m3_lugs() {
    r_pitch_base = (z_ring * m_outer) / 2; // 28.80 mm
    apex_h       = r_pitch_base / tan(cone_angle);
    scale_top    = (apex_h - ring_total_h) / apex_h;

    r_tip_0      = r_pitch_base + m_outer * 1.0;
    r_tip_top    = r_tip_0 * scale_top;
    r_root_0     = r_pitch_base - m_outer * 1.25;
    r_root_top   = max(r_root_0 * scale_top, (flange_od / 2) + 1.4);

    difference() {
        union() {
            // 1. КОНИЧЕН ЗЪБЕН ВЕНЕЦ (широк при Z=0, стеснява се към Z=7.5)
            intersection() {
                linear_extrude(height = ring_total_h, scale = scale_top, slices = 45)
                    involute_gear_2d(z = z_ring, mod = m_outer, pressure_angle = alpha);

                cylinder(r1 = r_tip_0, r2 = r_tip_top, h = ring_total_h);
            }

            // 2. НОСЕЩА ГРИВНА ОКОЛО ЛЕГЛОТО НА ФЛАНЕЦА
            cylinder(r1 = r_root_0 + 0.3, r2 = r_root_top + 0.2, h = ring_total_h);

            // 3. ТРИ УШИЧКИ (Ø6.0 mm) НА 120° НА ВЪНШНОТО ЧЕЛО (от Z=6.0 до Z=7.5)
            for (i = [0 : 2]) {
                rotate([0, 0, i * 120 + pair_angle/2 + 60])
                translate([0, 0, pocket_depth])
                linear_extrude(height = lip_thick)
                    lug_2d_shape();
            }
        }

        // --------------------------------------------------------------------
        // ОТНЕМАНИЯ
        // --------------------------------------------------------------------

        // 4. Легло за фланеца Ø42.95 mm (от Z = -0.1 до Z = 6.0 mm)
        translate([0, 0, -0.1])
            cylinder(d = pocket_d, h = pocket_depth + 0.1);

        // Водеща фаска (0.5mm) при Z = 0 за лесно подвеждане на фланеца
        translate([0, 0, -0.05])
            cylinder(d1 = pocket_d + 0.8, d2 = pocket_d, h = 0.55);

        // 5. Централен отвор през външния праг (оставя 1.2mm периферен праг и трите ушички)
        difference() {
            translate([0, 0, pocket_depth - 0.1])
                cylinder(d = flange_od - 2 * rim_lip_w, h = lip_thick + 0.5);

            // Запазваме материала на трите ушички
            for (i = [0 : 2]) {
                rotate([0, 0, i * 120 + pair_angle/2 + 60])
                translate([0, 0, pocket_depth - 0.2])
                linear_extrude(height = lip_thick + 1.0)
                    lug_2d_shape();
            }
        }

        // 6. ТРИ ПРОХОДНИ ОТВОРА Ø3.4 mm ПРЕЗ УШИЧКИТЕ ЗА ВИНТОВЕ М3
        for (i = [0 : 2]) {
            rotate([0, 0, i * 120 + pair_angle/2 + 60])
            translate([lug_r_hole, 0, pocket_depth - 1.0])
                cylinder(d = m3_hole_d, h = lip_thick + 2.0);
        }
    }
}

// 2D форма на една ушичка (Ø6.0 mm около отвора, преливаща към пръстена)
module lug_2d_shape() {
    hull() {
        translate([lug_r_hole, 0])
            circle(d = lug_od);
        translate([flange_od/2 + 0.5, 0])
            circle(d = lug_od + 1.5);
    }
}

// ============================================================================
// МОДУЛ: ЕВОЛВЕНТЕН 2D ПРОФИЛ НА ЗЪБИТЕ
// ============================================================================

module involute_gear_2d(z, mod, pressure_angle) {
    r_p = (mod * z) / 2;
    r_b = r_p * cos(pressure_angle);
    r_a = r_p + mod * 1.0;
    r_d = r_p - mod * 1.25;

    union() {
        circle(r = r_d + 0.05, $fn = z * 4);
        for (i = [0 : z - 1]) {
            rotate([0, 0, i * (360 / z)])
                single_involute_tooth(z, r_p, r_b, r_a, r_d);
        }
    }
}

module single_involute_tooth(z, r_p, r_b, r_a, r_d) {
    steps = 18;
    t_max = (r_a > r_b) ? sqrt(pow(r_a / r_b, 2) - 1) : 0;
    t_min = (r_d > r_b) ? sqrt(pow(r_d / r_b, 2) - 1) : 0;
    t_p   = (r_p > r_b) ? sqrt(pow(r_p / r_b, 2) - 1) : 0;
    inv_p = (t_p * 180 / PI) - atan(t_p);
    s_ang = 180 / z;
    off   = (s_ang / 2) + inv_p;

    inv_pts = [
        for (i = [0 : steps])
            let (t = t_min + i * (t_max - t_min) / steps)
            let (r = r_b * sqrt(1 + t * t))
            let (th = (t * 180 / PI) - atan(t))
            [r * cos(off - th), r * sin(off - th)]
    ];
    mir_pts = [
        for (i = [steps : -1 : 0])
            [inv_pts[i][0], -inv_pts[i][1]]
    ];
    polygon(concat([[0, 0]], inv_pts, mir_pts));
}

// ============================================================================
// МОДУЛ: РЕФЕРЕНТЕН ФЛАНЕЦ (ОТ ОСНОВНИЯ МОДЕЛ)
// ============================================================================

module flange_reference() {
    rotate([180, 0, 0])
    difference() {
        translate([0, 0, -flange_thick])
            cylinder(d = flange_od, h = flange_thick);

        translate([0, 0, -4.2])
            cylinder(d = 14.88, h = 4.3);
        translate([0, 0, -flange_thick - 0.5])
            cylinder(d = 11.4, h = 2.5);

        for (i = [0 : 2]) {
            rotate([0, 0, i * 120])
            translate([15.61, 0, -flange_thick - 0.5])
                cylinder(d = 8.80, h = flange_thick + 1.0);

            rotate([0, 0, i * 120 + pair_angle])
            translate([15.61, 0, -flange_thick - 0.5])
                cylinder(d = 5.84, h = flange_thick + 1.0);

            // Трите отвора за винтове М3 във фланеца (на R = 18.5 mm)
            rotate([0, 0, i * 120 + pair_angle/2 + 60])
            translate([lug_r_hole, 0, -flange_thick - 0.5])
                cylinder(d = 3.20, h = flange_thick + 1.0);
        }
    }
}
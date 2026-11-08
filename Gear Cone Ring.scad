// ============================================================================
// ПРАВИЛЕН КОНИЧЕН ЗЪБЕН ВЕНЕЦ (BEVEL RING GEAR) С ЗЪБИ, ГЛЕДАЩИ НАВЪН
// Истинска конична геометрия по Тредголд с общ връх на конусите (Apex)
// Фланецът (Ø43 x 6mm) влиза отвътре и опира във външния 1.2mm праг.
// ============================================================================

$fn = 90;

/* [Избор на изглед / Експорт] */
// 0 = Сглобка: Коничен венец + Фланец + Задвижващ пиньон под 90° (проверка на зацепването)
// 1 = 1/2 Надлъжен разрез (вижда се посоката на конуса навън и 1.2mm праг)
// 2 = Разглобен изглед (Exploded View)
// 3 = КОНИЧЕН ВЕНЕЦ ЗА ПЕЧАТ (легнал на широката си задна основа Z=0, зъбите гледат нагоре/навън!)
// 4 = Задвижващ коничен пиньон (Z=13) за печат
view_mode = 0;

/* [Кинематични параметри на коничната предавка (90° оси)] */
m_bevel         = 1.5;   // Външен модул (Outer Transverse Module)
z_ring          = 36;    // Брой зъби на венеца (Делителен диаметър d = 54.0 mm)
z_pinion        = 12;    // Брой зъби на пиньона (Предавателно отношение 3:1)
alpha           = 20;    // Ъгъл на профила (20°)

/* [Геометрия на венеца и леглото за фланеца] */
flange_od       = 43.00; // Външен диаметър на фланеца
flange_thick    = 6.00;  // Дебелина на фланеца

pocket_d        = 42.90; // Легло с 0.10mm натяг за Ø43.0mm фланец
pocket_depth    = 6.00;  // Пълна дълбочина 6.0mm за фланеца
lip_thick       = 1.20;  // Външен опорен праг = 1.2 mm
ring_total_h    = pocket_depth + lip_thick; // 7.20 mm обща аксиална дебелина

// Вътрешен диаметър на 1.2mm праг (34.0 mm покрива и М3 отворите; 40.0 mm за чист периферен ръб)
lip_id          = 34.00;
pair_angle      = 48.68; // Ъгъл за синхронизиране на М3 отворите с фланеца

// ============================================================================
// ТОЧНИ ГЕОМЕТРИЧНИ ИЗЧИСЛЕНИЯ НА КОНУСИТЕ (GLEASON / TREDGOLD)
// ============================================================================

// 1. Делителни диаметри и конусни ъгли
d_ring          = m_bevel * z_ring;             // 54.0 mm
d_pinion        = m_bevel * z_pinion;           // 18.0 mm
r_ring          = d_ring / 2;                   // 27.0 mm
r_pinion        = d_pinion / 2;                 // 9.0 mm

gamma_ring      = atan(z_ring / z_pinion);      // Делителен ъгъл на венеца = 71.565°
gamma_pinion    = 90 - gamma_ring;              // Делителен ъгъл на пиньона = 18.435°

// 2. Външно конусно разстояние (Outer Cone Distance Re)
Re              = r_ring / sin(gamma_ring);     // 28.46 mm

// 3. Височина на главата (ha), петата (hf) и ъгли на изменение
ha              = 1.00 * m_bevel;               // 1.50 mm
hf              = 1.25 * m_bevel;               // 1.875 mm
theta_a         = atan(ha / Re);                // Ъгъл на главата на зъба
theta_f         = atan(hf / Re);                // Ъгъл на корена на зъба

// 4. Аксиална позиция на общия връх на конуса (Apex)
// Z = 0 е широката вътрешна страна (към диференциала), Z = 7.2 е външната страна (с 1.2mm праг)
// Така зъбите гледат НАВЪН (към Z+) и се зацепват с пиньон от външната страна!
apex_z_ring     = r_ring / tan(gamma_ring);     // 9.00 mm (точно на оста на пиньона!)

// ============================================================================
// ГЛАВНО УПРАВЛЕНИЕ НА ИЗГЛЕДИТЕ
// ============================================================================

if (view_mode == 0) {
    // Пълна сглобка със задвижващия пиньон под 90°
    color("Gold") bevel_ring_gear_outward();
    color("LightSteelBlue", 0.7) flange_in_pocket();

    // Пиньон, зацепен от външната страна (в общия апекс Z = apex_z_ring)
    color("Crimson")
    translate([0, -apex_z_ring / tan(gamma_pinion), apex_z_ring])
    rotate([-90, 0, 0])
    rotate([0, 0, 180 / z_pinion])
        bevel_pinion_true();
}
else if (view_mode == 1) {
    // 1/2 разрез за проверка на леглото, прага 1.2mm и наклона на зъбите навън
    difference() {
        union() {
            color("Gold") bevel_ring_gear_outward();
            color("LightSteelBlue", 0.85) flange_in_pocket();
        }
        translate([-50, 0, -10])
            cube([100, 50, 40]);
    }
}
else if (view_mode == 2) {
    // Разглобен изглед: Фланецът влиза отдолу (отвътре навън) до 1.2mm праг
    color("Gold")
    translate([0, 0, 15])
        bevel_ring_gear_outward();

    color("LightSteelBlue", 0.85)
        flange_in_pocket();
}
else if (view_mode == 3) {
    // ЗА ПЕЧАТ: Венецът лежи на широката си основа при Z = 0, а конусните зъби гледат нагоре!
    // Идеална ориентация за FDM печат без никакви поддръжки (0% overhangs по зъбите).
    bevel_ring_gear_outward();
}
else if (view_mode == 4) {
    // Задвижващ пиньон за печат (стъпил на широката си основа)
    bevel_pinion_true();
}

// ============================================================================
// МОДУЛ: КОНИЧЕН ВЕНЕЦ СЪС ЗЪБИ, НАКЛОНЕНИ НАВЪН
// ============================================================================

module bevel_ring_gear_outward() {
    // Мащабиране към общия връх на конуса (Apex при Z = apex_z_ring)
    // За да пресечем цялата височина ring_total_h (7.2mm), екструдираме до h_ext = 7.5mm
    h_ext  = ring_total_h + 0.5;
    s_ring = (apex_z_ring - h_ext) / apex_z_ring;

    // Външни радиуси на лицевия конус (върховете на зъбите) при Z=0 и Z=ring_total_h
    r_tip_base = r_ring + ha * cos(gamma_ring);
    r_tip_top  = r_tip_base * ((apex_z_ring - ring_total_h) / apex_z_ring);

    // Радиус на коренния конус (дъното между зъбите) при Z=0 и Z=ring_total_h
    r_root_base = r_ring - hf * cos(gamma_ring);
    r_root_top  = r_root_base * ((apex_z_ring - ring_total_h) / apex_z_ring);

    difference() {
        union() {
            // 1. Истински коничен зъбен венец (гледащ навън към Z+)
            intersection() {
                // Сходяща еволвентна геометрия към апекса (Z = 9.0 mm)
                linear_extrude(height = h_ext, scale = s_ring, slices = 50)
                    bevel_gear_2d_section(
                        r_pitch = r_ring,
                        z_teeth = z_ring,
                        gamma   = gamma_ring,
                        ha_val  = ha,
                        hf_val  = hf
                    );

                // Лицев конус (ограничава височината на зъбите точно по конуса)
                cylinder(r1 = r_tip_base, r2 = r_tip_top, h = ring_total_h);
            }

            // 2. Плътен конусен пръстен в основата на зъбите (корпус около фланеца)
            cylinder(
                r1 = r_root_base + 0.2,
                r2 = max(r_root_top + 0.2, (flange_od / 2) + 1.6),
                h  = ring_total_h
            );
        }

        // --------------------------------------------------------------------
        // ВЪТРЕШНО ЛЕГЛО ЗА ФЛАНЕЦА И 1.2mm ПРАГ
        // --------------------------------------------------------------------
        // Тъй като зъбите гледат навън (към Z = 7.2mm):
        // - Прагът 1.2mm се намира от външната страна (от Z = 6.0 до Z = 7.2mm)
        // - Фланецът влиза откъм диференциала (от Z = 0 до Z = 6.0mm) и опира в прага!

        // 3. Легло Ø42.90mm с дълбочина 6.0mm (от Z = -0.1 до Z = 6.0mm)
        translate([0, 0, -0.1])
            cylinder(d = pocket_d, h = pocket_depth + 0.1);

        // Водеща фаска (0.5mm) на входа на леглото (при Z = 0)
        translate([0, 0, -0.05])
            cylinder(d1 = pocket_d + 0.8, d2 = pocket_d, h = 0.55);

        // 4. Вътрешен проходен отвор през 1.2mm праг (Ø34.0 mm)
        translate([0, 0, -1.0])
            cylinder(d = lip_id, h = ring_total_h + 2.0);

        // 5. Трите отвора за стягащи болтове M3 през 1.2mm праг (R = 18.5 mm)
        for (i = [0 : 2]) {
            rotate([0, 0, i * 120 + pair_angle/2 + 60])
            translate([18.5, 0, pocket_depth - 0.5])
                cylinder(d = 3.2, h = lip_thick + 1.5);
        }
    }
}

// ============================================================================
// МОДУЛ: ИСТИНСКИ КОНИЧЕН ПИНЬОН (Z=12) ЗА 90° ЗАЦЕПВАНЕ
// ============================================================================

module bevel_pinion_true() {
    pinion_w     = 6.5; // Работна ширина на пиньона
    apex_z_pin   = r_pinion / tan(gamma_pinion); // 27.0 mm
    s_pinion     = (apex_z_pin - pinion_w) / apex_z_pin;

    r_p_tip_base = r_pinion + ha * cos(gamma_pinion);
    r_p_tip_top  = r_p_tip_base * s_pinion;

    difference() {
        union() {
            // Конични зъби на пиньона
            intersection() {
                linear_extrude(height = pinion_w, scale = s_pinion, slices = 40)
                    bevel_gear_2d_section(
                        r_pitch = r_pinion,
                        z_teeth = z_pinion,
                        gamma   = gamma_pinion,
                        ha_val  = ha,
                        hf_val  = hf
                    );

                cylinder(r1 = r_p_tip_base, r2 = r_p_tip_top, h = pinion_w);
            }

            // Задна опорна шийка на пиньона
            translate([0, 0, -4.0])
                cylinder(r = r_pinion - hf * cos(gamma_pinion) + 0.5, h = 4.1);
        }

        // D-образен отвор Ø6.0mm (плоскост на 4.8mm)
        translate([0, 0, -5.0])
            intersection() {
                cylinder(d = 6.0, h = pinion_w + 10.0);
                translate([-3.0, -3.0, 0])
                    cube([6.0, 4.8, pinion_w + 10.0]);
            }
    }
}

// ============================================================================
// МОДУЛ: 2D ПРОФИЛ НА КОНИЧНО КОЛЕЛО ПО МЕТОДА НА ТРЕДГОЛД
// Проектира правилен еволвентен зъб спрямо конусния ъгъл gamma
// ============================================================================

module bevel_gear_2d_section(r_pitch, z_teeth, gamma, ha_val, hf_val) {
    // Радиуси, проектирани в равнината на основата (Z=0)
    r_a = r_pitch + ha_val * cos(gamma);
    r_d = r_pitch - hf_val * cos(gamma);
    r_b = r_pitch * cos(alpha);

    union() {
        circle(r = r_d + 0.05, $fn = z_teeth * 4);
        for (i = [0 : z_teeth - 1]) {
            rotate([0, 0, i * (360 / z_teeth)])
                bevel_single_tooth_2d(z_teeth, r_pitch, r_b, r_a, r_d);
        }
    }
}

module bevel_single_tooth_2d(z, r_p, r_b, r_a, r_d) {
    steps = 20;
    t_max = (r_a > r_b) ? sqrt(pow(r_a / r_b, 2) - 1) : 0;
    t_min = (r_d > r_b) ? sqrt(pow(r_d / r_b, 2) - 1) : 0;
    t_p   = (r_p > r_b) ? sqrt(pow(r_p / r_b, 2) - 1) : 0;
    inv_p = (t_p * 180 / PI) - atan(t_p);

    // Ъглова дебелина на зъба върху делителната окръжност
    s_ang = (180 / z);
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
// МОДУЛ: ИЛЮСТРАТИВЕН ФЛАНЕЦ В ЛЕГЛОТО (ЗА ПРОВЕРКА НА ПОСОКАТА)
// ============================================================================

module flange_in_pocket() {
    // Външната страна на фланеца (Z = 6.0) опира в 1.2mm праг,
    // а вътрешната страна (с лагерното гнездо 10x15x4) е при Z = 0 (към сателитите).
    translate([0, 0, pocket_depth])
    rotate([180, 0, 0])
        difference() {
            translate([0, 0, -flange_thick])
                cylinder(d = flange_od, h = flange_thick);

            // Лагерно легло 10x15x4 от вътрешната страна на фланеца
            translate([0, 0, -4.2])
                cylinder(d = 14.88, h = 4.3);
            translate([0, 0, -flange_thick - 0.5])
                cylinder(d = 11.4, h = 2.5);

            // Отвори за сателитни оси и М3 болтове
            for (i = [0 : 2]) {
                rotate([0, 0, i * 120])
                translate([15.61, 0, -flange_thick - 0.5])
                    cylinder(d = 8.80, h = flange_thick + 1.0);

                rotate([0, 0, i * 120 + pair_angle])
                translate([15.61, 0, -flange_thick - 0.5])
                    cylinder(d = 5.84, h = flange_thick + 1.0);

                rotate([0, 0, i * 120 + pair_angle/2 + 60])
                translate([18.5, 0, -flange_thick - 0.5])
                    cylinder(d = 3.2, h = flange_thick + 1.0);
            }
        }
}
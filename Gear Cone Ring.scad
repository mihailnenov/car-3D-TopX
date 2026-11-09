// ============================================================================
// ФИНАЛЕН И ИЗЧИСТЕН ШЕВРОНЕН ЗЪБЕН ВЕНЕЦ (Z=50, m=1.0, B=8mm) С М3.5 УШИЧКИ
// ============================================================================

$fn = 90;

/* [Избор на изглед / Експорт] */
// 0 = Сглобка: Венец + Фланец + Шевронен пиньон Z=15
// 1 = 1/2 Разрез през ушичката и отвора М3.5
// 2 = Разглобен изглед
// 3 = ВЕНЕЦ ЗА ПЕЧАТ (плосък от двете страни, 0% съпорти)
// 4 = ПИНЬОН Z=15 ЗА ПЕЧАТ
view_mode = 0;

/* [Параметри] */
z_ring          = 36;    // 36 зъба при модул 1.5 (делителен Ø54.0 mm)
z_pinion        = 12;    // Задвижващ шевронен пиньон
m_outer         = 1.5;   // Модул 1.5
alpha           = 20;    // Ъгъл на профила (20°)
beta            = 25;    // Ъгъл на наклона на шевронните зъби (25°)
x_ring          = 0.0;
ha_fac          = 0.80;  // Коефициент за височината на главата (намален за по-ниски зъби)
hf_fac          = 1.00;  // Коефициент за дълбочината на корена

flange_od       = 43.00;
flange_thick    = 6.00;
pocket_d        = 42.95;
pocket_depth    = 6.00;

ring_total_h    = 8.00;  // Обща ширина на венеца и зъбите = 8.0 mm
lip_thick       = ring_total_h - pocket_depth; // 2.00 mm (още по-здрави ушички при 8mm обща ширина)
rim_lip_w       = 1.20;
lug_r_hole      = 18.50;
lug_od          = 7.00;
m35_hole_d      = 3.85;
pair_angle      = 48.68;

r_p_ring        = (m_outer * z_ring) / 2;   // 27.00 mm
r_p_pinion      = (m_outer * z_pinion) / 2; // 9.00 mm
center_dist     = r_p_ring + r_p_pinion;    // 36.00 mm междуосово разстояние

// ============================================================================
// ИЗГЛЕДИ
// ============================================================================

if (view_mode == 0) {
    color("Gold") bevel_ring_m35_lugs();
    color("LightSteelBlue", 0.65) flange_reference();
    color("Crimson")
    translate([0, -center_dist, 0])
    rotate([0, 0, 180 / z_pinion])
        bevel_pinion_z12();
}
else if (view_mode == 1) {
    rot_cut = -(pair_angle/2 + 60);
    difference() {
        rotate([0, 0, rot_cut]) {
            color("Gold") bevel_ring_m35_lugs();
            color("LightSteelBlue", 0.8) flange_reference();
        }
        translate([-50, -50, -10])
            cube([100, 50, 40]);
    }
}
else if (view_mode == 2) {
    color("Gold") translate([0, 0, 14]) bevel_ring_m35_lugs();
    color("LightSteelBlue", 0.8) flange_reference();
}
else if (view_mode == 3) {
    // Готов за печат: обърнат с ушичките към леглото (Z=0), без съпорти
    translate([0, 0, ring_total_h])
    rotate([180, 0, 0])
        bevel_ring_m35_lugs();
}
else if (view_mode == 4) {
    bevel_pinion_z12();
}

// ============================================================================
// МОДУЛИ
// ============================================================================

module bevel_ring_m35_lugs() {
    difference() {
        union() {
            // 1. Шевронен зъбен венец (ширина 8.0 mm, модул 1.5, Z=36)
            herringbone_gear_body(z = z_ring, mod = m_outer, x = x_ring, h = ring_total_h, hand = 1);

            // 2. Три прибрани ушички за М3.5 на външното чело (от Z = 6.0 до 8.0 mm)
            for (i = [0 : 2]) {
                rotate([0, 0, i * 120 + pair_angle/2 + 60])
                translate([0, 0, pocket_depth])
                linear_extrude(height = lip_thick)
                    lug_2d_shape();
            }
        }

        // Легло за фланеца Ø42.95 mm (дълбочина 6.0 mm)
        translate([0, 0, -0.1])
            cylinder(d = pocket_d, h = pocket_depth + 0.1);

        // Водеща фаска на входа на леглото
        translate([0, 0, -0.05])
            cylinder(d1 = pocket_d + 0.8, d2 = pocket_d, h = 0.55);

        // Централен проходен отвор (оставя 1.2mm периферен праг и трите ушички)
        difference() {
            translate([0, 0, pocket_depth - 0.1])
                cylinder(d = flange_od - 2 * rim_lip_w, h = lip_thick + 0.5);

            for (i = [0 : 2]) {
                rotate([0, 0, i * 120 + pair_angle/2 + 60])
                translate([0, 0, pocket_depth - 0.2])
                linear_extrude(height = lip_thick + 1.0)
                    lug_2d_shape();
            }
        }

        // Проходни отвори Ø3.85 mm за винтове М3.5 (на R = 18.5 mm) + конусна фаска за главата на винта
        for (i = [0 : 2]) {
            rotate([0, 0, i * 120 + pair_angle/2 + 60])
            translate([lug_r_hole, 0, pocket_depth - 1.0]) {
                cylinder(d = m35_hole_d, h = lip_thick + 2.0);
                translate([0, 0, lip_thick + 1.0 - 1.0])
                    cylinder(d1 = m35_hole_d, d2 = m35_hole_d + 2.0, h = 1.05);
            }
        }
    }
}

module lug_2d_shape() {
    hull() {
        translate([lug_r_hole, 0])
            circle(d = lug_od);
        translate([20.8, 0])
            circle(d = 5.0);
    }
}

module bevel_pinion_z12() {
    difference() {
        // Шевронен пиньон с обратна посока на спиралата (hand = -1) за зацепване с венеца
        herringbone_gear_body(z = z_pinion, mod = m_outer, x = 0.0, h = ring_total_h, hand = -1);

        // D-отвор Ø6.0 mm за вала
        translate([0, 0, -1.0])
            intersection() {
                cylinder(d = 6.0, h = ring_total_h + 2.0);
                translate([-3.0, -3.0, 0])
                    cube([6.0, 4.8, ring_total_h + 2.0]);
            }
    }
}

// Модул за генериране на двоен спирален (шевронен) венец
module herringbone_gear_body(z, mod, x, h, hand = 1) {
    r_p    = (mod * z) / 2;
    half_h = h / 2;
    twist  = hand * (half_h * tan(beta) / r_p) * (180 / PI);

    union() {
        // Долна половина (Z = 0 до h/2)
        linear_extrude(height = half_h + 0.02, twist = twist, slices = 25)
            gear_2d_profile(z, mod, x);

        // Горна половина (Z = h/2 до h), завъртяна точно в средата на V-връхчето
        translate([0, 0, half_h])
        rotate([0, 0, -twist])
        linear_extrude(height = half_h, twist = -twist, slices = 25)
            gear_2d_profile(z, mod, x);
    }
}

module gear_2d_profile(z, mod, x) {
    r_p = (mod * z) / 2;
    r_b = r_p * cos(alpha);
    r_a = r_p + mod * (ha_fac + x);
    r_d = r_p - mod * (hf_fac - x);
    union() {
        circle(r = r_d + 0.05, $fn = z * 4);
        for (i = [0 : z - 1]) {
            rotate([0, 0, i * 360 / z])
                single_tooth_2d(z, mod, x, r_p, r_b, r_a, r_d);
        }
    }
}

module single_tooth_2d(z, mod, x, r_p, r_b, r_a, r_d) {
    steps = 18;
    t_max = sqrt(pow(r_a / r_b, 2) - 1);
    t_min = (r_d > r_b) ? sqrt(pow(r_d / r_b, 2) - 1) : 0;
    t_p   = sqrt(pow(r_p / r_b, 2) - 1);
    inv_p = (t_p * 180 / PI) - atan(t_p);
    s_ang = (180 / z) + (360 * x * tan(alpha) / (PI * z));
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

            // Отворите М3.5 на R = 18.5 mm
            rotate([0, 0, i * 120 + pair_angle/2 + 60])
            translate([lug_r_hole, 0, -flange_thick - 0.5])
                cylinder(d = 3.20, h = flange_thick + 1.0);
        }
    }
}
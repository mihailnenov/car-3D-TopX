$fn = 120; // Гладкост на цилиндрите

// =========================================================================
// --- ИЗБОР НА ИЗГЛЕД (VIEW MODE) И НАСТРОЙКИ ---
// =========================================================================
// 1 = ХОРИЗОНТАЛНО СГЛОБЕНИ (по оста X, с лагерите)
// 2 = ХОРИЗОНТАЛНО РАЗГЛОБЕНИ (Exploded view по оста X)
// 3 = ВЕРТИКАЛНО РАЗГЛОБЕНИ (Exploded view по оста Z)
// 4 = ВЕРТИКАЛНО СГЛОБЕНИ (по оста Z, с разрез и лагери)
// 5 = Комплект за печат на Z = 0 (1 вал и 1 втулка)
// 6 = Само стъпаловидният вал
// 7 = Само цилиндричната втулка
view_mode = 5;

top_profile_type = 3;  // 3 = Заоблен ТРИЪГЪЛНИК, 4 = Заоблен КВАДРАТ
cross_section = true;  // true = срязва втулките и лагерите наполовина
show_bearings = true;  // true = показва полупрозрачно лагерите (1x 6700 + 2x MR128 на полуоска)
explode_dist  = 14.0;  // Разстояние между детайлите при разглобен вид (режими 2 и 3)


// =========================================================================
// --- ПАРАМЕТРИ И ДОПУСКИ ЗА СГЛОБКИТЕ ---
// =========================================================================
clearance = 0.10;            // Хлабина пластмаса в пластмаса (0.10 мм)
bearing_interference = 0.01; // +1% натяг за лагерите (D8 -> 8.08 мм, D10 -> 10.10 мм)

dogbone_d   = 0.65; // Освобождаващи канали във вътрешните ъгли на квадрата (за втулката)
corner_clip = 0.35; // Скосяване на острите ръбове на квадратния вал

// Параметри на ВАЛА (Обща дължина: 10 + 17 + 6 = 33 мм)
s1 = 5.65;  h1 = 10; // Секция 1 (За зъбното колело към гумите): Квадрат 5.65 мм (Z = 0 до 10)
s2 = 4.24;  h2 = 17; // Секция 2 (За втулката 15 мм + 2 мм остатък): Квадрат 4.24 мм (Z = 10 до 27)
            h3 = 6;  // Секция 3 (За слънцето): Заоблен триъгълник с пирамида (Z = 27 до 33)

h3_straight = 4.0;   // Права част на профила (4 мм: Z = 27 до 31)
h3_pyramid  = 2.0;   // Пирамидален връх (2 мм: Z = 31 до 33)
tip_z_play  = 0.10;  // Минимален аксиален резерв на върха

total_shaft_h = h1 + h2 + h3; // 33 мм

// Параметри на ВЪРХА НА ВАЛА (Секция 3) - Вписан в окръжност Ø4.0 мм
top_outer_r  = 2.00; // Максимален външен радиус до заоблените върхове в основата (Ø4.0 мм)
top_corner_r = 0.40; // Радиус на заобляне на върховете
tip_outer_r  = 0.60; // Външен радиус на върха на пирамидата на Z = 33 (Ø1.2 мм)
tip_corner_r = 0.30; // Радиус на заобляне на върха на пирамидата

// Диаметри на ВТУЛКАТА ЗА ЛАГЕРИ (Обща дължина: 2 + 6 + 7 = 15 мм)
d_mid_nom = 10.0; // 1 бр. Лагер 6700 (10x15x4) във фланеца на диференциала
d_top_nom = 8.0;  // 2 бр. Лагери MR128 (8x12x3.5 -> общо 7 мм) във външната подпора

d_flange = 12.00;                                  l_flange = 2.0; // Вътрешен праг Ø12 мм
d_mid    = d_mid_nom * (1 + bearing_interference); l_mid    = 6.0; // Ø10.10 мм, дължина 6 мм
d_top    = d_top_nom * (1 + bearing_interference); l_top    = 7.0; // Ø8.08 мм, дължина 7 мм (за 2x3.5 мм лагера)
chamfer_mid = 0.50; // Скосяване на прехода от Ø10.10 към Ø8.08
chamfer_top = 0.25; // Минимална фаска на края на Ø8.08, за да не губим площ за втория лагер MR128
sleeve_total_h = l_flange + l_mid + l_top; // 15 мм

// Размер на квадратния отвор за втулката
hole_s2 = s2 + clearance; // 4.34 мм


// =========================================================================
// --- ПОМОЩНИ МОДУЛИ ---
// =========================================================================
module chamfered_box(s, h, clip) {
    diag_limit = s * sqrt(2) - 2 * clip;
    linear_extrude(height = h)
    intersection() {
        square([s, s], center = true);
        rotate([0, 0, 45])
            square([diag_limit, diag_limit], center = true);
    }
}

module dogbone_square_hole(s, h, db_d) {
    offset_pos = s / 2 - db_d / (2 * sqrt(2));
    
    translate([0, 0, -0.5])
    linear_extrude(height = h + 0.5)
    union() {
        square([s, s], center = true);
        for (dx = [-1, 1], dy = [-1, 1]) {
            translate([dx * offset_pos, dy * offset_pos])
                circle(d = db_d, $fn = 32);
        }
    }
}

module rounded_polygon_2d(n_sides, outer_r, corner_r, extra_offset = 0) {
    R_centers = max(0.05, outer_r - corner_r);
    eff_r = corner_r + extra_offset;
    rot_align = (n_sides == 3) ? 90 : 45;
    
    rotate([0, 0, rot_align])
    hull() {
        for (i = [0 : n_sides - 1]) {
            rotate([0, 0, i * 360 / n_sides])
            translate([R_centers, 0])
                circle(r = eff_r, $fn = 48);
        }
    }
}

module tapered_top_section(is_hole = false) {
    rad_off = is_hole ? (clearance / 2) : 0;
    z_bottom_ext = is_hole ? 0.5 : 0.01;
    pyr_h = is_hole ? h3_pyramid : (h3_pyramid - tip_z_play);
    eps = 0.01;
    
    union() {
        translate([0, 0, -z_bottom_ext])
        linear_extrude(height = h3_straight + z_bottom_ext)
            rounded_polygon_2d(top_profile_type, top_outer_r, top_corner_r, extra_offset = rad_off);
            
        hull() {
            translate([0, 0, h3_straight - eps])
            linear_extrude(height = eps)
                rounded_polygon_2d(top_profile_type, top_outer_r, top_corner_r, extra_offset = rad_off);
                
            translate([0, 0, h3_straight + pyr_h - eps])
            linear_extrude(height = eps)
                rounded_polygon_2d(top_profile_type, tip_outer_r, tip_corner_r, extra_offset = rad_off);
        }
    }
}

module maybe_cut(do_cut = false) {
    if (do_cut) {
        difference() {
            children();
            translate([-25, -50, -20]) cube([50, 50, 80]);
        }
    } else {
        children();
    }
}

// Помощен модул за визуализация на стандартен лагер
module dummy_bearing(id, od, w) {
    difference() {
        cylinder(d = od, h = w - 0.05);
        translate([0, 0, -0.5])
            cylinder(d = id, h = w + 1);
    }
}


// =========================================================================
// --- ОСНОВНИ ДЕТАЙЛИ ---
// =========================================================================

// 1. СТЪПАЛОВИДЕН ВАЛ
module stepped_square_shaft() {
    union() {
        // Секция 1 (Външна, за зъбното колело към гумите): Квадрат 5.65 мм (Z = 0 до 10)
        chamfered_box(s1, h1, corner_clip);
        
        // Секция 2 (Средна, 17 мм): Квадрат 4.24 мм (Z = 10 до 27)
        translate([0, 0, h1 - 0.01])
            chamfered_box(s2, h2 + 0.01, corner_clip);
            
        // Секция 3 (Вътрешна, 6 мм): Заоблен триъгълник с пирамида (Z = 27 до 33)
        translate([0, 0, h1 + h2])
            tapered_top_section(is_hole = false);
    }
}

// 2. ВТУЛКА ЗА ЛАГЕРИ (Моделирана от Z=0 до Z=15 с фланеца Ø12 на Z=0 за печат без подпори)
module bearing_sleeve() {
    difference() {
        union() {
            // 1. Праг Ø12 мм (дължина 2 мм: от 0 до 2)
            cylinder(d = d_flange, h = l_flange);
            
            // 2. Секция Ø10.10 мм за лагер 6700 във фланеца на диференциала (дължина 6 мм: от 2 до 8)
            translate([0, 0, l_flange - 0.01])
                cylinder(d = d_mid, h = l_mid - chamfer_mid + 0.01);
            translate([0, 0, l_flange + l_mid - chamfer_mid - 0.01])
                cylinder(d1 = d_mid, d2 = d_mid - 2*chamfer_mid, h = chamfer_mid + 0.01);
                
            // 3. Секция Ø8.08 мм за ДВА лагера MR128 (2 x 3.5 = 7 мм: от 8 до 15)
            translate([0, 0, l_flange + l_mid - 0.01])
                cylinder(d = d_top, h = l_top - chamfer_top + 0.01);
            translate([0, 0, sleeve_total_h - chamfer_top - 0.01])
                cylinder(d1 = d_top, d2 = d_top - 2*chamfer_top, h = chamfer_top + 0.01);
        }
        dogbone_square_hole(hole_s2, sleeve_total_h + 1, dogbone_d);
    }
}

// =========================================================================
// --- МОДУЛ ЗА ПОЛУОСКОВ МЕХАНИЗЪМ (С ОБЪРНАТА ВТУЛКА И 3 ЛАГЕРА) ---
// =========================================================================
module half_shaft_unit(exp = 0, cut = false) {
    // 1. Стъпаловиден вал (Z = 0 до Z = 33)
    color("Gold") 
        stepped_square_shaft();
    
    // 2. Втулка ОБЪРНАТА НАОПАКИ (ротация 180°):
    // При exp = 0: тесният край Ø8.08 опира в прага на квадрата на Z = 10 мм,
    // а широкият фланец Ø12 завършва на Z = 25 мм (остават точно 2 мм от вала между Z = 25 и Z = 27)!
    sleeve_top_z = h1 + sleeve_total_h + exp * 1.2; // 10 + 15 = 25 мм при exp = 0
    
    color("SteelBlue") 
    translate([0, 0, sleeve_top_z])
    rotate([180, 0, 0])
        maybe_cut(cut) bearing_sleeve();
        
    // Визуализация на трите лагера върху втулката (ако show_bearings = true)
    if (show_bearings) {
        // Лагер 1: 6700 (10x15x4) във фланеца на диференциала (опира под прага Ø12 на Z = 23..19)
        color("Silver", 0.55)
        translate([0, 0, sleeve_top_z - l_flange - 4.0])
            maybe_cut(cut) dummy_bearing(10.0, 15.0, 4.0);
            
        // Лагер 2 (вътрешен MR128: 8x12x3.5) в подпората (Z = 17..13.5)
        color("LightSlateGray", 0.65)
        translate([0, 0, sleeve_top_z - l_flange - l_mid - 3.5])
            maybe_cut(cut) dummy_bearing(8.0, 12.0, 3.5);
            
        // Лагер 3 (външен MR128: 8x12x3.5) в подпората (Z = 13.5..10.0)
        color("SlateGray", 0.65)
        translate([0, 0, sleeve_top_z - l_flange - l_mid - 7.0])
            maybe_cut(cut) dummy_bearing(8.0, 12.0, 3.5);
    }
}


// =========================================================================
// --- РЕНДЕРИРАНЕ СПОРЕД ИЗБРАНИЯ VIEW_MODE ---
// =========================================================================

if (view_mode == 1) {
    // РЕЖИМ 1: ХОРИЗОНТАЛНО СГЛОБЕНИ (по оста X, с лагерите)
    translate([-total_shaft_h / 2, 0, 0])
    rotate([0, 90, 0])
        half_shaft_unit(exp = 0, cut = cross_section);
}
else if (view_mode == 2) {
    // РЕЖИМ 2: ХОРИЗОНТАЛНО РАЗГЛОБЕНИ (Exploded View по оста X)
    translate([-(total_shaft_h + explode_dist) / 2, 0, 0])
    rotate([0, 90, 0])
        half_shaft_unit(exp = explode_dist, cut = cross_section);
}
else if (view_mode == 3) {
    // РЕЖИМ 3: ВЕРТИКАЛНО РАЗГЛОБЕНИ (по оста Z)
    half_shaft_unit(exp = explode_dist, cut = cross_section);
}
else if (view_mode == 4) {
    // РЕЖИМ 4: ВЕРТИКАЛНО СГЛОБЕНИ (по оста Z, с разрез и лагери)
    half_shaft_unit(exp = 0, cut = true);
}
else if (view_mode == 5) {
    // РЕЖИМ 5: КОМПЛЕКТ ЗА ПЕЧАТ НА Z = 0 (1 вал и 1 втулка)
    stepped_square_shaft();
    translate([18, 0, 0]) bearing_sleeve();
}
else if (view_mode == 6) {
    stepped_square_shaft();
}
else if (view_mode == 7) {
    bearing_sleeve();
}
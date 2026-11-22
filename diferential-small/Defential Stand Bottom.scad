// ============================================================================
// САМОСТОЯТЕЛЕН МОДЕЛ: ЗАОБЛЕНА П-ОБРАЗНА СТОЙКА (ДОЛНА ЧАСТ С КАПАК)
// - Вътрешен просвет между колонките: 41.8 mm (леглата съвпадат с лагерите MR128 на валовете,
//   0.9 mm хлабина до външните лица на фланците на касетата - обща дължина 40.0 mm)
// - Тънки вертикални подпори: 4.0 mm дебелина
// - Полу-шайби (полуцилиндрични босове) за лагерите MR128 (8x12x3.5 mm)
// - Външен аксиален упор (полу-праг ф10.0 mm)
// - Заоблен дизайн с 4 монтажни уши за болтове M3.5
// - Триъгълно оребряване (1 mm) на основата
// - Удължение на пода до шенкелите (шаси): език под долното ухо на шенкела (12.0 mm под оста
//   на колелото), лагерно тяло за MR128 на колелото Z=14 и площадка за скобата на горната панта
// - Скоба на горната панта: отделен детайл (stand_view = 1 / 2), L и R са огледални
// - 100% FDM принт без подпори
// ============================================================================

$fn = 90;

/* [Основни габарити на стойката] */
stand_inner_gap  = 41.8;  // Вътрешно разстояние между опорите: лагерите MR128 са на 21.0..28.0 mm от центъра
                          // -> легло 20.9..28.1 mm, праг 28.1..29.9 mm (виж "Square shaft small.scad")
stand_depth      = 28.0;  // Ширина на колонките по ос Y
stand_base_h     = 3.0;   // Обща дебелина на основната хоризонтална плоча
wheel_axis_drop  = 14.655; // Оста на колелото е под оста на диференциала (крайна предавка a_final
                           // в "Helical Gear Deferantial - New Small.scad": 1.2 * (12 + 0.25 * 0.85))
floor_below_wheel_axis = 12.0; // Горната повърхност на пода е ТОЧНО 12.0 mm под оста на колелото
stand_center_z   = stand_base_h + wheel_axis_drop + floor_below_wheel_axis;
                           // 3.0 + 14.655 + 12.0 = 29.655 mm от дъното (Z=0) до центъра на осите
                           // (линия на разделяне с капака)
stand_pillar_w   = 4.0;   // Тънка дебелина на вертикалните подпори (4.0 mm)

/* [Подсилващи полу-шайби (босове) за лагерите] */
boss_od          = 18.0;  // Външен диаметър на полу-шайбата около лагерното легло
stand_brg_d      = 12.10; // Диаметър на леглото за лагери D12 (0.10 mm толеранс)
stand_brg_seat_w = 7.20;  // Дължина на леглото (за 2 лагера x 3.5 mm = 7.0 mm)
stand_lip_w      = 1.80;  // Дебелина на външния праг (аксиален стопер за лагера)
stand_lip_d      = 10.00; // Проходен отвор ф10.0 mm в прага
total_boss_w     = stand_brg_seat_w + stand_lip_w; // 9.0 mm обща ширина на шайбата

/* [Триъгълно оребряване на основата] */
rib_depth        = 1.0;   // Дълбочина на триъгълното оребряване отгоре (последният 1.0 mm)
rib_wall         = 2.4;   // Дебелина на ребрата и външната рамка

/* [Заобляне и монтажни уши за M3.5] */
corner_r         = 4.0;   // Радиус на заобляне на вертикалните ръбове
corner_fillet_r  = 4.0;   // Вътрешно 45-градусово усилване в основата на колонките
ear_ext          = 12.0;  // Колко да излизат монтажните уши отстрани (по ос Y)
mount_hole_d     = 3.8;   // Проходен отвор ф3.8 mm за болт/винт M3.5
mount_boss_d     = 10.0;  // Външен диаметър на заобленото монтажно ухо

/* [УДЪЛЖЕНИЕ НА СТОЙКАТА (ШАСИ) ДО ШЕНКЕЛИТЕ] */
// Копия от "Helical Gear Deferantial - New Small.scad" (проверяват се там с ВНИМАНИЕ)
kingpin_from_center = 57.915; // Ос на завиване (шенкел) от центъра на касетата
                              // = 30.5 (вътрешно чело на Z=14) + 27.415 (полуоска-кучешка кост)
wheel_gear_outer_d  = 37.5;   // Външно чело на колелото Z=14 от центъра
wg_shoulder_h       = 1.0;    // Рамо ф9.4 на колелото Z=14 (опира във вътрешната гривна на MR128)

wheel_axis_z     = stand_base_h + floor_below_wheel_axis; // 15.0 mm - ос на колелото от дъното

ext_floor_w      = stand_depth;   // Ширина на удължението на пода (по Y)
ext_floor_end    = 3.0;   // Пълната ширина свършва на 3.0 mm навътре от оста на завиване
tongue_w         = 12.0;  // Език под долното ухо на шенкела
tongue_r         = 6.0;   // Радиус на заоблението на езика около оста на завиване
kingpin_hole_d   = 2.55;  // Отвор за резба M3 (метчик) в рамото на скобата - горният винт M3x8 е и щифт
                          // на горното ухо на шенкела
// Долна панта: стоманен щифт ф3 x 6 mm, набит отгоре в глух отвор в пода - НЕ излиза под пода
kp_pin_d         = 3.0;   // Щифт ф3 (влиза с хлабина в отвора ф4 на ухото на шенкела)
kp_pin_len       = 6.0;   // 2.6 mm в пода + 3.4 mm в ухото (връх на 8.6 mm от оста - извън лагерите ф15)
kp_pin_skin      = 0.4;   // Плътно дъно под глухия отвор (2 слоя)
kp_pin_depth     = stand_base_h - kp_pin_skin; // 2.6 mm дълбочина на глухия отвор
kp_pin_hole_d    = 3.0;   // Отвор за набиване (FDM отворите излизат ~0.1-0.15 mm по-малки)

// Лагерно тяло за MR128 (8x12x3.5) на главината на колелото Z=14 (без подпори - "капка" отгоре)
wb_brg_d         = 12.10;
wb_brg_w         = 3.60;
wb_lip_w         = 1.50;
wb_lip_d         = 10.00;
wb_od            = 16.0;
wb_x0            = wheel_gear_outer_d + wg_shoulder_h - 0.05; // 38.45 mm

/* [Скоба на горната панта (отделен детайл, L и R огледални)] */
// Локални координати: x = навътре от оста на завиване, y = настрани, z = над горната повърхност на пода
br_y0            = 13.0;  // Вътрешно лице на колонката (по Y)
br_t             = 6.0;   // Дебелина на колонката и стъпалото (по Y) - лицето y = 19 ляга на плочата
br_post_x        = [3.0, 9.0];
br_foot_x        = [3.0, 25.0];
br_foot_h        = 3.0;
br_arm_z0        = 2 * floor_below_wheel_axis + 0.3; // 24.3: 0.3 mm над горното ухо на шенкела
br_arm_h         = 4.0;
br_boss_r        = 5.0;
br_gusset        = 4.0;   // 45-градусово усилване между колонката и стъпалото (не пречи на главите на болтовете)
br_screw_x       = [16.5, 22.0];
br_screw_d       = 3.2;   // M3 + гайка под пода

/* [Изглед] */
// 0 = стойката (с удължението) | 1 = скоба L за печат | 2 = скоба R за печат
stand_view = 0;

// Достъп до размерите от други файлове (use <...> внася само модули и функции, не и променливи)
function stand_param(key) =
    let (t = [
        ["stand_center_z", stand_center_z], ["stand_inner_gap", stand_inner_gap],
        ["stand_base_h", stand_base_h], ["floor_below_wheel_axis", floor_below_wheel_axis],
        ["wheel_axis_drop", wheel_axis_drop], ["kingpin_from_center", kingpin_from_center],
        ["wheel_gear_outer_d", wheel_gear_outer_d], ["wg_shoulder_h", wg_shoulder_h],
        ["kp_pin_d", kp_pin_d], ["kp_pin_len", kp_pin_len], ["kp_pin_depth", kp_pin_depth]
    ], i = search([key], t)[0])
    assert(is_num(i), str("stand_param: непознат ключ ", key))
    t[i][1];

// ============================================================================
// РЕНДЕРИРАНЕ
// ============================================================================

if (stand_view == 0) diff_u_stand();
if (stand_view == 1) kingpin_bracket_print();
if (stand_view == 2) mirror([1, 0, 0]) kingpin_bracket_print();

// ============================================================================
// МОДУЛ НА СТОЙКАТА
// ============================================================================

module diff_u_stand() {
    // Обща дължина на основата включва подпорите от двете страни
    total_len = stand_inner_gap + 2 * total_boss_w; 
    ear_y     = stand_depth / 2 + ear_ext - mount_boss_d / 2;
    boss_overhang = total_boss_w - stand_pillar_w; // 5.0 mm издадена навън част на шайбата

    color("SteelBlue")
    difference() {
        // 1. ПОЗИТИВНО ТЯЛО (Всичко плътно до линията на осите Z = stand_center_z)
        union() {
            // А) Заоблена основна плоча (на Z = 0)
            hull() {
                for (dx = [-1, 1], dy = [-1, 1]) {
                    translate([
                        dx * (total_len / 2 - corner_r),
                        dy * (stand_depth / 2 - corner_r),
                        0
                    ])
                    cylinder(r = corner_r, h = stand_base_h);
                }
            }

            // Б) 4 заоблени монтажни уши отстрани (по ос Y)
            for (side_x = [-1, 1], side_y = [-1, 1]) {
                hull() {
                    translate([
                        side_x * (stand_inner_gap / 2 + total_boss_w / 2),
                        side_y * (stand_depth / 2 - corner_r),
                        0
                    ])
                    cylinder(d = mount_boss_d, h = stand_base_h);

                    translate([
                        side_x * (stand_inner_gap / 2 + total_boss_w / 2),
                        side_y * ear_y,
                        0
                    ])
                    cylinder(d = mount_boss_d, h = stand_base_h);
                }
            }

            // В) Лява и дясна вертикална подпора (4 мм дебелина) + полу-шайби за лагерите до Z = stand_center_z
            for (side = [-1, 1]) {
                // Основна тънка подпора (от вътрешния просвет 55мм навън с дебелина 4мм)
                hull() {
                    for (dx = [0, 1], dy = [-1, 1]) {
                        translate([
                            side * (stand_inner_gap / 2 + (dx == 0 ? 0 : stand_pillar_w)),
                            dy * (stand_depth / 2 - corner_r),
                            0
                        ])
                        cylinder(r = (dx == 0 ? 0.1 : corner_r), h = stand_center_z);
                    }
                }

                // Полу-шайба (бос) около лагерното легло (затворена до Z = stand_center_z).
                // Издадената навън част (извън 4 mm подпора) е подпряна отдолу под 45 deg
                // (hull с копие, свалено с размера на издаването) - печат без подпори.
                intersection() {
                    hull() {
                        translate([side * (stand_inner_gap / 2 + total_boss_w / 2), 0, stand_center_z])
                            rotate([0, 90, 0])
                                cylinder(d = boss_od, h = total_boss_w, center = true);

                        translate([side * (stand_inner_gap / 2 + stand_pillar_w / 2), 0, stand_center_z - boss_overhang])
                            rotate([0, 90, 0])
                                cylinder(d = boss_od, h = stand_pillar_w, center = true);
                    }
                    
                    // Ограничена само до долната половина (до линията на осите)
                    translate([side * (stand_inner_gap / 2 + total_boss_w / 2), 0, stand_center_z / 2])
                        cube([total_boss_w, stand_depth + 2, stand_center_z], center = true);
                }

                // Вътрешно 45-градусово скосяване в основата
                hull() {
                    for (dy = [-1, 1]) {
                        translate([
                            side * (stand_inner_gap / 2 + corner_r),
                            dy * (stand_depth / 2 - corner_r),
                            0
                        ])
                        cylinder(r = corner_r, h = stand_base_h + corner_fillet_r);

                        translate([
                            side * (stand_inner_gap / 2),
                            dy * (stand_depth / 2 - corner_r),
                            0
                        ])
                        cylinder(r = 0.1, h = stand_base_h);
                    }
                }
            }

            // Г) УДЪЛЖЕНИЕ ДО ШЕНКЕЛИТЕ (под + лагерно тяло на колелото Z=14), двете страни
            for (side = [-1, 1])
                mirror([side > 0 ? 1 : 0, 0, 0])
                    floor_extension_left(total_len);
        }

        // 2. ИЗРЯЗВАНИЯ И ОТВОРИ (НЕГАТИВ)

        // Отвори в удължението (лагерно легло MR128, отвор за пантата, отвори за скобата)
        for (side = [-1, 1])
            mirror([side > 0 ? 1 : 0, 0, 0])
                floor_extension_holes_left();
        
        // А) Полукръгли легла ф12.10 mm за лагерите (отворени отгоре на Z = stand_center_z)
        //    + външен праг ф10.0 mm (аксиален стопер откъм външната страна)
        for (side = [-1, 1]) {
            translate([side * (stand_inner_gap / 2 + stand_brg_seat_w / 2 - 0.05), 0, stand_center_z])
                rotate([0, 90, 0])
                    cylinder(d = stand_brg_d, h = stand_brg_seat_w + 0.1, center = true);

            translate([side * (stand_inner_gap / 2 + stand_brg_seat_w + stand_lip_w / 2), 0, stand_center_z])
                rotate([0, 90, 0])
                    cylinder(d = stand_lip_d, h = stand_lip_w + 1.0, center = true);
        }

        // Б) Изрязване на всичко над линията на осите (за да остане чисто долно П-образно тяло с полу-легла)
        translate([0, 0, stand_center_z + 50])
            cube([200, 200, 100], center = true);

        // В) 4 проходни отвора ф3.8 mm в ушите за болтове M3.5
        for (side_x = [-1, 1], side_y = [-1, 1]) {
            translate([
                side_x * (stand_inner_gap / 2 + total_boss_w / 2),
                side_y * ear_y,
                -1
            ])
            cylinder(d = mount_hole_d, h = stand_base_h + 2);
        }

        // Г) Триъгълно оребряване в последния 1.0 mm от горната страна на основата
        translate([0, 0, stand_base_h - rib_depth])
            linear_extrude(height = rib_depth + 0.1)
                triangular_floor_pockets();
    }
}

// ============================================================================
// УДЪЛЖЕНИЕ НА ПОДА ДО ШЕНКЕЛА (лявата страна, x < 0; дясната е огледална)
// ============================================================================

module floor_extension_left(total_len) {
    K = kingpin_from_center;

    // А) Под с пълна ширина до 3.0 mm преди оста на завиване
    hull()
        for (x = [-(total_len / 2 - corner_r), -(K - ext_floor_end - corner_r)], dy = [-1, 1])
            translate([x, dy * (ext_floor_w / 2 - corner_r), 0])
                cylinder(r = corner_r, h = stand_base_h);

    // Б) Език под долното ухо на шенкела (горната му повърхност е 12.0 mm под оста на колелото)
    hull() {
        translate([-K, 0, 0])
            cylinder(r = tongue_r, h = stand_base_h);
        translate([-(K - ext_floor_end - 2), -tongue_w / 2, 0])
            cube([2, tongue_w, stand_base_h]);
    }

    // В) Площадка за стъпалото на скобата на горната панта (+Y)
    hull()
        for (a = [br_foot_x[0] + 1, br_foot_x[1] - 1], y = [br_y0 + 1, br_y0 + br_t - 1])
            translate([-K + a, y, 0])
                cylinder(r = 2, h = stand_base_h);

    // Г) Лагерно тяло за MR128 на главината на колелото Z=14 (контур "капка" - без подпори)
    translate([-(wb_x0 + wb_brg_w + wb_lip_w), 0, 0])
        rotate([90, 0, 90])
            linear_extrude(height = wb_brg_w + wb_lip_w)
                hull() {
                    translate([0, wheel_axis_z]) teardrop_2d(wb_od / 2);
                    translate([-wb_od / 2, 0]) square([wb_od, stand_base_h]);
                }
}

module floor_extension_holes_left() {
    K = kingpin_from_center;

    // Легло ф12.10 за MR128 (вкарва се откъм колелото Z=14) + праг ф10.0 откъм шенкела
    translate([-(wb_x0 + wb_brg_w), 0, wheel_axis_z])
        rotate([90, 0, 90])
            linear_extrude(height = wb_brg_w + 0.1)
                teardrop_2d(wb_brg_d / 2);
    translate([-(wb_x0 + wb_brg_w + wb_lip_w + 0.5), 0, wheel_axis_z])
        rotate([90, 0, 90])
            linear_extrude(height = wb_lip_w + 1.0)
                teardrop_2d(wb_lip_d / 2);

    // Глух отвор отгоре за щифта ф3 на долната панта (0.4 mm плътно дъно - нищо не излиза отдолу)
    translate([-K, 0, stand_base_h - kp_pin_depth])
        cylinder(d = kp_pin_hole_d, h = kp_pin_depth + 1);

    // Отвори за двата болта M3 на скобата
    for (sx = br_screw_x)
        translate([-K + sx, br_y0 + br_t / 2, -1])
            cylinder(d = br_screw_d, h = stand_base_h + 2);
}

// Кръг с 45-градусов "покрив" (хоризонтални отвори без подпори)
module teardrop_2d(r) {
    hull() {
        circle(r = r);
        rotate(45) square([r, r]);
    }
}

// ============================================================================
// СКОБА НА ГОРНАТА ПАНТА НА ШЕНКЕЛА (отделен детайл, завинтва се за удължението)
// Локални координати: начало = ос на завиване на нивото на горната повърхност на пода,
// +x = навътре към диференциала. Скобата R е огледална на L.
// ============================================================================

module kingpin_bracket() {
    post_w = br_post_x[1] - br_post_x[0];
    color("Peru")
    difference() {
        union() {
            // Колонка
            translate([br_post_x[0], br_y0, 0])
                cube([post_w, br_t, br_arm_z0 + br_arm_h]);

            // Стъпало с 2 отвора M3
            translate([br_foot_x[0], br_y0, 0])
                cube([br_foot_x[1] - br_foot_x[0], br_t, br_foot_h]);

            // 45-градусово усилване колонка-стъпало
            hull() {
                translate([br_post_x[0], br_y0, 0])
                    cube([post_w, br_t, br_foot_h + br_gusset]);
                translate([br_post_x[0], br_y0, 0])
                    cube([post_w + br_gusset, br_t, br_foot_h]);
            }

            // Горно рамо с бос над горното ухо на шенкела
            hull() {
                translate([0, 0, br_arm_z0])
                    cylinder(r = br_boss_r, h = br_arm_h);
                translate([br_post_x[0], br_y0, br_arm_z0])
                    cube([post_w, br_t, br_arm_h]);
            }
        }

        // Отвор за резба M3 на пантата (винт M3x8 отгоре)
        translate([0, 0, br_arm_z0 - 1])
            cylinder(d = kingpin_hole_d, h = br_arm_h + 2);

        // Отвори за болтовете M3 на стъпалото
        for (sx = br_screw_x)
            translate([sx, br_y0 + br_t / 2, -1])
                cylinder(d = br_screw_d, h = br_foot_h + 2);
    }
}

// За печат: ляга на външното лице на колонката (y = 19) - без подпори
module kingpin_bracket_print() {
    translate([0, 0, br_y0 + br_t])
        rotate([-90, 0, 0])
            kingpin_bracket();
}

// Двете скоби, разположени в координатите на стойката
module chassis_brackets() {
    for (side = [-1, 1])
        mirror([side > 0 ? 1 : 0, 0, 0])
            translate([-kingpin_from_center, 0, stand_base_h])
                kingpin_bracket();
}

// ============================================================================
// ПОМОЩЕН МОДУЛ ЗА ТРИЪГЪЛНИТЕ ДЖОБОВЕ НА ОСНОВАТА
// ============================================================================

module triangular_floor_pockets() {
    bay_x = stand_inner_gap - 2 * rib_wall;
    bay_y = stand_depth - 2 * rib_wall;
    cells = 3; 
    cell_w = bay_x / cells;

    offset(r = 0.8) offset(r = -0.8) 
    difference() {
        square([bay_x, bay_y], center = true);

        for (i = [0 : cells - 1]) {
            cx = -bay_x / 2 + (i + 0.5) * cell_w;
            translate([cx, 0]) {
                for (ang = [atan2(bay_y, cell_w), -atan2(bay_y, cell_w)]) {
                    rotate([0, 0, ang])
                        square([sqrt(cell_w * cell_w + bay_y * bay_y) + 2, rib_wall], center = true);
                }
            }
            if (i > 0) {
                translate([-bay_x / 2 + i * cell_w, 0])
                    square([rib_wall, bay_y + 2], center = true);
            }
        }
    }
}
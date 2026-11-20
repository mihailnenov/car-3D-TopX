// ============================================================================
// САМОСТОЯТЕЛЕН МОДЕЛ: ЗАОБЛЕНА П-ОБРАЗНА СТОЙКА (ДОЛНА ЧАСТ С КАПАК)
// - Вътрешен просвет между колонките: ТОЧНО 55.0 mm (напълно свободен от стени)
// - Тънки вертикални подпори: 4.0 mm дебелина
// - Полу-шайби (полуцилиндрични босове) за лагерите MR128 (8x12x3.5 mm)
// - Външен аксиален упор (полу-праг ф10.0 mm)
// - Заоблен дизайн с 4 монтажни уши за болтове M3.5
// - Триъгълно оребряване (1 mm) на основата
// - 100% FDM принт без подпори
// ============================================================================

$fn = 90;

/* [Основни габарити на стойката] */
stand_inner_gap  = 55.0;  // Вътрешно разстояние между двете опори (55.0 mm)
stand_depth      = 28.0;  // Ширина на колонките по ос Y
stand_base_h     = 3.0;   // Обща дебелина на основната хоризонтална плоча
stand_center_z   = 22.0;  // Височина от дъното (Z=0) до центъра на осите (линия на разделяне с капака)
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

// ============================================================================
// РЕНДЕРИРАНЕ
// ============================================================================

diff_u_stand();

// ============================================================================
// МОДУЛ НА СТОЙКАТА
// ============================================================================

module diff_u_stand() {
    // Обща дължина на основата включва подпорите от двете страни
    total_len = stand_inner_gap + 2 * total_boss_w; 
    ear_y     = stand_depth / 2 + ear_ext - mount_boss_d / 2;

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

                // Полу-шайба (бос) около лагерното легло (затворена до Z = stand_center_z)
                intersection() {
                    translate([side * (stand_inner_gap / 2 + total_boss_w / 2), 0, stand_center_z])
                        rotate([0, 90, 0])
                            cylinder(d = boss_od, h = total_boss_w, center = true);
                    
                    // Ограничена само до долната половина (до линията на осите)
                    translate([side * (stand_inner_gap / 2 + total_boss_w / 2), 0, stand_center_z / 2])
                        cube([total_boss_w + 2, stand_depth + 2, stand_center_z], center = true);
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
        }

        // 2. ИЗРЯЗВАНИЯ И ОТВОРИ (НЕГАТИВ)
        
        // А) Полукръгли легла ф12.10 mm за лагерите (отворени отгоре на Z = stand_center_z)
        for (side = [-1, 1]) {
            translate([side * (stand_inner_gap / 2 + total_boss_w / 2), 0, stand_center_z])
                rotate([0, 90, 0])
                    cylinder(d = stand_brg_d, h = total_boss_w + 0.1, center = true);

            translate([side * (stand_inner_gap / 2 + total_boss_w + stand_lip_w / 2 - total_boss_w), 0, stand_center_z])
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
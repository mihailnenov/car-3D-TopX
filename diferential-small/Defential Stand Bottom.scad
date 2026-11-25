// ============================================================================
// САМОСТОЯТЕЛЕН МОДЕЛ: ШАСИ С ПОВДИГНАТ ЦЕНТЪР + ОТДЕЛНИ ЛАГЕРНИ СТОЙКИ
// - Повдигната централна плоча под диференциала: center_raise = 6.5 mm (13.0 mm
//   просвет над земята, 2.75 mm хлабина до венеца Z=27), свързана с ниските
//   странични крила (Z = 0..3 mm) чрез 2 наклонени рампи около колелата Z=14
// - Отделни големи лагерни стойки за 2x MR128 на полуоските (stand_view = 4, 2 бр.):
//   полукръгли легла, отворени отгоре (обхващат долната половина на лагерите H8xD12),
//   влизат с правоъгълен шип в канали в повдигнатия център и се завинтват с 2x M3
//   (отвори ф3.4 mm в крилцата -> ф2.65 mm в шасито)
// - Отделни малки лагерни стойки за MR128 на колелата Z=14 (stand_view = 3, 2 бр.)
// - Скоба на горната панта: отделен детайл (stand_view = 1 / 2), L и R са огледални
// - Триъгълно оребряване (1 mm) на повдигнатата основа
// - 100% FDM принт без подпори
// ============================================================================

$fn = 90;

/* [Основни габарити на стойката] */
stand_inner_gap  = 41.8;  // Вътрешно разстояние между опорите: лагерите MR128 са на 21.0..28.0 mm от центъра
                          // -> легло 20.9..28.1 mm, праг 28.1..29.9 mm (виж "Square shaft small.scad")
stand_depth      = 28.0;  // Ширина на централната част и удълженията по ос Y
stand_base_h     = 3.0;   // Дебелина на основната плоча
center_raise     = 6.5;   // Повдигане на централната част под диференциала (Z = 6.5..9.5 mm ->
                          // 13.0 mm просвет над земята, 2.75 mm до долния ръб на венеца Z=27)
wheel_axis_drop  = 14.655; // Оста на колелото е под оста на диференциала (крайна предавка a_final
                           // в "Helical Gear Deferantial - New Small.scad": 1.2 * (12 + 0.25 * 0.85))
floor_below_wheel_axis = 12.0; // Горната повърхност на ниския под е ТОЧНО 12.0 mm под оста на колелото
stand_center_z   = stand_base_h + wheel_axis_drop + floor_below_wheel_axis;
                           // 3.0 + 14.655 + 12.0 = 29.655 mm от долното ниво (Z=0) до оста на диференциала

/* [Отделни лагерни стойки за 2x MR128 на полуоските (диференциала)] */
// (влизат в правоъгълен канал в повдигнатия център и се завинтват с 2x M3 през крилцата)
boss_od           = 18.0;  // Външен диаметър на полукръглото легло около лагерите 2x MR128 (срязано на Z = stand_center_z)
stand_brg_d       = 12.10; // Полукръгло легло за 2x MR128 (0.10 mm толеранс)
stand_brg_seat_w  = 7.20;  // Дължина на леглото (за 2 лагера x 3.5 mm = 7.0 mm)
stand_lip_w       = 1.80;  // Външен аксиален борд (стопер за лагера)
stand_lip_d       = 10.00; // Проходен полукръгъл отвор ф10.0 mm в борда
total_boss_w      = stand_brg_seat_w + stand_lip_w; // 9.0 mm обща дебелина на стойката
db_tab_w          = 14.0;  // Ширина на правоъгълния шип (по Y), влизащ в канала на шасито
db_tab_bottom_clr = 0.10;  // 0.1 mm над долната равнина на повдигнатия център (да не стърчи отдолу)
db_slot_clr       = 0.10;  // Хлабина по стените на канала (+0.20 mm общо)
db_wing_h         = 3.0;   // Дебелина на крилцата (лягат отгоре на повдигнатия под Z = 9.5..12.5)
db_wing_half_y    = 13.8;  // Полуширина на крилцата по Y (в рамките на stand_depth/2 = 14.0 mm)
db_wing_hole_y    = 10.8;  // Междуосие на отворите за M3: +/-10.8 mm (21.6 mm)
db_wing_hole_d    = 3.4;   // Проходен отвор ф3.4 mm в крилцата
db_tap_d          = 2.65;  // Отвор ф2.65 mm в шасито за резба M3

/* [Триъгълно оребряване на основата] */
rib_depth        = 1.0;   // Дълбочина на триъгълното оребряване отгоре (последният 1.0 mm)
rib_wall         = 2.4;   // Дебелина на ребрата и външната рамка

/* [Заобляне и монтажни уши за M3] */
corner_r         = 4.0;   // Радиус на заобляне на вертикалните ръбове
ear_ext          = 12.0;  // Колко да излизат монтажните уши отстрани (по ос Y)
mount_hole_d     = 2.65;  // Отвор ф2.65 mm за резба M3 (за горен преходен отвор ф3.4 mm в капак/детайл)
mount_boss_d     = 10.0;  // Външен диаметър на заобленото монтажно ухо

/* [Фаски за болтове M3 (скрита глава и водене на метчик)] */
m3_cs_top_d   = 5.4;  // Горен диаметър на конусната фаска (за глава ф5.2 mm с +0.2 mm хлабина)
m3_cs_depth   = 1.65; // Дълбочина на фаската (за глава с височина 1.6 mm -> ляга напълно наравно)
m3_tap_chamf  = 0.4;  // Водеща фаска 0.4 mm x 45° на входа на отворите ф2.65 mm за метчик M3

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
kingpin_hole_d   = 2.65;  // Отвор за резба M3 (метчик) в рамото на скобата - горният винт M3x8 е и щифт
                          // на горното ухо на шенкела
// Долна панта: стоманен щифт ф3 x 6 mm, набит отгоре в глух отвор в пода - НЕ излиза под пода
kp_pin_d         = 3.0;   // Щифт ф3 (влиза с хлабина в отвора ф4 на ухото на шенкела)
kp_pin_len       = 6.0;   // 2.6 mm в пода + 3.4 mm в ухото (връх на 8.6 mm от оста - извън лагерите ф15)
kp_pin_skin      = 0.4;   // Плътно дъно под глухия отвор (2 слоя)
kp_pin_depth     = stand_base_h - kp_pin_skin; // 2.6 mm дълбочина на глухия отвор
kp_pin_hole_d    = 3.0;   // Отвор за набиване (FDM отворите излизат ~0.1-0.15 mm по-малки)

// Отделна лагерна стойка за MR128 (8x12x3.5) на главината на колелото Z=14
// (влиза в правоъгълен канал в пода и се завинтва с 2x M3 през крилцата)
wb_brg_d          = 12.10; // Легло за MR128 (кръгло, печата се вертикално без подпори)
wb_brg_w          = 3.60;  // Дълбочина на леглото (лагерът е 3.5 mm)
wb_lip_w          = 2.90;  // Външен аксиален борд (обща дебелина 6.50 mm -> 1.55 mm стена около отвора ф3.4)
wb_lip_d          = 10.00; // Проходен отвор ф10.0 mm в борда
wb_total_w        = wb_brg_w + wb_lip_w; // 6.50 mm
wb_od             = 16.0;  // Закръглен външен диаметър около лагера (без заостряне)
wb_x0             = wheel_gear_outer_d + wg_shoulder_h - 0.05; // 38.45 mm (вътрешно лице към Z=14)
wb_tab_w          = 12.0;  // Ширина на правоъгълния шип (по Y), влизащ в канала на шасито
wb_tab_bottom_clr = 0.10;  // 0.1 mm отстояние от долната равнина Z=0 (да не стърчи под шасито)
wb_slot_clr       = 0.10;  // Хлабина по стените на правоъгълния канал в шасито (+0.20 mm общо)
wb_wing_h         = 3.0;   // Дебелина на крилцата (лягат отгоре на пода Z = 3.0..6.0)
wb_wing_half_y    = 12.8;  // Полуширина на крилцата по Y (0.2 mm хлабина до стъпалото на скобата y=13.0)
wb_wing_hole_y    = 9.8;   // Междуосие на отворите за M3: +/-9.8 mm (19.6 mm)
wb_wing_hole_d    = 3.4;   // Проходен отвор ф3.4 mm в крилцата
wb_tap_d          = 2.65;  // Отвор ф2.65 mm в шасито за нарязване на резба M3

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
br_screw_d       = 3.4;   // Проходен отвор ф3.4 mm в стъпалото на скобата за M3
br_tap_d         = 2.65;  // Отвор ф2.65 mm в шасито за нарязване на резба M3

/* [Изглед] */
// 0 = само шасито (повдигнат център + канали + отвори ф2.65 mm) - за печат
// 1 = само скоба L - за печат
// 2 = само скоба R - за печат
// 3 = само малката лагерна стойка MR128 (колело Z=14) - за печат (2 еднакви броя)
// 4 = само голямата лагерна стойка 2x MR128 (диференциал) - за печат (2 еднакви броя)
// 5 = сглобен изглед (шаси + 2 скоби + 2 малки + 2 големи лагерни стойки)
// 6 = разглобен изглед (повдигнати скоби и лагерни стойки, за преглед на каналите)
stand_view = 5;

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
if (stand_view == 3) wheel_bearing_block_print();
if (stand_view == 4) diff_bearing_block_print();
if (stand_view == 5) {
    diff_u_stand();
    chassis_brackets();
    chassis_wheel_bearing_blocks();
    chassis_diff_bearing_blocks();
}
if (stand_view == 6) {
    diff_u_stand();
    translate([0, 0, 14]) {
        chassis_brackets();
        chassis_wheel_bearing_blocks();
        chassis_diff_bearing_blocks();
    }
}

// ============================================================================
// МОДУЛ НА ШАСИТО С ПОВДИГНАТ ЦЕНТЪР И КАНАЛИ ЗА ЛАГЕРНИТЕ СТОЙКИ
// ============================================================================

module diff_u_stand() {
    // Обща дължина на повдигнатия център включва зоните на двете големи стойки (59.8 mm)
    total_len = stand_inner_gap + 2 * total_boss_w;
    ear_y     = stand_depth / 2 + ear_ext - mount_boss_d / 2;

    color("SteelBlue")
    difference() {
        // 1. ПОЗИТИВНО ТЯЛО
        union() {
            // А) Повдигната централна плоча (Z = center_raise .. center_raise + stand_base_h)
            translate([-total_len / 2, -stand_depth / 2, center_raise])
                cube([total_len, stand_depth, stand_base_h]);

            // Б) 4 заоблени монтажни уши отстрани (на нивото на повдигнатия център)
            for (side_x = [-1, 1], side_y = [-1, 1]) {
                hull() {
                    translate([
                        side_x * (stand_inner_gap / 2 + total_boss_w / 2),
                        side_y * (stand_depth / 2 - corner_r),
                        center_raise
                    ])
                    cylinder(d = mount_boss_d, h = stand_base_h);

                    translate([
                        side_x * (stand_inner_gap / 2 + total_boss_w / 2),
                        side_y * ear_y,
                        center_raise
                    ])
                    cylinder(d = mount_boss_d, h = stand_base_h);
                }
            }

            // В) Удължения до шенкелите + две 41° странични рампи покрай отвора за колелото Z=14
            for (side = [-1, 1])
                mirror([side > 0 ? 1 : 0, 0, 0])
                    floor_extension_left(total_len);
        }

        // 2. ИЗРЯЗВАНИЯ И ОТВОРИ (НЕГАТИВ)

        // А) Канали и M3 отвори ф2.65 mm за двете големи лагерни стойки на диференциала
        for (side = [-1, 1]) {
            translate([side * (stand_inner_gap / 2 + total_boss_w / 2), 0, center_raise + stand_base_h / 2])
                cube([total_boss_w + 2 * db_slot_clr, db_tab_w + 2 * db_slot_clr, stand_base_h + 2], center = true);

            for (sy = [-1, 1])
                translate([side * (stand_inner_gap / 2 + total_boss_w / 2), sy * db_wing_hole_y, center_raise])
                    m3_tapped_hole(db_tap_d, stand_base_h);
        }

        // Б) Отвори в удълженията (правоъгълен канал + ф2.65 за стойката MR128, отвор за пантата, отвори ф2.65 за скобата)
        for (side = [-1, 1])
            mirror([side > 0 ? 1 : 0, 0, 0])
                floor_extension_holes_left();

        // В) 4 отвора ф2.65 mm в ушите за нарязване на резба M3
        for (side_x = [-1, 1], side_y = [-1, 1]) {
            translate([
                side_x * (stand_inner_gap / 2 + total_boss_w / 2),
                side_y * ear_y,
                center_raise
            ])
            m3_tapped_hole(mount_hole_d, stand_base_h);
        }

        // Г) Триъгълно оребряване в последния 1.0 mm от горната страна на повдигнатия център
        translate([0, 0, center_raise + stand_base_h - rib_depth])
            linear_extrude(height = rib_depth + 0.1)
                triangular_floor_pockets();
    }
}

// ============================================================================
// УДЪЛЖЕНИЕ НА ПОДА ДО ШЕНКЕЛА (лявата страна, x < 0; дясната е огледална)
// ============================================================================

module floor_extension_left(total_len) {
    K = kingpin_from_center;
    ramp_x_top = total_len / 2;                // 29.9 mm (край на повдигнатия център)
    ramp_x_bot = ramp_x_top + center_raise;    // 36.4 mm (начало на ниския под)

    // А) Нисък под с пълна ширина (Z = 0..stand_base_h) от ramp_x_bot до 3.0 mm преди оста на завиване
    hull()
        for (x = [-(ramp_x_bot + corner_r), -(K - ext_floor_end - corner_r)], dy = [-1, 1])
            translate([x, dy * (ext_floor_w / 2 - corner_r), 0])
                cylinder(r = corner_r, h = stand_base_h);
    // Право завършване към рампите при x = -ramp_x_bot
    translate([-(ramp_x_bot + corner_r), -ext_floor_w / 2, 0])
        cube([corner_r, ext_floor_w, stand_base_h]);

    // Б) Две наклонени (~41°) странични рампи покрай отвора за колелото Z=14
    //    (|Y| > 10.2 mm: заобикалят зъбите на Z=14 при |Y| <= 9.6 mm; +Y рампата спира на 12.8 mm до скобата)
    for (r = [[-ext_floor_w / 2, ext_floor_w / 2 - 10.2], [10.2, br_y0 - 0.2 - 10.2]])
        hull() {
            translate([-ramp_x_top, r[0], center_raise])
                cube([1.0, r[1], stand_base_h]);
            translate([-(ramp_x_bot + 1.0), r[0], 0])
                cube([1.0, r[1], stand_base_h]);
        }
}

module floor_extension_holes_left() {
    K = kingpin_from_center;

    // Правоъгълен проходен канал за шипа на отделната лагерна стойка MR128
    translate([-(wb_x0 + wb_total_w / 2), 0, stand_base_h / 2])
        cube([wb_total_w + 2 * wb_slot_clr, wb_tab_w + 2 * wb_slot_clr, stand_base_h + 2], center = true);

    // 2x отвора ф2.65 mm за резба M3 (завинтване на крилцата на лагерната стойка)
    for (sy = [-1, 1])
        translate([-(wb_x0 + wb_total_w / 2), sy * wb_wing_hole_y, 0])
            m3_tapped_hole(wb_tap_d, stand_base_h);

    // Глух отвор отгоре за щифта ф3 на долната панта (0.4 mm плътно дъно - нищо не излиза отдолу)
    translate([-K, 0, stand_base_h - kp_pin_depth])
        cylinder(d = kp_pin_hole_d, h = kp_pin_depth + 1);

    // Отвори ф2.65 mm за нарязване на резба M3 в шасито (за двата болта на скобата)
    for (sx = br_screw_x)
        translate([-K + sx, br_y0 + br_t / 2, 0])
            m3_tapped_hole(br_tap_d, stand_base_h);
}

// ============================================================================
// ОТДЕЛНА ЛАГЕРНА СТОЙКА ЗА MR128 НА КОЛЕЛОТО Z=14 (симетрична: 2 еднакви броя)
// Локални координати: x = 0..wb_total_w (x=0 е външният борд, x=wb_total_w е входът
// за MR128 към Z=14), y = 0 е оста, z = 0 е дъното на шасито.
// ============================================================================
module wheel_bearing_block() {
    color("DarkCyan")
    difference() {
        // Позитивно тяло: плосък 2D профил в равнината Y-Z, екструдиран по X (0..wb_total_w)
        // rotate([90, 0, 90]) мапва 2D (u, v) -> (Y, Z) и екструзията -> +X
        rotate([90, 0, 90])
            linear_extrude(height = wb_total_w)
                union() {
                    // Закръглен връх около лагера MR128
                    translate([0, wheel_axis_z])
                        circle(d = wb_od);

                    // Право стъбло от пода до центъра на лагера + шип в канала на шасито
                    translate([-wb_tab_w / 2, wb_tab_bottom_clr])
                        square([wb_tab_w, wheel_axis_z - wb_tab_bottom_clr]);

                    // Крилца, лягащи отгоре на пода (Z = stand_base_h .. stand_base_h + wb_wing_h)
                    translate([-wb_wing_half_y, stand_base_h])
                        square([2 * wb_wing_half_y, wb_wing_h]);
                }

        // А) Кръгло легло ф12.10 mm за MR128 (влиза откъм x = wb_total_w, дълбочина wb_brg_w)
        translate([wb_lip_w, 0, wheel_axis_z])
            rotate([0, 90, 0])
                cylinder(d = wb_brg_d, h = wb_brg_w + 0.5);

        // Лека водеща фаска 0.25 mm на входа на леглото за MR128
        translate([wb_total_w - 0.25, 0, wheel_axis_z])
            rotate([0, 90, 0])
                cylinder(d1 = wb_brg_d, d2 = wb_brg_d + 0.4, h = 0.25 + 0.05);

        // Б) Проходен кръгъл отвор ф10.0 mm през външния борд
        translate([-0.5, 0, wheel_axis_z])
            rotate([0, 90, 0])
                cylinder(d = wb_lip_d, h = wb_lip_w + 1.0);

        // В) 2x проходни отвора ф3.4 mm в крилцата за болтове M3 (със скрита фаска)
        for (sy = [-1, 1])
            translate([wb_total_w / 2, sy * wb_wing_hole_y, stand_base_h])
                m3_countersunk_hole(wb_wing_hole_d, wb_wing_h);
    }
}

// За 3D печат без подпори: ляга плоско на външното лице x=0 (бордът е отдолу, леглото ф12.10 нагоре)
module wheel_bearing_block_print() {
    translate([wheel_axis_z, 0, 0])
        rotate([0, -90, 0])
            wheel_bearing_block();
}

// Двете лагерни стойки, разположени в координатите на шасито
module chassis_wheel_bearing_blocks() {
    for (side = [-1, 1])
        mirror([side > 0 ? 1 : 0, 0, 0])
            translate([-(wb_x0 + wb_total_w), 0, 0])
                wheel_bearing_block();
}

// ============================================================================
// ОТДЕЛНА ГОЛЯМА ЛАГЕРНА СТОЙКА ЗА 2x MR128 НА ДИФЕРЕНЦИАЛА (2 еднакви броя)
// Локални координати: x = 0..total_boss_w (x=0 е външният борд ф10, x=total_boss_w
// е входът за 2x MR128 към диференциала), y = 0 е оста, z = 0 е дъното на шасито.
// ============================================================================
module diff_bearing_block() {
    deck_top = center_raise + stand_base_h; // 9.50 mm
    color("RoyalBlue")
    difference() {
        rotate([90, 0, 90])
            linear_extrude(height = total_boss_w)
                union() {
                    // Външен контур около 2x MR128 (над Z = stand_center_z се изрязва до полукръг)
                    translate([0, stand_center_z])
                        circle(d = boss_od);

                    // Право стъбло до центъра на лагерите + шип в канала на повдигнатия център
                    translate([-db_tab_w / 2, center_raise + db_tab_bottom_clr])
                        square([db_tab_w, stand_center_z - (center_raise + db_tab_bottom_clr)]);

                    // Крилца, лягащи отгоре на повдигнатия център (Z = deck_top .. deck_top + db_wing_h)
                    translate([-db_wing_half_y, deck_top])
                        square([2 * db_wing_half_y, db_wing_h]);
                }

        // А) Полукръгло легло ф12.10 mm за 2x MR128 (влиза откъм x = total_boss_w, дълбочина 7.20 mm)
        translate([stand_lip_w, 0, stand_center_z])
            rotate([0, 90, 0])
                cylinder(d = stand_brg_d, h = stand_brg_seat_w + 0.5);

        // Лека водеща фаска 0.25 mm на входа на леглото
        translate([total_boss_w - 0.25, 0, stand_center_z])
            rotate([0, 90, 0])
                cylinder(d1 = stand_brg_d, d2 = stand_brg_d + 0.4, h = 0.25 + 0.05);

        // Б) Проходен полукръгъл отвор ф10.0 mm през външния борд
        translate([-0.5, 0, stand_center_z])
            rotate([0, 90, 0])
                cylinder(d = stand_lip_d, h = stand_lip_w + 1.0);

        // В) 2x проходни отвора ф3.4 mm в крилцата за болтове M3 (със скрита фаска)
        for (sy = [-1, 1])
            translate([total_boss_w / 2, sy * db_wing_hole_y, deck_top])
                m3_countersunk_hole(db_wing_hole_d, db_wing_h);

        // Г) Срязване над оста (Z = stand_center_z), за да остане полукръгло легло (обхваща долната половина на 2x MR128)
        translate([-1, -boss_od, stand_center_z])
            cube([total_boss_w + 2, 2 * boss_od, boss_od]);
    }
}

// За 3D печат без подпори: ляга плоско на външното лице x=0 (бордът е отдолу, леглото ф12.10 нагоре)
module diff_bearing_block_print() {
    translate([stand_center_z, 0, 0])
        rotate([0, -90, 0])
            diff_bearing_block();
}

// Двете големи лагерни стойки, разположени в координатите на шасито
module chassis_diff_bearing_blocks() {
    for (side = [-1, 1])
        mirror([side > 0 ? 1 : 0, 0, 0])
            translate([-(stand_inner_gap / 2 + total_boss_w), 0, 0])
                diff_bearing_block();
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

        // Отвор за резба M3 на пантата (винт M3x8 отгоре, с водеща фаска 0.4 mm за метчика)
        translate([0, 0, br_arm_z0])
            m3_tapped_hole(kingpin_hole_d, br_arm_h);

        // Отвори за болтовете M3 на стъпалото (със скрита фаска)
        for (sx = br_screw_x)
            translate([sx, br_y0 + br_t / 2, 0])
                m3_countersunk_hole(br_screw_d, br_foot_h);
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
// ПОМОЩНИ МОДУЛИ ЗА ОТВОРИ M3 (СКРИТА ГЛАВА И ВОДЕЩА ФАСКА ЗА МЕТЧИК)
// ============================================================================

// Проходен отвор (z = 0..h) с конусна фаска отгоре за скрита глава M3 (ф5.2 x 1.6 mm)
module m3_countersunk_hole(hole_d, h) {
    eps = 0.05;
    d_top_ext = m3_cs_top_d + (m3_cs_top_d - hole_d) * (eps / m3_cs_depth);
    translate([0, 0, -1])
        cylinder(d = hole_d, h = h + 2);
    translate([0, 0, h - m3_cs_depth])
        cylinder(d1 = hole_d, d2 = d_top_ext, h = m3_cs_depth + eps);
}

// Отвор за резба M3 (z = 0..h) с водеща фаска 0.4 mm x 45° отгоре за подвеждане на метчика
module m3_tapped_hole(hole_d, h) {
    eps = 0.05;
    translate([0, 0, -1])
        cylinder(d = hole_d, h = h + 2);
    translate([0, 0, h - m3_tap_chamf])
        cylinder(d1 = hole_d, d2 = hole_d + 2 * (m3_tap_chamf + eps), h = m3_tap_chamf + eps);
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
// =========================================================================
// ЦЯЛОСТЕН ПРЕДЕН МОСТ (РЕВИЗИЯ С РАЗШИРЕНА СЛЕДА И ВИСОК ПРОСВЕТ)
// Параметри:
// - Колела: OD = 43.0 мм, Барабан ID = 27.0 мм, Ширина = 20.0 мм
// - Диференциал: Корона Z=45 (OD=47мм), Пиньон Z=15 (OD=17мм), Повдигане Z = +9.5 мм
// - Междуосие на пантите (Kingpin Track): 144.0 мм (kingpin_x = 72.0 мм)
// - Ъгъл на наклон на полуоските: 10.0 градуса (дължина център-център: 54.83 мм)
// - Лагери: 6x (10x15x4), 2x (8x12x3.5), 4x (3x8x4)
// =========================================================================

$fn = 64;

// --- ИЗБОР НА ДЕТАЙЛ ЗА ПРИНТИРАНЕ ИЛИ СГЛОБКА ---
// 0 = ПЪЛНА СГЛОБКА С АНИМАЦИЯ (View -> Animate, напр. FPS: 30, Steps: 100)
// 1 = Само Предна Подрама (Front Subframe Chassis) - 156мм ширина (за принт)
// 2 = Само Кормилна Рейка (Steering Tie-Rod Bar) - (за принт)
// 3 = Само Завиващ Шенкел (Steering Knuckle - принтират се 2 бр., симетричен)
// 4 = Само Главина с чашка (Wheel Hub Cup - принтират се 2 бр., без подпори)
// 5 = Само Двойна Полуоска (Double Dogbone Shaft - принтират се 2 бр.)
part_select = 5;

// --- АНИМАЦИОННИ ПРОМЕНЛИВИ ---
steer_deg   = ($t > 0) ? 20 * sin($t * 360) : 16;  // Завиване наляво-надясно (+/- 20°)
wheel_spin  = ($t > 0) ? $t * 360 * 2 : 0;         // Въртене на колелата и диференциала
pinion_spin = wheel_spin * 3;                      // Предавателно отношение 45/15 = 3:1

// --- ОСНОВНИ ГЕОМЕТРИЧНИ КОНСТАНТИ ---
tol = 0.15;                // Стандартен толеранс за Prusa MINI+

kingpin_x     = 72.0;      // Разстояние от центъра (X=0) до оста на завиване (общо 144 мм)
diff_cup_x    = 18.0;      // Център на вътрешните чашки в диференциала (X = +/- 18 мм)
dogbone_l     = kingpin_x - diff_cup_x; // Хоризонтална проекция = 54.0 мм
diff_z_offset = 9.5;       // Повдигане на диференциала (+9.5 мм -> 7.5 мм просвет под короната!)

// Размери на диференциала (от предходния проект)
ring_od   = 47.0;          // Венечно колело m=1.0, Z=45
ring_w    = 8.0;
carrier_d = 43.0;          // Фланец на касетата (с 3x M3.5 на R=18.5 мм)
pinion_od = 17.0;          // Пиньон m=1.0, Z=15
pinion_y  = -30.0;         // Междуцентрово разстояние (45+15)/2 = 30.0 мм

// Размери на колелата и шенкелите
wheel_od  = 43.0;          // Външен диаметър на гумата (Радиус = 21.5 мм)
drum_id   = 27.0;          // Вътрешен диаметър на барабана (Радиус = 13.5 мм)
drum_w    = 20.0;          // Ширина на гумата/барабана
kingpin_z = 23.5;          // Пантите са на +/- 23.5 мм (на 2 мм над и под 43мм гума)
steer_y   = 18.0;          // Дължина на кормилното рамо напред (+Y)
arm_x_ofs = 7.5;           // Изместване на рамото навътре (заобикаля ръба на барабана)


// =========================================================================
// 1. ПРЕДНА ПОДРАМА (FRONT SUBFRAME & DIFF HOUSING)
// =========================================================================
module front_subframe() {
    color("SlateGray")
    difference() {
        union() {
            // А) Основна базова плоча на шасито (на ниво Z = -26.5 мм, с предпазител под короната)
            translate([0, -25, -kingpin_z - 3.0])
                cube([48, 65, 4], center = true);
                
            // Б) Лява и дясна стена на диференциалната кутия (при X = +/- 19.5 мм)
            for (x_sign = [-1, 1]) {
                hull() {
                    translate([x_sign * 19.5, 0, diff_z_offset])
                        rotate([0, 90, 0])
                        cylinder(d = 24, h = 5, center = true);
                    translate([x_sign * 19.5, -10, -kingpin_z - 1.5])
                        cube([5, 36, 3], center = true);
                    translate([x_sign * 19.5, 0, kingpin_z + 4.0])
                        cube([5, 16, 4], center = true);
                }
                
                // В) Горно и долно носещо рамо (С-образна вилка) до X = +/- 72.0 мм
                for (z_sign = [-1, 1]) {
                    z_arm = z_sign * (kingpin_z + 4.0);
                    hull() {
                        translate([x_sign * 19.5, 0, z_arm])
                            cube([5, 18, 4.5], center = true);
                        translate([x_sign * kingpin_x, 0, z_arm])
                            cylinder(d = 12, h = 4.5, center = true);
                    }
                    // Диагонално ребро за коравина при по-дългото рамо (72 мм)
                    hull() {
                        translate([x_sign * 38, 0, z_arm])
                            cylinder(d = 9, h = 4.5, center = true);
                        translate([x_sign * 21, 0, z_sign * 12])
                            cube([4, 14, 4], center = true);
                    }
                }
            }
            
            // Г) Задна опора за пиньона (Z=15) с два лагера 8x12x3.5 мм (при Y = -30 мм)
            hull() {
                translate([-14, pinion_y, diff_z_offset])
                    rotate([0, 90, 0])
                    cylinder(d = 19, h = 14);
                translate([-7, pinion_y, -kingpin_z - 1.5])
                    cube([14, 18, 3], center = true);
            }
            
            // Д) Предна конзола (водач) за напречната кормилна рейка (при Y = +18 мм)
            hull() {
                translate([0, steer_y, 0])
                    cube([64, 10, 12], center = true);
                translate([0, 9, -kingpin_z - 1.5])
                    cube([48, 18, 3], center = true);
            }
            
            // Е) Горна разпънка (Strut Bar) над диференциала
            translate([0, 0, kingpin_z + 4.0])
                cube([44, 16, 4.5], center = true);
        }
        
        // --- ИЗРЯЗВАНИЯ И ЛАГЕРНИ ЛЕГЛА В РАМАТА ---
        
        // 1. Легла за двата лагера 10x15x4 на диференциала (при X = +/- 19.5, Z = +9.5)
        for (x_sign = [-1, 1]) {
            translate([x_sign * 19.5, 0, diff_z_offset])
                rotate([0, 90, 0]) {
                    cylinder(d = 12.5, h = 10, center = true);
                    translate([0, 0, -x_sign * 0.6])
                        cylinder(d = 15.0 + tol, h = 4.2, center = true);
                }
        }
        
        // 2. Отвор и легла за двата лагера 8x12x3.5 на пиньона (при Y = -30, Z = +9.5)
        translate([-15, pinion_y, diff_z_offset])
            rotate([0, 90, 0])
            cylinder(d = 9.5, h = 20);
        translate([-3.6, pinion_y, diff_z_offset])
            rotate([0, 90, 0])
            cylinder(d = 12.0 + tol, h = 3.7);
        translate([-14.1, pinion_y, diff_z_offset])
            rotate([0, 90, 0])
            cylinder(d = 12.0 + tol, h = 3.7);
            
        // 3. Вътрешно легло около 47мм корона на диференциала
        translate([-10, 0, diff_z_offset])
            rotate([0, 90, 0])
            cylinder(d = ring_od + 3.0, h = 14);
            
        // 4. Отвори M3 в краищата на рамата (X = +/- 72.0) за пантите на шенкелите
        for (x_sign = [-1, 1]) {
            translate([x_sign * kingpin_x, 0, 0])
                cylinder(d = 3.0, h = 65, center = true);
        }
        
        // 5. Правоъгълен водач за кормилната рейка отпред (Y = +18, Z = 0)
        translate([0, steer_y, 0])
            cube([70, 6.4, 5.4], center = true);
        translate([0, steer_y, 5])
            cube([36, 8, 6], center = true);
            
        // 6. Монтажни отвори M3.5 в задната част на рамата (за връзка със задната секция)
        for (x_pos = [-16, 0, 16]) {
            for (y_pos = [-42, -52]) {
                translate([x_pos, y_pos, -kingpin_z - 3.0])
                    cylinder(d = 3.6, h = 12, center = true);
            }
        }
    }
}


// =========================================================================
// 2. ДИФЕРЕНЦИАЛ С РАЗШИРЕНИ ЧАШКИ (Z=45, m=1.0, OD=47mm)
// =========================================================================
module differential_unit() {
    // А) Стреловидна корона Z=45, OD=47mm, W=8mm с 3x M3.5 на R=18.5mm
    color("RoyalBlue")
    translate([-8, 0, 0])
    rotate([0, 90, 0])
    difference() {
        union() {
            cylinder(d = ring_od, h = ring_w);
            for (i = [0:15:345]) {
                rotate([0, 0, i])
                translate([ring_od/2 - 0.8, 0, ring_w/2])
                    cube([1.6, 1.5, ring_w], center = true);
            }
        }
        translate([0, 0, -1]) cylinder(d = 32, h = 10);
        for (a = [0, 120, 240]) {
            rotate([0, 0, a])
            translate([18.5, 0, -1])
                cylinder(d = 3.5, h = 10);
        }
    }
    
    // Б) Касета с фланец Ф43мм и вградени чашки с широка фаска (до 28° наклон)
    color("DodgerBlue")
    difference() {
        union() {
            translate([0, 0, 0]) rotate([0, 90, 0]) cylinder(d = carrier_d, h = 3.5);
            translate([-14, 0, 0]) rotate([0, 90, 0]) cylinder(d = 31.0, h = 28.0);
            translate([-22.5, 0, 0]) rotate([0, 90, 0]) cylinder(d = 10.0 - tol, h = 45.0);
        }
        for (x_sign = [-1, 1]) {
            translate([x_sign * diff_cup_x, 0, 0]) {
                sphere(d = 7.0);
                rotate([0, x_sign * 90, 0])
                    cylinder(d = 7.0, h = 5.0);
                // Широка входна фаска (Ф7.0 -> Ф8.6 мм)
                translate([x_sign * 2.2, 0, 0])
                    rotate([0, x_sign * 90, 0])
                    cylinder(d1 = 7.0, d2 = 8.6, h = 2.6);
                // Канали за щифта Ф1.5мм
                hull() {
                    translate([-x_sign * 2.2, 0, 0]) rotate([90, 0, 0]) cylinder(d = 1.9, h = 12, center = true);
                    translate([ x_sign * 3.0, 0, 0]) rotate([90, 0, 0]) cylinder(d = 1.9, h = 12, center = true);
                }
            }
        }
    }
}

module pinion_unit() {
    color("Gold")
    translate([-8, 0, 0])
    rotate([0, 90, 0]) {
        cylinder(d = pinion_od, h = ring_w);
        translate([0, 0, -10])
            cylinder(d = 8.0 - tol, h = 22);
    }
}


// =========================================================================
// 3. ДВОЙНА ПОЛУОСКА (DOUBLE DOGBONE SHAFT - дължина 54.83 мм, наклон 10.0°)
// =========================================================================
module double_dogbone_shaft() {
    shaft_len = sqrt(pow(dogbone_l, 2) + pow(diff_z_offset, 2)); // 54.83 мм
    tilt_deg  = atan2(diff_z_offset, dogbone_l);                 // 10.0 градуса
    
    rotate([0, tilt_deg, 0]) {
        color("MediumSeaGreen")
        difference() {
            union() {
                // Две сфери Ф6.6 мм в краищата
                sphere(d = 6.6);
                translate([shaft_len, 0, 0]) sphere(d = 6.6);
                
                // Изтънени шийки Ф3.5 мм около сферите за максимален ъгъл на завиване
                rotate([0, 90, 0]) cylinder(d = 3.5, h = shaft_len);
                
                // Усилено централно тяло Ф4.5 мм с конусни преходи
                translate([6.5, 0, 0])
                    rotate([0, 90, 0])
                    cylinder(d1 = 3.5, d2 = 4.5, h = 2.5);
                translate([9.0, 0, 0])
                    rotate([0, 90, 0])
                    cylinder(d = 4.5, h = shaft_len - 18.0);
                translate([shaft_len - 9.0, 0, 0])
                    rotate([0, 90, 0])
                    cylinder(d1 = 4.5, d2 = 3.5, h = 2.5);
            }
            // Отвори за набиване на двата стоманени щифта Ф1.5 мм
            rotate([90, 0, 0]) cylinder(d = 1.5, h = 12, center = true);
            translate([shaft_len, 0, 0]) rotate([90, 0, 0]) cylinder(d = 1.5, h = 12, center = true);
        }
        // Визуализация на двата стоманени щифта (Ф1.5 x 9.5 мм)
        color("Crimson") {
            rotate([90, 0, 0]) cylinder(d = 1.5, h = 9.5, center = true);
            translate([shaft_len, 0, 0]) rotate([90, 0, 0]) cylinder(d = 1.5, h = 9.5, center = true);
        }
    }
}


// =========================================================================
// 4. НАПРЕЧНА КОРМИЛНА РЕЙКА (STEERING TIE-ROD BAR - дължина 129 мм)
// =========================================================================
module steering_tierod_bar() {
    // Разстояние между кормилните уши: 2 * (72.0 - 7.5) = 129.0 мм
    tie_span = 2 * (kingpin_x - arm_x_ofs); 
    
    color("Tomato")
    difference() {
        union() {
            cube([tie_span, 6.0, 5.0], center = true);
            for (x_sign = [-1, 1]) {
                translate([x_sign * (tie_span/2), 0, 0])
                    cylinder(d = 8.0, h = 5.0, center = true);
            }
            // Централен пин за задвижване от серво или кормилен механизъм
            translate([0, 0, 4.0])
                cylinder(d = 5.0, h = 6.0, center = true);
        }
        // Овални отвори M3 в краищата (обират дъгата на кормилните рамена при завой)
        for (x_sign = [-1, 1]) {
            hull() {
                translate([x_sign * (tie_span/2), -1.2, 0]) cylinder(d = 3.2, h = 10, center = true);
                translate([x_sign * (tie_span/2),  1.2, 0]) cylinder(d = 3.2, h = 10, center = true);
            }
        }
        translate([0, 0, 4.0])
            cylinder(d = 2.5, h = 12, center = true);
    }
}


// =========================================================================
// 5. ЗАВИВАЩ ШЕНКЕЛ И ГЛАВИНА (С ЛАГЕРИ 10x15x4 И 3x8x4)
// =========================================================================
module steering_knuckle_unit() {
    color("DarkOrange")
    difference() {
        union() {
            // Централно тяло за двата лагера 10x15x4 (вътре в барабана)
            translate([-5, 0, 0]) rotate([0, 90, 0]) cylinder(d = 19.0, h = 10.0);
            
            // Горна и долна Г-образна скоба (заобикаля 43мм гума до Z = +/- 23.5 мм)
            for (z_sign = [-1, 1]) {
                hull() {
                    translate([-3.5, 0, z_sign * 8.0]) cube([3.0, 9.0, 3.0], center = true);
                    translate([-arm_x_ofs, 0, z_sign * 10.5]) cube([4.0, 9.0, 4.0], center = true);
                }
                hull() {
                    translate([-arm_x_ofs, 0, z_sign * 10.5]) cube([4.0, 9.0, 4.0], center = true);
                    translate([-arm_x_ofs, 0, z_sign * kingpin_z]) cylinder(d = 10.0, h = 4.0, center = true);
                }
                hull() {
                    translate([-arm_x_ofs, 0, z_sign * kingpin_z]) cylinder(d = 10.0, h = 4.0, center = true);
                    translate([0, 0, z_sign * kingpin_z]) cylinder(d = 12.0, h = 4.0, center = true);
                }
            }
            // Кормилно рамо напред към Y = +18 мм
            hull() {
                translate([-arm_x_ofs, 0, 0]) cylinder(d = 8.0, h = 5.0, center = true);
                translate([-arm_x_ofs, steer_y, -3.5]) cylinder(d = 7.5, h = 4.0, center = true);
            }
        }
        // Легла за двата лагера 10x15x4
        translate([-5.1, 0, 0]) rotate([0, 90, 0]) cylinder(d = 15.0 + tol, h = 4.1);
        translate([ 1.0, 0, 0]) rotate([0, 90, 0]) cylinder(d = 15.0 + tol, h = 4.1);
        translate([-10, 0, 0])  rotate([0, 90, 0]) cylinder(d = 12.6, h = 20);
        
        // Легла за малките лагери 3x8x4 в пантите на завиване (Kingpins)
        for (z_sign = [-1, 1]) {
            translate([0, 0, z_sign * kingpin_z]) {
                cylinder(d = 3.2, h = 10, center = true);
                cylinder(d = 8.0 + tol, h = 4.2, center = true);
            }
        }
        // Отвор M3 за кормилната щанга
        translate([-arm_x_ofs, steer_y, -3.5]) cylinder(d = 3.0, h = 12, center = true);
    }
}

module wheel_hub_cup() {
    color("SteelBlue")
    difference() {
        union() {
            translate([-5, 0, 0]) rotate([0, 90, 0]) cylinder(d = 10.0 - tol, h = 11.0);
            translate([ 5, 0, 0]) rotate([0, 90, 0]) cylinder(d = 11.8, h = 1.0);
            translate([ 6, 0, 0]) rotate([0, 90, 0]) cylinder(d = 25.0, h = 3.0);
            translate([ 9, 0, 0]) rotate([0, 90, 0]) cylinder(d = 14.0, h = 2.0);
        }
        translate([-6, 0, 0]) rotate([0, 90, 0]) cylinder(d = 7.0, h = 9.5);
        sphere(d = 7.0);
        // Широка входна фаска (Ф8.6 -> Ф7.0 мм)
        translate([-5.1, 0, 0])
            rotate([0, 90, 0])
            cylinder(d1 = 8.6, d2 = 7.0, h = 2.6);
        // Канали за щифта Ф1.5 мм
        hull() {
            translate([-3.5, 0, 0]) rotate([90, 0, 0]) cylinder(d = 1.9, h = 12, center = true);
            translate([ 2.5, 0, 0]) rotate([90, 0, 0]) cylinder(d = 1.9, h = 12, center = true);
        }
        // 3 монтажни отвора M3.5 на R = 8.5 мм за барабана на колелото
        for (a = [0, 120, 240]) {
            rotate([a, 0, 0])
            translate([5, 0, 8.5])
                rotate([0, 90, 0])
                cylinder(d = 3.6, h = 6);
        }
        translate([0, 0, 0]) rotate([0, 90, 0]) cylinder(d = 3.2, h = 25);
    }
}

module ghost_wheel_43mm() {
    color("DimGray", 0.35)
    translate([-3.5, 0, 0])
    rotate([0, 90, 0])
    difference() {
        cylinder(d = wheel_od, h = drum_w);
        translate([0, 0, -0.1]) cylinder(d = drum_id, h = 12.6);
        translate([0, 0, -0.1]) cylinder(d = 14.2, h = 22.0);
    }
}


// =========================================================================
// ГЛАВНА СЦЕНА И ИЗБОР НА ДЕТАЙЛИ ЗА ПРИНТИРАНЕ
// =========================================================================
if (part_select == 0) {
    // 1. Предна подрама (Неподвижна)
    front_subframe();
    
    // 2. Повдигнат диференциал и пиньон на Z = +9.5 мм
    translate([0, 0, diff_z_offset]) {
        rotate([wheel_spin, 0, 0])
            differential_unit();
        translate([0, pinion_y, 0])
            rotate([pinion_spin, 0, 0])
            pinion_unit();
    }
    
    // 3. Кормилна рейка
    steer_shift_x = -steer_y * sin(steer_deg);
    translate([steer_shift_x, steer_y, 0])
        steering_tierod_bar();
        
    // 4. Лява и дясна полуоска + Завиващи шенкели и 43мм колела (при X = +/- 72 мм)
    for (side = [-1, 1]) {
        translate([side * diff_cup_x, 0, diff_z_offset])
        scale([side, 1, 1])
        rotate([side * wheel_spin, 0, 0])
            double_dogbone_shaft();
            
        translate([side * kingpin_x, 0, 0])
        rotate([0, 0, steer_deg])
        scale([side, 1, 1]) {
            steering_knuckle_unit();
            rotate([side * wheel_spin, 0, 0]) {
                wheel_hub_cup();
                ghost_wheel_43mm();
            }
        }
    }
}
else if (part_select == 1) {
    // Подрама за принтиране
    front_subframe();
}
else if (part_select == 2) {
    // Кормилна рейка за принтиране
    steering_tierod_bar();
}
else if (part_select == 3) {
    // Шенкел за принтиране
    steering_knuckle_unit();
}
else if (part_select == 4) {
    // Главина с чашка - обърната върху фланеца за принт без подпори!
    translate([0, 0, 9]) rotate([0, -90, 0]) wheel_hub_cup();
}
else if (part_select == 5) {
    // Изправена хоризонтално полуоска за принтиране
    rotate([0, -atan2(diff_z_offset, dogbone_l), 0]) double_dogbone_shaft();
}
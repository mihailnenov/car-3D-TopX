// =========================================================================
// САМОСТОЯТЕЛЕН OPENSCAD ФАЙЛ: ОПТИМИЗИРАНА ДВОЙНА ПОЛУОСКА (DOGBONE)
// Параметри:
// - Междуцентрова дължина: 54.83 мм (при kingpin_x = 72 мм и diff_z_offset = 9.5 мм)
// - Диаметър на сферите: 6.6 мм (срязани отдолу и отгоре за 100% плоска база Z = 0)
// - Шийки: 3.5 мм | Централно тяло: 4.5 мм
// - Отвори за щифтове: 1.55 мм (вертикални за перфектен принт без подпори)
// =========================================================================

$fn = 64;

// Глобални константи от твоя мост
kingpin_x     = 72.0;
diff_cup_x    = 18.0;
dogbone_l     = kingpin_x - diff_cup_x; // 54.0 мм
diff_z_offset = 9.5;

module double_dogbone_shaft_printable() {
    shaft_len = sqrt(pow(dogbone_l, 2) + pow(diff_z_offset, 2)); // 54.83 мм
    flat_z    = 2.4; // Разстояние от центъра до плоската основа
    
    color("MediumSeaGreen")
    difference() {
        union() {
            // 1. Двете сфери Ф6.6 мм в краищата
            sphere(d = 6.6);
            translate([shaft_len, 0, 0]) sphere(d = 6.6);
            
            // 2. Шийки Ф3.5 мм при сферите + Опора до плоската база (Z = -2.4 мм)
            hull() {
                rotate([0, 90, 0]) cylinder(d = 3.5, h = shaft_len);
                translate([0, -1.2, -flat_z]) cube([shaft_len, 2.4, 0.4]);
            }
            
            // 3. Усилено централно тяло Ф4.5 мм с конусни преходи към шийките
            hull() {
                translate([6.5, 0, 0]) rotate([0, 90, 0]) cylinder(d = 3.5, h = 0.1);
                translate([9.0, 0, 0]) rotate([0, 90, 0]) cylinder(d = 4.5, h = shaft_len - 18.0);
                translate([9.0, -1.8, -flat_z]) cube([shaft_len - 18.0, 3.6, 0.4]);
            }
            hull() {
                translate([shaft_len - 9.0, 0, 0]) rotate([0, 90, 0]) cylinder(d = 4.5, h = 0.1);
                translate([shaft_len - 6.5, 0, 0]) rotate([0, 90, 0]) cylinder(d = 3.5, h = 0.1);
            }
        }
        
        // 4. Срязване отдолу за плътна първа контактна повърхност върху плочата на принтера
        translate([-10, -10, -flat_z - 10])
            cube([shaft_len + 20, 20, 10]);
            
        // 5. Симетрично срязване отгоре за баланс
        translate([-10, -10, flat_z])
            cube([shaft_len + 20, 20, 10]);
            
        // 6. Вертикални отвори за стоманените щифтове Ф1.55 мм
        cylinder(d = 1.55, h = 12, center = true);
        translate([shaft_len, 0, 0])
            cylinder(d = 1.55, h = 12, center = true);
    }
}

// Визуализация в изправено положение за директен експорт към STL (без подпори!)
translate([0, 0, 2.4])
    double_dogbone_shaft_printable();
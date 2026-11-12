// ============================================================================
// ЦЕНТРАЛЕН СТЪПАЛОВИДЕН ВАЛ ЗА ПОЛУОСКАТА (С ФАСКИ И НА ДВАТА D-ВАЛА)
// ============================================================================

$fn = 90;

sun_d_shaft_d       = 7.80;  
sun_d_shaft_flat    = 6.30;
sun_d_shaft_len     = 8.00;

c_collar_d          = 11.60; // Външен диаметър на яката
c_collar_w          = 2.00;  // Обща височина на яката

c_sec1_d            = 10.00; 
c_sec1_len          = 4.00;

c_trans1_len        = 1.00;  
c_sec2_d            = 8.80;  
c_sec2_len          = 7.00;

c_sec3_d            = 8.00;  
c_sec3_len          = 3.50;

c_trans2_len        = 1.00;  
c_sec5_d            = 5.80;  
c_sec5_flat_t       = 4.60;
c_sec5_len          = 8.00;

corrected_central_shaft();

module corrected_central_shaft() {
    union() {
        // 1. Долен D-накрайник (с фаска отдолу, стъпва на леглото)
        intersection() {
            union() {
                cylinder(d1 = sun_d_shaft_d - 0.8, d2 = sun_d_shaft_d, h = 0.6);
                translate([0, 0, 0.6])
                    cylinder(d = sun_d_shaft_d, h = sun_d_shaft_len - 0.6);
            }
            translate([-sun_d_shaft_d/2, -sun_d_shaft_d/2, 0])
                cube([sun_d_shaft_d, sun_d_shaft_flat, sun_d_shaft_len]);
        }

        // 2. Преходен конус ОТДОЛУ на яката (за печат без подпори)
        translate([0, 0, sun_d_shaft_len])
            cylinder(d1 = sun_d_shaft_d + 1, d2 = c_collar_d, h = 1.0);

        // 3. РАВНА ЧАСТ НА ЯКАТА ОТГОРЕ
        translate([0, 0, sun_d_shaft_len + 1.0])
            cylinder(d = c_collar_d, h = c_collar_w - 1);

        // 4. Лагерна шийка 10.00mm
        base_z4 = sun_d_shaft_len + c_collar_w;
        translate([0, 0, base_z4]) {
            cylinder(d = c_sec1_d, h = c_sec1_len);
        }

        // 5. Преход към междинна шийка 8.80mm
        base_z5 = base_z4 + c_sec1_len;
        translate([0, 0, base_z5])
            cylinder(d1 = c_sec1_d, d2 = c_sec2_d, h = c_trans1_len);

        // 6. Междинна шийка 8.80mm
        base_z6 = base_z5 + c_trans1_len;
        translate([0, 0, base_z6])
            cylinder(d = c_sec2_d, h = c_sec2_len);

        // 7. Шийка за лагер 8mm
        base_z7 = base_z6 + c_sec2_len;
        translate([0, 0, base_z7]) {
            cylinder(d = c_sec3_d, h = c_sec3_len);
        }

        // 8. Преход към горния D-вал 5.80mm
        base_z8 = base_z7 + c_sec3_len;
        translate([0, 0, base_z8])
            cylinder(d1 = c_sec3_d, d2 = c_sec5_d + 1, h = c_trans2_len);

        // 9. Горен външен D-вал 5.80mm (с фаска на самия връх)
        base_z9 = base_z8 + c_trans2_len;
        translate([0, 0, base_z9])
            intersection() {
                union() {
                    // Права част на вала
                    cylinder(d = c_sec5_d, h = c_sec5_len - 0.6);
                    // Конус (фаска) на върха
                    translate([0, 0, c_sec5_len - 0.6])
                        cylinder(d1 = c_sec5_d, d2 = c_sec5_d - 0.8, h = 0.6);
                }
                // Изрязващ куб, който оформя плоската страна на D-профила
                translate([-c_sec5_d/2, -c_sec5_d/2, 0])
                    cube([c_sec5_d, c_sec5_flat_t, c_sec5_len]);
            }
    }
}
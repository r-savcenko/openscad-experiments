canal_sizes = [5, 4, 3, 4, 5];

canal_max_diameter = 5;

canal_size_offset = 0.3;

canal_gutter = 3;

base_width = 50;

base_length = 21.5;

base_height = 5;

base_rounding = 2.5;

canal_z_offset = 1.6;

$fn = 32;

module base() {
    translate([base_rounding, base_rounding]) {
        minkowski() {
            cube([base_width - base_rounding * 2, base_length - base_rounding * 2, base_height]);
            difference() {
                sphere(r = base_rounding, center = false);
                translate([-base_rounding, -base_rounding, -base_rounding])
                    cube([base_rounding * 2, base_rounding * 2, base_rounding]);
            }
        }
    }
}

module canal(diameter) {
    offset = diameter * canal_size_offset;
    translate([diameter / 2, base_length + 1, base_height + base_rounding - diameter]) {
        rotate([0, -90, 90]) {
            translate([diameter / 2, diameter / 2, 0])
                cylinder(r=diameter/2, h=base_length + 2);

            translate([diameter / 2, offset / 2, 0])
                cube([10, diameter - offset, base_length + 2]);
        }
    }
}


difference() {
    base();
    if (len(canal_sizes) == 1) {
        sx = base_width / 2;
        translate([sx, 0, 0])
            canal(canal_sizes[0]);
    } else {
        canals_width = canal_max_diameter * (len(canal_sizes) - 1) + canal_gutter * (len(canal_sizes) - 1);
        sx = base_width / 2 - canals_width / 2;
        for(i=[0:len(canal_sizes)-1]) {
            pos_x = sx + i * canal_max_diameter + canal_gutter * i;
            translate([pos_x, 0, 0])
                canal(canal_sizes[i]);
        }
    }
}

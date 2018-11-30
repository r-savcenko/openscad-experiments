include <vars.scad>

module cell() {
    linear_extrude(height + thickness) {
        difference() {
            circle(r=outer_r, $fn=sides);
            circle(r=outer_r - thickness, $fn=sides);
        }
    }

    linear_extrude(thickness / 2) {
        for (i=[0:5]) {
            rotate([0, 0, i * 360 / sides]) translate([outer_r * r_koef - thickness / 2, 0 - thickness / 2, 0]) square([outer_r - outer_r * r_koef, thickness]);
        }

        difference() {
            circle(r=outer_r * r_koef, $fn=sides);
            circle(r=outer_r * r_koef - thickness, $fn=sides);
        }
    }
}

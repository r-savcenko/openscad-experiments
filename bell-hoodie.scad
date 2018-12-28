hole_distance = 60;
height = 100;
width = 60;
wall_thickness = 3;
base_thinkess = 5;
length = 40;
hole_radius = 2;
tolerance = 0.2;
module base(off, addon = 0) {
    offset(delta=off) {
        translate([width/2, 0 ,0]) circle(r=width/2);
        square([width, height + addon], false);
    }
}
cutout_r = hole_radius + tolerance/2;

difference() {
    difference() {
        union() {
            linear_extrude(base_thinkess) base(0, wall_thickness);
            linear_extrude(length+base_thinkess) {
                difference() {
                    base(wall_thickness);
                    base(0, wall_thickness);
                }
            }
        }

        translate([width/2 - cutout_r/2, 15, 0]) cylinder(r=cutout_r, h=10, $fn=32);
        translate([width/2 - cutout_r/2, 15 + 60, 0]) cylinder(r=cutout_r, h=10, $fn=32);
    }

    #translate([-width/2, length * 2.5 ,width*1.5]) rotate([90, 0 ,90]) cylinder(r=length * 2, h=width * 2, $fn = 64);
}

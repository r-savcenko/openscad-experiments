include <../common/din/din934.scad>
include <../common/din/din912.scad>


leg_side = 40;
front_height = 60;
joint_height = 10;
thickness = 4;
ear_size = 10;

headphones_joint_size = 28;

tolerance = 0.1;

module mock() {
    color(c = [1, 0, 0], alpha = 0.3) {
        union() {
            translate([0, 0, -100]) cube([leg_side, leg_side, 100 + leg_side]);
            translate([0, -100, 0]) cube([leg_side, 100, leg_side]);
        }
    }
}

module ear_base() {
    cube([ear_size + thickness, joint_height, thickness]);
}

module front_ear() {
    translate([0, 0, joint_height])
        rotate([-90, 0, 0])
            din912(1, thickness + 0.01, [[5, 5]])
                ear_base();
}

module back_ear() {
    translate([0, thickness, 0])
        rotate([90, 0, 0])
            din934(9, thickness + 0.01, [[5, 5]])
                ear_base();
}

module hook() {
    translate([ear_size + thickness, thickness, 0])
        cube([leg_side + thickness, headphones_joint_size, thickness]);

    translate([ear_size + thickness, headphones_joint_size + thickness, 0])
        rotate([80, 0, 0])
            cube([leg_side + thickness, headphones_joint_size * 0.5, thickness]);
}

module front_part() {
    union() {
        translate([ear_size + thickness, 0, 0])
            cube([leg_side + thickness, thickness, front_height + thickness]);

        translate([ear_size + thickness, -leg_side - ear_size - thickness, front_height])
            cube([leg_side + thickness, leg_side + ear_size + thickness, thickness]);

        translate([0, 0, front_height - headphones_joint_size])
            hook();

        front_ear();

        translate([ear_size + leg_side + thickness, -leg_side - ear_size - thickness, 0])
            rotate([0, 0, 270])
                mirror([1, 0, 0])
                    front_ear();
        translate([leg_side + ear_size + thickness, - leg_side - thickness - ear_size, joint_height])
            cube([thickness, ear_size + thickness, front_height - joint_height]);

        translate([ear_size + thickness + leg_side, - leg_side, 0])
            cube([thickness, leg_side, joint_height]);
    }
}

module back_part() {
    back_ear();
    translate([ear_size, -leg_side, 0])
        cube([thickness, leg_side, joint_height]);

    translate([ear_size + thickness, -leg_side, 0])
        cube([leg_side - thickness, thickness, joint_height]);

    translate([thickness + ear_size + leg_side - thickness, -leg_side - ear_size, 0])
        rotate([0, 0, 90])
            mirror([0, 1, 0])
                back_ear();
}

translate([ear_size + thickness, -leg_side, front_height - leg_side]) mock();

color(c = [0, 1, 0])
    front_part();

translate([0, -thickness, 0]) back_part();

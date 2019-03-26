include <../common/din/din934.scad>
include <../common/din/din912.scad>


leg_side = 40;
front_height = 60;
joint_height = 10;
thickness = 4;
ear_size = 10;

bolt_height = 10;

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

module ear() {
    translate([0, 0, 0])
        rotate([-90, 0, 0])
            din912(1, thickness, [[5, 5]])
                cube([ear_size, joint_height, thickness]);
}

module ear2() {
    translate([0, 0, 0])
        rotate([-90, 0, 0])
            din934(9, thickness, [[5, 5]])
                cube([ear_size, joint_height, thickness]);
}

module hook() {
    translate([0, thickness, 0])
        cube([leg_side + ear_size * 2 + thickness * 2, headphones_joint_size, thickness]);

    translate([0, headphones_joint_size + thickness, 0])
        rotate([80, 0, 0])
            cube([leg_side + ear_size * 2 + thickness * 2, headphones_joint_size * 0.5, thickness]);
}

module front_part() {
    union() {
        rotate([90, 0, 0])
            mirror([0, 0, 1])
                din912(1, thickness, [[5, 5], [leg_side + ear_size + thickness * 2 + 5, 5]])
                    cube([leg_side + ear_size * 2 + thickness * 2, front_height + thickness, thickness]);

        translate([0, -leg_side - ear_size - thickness * 2, front_height])
            din934(9, thickness, [[5, 5], [leg_side + ear_size + thickness * 2 + 5, 5]])
                cube([leg_side + ear_size * 2 + thickness * 2, leg_side + ear_size + thickness * 2, thickness]);

        translate([0, 0, front_height - headphones_joint_size])
            hook();

    }
}

module back_part1() {
    translate([0, - leg_side - thickness, front_height - bolt_height])
        rotate([-90, 0, 0])
                ear();

    translate([leg_side + thickness * 2 + ear_size, - leg_side - thickness, front_height - bolt_height])
        rotate([-90, 0, 0])
                ear();

    translate([ear_size,  - leg_side - joint_height - thickness, front_height - leg_side - thickness]) {
        difference() {
            cube([leg_side + thickness * 2, joint_height, leg_side - bolt_height + thickness]);
            translate([thickness, 0, thickness])
                cube([leg_side, joint_height, leg_side - bolt_height + thickness]);
        }
    }
}

module back_part2() {
    translate([0, - leg_side - thickness, front_height - bolt_height])
        rotate([-90, 0, 0])
                ear2();

    translate([leg_side + thickness * 2 + ear_size, - leg_side - thickness, front_height - bolt_height])
        rotate([-90, 0, 0])
                ear2();

    translate([ear_size,  - leg_side - joint_height - thickness, front_height - leg_side - thickness]) {
        difference() {
            cube([leg_side + thickness * 2, joint_height, leg_side - bolt_height + thickness]);
            translate([thickness, 0, thickness])
                cube([leg_side, joint_height, leg_side - bolt_height + thickness]);
        }
    }
}

translate([ear_size + thickness, -leg_side, front_height - leg_side]) mock();

front_part();

back_part1();

translate([0, -40, 0]) back_part2();

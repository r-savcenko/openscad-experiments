include <../common/din/din934.scad>
include <../common/din/din912.scad>

leg_side = 40;

thickness = 5;

headphone_side = 27;

back_joint_height = 10;

ear_size = 10;

front_height = 50;

module hook() {
    hook_width = leg_side;
    translate([0, headphone_side, 0]) {
        translate([0, -headphone_side, 0])
            cube([hook_width, headphone_side, thickness]);
        rotate([60, 0, 0])
            cube([hook_width, headphone_side, thickness]);
    }
}

module back_joint_base() {
    translate([ear_size, 0, 0]) {
        translate([thickness, 0, 0]) {
            cube([leg_side, thickness, back_joint_height]);
            rotate([0, 0, 90]) cube([leg_side + thickness, thickness, back_joint_height]);
            translate([leg_side + thickness, 0, 0]) rotate([0, 0, 90]) cube([leg_side + thickness * 2, thickness, back_joint_height]);
        }
        translate([-ear_size, leg_side, 0]) cube([ear_size, thickness, back_joint_height]);
        /* translate([leg_side + thickness * 2, leg_side, 0]) cube([ear_size, thickness, back_joint_height]); */
    }
}

module back_joint() {
    coords = [
        [5, 5],
        [ear_size + thickness * 2 + leg_side + 5, 5]
    ];

    rotate([90, 0, 0])
        translate([0, 0, - (leg_side + thickness)])
            din934(9, thickness + 1, coords)
                translate([0, 0, leg_side + thickness])
                    rotate([-90, 0, 0])
                        back_joint_base();
}

module front_ear() {
    translate([0, 0, back_joint_height])
        rotate([-90, 0, 0])
            din912(1, thickness + 1, [[5, 5]])
                cube([ear_size + thickness, back_joint_height, thickness]);
}

module front() {
    translate([ear_size + thickness, 0, 0])
        cube([leg_side, thickness, front_height + thickness]);

    front_ear();

    translate([ear_size + thickness, -leg_side, front_height])
        cube([leg_side, leg_side, thickness]);

    translate([ear_size + thickness, thickness, 0]) hook();
}

front();

translate([0, -(leg_side + thickness) - 1, 0]) back_joint();

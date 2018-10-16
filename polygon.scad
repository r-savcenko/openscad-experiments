SIDE_COUNT = 6;
SIDE_WIDTH = 20;
MODEL_HEIGHT = 5;

FLEX_JOINT_WIDTH = 1;
FLEX_JOINT_HEIGHT = 0.6;

SCALE_ADDON = 0.09;
BASE_SIZE = SIDE_WIDTH / 3.5;

VERTEX_ANGLE = (SIDE_COUNT - 2) * (180 / SIDE_COUNT);
CENTER_ANGLE = 360 / SIDE_COUNT;

OUTER_RADIUS = (SIDE_WIDTH / 2) / cos( VERTEX_ANGLE / 2 );
INNER_RADIUS = OUTER_RADIUS - BASE_SIZE;

MID_RADIUS = sqrt( pow(OUTER_RADIUS, 2) - pow(SIDE_WIDTH / 2, 2) );


JOINT_SIZE_X = 5;
JOINT_SIZE_Y = 7;
JOINT_SIZE_Z = MODEL_HEIGHT;

include <common/joint/chain-joint.scad>

module extruded_poly(RADIUS = OUTER_RADIUS, KOEF = 1, HEIGHT = MODEL_HEIGHT / 2) {
    linear_extrude(height = HEIGHT, scale = 1 + SCALE_ADDON * KOEF)
        circle(r = RADIUS, $fn = SIDE_COUNT);
}

module cap(RADIUS = OUTER_RADIUS, KOEF = 1) {
    union() {
        extruded_poly(RADIUS, KOEF);
        translate([0, 0, MODEL_HEIGHT])
            mirror([0, 0, 1])
                extruded_poly(RADIUS, KOEF);
    }
}

module base() {
    difference() {
        cap(OUTER_RADIUS, 1);
        cap(INNER_RADIUS, -1);
    }
}

module flex_cutout() {
    translate([0, 0 - FLEX_JOINT_WIDTH / 2, FLEX_JOINT_HEIGHT])
        cube([OUTER_RADIUS * (1 + SCALE_ADDON) + 1, FLEX_JOINT_WIDTH, MODEL_HEIGHT]);
}

module side_joint() {
    X_DISTANCE = MID_RADIUS;
    translate([X_DISTANCE, SIDE_WIDTH / 2 - JOINT_SIZE_X / 2 - FLEX_JOINT_WIDTH * 2, 0])
        rotate([0, 0, -90]) joint_f();
    translate([X_DISTANCE, 0 - SIDE_WIDTH / 2 + JOINT_SIZE_X / 2 + FLEX_JOINT_WIDTH * 2, 0])
        rotate([0, 0, -90]) joint_m();
}

module assembly() {
    difference() {
        base();
        for(I = [0:SIDE_COUNT - 1]) {
            rotate([0, 0, I * CENTER_ANGLE])
                flex_cutout();
        }
    }
    rotate([0, 0, CENTER_ANGLE / 2]) {
        for(I = [0:SIDE_COUNT - 1]) {
            rotate([0, 0, CENTER_ANGLE * I]) side_joint();
        }
    }
}


assembly();

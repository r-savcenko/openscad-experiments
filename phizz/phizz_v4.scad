TRIANGLE_WIDTH = 30;
TRIANGLE_THICKNESS = 5;

FLEX_JOINT_WIDTH = 1;
FLEX_JOINT_HEIGHT = 0.8;

/** DO NOT EDIT FOLLOWING VARS **/

JOINT_SIZE_X = 4.6;
JOINT_SIZE_Y = 8.25;
JOINT_SIZE_Y_2 = 8;
JOINT_SIZE_Z = TRIANGLE_THICKNESS;
JOINT_WALL_THICKNESS = 1;
JOINT_R = JOINT_SIZE_Z / 4.5;
JOINT_CORNER_RADIUS = JOINT_SIZE_Z / 2;

module joint_m(SY = JOINT_SIZE_Y) {
    _SIZE = [JOINT_SIZE_X, SY, JOINT_SIZE_Z];
    translate([0 - JOINT_SIZE_X / 2, 0, 0]) chain_joint(TYPE="male", SIZE=_SIZE, WALL_THICKNESS=JOINT_WALL_THICKNESS, CORNER_RADIUS = JOINT_CORNER_RADIUS, R = JOINT_R);
}

module joint_f(SY = JOINT_SIZE_Y) {
    _SIZE = [JOINT_SIZE_X, SY, JOINT_SIZE_Z];
    translate([0 - JOINT_SIZE_X / 2, 0, 0]) chain_joint(TYPE="female", SIZE=_SIZE, WALL_THICKNESS=JOINT_WALL_THICKNESS, CORNER_RADIUS = JOINT_CORNER_RADIUS, R = JOINT_R);
}

include <./../common/joint-v2/chain.scad>

module triangle_base(OFFSET = 0) {
    X1 = 0 - TRIANGLE_WIDTH / 2;
    X2 = 0;
    X3 = TRIANGLE_WIDTH / 2;

    Y1 = 0;
    Y2 = TRIANGLE_WIDTH / 2;
    Y3 = 0;
    offset(delta = 0 - OFFSET) {
        polygon([[X1, Y1], [X2, Y2], [X3, Y3]]);
    }
}

module triangle(SCALE = 1) {
    translate([0, TRIANGLE_WIDTH / 2, 0])
        linear_extrude(height = TRIANGLE_THICKNESS, scale=SCALE)
            translate([0, 0 - TRIANGLE_WIDTH / 2, 0])
                triangle_base();
}

module joint_extension(WIDTH = 1) {
    difference() {
        rotate(180, [0, 0, 1])
            translate([0, 0, 0])
                cube([WIDTH, JOINT_WIDTH / 2, JOINT_HEIGHT]);
        translate([1, 0 - JOINT_WIDTH / 2, 0])
            rotate(-45, [1, 0, 0])
                rotate(180, [0, 0, 1])
                    cube([JOINT_WIDTH + 2, TRIANGLE_WIDTH / 4, JOINT_HEIGHT]);
    }
}

module cutout() {
    translate([0, 0.5, 0])
        mirror([0, 0, 1])
            linear_extrude(height = TRIANGLE_THICKNESS / 3, scale = 0.5)
                translate([0, 0 - TRIANGLE_WIDTH / 4, 0])
                    triangle_base(3.5);
}

module base() {
    difference() {
        triangle(0.9);
        translate([0, TRIANGLE_WIDTH / 4, TRIANGLE_THICKNESS])
            cutout();
    }
}

module base_model() {
    union() {
        base();

        translate([TRIANGLE_WIDTH / 4 - 1, TRIANGLE_WIDTH / 4 - 1, 0])
          rotate(-45, [0, 0, 1])
            joint_f();

        translate([0 - TRIANGLE_WIDTH / 4 + 1, TRIANGLE_WIDTH / 4 - 1, 0])
          rotate(45, [0, 0, 1])
            joint_m();

        translate([TRIANGLE_WIDTH / 2, 0, 0]) {
            translate([0, 0, 0]) {
                rotate([0, 0, 180]) {
                    translate([TRIANGLE_WIDTH / 8, 0 - 2, 0]) {
                        joint_f(JOINT_SIZE_Y_2);
                        translate([TRIANGLE_WIDTH / 4, 0, 0])
                            joint_m(JOINT_SIZE_Y_2);
                    }
                }
            }
        }
    }
}

module assembly() {
    FLEX_H = TRIANGLE_THICKNESS - FLEX_JOINT_HEIGHT;
    difference() {
        base_model();
        translate([0, 0, FLEX_JOINT_HEIGHT])
            linear_extrude(height = FLEX_H, scale = [3.5, 1])
                translate([0 - FLEX_JOINT_WIDTH / 2, 0, 0])
                    square([FLEX_JOINT_WIDTH, TRIANGLE_WIDTH]);
    }
}

assembly();
/* base(); */

TRIANGLE_WIDTH = 30;
TRIANGLE_THICKNESS = 5;

FLEX_JOINT_WIDTH = 1;
FLEX_JOINT_HEIGHT = 0.6;

/** DO NOT EDIT FOLLOWING VARS **/

JOINT_SIZE_X = 5;
JOINT_SIZE_Y = 7;
JOINT_SIZE_Y_2 = 8;
JOINT_SIZE_Z = TRIANGLE_THICKNESS;
JOINT_WALL_THICKNESS = 0.8;
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

module triangle() {
    X1 = 0 - TRIANGLE_WIDTH / 2;
    X2 = 0;
    X3 = TRIANGLE_WIDTH / 2;

    Y1 = 0;
    Y2 = TRIANGLE_WIDTH / 2;
    Y3 = 0;

    translate([0, TRIANGLE_WIDTH / 2, 0])
        linear_extrude(height = TRIANGLE_THICKNESS, scale=0.9)
            translate([0, 0 - TRIANGLE_WIDTH / 2, 0])
                polygon([[X1, Y1], [X2, Y2], [X3, Y3]]);
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

module base() {
    STEP = 0.2;
    SCALE_STEP = 1 - STEP;
    ITERATIONS = 6;

    difference() {
        triangle();
        translate([0, TRIANGLE_WIDTH / 4.5, 0]) {
            union() {
                for(i=[1:ITERATIONS])
                    translate([0, 0 - STEP * 4, TRIANGLE_THICKNESS - STEP * i * 2])
                        scale([0.4 - STEP * i / 4, 0.4 - STEP * i / 4, 1])
                            translate([0, 0 - TRIANGLE_WIDTH / 5, 0])
                                triangle();
            }
        }
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
    difference() {
        base_model();
        translate([0 - FLEX_JOINT_WIDTH / 2, -0.1, FLEX_JOINT_HEIGHT])
            cube([FLEX_JOINT_WIDTH, TRIANGLE_WIDTH, TRIANGLE_THICKNESS]);
    }
}

assembly();

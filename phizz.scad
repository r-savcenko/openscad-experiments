TRIANGLE_WIDTH = 30;
TRIANGLE_THICKNESS = 4;

FLEX_JOINT_WIDTH = 1;
FLEX_JOINT_HEIGHT = 0.6;

/** DO NOT EDIT FOLLOWING VARS **/

JOINT_WIDTH = 5;
JOINT_SIDE_WIDTH = TRIANGLE_THICKNESS;
JOINT_HEIGHT = TRIANGLE_THICKNESS;
HINGE_SIDE_THICKNESS = 1;

include <common/joint/hinge-clip-joint.scad>

module triangle() {
    X1 = 0 - TRIANGLE_WIDTH / 2;
    X2 = 0;
    X3 = TRIANGLE_WIDTH / 2;

    Y1 = 0;
    Y2 = TRIANGLE_WIDTH / 2;
    Y3 = 0;

    linear_extrude(TRIANGLE_THICKNESS) polygon([[X1, Y1], [X2, Y2], [X3, Y3]]);
}

module base() {
    STEP = 0.2;
    SCALE_STEP = 1 - STEP;
    ITERATIONS = 5;

    difference() {
        triangle();
        translate([0, TRIANGLE_WIDTH / 4.5, 0]) {
            union() {
                for(i=[1:ITERATIONS])
                    translate([0, 0 - STEP * 4, TRIANGLE_THICKNESS - STEP * i * 2])
                        scale([0.5 - STEP * i / 4, 0.5 - STEP * i / 4, 1])
                            translate([0, 0 - TRIANGLE_WIDTH / 5, 0])
                                triangle();
            }
        }
    }
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


module base_model() {
    union() {
        base();

        translate([TRIANGLE_WIDTH / 4, TRIANGLE_WIDTH / 4, 0])
          rotate(-45, [0, 0, 1])
            hinge();

        translate([0 - TRIANGLE_WIDTH / 4, TRIANGLE_WIDTH / 4, 0])
          rotate(45, [0, 0, 1])
            clip(true);

        translate([TRIANGLE_WIDTH / 2, 0, 0]) {
            translate([0 - TRIANGLE_WIDTH / 8 + CLIP_WIDTH / 2, 0, 0])
                joint_extension(CLIP_WIDTH);

            CX = 0 - TRIANGLE_WIDTH / 4 - TRIANGLE_WIDTH / 8;
            translate([CX - JOINT_WIDTH / 2 + HINGE_SIDE_THICKNESS, 0, 0])
                joint_extension(HINGE_SIDE_THICKNESS);

            translate([CX + JOINT_WIDTH / 2, 0, 0])
                joint_extension(HINGE_SIDE_THICKNESS);

            translate([0, 0 - JOINT_WIDTH / 2, 0]) {
                rotate(180, [0, 0, 1]) {
                    rotate(45, [1, 0, 0]) {
                        translate([TRIANGLE_WIDTH / 8, 0, 0]) {
                            clip();
                            translate([TRIANGLE_WIDTH / 4, 0, 0])
                                hinge();
                        }
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

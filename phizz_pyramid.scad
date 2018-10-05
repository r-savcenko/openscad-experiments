LAYER_THICKNESS = 0.2;

TRIANGLE_WIDTH = 30;
TRIANGLE_THICKNESS = 4;

FLEX_JOINT_WIDTH = 1.5;
FLEX_JOINT_HEIGHT = LAYER_THICKNESS * 2;

SIDE_OFFSET = 0.75;

TRIANGLE_HEIGHT = TRIANGLE_WIDTH / 2;

CENTER_DIST = (1 / tan(60)) * ( TRIANGLE_WIDTH / 2 );
PIRAMYD_HEIGHT = sqrt(pow(TRIANGLE_HEIGHT / 2, 2) - pow(CENTER_DIST, 2));
ANGLE_A = asin(CENTER_DIST / TRIANGLE_HEIGHT);

TIP_KOEF = FLEX_JOINT_WIDTH / TRIANGLE_WIDTH;

TRIANGLE_SIDE_WIDTH = sqrt(pow(TRIANGLE_HEIGHT, 2) * 2);

SIDE_JOINT_LENGTH = TRIANGLE_SIDE_WIDTH * (1 - TIP_KOEF);
SIDE_JOINT_WIDTH = cos(30) * SIDE_OFFSET * 2;


JOINT_WIDTH = TRIANGLE_WIDTH / 4 - FLEX_JOINT_WIDTH;
JOINT_SIDE_WIDTH = TRIANGLE_THICKNESS;
JOINT_HEIGHT = TRIANGLE_THICKNESS;
HINGE_SIDE_THICKNESS = 1;

include <common/hinge-clip-joint.scad>

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


module triangle() {
    COORDS = [
        [0 - TRIANGLE_WIDTH / 2, 0],
        [0, TRIANGLE_WIDTH / 2],
        [TRIANGLE_WIDTH / 2, 0]
    ];
    linear_extrude(TRIANGLE_THICKNESS)
        polygon(COORDS);
}

module side_joint() {
    translate([0 - TRIANGLE_WIDTH / 2, 0, 0])
        rotate([-45, 0, 45])
            translate([0, 0 - FLEX_JOINT_HEIGHT / 2, 0 - FLEX_JOINT_HEIGHT / 2])
                cube([SIDE_JOINT_LENGTH, SIDE_JOINT_WIDTH + FLEX_JOINT_HEIGHT, FLEX_JOINT_HEIGHT]);
}

module pyramid_face() {
    side_joint();
    translate([0, 0, 0]) {
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
        difference() {
            triangle();
            translate([0 - FLEX_JOINT_WIDTH / 2, 0, FLEX_JOINT_HEIGHT])
                cube([FLEX_JOINT_WIDTH, TRIANGLE_HEIGHT, TRIANGLE_THICKNESS]);
            translate([0 - FLEX_JOINT_WIDTH / 2, TRIANGLE_HEIGHT * (1 - TIP_KOEF), 0])
                cube([FLEX_JOINT_WIDTH, FLEX_JOINT_WIDTH, FLEX_JOINT_HEIGHT]);
        }
    }
}


module pyramid_segment() {
    translate([0, 0 - CENTER_DIST - SIDE_OFFSET , 0])
        rotate([0 - ANGLE_A, 0, 0])
            rotate([90, 0, 0])
                pyramid_face();
}

module model() {
    union() {
        for(I=[0:2]) {
            rotate([0, 0, I * 120]) {
                pyramid_segment();
            }
        };
    }
};

render() model();

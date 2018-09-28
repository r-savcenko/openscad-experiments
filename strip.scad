STRIP_WIDTH = 8;
STRIP_OUTER_WIDTH = 40;
STRIP_THICKNESS = 3;
CUTOUT_COUNT = 3;
CORNER_CUTOUTS = true;

/** DO NOT EDIT FOLLOWING VARS **/

STRIP_INNER_WIDTH = STRIP_OUTER_WIDTH - STRIP_WIDTH * 2;
WIDTH_DIFF = (STRIP_OUTER_WIDTH - STRIP_INNER_WIDTH) / 2;

JOINT_WIDTH = STRIP_WIDTH * 0.75;
JOINT_SIDE_WIDTH = STRIP_THICKNESS + 1;
JOINT_HEIGHT = STRIP_THICKNESS;

include <common/hinge-clip-joint.scad>

CUTOUT_RADIUS = STRIP_WIDTH / 3.5;

module base(SIZE_Z = STRIP_THICKNESS) {
    X1 = 0;
    Y1 = 0;

    X2 = X1 + STRIP_OUTER_WIDTH;
    Y2 = Y1;

    X3 = X2 - WIDTH_DIFF;
    Y3 = Y2 + STRIP_WIDTH;

    X4 = X1 + WIDTH_DIFF;
    Y4 = Y3;

    linear_extrude(SIZE_Z)
        polygon([[X1,Y1], [X2,Y2], [X3,Y3], [X4,Y4]]);
}

module assembly() {
    base();

    translate([WIDTH_DIFF / 2, STRIP_WIDTH / 2, 0])
        rotate([0, 0, 45])
            hinge();

    translate([STRIP_OUTER_WIDTH - WIDTH_DIFF / 2, STRIP_WIDTH / 2, 0])
        rotate([0, 0, -45])
            clip();

    translate([WIDTH_DIFF, 0, 0])
        rotate([0, 0, 180])
            clip();

    translate([STRIP_OUTER_WIDTH - WIDTH_DIFF, 0, 0])
        rotate([0, 0, 180])
            hinge();
}

module cutout_piece() {
    R2 = CUTOUT_RADIUS;
    //R1 = R2 * 0.5;
    translate([0, 0, -1])
        cylinder(h=STRIP_THICKNESS + 2, r1=R2, r2=R2, $fn=16);
}

module cutout(COUNT = 2) {
    if (COUNT > 1) {
        KOEF = 1.6;
        SX = WIDTH_DIFF * KOEF;
        EX = STRIP_OUTER_WIDTH - WIDTH_DIFF * KOEF;
        STEP = (EX - SX) / (COUNT - 1);
        for(I = [0:COUNT - 1]) {
            translate([SX + I * STEP, STRIP_WIDTH / 2, 0]) cutout_piece();
        }
    }
}

module model() {
    difference() {
        assembly();
        cutout(CUTOUT_COUNT);
        if (CORNER_CUTOUTS) {
            translate([WIDTH_DIFF, STRIP_WIDTH / 2.5, 0])
                scale([0.5, 0.5, 1])
                    cutout_piece();

            translate([STRIP_OUTER_WIDTH - WIDTH_DIFF, STRIP_WIDTH / 2.5, 0])
                scale([0.5, 0.5, 1])
                    cutout_piece();
        }
    }
}


model();

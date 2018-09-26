STRIP_WIDTH = 8;
STRIP_OUTER_WIDTH = 40;
STRIP_INNER_WIDTH = STRIP_OUTER_WIDTH - STRIP_WIDTH * 2;
STRIP_THICKNESS = 3;
CUTOUT_COUNT = 3;
CORNER_CUTOUTS = true;

CLIP_TOLERANCE_MARGIN = 0.3;
CLIP_SIDE_TOLERANCE_MARGIN = 0.5;

HINGE_SIDE_THICKNESS = 1;

/** DO NOT EDIT FOLLOWING VARS **/

WIDTH_DIFF = (STRIP_OUTER_WIDTH - STRIP_INNER_WIDTH) / 2;

JOINT_WIDTH = STRIP_WIDTH * 0.75;
JOINT_SIDE_WIDTH = STRIP_THICKNESS + 1;
JOINT_HEIGHT = STRIP_THICKNESS;
JOINT_CORNER_RADIUS = 1;
JOINT_CILINDER_RADIUS = STRIP_THICKNESS / 5;
CLIP_WIDTH = JOINT_WIDTH - HINGE_SIDE_THICKNESS * 2 - CLIP_SIDE_TOLERANCE_MARGIN * 2;

CUTOUT_RADIUS = STRIP_WIDTH / 3.5;

module joint_side(WIDTH = JOINT_WIDTH) {
    SIZE_X = WIDTH;
    SIZE_Y = JOINT_SIDE_WIDTH - JOINT_CORNER_RADIUS;
    SIZE_Z = JOINT_HEIGHT;    
    hull() {
        cube([SIZE_X, SIZE_Y, SIZE_Z]);
    
        translate([0, SIZE_Y, SIZE_Z - JOINT_CORNER_RADIUS])
            rotate(90, [0, 1, 0])
                cylinder(h=WIDTH, r=JOINT_CORNER_RADIUS, $fn=16);
        
        
        translate([0, SIZE_Y, JOINT_CORNER_RADIUS])
            rotate(90, [0, 1, 0])
                cylinder(h=WIDTH, r=JOINT_CORNER_RADIUS, $fn=16);
    }

}

module joint_cilinder(MARGIN = 0) {
    RADIUS = JOINT_CILINDER_RADIUS + MARGIN;
    translate([0 - JOINT_WIDTH / 2, JOINT_SIDE_WIDTH - JOINT_CILINDER_RADIUS * 2, JOINT_HEIGHT / 2])
        rotate(90, [0, 1, 0])
            cylinder(h=JOINT_WIDTH, r=RADIUS, $fn=16);
}

module hinge() {    
    union() {
        translate([0 - JOINT_WIDTH / 2, 0, 0])
            joint_side(WIDTH = HINGE_SIDE_THICKNESS);
        
        translate([JOINT_WIDTH / 2 - HINGE_SIDE_THICKNESS, 0, 0])
            joint_side(WIDTH = HINGE_SIDE_THICKNESS);
        
        joint_cilinder();
    }
}

module clip() {
    WIDTH = CLIP_WIDTH;

    CLEARANCE_SIZE_X = JOINT_WIDTH;
    CLEARANCE_SIZE_Y = JOINT_CILINDER_RADIUS * 2;
    CLEARANCE_SIZE_Z = JOINT_CILINDER_RADIUS * 1.5;

    difference() {
        translate([0 - WIDTH / 2, 0, 0])
            joint_side(WIDTH);
    
        union() {
            scale([1.5, 1, 1]) {
                joint_cilinder(CLIP_TOLERANCE_MARGIN);
                translate([0 - CLEARANCE_SIZE_X / 2, JOINT_SIDE_WIDTH - CLEARANCE_SIZE_Y, JOINT_HEIGHT / 2 - CLEARANCE_SIZE_Z / 2])
                    cube([CLEARANCE_SIZE_X, CLEARANCE_SIZE_Y + 1, CLEARANCE_SIZE_Z]);
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

module base(SIZE_Z = STRIP_THICKNESS) {
    OUTER = STRIP_OUTER_WIDTH;
    INNER = STRIP_INNER_WIDTH;
    WIDTH = STRIP_WIDTH;
    DIFF = WIDTH_DIFF;

    X1 = 0;
    Y1 = 0;

    X2 = X1 + OUTER;
    Y2 = Y1;

    X3 = X2 - DIFF;
    Y3 = Y2 + WIDTH;

    X4 = X1 + DIFF;
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
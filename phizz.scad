TRIANGLE_WIDTH = 30;
TRIANGLE_THICKNESS = 4;

FLEX_JOINT_WIDTH = 1;
FLEX_JOINT_HEIGHT = 0.5;

CLIP_TOLERANCE_MARGIN = 0.3;
CLIP_SIDE_TOLERANCE_MARGIN = 0.5;

HINGE_SIDE_THICKNESS = 1;

/** DO NOT EDIT FOLLOWING VARS **/

JOINT_WIDTH = TRIANGLE_WIDTH / 4 - FLEX_JOINT_WIDTH;
JOINT_SIDE_WIDTH = TRIANGLE_THICKNESS;
JOINT_HEIGHT = TRIANGLE_THICKNESS;
JOINT_CORNER_RADIUS = 1;
JOINT_CILINDER_RADIUS = TRIANGLE_THICKNESS / 5;
CLIP_WIDTH = JOINT_WIDTH - HINGE_SIDE_THICKNESS * 2 - CLIP_SIDE_TOLERANCE_MARGIN * 2;

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


module base_model() {
    union() {
        base();
        translate([TRIANGLE_WIDTH / 4, TRIANGLE_WIDTH / 4, 0]) rotate(-45, [0, 0, 1]) hinge();
        translate([0 - TRIANGLE_WIDTH / 4, TRIANGLE_WIDTH / 4, 0]) rotate(45, [0, 0, 1]) clip();

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
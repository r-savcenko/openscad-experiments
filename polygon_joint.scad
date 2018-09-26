JOINT_CORNER_RADIUS = 1;
JOINT_CILINDER_RADIUS = JOINT_HEIGHT / 5;
CLIP_WIDTH = JOINT_WIDTH - HINGE_SIDE_THICKNESS * 2 - CLIP_SIDE_TOLERANCE_MARGIN * 2;

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
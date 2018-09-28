/*
The following vars should be included prior to importing this file

After inclusion - use clip() or hinge() modules as you like

Required vars (no default value):
JOINT_WIDTH = 10;
JOINT_SIDE_WIDTH = 5;
JOINT_HEIGHT = 5;

Optional vars (with defaults):
CLIP_TOLERANCE_MARGIN = 0.3;
CLIP_SIDE_TOLERANCE_MARGIN = 0.5;
HINGE_SIDE_THICKNESS = 1;
JOINT_CORNER_RADIUS = 1;
*/

function getValue(variable, default) = variable == undef ? default : variable;

HINGE_SIDE_THICKNESS_ = getValue(HINGE_SIDE_THICKNESS, 1);
CLIP_TOLERANCE_MARGIN_ = getValue(CLIP_TOLERANCE_MARGIN, 0.3);
CLIP_SIDE_TOLERANCE_MARGIN_ = getValue(CLIP_SIDE_TOLERANCE_MARGIN, 0.5);
JOINT_CORNER_RADIUS_ = getValue(JOINT_CORNER_RADIUS, 1);


JOINT_CILINDER_RADIUS = JOINT_HEIGHT / 5;
CLIP_WIDTH = JOINT_WIDTH - HINGE_SIDE_THICKNESS_ * 2 - CLIP_SIDE_TOLERANCE_MARGIN_ * 2;

module joint_side(WIDTH = JOINT_WIDTH) {
    SIZE_X = WIDTH;
    SIZE_Y = JOINT_SIDE_WIDTH - JOINT_CORNER_RADIUS_;
    SIZE_Z = JOINT_HEIGHT;
    hull() {
        cube([SIZE_X, SIZE_Y, SIZE_Z]);

        translate([0, SIZE_Y, SIZE_Z - JOINT_CORNER_RADIUS_])
            rotate(90, [0, 1, 0])
                cylinder(h=WIDTH, r=JOINT_CORNER_RADIUS_, $fn=16);


        translate([0, SIZE_Y, JOINT_CORNER_RADIUS_])
            rotate(90, [0, 1, 0])
                cylinder(h=WIDTH, r=JOINT_CORNER_RADIUS_, $fn=16);
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
            joint_side(WIDTH = HINGE_SIDE_THICKNESS_);

        translate([JOINT_WIDTH / 2 - HINGE_SIDE_THICKNESS_, 0, 0])
            joint_side(WIDTH = HINGE_SIDE_THICKNESS_);

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
                joint_cilinder(CLIP_TOLERANCE_MARGIN_);
                translate([0 - CLEARANCE_SIZE_X / 2, JOINT_SIDE_WIDTH - CLEARANCE_SIZE_Y, JOINT_HEIGHT / 2 - CLEARANCE_SIZE_Z / 2])
                    cube([CLEARANCE_SIZE_X, CLEARANCE_SIZE_Y + 1, CLEARANCE_SIZE_Z]);
            }
        }
    }
}

$fn = 64;

KNOB_OUTER_D=15;
KNOB_INNER_D=12;
KNOB_OUTER_SIZE_Z=12;
KNOB_INNER_SIZE_Z=11;

KNOB_CAP_SIZE_Z=2;
KNOB_CAP_SPHERE_R=16;

NUMBER_OF_CUTS=8;

KNOB_GRAB_SIZE_Z=7.5;
KNOB_GRAB_D=6; /////////////////////////////////////////////// CHANGE_THIS. tried [8, 7, 6]  
KNOB_GRAB_THICKNESS=1;
KNOB_GRAB_FIXATOR_THICKNESS=2.5; ///////////////////////////// CHANGE_THIS: tried [3, 2.5]

KNOB_OUTER_R=KNOB_OUTER_D / 2;
KNOB_INNER_R=KNOB_INNER_D / 2;
KNOB_GRAB_R=KNOB_GRAB_D / 2;

KNOB_CUT_RADIUS=3;
KNOB_CUT_ANGLE=360/NUMBER_OF_CUTS;

KNOB_CUT_DISTANCE=KNOB_OUTER_R - 0.6;

module knob_base() {
    difference() {
        cylinder(r=KNOB_OUTER_R, h=KNOB_OUTER_SIZE_Z - 0.4);
        translate([0, 0, -1])
            cylinder(r=KNOB_INNER_R, h=KNOB_INNER_SIZE_Z + 1);
    }
}

module knob_cap() {
    difference() {
        intersection() {
            cylinder(r=KNOB_OUTER_R, h=KNOB_OUTER_SIZE_Z * 2);
            translate([0, 0, 0 - KNOB_CAP_SPHERE_R + KNOB_OUTER_SIZE_Z + KNOB_CAP_SIZE_Z])
                sphere(r=KNOB_CAP_SPHERE_R, $fn = 128);
        }
        cylinder(r=KNOB_OUTER_R, h=KNOB_OUTER_SIZE_Z - 0.4);
    }
}

module knob_cut() {
    for(i=[0:NUMBER_OF_CUTS]) {
        rotate([0, 0, i * KNOB_CUT_ANGLE])
            translate([KNOB_CUT_RADIUS + KNOB_CUT_DISTANCE, 0, -1])
                cylinder(r=KNOB_CUT_RADIUS, h=KNOB_OUTER_SIZE_Z * 2);
    }
}

module knob_inner() {
    translate([0, 0, KNOB_INNER_SIZE_Z - KNOB_GRAB_SIZE_Z]) {
        difference() {
            cylinder(r=KNOB_GRAB_R + KNOB_GRAB_THICKNESS, h=KNOB_GRAB_SIZE_Z);
            translate([0, 0, -1])
                cylinder(r=KNOB_GRAB_R, h=KNOB_GRAB_SIZE_Z + 1);
        }
        intersection() {
            cylinder(r=KNOB_GRAB_R, h=KNOB_GRAB_SIZE_Z);
            translate([0-KNOB_GRAB_R, KNOB_GRAB_R - KNOB_GRAB_FIXATOR_THICKNESS, 0])
                cube([KNOB_GRAB_D, KNOB_GRAB_D, KNOB_GRAB_SIZE_Z]);
        }
    }
}

difference() {
    union() {
        /* knob_cap(); */
        knob_base();
        knob_inner();
    }
    knob_cut();
}

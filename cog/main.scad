BASE_DIAMETER = 100;
BASE_SIZE_Z = 10;

BASE_SUPPORT_THICKNESS = 4;

BASE_INSET_DIAMETER = 90;
BASE_INSET_SIZE_Z = 5;

BASE_TOOTH_SIZE_Y = 4;
BASE_TOOTH_SIZE_X_BOTTOM = 3;
BASE_TOOTH_SIZE_X_TOP = 1;
BASE_TEETH_NUMBER = 72;

INNER_TOOTH_SIZE_Y = 4;
INNER_TOOTH_SIZE_X_BOTTOM = 2.5;
INNER_TOOTH_SIZE_X_TOP = 2.5;
INNER_TEETH_NUMBER = 9;

CENTER_CYL_OUTER_DIAMETER = 12;
CENTER_CYL_INNER_DIAMETER = 6;
CENTER_CYL_SIZE_Z = 20;

module support() {
    linear_extrude(BASE_SIZE_Z) {
        square(size = [BASE_SUPPORT_THICKNESS, BASE_DIAMETER - 0.5], center = true);
        rotate([0, 0, 90])
            square(size = [BASE_SUPPORT_THICKNESS, BASE_DIAMETER - 0.5], center = true);
    }
}

module inset() {
    linear_extrude(BASE_INSET_SIZE_Z * 2) {
        circle(r = BASE_INSET_DIAMETER / 2, $fn = 36);
    }
}

module base() {
    linear_extrude(BASE_SIZE_Z) {
        circle(r = BASE_DIAMETER / 2, $fn = 36);
    }
}

module tooth(SIZE_X_BOTTOM, SIZE_X_TOP, SIZE_Y, SIZE_Z) {
    linear_extrude(SIZE_Z) {
        x1 = SIZE_X_BOTTOM / 2;
        x2 = 0 - x1;
        x3 = SIZE_X_TOP / 2;
        x4 = 0 - x3;
        y1 = 0;
        y2 = SIZE_Y;
        polygon([
            [x1, y1],
            [x2, y1],
            [x4, y2],
            [x3, y2]
        ]);
    }
}

module teeth(NUMBER, DISTANCE) {
    step = 360 / NUMBER;
    for (i = [0:NUMBER]) {
        rotate([0, 0, i * step])
            translate([0, DISTANCE, 0])
                children();
    }
}

module inner_tooth() {
    translate([0, INNER_TOOTH_SIZE_Y - INNER_TOOTH_SIZE_X_TOP / 2, 0]) cylinder(r=INNER_TOOTH_SIZE_X_TOP / 2, h=CENTER_CYL_SIZE_Z, $fn=8);
    tooth(
        INNER_TOOTH_SIZE_X_BOTTOM,
        INNER_TOOTH_SIZE_X_TOP,
        INNER_TOOTH_SIZE_Y - INNER_TOOTH_SIZE_X_TOP / 2,
        CENTER_CYL_SIZE_Z
    );
}

module base_teeth() {
    teeth(BASE_TEETH_NUMBER, BASE_DIAMETER / 2 - 0.2) {
        tooth(
            BASE_TOOTH_SIZE_X_BOTTOM,
            BASE_TOOTH_SIZE_X_TOP,
            BASE_TOOTH_SIZE_Y,
            BASE_SIZE_Z
        );
    }
}

module inner_teeth() {
    teeth(INNER_TEETH_NUMBER, CENTER_CYL_OUTER_DIAMETER / 2 - 0.2) {
        inner_tooth();
    }
}

module center_cyl() {
    cylinder(r=CENTER_CYL_OUTER_DIAMETER / 2, h=CENTER_CYL_SIZE_Z, $fn=18);
}

module assembly() {
    difference() {
        union() {
            difference() {
                base();
                translate([0, 0, BASE_SIZE_Z - BASE_INSET_SIZE_Z])
                    inset();
            }
            support();
            cylinder(r=CENTER_CYL_OUTER_DIAMETER / 2, h=CENTER_CYL_SIZE_Z, $fn=18);
        }
        translate([0, 0, -1])
            cylinder(r=CENTER_CYL_INNER_DIAMETER / 2, h=CENTER_CYL_SIZE_Z + 2, $fn=18);
    }
    base_teeth();
    inner_teeth();
}

assembly();

BASE_DIAMETER = 100;
BASE_SIZE_Z = 10;

BASE_SUPPORT_THICKNESS = 4;

BASE_INSET_DIAMETER = 90;
BASE_INSET_SIZE_Z = 5;

BASE_TOOTH_SIZE_Y = 4;
BASE_TOOTH_SIZE_X_BOTTOM = 3;
BASE_TOOTH_SIZE_X_TOP = 1;

BASE_TEETH_NUMBER = 36;

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

module base_tooth() {
    tooth(BASE_TOOTH_SIZE_X_BOTTOM, BASE_TOOTH_SIZE_X_TOP, BASE_TOOTH_SIZE_Y, BASE_SIZE_Z);
    /* linear_extrude(BASE_SIZE_Z) {
        x1 = BASE_TOOTH_SIZE_X_BOTTOM / 2;
        x2 = 0 - x1;
        x3 = BASE_TOOTH_SIZE_X_TOP / 2;
        x4 = 0 - x3;
        y1 = 0;
        y2 = BASE_TOOTH_SIZE_Y;
        polygon([
            [x1, y1],
            [x2, y1],
            [x4, y2],
            [x3, y2]
        ]);
    } */
}

module base_teeth() {
    step = 360 / BASE_TEETH_NUMBER;
    for (i = [0:BASE_TEETH_NUMBER]) {
        rotate([0, 0, i * step])
            translate([0, BASE_DIAMETER / 2 - 0.2, 0])
                base_tooth();
    }
}

module assembly() {
    difference() {
        base();
        translate([0, 0, BASE_SIZE_Z - BASE_INSET_SIZE_Z])
            inset();
    }
    support();
}

assembly();
base_teeth();

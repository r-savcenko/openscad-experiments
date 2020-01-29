$fn = 32;
GENERAL_THICKNESS = 5;

BASE_DIAMETER = 84;
BASE_RADIUS = BASE_DIAMETER / 2;
BASE_BOTTOM_ROUND_RADIUS = 5;
BASE_BOTTOM_INSET = 7.5;

TOTAL_HEIGHT = 129;
BASE_TOP_ROUND_RADIUS = 20;

SEGMENT_SIZE_Z = 2.5;
SEGMENT_BOTTOM_THICKNESS = 10;

OUTSIDE_BOTTOM_ROUND_RADIUS = 10;

OUTSIDE_TOP_LEFT_RADIUS = 20;
OUTSIDE_TOP_RADIUS = 50;
TOP_DIFF = 4;

MARGIN = 0.2;

CUTS_START_ANGLE = 120;
SEGMENT_COUNT = 6;

RING_POS_Z_1 = 25;
RING_POS_Z_2 = 101;

SEGMENT_ANGlE = CUTS_START_ANGLE * 2 / (SEGMENT_COUNT - 1);

module segment_cutout_inner() {
        translate([BASE_BOTTOM_ROUND_RADIUS, BASE_BOTTOM_ROUND_RADIUS, 0])
            circle(r = BASE_BOTTOM_ROUND_RADIUS);

        translate([BASE_TOP_ROUND_RADIUS - TOP_DIFF, TOTAL_HEIGHT - BASE_TOP_ROUND_RADIUS, 0])
            resize([BASE_TOP_ROUND_RADIUS * 2 - TOP_DIFF * 2, BASE_TOP_ROUND_RADIUS * 2])
                circle(r = BASE_TOP_ROUND_RADIUS);

        translate([BASE_TOP_ROUND_RADIUS - TOP_DIFF, 0, 0])
            square([100, TOTAL_HEIGHT]);

        translate([0, BASE_BOTTOM_ROUND_RADIUS, 0])
            square([BASE_TOP_ROUND_RADIUS, TOTAL_HEIGHT - BASE_BOTTOM_ROUND_RADIUS - BASE_TOP_ROUND_RADIUS]);

        translate([BASE_BOTTOM_ROUND_RADIUS, 0, 0])
            square([BASE_TOP_ROUND_RADIUS, BASE_BOTTOM_ROUND_RADIUS]);
};

module segment_cutout() {
    translate([0, 0, 0 - SEGMENT_SIZE_Z / 2]) {
        linear_extrude(SEGMENT_SIZE_Z * 2)
            segment_cutout_inner();

        linear_extrude(SEGMENT_SIZE_Z * 2)
            translate([0 - OUTSIDE_BOTTOM_ROUND_RADIUS - GENERAL_THICKNESS, OUTSIDE_BOTTOM_ROUND_RADIUS - SEGMENT_BOTTOM_THICKNESS, 0])
                circle(r = OUTSIDE_BOTTOM_ROUND_RADIUS);

        linear_extrude(SEGMENT_SIZE_Z * 2)
            translate([0 - OUTSIDE_TOP_LEFT_RADIUS, TOTAL_HEIGHT + OUTSIDE_TOP_LEFT_RADIUS * 0.5, 0])
                circle(r = OUTSIDE_TOP_LEFT_RADIUS, $fn = 64);

        linear_extrude(SEGMENT_SIZE_Z * 2)
            translate([OUTSIDE_TOP_RADIUS * 0.7, TOTAL_HEIGHT + OUTSIDE_TOP_RADIUS * 0.94, 0])
                circle(r = OUTSIDE_TOP_RADIUS, $fn = 64);
    }
};

module segment_ring_cut(pos_y) {
    translate([0 - GENERAL_THICKNESS * 2.5, pos_y, -1])
        linear_extrude(GENERAL_THICKNESS + 2)
            square([GENERAL_THICKNESS * 2, SEGMENT_SIZE_Z]);
}

module segment_raw() {
    x1 = 0 - OUTSIDE_BOTTOM_ROUND_RADIUS - GENERAL_THICKNESS;
    x2 = 0 - OUTSIDE_TOP_LEFT_RADIUS;
    x3 = OUTSIDE_TOP_RADIUS * 0.7;
    x4 = BASE_BOTTOM_INSET;
    x5 = BASE_BOTTOM_INSET * 2;

    y1 = 0 - OUTSIDE_BOTTOM_ROUND_RADIUS;
    y2 = TOTAL_HEIGHT + OUTSIDE_TOP_LEFT_RADIUS * 0.5;
    y3 = TOTAL_HEIGHT + OUTSIDE_TOP_RADIUS;
    y4 = 0;
    y5 = 0 - SEGMENT_BOTTOM_THICKNESS;

    COORDS = [
        [x1, y1],
        [x1 + OUTSIDE_BOTTOM_ROUND_RADIUS, y1 + OUTSIDE_BOTTOM_ROUND_RADIUS],
        [x2 + OUTSIDE_BOTTOM_ROUND_RADIUS, y2],
        [x3, y3],
        [x4, y4],
        [x5, y5]
    ];

    difference() {
        linear_extrude(SEGMENT_SIZE_Z)
            polygon(COORDS);
        segment_cutout();
    };
}

module front_cyl_cut() {
    x1 = 0;
    x2 = 90;
    x3 = 0 - x2;

    y1 = 0;
    y2 = 60;
    y3 = y2;

    COORDS = [
        [x1, y1],
        [x2, y2],
        [x3, y3]
    ];

    translate([0, 0, -1])
        linear_extrude(GENERAL_THICKNESS + 2)
            polygon(COORDS);
}

module base_cyl() {
    difference() {
        cylinder(r=BASE_RADIUS + GENERAL_THICKNESS, h=GENERAL_THICKNESS, $fn = 64);
        translate([0, 0, -1])
            cylinder(r=BASE_RADIUS, h=GENERAL_THICKNESS + 2, $fn = 64);
        front_cyl_cut();
    }
}

module base_cyl_cut() {
    segment_cut_size_x = SEGMENT_SIZE_Z + MARGIN * 2;

    translate([0 - segment_cut_size_x / 2, 0 - GENERAL_THICKNESS * 0.5 - BASE_RADIUS, -1])
        linear_extrude(GENERAL_THICKNESS + 2)
            square([segment_cut_size_x, GENERAL_THICKNESS]);
}

module base_ring() {
    difference() {
        base_cyl();
        for (i=[0:SEGMENT_COUNT - 1]) {
            rotate([0, 0, 0 - CUTS_START_ANGLE + i * SEGMENT_ANGlE])
                base_cyl_cut();
        }

    }
}

module segment() {
    difference() {
        segment_raw();
        segment_ring_cut(RING_POS_Z_1);
        segment_ring_cut(RING_POS_Z_2);
    }
}

base_ring();
segment();

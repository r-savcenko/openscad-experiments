$fn = 32;

BASE_DIAMETER = 84;
BASE_RADIUS = BASE_DIAMETER / 2;
BASE_BOTTOM_ROUND_RADIUS = 5;
BASE_BOTTOM_INSET = 7.5;

TOTAL_HEIGHT = 129;
BASE_TOP_ROUND_RADIUS = 20;

SEGMENT_SIZE_Z = 2.5;
SEGMENT_THICKNESS = 5;
SEGMENT_BOTTOM_THICKNESS = 10;

OUTSIDE_BOTTOM_ROUND_RADIUS = 10;

OUTSIDE_TOP_LEFT_RADIUS = 20;
OUTSIDE_TOP_RADIUS = 50;
TOP_DIFF = 4;

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
            translate([0 - OUTSIDE_BOTTOM_ROUND_RADIUS - SEGMENT_THICKNESS, OUTSIDE_BOTTOM_ROUND_RADIUS - SEGMENT_BOTTOM_THICKNESS, 0])
                circle(r = OUTSIDE_BOTTOM_ROUND_RADIUS);

        linear_extrude(SEGMENT_SIZE_Z * 2)
            translate([0 - OUTSIDE_TOP_LEFT_RADIUS, TOTAL_HEIGHT + OUTSIDE_TOP_LEFT_RADIUS * 0.5, 0])
                circle(r = OUTSIDE_TOP_LEFT_RADIUS, $fn = 64);

        #linear_extrude(SEGMENT_SIZE_Z * 2)
            translate([OUTSIDE_TOP_RADIUS * 0.7, TOTAL_HEIGHT + OUTSIDE_TOP_RADIUS * 0.94, 0])
                circle(r = OUTSIDE_TOP_RADIUS, $fn = 64);
    }
};


x1 = 0 - OUTSIDE_BOTTOM_ROUND_RADIUS - SEGMENT_THICKNESS;
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

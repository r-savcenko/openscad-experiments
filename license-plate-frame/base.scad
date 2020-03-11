include <../common/din/din912.scad>
include <../common/din/din934.scad>

PLATE_SIZE_X = 250;
PLATE_SIZE_Y = 150;
PLATE_SIZE_Z = 3;

FRAME_BACK_BAR_WIDTH = 20;
FRAME_BACK_BAR_SIZE_Z = 5;


INNER_CORNER_RADIUS = 5;

FRAME_ADD_X = 10;
FRAME_ADD_Y = 10;

FRAME_BAR_ANGLE_ADJUST = 2;

FRAME_BAR_SIDE_THICKNESS = 15;

module bar(add_x = 0, add_y = 0) {
    FRAME_BACK_BAR_LENGTH = sqrt(pow(PLATE_SIZE_X / 2 + add_x, 2) + pow(PLATE_SIZE_Y / 2 + add_y, 2));
    angle = asin(PLATE_SIZE_Y / 2 / FRAME_BACK_BAR_LENGTH);
    rotate([0, 0, angle + FRAME_BAR_ANGLE_ADJUST])
        translate([0, 0 - FRAME_BACK_BAR_WIDTH / 2, 0])
            cube([FRAME_BACK_BAR_LENGTH, FRAME_BACK_BAR_WIDTH, FRAME_BACK_BAR_SIZE_Z]);
}

module base_plate(size_z, add_x = 0, add_y = 0, corner_radius = INNER_CORNER_RADIUS) {
    translate([PLATE_SIZE_X / 2 - corner_radius + add_x, PLATE_SIZE_Y / 2 - corner_radius + add_y, 0])
        cylinder(r=corner_radius, h=size_z, $fn=32);
    cube([PLATE_SIZE_X / 2 - corner_radius + add_x, PLATE_SIZE_Y / 2 + add_y, size_z]);
    cube([PLATE_SIZE_X / 2 + add_x, PLATE_SIZE_Y / 2 - corner_radius + add_y, size_z]);
}

module side_bar(thickness = FRAME_BAR_SIDE_THICKNESS) {
    cube([thickness, PLATE_SIZE_Y / 2 - INNER_CORNER_RADIUS + FRAME_ADD_X, FRAME_BACK_BAR_SIZE_Z]);
}

module quarter_raw() {
    intersection() {
        bar(FRAME_ADD_X, FRAME_ADD_Y);
        base_plate(FRAME_BACK_BAR_SIZE_Z, FRAME_ADD_X, FRAME_ADD_Y);
    }
    translate([0, PLATE_SIZE_Y / 2 - FRAME_BAR_SIDE_THICKNESS + FRAME_ADD_Y, 0])
        cube([PLATE_SIZE_X / 2 - INNER_CORNER_RADIUS + FRAME_ADD_X, FRAME_BAR_SIDE_THICKNESS, FRAME_BACK_BAR_SIZE_Z]);
    side_bar( FRAME_BAR_SIDE_THICKNESS );
    translate([PLATE_SIZE_X / 2 - FRAME_BAR_SIDE_THICKNESS + FRAME_ADD_X, 0, 0])
        side_bar();
}

module quarter() {
    start_x = PLATE_SIZE_X / 2 - INNER_CORNER_RADIUS + FRAME_ADD_X - 1;
    start_y = PLATE_SIZE_Y / 2 - INNER_CORNER_RADIUS + FRAME_ADD_Y - 1;

    JOINT_COORDS = [
        [start_x, start_y],
        [start_x - 20, start_y],
        [start_x, start_y - 20]
    ];

    din934(9, FRAME_BACK_BAR_SIZE_Z, JOINT_COORDS) {
        quarter_raw();
    }
}

difference() {
    translate([0, 0, FRAME_BACK_BAR_SIZE_Z]) {
        mirror([0, 0, 1]) {
            quarter();
            mirror([0, 1, 0])
                quarter();
        }
    }
    translate([0, 0, PLATE_SIZE_Z / 2 + 2]) cube([PLATE_SIZE_X, PLATE_SIZE_Y, PLATE_SIZE_Z], center=true);
}

/* color("lime") translate([0, 0, PLATE_SIZE_Z / 2 + 2]) cube([PLATE_SIZE_X, PLATE_SIZE_Y, PLATE_SIZE_Z], center=true); */

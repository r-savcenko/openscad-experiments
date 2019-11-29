BASE_CORNER_RADIUS=1;
BASE_SIZE_X=40;
BASE_SIZE_Y=10;
THICKNESS=1;

BASE_CUTOUT_SIZE_X=20;
BASE_CUTOUT_SIZE_Y=5;

HOLDER_HEIGHT=10;
HOLDER_STICKOUT=0.4;

HOLE_DIAMETER=2;
HOLE_DISTANCE_X= 4;
HOLE_DISTANCE_Y= BASE_SIZE_Y / 2;



module smooth_rect(size_x, size_y, size_z, corner_radius = 0.1) {
    x1 = 0 - size_x / 2 + corner_radius;
    x2 = 0 - x1;
    y1 = 0 - size_y / 2 + corner_radius;
    y2 = 0 - y1;
    coords = [
        [x1, y1],
        [x1, y2],
        [x2, y2],
        [x2, y1]
    ];
    hull() {
        linear_extrude(size_z) {
            for(i=[0:len(coords) - 1]) {
                x = coords[i][0];
                y = coords[i][1];
                translate([x, y, 0])
                    circle(r = corner_radius, $fn=16);
            }
        }
    }
}

module holder() {
    poly = [
        [0, 0],
        [THICKNESS, 0],
        [0, HOLDER_STICKOUT + THICKNESS]
    ];

    translate([0 - THICKNESS / 2, 0 - BASE_CUTOUT_SIZE_Y / 2, HOLDER_HEIGHT - THICKNESS])
        rotate([90, -90, 180])
            linear_extrude(BASE_CUTOUT_SIZE_Y)
                polygon(poly);
    translate([0, 0, (HOLDER_HEIGHT - THICKNESS) / 2])
        cube([THICKNESS, BASE_CUTOUT_SIZE_Y, HOLDER_HEIGHT - THICKNESS], true);
}

module base() {
    difference() {
        smooth_rect(BASE_SIZE_X, BASE_SIZE_Y, THICKNESS, BASE_CORNER_RADIUS);
        translate([0, 0, 0 - THICKNESS / 2])
            smooth_rect(BASE_CUTOUT_SIZE_X, BASE_CUTOUT_SIZE_Y, THICKNESS * 2);
    }
}

module holes() {
    translate([BASE_SIZE_X / 2 - HOLE_DISTANCE_X, 0, 0 - THICKNESS / 2])
        cylinder(h=THICKNESS * 2, d=HOLE_DIAMETER, $fn=16);

    mirror([1, 0, 0])
        translate([BASE_SIZE_X / 2 - HOLE_DISTANCE_X, 0, 0 - THICKNESS / 2])
            cylinder(h=THICKNESS * 2, d=HOLE_DIAMETER, $fn=16);
}

module assembly() {
    difference() {
        base();
        holes();
    }
    translate([0 - BASE_CUTOUT_SIZE_X / 2 - THICKNESS / 2, 0, 0])
        holder();
    mirror([1, 0, 0])
        translate([0 - BASE_CUTOUT_SIZE_X / 2 - THICKNESS / 2, 0, 0])
            holder();
}

render() {
    assembly();
}

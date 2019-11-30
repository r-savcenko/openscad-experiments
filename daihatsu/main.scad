BASE_CORNER_RADIUS=2;
BASE_SIZE_X=36.00;
BASE_SIZE_Y=13.00;
THICKNESS=2;

BASE_CUTOUT_SIZE_X=21;
BASE_CUTOUT_SIZE_Y=5;

HOLDER_HEIGHT=7;
HOLDER_STICKOUT=0.75;

HOLE_DIAMETER=2;
HOLE_DISTANCE_X= 2;

SIDE_THICKNESS=2;
SIDE_SIZE_X=22.5;
SIDE_SIZE_Z=6;

CENTER_SIZE_X=12;

CENTER_CYL_R1=2;
CENTER_CYL_R2=1;
CENTER_CYL_H=4;

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

    translate([BASE_SIZE_X / 2 - HOLE_DISTANCE_X - 0.5, 0, 0 - THICKNESS / 2])
        cylinder(h=THICKNESS * 2, d=HOLE_DIAMETER, $fn=16);

    mirror([1, 0, 0])
        translate([BASE_SIZE_X / 2 - HOLE_DISTANCE_X - 0.5, 0, 0 - THICKNESS / 2])
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
    cylinder(r1=CENTER_CYL_R1, r2=CENTER_CYL_R2, h=CENTER_CYL_H,$fn=16);
    translate([0, 0, THICKNESS/2])
        cube([CENTER_SIZE_X, BASE_SIZE_Y, THICKNESS], center=true);
    mirror([0,1,0])
        translate([0, BASE_SIZE_Y/2-THICKNESS/2, SIDE_SIZE_Z/2])
            cube([SIDE_SIZE_X, THICKNESS, SIDE_SIZE_Z], center=true);
    translate([0, BASE_SIZE_Y/2-THICKNESS/2, SIDE_SIZE_Z/2])
        cube([SIDE_SIZE_X, THICKNESS, SIDE_SIZE_Z], center=true);
    assembly();
}

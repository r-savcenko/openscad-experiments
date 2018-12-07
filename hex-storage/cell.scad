/* [Params:] */
// Outer radius of the cell
outer_r = 25; // [20:50]

// Height of the cell
height = 60; // [30:150]

// Walls' thickness
thickness = 2; // [2:0.1:3]

// Tolerance in (mm)
tolerance = 0.075; // [0:0.005:0.1]

/* [Render:] */
// Cell
render_cell = true;

// Cell joints
render_joints = true;

// Drawer
render_drawer = true;

/* [Hidden] */
sides = 6;
r_koef = 0.5;

side_angle = 360 / sides;
side_distance = cos(side_angle / 2) * outer_r;

inner_angle = 90 - side_angle;
wall_thickness = cos(inner_angle) * thickness;

module cell_joint(off = 0.075) {
    width = wall_thickness * 1.2;
    poly_coords = [
        [0, 0],
        [width, 0],
        [wall_thickness * 0.9, wall_thickness],
        [wall_thickness * 0.3, wall_thickness]
    ];
    translate([-width / 2, 0, 0]) {
        linear_extrude(thickness / 2) {
            offset(delta = off) {
                polygon(poly_coords);
                translate([0, wall_thickness * 2, 0])
                    mirror([0, 1, 0])
                        polygon(poly_coords);
            }
        }
    }
}

module cell() {
    difference() {
        union() {
            linear_extrude(height + thickness) {
                difference() {
                    circle(r=outer_r, $fn=sides);
                    circle(r=outer_r - thickness, $fn=sides);
                }
            }

            linear_extrude(thickness / 2) {
                for (i=[0:5]) {
                    rotate([0, 0, i * side_angle]) translate([outer_r * r_koef - thickness / 2, 0 - thickness / 2, 0]) square([outer_r - outer_r * r_koef, thickness]);
                }

                difference() {
                    circle(r=outer_r * r_koef, $fn=sides);
                    circle(r=outer_r * r_koef - thickness, $fn=sides);
                }
            }
        }
        for(x=[0,1]) {
            for (i=[0:5]) {
                rotate([0, 0, i * side_angle])
                    translate([0, side_distance - wall_thickness, x * height + x * thickness / 2])
                        cell_joint();
            }
        }
    }
}

    if (render_cell) {
        cell();
    };

    if (render_joints) {
        translate([-15, outer_r, 0]) cell_joint();
        translate([-10, outer_r, 0]) cell_joint();
        translate([-5, outer_r, 0]) cell_joint();
        translate([5, outer_r, 0]) cell_joint();
        translate([10, outer_r, 0]) cell_joint();
        translate([15, outer_r, 0]) cell_joint();
    }

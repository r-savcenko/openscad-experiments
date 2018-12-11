/* [Cell settings:] */
// Outer radius of the cell (mm)
outer_r = 25; // [20:100]

// Height of the cell (mm)
height = 20; // [10:150]

// Walls' thickness (mm)
thickness = 2; // [2:0.1:5]

// Bottom sides' thickness (mm)
bottom_thickness = 2; // [2:0.1:5]

// Bottom height (mm)
bottom_height = 2; // [1:0.1:5]

/* [Joint settings:] */
// Width (mm)
joint_width = 3; // [1:0.1:5]

// Height (mm)
joint_height = 2; // [1:0.1:5]

// Tolerance (mm)
tolerance = 0.1; // [0:0.005:0.2]


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

module cell_joint(off = tolerance) {
    width = joint_width;
    offset = wall_thickness * 0.6;
    poly_coords = [
        [0, 0],
        [width, 0],
        [width - offset, wall_thickness],
        [offset, wall_thickness]
    ];
    translate([-width / 2, 0, 0]) {
        linear_extrude(joint_height) {
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
            linear_extrude(height + bottom_height) {
                difference() {
                    circle(r=outer_r, $fn=sides);
                    circle(r=outer_r - thickness, $fn=sides);
                }
            }

            linear_extrude(bottom_height) {
                for (i=[0:5]) {
                    rotate([0, 0, i * side_angle]) translate([outer_r * r_koef - bottom_thickness / 3, 0 - bottom_thickness / 2, 0]) square([outer_r - outer_r * r_koef, bottom_thickness]);
                }

                difference() {
                    circle(r=outer_r * r_koef, $fn=sides);
                    circle(r=outer_r * r_koef - bottom_thickness, $fn=sides);
                }
            }
        }
        for(x=[0:1]) {
            for (i=[0:5]) {
                rotate([0, 0, i * side_angle])
                    translate([0, side_distance - wall_thickness, x * height + x * bottom_height - x * joint_height])
                        cell_joint();
            }
        }
    }
}

    if (render_cell) {
        cell();
    };

    if (render_joints) {
        general_offset = joint_width + 3;
        translate([-general_offset * 3, outer_r, 0]) cell_joint(0);
        translate([-general_offset * 2, outer_r, 0]) cell_joint(0);
        translate([-general_offset, outer_r, 0]) cell_joint(0);
        translate([general_offset, outer_r, 0]) cell_joint(0);
        translate([general_offset * 2, outer_r, 0]) cell_joint(0);
        translate([general_offset * 3, outer_r, 0]) cell_joint(0);
    }

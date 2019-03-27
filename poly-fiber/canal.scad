module canal_side (width, height, length, bottom_opening, top_opening, top_opening_height, angle) {
    extrude_scale = top_opening / bottom_opening;
    difference() {
        cube([width, length, height]);
        union() {
            translate([0, 0, height - top_opening_height])
                linear_extrude(height = top_opening_height, scale = ( 1 / extrude_scale ) * 0.75)
                    square([top_opening, length]);
            linear_extrude(height = height - top_opening_height, scale = extrude_scale)
                square([bottom_opening, length * ( 1 / extrude_scale )]);
        }

        // Front cutout
        rotate([-angle, 0, 0])
            translate([0, -length, 0])
                cube([width, length, height * 2]);

        // Side cutout
        translate([width, 0, 0])
            rotate([0, -angle / 1.25, 0])
                cube([length, length, length * 2]);
    }
}

module canal (canal_width = 10, canal_height = 3, canal_length = 5, bottom_opening = 4, top_opening = 1, top_opening_height = 1.4, canal_angle = 30) {
    rotate([0, 0, -90]) {
        canal_side(
            width = canal_width / 2,
            height = canal_height,
            length = canal_length,
            bottom_opening = bottom_opening / 2,
            top_opening = top_opening / 2,
            top_opening_height = top_opening_height,
            angle = canal_angle
        );
        mirror([1, 0, 0])
            canal_side(
                width = canal_width / 2,
                height = canal_height,
                length = canal_length,
                bottom_opening = bottom_opening / 2,
                top_opening = top_opening / 2,
                top_opening_height = top_opening_height,
                angle = canal_angle
            );
    }
}

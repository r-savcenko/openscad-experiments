/* SIDES = 7;

include <center-piece.scad>
include <canal.scad>

module polygon(sides = SIDES, side_width = 15, thickness = 1.2, total_height = 5) {
    // calculations: https://www-formula.ru/lengthpartiesisoscelestriangle
    side_angle = 360 / sides;
    center_piece_height = total_height - thickness;
    radius = side_width / ( 2 * sin( side_angle / 2 ) );
    side_distance_from_center = sqrt( pow( radius, 2 ) - pow( side_width / 2, 2 ) );
    rotate([ 0, 0, ( 1 - sides % 2 ) * side_angle / 2 ])
        linear_extrude(thickness)
            circle(r=radius, $fn=sides);
    translate([0, 0, thickness])
        center_piece(height = center_piece_height, top_radius = 4.7);

    for(i = [0:sides - 1]) {
        rotate([0, 0, i * side_angle])
            translate([-side_distance_from_center, 0, thickness])
                canal(canal_width = side_width / 1.75, canal_length = radius / 4, canal_angle = 36, top_opening = 0.4, canal_height = 3);
    }

}

polygon(); */

linear_extrude(height=10, scale=0.75)
    circle(r=50, $fn = 128);

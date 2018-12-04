outer_r = 25;
thickness = 2;
sides = 6;
r_koef = 0.5;
height = 60;

side_angle = 360 / sides;
side_distance = cos(side_angle / 2) * outer_r;

inner_angle = 90 - side_angle;
wall_thickness = cos(inner_angle) * thickness;

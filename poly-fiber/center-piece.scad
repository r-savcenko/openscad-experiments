module center_piece (height = 5, bottom_radius = 3, top_radius = 5, cap_height = 0.4) {
    main_height = height - cap_height;
    cylinder(r1 = bottom_radius, r2 = top_radius, h = main_height);
    translate([0, 0, main_height])
        cylinder(r = top_radius, h = cap_height);
}

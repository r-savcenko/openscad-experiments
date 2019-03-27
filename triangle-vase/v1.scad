triangle_radius = 30;
triangle_offset = 5;
triangle_height = 10;

difference() {
    offset( r = triangle_offset / 2 )
        circle( r = triangle_radius - triangle_offset, $fn = 3 );
    #offset( r = -triangle_offset / 2 )
        circle( r = triangle_radius - triangle_offset, $fn = 3 );
}

include <../helpers/getValue.scad>

module joint_wall_side(
    SIZE,
    CORNER_RADIUS,
    fn = 32
) {
    SIZE_X = getValue(SIZE[0], 1);
    SIZE_Y = getValue(SIZE[1], 5);
    SIZE_Z = getValue(SIZE[2], 5);
    _CR = getValue(CORNER_RADIUS, SIZE_Z / 4);
    if (_CR == 0) {
        cube([SIZE_X, SIZE_Y, SIZE_Z]);
    } else {
        hull() {
            cube([SIZE_X, 1, SIZE_Z]);

            translate([0, SIZE_Y - _CR , 0]) {
                translate([0, 0, _CR])
                    rotate([0, 90, 0])
                        cylinder(r=_CR, h=SIZE_X, $fn=fn);

                translate([0, 0, SIZE_Z - _CR])
                    rotate([0, 90, 0])
                        cylinder(r=_CR, h=SIZE_X, $fn=fn);
            }
        }
    }
}

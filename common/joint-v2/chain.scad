include <../helpers/getValue.scad>

_CHAIN_DEFAULT_X = 1;
_CHAIN_DEFAULT_Y = 5;
_CHAIN_DEFAULT_Z = 5;

_CHAIN_DEFAULT_TOLERANCE = 0.3;

_CHAIN_DEFALLT_TYPE = "male";

module chain_joint_side(TYPE = _CHAIN_DEFALLT_TYPE, SIZE, CORNER_RADIUS, R, R2_KOEF, H, TOLERANCE = _CHAIN_DEFAULT_TOLERANCE) {
    SIZE_X = getValue(SIZE[0], _CHAIN_DEFAULT_X);
    SIZE_Y = getValue(SIZE[1], _CHAIN_DEFAULT_Y);
    SIZE_Z = getValue(SIZE[2], _CHAIN_DEFAULT_Z);

    include <./wall.scad>

    _CR1 = getValue(R, SIZE_Z / 4);
    _CR2 = getValue(R2_KOEF, 0.75) * _CR1;
    _CH = getValue(H, SIZE_X * 0.75);

    DIFF = SIZE_Z / 2 - _CR1;

    if (TYPE == "male") {
        union() {
            joint_wall_side(SIZE, CORNER_RADIUS);

            translate([SIZE_X, SIZE_Y - _CR1 - DIFF, SIZE_Z / 2])
                rotate([0, 90, 0])
                    cylinder(r1=_CR1, r2=_CR2, h=_CH, $fn = 16);
        }
    } else {
        difference() {
            joint_wall_side(SIZE, CORNER_RADIUS);

            translate([SIZE_X + TOLERANCE / 2, SIZE_Y - _CR1 - DIFF, SIZE_Z / 2])
                rotate([0, 270, 0])
                    cylinder(r2=_CR1 + TOLERANCE / 2, r1=_CR2 + TOLERANCE / 2, h=SIZE_X + TOLERANCE, $fn = 16);
        }
    }
}

module chain_joint(TYPE = _CHAIN_DEFALLT_TYPE, SIZE, CORNER_RADIUS, WALL_THICKNESS = _CHAIN_DEFAULT_X, R, R2_KOEF, H, TOLERANCE = _CHAIN_DEFAULT_TOLERANCE) {
    SIZE_X = getValue(SIZE[0], _CHAIN_DEFAULT_X);
    SIZE_Y = getValue(SIZE[1], _CHAIN_DEFAULT_Y);
    SIZE_Z = getValue(SIZE[2], _CHAIN_DEFAULT_Z);

    SIDE_SIZE = [WALL_THICKNESS, SIZE_Y, SIZE_Z];

    MOVE_X = TYPE == "male" ? 0 : WALL_THICKNESS + TOLERANCE;

    translate([MOVE_X, 0, 0]) chain_joint_side(TYPE, SIDE_SIZE, CORNER_RADIUS, R, R2_KOEF, H, TOLERANCE);
    translate([SIZE_X - MOVE_X, 0, 0])
        mirror([1, 0, 0]) chain_joint_side(TYPE, SIDE_SIZE, CORNER_RADIUS, R, R2_KOEF, H, TOLERANCE);
}

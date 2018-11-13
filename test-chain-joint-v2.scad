include <./common/joint-v2/chain.scad>

module test(_SIZE, _THICKNESS) {
    cube([_SIZE[0], 5, _SIZE[2]]);
    translate([_SIZE[0] + 5, 0, 0]) cube([_SIZE[0], 5, _SIZE[2]]);
    translate([0, 5, 0]) {
        chain_joint(TYPE="male", SIZE=_SIZE, WALL_THICKNESS=_THICKNESS);
        translate([_SIZE[0] + 5, 0, 0]) chain_joint(TYPE="female", SIZE=_SIZE, WALL_THICKNESS=_THICKNESS);
    }
}

test([6, 6, 6], 0.8);

/*

Generation a female / maile chain joint

After inclusion - use joint_f() or joint_m() modules as you like

Optional vars (with defaults):
JOINT_SIZE_X = 5;
JOINT_SIZE_Y = 5;
JOINT_SIZE_Z = 5;
*/

include <../helpers/getValue.scad>

JOINT_SIZE_X_ = getValue(JOINT_SIZE_X, 5);
JOINT_SIZE_Y_ = getValue(JOINT_SIZE_Y, 5);
JOINT_SIZE_Z_ = getValue(JOINT_SIZE_Z, 3);

JOINT_CYLINDER_H = 0.5;
JOINT_WALL_THICKNESS = JOINT_CYLINDER_H * 2.5;
JOINT_OUTER_WALL_THICKNESS = JOINT_CYLINDER_H;

RADIUS = JOINT_SIZE_Z_ / 2;

module joint_common_side() {
  difference() {
    hull() {
      translate([0, JOINT_SIZE_Y_ - RADIUS, RADIUS])
        rotate([0, 90, 0])
          cylinder(r = RADIUS, h = JOINT_WALL_THICKNESS, $fn = 32);
      cube([JOINT_WALL_THICKNESS, 1, JOINT_SIZE_Z_]);
    }
    translate([JOINT_OUTER_WALL_THICKNESS, JOINT_SIZE_Y_ - RADIUS * 2, 0])
      cube([JOINT_WALL_THICKNESS, RADIUS * 2.1, JOINT_SIZE_Z_]);
  }
}

module joint_side_m() {
  joint_common_side();
  translate([JOINT_CYLINDER_H, JOINT_SIZE_Y_ - RADIUS, JOINT_SIZE_Z_ / 2])
    rotate([0, 90, 0])
      cylinder(r = RADIUS / 2.25, r2 = RADIUS / 2.75, h = JOINT_CYLINDER_H * 1.75, $fn = 18);
}

module joint_side_f() {
  translate([JOINT_WALL_THICKNESS, 0, JOINT_SIZE_Z_]) {
    rotate([0, 180, 0]) {
        difference() {
        joint_common_side();
        translate([0, JOINT_SIZE_Y_ - RADIUS, JOINT_SIZE_Z_ / 2])
          rotate([0, 90, 0])
            cylinder(r = RADIUS / 2, r2 = RADIUS / 2.1, h = JOINT_CYLINDER_H * 1.1, $fn = 18);
        }
    }
  }
}

module joint_m() {
  translate([-JOINT_SIZE_X_ / 2, 0, 0]) {
      joint_side_m();
      translate([JOINT_SIZE_X_, 0, JOINT_SIZE_Z_])
        rotate([0, 180, 0])
          joint_side_m();
  }
}

module joint_f() {
  translate([-JOINT_SIZE_X_ / 2, 0, 0]) {
    joint_side_f();
    translate([JOINT_SIZE_X_, 0, JOINT_SIZE_Z_])
      rotate([0, 180, 0])
        joint_side_f();
  }
}

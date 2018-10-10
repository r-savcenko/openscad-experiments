JOINT_WIDTH = 5;
JOINT_SIDE_WIDTH = 5;
JOINT_HEIGHT = 5;

include <common/joint/hinge-clip-joint.scad>

module clip_base() {
  translate([-JOINT_WIDTH / 2, -JOINT_WIDTH, 0]) cube([JOINT_WIDTH, JOINT_WIDTH, JOINT_HEIGHT]);
  clip(true);
}

module hinge_base() {
  translate([-JOINT_WIDTH / 2, -JOINT_WIDTH, 0]) cube([JOINT_WIDTH, JOINT_WIDTH, JOINT_HEIGHT]);
  hinge(true);
}

render() {
  translate([-JOINT_WIDTH * 0.75, 0, 0])  hinge_base();
  translate([JOINT_WIDTH * 0.75, 0, 0]) clip_base();
}

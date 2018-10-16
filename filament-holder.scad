HOLDER_THICKNESS = 16;
HOLDER_HEIGHT = 175;
HOLDER_LENGTH = 175;
SPOOL_SIZE = 100;
SPOOL_SIZE_MARGIN = 4;
SPOOL_INNER_RADIUS = 53 / 2;

HOLDER_SIDE_DISTANCE = SPOOL_SIZE + SPOOL_SIZE_MARGIN;

BAR_CLIP_SIZE_X = 15;
BAR_CLIP_SIZE_Y= 30;
BAR_WIDTH = 10;
BAR_HEIGHT = 7;

module guide() {
    cylinder(h = HOLDER_THICKNESS / 2, r1 = SPOOL_INNER_RADIUS, r2 = SPOOL_INNER_RADIUS * 0.75, $fn = 64);
    translate([0, 0, HOLDER_THICKNESS / 2])
      cylinder(h = HOLDER_THICKNESS / 2, r1 = SPOOL_INNER_RADIUS * 0.75, r2 = SPOOL_INNER_RADIUS, $fn = 64);
}

module base() {
  difference() {
    linear_extrude(HOLDER_THICKNESS)
      square([HOLDER_LENGTH, HOLDER_HEIGHT]);

    linear_extrude(HOLDER_THICKNESS)
      translate([HOLDER_LENGTH, HOLDER_HEIGHT + 10, 0])
        resize([HOLDER_LENGTH * 2 - 40 - SPOOL_INNER_RADIUS * 2, HOLDER_HEIGHT * 2])
          circle(r = HOLDER_HEIGHT, $fn = 64);
  }
}

module spool_axis() {
  translate([0, HOLDER_HEIGHT + 2, 0]) {
    guide();

    translate([0, 0, HOLDER_SIDE_DISTANCE + HOLDER_THICKNESS])
      guide();

    translate([0, 0, HOLDER_THICKNESS])
      cylinder(h = HOLDER_SIDE_DISTANCE, r = SPOOL_INNER_RADIUS, $fn = 64);
  }
}

module side() {
  difference() {
    base();

    translate([0, HOLDER_HEIGHT, 0])
      guide();

    translate([HOLDER_LENGTH / 3 - BAR_WIDTH / 2, -1, -1])
      cube([BAR_WIDTH, BAR_HEIGHT + 1, HOLDER_THICKNESS + 2]);
  }
}

module side_clip(OFFSET = 0) {
  union() {
    translate([-10, 0, -OFFSET / 2]) linear_extrude(HOLDER_THICKNESS + OFFSET) square([5, 30]);
    translate([-5, 10, -OFFSET / 2]) linear_extrude(HOLDER_THICKNESS + OFFSET) square([10, 10]);
  }
}

module side_l() {
  union() {
    side();
    translate([0, 10, 0]) side_clip();
    translate([0, 100, 0]) side_clip();
  }
}

module side_r() {
  difference() {
      mirror([1, 0, 0]) side();
      translate([0, 10, 0]) side_clip(10);
      translate([0, 100, 0]) side_clip(10);
  }
}

module bar_clip() {
  linear_extrude(BAR_WIDTH)
    polygon([
      [0, 0],
      [0, BAR_HEIGHT],
      [BAR_CLIP_SIZE_X, BAR_CLIP_SIZE_Y],
      [BAR_CLIP_SIZE_X, BAR_HEIGHT],
      [BAR_CLIP_SIZE_X + HOLDER_THICKNESS, BAR_HEIGHT],
      [BAR_CLIP_SIZE_X + HOLDER_THICKNESS, BAR_CLIP_SIZE_Y],
      [BAR_CLIP_SIZE_X * 2 + HOLDER_THICKNESS, BAR_HEIGHT],
      [BAR_CLIP_SIZE_X * 2 + HOLDER_THICKNESS, 0]
    ]);
}

module bar() {
  bar_clip();
  translate([BAR_CLIP_SIZE_X * 2 + HOLDER_THICKNESS, 0, 0]) cube([HOLDER_SIDE_DISTANCE - BAR_CLIP_SIZE_X * 2, BAR_HEIGHT, BAR_WIDTH]);
  translate([HOLDER_THICKNESS + HOLDER_SIDE_DISTANCE, 0, 0]) bar_clip();

}

/* side(); */

bar();

translate([0, 100, 0]) {
  spool_axis();
  render() {
    translate([20, 0, 0]) side_l();
    translate([-20, 0, 0]) side_r();
  }
}

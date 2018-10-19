HOLDER_THICKNESS = 6;
HOLDER_HEIGHT = 175;
HOLDER_LENGTH = 150;
SPOOL_SIZE = 148.5;
SPOOL_SIZE_MARGIN = 0;
SPOOL_INNER_RADIUS = 53 / 2;

HOLDER_SIDE_DISTANCE = SPOOL_SIZE + SPOOL_SIZE_MARGIN;

BAR_CLIP_SIZE_X = 15;
BAR_CLIP_SIZE_Y= 20;
BAR_CLIP_SIZE_Y_OUTER= 17.5;
BAR_WIDTH = 6;
BAR_HEIGHT = 6;

ROD_RADIUS = 8 / 2;

JOINT_MARGIN = 0.6;

module base() {
  difference() {
    linear_extrude(HOLDER_THICKNESS)
      square([HOLDER_LENGTH, HOLDER_HEIGHT]);

    linear_extrude(HOLDER_THICKNESS)
      translate([HOLDER_LENGTH - 10, HOLDER_HEIGHT + 10, 0])
        resize([HOLDER_LENGTH * 2 - SPOOL_INNER_RADIUS * 2, HOLDER_HEIGHT * 2])
          circle(r = HOLDER_HEIGHT, $fn = 128);

    translate([35, 40, 0])
      cylinder(r1=15, r2=20, h=HOLDER_THICKNESS, $fn = 64);

    translate([20, 80, 0])
      cylinder(r1=8, r2=13, h=HOLDER_THICKNESS, $fn = 64);

    translate([70, 18, 0])
      cylinder(r1=5, r2=10, h=HOLDER_THICKNESS, $fn = 64);
  }
}

module guide() {
  RADIUS = ROD_RADIUS + JOINT_MARGIN;
  translate([0, -10, 0]) cylinder(r=RADIUS, h=HOLDER_THICKNESS, $fn=32);
  translate([0, -10, 0]) cube([RADIUS, 20, HOLDER_THICKNESS]);
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
  COORDS = [
    [-10, 0],
    [-10, 30],
    [-5, 30],
    [-5, 20],
    [0, 20],
    [0, 10],
    [-5,10],
    [-5, 0]
  ];
  translate([0, 0, -OFFSET/2])
    linear_extrude(HOLDER_THICKNESS + OFFSET)
      offset(delta =  OFFSET)
        polygon(COORDS);
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
      translate([0, 10, 0]) side_clip(JOINT_MARGIN);
      translate([0, 100, 0]) side_clip(JOINT_MARGIN);
  }
}

module bar_clip() {
  BAR_HEIGHT_1 = BAR_HEIGHT - JOINT_MARGIN;
  linear_extrude(BAR_WIDTH)
    polygon([
      [0, 0],
      [0, BAR_HEIGHT],
      [BAR_CLIP_SIZE_X, BAR_CLIP_SIZE_Y_OUTER],
      [BAR_CLIP_SIZE_X, BAR_HEIGHT_1],
      [BAR_CLIP_SIZE_X + HOLDER_THICKNESS, BAR_HEIGHT_1],
      [BAR_CLIP_SIZE_X + HOLDER_THICKNESS, BAR_CLIP_SIZE_Y],
      [BAR_CLIP_SIZE_X * 2 + HOLDER_THICKNESS, BAR_HEIGHT],
      [BAR_CLIP_SIZE_X * 2 + HOLDER_THICKNESS, 0]
    ]);
}

module bar() {
  bar_clip();

  translate([BAR_CLIP_SIZE_X * 2 + HOLDER_THICKNESS, 0, 0])
    cube([HOLDER_SIDE_DISTANCE - BAR_CLIP_SIZE_X * 2, BAR_HEIGHT, BAR_WIDTH]);

  translate([HOLDER_THICKNESS * 2 + HOLDER_SIDE_DISTANCE + BAR_CLIP_SIZE_X * 2, 0, 0])
    mirror([1, 0, 0])
      bar_clip();

}

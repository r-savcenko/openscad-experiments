STAND_SIZE_Z=120;
STAND_ROD_SIZE_Z=10;
STAND_ROD_Z_DIFF=10;
STAND_INNER_Z=9;

STAND_ROD_DIAMETER=12;
STAND_DIAMETER=20;

STAND_SIDES=8;

STAND_LEG_SIZE_X=20;
STAND_LEG_SIZE_Y=40;
STAND_LEG_SIZE_Z=20;
STAND_LEG_KOEF=0.5;

module rod(diff) {
    translate([0, 0, STAND_SIZE_Z+diff])
        cylinder(r1=STAND_ROD_DIAMETER / 2, h=STAND_ROD_SIZE_Z, r2=STAND_ROD_DIAMETER / 2 - 1, center=false, $fn=64);
    cylinder(r=STAND_DIAMETER / 2, h=STAND_SIZE_Z+diff, center=false, $fn=STAND_SIDES);
}

module leg() {
    linear_extrude(height=STAND_LEG_SIZE_Z, scale=STAND_LEG_KOEF)
        translate([0 - STAND_LEG_SIZE_X / 2, 0, 0])
            square([STAND_LEG_SIZE_X, STAND_LEG_SIZE_Y]);
}

for(i=[0:STAND_SIDES]) {
    rotate([0, 0, i * 360 / STAND_SIDES])
        leg();
}

cylinder(r1=STAND_LEG_SIZE_Y, r2=STAND_LEG_SIZE_Y * STAND_LEG_KOEF, h=STAND_LEG_SIZE_Z, $fn=STAND_SIDES);


/* rod(0); */
rod(STAND_ROD_Z_DIFF);

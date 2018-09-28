/*

Generates a "support" line

After inclusion use support(WIDTH, HEIGHT) as you like

Optional vars (with defaults):
LAYER_THICKNESS = 0.1;
WALL_THICKNESS = 0.2;

*/

include <helpers/getValue.scad>

LAYER_THICKNESS_ = getValue(LAYER_THICKNESS, 0.1);
WALL_THICKNESS_ = getValue(WALL_THICKNESS, 0.2);

module support(WIDTH = 1, HEIGHT = 1) {
    STEPS_COUNT = floor(HEIGHT / (LAYER_THICKNESS_ * 2));
    SIZE_X = WALL_THICKNESS_;
    SIZE_Y = WIDTH;
    SIZE_Z = LAYER_THICKNESS_;
    for(I = [0:STEPS_COUNT]) {
        translate([0, 0, I * LAYER_THICKNESS_ * 2])
        cube([SIZE_X, SIZE_Y, SIZE_Z]);
    }
}

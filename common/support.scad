LAYER_THICKNESS = 0.1;
WALL_THICKNESS = 0.2;

module support(WIDTH = 1, HEIGHT = 1) {
    STEPS_COUNT = ceil(HEIGHT / LAYER_THICKNESS * 2);
    SIZE_X = WALL_THICKNESS;
    SIZE_Y = WIDTH;
    SIZE_Z = LAYER_THICKNESS;
    for(I = [0:STEPS_COUNT]) {
        echo(I);
        translate([0, 0, I * LAYER_THICKNESS * 2])
        cube([SIZE_X, SIZE_Y, SIZE_Z]);
    }
}

support(WIDTH = 10, HEIGHT = 5);
include <./nut-bolt.scad>

SIZE = 12;

COORDS = [
    [SIZE/2, SIZE/2]
];

HEIGHT = 10;

render() {
    m_nut_cutout(std_idx = 1, height = HEIGHT, coords = COORDS)
        cube([SIZE, SIZE, HEIGHT]);

    translate([SIZE + 10, 0, 0])
        m_bolt_cutout(std_idx = 1, height = HEIGHT, coords = COORDS, cap_height = 2.5)
            cube([SIZE, SIZE, HEIGHT]);
}

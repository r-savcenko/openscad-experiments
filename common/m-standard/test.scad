include <./nut-bolt.scad>

COORDS1 = [
    [7, 8]
];

COORDS2 = [
    [17, 8]
];

HEIGHT = 15;

render() {
    m_bolt_cutout(std_idx = 1, height = HEIGHT, coords = COORDS2, cap_height = 2, taper = true)
        m_nut_cutout(std_idx = 1, height = HEIGHT, coords = COORDS1)
            cube([24, 16, HEIGHT]);
}

include <./nut.scad>

COORDS = [
    [10, 10],
    [10, 30]
];


render() {
    m_nut_cutout(std_idx = 3, height = 10, coords = COORDS) {
        cube([40, 40, 10]);
    };
}

include <./nut.scad>

COORDS = [
    [8, 8]
];


render() {
    m_nut_cutout(std_idx = 1, height = 5, coords = COORDS) {
        cube([16, 16, 5]);
    };
}

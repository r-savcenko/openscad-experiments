// format: [hole_diameter, height, diameter]
_STD_TABLE = [
    [2.5, 2, 5.4],
    [3, 2.5, 6.3],
    [4, 3.2, 8],
    [5, 4.49, 9]
];

echo("-----------------------------");
echo("Size indexes");
for(idx=[0:len(_STD_TABLE)-1]) {
    echo(idx, str("M", _STD_TABLE[idx][0]));
}
echo("-----------------------------");

module m_nut(inner, outer, nut_height, model_height) {
    translate([0, 0, model_height]) {
        mirror([0, 0, 1]) {
            cylinder(r=inner/2, h=model_height, center=false, $fn = 32);
            linear_extrude(nut_height)
                circle(outer / 2, center=false, $fn=6);
        }
    }
}

module m_nut_cutout(
    std_idx = 0,
    height = 10,
    coords = []
) {
    HOLE_DIAMETER = _STD_TABLE[std_idx][0];
    HEIGHT = _STD_TABLE[std_idx][1];
    DIAMETER = _STD_TABLE[std_idx][2];

    difference() {
        children();
        for(i=[0:len(coords) - 1]) {
            translate([coords[i][0], coords[i][1], 0])
                m_nut(inner = HOLE_DIAMETER, outer = DIAMETER, nut_height = HEIGHT, model_height = height);
        }
    }
}

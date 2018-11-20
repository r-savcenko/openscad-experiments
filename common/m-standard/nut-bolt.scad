// format: [hole_diameter, height, diameter]
_STD_TABLE = [
    [2.5, 2, 5.4],
    [3, 2.5, 6.3],
    [4, 3.2, 8],
    [5, 4.49, 9],
    [6, 4.95, 11.3],
    [8, 6.3, 14.5],
    [10, 7.9, 18.3],
    [12, 9.75, 20.3]
];

SAFE_MARGIN = 0.2;

echo("-----------------------------");
echo("Size indexes");
for(idx=[0:len(_STD_TABLE)-1]) {
    echo(idx, str("M", _STD_TABLE[idx][0]));
}
echo("-----------------------------");

module m_nut(inner, outer, nut_height, model_height, fn=6, taper = false) {
    inner_r = inner/2 + SAFE_MARGIN * 2;
    outer_r = outer / 2 + SAFE_MARGIN / 2;
    outer_r2 = taper ? inner_r : outer_r;
    translate([0, 0, model_height]) {
        mirror([0, 0, 1]) {
            cylinder(r=inner_r, h=model_height, center=false, $fn = 32);
            cylinder(r=outer_r, r2 = outer_r2, h=nut_height, center=false, $fn = fn);
        }
    }
}

module m_bolt(inner, outer, nut_height, model_height, _taper) {
    m_nut(inner, outer, nut_height, model_height, fn=32, taper = _taper);
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

module m_bolt_cutout(
    std_idx = 0,
    height = 10,
    coords = [],
    cap_height,
    taper
) {
    HOLE_DIAMETER = _STD_TABLE[std_idx][0];
    HEIGHT = cap_height == undef ? _STD_TABLE[std_idx][1] : cap_height;
    DIAMETER = _STD_TABLE[std_idx][2];

    difference() {
        children();
        for(i=[0:len(coords) - 1]) {
            translate([coords[i][0], coords[i][1], 0])
                m_bolt(inner = HOLE_DIAMETER, outer = DIAMETER, nut_height = HEIGHT, model_height = height, _taper = taper);
        }
    }
}

use <./base.scad>
/*
    format: [size, diameter, cap_height]
            [d1, d2, k]
*/
_DIN_912_STD = [[2,3.8,2],[3,5.5,3],[4,7,4],[5,8.5,5],[6,10,6],[8,13,8],[10,16,10],[12,18,12],[14,21,14],[16,24,16],[18,27,18],[20,30,20],[24,36,24],[27,40,27],[30,45,30],[36,54,36]];

module din912_help() {
    din_help("DIN 912", _DIN_912_STD);
}

module din912_base(m_idx, height) {
    row = _DIN_912_STD[m_idx];
    inner = row[0];
    outer = row[1];
    cap_height = row[2];
    round_bolt(inner, outer, cap_height, height);
}

module din912(m_idx, height, coords) {
    difference() {
        children();
        for(i=[0:len(coords) - 1]) {
            translate([coords[i][0], coords[i][1], 0])
                din912_base(m_idx, height);
        }
    }
}

din912_help();

/*
din912(1, 10, [[5, 5]]) {
    cube([10, 10, 10]);
}
*/

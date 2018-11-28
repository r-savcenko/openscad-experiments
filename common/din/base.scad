module din_help(name, _STD_TABLE) {
    echo("-----------------------------");
    echo(str("Size indexes for ", name));
    for(idx=[0:len(_STD_TABLE)-1]) {
        echo(str(idx, " = M", _STD_TABLE[idx][0]));
    }
    echo("-----------------------------");
}

module din_cutout_base(inner, outer, cap_height, height, fn) {
    translate([0, 0, height]) {
        mirror([0, 0, 1]) {
            cylinder(r=outer/2, h=cap_height, center=false, $fn = fn);
            cylinder(r=inner/2, h=height, center=false, $fn = 32);
        }
    }
}

module hex_nut(inner, outer, cap_height, height = 0) {
    din_cutout_base(inner, outer, cap_height, height, 6);
}

module round_bolt(inner, outer, cap_height, height = 0) {
    din_cutout_base(inner, outer, cap_height, height, 32);
}

translate([-10, 0, 0]) round_bolt(inner = 3, outer = 6.01, cap_height = 2.4, height = 10);
translate([10, 0, 0]) hex_nut(inner = 3, outer = 6.01, cap_height = 2.4, height = 10);

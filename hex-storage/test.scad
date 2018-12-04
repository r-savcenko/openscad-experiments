include <cell.scad>

cell();

translate([0, outer_r, 0]) cell_joint();
translate([-5, outer_r, 0]) cell_joint();
translate([5, outer_r, 0]) cell_joint();

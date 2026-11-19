// params.scad: mechanical parameters of the printed housing of the portable unit and shared helper modules.
// DESIGN ONLY: not printed, not built. Positions, beam sizes and assumed component outlines are defined in
// layout_gen.scad; do not retype them here.
include <layout_gen.scad>

$fn  = 40;
fn_s = 16;                         // facets of screw holes
eps  = 0.01;

// ---- heights above the deck top (z = 0 of the "deck frame")
ped_h   = axis_h - cube / 2;       // cube pedestal
fence_h = 2.5;                     // corner fences above the pedestal (below the beams)
fence_arm = 2.5;                   // arm length of a corner fence
feat_h  = inner_h - 0.3;           // baffles and dump walls end 0.3 mm below the lid

// ---- board seats (panels, sensor boards, mirrors, shutter plate)
seat_bw   = 1.2;                   // back wall
seat_lip  = 1.2;                   // front and back lips at the two ends
seat_eng  = 1.5;                   // engagement of a lip over the end of a board
seat_scr  = 4.4;                   // extension of the screw end beyond the board
seat_hole_x = -0.6;                // screw hole behind the front face (keeps the clamp tab off the side wall)
seat_hole_y = 2.05;                // screw hole beyond the end of the board

// ---- lid and corners
corner_r  = 2.0;                   // outer corner radius (vertical edges)
lid_lip_t = 1.2;                   // locating lip of the lid, inside the walls
lid_lip_h = 0.8;
lid_lip_c = 0.2;                   // clearance between lip and wall
lid_pad   = 1.2;                   // pads of the lid on the screw bosses (countersinks)

// ---- clamps
tab_l = 9.0;  tab_t = 2.0;  tab_back = 2.3;   // clamp tab: length, thickness, hole to rear end
tab_w1 = 4.6; tab_w2 = 9.0;                    // narrow / wide tab
lc_w = 4.6;   lc_t = 3.0;                      // lens clamp: width, thickness (45 degree nose)
lc_nose = lens_post_off - 1.5;                 // hole to the lower edge of the nose

// ---- colors of the assembly (paper palette)
c_print = "#CFCECE";  c_dark = "#6F6F6F";  c_l1 = "#3775BA";  c_l2 = "#DAA87C";  c_beam = "#8BCF8B";
c_glass = "#B8C9E5";  c_ink = "#272727";

// ---- outline of the housing (rounded vertical edges), inset by i
module outline2d(i = 0) { offset(delta = -i) offset(r = corner_r) offset(delta = -corner_r) square([LX, WY]); }

// ---- beams in the deck frame: required envelopes (+ m on every diameter); up > 0 opens them to the top
module bdisc(x, y, d, hx) { translate([x, y, axis_h]) rotate(hx ? [0, 90, 0] : [90, 0, 0]) cylinder(d = d, h = 0.02, center = true); }
module beam_seg(b, m = 0, up = 0) {
  hx = abs(b[3] - b[0]) > abs(b[4] - b[1]);
  hull() for (u = [0, up]) translate([0, 0, u]) { bdisc(b[0], b[1], b[2] + m, hx); bdisc(b[3], b[4], b[5] + m, hx); }
}
// space behind the reflecting face of a fold mirror (a beam ends on the 45 degree face, not on a plane across it)
module mirror_cut() { for (s = SEATS) if (s[8] == 0) translate([s[0], s[1], 0]) rotate([0, 0, s[2]]) translate([-5, -8, -1]) cube([5, 16, 80]); }
module beams(m = 0, up = 0, kind = -1) {
  difference() { union() for (b = BEAMS) if (kind < 0 || b[6] == kind) beam_seg(b, m, up); mirror_cut(); }
}

// ---- insertion volumes of the components (deck frame): body + clearance g, open to the top
module cyl_pocket(d, len, top = true) {
  rotate([0, 90, 0]) cylinder(d = d, h = len, center = true);
  if (top) translate([-len / 2, -d / 2, 0]) cube([len, d, inner_h]);
}
module pockets(g = clr) {
  for (c = CUBES) translate([c[0] - cube / 2 - g, c[1] - cube / 2 - g, ped_h]) cube([cube + 2 * g, cube + 2 * g, inner_h]);
  for (s = SEATS) translate([s[0], s[1], 0]) rotate([0, 0, s[2]])
    translate([-s[4] - g, -s[3] / 2 - g, axis_h - s[5] / 2]) cube([s[4] + 2 * g, s[3] + 2 * g, inner_h]);
  for (l = LENSES) translate([l[0], l[1], axis_h]) cyl_pocket(l[2], l[3] + 2 * g);
  translate([las_x + las_l / 2, las_y, axis_h]) cyl_pocket(las_d, las_l + 2 * g);
  translate([las_x + las_l + las_pin_l / 2, las_y, axis_h]) cyl_pocket(las_pin_d + 0.6, las_pin_l + 2 * g);
}

// ---- space of the clamp tabs (deck frame): tab + g, open to the top; no chassis feature may stand in it
module tab_box(w, g) { translate([-tab_back - g, -w / 2 - g, 0]) cube([tab_l + 2 * g, w + 2 * g, inner_h]); }
module tab_zones(g = 0.2) {
  for (p = POSTS) translate([p[0], p[1], axis_h + p[3]]) rotate([0, 0, p[2]]) tab_box(p[4] == 2 ? tab_w2 : tab_w1, g);
  for (s = SEATS) if (s[6] != 0) translate([s[0], s[1], 0]) rotate([0, 0, s[2]])
    translate([seat_hole_x, sign(s[6]) * (s[3] / 2 + clr + seat_hole_y), axis_h + s[5] / 2])
      rotate([0, 0, -90 * sign(s[6])]) tab_box(abs(s[6]) == 2 ? tab_w2 : tab_w1, g);
}

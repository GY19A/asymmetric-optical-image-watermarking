// assembly.scad: the whole portable unit, placed with the coordinates of layout_gen.scad.
// DESIGN ONLY: not printed, not built.
// Frame: x length, y width, z up; z = 0 is the outer bottom. The deck top is at z0 = tray_h + deck_t and the beams
// run in the plane z0 + axis_h.
// what = "all" (default) | "printed" (union of every printed instance: interference check) | "beams" |
//        "clash" (beams + beam_margin against the printed parts) | "bodyclash" (component dummies against the
//        printed parts). Flags: show_lid, show_beams, plan (top render: deck, features and walls in three grays),
//        fast (import the exported STL of chassis, lid and base tray instead of rebuilding them: renders only).
include <params.scad>
use <chassis.scad>
use <covers.scad>
use <clamps.scad>

what = "all";
show_lid = false;
show_beams = true;
fast = false;
plan = false;                    // plan view coloring (top render)
beam_margin = 0;
body_shrink = 0;                 // the body check shrinks the dummies by this amount (touching faces are not a clash)
z0 = tray_h + deck_t;
z_pcb = floor_t + pcb_pad;

module deck() { translate([0, 0, z0]) children(); }

// ---- printed parts
module p_chassis() { translate([0, 0, tray_h]) if (fast) import("../stl/chassis.stl", convexity = 10); else chassis(); }
module p_base() { if (fast) import("../stl/base_tray.stl", convexity = 10); else base_tray(); }
module p_lid() { translate([0, 0, HZ]) mirror([0, 0, 1]) if (fast) import("../stl/lid.stl", convexity = 10); else lid(); }
module tabs() {
  deck() {
    for (p = POSTS) translate([p[0], p[1], axis_h + p[3]]) rotate([0, 0, p[2]]) tab_clamp(p[4] == 2 ? tab_w2 : tab_w1);
    for (s = SEATS) if (s[6] != 0) translate([s[0], s[1], 0]) rotate([0, 0, s[2]])
      translate([seat_hole_x, sign(s[6]) * (s[3] / 2 + clr + seat_hole_y), axis_h + s[5] / 2])
        rotate([0, 0, -90 * sign(s[6])]) tab_clamp(abs(s[6]) == 2 ? tab_w2 : tab_w1);
  }
}
module lens_clamps() {
  deck() for (l = LENSES) translate([l[0], l[1] - (l[2] / 2 * sqrt(0.5) + lens_post_off), axis_h + l[2] / 2 * sqrt(0.5) - 1.5])
    rotate([0, 0, 90]) translate([0, 0, lc_t]) mirror([0, 0, 1]) lens_clamp();
}
module spacers() { for (b = BOSSES) translate([b[0], b[1], z_pcb + pcb_t]) pcb_spacer(); }
module printed(lid_on = true) { p_base(); p_chassis(); if (lid_on) p_lid(); tabs(); lens_clamps(); spacers(); }

// ---- component dummies (not printed): g < 0 shrinks them for the body check
module board(b, g = 0) {
  translate([b[0], b[1], 0]) rotate([0, 0, b[2]]) translate([-b[4] - g, -b[3] / 2 - g, axis_h - b[5] / 2 - g]) cube([b[4] + 2 * g, b[3] + 2 * g, b[5] + 2 * g]);
}
module cell(l, g = 0) { translate([l[0], l[1], axis_h]) rotate([0, 90, 0]) cylinder(d = l[2] + 2 * g, h = l[3] + 2 * g, center = true); }
module laser(g = 0) {
  translate([las_x - g, las_y, axis_h]) rotate([0, 90, 0]) cylinder(d = las_d + 2 * g, h = las_l + 2 * g);
  translate([las_x + las_l, las_y, axis_h]) rotate([0, 90, 0]) cylinder(d = las_pin_d + 2 * g, h = las_pin_l + g);
}
module pcb(g = 0) {
  translate([0, 0, z_pcb - g]) linear_extrude(pcb_t + 2 * g) difference() {
    outline2d(wall + pcb_edge - g);
    for (b = BOSSES) translate([b[0], b[1]]) circle(d = scr_clear + 0.2 - 2 * g, $fn = fn_s);
  }
}
module usb(g = 0) { translate([LX - usb_d - g, WY / 2 - usb_w / 2 - g, z_pcb + pcb_t]) cube([usb_d + 2 * g, usb_w + 2 * g, usb_h + g]); }
module bodies(g = 0) {           // every dummy, one solid (for the check)
  deck() {
    for (c = CUBES) translate([c[0] - cube / 2 - g, c[1] - cube / 2 - g, ped_h - g]) cube(cube + 2 * g);
    for (b = BOARDS) board(b, g);
    for (l = LENSES) cell(l, g);
    laser(g);
  }
  pcb(g); usb(g);
}
BCOL = [c_l1, c_l2, c_dark, c_ink, "#F1F1F1"];
module commercial() {            // colored dummies of the commercial components
  deck() {
    color(c_glass, 0.55) for (c = CUBES) translate([c[0] - cube / 2, c[1] - cube / 2, ped_h]) cube(cube);
    for (b = BOARDS) color(BCOL[b[6]]) board(b);
    for (l = LENSES) { color(c_dark) difference() { cell(l); translate([l[0], l[1], axis_h]) rotate([0, 90, 0]) cylinder(d = l[2] * 0.9, h = l[3] + 1, center = true); }
                       color(c_glass, 0.7) translate([l[0], l[1], axis_h]) rotate([0, 90, 0]) cylinder(d = l[2] * 0.9, h = l[3] * 0.5, center = true); }
    color(c_dark) laser();
  }
  color("#AADCA9") pcb();
  color("#F1F1F1") usb();
}

// ---- top level
if (what == "printed") printed();
else if (what == "beams") deck() beams(beam_margin);
else if (what == "clash") intersection() { deck() beams(beam_margin); printed(); }
else if (what == "bodyclash") intersection() { bodies(-body_shrink); printed(); }
else {
  if (plan) {                    // plan view: deck light, seats / fences / baffles mid gray, walls dark (same geometry)
    color(c_dark) p_base();
    color("#F1F1F1") translate([0, 0, tray_h]) linear_extrude(deck_t) outline2d();
    color(c_dark) translate([0, 0, z0]) linear_extrude(inner_h) difference() { outline2d(); outline2d(wall); }
    color(c_print) deck() { render(convexity = 10) features_cut(); for (b = BOSSES) translate([b[0], b[1], 0]) difference() { cylinder(d = boss_d, h = inner_h - lid_pad); cylinder(d = scr_tap, h = 50, center = true, $fn = fn_s); } }
    color(c_dark) { tabs(); lens_clamps(); }
  } else {
    color(c_dark) p_base();
    color(c_print) { p_chassis(); tabs(); lens_clamps(); spacers(); }
  }
  if (show_lid) color(c_print) p_lid();
  commercial();
  if (show_beams && !show_lid) deck() { color(c_beam, 0.6) beams(0, 0, 0); color(c_l2, 0.75) beams(0, 0, 1); }
}

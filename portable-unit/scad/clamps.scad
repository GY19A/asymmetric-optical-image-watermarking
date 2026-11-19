// clamps.scad: the two small clamps of the portable unit. DESIGN ONLY: not printed, not built.
// Print orientation: clamp tab flat as modeled (countersink up); lens clamp as modeled here, i.e. upside down
// with its top face on the bed (the 45 degree nose then leans inwards, the countersink is a 35 degree cone).
include <params.scad>

// flat tab over the top of a cube, a board or the laser can: hole at the origin, tab along +x
module tab_clamp(w = tab_w1) {
  difference() {
    translate([-tab_back, -w / 2, 0]) cube([tab_l, w, tab_t]);
    translate([0, 0, -1]) cylinder(d = scr_clear, h = tab_t + 2, $fn = fn_s);
    translate([0, 0, tab_t - scr_head_h]) cylinder(d1 = scr_clear, d2 = scr_head_d + 0.2, h = scr_head_h + eps, $fn = fn_s);
  }
}

// lens clamp, upside down: hole at the origin, 45 degree nose towards +x; the nose touches the cell on its upper
// 45 degree line and presses it onto the land and against the fence
module lens_clamp() {
  difference() {
    translate([0, lc_w / 2, 0]) rotate([90, 0, 0]) linear_extrude(lc_w)
      polygon([[-post / 2, 0], [lc_nose + lc_t, 0], [lc_nose, lc_t], [-post / 2, lc_t]]);
    translate([0, 0, -1]) cylinder(d = scr_clear, h = lc_t + 2, $fn = fn_s);
    translate([0, 0, -eps]) cylinder(d1 = scr_head_d + 0.2, d2 = scr_clear, h = scr_head_h + eps, $fn = fn_s);
  }
}

tab_clamp();

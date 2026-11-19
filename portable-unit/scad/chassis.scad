// chassis.scad: one-piece chassis of the portable unit = optical deck + side walls + every seat, fence, baffle and
// beam dump. DESIGN ONLY: not printed, not built.
// Print orientation: as modeled, deck flat on the bed (z = 0 is the underside of the deck). Every feature rises
// vertically from the deck and every pocket is open to the top, so there is no overhang and no bridge.
// Features are written in the "deck frame" (z = 0 at the deck top) and lifted by deck_t.
include <params.scad>

// cube pedestal with four corner fences (the faces stay free for the beams)
module cube_seat(c) {
  s = cube + 2 * fence_t;
  translate([c[0], c[1], 0]) difference() {
    translate([-s / 2, -s / 2, 0]) cube([s, s, ped_h + fence_h]);
    translate([-s / 2 - 1, -(cube / 2 - fence_arm), ped_h]) cube([s + 2, cube - 2 * fence_arm, fence_h + 1]);
    translate([-(cube / 2 - fence_arm), -s / 2 - 1, ped_h]) cube([cube - 2 * fence_arm, s + 2, fence_h + 1]);
  }
}

// seat of a flat component standing on edge: sill, two end posts with lips, optional back wall, one screw boss
// local frame: front face in the plane x = 0 facing +x, width along y
module board_seat(s) {
  w = s[3]; t = s[4]; h = s[5]; se = s[6]; back = s[7]; lipf = s[8];
  zb = axis_h - h / 2; top = axis_h + h / 2;
  xb = -t - clr - seat_bw;
  xf = lipf ? clr + seat_lip : clr;
  translate([s[0], s[1], 0]) rotate([0, 0, s[2]]) {
    translate([xb, -w / 2 - clr - seat_bw, 0]) cube([xf - xb, w + 2 * clr + 2 * seat_bw, zb]);
    for (sg = [-1, 1]) {
      scr = (sign(se) == sg);
      y0 = w / 2 - seat_eng; y1 = w / 2 + clr + (scr ? seat_scr : seat_bw);
      xf2 = scr ? xf + 0.35 : xf;
      difference() {
        translate([xb, sg > 0 ? y0 : -y1, 0]) cube([xf2 - xb, y1 - y0, top]);
        if (scr) translate([seat_hole_x, sg * (w / 2 + clr + seat_hole_y), top - 6]) cylinder(d = scr_tap, h = 7, $fn = fn_s);
      }
    }
    if (back) translate([xb, -w / 2 - clr - seat_bw, 0]) cube([seat_bw, w + 2 * clr + 2 * seat_bw, top]);
  }
}

// seat of a lens cell (axis along x): a 90 degree V turned by 45 degrees = horizontal land + vertical fence on the
// +y side; one clamp with a 45 degree nose on a post on the -y side presses the cell into the corner
module lens_seat(l) {
  R = l[2] / 2; len = l[3]; lp = l[4];
  zl = axis_h - R;
  yp = R * sqrt(0.5) + lens_post_off;       // post center
  lx = len + 2 * clr + 2.4;
  translate([l[0], l[1], 0]) {
    translate([-lx / 2, -yp - post / 2, 0]) cube([lx, yp + post / 2 + R + 1.6, zl]);
    translate([-lx / 2, R, 0]) cube([lx, 1.6, axis_h + 1.5]);
    for (sg = [-1, 1]) translate([sg > 0 ? len / 2 + clr : -len / 2 - clr - 1.2, -R, 0]) cube([1.2, 2 * R, zl + lp]);
    difference() {
      translate([-post / 2, -yp - post / 2, 0]) cube([post, post, axis_h + R * sqrt(0.5) - 1.5]);
      translate([0, -yp, axis_h + R * sqrt(0.5) - 1.5 - 6]) cylinder(d = scr_tap, h = 7, $fn = fn_s);
    }
  }
}

// post of a clamp tab
module clamp_post(p) {
  difference() {
    translate([p[0] - post / 2, p[1] - post / 2, 0]) cube([post, post, axis_h + p[3]]);
    translate([p[0], p[1], axis_h + p[3] - 6]) cylinder(d = scr_tap, h = 7, $fn = fn_s);
  }
}

// beam dump: cavity with an entrance wall (the beam channel opens it) and a slanted back wall; closed by the lid
module dump(d) {
  w = d[3]; dep = d[4]; wo = w + 2 * dump_wall;
  translate([d[0], d[1], 0]) rotate([0, 0, d[2]]) {
    difference() {
      translate([0, -wo / 2, 0]) cube([dep + 2 * dump_wall, wo, feat_h]);
      translate([dump_wall, -w / 2, -eps]) cube([dep, w, feat_h + 1]);
    }
    k = min(dep - 2.5, w / 2);       // the slanted wall is rooted 0.5 mm in the back and side walls
    translate([dump_wall, 0, 0]) linear_extrude(feat_h) polygon([[dep + 0.5, -w / 2], [dep + 0.5, w / 2 + 0.5], [dep - k, w / 2 + 0.5], [dep - k, w / 2]]);
  }
}

module baffle(b) { hull() for (p = [[b[0], b[1]], [b[2], b[3]]]) translate([p[0] - 0.6, p[1] - 0.6, 0]) cube([1.2, 1.2, feat_h]); }

// saddle of the laser can with a rear stop (the pin zone stays open)
module laser_saddle() {
  translate([las_x, las_y - las_d / 2 - 1.5, 0]) cube([las_l, las_d + 3, axis_h]);
  translate([las_x + las_l + clr, las_y - las_d / 2 - 1.5, 0]) cube([1.2, las_d + 3, axis_h + 1]);
}

module features() {
  for (c = CUBES) cube_seat(c);
  for (s = SEATS) board_seat(s);
  for (l = LENSES) lens_seat(l);
  for (p = POSTS) clamp_post(p);
  for (d = DUMPS) dump(d);
  for (b = BAFFLES) baffle(b);
  laser_saddle();
}

// band under the lid where its locating lip sits
module lip_zone() {
  translate([0, 0, inner_h - lid_lip_h - 0.2]) linear_extrude(lid_lip_h + 1)
    difference() { outline2d(wall - 0.05); outline2d(wall + lid_lip_c + lid_lip_t + 0.2); }
}

// seats, fences, baffles and dumps after all cuts (deck frame)
module features_cut() {
  difference() {
    intersection() { features(); translate([0, 0, -eps]) linear_extrude(inner_h) outline2d(0.2); }
    beams(channel_margin, 60);
    pockets();
    tab_zones();
    lip_zone();
  }
}

module chassis() {
  ov = 0.1;                      // features are rooted this deep in the deck so that the chassis is one solid
  difference() {
    union() {
      difference() {             // deck and side walls: one tub
        linear_extrude(deck_t + inner_h) outline2d();
        translate([0, 0, deck_t]) linear_extrude(inner_h + 1) outline2d(wall);
      }
      translate([0, 0, deck_t]) {
        for (b = BOSSES) hull() {     // screw boss, tied to the corner of the walls
          translate([b[0], b[1], -ov]) cylinder(d = boss_d, h = inner_h - lid_pad + ov);
          translate([b[0] < LX / 2 ? wall - 0.5 : LX - wall, b[1] < WY / 2 ? wall - 0.5 : WY - wall, -ov]) cube([0.5, 0.5, inner_h - lid_pad + ov]);
        }
        features_cut();
        translate([0, 0, -ov]) intersection() { features_cut(); translate([-1, -1, 0]) cube([LX + 2, WY + 2, 2 * ov]); }
      }
    }
    for (b = BOSSES) translate([b[0], b[1], -1]) cylinder(d = scr_tap, h = deck_t + inner_h + 2, $fn = fn_s);
  }
}

chassis();

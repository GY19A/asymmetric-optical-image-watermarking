// parts_misc.scad: fiber holder, laser V-block, shutter bracket and flag, beam dump, rail foot, corner bracket,
// enclosure post, electronics tray.
// DESIGN ONLY: not printed, not built.
// Local frames: holders as in parts_mounts.scad (z = 0 = carrier top, beam along +x through (0, 0, ha));
// beam dump, rail foot, corner bracket, post and tray stand on the base board (z = 0 = board).
// Print orientation: as modeled; the shutter flag flat. No supports except the servo window (bridged).
// Hardware: fiber adapter 2 x M2.5; V-block strap 2 x M3; servo 2 x M2 self-tapping; rail foot and corner
// bracket M5 into T-nuts plus one screw into the base board; post 2 screws into the board; tray boards on
// M3 stand-offs or adhesive clips.
include <params.scad>
use <parts_mounts.scad>

module hole_x(d, l) { rotate([0, 90, 0]) translate([0, 0, -0.01]) cylinder(d = d, h = l + 0.02, $fn = fn_s); }

// ---- 6a. fiber holder: plate with a bore for a bulkhead fiber adapter, tip at the collimator focus.
fib_bore = 9.6;     // bulkhead adapter barrel (generic; set to the adapter used)
fib_pitch = 14;     // flange screw pitch (generic)
module fiber_holder() {
  w = 40; top = ha + 16;
  difference() {
    union() {
      foot();
      translate([-3, -w / 2, 0]) cube([6, w, top]);
    }
    translate([-3, 0, ha]) hole_x(fib_bore, 6);
    for (s = [-1, 1]) translate([-3, s * fib_pitch / 2, ha]) hole_x(m25_d, 6);
  }
}

// ---- 6b. V-block for a 12 mm laser module barrel (alternative to the fiber holder).
module laser_vblock(d = 12) {
  h = ha - d / 2 * sqrt(2);                                // bottom of the V so that the barrel axis is at ha
  difference() {
    union() {
      foot();
      translate([-car_l / 2, -12, 0]) cube([car_l, 24, ha + 2]);
    }
    translate([-car_l / 2 - 0.01, 0, h]) rotate([90, 0, 90]) linear_extrude(car_l + 0.02)
      polygon([[0, 0], [14, 14], [-14, 14]]);
    for (s = [-1, 1]) translate([0, s * 9.5, ha + 2 - m3_ins_h]) cylinder(d = m3_ins, h = m3_ins_h + 0.01, $fn = fn_s);
  }
}

// ---- 7a. shutter bracket: upright with a clear bore for the reference beam and a window for a micro servo
// whose shaft is parallel to the beam, above it. The flag swings in the plane normal to the beam.
module shutter_bracket() {
  w = 46; top = ha + sh_axis + servo_h / 2 + 6;
  difference() {
    union() {
      foot();
      translate([-3, -w / 2, 0]) cube([6, w, top]);
    }
    translate([-3, 0, ha]) hole_x(sh_bore, 6);
    translate([-3.01, -servo_w / 2, ha + sh_axis - servo_h / 2]) cube([6.02, servo_w, servo_h]);
    for (s = [-1, 1]) translate([-3, s * servo_ear / 2, ha + sh_axis]) hole_x(1.8, 6);
  }
}

// ---- 7b. shutter flag: paddle on the servo horn; covers the bore when turned down.
module shutter_flag() {
  difference() {
    union() {
      cylinder(d = 12, h = 1.6);
      translate([-13, -sh_axis - 14, 0]) cube([26, sh_axis + 14, 1.6]);
    }
    translate([0, 0, -0.01]) cylinder(d = 4.9, h = 1.62, $fn = fn_s);       // horn hub
    for (s = [-1, 1]) translate([0, s * 4, -0.01]) cylinder(d = 1.5, h = 1.62, $fn = fn_s);
  }
}

// ---- 8. beam dump on a pedestal standing on the base board; entrance faces -x at the axis height.
module beam_dump() {
  b = 34; depth = 34;
  difference() {
    union() {
      translate([-5, -25, 0]) cube([depth + 10, 50, 5]);                    // flange
      translate([0, -b / 2, 0]) cube([depth, b, ha_board + b / 2]);
    }
    translate([-0.01, 0, ha_board]) difference() {                           // blind bore with a cone at the bottom
      rotate([0, 90, 0]) cylinder(d = 24, h = depth - 5);
      translate([depth - 5 - 14, 0, 0]) rotate([0, 90, 0]) cylinder(d1 = 2, d2 = 20, h = 14.01);
    }
    for (s = [-1, 1]) translate([depth / 2, s * 21, -0.01]) cylinder(d = 4.5, h = 5.02, $fn = fn_s);
  }
}

// ---- 9a. rail foot: angle clip that fixes a rail to the base board (M5 into the side slot, screw into the board).
module rail_foot() {
  difference() {
    union() {
      cube([20, 22, 5]);
      cube([20, 5, 15]);
    }
    translate([10, 5 + 9, -0.01]) cylinder(d = 4.5, h = 5.02, $fn = fn_s);
    translate([10, -0.01, 10]) rotate([-90, 0, 0]) cylinder(d = m5_d, h = 5.02, $fn = fn_s);
  }
}

// ---- 9b. corner bracket: joins two rails at a right angle through their side slots; bridges the end gap.
// 15 mm high so that it passes under the carrier skirts.
module corner_bracket(gap = 20) {
  la = 34; lb = gap + 34;
  difference() {
    union() {
      cube([la, 5, 15]);
      cube([5, lb, 15]);
      linear_extrude(4) polygon([[0, 0], [la, 0], [0, 26]]);
    }
    translate([la - 10, -0.01, 10]) rotate([-90, 0, 0]) cylinder(d = m5_d, h = 5.02, $fn = fn_s);
    translate([-0.01, lb - 10, 10]) rotate([0, 90, 0]) cylinder(d = m5_d, h = 5.02, $fn = fn_s);
  }
}

// ---- 10a. enclosure post: corner post with two slots that take 3 mm opaque sheet panels.
module enclosure_post(sheet = 3.2) {
  difference() {
    union() {
      cube([24, 24, post_h]);
      cube([44, 44, 5]);
    }
    translate([24 - 10, 8, 5]) cube([10.01, sheet, post_h]);                // slot towards +x
    translate([8, 24 - 10, 5]) cube([sheet, 10.01, post_h]);                // slot towards +y
    for (p = [[34, 12], [12, 34]]) translate([p[0], p[1], -0.01]) cylinder(d = 4.5, h = 5.02, $fn = fn_s);
  }
}

// ---- 10b. electronics tray: bays for a USB hub, three panel driver boards and a microcontroller board.
tray_bays = [[4, 4, 100, 52], [108, 4, 88, 52], [4, 60, 62, 86], [70, 60, 62, 86], [136, 60, 60, 86]];
module electronics_tray() {
  difference() {
    cube([tray[2], tray[3], 8]);                                           // bays below assume 200 x 150
    for (b = tray_bays) translate([b[0], b[1], 2]) cube([b[2], b[3], 6.01]);
    for (p = [[6, 6], [194, 6], [6, 144], [194, 144]]) translate([p[0], p[1], -0.01]) cylinder(d = 4.5, h = 8.02, $fn = fn_s);
  }
}

// parts_mounts.scad: rail carrier, lens / optic holder with retaining ring, cube table with clamp.
// DESIGN ONLY: not printed, not built.
// Local frame of every holder: z = 0 is the top face of the rail carrier, the beam travels along +x through
// (0, 0, ha). Print orientation: as modeled (foot down), no supports; bores bridge at the top.
// Hardware: carrier 2 x M5 x 10 into rail T-nuts, 4 x M3 heat-set inserts; holders 4 x M3 x 10 into the carrier;
// retaining ring 3 x M3 x 8 into inserts of the holder; cube clamp 1 x M3 x 12 + 1 x M3 nylon-tip set screw.
include <params.scad>

module hole(d, h, fn = fn_s) { translate([0, 0, -0.01]) cylinder(d = d, h = h + 0.02, $fn = fn); }

// ---- foot plate with the 4 x M3 pattern of the carrier (local x = along the rail)
module foot(l = car_l, w = car_w) {
  difference() {
    translate([-l / 2, -w / 2, 0]) cube([l, w, foot_t]);
    for (sx = [-1, 1], sy = [-1, 1]) translate([sx * pat_x, sy * pat_y, 0]) hole(m3_d, foot_t);
  }
}

// ---- 1. rail carrier: saddle on the rail. Local x = along the rail, z = 0 at the rail top face.
module rail_carrier() {
  difference() {
    union() {
      translate([-car_l / 2, -car_w / 2, 0]) cube([car_l, car_w, car_t]);
      for (s = [-1, 1])                                   // skirts along both rail sides
        translate([-car_l / 2, s > 0 ? rail / 2 + clr : -car_w / 2, -car_skirt])
          cube([car_l, car_w / 2 - rail / 2 - clr, car_skirt + 0.01]);
    }
    for (s = [-1, 1]) translate([s * 8, 0, 0]) {          // 2 x M5 into T-nuts, counterbored
      hole(m5_d, car_t);
      translate([0, 0, car_t - 3]) hole(m5_head, 3.5);
    }
    for (sx = [-1, 1], sy = [-1, 1])                      // 4 x M3 inserts for the holders
      translate([sx * pat_x, sy * pat_y, car_t - m3_ins_h]) hole(m3_ins, m3_ins_h);
    translate([0, -car_w / 2 - 0.01, car_t - 2]) rotate([-90, 0, 0])   // index mark at the center
      linear_extrude(1) polygon([[-1.5, -2.5], [1.5, -2.5], [0, 0]]);
  }
}

// ---- 2. holder for a round optic of diameter d, centered on the beam at height h_axis above the foot bottom
module lens_holder(d = lens_d, h_axis = ha) {
  w = d + 2 * rim;
  top = h_axis + d / 2 + rim;
  bc = d / 2 + 5.5;                                       // bolt circle of the retaining ring
  difference() {
    union() {
      foot(car_l, max(car_w, w));
      translate([-up_t / 2, -w / 2, 0]) cube([up_t, w, top]);
      for (s = [-1, 1]) translate([0, s * (w / 2 - 3), foot_t])   // two gussets
        rotate([90, 0, 0]) translate([0, 0, -1.5]) linear_extrude(3)
          polygon([[-car_l / 2, 0], [car_l / 2, 0], [up_t / 2, 12], [-up_t / 2, 12]]);
    }
    translate([-up_t / 2, 0, h_axis]) rotate([0, 90, 0]) hole(d - 2 * lip - 0.6, up_t, $fn);          // clear bore
    translate([up_t / 2 - seat_d, 0, h_axis]) rotate([0, 90, 0]) hole(d + 2 * clr, seat_d, $fn);    // seat
    for (a = [90, 210, 330]) translate([up_t / 2 - m3_ins_h, bc * cos(a), h_axis + bc * sin(a)])
      rotate([0, 90, 0]) hole(m3_ins, m3_ins_h);
  }
}

module retaining_ring(d = lens_d) {
  bc = d / 2 + 5.5;
  difference() {
    cylinder(d = d + 2 * rim - 2, h = ring_t);
    hole(d - 2 * lip - 0.6, ring_t, $fn);
    for (a = [90, 210, 330]) translate([bc * cos(a), bc * sin(a), 0]) hole(m3_d, ring_t);
  }
}

// ---- 3. cube table: seat for the beam-splitter cube, center on the beam; four free ports.
module cube_table() {
  seat = ha - cube / 2;                                   // seat height above the foot bottom
  pw = cube + 2 * cube_fence_t + 2 * clr;                 // pedestal width
  difference() {
    union() {
      foot();
      translate([-pw / 2, -pw / 2, 0]) cube([pw, pw, seat]);
      // locating corner: two fences, lower than the beam
      translate([-pw / 2, -pw / 2, seat]) cube([pw, cube_fence_t, cube_fence_h]);
      translate([-pw / 2, -pw / 2, seat]) cube([cube_fence_t, pw, cube_fence_h]);
      // clamp post at the locating corner, outside every beam port
      translate([-pw / 2 - cube_post + cube_fence_t, -pw / 2 - cube_post + cube_fence_t, 0])
        cube([cube_post, cube_post, seat + cube + 1]);
    }
    // post: insert for the clamp screw
    translate([-pw / 2 - cube_post / 2 + cube_fence_t, -pw / 2 - cube_post / 2 + cube_fence_t,
               seat + cube + 1 - m3_ins_h]) hole(m3_ins, m3_ins_h);
    // access to the foot screws under the pedestal overhang is from the sides: nothing to cut
  }
}

// ---- cube clamp: plate over the cube top, bolted on the post, set screw over the cube center.
module cube_clamp() {
  pw = cube + 2 * cube_fence_t + 2 * clr;
  o = -pw / 2 - cube_post + cube_fence_t;                 // outer corner of the post
  difference() {
    translate([o, o, 0]) cube([cube / 2 - o + 6, cube / 2 - o + 6, 4]);
    translate([o + cube_post / 2, o + cube_post / 2, 0]) hole(m3_d, 4);
    hole(2.9, 4);                                         // M3 tapped (self-cut) for the nylon-tip set screw
  }
}

// parts_panels.scad: mounts for the reflective modulator panels and for the two camera boards.
// DESIGN ONLY: not printed, not built. The board outlines are generic; replace them by the drawings of the chosen
// commercial parts (params.scad: pan_bw, pan_bh, pan_stack, cam_b, cam_hole, cam_stack).
// Local frame: the active surface (panel or sensor) is centered at (0, 0, h_axis) and faces -x; the beam arrives
// travelling along +x; every printed body lies at x > 0 except the stop cap. z = 0 is the mounting face.
// Print orientation: frames and camera mounts as modeled (foot down); tilt plate, stop cap and slide parts flat.
// Hardware: panel board 4 x M2.5; tilt plate 3 x M3 x 16 with compression springs into inserts of the frame;
// camera board 4 x M2; slide 2 x M3 x 12 in slots, 1 x M3 fine screw; frames 4 x M3 x 10 into the carrier
// (rail version) or 2 x M5 into the base board (board version).
include <params.scad>
use <parts_mounts.scad>

pan_pw = pan_bw + 16;                    // tilt plate width
pan_ph = pan_bh + 16;                    // tilt plate height
pan_adj = [[-(pan_pw / 2 - 5), pan_ph / 2 - 5], [pan_pw / 2 - 5, pan_ph / 2 - 5], [-(pan_pw / 2 - 5), -(pan_ph / 2 - 5)]];
x_plate = pan_stack;                     // tilt plate front face (board back face)
x_frame = pan_stack + pan_plate_t + pan_gap;
foot_x  = 20.3;                          // carrier center behind the active surface (layout: C_im, C_fc, C_pm)

module hole_x(d, l) { rotate([0, 90, 0]) translate([0, 0, -0.01]) cylinder(d = d, h = l + 0.02, $fn = fn_s); }

// ---- 4a. tip/tilt plate: carries the panel board on its front face. Modelled in place (x from x_plate).
module panel_tilt_plate(h_axis = ha) {
  difference() {
    translate([x_plate, -pan_pw / 2, h_axis - pan_ph / 2]) cube([pan_plate_t, pan_pw, pan_ph]);
    for (p = pan_adj) translate([x_plate, p[0], h_axis + p[1]]) hole_x(m3_d, pan_plate_t);
    for (sy = [-1, 1], sz = [-1, 1])     // board screws in horizontal slots: lateral adjustment
      hull() for (dy = [-pan_slot / 2, pan_slot / 2])
        translate([x_plate, sy * (pan_bw / 2 - 3) + dy, h_axis + sz * (pan_bh / 2 - 3)]) hole_x(m25_d, pan_plate_t);
  }
}

// ---- 4b. fixed frame. on_board = false: foot on a rail carrier; true: pedestal on the base board (taller).
module panel_frame(on_board = false) {
  h_axis = on_board ? ha_board : ha;
  top = h_axis + pan_ph / 2;
  difference() {
    union() {
      if (on_board) translate([foot_x - 22, -30, 0]) cube([44, 60, foot_t]);
      else translate([foot_x, 0, 0]) foot();
      translate([x_frame, -pan_pw / 2, 0]) cube([pan_frame_t, pan_pw, top]);
      for (s = [-1, 1]) translate([0, s * ((on_board ? 30 : car_w / 2) - 2), foot_t])   // gussets behind the frame
        rotate([90, 0, 0]) translate([0, 0, -2]) linear_extrude(4)
          polygon([[x_frame + pan_frame_t, 0], [foot_x + 14, 0], [x_frame + pan_frame_t, on_board ? 40 : 22]]);
    }
    for (p = pan_adj) translate([x_frame, p[0], h_axis + p[1]]) hole_x(m3_ins, pan_frame_t);
    translate([x_frame, 0, h_axis]) hole_x(18, pan_frame_t);                  // cable window
    if (on_board) for (s = [-1, 1]) hull() for (dx = [-4, 4])                 // 2 x M5 slots into the base board
      translate([foot_x + 8 + dx, s * 22, -0.01]) cylinder(d = m5_d, h = foot_t + 0.02, $fn = fn_s);
  }
}

// ---- 5a. fixed camera mount (Fourier camera). Board back face at x = cam_stack, on four bosses.
module camera_upright(h_axis, x0) {                      // upright with bosses; x0 = front face of the upright
  w = cam_b + 8;
  difference() {
    union() {
      translate([x0, -w / 2, 0]) cube([6, w, h_axis + cam_b / 2 + 4]);
      for (sy = [-1, 1], sz = [-1, 1]) translate([cam_stack, sy * cam_hole / 2, h_axis + sz * cam_hole / 2])
        rotate([0, 90, 0]) cylinder(d = 6, h = x0 - cam_stack + 0.01, $fn = fn_s);
    }
    for (sy = [-1, 1], sz = [-1, 1]) translate([cam_stack, sy * cam_hole / 2, h_axis + sz * cam_hole / 2])
      hole_x(m2_d, x0 - cam_stack + 6);
    translate([x0, 0, h_axis]) hole_x(20, 6);                                 // connector window
  }
}

module camera_mount_fixed() {
  union() {
    translate([foot_x, 0, 0]) foot();
    camera_upright(ha, cam_stack + 3);
  }
}

// ---- 5b. zero-order stop cap: holds a 12.7 mm window with the stop dot close in front of the sensor.
// Modelled in place: plate at x = -3 .. -1, legs back to the board front face.
module stop_cap(h_axis = ha) {
  board_front = cam_stack - 1.6;
  difference() {
    union() {
      translate([-3, -cam_b / 2, h_axis - cam_b / 2]) cube([2, cam_b, cam_b]);
      for (sy = [-1, 1], sz = [-1, 1]) translate([-1.01, sy * cam_hole / 2, h_axis + sz * cam_hole / 2])
        rotate([0, 90, 0]) cylinder(d = 5, h = board_front + 1.01, $fn = fn_s);
    }
    for (sy = [-1, 1], sz = [-1, 1]) translate([-3, sy * cam_hole / 2, h_axis + sz * cam_hole / 2])
      hole_x(m2_d, board_front + 3);
    translate([-3, 0, h_axis]) hole_x(stop_hole, 2);                          // light path
    translate([-3, 0, h_axis]) hole_x(12.7 + 2 * clr, 1.0);                   // window pocket
  }
}

// ---- 5c. image sensor on a fine-focus slide along the beam. Base on the carrier (center at x = 24).
slide_c = 24;                            // carrier center (layout: C_is)
module camera_slide_base() {
  difference() {
    union() {
      translate([-4, -car_w / 2, 0]) cube([56, car_w, foot_t]);
      translate([46, -10, 0]) cube([6, 20, foot_t + 14]);                     // end block of the fine screw
    }
    for (sx = [-1, 1], sy = [-1, 1]) translate([slide_c + sx * pat_x, sy * pat_y, 0]) {
      translate([0, 0, -0.01]) cylinder(d = m3_d, h = foot_t + 0.02, $fn = fn_s);
      translate([0, 0, foot_t - 3.2]) cylinder(d = 6.2, h = 3.3, $fn = fn_s);  // heads below the carriage
    }
    for (sy = [-1, 1]) translate([22, sy * 12, foot_t - m3_ins_h]) cylinder(d = m3_ins, h = m3_ins_h + 0.01, $fn = fn_s);
    translate([46, 0, foot_t + 8]) hole_x(m3_ins, 6);                         // M3 x 0.5 fine screw, along the beam
  }
}

module camera_slide_carriage() {
  difference() {
    union() {
      translate([3, -car_w / 2, foot_t]) cube([38, car_w, 6]);
      translate([0, 0, foot_t]) camera_upright(ha - foot_t, cam_stack + 3);
    }
    for (sy = [-1, 1]) hull() for (dx = [-slide_travel, slide_travel])        // slots: +- travel
      translate([22 + dx, sy * 12, foot_t - 0.01]) cylinder(d = m3_d, h = 6.02, $fn = fn_s);
  }
}

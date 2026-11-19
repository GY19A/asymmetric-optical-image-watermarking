// assembly.scad: the whole bench of the reference hardware design, placed with the coordinates of layout_gen.scad.
// DESIGN ONLY: not printed, not built.
// Top view: x east, y north, z up; z = 0 is the base board. Beams run in the plane z = rail + axis_h.
// what = "all" (default), "printed" (printed parts only, one union: used by the interference check),
//        "beams" (beam volumes only). Flags: show_beams, show_enclosure, show_commercial.
include <params.scad>
use <parts_mounts.scad>
use <parts_panels.scad>
use <parts_misc.scad>

what = "all";
show_beams = true;
show_enclosure = false;
show_commercial = true;
beam_margin = 0;                 // added to every beam diameter (clearance check uses 1)
shutter_open = true;             // flag turned out of the reference beam
za = rail + axis_h;              // beam plane above the base board

// ---- placement helpers
module at(P, rot = 0) { translate([P[0], P[1], z_carrier]) rotate([0, 0, P[2] + rot]) children(); }
module on_board(P, rot = 0) { translate([P[0], P[1], 0]) rotate([0, 0, P[2] + rot]) children(); }
module carrier_at(C) { translate([C[0], C[1], rail]) rotate([0, 0, C[2]]) rail_carrier(); }

// ---- printed parts (every instance; used for the bill of materials and the interference check)
module printed() {
  for (C = [C_fibre, C_col, C_pol, C_bs0, C_c1, C_im, C_an1, C_l1, C_fc, C_c2, C_an2, C_c3, C_l2, C_is, C_sh, C_va,
            C_as, C_pm]) carrier_at(C);
  at(P_fibre) fiber_holder();
  for (P = [P_col, P_pol, P_an1, P_an2, P_va]) at(P) { lens_holder(opt_d); ring_on(opt_d); }
  for (P = [P_l1, P_l2]) at(P) { lens_holder(lens_d); ring_on(lens_d); }
  at(P_as) { lens_holder(opt_d / 2); ring_on(opt_d / 2); }
  // cube tables; the second argument turns the clamp post into a free corner
  for (c = [[P_bs0, 180], [P_c1, 180], [P_c2, 90], [P_c3, 180]])
    translate([c[0][0], c[0][1], z_carrier]) rotate([0, 0, c[1]]) {
      cube_table();
      translate([0, 0, ha + cube / 2 + 1]) cube_clamp();
    }
  at(P_im) { panel_frame(false); panel_tilt_plate(ha); }
  at(P_pm) { panel_frame(false); panel_tilt_plate(ha); }
  on_board(P_am) { panel_frame(true); panel_tilt_plate(ha_board); }
  at(P_fc) { camera_mount_fixed(); stop_cap(ha); }
  at(P_is) { camera_slide_base(); camera_slide_carriage(); }
  at(P_sh) { shutter_bracket(); translate([3.2, 0, ha + sh_axis]) rotate([shutter_open ? 90 : 0, 0, 0]) rotate([90, 0, 90]) shutter_flag(); }
  translate([P_dump1[0], P_dump1[1], 0]) rotate([0, 0, 90]) beam_dump();
  rail_feet();
  // corner brackets at the five rail junctions (inner corners, below the carrier skirts)
  translate([R_west[0] + rail / 2, -rail / 2, 0]) mirror([0, 1, 0]) corner_bracket();
  translate([R_ref[0] + rail / 2, -rail / 2, 0]) mirror([0, 1, 0]) corner_bracket();
  translate([R_west[0] + rail / 2, R_south[1] + rail / 2, 0]) corner_bracket();
  translate([R_ref[0] + rail / 2, R_south[1] + rail / 2, 0]) corner_bracket();
  translate([R_stub[0] + rail / 2, R_south[1] - rail / 2, 0]) mirror([0, 1, 0]) corner_bracket();
  // enclosure posts at the corners of the base board, slots along the edges
  translate([FOOT[0], FOOT[1], 0]) enclosure_post();
  translate([FOOT[2], FOOT[1], 0]) rotate([0, 0, 90]) enclosure_post();
  translate([FOOT[2], FOOT[3], 0]) rotate([0, 0, 180]) enclosure_post();
  translate([FOOT[0], FOOT[3], 0]) rotate([0, 0, 270]) enclosure_post();
  translate([tray[0], tray[1], 0]) electronics_tray();
}
module ring_on(d) { translate([up_t / 2, 0, ha]) rotate([0, 90, 0]) retaining_ring(d); }

module yfeet(R, y) {
  translate([R[0] - rail / 2, y, 0]) rotate([0, 0, 90]) rail_foot();
  translate([R[0] + rail / 2, y + 20, 0]) rotate([0, 0, -90]) rail_foot();
}
// rail feet: two per rail end, one on each side
module rail_feet() {
  for (R = [R_north, R_south]) for (x = [R[0] + 14, R[2] - 34]) {
    translate([x, R[1] - rail / 2, 0]) mirror([0, 1, 0]) rail_foot();
    translate([x, R[1] + rail / 2, 0]) rail_foot();
  }
  for (R = [R_west, R_ref]) for (y = [min(R[1], R[3]) + 90, max(R[1], R[3]) - 110]) yfeet(R, y);
  yfeet(R_stub, min(R_stub[1], R_stub[3]) + 30);
}

// ---- commercial part placeholders (not printed)
module commercial() {
  color(c_rail) for (R = [R_north, R_south]) translate([R[0], R[1] - rail / 2, 0]) cube([R[2] - R[0], rail, rail]);   // commercial part placeholder: rails
  color(c_rail) for (R = [R_west, R_ref, R_stub]) translate([R[0] - rail / 2, min(R[1], R[3]), 0]) cube([rail, abs(R[3] - R[1]), rail]);
  color("#F1F1F1") translate([FOOT[0], FOOT[1], -12]) cube([FOOT[2] - FOOT[0], FOOT[3] - FOOT[1], 12]);            // commercial part placeholder: base board
  color(c_glass, 0.5) for (P = [P_bs0, P_c1, P_c2, P_c3]) translate([P[0] - cube / 2, P[1] - cube / 2, za - cube / 2]) cube(cube);   // commercial part placeholder: cubes
  color(c_glass, 0.6) for (P = [P_l1, P_l2]) at(P) translate([up_t / 2 - seat_d, 0, ha]) rotate([0, 90, 0]) cylinder(d = lens_d, h = seat_d - 1);   // commercial part placeholder: lenses
  color(c_glass, 0.6) for (P = [P_col, P_pol, P_an1, P_an2]) at(P) translate([up_t / 2 - seat_d, 0, ha]) rotate([0, 90, 0]) cylinder(d = opt_d, h = seat_d - 1);
  color(c_l2, 0.8) at(P_va) translate([up_t / 2 - seat_d, 0, ha]) rotate([0, 90, 0]) cylinder(d = opt_d, h = seat_d - 1);     // commercial part placeholder: attenuator
  color(c_l2, 0.8) at(P_as) translate([up_t / 2 - seat_d, 0, ha]) rotate([0, 90, 0]) cylinder(d = opt_d / 2, h = seat_d - 1);  // commercial part placeholder: annular stop
  color(c_l1) at(P_im) translate([0, -pan_bw / 2, ha - pan_bh / 2]) cube([pan_stack, pan_bw, pan_bh]);          // commercial part placeholder: input modulator
  color(c_l1) on_board(P_am) translate([0, -pan_bw / 2, ha_board - pan_bh / 2]) cube([pan_stack, pan_bw, pan_bh]);   // commercial part placeholder: amplitude modulator
  color(c_l2) at(P_pm) translate([0, -pan_bw / 2, ha - pan_bh / 2]) cube([pan_stack, pan_bw, pan_bh]);          // commercial part placeholder: phase modulator
  color(c_l1) at(P_fc) translate([cam_stack - 1.6, -cam_b / 2, ha - cam_b / 2]) cube([1.6, cam_b, cam_b]);       // commercial part placeholder: Fourier camera board
  color(c_rail) at(P_is) translate([cam_stack - 1.6, -cam_b / 2, ha - cam_b / 2]) cube([1.6, cam_b, cam_b]);     // commercial part placeholder: image sensor board
  color(c_l2) at(P_sh) translate([-3 - 22, -servo_w / 2, ha + sh_axis - servo_h / 2]) cube([22, servo_w, servo_h]);   // commercial part placeholder: micro servo
  color(c_rail) at(P_fibre) translate([-20, 0, ha]) rotate([0, 90, 0]) cylinder(d = 9, h = 23);                  // commercial part placeholder: fiber adapter
}

module enclosure() {             // commercial part placeholder: opaque sheet panels between the posts
  color("#272727", 0.25) {
    translate([FOOT[0] + 14, FOOT[1] + 8.1, 5]) cube([FOOT[2] - FOOT[0] - 28, 3, post_h - 5]);
    translate([FOOT[0] + 14, FOOT[3] - 11.1, 5]) cube([FOOT[2] - FOOT[0] - 28, 3, post_h - 5]);
    translate([FOOT[0] + 8.1, FOOT[1] + 14, 5]) cube([3, FOOT[3] - FOOT[1] - 28, post_h - 5]);
    translate([FOOT[2] - 11.1, FOOT[1] + 14, 5]) cube([3, FOOT[3] - FOOT[1] - 28, post_h - 5]);
  }
}

// ---- beams: required envelopes of layout_gen.scad (+ beam_margin on every diameter)
module disc(p, d, along) {       // thin disc at p, normal along "x" or "y"
  translate([p[0], p[1], za]) rotate(along == "x" ? [0, 90, 0] : [90, 0, 0]) cylinder(d = d + beam_margin, h = 0.02, center = true);
}
module seg(p0, d0, p1, d1) {
  along = abs(p1[0] - p0[0]) > abs(p1[1] - p0[1]) ? "x" : "y";
  hull() { disc(p0, d0, along); disc(p1, d1, along); }
}
module beams() {
  seg(P_fibre, 1, P_col, beam_col);                                  // diverging from the fiber tip
  seg(P_col, beam_col, P_im, beam_col);                              // collimated to the input modulator
  seg(P_c1, beam_col, [P_dump1[0], P_dump1[1] + 10], beam_col);      // first-pass reflection into the dump bore
  seg(P_c1, ca_icube, P_l1, ca_lens);                                // input cube to L1
  seg(P_l1, ca_lens, P_am, pupil_d);                                 // L1 to the amplitude modulator
  seg(P_c2, beam_fc, P_fc, beam_fc);                                 // tap to the Fourier camera (central region)
  seg(P_c2, ca_fcube, [P_c3[0] + cube / 2, P_c3[1]], ca_comb);       // Fourier cube to the combiner exit face
  seg([P_c3[0] + cube / 2, P_c3[1]], ca_comb, P_l2, ca_lens);        // combiner to L2
  seg(P_l2, ca_lens, P_is, ca_sensor);                               // L2 to the image sensor
  seg(P_bs0, beam_ref, P_pm, beam_ref);                              // reference arm (central part used)
}

// ---- top level
if (what == "printed") printed();
else if (what == "beams") beams();
else if (what == "clash") intersection() { beams(); printed(); }
else {
  color(c_print) printed();
  if (show_commercial) commercial();
  if (show_beams) color(c_beam, 0.55) beams();
  if (show_enclosure) enclosure();
}

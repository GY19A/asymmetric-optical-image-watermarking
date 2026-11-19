// covers.scad: lid, base tray (board bay with the USB-C cut-out) and board spacer of the portable unit.
// DESIGN ONLY: not printed, not built.
// Print orientation: lid with its outer face on the bed (as modeled here, lip and pads up); base tray as modeled
// (floor on the bed); spacer standing. No overhang beyond the 45 degree countersinks, no bridge.
include <params.scad>

z_pcb = floor_t + pcb_pad;                 // underside of the board above the outer bottom
usb_cut_w = usb_w + 0.6;

module countersink_down() {                // countersink in the face z = 0, screw along +z
  translate([0, 0, -eps]) cylinder(d1 = scr_head_d + 0.2, d2 = scr_clear, h = scr_head_h + eps, $fn = fn_s);
  translate([0, 0, -1]) cylinder(d = scr_clear, h = 30, $fn = fn_s);
}

// lid, modeled upside down: outer face at z = 0
module lid() {
  difference() {
    union() {
      linear_extrude(lid_t) outline2d();
      translate([0, 0, lid_t - 0.1]) linear_extrude(lid_lip_h + 0.1)
        difference() { outline2d(wall + lid_lip_c); outline2d(wall + lid_lip_c + lid_lip_t); }
      for (b = BOSSES) translate([b[0], b[1], lid_t - 0.1]) cylinder(d = boss_d - 0.4, h = lid_pad + 0.1);   // pad on a screw boss (overlaps the lip)
    }
    for (b = BOSSES) translate([b[0], b[1], 0]) countersink_down();
  }
}

// base tray: floor, walls, pads under the board, USB-C cut-out in the +x end wall
module base_tray() {
  difference() {
    union() {
      linear_extrude(floor_t) outline2d();
      linear_extrude(tray_h) difference() { outline2d(); outline2d(wall); }
      for (b = BOSSES) translate([b[0], b[1], 0]) cylinder(d = boss_d + 1, h = z_pcb);
      for (p = [[LX / 4, WY / 2], [LX / 2, WY / 2], [3 * LX / 4, WY / 2]]) translate([p[0], p[1], 0]) cylinder(d = 5, h = z_pcb);
    }
    for (b = BOSSES) translate([b[0], b[1], 0]) countersink_down();
    translate([LX - wall - 1, WY / 2 - usb_cut_w / 2, z_pcb + pcb_t - 0.2]) cube([wall + 2, usb_cut_w, tray_h]);
  }
}

// spacer between the board and the underside of the deck, on each of the four base screws
module pcb_spacer() {
  difference() {
    cylinder(d = boss_d, h = tray_h - z_pcb - pcb_t);
    translate([0, 0, -1]) cylinder(d = scr_clear + 0.2, h = tray_h, $fn = fn_s);
  }
}

lid();

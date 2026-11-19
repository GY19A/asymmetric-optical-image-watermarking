// parts_sheet.scad: every printable part of the kit once, laid out in rows in its modeled orientation.
// DESIGN ONLY: not printed, not built.
include <params.scad>
use <parts_mounts.scad>
use <parts_panels.scad>
use <parts_misc.scad>
dx = 82;
module cell(i, y) { translate([i * dx, y, 0]) children(); }
// back row: tall parts
cell(0, 210) lens_holder(lens_d);
cell(1, 210) lens_holder(opt_d);
cell(2, 210) lens_holder(opt_d / 2);
cell(3, 210) shutter_bracket();
cell(4, 210) fiber_holder();
cell(5, 210) translate([-20, 0, 0]) panel_frame(true);
cell(6, 210) translate([-17, 0, 0]) beam_dump();
cell(7, 210) translate([-22, -22, 0]) enclosure_post();
// middle row
cell(0, 105) cube_table();
cell(1, 105) translate([-20, 0, 0]) panel_frame(false);
cell(2, 105) translate([-20, 0, 0]) camera_mount_fixed();
cell(3, 105) translate([-22, 0, -foot_t]) camera_slide_carriage();
cell(4, 105) laser_vblock();
cell(5, 105) translate([-5, 0, pan_bh / 2 + 8 - ha]) panel_tilt_plate(ha);
cell(6, 105) translate([0, 0, cam_b / 2 - ha]) stop_cap(ha);
cell(7, 105) translate([-24, 0, 0]) camera_slide_base();
// front row: flat parts
cell(0, 0) rail_carrier();
cell(1, 0) retaining_ring(lens_d);
cell(2, 0) retaining_ring(opt_d);
cell(2.75, 0) retaining_ring(opt_d / 2);
cell(3.5, 0) translate([20, 20, 0]) cube_clamp();
cell(4.5, 20) shutter_flag();
cell(5.2, 0) translate([-10, -10, 0]) rail_foot();
cell(5.9, 0) translate([-17, -27, 0]) corner_bracket();
translate([6.6 * dx, -75, 0]) electronics_tray();

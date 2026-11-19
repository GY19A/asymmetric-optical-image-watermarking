// export.scad: one printable part per call:  openscad -D 'part="lens_holder_50"' -o ../stl/lens_holder_50.stl export.scad
// DESIGN ONLY: not printed, not built. Parts are exported in their modeled frame (see the part files for the
// print orientation); panel_tilt_plate, stop_cap and camera_slide_carriage are moved to the origin of their own
// frame by the slicer.
include <params.scad>
use <parts_mounts.scad>
use <parts_panels.scad>
use <parts_misc.scad>
part = "rail_carrier";
if (part == "rail_carrier") rail_carrier();
if (part == "lens_holder_50") lens_holder(lens_d);
if (part == "lens_holder_25") lens_holder(opt_d);
if (part == "lens_holder_12") lens_holder(opt_d / 2);
if (part == "retaining_ring_50") retaining_ring(lens_d);
if (part == "retaining_ring_25") retaining_ring(opt_d);
if (part == "retaining_ring_12") retaining_ring(opt_d / 2);
if (part == "cube_table") cube_table();
if (part == "cube_clamp") cube_clamp();
if (part == "panel_frame_rail") panel_frame(false);
if (part == "panel_frame_board") panel_frame(true);
if (part == "panel_tilt_plate") panel_tilt_plate(ha);
if (part == "camera_mount_fixed") camera_mount_fixed();
if (part == "stop_cap") stop_cap(ha);
if (part == "camera_slide_base") camera_slide_base();
if (part == "camera_slide_carriage") camera_slide_carriage();
if (part == "fiber_holder") fiber_holder();
if (part == "laser_vblock") laser_vblock();
if (part == "shutter_bracket") shutter_bracket();
if (part == "shutter_flag") shutter_flag();
if (part == "beam_dump") beam_dump();
if (part == "rail_foot") rail_foot();
if (part == "corner_bracket") corner_bracket();
if (part == "enclosure_post") enclosure_post();
if (part == "electronics_tray") electronics_tray();

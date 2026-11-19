// export.scad: one printable part per call:  openscad -D 'part="chassis"' -o ../stl/chassis.stl export.scad
// DESIGN ONLY: not printed, not built. Every part is exported in its print orientation (see the part files).
include <params.scad>
use <chassis.scad>
use <covers.scad>
use <clamps.scad>
part = "chassis";
if (part == "chassis") chassis();
if (part == "lid") lid();
if (part == "base_tray") base_tray();
if (part == "pcb_spacer") pcb_spacer();
if (part == "tab_clamp_narrow") tab_clamp(tab_w1);
if (part == "tab_clamp_wide") tab_clamp(tab_w2);
if (part == "lens_clamp") lens_clamp();
// not a printed part: seats, fences, baffles and dumps alone (deck frame)
if (part == "features_aux") features_cut();

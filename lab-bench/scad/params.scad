// params.scad: every mechanical parameter of the printed mount kit (reference hardware design).
// DESIGN ONLY: not printed, not built.
// Optical layout numbers (stations, rails, beam sizes) are defined in layout_gen.scad and follow from the optical
// parameters of the design. Do not retype positions here.
include <layout_gen.scad>

// ---- print and fit
clr      = 0.25;    // general print clearance per side
$fn      = 48;      // facets of optical bores (screw holes use fn_s)
fn_s     = 20;

// ---- fasteners
m5_d     = 5.5;     // M5 clearance (rail T-nuts)
m5_head  = 9.6;     // M5 button-head counterbore diameter
m3_d     = 3.4;     // M3 clearance
m3_ins   = 4.0;     // hole for an M3 heat-set insert
m3_ins_h = 5.5;     // insert hole depth
m25_d    = 2.9;     // M2.5 clearance (boards)
m2_d     = 2.4;     // M2 clearance (camera boards)

// ---- rail carrier (saddle on the 20 x 20 slotted rail)
car_l    = carrier_l;   // along the rail (from the layout: neighboring carriers must not overlap)
car_w    = 40;          // across the rail
car_t    = 8;           // plate thickness above the rail top
car_skirt = 4;          // skirt depth down the rail sides
pat_x    = 10;          // M3 insert pattern, half pitch along the rail
pat_y    = 15;          // M3 insert pattern, half pitch across the rail

// ---- heights
z_carrier = rail + car_t;          // top face of a carrier above the base board
ha        = axis_h - car_t;        // optical axis above the top face of a carrier (52 mm)
ha_board  = rail + axis_h;         // optical axis above the base board (80 mm)

// ---- holders
foot_t   = 6;       // foot plate thickness of every holder
up_t     = 10;      // upright thickness along the beam
rim      = 10;      // material around a bore
lip      = 1.2;     // seat lip that the optic rests on
seat_d   = 6;       // seat depth
ring_t   = 3;       // retaining ring thickness

// ---- cube table
cube_fence_h = 1.5; // locating fences (below the beam: the beam bottom is 10.05 mm below the cube center)
cube_fence_t = 3;
cube_post    = 8;   // clamp post section

// ---- panel mount (reflective modulator on a carrier board)
pan_bw   = 40;      // board width (horizontal)
pan_bh   = 32;      // board height
pan_stack = 3.0;    // reflective surface in front of the board back face
pan_plate_t = 4;    // tip/tilt plate thickness
pan_gap  = 4;       // spring gap between the tilt plate and the frame
pan_frame_t = 6;
pan_slot = 3.0;     // board slots: +-1.5 mm lateral adjustment

// ---- camera boards
cam_b    = 38;      // square board
cam_hole = 34;      // hole pitch
cam_stack = 4.0;    // sensor surface in front of the board back face
slide_travel = 3;   // +- fine focus travel of the image sensor

// ---- shutter (micro servo)
servo_w  = 23.0;    // body
servo_h  = 12.6;
servo_ear = 28.0;   // screw pitch
sh_bore  = 22;      // clear bore of the shutter bracket
sh_axis  = sh_bore / 2 + 6 + servo_h / 2;   // servo shaft above the beam axis
post_h   = 130;     // enclosure post height
stop_hole = 10;     // light hole of the zero-order stop cap (the camera reads the central roi_d only)

// ---- beams used by the clearance check (diameters from the layout; the check adds beam_margin in assembly.scad)
beam_col  = obj_w * sqrt(2);       // collimated beam over the object diagonal
beam_lens = pupil_d + obj_w * sqrt(2);
beam_ref  = 8;                     // the reference arm uses the central ring2_d = 4.31 mm only
beam_fc   = 8;                     // the Fourier camera reads the central roi_d = 4.79 mm only

// ---- colors of the assembly
c_print = "#CFCECE";  c_rail = "#6F6F6F";  c_l1 = "#3775BA";  c_l2 = "#DAA87C";  c_beam = "#8BCF8B";
c_glass = "#B8C9E5";

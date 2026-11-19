// layout_gen.scad: optical and mechanical layout of the portable unit: outer size, component positions, seats, clamp
// posts, beam dumps, baffles and beam envelopes. Every other file takes its positions from here.
// Portable unit, DESIGN ONLY: no hardware was built. Units: mm. Origin: outer bottom corner; x length, y width, z up.
LX = 132.7052;   // outer length
WY = 74.2580;   // outer width
HZ = 29.6000;   // outer height
wall = 1.6000;
floor_t = 1.2000;
lid_t = 1.2000;
deck_t = 1.6000;
clr = 0.1500;   // print clearance per side
tray_h = 6.8000;   // height of the base tray
axis_h = 10.0000;   // optical axis above the deck top
inner_h = 20.0000;   // deck top to lid underside
cube = 12.7000;
fence_t = 1.8000;
post = 4.6000;
dump_wall = 1.2000;
beam_margin_chk = 1.0000;
channel_margin = 2.0000;
lens_post_off = 5.3000;   // lens clamp post center beyond the 45 degree contact
pcb_t = 1.6000;   // assumed outline
pcb_pad = 0.5000;
pcb_edge = 0.3000;
pcb_comp = 3.0000;
usb_w = 8.9400;   // assumed outline
usb_h = 3.2600;
usb_d = 7.3500;
scr_tap = 1.7000;   // assumed outline
scr_clear = 2.3000;
scr_head_d = 3.8000;
scr_head_h = 1.2000;
boss_d = 5.6000;
mir_w = 12.7000;
las_d = 5.6000;   // assumed outline
las_l = 4.5000;
las_pin_d = 4.0000;
las_pin_l = 6.5000;
las_x = 113.4552;   // front face of the can
las_y = 66.1580;
CUBES = [   // x, y, diagonal (1: /, -1: \)
  [14.1000, 24.4580, 1],   // C1 illumination cube
  [28.8000, 24.4580, 1],   // C0 sensor cube
  [118.6052, 24.4580, -1],   // C2 Fourier cube
  [94.6052, 48.4580, -1],   // C3 reference cube
  [94.6052, 66.1580, 1],   // C4 source splitter cube
];
SEATS = [   // board seats: x, y of the front face center, heading, width, thickness, height, screw end, back wall, front lips
  [4.7500, 24.4580, 0, 22.0000, 3.0000, 14.0000, 1, 1, 1],   // IM
  [127.9552, 24.4580, 180, 22.0000, 3.0000, 14.0000, -1, 1, 1],   // AM
  [94.6052, 39.6080, 90, 22.0000, 3.5000, 14.0000, 1, 1, 1],   // PM
  [118.6052, 15.1080, 90, 14.0000, 3.0000, 14.0000, 1, 1, 1],   // FC
  [28.8000, 4.7500, 90, 14.0000, 3.0000, 14.0000, -1, 1, 1],   // IS
  [28.8000, 48.4580, -45, 12.7000, 2.0000, 12.7000, 0, 1, 0],   // M1
  [14.1000, 66.1580, -45, 12.7000, 2.0000, 12.7000, 0, 1, 0],   // M2
  [94.6052, 58.3080, 90, 16.0000, 2.0000, 12.7000, 2, 0, 1],   // SH
];
BOARDS = [   // dummy boards: x, y, heading, width, thickness, height, color index
  [4.7500, 24.4580, 0, 22.0000, 3.0000, 14.0000, 0],   // IM input modulator
  [127.9552, 24.4580, 180, 22.0000, 3.0000, 14.0000, 0],   // AM amplitude modulator (Fourier plane)
  [94.6052, 39.1080, 90, 22.0000, 3.0000, 14.0000, 1],   // PM phase modulator
  [94.6052, 39.6080, 90, 14.0000, 0.5000, 14.0000, 3],   // AS annular stop
  [118.6052, 15.1080, 90, 14.0000, 3.0000, 14.0000, 0],   // FC Fourier camera
  [28.8000, 4.7500, 90, 14.0000, 3.0000, 14.0000, 2],   // IS image sensor
  [28.8000, 48.4580, -45, 12.7000, 2.0000, 12.7000, 4],   // M1 fold mirror
  [14.1000, 66.1580, -45, 12.7000, 2.0000, 12.7000, 4],   // M2 fold mirror
  [94.6052, 58.3080, 90, 16.0000, 2.0000, 12.7000, 1],   // SH shutter / attenuator
];
LENSES = [   // lens cells (axis along x): x, y, diameter, length, end lip
  [68.5236, 24.4580, 18.0000, 8.0000, 1.3622],   // L
  [44.5236, 48.4580, 12.7000, 6.0000, 1.4648],   // Lr
  [106.4552, 66.1580, 9.0000, 5.0000, 0.4000],   // CL
];
POSTS = [   // clamp posts: x, y, heading of the clamp tab, half height of the clamped body, tab (1 narrow, 2 wide)
  [21.4500, 34.1580, -90, 6.3500, 2],   // clamp post C1/C0
  [109.6552, 33.4080, -45, 6.3500, 1],   // clamp post C2
  [115.7052, 59.8580, 90, 2.8000, 1],   // clamp post laser diode
];
DUMPS = [   // beam dumps: x, y of the entrance, heading, inner width, depth
  [14.1000, 16.3080, -90, 9.0000, 8.0000],   // illumination cube
  [118.6052, 35.0080, 90, 11.3653, 5.5000],   // Fourier cube
  [102.7552, 48.4580, 0, 9.0000, 6.0000],   // reference cube
];
BAFFLES = [   // baffle center lines: x0, y0, x1, y1
  [37.8000, 60.5580, 81.1052, 60.5580],   // source line / reference line
  [42.0000, 1.6000, 42.0000, 16.9580],   // image sensor / lens bay
  [37.8000, 33.4580, 62.8736, 33.4580],   // main axis / reference line
];
BOSSES = [   // screw bosses: x, y
  [4.6000, 4.6000],   // boss 0
  [128.1052, 4.6000],   // boss 1
  [128.1052, 69.6580],   // boss 2
  [4.6000, 69.6580],   // boss 3
];
BEAMS = [   // x0, y0, d0, x1, y1, d1, color (0 signal and source, 1 reference arm)
  [4.7500, 24.4580, 5.4161, 7.7500, 24.4580, 5.8332, 0],   // input modulator to Fourier lens
  [7.7500, 24.4580, 5.8332, 20.4500, 24.4580, 6.9953, 0],   // input modulator to Fourier lens
  [20.4500, 24.4580, 6.9953, 22.4500, 24.4580, 7.2734, 0],   // input modulator to Fourier lens
  [22.4500, 24.4580, 7.2734, 35.1500, 24.4580, 8.4354, 0],   // input modulator to Fourier lens
  [35.1500, 24.4580, 8.4354, 68.5236, 24.4580, 13.0756, 0],   // input modulator to Fourier lens
  [68.5236, 24.4580, 13.0756, 112.2552, 24.4580, 8.7762, 0],   // Fourier lens to amplitude modulator
  [112.2552, 24.4580, 8.7762, 124.9552, 24.4580, 7.9545, 0],   // Fourier lens to amplitude modulator
  [124.9552, 24.4580, 7.9545, 127.9552, 24.4580, 7.6595, 0],   // Fourier lens to amplitude modulator
  [118.6052, 24.4580, 8.3653, 118.6052, 18.1080, 7.9545, 0],   // Fourier cube to Fourier camera
  [118.6052, 18.1080, 7.9545, 118.6052, 15.1080, 7.6595, 0],   // Fourier cube to Fourier camera
  [118.6052, 24.4580, 8.3653, 118.6052, 30.8080, 8.3653, 0],   // Fourier cube to beam dump
  [118.6052, 30.8080, 8.3653, 118.6052, 37.2080, 8.3653, 0],   // Fourier cube to beam dump
  [28.8000, 24.4580, 7.8544, 28.8000, 18.1080, 7.2734, 0],   // sensor cube to image sensor
  [28.8000, 18.1080, 7.2734, 28.8000, 4.7500, 5.4161, 0],   // sensor cube to image sensor
  [114.4552, 66.1580, 0.5000, 106.4552, 66.1580, 6.0000, 0],   // laser diode to collimator
  [106.4552, 66.1580, 6.0000, 100.9552, 66.1580, 6.0000, 0],   // collimator to source splitter cube
  [100.9552, 66.1580, 6.0000, 94.6052, 66.1580, 6.0000, 0],   // collimator to source splitter cube
  [94.6052, 66.1580, 6.0000, 88.2552, 66.1580, 6.0000, 0],   // source splitter cube to fold mirror
  [88.2552, 66.1580, 6.0000, 14.1000, 66.1580, 6.0000, 0],   // source splitter cube to fold mirror
  [14.1000, 66.1580, 6.0000, 14.1000, 30.8080, 6.0000, 0],   // fold mirror to illumination cube
  [14.1000, 30.8080, 6.0000, 14.1000, 24.4580, 6.0000, 0],   // fold mirror to illumination cube
  [14.1000, 24.4580, 6.0000, 7.7500, 24.4580, 6.0000, 0],   // illumination cube to input modulator
  [7.7500, 24.4580, 6.0000, 4.7500, 24.4580, 6.0000, 0],   // illumination cube to input modulator
  [14.1000, 24.4580, 6.0000, 14.1000, 18.1080, 6.0000, 0],   // illumination cube to beam dump
  [14.1000, 18.1080, 6.0000, 14.1000, 14.1080, 6.0000, 0],   // illumination cube to beam dump
  [94.6052, 66.1580, 6.0000, 94.6052, 59.8080, 6.0000, 1],   // source splitter cube to phase modulator
  [94.6052, 59.8080, 6.0000, 94.6052, 54.8080, 6.0000, 1],   // source splitter cube to phase modulator
  [94.6052, 54.8080, 6.0000, 94.6052, 42.1080, 6.0000, 1],   // source splitter cube to phase modulator
  [94.6052, 42.1080, 6.0000, 94.6052, 39.1080, 6.0000, 1],   // source splitter cube to phase modulator
  [94.6052, 48.4580, 6.0000, 100.9552, 48.4580, 6.0000, 1],   // reference cube to beam dump
  [100.9552, 48.4580, 6.0000, 104.9552, 48.4580, 6.0000, 1],   // reference cube to beam dump
  [94.6052, 39.1080, 2.1542, 94.6052, 42.1080, 2.4492, 1],   // phase modulator to reference lens
  [94.6052, 42.1080, 2.4492, 94.6052, 48.4580, 2.8600, 1],   // phase modulator to reference lens
  [94.6052, 48.4580, 2.8600, 88.2552, 48.4580, 3.2709, 1],   // phase modulator to reference lens
  [88.2552, 48.4580, 3.2709, 44.5236, 48.4580, 7.5703, 1],   // phase modulator to reference lens
  [44.5236, 48.4580, 7.5703, 28.8000, 48.4580, 6.9555, 1],   // reference lens to image sensor
  [28.8000, 48.4580, 6.9555, 28.8000, 30.8080, 6.2653, 1],   // reference lens to image sensor
  [28.8000, 30.8080, 6.2653, 28.8000, 18.1080, 5.9385, 1],   // reference lens to image sensor
  [28.8000, 18.1080, 5.9385, 28.8000, 4.7500, 5.4161, 1],   // reference lens to image sensor
];

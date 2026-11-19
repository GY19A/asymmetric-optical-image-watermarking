# Bill of materials: laboratory bench

Design files only. No hardware was built or measured. Part classes are examples. The column "required
specification" states what the design needs. Check every candidate part against it. Prices, suppliers, and order
codes are not given.

## Key optical parameters

| quantity | value |
|---|---|
| wavelength | 532 nm |
| object: pixels, pitch, width | 1024 x 1024, 8.0 um, 8.192 mm (diagonal 11.59 mm) |
| focal length of L1 and L2 | 230.36 mm (4f = 921 mm) |
| Fourier-plane bin pitch | 14.96 um = 4 modulator pixels of 3.74 um |
| pixel aperture fraction | 0.25 (one open pixel of 3.74 um per bin) |
| zero-order stop | radius 8 bins = 0.120 mm |
| Layer 1 ring | 16 to 80 bins = 0.239 to 1.197 mm |
| Layer 2 ring | 80 to 144 bins = 1.197 to 2.154 mm |
| Fourier-camera region | radius 160 bins, diameter 4.79 mm |
| nominal pupil | radius 512 bins, diameter 15.32 mm = 4096 modulator pixels |

## Commercial parts (by class)

| # | qty | element | part class (example) | required specification |
|---|---|---|---|---|
| 1 | 1 | laser source | single-frequency laser, single-mode fiber output | 532 nm; coherence length well above the arm path difference of 106 mm; the fiber tip is the spatial filter |
| 2 | 1 | collimator | achromatic doublet, f = 100 mm, diameter 25.4 mm | uniform plane wave over the object diagonal of 11.59 mm |
| 3 | 3 | polarizer and two analyzers | linear polarizers, diameter 25.4 mm | amplitude operation of the panels |
| 4 | 4 | beam-splitter cubes | non-polarizing 50:50 cubes, edge 25.4 mm | required beam diameter up to 20.1 mm (combiner cube) |
| 5 | 1 | input modulator | reflective LCOS panel, 8.0 um pixel pitch, amplitude mode | 1024 x 1024 pixels of 8.0 um (8.192 mm square), 10 amplitude bits |
| 6 | 2 | Fourier lenses L1, L2 | achromatic doublets, diameter 50.8 mm, effective focal length trimmed to the required value | f = 230.36 mm, matched pair; required beam diameter 26.9 mm |
| 7 | 1 | amplitude modulator (Fourier plane) | reflective LCOS panel, 3.74 um pixel pitch, amplitude mode between polarizers | pitch 3.74 um, 8 amplitude bits, one open pixel per 4 x 4 block, pupil of 4096 pixels (15.32 mm) in both axes |
| 8 | 1 | phase modulator (reference arm) | reflective LCOS panel, 3.74 um pixel pitch, phase mode | pitch 3.74 um, 8 phase bits over 2 pi at 532 nm; Layer 2 ring 1152 pixels across (4.31 mm); annular stop in front |
| 9 | 1 | Fourier camera | monochrome USB board camera | samples at the bin centers (pitch 14.96 um) over a diameter of 4.79 mm; pixel pitch at most 3.74 um; full well 3e4 e-, read noise 3 e-, 12-bit converter, 3 exposures in steps of 16 (span 1:256) |
| 10 | 1 | image sensor | monochrome USB board camera | 1024 x 1024 samples of 8.0 um (8.192 mm square, diagonal 11.59 mm); effective full well 1.2e5 e- (for example 4 averaged frames of 3e4 e-), read noise 6 e-, 12 bits |
| 11 | 1 | reference shutter | micro servo with printed flag | blocks the reference arm; driven by the microcontroller |
| 12 | 1 | variable attenuator | motorized neutral-density wheel or liquid-crystal attenuator, diameter 25.4 mm | carrier amplitude range 3.98 (12.0 dB in intensity); mean reference intensity 3.8e-6 to 5.9e-5 of the sensor full scale |
| 13 | 2 | stops | chrome-on-glass or printed film | zero-order stop: opaque dot of 0.24 mm diameter on a 12.7 mm window; annular stop: clear from 2.39 to 4.31 mm diameter |
| 14 | 5 | rails | slotted aluminum profile 20 x 20 mm | lengths 387, 588, 369, 369, and 121 mm |
| 15 | 1 | base board | flat, stiff board (aluminum tooling plate or laminated board) | 668 x 747 mm; optical axis 80 mm above the board (60 mm above the rail top) |
| 16 | 1 | housing panels | opaque sheet, 3 mm (black foam board or acrylic), on printed corner posts | light tight; lid switch in the laser enable line |
| 17 | 1 | USB hub | powered hub, at least 6 ports | 2 cameras, 3 display bridges, 1 microcontroller |
| 18 | 3 | display bridges | USB-to-video adapters or direct video outputs, one per panel driver | uncompressed, pixel-exact frames at the native panel resolution |
| 19 | 1 | microcontroller board | USB microcontroller with PWM and digital I/O | laser enable, servo shutter, attenuator, lid switch |
| 20 | - | fasteners | M5 T-nuts and screws for the rails; M3 screws and heat-set inserts for the printed parts; M2 and M2.5 screws for the boards | see the printed parts table |

## Required beam diameters

Measured along the object diagonal. The clear aperture of each element must be at least this large.

| element | required beam diameter (mm) |
|---|---|
| splitter cube | 11.59 |
| input cube | 13.49 |
| analyzer 1 | 15.64 |
| lens L1 | 26.90 |
| Fourier cube | 16.76 |
| amplitude modulator | 15.32 |
| Fourier camera | 4.79 |
| analyzer 2 | 18.01 |
| combiner cube | 20.10 |
| phase modulator | 4.31 |
| lens L2 | 26.90 |
| image sensor | 11.59 |

## Printed parts

Sources are in `scad/`, meshes in `stl/`. Bounding boxes and volumes are taken from the STL files. 25 part types.
The assembly uses 24 of them in 84 instances. Total printed volume 1569 cm^3 (solid).

| part (STL) | source | qty | bounding box (mm) | volume (cm^3) | print orientation | hardware per part |
|---|---|---|---|---|---|---|
| `beam_dump` | `parts_misc.scad` | 1 | 44.0 x 50.0 x 97.0 | 105.7 | flange down; the blind bore needs support or is printed on its back | 2 x screws into the base board |
| `camera_mount_fixed` | `parts_panels.scad` | 1 | 31.3 x 46.0 x 75.0 | 24.7 | foot down; bosses need no support if printed upright face down | 4 x M3 x 10; 4 x M2 for the board |
| `camera_slide_base` | `parts_panels.scad` | 1 | 56.0 x 40.0 x 20.0 | 14.4 | flat | 4 x M3 x 8 (counterbored); 3 x M3 inserts; M3 x 0.5 fine screw |
| `camera_slide_carriage` | `parts_panels.scad` | 1 | 38.0 x 46.0 x 69.0 | 24.7 | plate down | 2 x M3 x 12 with washers; 4 x M2 for the board |
| `corner_bracket` | `parts_misc.scad` | 5 | 34.0 x 54.0 x 15.0 | 6.8 | as modeled | 2 x M5 x 8 + T-nuts |
| `cube_clamp` | `parts_mounts.scad` | 4 | 39.6 x 39.6 x 4.0 | 6.2 | flat | 1 x M3 x 12; 1 x M3 nylon-tip set screw |
| `cube_table` | `parts_mounts.scad` | 4 | 36.9 x 41.0 x 65.7 | 45.4 | foot down | 4 x M3 x 10; 1 x M3 insert in the post |
| `electronics_tray` | `parts_misc.scad` | 1 | 200.0 x 150.0 x 8.0 | 86.3 | flat | 4 x screws into the base board |
| `enclosure_post` | `parts_misc.scad` | 4 | 44.0 x 44.0 x 130.0 | 73.5 | base down | 2 x screws into the base board |
| `fiber_holder` | `parts_misc.scad` | 1 | 30.0 x 40.0 x 68.0 | 21.4 | foot down | 4 x M3 x 10; 2 x M2.5 for the adapter flange |
| `laser_vblock` | `parts_misc.scad` | 0 | 30.0 x 40.0 x 54.0 | 38.1 | foot down | 4 x M3 x 10; 2 x M3 inserts for a strap |
| `lens_holder_12` | `parts_mounts.scad` | 1 | 30.0 x 40.0 x 68.3 | 26.8 | foot down | 4 x M3 x 10; 3 x M3 inserts |
| `lens_holder_25` | `parts_mounts.scad` | 5 | 30.0 x 45.4 x 74.7 | 34.9 | foot down; bore bridges | 4 x M3 x 10; 3 x M3 inserts |
| `lens_holder_50` | `parts_mounts.scad` | 2 | 30.0 x 70.8 x 87.4 | 51.2 | foot down; bore bridges | 4 x M3 x 10; 3 x M3 inserts |
| `panel_frame_board` | `parts_panels.scad` | 1 | 44.0 x 60.0 x 104.0 | 49.0 | foot down | 2 x M5 into the base board; 3 x M3 inserts |
| `panel_frame_rail` | `parts_panels.scad` | 2 | 30.0 x 56.0 x 76.0 | 30.9 | foot down | 4 x M3 x 10; 3 x M3 inserts |
| `panel_tilt_plate` | `parts_panels.scad` | 3 | 4.0 x 56.0 x 48.0 | 10.4 | flat | 3 x M3 x 16 + 3 compression springs; 4 x M2.5 for the board |
| `rail_carrier` | `parts_mounts.scad` | 18 | 30.0 x 40.0 x 12.0 | 11.0 | plate down, skirts up (flip) or as modeled with supports under the plate | 2 x M5 x 10 + T-nuts; 4 x M3 heat-set inserts |
| `rail_foot` | `parts_misc.scad` | 18 | 20.0 x 22.0 x 15.0 | 3.0 | as modeled | 1 x M5 x 8 + T-nut; 1 x screw into the base board |
| `retaining_ring_12` | `parts_mounts.scad` | 1 | 30.7 x 30.7 x 3.0 | 1.9 | flat | 3 x M3 x 8 |
| `retaining_ring_25` | `parts_mounts.scad` | 5 | 43.4 x 43.4 x 3.0 | 3.2 | flat | 3 x M3 x 8 |
| `retaining_ring_50` | `parts_mounts.scad` | 2 | 68.8 x 68.8 x 3.0 | 5.7 | flat | 3 x M3 x 8 |
| `shutter_bracket` | `parts_misc.scad` | 1 | 30.0 x 46.0 x 87.6 | 25.7 | foot down; servo window bridges | 4 x M3 x 10; 2 x M2 self-tapping |
| `shutter_flag` | `parts_misc.scad` | 1 | 26.0 x 43.3 x 1.6 | 1.6 | flat | servo horn screws |
| `stop_cap` | `parts_panels.scad` | 1 | 5.4 x 39.0 x 39.0 | 2.8 | plate down, legs up | shares the 4 x M2 board screws |

`laser_vblock` is an alternative to `fiber_holder` (a 12 mm laser module barrel instead of a fiber adapter). It is
not placed in the assembly.

## Not part of this list

Cables, firmware, and driver software are not designed.

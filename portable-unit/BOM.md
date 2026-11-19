# Bill of materials: portable unit

Design files only. No hardware was built or measured. Component classes only: no supplier, no order code, no price.
The column "required specification" states what the design needs. The column "assumed outline" gives the body size
that the printed housing is drawn for. These outlines are assumptions of the mechanical layout, not data-sheet
values. Set them to the selected parts in `scad/layout_gen.scad` before printing.

## Components (not printed)

| item | qty | class | required specification | assumed outline (mm) |
|---|---|---|---|---|
| laser diode | 1 | single-mode laser diode in a metal can | wavelength 520 nm | can diameter 5.6, length 4.5; pin zone diameter 4, length 6.5 |
| collimator | 1 | collimator lens in a cell | collimated beam of at least 6 mm (object diagonal 5.416 mm); focal length 8 mm | cell diameter 9, length 5 |
| splitter cube | 5 | non-polarizing 50:50 cube | edge 12.7 mm; clear aperture needed 8.44 mm (object side), 8.78 mm (Fourier side) | edge 12.7 |
| Fourier lens | 1 | achromatic lens in a cell | f = 55.09 mm; clear aperture needed 13.08 mm | cell diameter 18, length 8 |
| reference lens | 1 | achromatic lens in a cell | f = 55.09 mm; clear aperture needed 7.57 mm | cell diameter 12.7, length 6 |
| input modulator | 1 | reflective LCOS microdisplay, 3.74 um pixel pitch, amplitude mode between polarizers | window 1024 x 1024 pixels = 3.830 mm square; 10 bits | 22 x 14 x 3 |
| amplitude modulator (Fourier plane) | 1 | reflective LCOS microdisplay, 3.74 um pixel pitch, at least 2464 pixels on the short side | window 2048 x 2048 pixels = 7.660 mm square; 8 bits | 22 x 14 x 3 |
| phase modulator | 1 | reflective LCOS microdisplay, 3.74 um pixel pitch, phase mode | window 576 x 576 pixels = 2.154 mm square; 8 bits | 22 x 14 x 3 |
| annular stop | 1 | thin opaque mask on the phase modulator | opening over the reference window of 2.154 mm | 14 x 14 x 0.5 |
| image sensor | 1 | board-level camera | 1024 x 1024 samples at 3.74 um = 3.830 mm square | 14 x 14 x 3 |
| Fourier camera | 1 | board-level camera with a zero-order stop on its window | read region of 2.394 mm diameter; pixel pitch at most 1.87 um; stop of 0.120 mm diameter | 14 x 14 x 3 |
| fold mirror | 2 | square first-surface mirror | beam of 6.96 mm at 45 degrees on the reference side | 12.7 x 12.7 x 2 |
| shutter / attenuator | 1 | flat liquid-crystal cell | clear aperture for the 6 mm reference feed | 16 x 12.7 x 2 |
| printed circuit board | 1 | one board under the optical deck | outline 128.9 x 70.5 mm, 1.6 mm thick, components up to 3 mm high; circuit not designed | - |
| USB-C receptacle | 1 | board-mounted receptacle at the end wall | cut-out in the end wall of the base tray | 8.94 x 3.26 x 7.35 (width x height x depth) |
| screw, lid | 4 | M2 countersunk self-tapping | through 2.4 mm of lid into the chassis bosses | - |
| screw, base | 4 | M2 countersunk self-tapping | clamped stack of 8.4 mm (floor, pad, board, spacer, deck) into the chassis bosses | - |
| screw, clamps | 12 | M2 countersunk self-tapping | 9 clamp tabs and 3 lens clamps | - |

Not designed and not in this list: polarizer and analyzer films (the amplitude mode of the panels needs them), panel
driver boards, flex cables, laser driver and heat sink, absorber coating of the beam dumps.

## Printed parts

Sources are in `scad/`, meshes in `stl/`. Bounding boxes and volumes are taken from the STL files.

| part (STL) | qty | bounding box (mm) | volume (cm^3) | print orientation |
|---|---|---|---|---|
| `base_tray` | 1 | 132.71 x 74.26 x 6.80 | 15.447 | floor on the bed |
| `chassis` | 1 | 132.71 x 74.26 x 21.60 | 51.263 | as modeled: underside of the deck on the bed |
| `lens_clamp` | 3 | 9.10 x 4.60 x 3.00 | 0.088 | top face on the bed (upside down) |
| `lid` | 1 | 132.71 x 74.26 x 2.40 | 12.227 | outer face on the bed (lip and pads up) |
| `pcb_spacer` | 4 | 5.60 x 5.60 x 3.50 | 0.069 | standing |
| `tab_clamp_narrow` | 7 | 9.00 x 4.60 x 2.00 | 0.070 | flat, countersink up |
| `tab_clamp_wide` | 2 | 9.00 x 9.00 x 2.00 | 0.149 | flat, countersink up |

7 part types, 19 instances, 80.3 cm^3 in total (about 102 g of PETG at 1.27 g/cm^3, solid).

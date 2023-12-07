/*
Define file for VGA timings, fetch timings, and 


*/

`define HACTIVE 640
`define HFRONTPORCH 16
`define HSYNCPULSE 96
`define HBACKPORCH 48
`define HFULLSCAN (`HACTIVE+`HFRONTPORCH+`HSYNCPULSE+`HBACKPORCH)

`define VACTIVE 480
`define VFRONTPORCH 11
`define VSYNCPULSE 2
`define VBACKPORCH 32
`define VFULLSCAN (`VACTIVE+`VFRONTPORCH+`VSYNCPULSE+`VBACKPORCH)

`define HFETCHNEXTLINE 20
`define HFETCH `HFULLSCAN - `HFETCHNEXTLINE - 1

// Vectors defining size of segments

`define L_H -2  // vertical size of horizontal segments
`define L_V -11 // vertical size of vertical segments
`define W_H 11 // horizontal size of horizontal segments
`define W_V 2  // horizontal size of vertical segments 
`define HSIZE `W_H + 2*`W_V   // Total horizontal pixels taken up by the segment
`define VSIZE (-2*`L_V + -3*`L_H) // Total vertical pixels taken up by the segment (up positive)

// Offsets for beginning of each segment

`define HBAR_OFFSET_X   `W_V
`define VBAR_L_OFFSET_X 0
`define VBAR_R_OFFSET_X `W_V + `W_H

`define HBARLOW_OFFSET_Y 0
`define HBARMID_OFFSET_Y `L_H + `L_V
`define HBARHI_OFFSET_Y  2*`L_H + 2*`L_V
`define VBARLOW_OFFSET_Y `L_H
`define VBARHI_OFFSET_Y  2*`L_H + `L_V

`define A_X `HBAR_OFFSET_X
`define B_X `VBAR_R_OFFSET_X
`define C_X `VBAR_R_OFFSET_X
`define D_X `HBAR_OFFSET_X
`define E_X `VBAR_L_OFFSET_X
`define F_X `VBAR_L_OFFSET_X
`define G_X `HBAR_OFFSET_X

`define A_Y `HBARHI_OFFSET_Y
`define B_Y `VBARHI_OFFSET_Y
`define C_Y `VBARLOW_OFFSET_Y
`define D_Y `HBARLOW_OFFSET_Y
`define E_Y `VBARLOW_OFFSET_Y
`define F_Y `VBARHI_OFFSET_Y
`define G_Y `HBARMID_OFFSET_Y

// Offsets for number positions

`define HSPACING 10 // There's a bug where HSIZE-HSPACING doesn't result in the correct spacing. Setting this to 10 fixes it. Too bad!
`define VSPACING 2

`define ONES_X_OFFSET `HACTIVE - `HSIZE - `HSPACING - 1
`define TENS_X_OFFSET `ONES_X_OFFSET - `HSIZE - `HSPACING
`define HUNS_X_OFFSET `TENS_X_OFFSET - `HSIZE - `HSPACING

`define ONES_Y_OFFSET `VACTIVE-`VSPACING - 1
`define TENS_Y_OFFSET `VACTIVE-`VSPACING - 1
`define HUNS_Y_OFFSET `VACTIVE-`VSPACING - 1



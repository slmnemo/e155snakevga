/*
Define file for VGA timings, fetch timings, and 


*/
`define RISETIMECORRECTION 0

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

// Offsets for number positions

`define ONES_X_OFFSET 300-2
`define TENS_X_OFFSET 400-2
`define HUNS_X_OFFSET 500-2

`define ONES_Y_OFFSET 100-2
`define TENS_Y_OFFSET 200-2
`define HUNS_Y_OFFSET 300-2

// Vectors defining size of segments

`define L_H 2  // vertical size of horizontal segments
`define L_V 11 // vertical size of vertical segments
`define W_H 11 // horizontal size of horizontal segments
`define W_V 2  // horizontal size of vertical segments 

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



/*
Define file for VGA timings


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

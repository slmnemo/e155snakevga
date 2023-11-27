/*
Define file for VGA timings


*/
`define RISETIMECORRECTION 3

`define HACTIVE 640
`define HFRONTPORCH 16
`define HSYNCPULSE 64
`define HBACKPORCH 120
`define HFULLSCAN (`HACTIVE+`HFRONTPORCH+`HSYNCPULSE+`HBACKPORCH)

`define VACTIVE 480
`define VFRONTPORCH 1
`define VSYNCPULSE 3
`define VBACKPORCH 16
`define VFULLSCAN (`VACTIVE+`VFRONTPORCH+`VSYNCPULSE+`VBACKPORCH)

---
layout: page
title: Design
permalink: /design/
---
# Design Decisions
This project focused on using the VGA protocol at the industry standard 640x480 resolution at 60 Hz refresh rate. Holding RGB values for each pixel would require 3\*640\*480 = 921600 bits of memory, more than the FPGA can hold in flip flops or in RAM. Therefore, to mitigate this constraint, we partitioned the screen in 20 pixel square chunks, allowing us to use the onboard embedded block RAM on the FPGA. This results in a chunk resolution of 32 by 24. 


# MCU Design
The MCU in this design is responsible for handling user input and game logic. User input is given through a set of four push buttons, which correspond to each direction the snake can move in. These buttons are tied to interrupts, allowing input to happen at any point during the calculations of game logic. This lets the inputs feel very responsive, as the input won't be missed due to polling at the wrong time. 

### SPI Design
Communication between the FPGA and MCU is entirely controlled by the MCU, as the FPGA has no need to send data to the MCU. This communication is done over SPI, with the following structure:
![SPI Timing Diagram](./assets/img/spi_timing.png)

The command, data1, and data2 bytes follow the following table:

| Command | Hex Encoding | Data Byte 1 | Data Byte 2 |
| ------- | ------------ | ----------- | ----------- |
| Write Color Base Address | 0x80 | X Position | Y Position |
| Update Score | 0x10 | Score value MSBs | Score value LSBs |

To set a specific color with the Write Color Base Address command, the lowest 3 bytes of the command byte follow the following encoding:

| Lowest 3 bits of command | Color |
| ------------------------ | ----- |
| 0 | Black |
| 1 | Blue | 
| 2 | Green | 
| 3 | Cyan |
| 4 | Red |
| 5 | Purple | 
| 6 | Yellow | 
| 7 | White | 

For example, to set the pixel at (4,7) to red,
- command = 0x84
- data1 = 4
- data2 = 7

The update score command follows a similar structure, except no data is encoded in the command byte.




## MCU Block Diagram

# FPGA Design

## FPGA Block Diagram

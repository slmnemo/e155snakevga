"""
File to generate testvectors for the controller testbench to test row col logic as well as raddr and updateoutput

inputs: duration (random)
outputs: row, col, raddr, updateoutput

format of output encoding is

next_duration{5}___row{10}_col{10}_raddr{10}_updateoutput

Writes to an output directory ./testvectors/
"""

import random

outputdir = "./testvectors/"
filename = "vga_transmitter.tv"

loops = 1
colsize = 525
rowsize = 800
h_visiblepix = 640
h_frontporch = 16
h_synctime = 96
h_backporch = 48
rowsize = h_visiblepix + h_frontporch + h_synctime + h_backporch
v_visiblepix = 480
v_frontporch = 10
v_synctime = 2
v_backporch = 33
colsize = v_visiblepix + v_frontporch + v_synctime + v_backporch

filepath = f"{outputdir}{filename}"
file = open(filepath, "w+")
testvectors = ["// Generated using transmitter_generator.py written by Kaitlin Lucio\n", "// format is \n// row_col_R_inG_inB_in___VSync_HSync_R_outG_outB_out", \
               "//\n", "// data below\n", "\n"]

totaltests = 0

for i in range(loops):
    for col in range(colsize):
        for row in range(rowsize):
            rgb = random.randint(0,7) # Set new input rgb value from 0 to 7
            if (col < v_visiblepix) and (row < h_visiblepix):
                # If col and row valid, set rgb_expected to rgb
                rgb_expected = rgb
            else:
                # If col or row not valid, set rgb_expected to 0
                rgb_expected = 0
            if (col < v_visiblepix+v_frontporch) or (col >= v_visiblepix+v_frontporch+v_synctime):
                # If col is in valid  location, col is less than value of pix+frontporch or more than previous+synctime
                VSync = 1
            else:
                VSync = 0
            if (row < h_visiblepix+h_frontporch) or (row >= h_visiblepix+h_frontporch+h_synctime):
                HSync = 1
            else:
                HSync = 0
            totaltests += 1
            testvectors += [f"{row:010b}_{col:010b}_{rgb:03b}___{VSync:01b}_{HSync:01b}_{rgb_expected:03b}\n"]
        
file.writelines(testvectors)
print(f"Created {totaltests} testvectors")



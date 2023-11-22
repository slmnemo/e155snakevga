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
filename = "vga_controller.tv"

loops = 2
colsize = 525
rowsize = 800
colblock = 0
colblocks = 480 / 20
rowblock = 0
rowblocks = 640 / 20

next_duration = random.randint(1,31)
duration = 0
duration_trig = 0

filepath = f"{outputdir}{filename}"
file = open(filepath, "w+")
testvectors = ["// Generated using controller_generator.py by Kaitlin Lucio\n", "// format is \n// next_duration___row_col_raddr_updateoutput", \
               "//\n", "// data below\n", "\n"]

totaltests = 0

for i in range(loops):
    for col in range(colsize):
        for row in range(rowsize):
            if (col < 480) and (row < 640):
                # If output is valid, check all important qualities
                if duration == duration_trig: 
                    # if duration triggers, next_duration becomes duration_trig, get new next_duration. set duration to 0 and update output
                    duration_trig = next_duration
                    next_duration = random.randint(0,31)
                    duration = 0
                    outputupdate = 1
                    re = 0
                else: # if duration not triggered, set outputupdate to zero and increment duration by 1
                    outputupdate = 0
                    duration += 1
                    re = 0
                if (((row + 1) % 20) == 0) or (row == 1): # every 20 row pixels in valid area, increment block by 1
                    rowblock += 1
                    re = 1
            elif (row > 640) and (col < 480): # row invalid, set rowblock to 0 and outputupdate to 1
                rowblock = 0
                outputupdate = 1
                re = 1
                if (row == 799) and (((col + 1) % 20) == 0):
                    colblock += 1
            else: # output completely invalid, read 0x000 from memory and continue iterating row/col. outputupdate becomes 1
                rowblock = 0
                outputupdate = 1
                re = 1
            rowaddr = f"{rowblock:06b}"
            rowaddr = rowaddr[1:]
            totaltests += 1
            testvectors += [f"{next_duration:05b}___{row:010b}_{col:010b}_{colblock:05b}{rowaddr}_{outputupdate:01b}_{re:01b}\n"]
        # if (col < 480): # col valid, check for colblock increment
        #     if ((col + 1) % 20) == 0: # every 20 col pixel, increment colblock by 1
        #         colblock += 1
        if (col >= 480): # col invalid, set colblock to zero
            colblock = 0

        # clear duration for new frame and move to next (could be wrong lol)
        duration = 0
        duration_trig = next_duration
        next_duration = random.randint(0,31)

file.writelines(testvectors)
print(f"Created {totaltests} testvectors")



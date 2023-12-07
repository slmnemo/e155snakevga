#ifndef SNAKE_H
#define SNAKE_H

#include "STM32L432KC.h"

#define NUM_ROWS 20
#define NUM_COLS 30
#define MAX_NUM_TAILS = NUM_ROWS*NUM_COLS

// Array containing X values to write for each Y value in an array to draw snake (y-negative) [x][y]
// 
// Each line terminates with a -1.
int[][] snakelines = {
    {2, 3, 4, 5, 7, 11, 14, 15, 16, 17, 18, 21, 22, 23, 24, 26, 27, 28, 29, -1}, // Line 0
    {2, 3, 7, 8, 11, 14, 15, 17, 18, 21, 24, 26, 27, -1},
    {2, 7, 8, 11, 14, 18, 21, 23, 24, 26, -1},
    {3, 4, 5, 7, 9, 11, 13, 14, 15, 16, 17, 18, 20, 21, 22, 23, 26, 27, 28, -1},
    {5, 7, 10, 11, 14, 18, 21, 22, 23, 24, 26, -1},
    {4, 5, 7, 10, 11, 14, 18, 21, 24, 26, 27, -1},
    {2, 3, 4, 5, 7, 11, 14, 18, 21, 24, 26, 27, 28, 29, -1}
};

typedef enum color {
    // using R G B encoding for each color
    BLACK  = 0b000,
    BLUE   = 0b001,
    GREEN  = 0b010,
    CYAN   = 0b011,
    RED    = 0b100,
    PURPLE = 0b101,
    YELLOW = 0b110,
    WHITE  = 0b111
} color_t;

typedef enum direction {
    STOP = 0,
    UP, 
    DOWN,
    RIGHT,
    LEFT
} direction_t;

typedef enum spi_command {
    WRITE_COLOR       = 0x80,
    UPDATE_SCORE      = 0x10,
    UPDATE_GAME_STATE = 0x20
} spi_command_t;


void write_pixel(uint8_t pixel_x, uint8_t pixel_y, color_t color);

void write_start_screen();

// game logic functions
void init_game();
void draw_snake();
void draw(); // for terminal debugging
void place_fruit();
void input(); // for keyboard debugging
void game_logic();


#endif // SNAKE_H





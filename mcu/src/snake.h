#ifndef SNAKE_H
#define SNAKE_H

#include "STM32L432KC.h"

#define GAME_ROWS 21
#define GAME_COLS 30

#define SCREEN_ROWS 24
#define SCREEN_COLS 32

#define SIDE_BORDER_WIDTH (SCREEN_COLS - GAME_COLS)/2
#define TOP_BORDER_WIDTH 1
#define BOTTOM_BORDER_WIDTH (SCREEN_ROWS - GAME_ROWS - TOP_BORDER_WIDTH)


#define MAX_NUM_TAILS GAME_ROWS*GAME_COLS

// Array containing X values to write for each Y value in an array to draw snake (y-negative) [x][y]

// Each line terminates with a -1.


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
} spi_command_t;


void write_pixel(uint8_t pixel_x, uint8_t pixel_y, color_t color);
void write_border(color_t color);
void write_splash_screen(int* lines);

// game logic functions
void init_game();
void draw_snake();
void draw(); // for terminal debugging
void place_fruit();
void input(direction_t new_input); 
void game_logic();
void update_score(int score);
void clear_screen();
void color_entire_screen(color_t color);


#endif // SNAKE_H





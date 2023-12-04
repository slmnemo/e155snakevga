#ifndef SNAKE_H
#define SNAKE_H

#include "STM32L432KC.h"

#define NUM_ROWS 20
#define NUM_COLS 30
#define MAX_NUM_TAILS = NUM_ROWS*NUM_COLS

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
void draw(); // for terminal debugging
void place_fruit();
void input(); // for keyboard debugging
void game_logic();


#endif // SNAKE_H





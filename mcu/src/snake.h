#ifndef SNAKE_H
#define SNAKE_H

#include "STM32L432KC.h"

#define NUM_ROWS 22
#define NUM_COLS 30

typedef enum color {
    RED,
    GREEN,
    BLUE,
    WHITE,
    BLACK
} color_t;

typedef enum spi_command {
    CLEAR             = 0x00,
    WRITE_WHITE       = 0x01,
    WRITE_RED         = 0x02,
    WRITE_GREEN       = 0x03,
    WRITE_BLUE        = 0x04,
    UPDATE_SCORE      = 0x05,
    UPDATE_GAME_STATE = 0x06
} spi_command_t;

typedef struct game_square {
    color_t pixel_color;
    int snake_head;
    int snake_tail;
    int snake_body;
    int has_apple;
} game_square_t;

typedef struct game_board {
    game_square_t board[NUM_ROWS][NUM_COLS];
    uint32_t score;
} game_board_t;


void write_pixel(uint8_t pixel_x, uint8_t pixel_y, color_t color);

void clear_pixel(uint8_t pixel_x, uint8_t pixel_y);

void write_start_screen();

#endif // SNAKE_H





#include "snake.h"
#include "main.h"


// sends a write pixel command to the FPGA for rendering
void write_pixel(uint8_t pixel_x, uint8_t pixel_y, color_t color)
{
    // use color command
    spi_command_t command;
    command = WRITE_COLOR | color; // encodes write color cmd in upper 4 bits, color in lowest 4 bits

    // begin SPI transaction
    SPI_BEGIN; // pull CS high
    spiSendReceive((char)command);
    spiSendReceive(pixel_y);
    spiSendReceive(pixel_x);
    SPI_END; // set CS back to low

    return;

}

void clear_screen()
{
    for (uint8_t i = 0; i < SCREEN_ROWS; i++) {
        for (uint8_t j = 0; j < SCREEN_COLS; j++) {
            write_pixel(i, j, BLACK);
            delay_micros(DELAY_TIM_US, 10);
        }
    }

    return;

}

void write_border()
{
    return;
}

void write_start_screen()
{
    return;
}

// ******************* GAME LOGIC FUNCTIONS ***********************

uint8_t snake_head_x, snake_head_y, fruit_x, fruit_y;
uint8_t tails_x[MAX_NUM_TAILS];
uint8_t tails_y[MAX_NUM_TAILS];
int num_tails;
direction_t dir;
extern int game_over;
int score;

void update_score(int score_input) {
    uint8_t score_MSB = (score_input << 8) & 0b11; // bits 9 and 10
    uint8_t score_LSB = score_input & 0xFF;

    SPI_BEGIN;
    spiSendReceive((char)UPDATE_SCORE);
    spiSendReceive(score_MSB);
    spiSendReceive(score_LSB);
    SPI_END;
}

void init_game() {
    game_over = 0;
    dir = STOP;
    num_tails = 0;
    snake_head_x = GAME_COLS / 2;
    snake_head_y = GAME_ROWS / 2;

    // send pixel command to init head
    write_pixel(snake_head_y, snake_head_x, GREEN);

    place_fruit();

    return;
}

void write_snake(int[][] *snakelines) {
    int const snake_y_offset = 4;
    int const snake_lines = 7;
    int i = 0;
    int x = 0;
    int not_term = 1;
    for (y=snake_y_offset, y < snake_y_offset + snake_lines, y++) {
        not_term = 1;
        i = 0;
        while (not_term)
            x = snakelines[i];
            if (x < 0) {
                not_term = 0;
            } else {
                write_pixel(x, y, GREEN);
            }
            i++
    }
}

void draw() {
    // function to draw game to terminal, mostly for PC debugging
    // system("cls");

    for (int i = 0; i < GAME_COLS + 2; i++)
        printf("#");
    printf("\n");

    for (int i = 0; i < GAME_ROWS; i++) {
        for (int j = 0; j < GAME_COLS; j++) {
            if (j == 0)
                printf("#");

            if (i == snake_head_y && j == snake_head_x)
                printf("O");
            else if (i == fruit_y && j == fruit_x)
                printf("F");
            else {
                int print_tail = 0;
                for (int k = 0; k < num_tails; k++) {
                    if (tails_x[k] == j && tails_y[k] == i) {
                        printf("o");
                        print_tail = 1;
                    }
                }

                if (!print_tail)
                    printf(" ");
            }

            if (j == GAME_COLS - 1)
                printf("#");
        }
        printf("\n");
    }

    for (int i = 0; i < GAME_COLS + 2; i++)
        printf("#");
    printf("\n");
}

void place_fruit() {
    // naive placement of fruit, does not account for where snake is
    fruit_x = rand() % GAME_COLS;
    fruit_y = rand() % GAME_ROWS;

    write_pixel(fruit_y, fruit_x, RED);
    return;
}

void input(direction_t new_input) {
   // use PC keyboard input for now for testing
    switch (new_input) {
        case LEFT: // moving left
            if (dir != RIGHT) {
                dir = LEFT;
            }
            break;
        case RIGHT: // moving right
            if (dir != LEFT) {
                dir = RIGHT;
            }
            break;
        case UP: // moving up
            if (dir != DOWN) {
                dir = UP;
            }
            break;
        case DOWN: // moving down
            if (dir != UP) {
                dir = DOWN;
            }
            break;
        case STOP:
            // do nothing
            break;
        default:
            game_over = 1;
            break;
    }
}

void game_logic() {
    int prev_head_x = tails_x[0];
    int prev_head_y = tails_y[0];

    // make head into next tail segment
    tails_x[0] = snake_head_x;
    tails_y[0] = snake_head_y;

    // clear old tail
    if (num_tails > 0) {
        printf("clearing old tail\n");

    }

    // propagate tails
    for (int i = 1; i < num_tails; i++) {
        int temp_x = tails_x[i]; 
        int temp_y = tails_y[i];
        tails_x[i] = prev_head_x;
        tails_y[i] = prev_head_y;
        prev_head_x = temp_x;
        prev_head_y = temp_y;
    }


    // propagate head
    switch (dir) {
        case LEFT:
            snake_head_x--;
            break;
        case RIGHT:
            snake_head_x++;
            break;
        case UP:
            snake_head_y--;
            break;
        case DOWN:
            snake_head_y++;
            break;
        default:
            // do nothing
            break;
    }

    printf("updating head at %d %d\n", snake_head_x, snake_head_y);
    write_pixel(snake_head_y, snake_head_x, GREEN);

    // TODO: call to write_pixel to update head
    
    // check boundary conditions
    if (snake_head_x < 0 || snake_head_x >= GAME_COLS || snake_head_y < 0 || snake_head_y >= GAME_ROWS)
        game_over = 1;

    // check if head runs into tails
    for (int i = 0; i < num_tails; i++)
        if (tails_x[i] == snake_head_x && tails_y[i] == snake_head_y)
            game_over = 1;

    // check if head ate fruit
    if (snake_head_x == fruit_x && snake_head_y == fruit_y) {
        num_tails++;
        place_fruit();
        score += 1;
    }
}

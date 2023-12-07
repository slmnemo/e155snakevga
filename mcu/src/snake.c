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
    spiSendReceive(pixel_x);
    spiSendReceive(pixel_y);
    SPI_END; // set CS back to low

    return;

}


void write_start_screen()
{
    return;
}

// ******************* GAME LOGIC FUNCTIONS ***********************

int snake_head_x, snake_head_y, fruit_x, fruit_y;
int tails_x[MAX_NUM_TAILS], tails_y[MAX_NUM_TAILS];
int num_tails;
direction_t dir;
int game_over;
int score;

void init_game() {
    game_over = 0;
    dir = STOP;
    snake_head_x = WIDTH / 2;
    snake_head_y = HEIGHT / 2;
    fruit_x = rand() % WIDTH;
    fruit_y = rand() % HEIGHT;
    num_tails = 0;
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
    system("cls");

    for (int i = 0; i < WIDTH + 2; i++)
        printf("#");
    printf("\n");

    for (int i = 0; i < HEIGHT; i++) {
        for (int j = 0; j < WIDTH; j++) {
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

            if (j == WIDTH - 1)
                printf("#");
        }
        printf("\n");
    }

    for (int i = 0; i < WIDTH + 2; i++)
        printf("#");
    printf("\n");
}

void place_fruit() {
    // naive placement of fruit, does not account for where snake is
    fruit_x = rand() % NUM_COLS;
    fruit_y = rand() % NUM_ROWS;
    return;
}

void input() {
    // use PC keyboard input for now for testing
    if (_kbhit()) {
        switch (_getch()) {
            case 'a': // moving left
                if (dir != RIGHT) {
                    dir = LEFT;
                }
                break;
            case 'd': // moving right
                if (dir != LEFT) {
                    dir = RIGHT;
                }
                break;
            case 'w': // moving up
                if (dir != DOWN) {
                    dir = UP;
                }
                break;
            case 's': // moving down
                if (dir != UP) {
                    dir = DOWN;
                }
                break;
            case 'x':
                game_over = 1;
                break;
        }
    }
}

void game_logic() {
    int prev_head_x = tails_x[0];
    int prev_head_y = tails_y[0];

    // make head into next tail segment
    tails_x[0] = snake_head_x;
    tails_y[0] = snake_head_y;

    // propagate tails
    for (int i = 1; i < num_tails; i++) {
        int temp_x = tails_x[i]; 
        int temp_y = tails_y[i];
        tails_x[i] = prev_head_x;
        tails_y[i] = prev_head_y;
        prev_head_x = temp_x;
        prev_head_y = temp_y;
    }

    // TODO: call to write_pixel to update tail position

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

    // TODO: call to write_pixel to update head
    
    // check boundary conditions
    if (snake_head_x < 0 || snake_head_x >= NUM_COLS || snake_head_y < 0 || snake_head_y >= NUM_ROWS)
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

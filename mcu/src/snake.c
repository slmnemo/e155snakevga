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
    color_entire_screen(BLACK);
    return;

}

void color_entire_screen(color_t color)
{
    for (uint8_t i = 0; i < SCREEN_ROWS; i++) {
        for (uint8_t j = 0; j < SCREEN_COLS; j++) {
            write_pixel(i, j, color);
            // delay_micros(DELAY_TIM_US, 1000);
        }
    }
}


void write_border(color_t color)
{
    // draw top border
    for(int row = 0; row < TOP_BORDER_WIDTH; row++)
    {
        for(int col = 0; col < SCREEN_COLS; col++)
        {
            write_pixel(row, col, color);
        }
    }

    // draw bottom border
    for (int row = SCREEN_ROWS - 1; row > (SCREEN_ROWS - BOTTOM_BORDER_WIDTH - 1); row--)
    {
        for(int col = 0; col < SCREEN_COLS; col++)
        {
            write_pixel(row, col, color);
        }
    }

    // left border
    for (int col = 0; col < SIDE_BORDER_WIDTH; col++)
    {
    
        for(int row = 0; row < SCREEN_COLS; row++)
        {
            write_pixel(row, col, color);
        }
    }

    // right border
    for (int col = SCREEN_COLS - 1; col > (SCREEN_COLS -  SIDE_BORDER_WIDTH - 1); col--)
    {
    
        for(int row = 0; row < SCREEN_COLS; row++)
        {
            write_pixel(row, col, color);
        }
    }


    return;
}

void write_splash_screen(int* lines) {
    // lines is separated by -1 when we are to go to next line
    int const snake_y_offset = 4;
    int const snake_lines = 7;
    int const MAX_ITER = 400;
    int i = 0;
    int x = 0;
    int not_term = 1;
    i = 0;
    for (int y=snake_y_offset; y < snake_y_offset + snake_lines; y++) {
        not_term = 1;
        while (not_term && i < MAX_ITER)
        {
            x = lines[i];

            
            if (x < 0) {
                not_term = 0;
            } else {
                write_pixel(y, x, GREEN);
            }
            i++;
          }
    }
}


// ******************* GAME LOGIC FUNCTIONS ***********************

uint8_t snake_head_x, snake_head_y, fruit_x, fruit_y;
uint8_t tails_x[MAX_NUM_TAILS];
uint8_t tails_y[MAX_NUM_TAILS];
int num_tails, got_fruit;
direction_t dir;
extern int game_over;
extern int score;

void update_score(int score_input) {
    // send score to FPGA
    uint8_t score_MSB = (score_input >> 8) & 0b11; // bits 9 and 10
    uint8_t score_LSB = score_input & 0xFF;

    SPI_BEGIN;
    spiSendReceive((char)UPDATE_SCORE);
    spiSendReceive(score_MSB);
    spiSendReceive(score_LSB);
    SPI_END;
}

void draw_snake()
{
    // draw green for all positions where the snake is
    
    if (num_tails > 0)
    {
        int y = tails_y[num_tails-1];
        int x = tails_x[num_tails-1];

        // write tail 
        write_pixel(y + TOP_BORDER_WIDTH, x + SIDE_BORDER_WIDTH, GREEN);
    }
    
    // write head
    write_pixel(snake_head_y + TOP_BORDER_WIDTH, snake_head_x + SIDE_BORDER_WIDTH, GREEN);

    // write fruit
    write_pixel(fruit_y + TOP_BORDER_WIDTH, fruit_x + SIDE_BORDER_WIDTH, RED);
    
}

void clear_snake()
{
    // write black to where the last tail is
    
    if (num_tails > 0)
    {
        int y = tails_y[num_tails-1];
        int x = tails_x[num_tails-1];

        // clear tail 
        write_pixel(y + TOP_BORDER_WIDTH, x + SIDE_BORDER_WIDTH, BLACK);
    }

    
    if (num_tails == 0) 
    {
        write_pixel(snake_head_y + TOP_BORDER_WIDTH, snake_head_x + SIDE_BORDER_WIDTH, BLACK);
    } 
    // write_pixel(fruit_y + TOP_BORDER_WIDTH, fruit_x + SIDE_BORDER_WIDTH, BLACK);
}

void init_game() {
    game_over = 0;
    dir = STOP;
    num_tails = 100;
    got_fruit = 0;
    snake_head_x = GAME_COLS / 2;
    snake_head_y = GAME_ROWS / 2;
    update_score(score);

    // send pixel command to init head
    write_pixel(snake_head_y + TOP_BORDER_WIDTH, snake_head_x + SIDE_BORDER_WIDTH, GREEN);

    place_fruit();

    return;
}

void draw() {
    // function to draw game to terminal, mostly for debugging

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
    // if the fruit appears where the snake is, it's a feature not a bug!

    // goal: get all the empty cells

    uint8_t empty_cells_x[MAX_NUM_TAILS];
    // uint8_t* empty_cells_x = (uint8_t *) malloc((num_tails+1)*sizeof(uint8_t));
    // uint8_t* empty_cells_y = (uint8_t *) malloc((num_tails+1)*sizeof(uint8_t));
    uint8_t empty_cells_y[MAX_NUM_TAILS];
    int num_empty = 0;
    // iterate over game board
    if (num_tails == 0)
    {
        fruit_x = rand() % GAME_COLS;
        fruit_y = rand() % GAME_ROWS;
        return;
    }

    for (int x = 0; x < GAME_COLS; x++)
    {
        for (int y = 0; y < GAME_ROWS; y++)
        {
            // check if x value is not occupied
            int is_occupied = 0;
            for (int tails = 0; tails < num_tails; tails++)
            {
                // contains a tail                
                if(x == tails_x[tails] && y == tails_y[tails]) 
                {
                    // add empty cell to empty cell 
                    is_occupied = 1;
                    break; //  no need to check rest
                }

                // contains a head
                
            }

            if (x == snake_head_x && y == snake_head_y)
            {
                is_occupied = 1;
            }

            if(!is_occupied)
            {
                empty_cells_x[num_empty] = x;
                empty_cells_y[num_empty] = y;
                num_empty++;
            }
            
        }
    }

    // get random from empty cell array
    int random_x = rand() % num_empty;
    int random_y = rand() % num_empty;
    fruit_x = empty_cells_x[random_x];
    fruit_y = empty_cells_y[random_y];
    printf("num_empty = %d\n", num_empty);
    printf("random x,y %d, %d\n", random_x, random_y);
    

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
            dir = STOP;
            break;
        default:
            game_over = 1;
            break;
    }
}

void game_logic() {
    clear_snake();

    if (got_fruit)
    {
        got_fruit = 0;
        num_tails++;
    }
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
    
    // check boundary conditions
    if (snake_head_x < 0 || snake_head_x >= GAME_COLS || snake_head_y < 0 || snake_head_y >= GAME_ROWS)
        game_over = 1;

    // check if head runs into tails
    for (int i = 0; i < num_tails; i++)
        if (tails_x[i] == snake_head_x && tails_y[i] == snake_head_y)
            game_over = 1;

    // check if head ate fruit
    if (snake_head_x == fruit_x && snake_head_y == fruit_y) {
        got_fruit = 1;
        place_fruit();
        score += 1;
        update_score(score);
    }

    draw_snake();

    return;
}

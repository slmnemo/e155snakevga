#include "snake.h"
#include "main.h"


// sends a write pixel command to the FPGA for rendering
void write_pixel(uint8_t pixel_x, uint8_t pixel_y, color_t color)
{
    // use color command
    spi_command_t command;
    switch(color) {
        case RED: 
        command = WRITE_RED;
        break;

        case GREEN:
        command = WRITE_GREEN;
        break;

        case BLUE:
        command = WRITE_BLUE;
        break;

        case WHITE:
        command = WRITE_WHITE;
        break;

        default:
        command = WRITE_WHITE;
        break;
    }

    // begin SPI transaction
    SPI_BEGIN; // pull CS high
    spiSendReceive((char)command);
    spiSendReceive(pixel_x);
    spiSendReceive(pixel_y);
    SPI_END; // set CS back to low

    return;

}

void clear_pixel(uint8_t pixel_x, uint8_t pixel_y)
{
    return;
}

void write_start_screen()
{
    return;
}

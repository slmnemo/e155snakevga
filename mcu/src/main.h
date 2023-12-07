#ifndef MAIN_H
#define MAIN_H

#include "STM32L432KC.h"
#include "snake.h"

#define SPI_BEGIN digitalWrite(SPI_CS, 1); 
#define SPI_END digitalWrite(SPI_CS, 0);

#define BUTTON_DOWN PA12
#define BUTTON_UP PB7
#define BUTTON_LEFT PB6
#define BUTTON_RIGHT PB0

#define DELAY_TIM_MS TIM2
#define DELAY_TIM_US TIM6


#endif // MAIN_H
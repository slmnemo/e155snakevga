#ifndef MAIN_H
#define MAIN_H

#include "STM32L432KC.h"
#include "snake.h"

#define SPI_BEGIN digitalWrite(SPI_CS, 1); 
#define SPI_END digitalWrite(SPI_CS, 0);



#endif // MAIN_H
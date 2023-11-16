/*********************************************************************
*                    SEGGER Microcontroller GmbH                     *
*                        The Embedded Experts                        *
**********************************************************************

-------------------------- END-OF-HEADER -----------------------------

File    : main.c
Purpose : Generic application start

*/

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include "main.h"

/*********************************************************************
*
*       main()
*
*  Function description
*   Application entry point.
*/
int main(void) {
  // Configure flash latency and set clock to run at 80 MHz
  // configureClock();

  // Enable GPIOA clock
  RCC->AHB2ENR |= (RCC_AHB2ENR_GPIOAEN | RCC_AHB2ENR_GPIOBEN | RCC_AHB2ENR_GPIOCEN);

  // "clock divide" = master clock frequency / desired baud rate
  // the phase for the SPI clock is 1 and the polarity is 0
  initSPI(2, 0, 0);

  // initialize timer
  initTIM(TIM6);
  
  // debugging LEDs
  pinMode(PA9, GPIO_OUTPUT);
  pinMode(PA10, GPIO_OUTPUT);
  digitalWrite(PA9, 0);
  digitalWrite(PA10, 0);

  while(1)
  {
    write_pixel(30, 50, RED);
  }


}

/*************************** End of file ****************************/

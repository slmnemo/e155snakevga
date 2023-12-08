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

const int splash_screen[] =  {2, 3, 4, 5,  7, 11, 14, 15, 16, 17, 18, 21, 24, 26, 27, 28, 29, -1, // Line 0
                              2, 7, 8, 11, 14, 18, 21, 24, 26, -1, //line 1
                              2, 7, 8, 11, 14, 18, 21, 23, 24, 26, -1, // etc
                              3, 4, 5, 7, 9, 11, 14, 15, 16, 17, 18, 21, 22, 23, 26, 27, 28, -1,
                              5, 7, 10, 11, 14, 18, 21, 22, 23, 24, 26, -1,
                              5, 7, 10, 11, 14, 18, 21, 24, 26, -1,
                              2, 3, 4, 5, 7, 11, 14, 18, 21, 24, 26, 27, 28, 29, -1};


direction_t input_dir = STOP;
int score = 0;
int game_over = 0;

void init_interrupts() {
  // enable SYSCFG in RCC
  RCC->APB2ENR |= RCC_APB2ENR_SYSCFGEN;

  // Configure EXTICR
  SYSCFG->EXTICR[0] |= _VAL2FLD(SYSCFG_EXTICR1_EXTI0, 0b001); // PB0
  SYSCFG->EXTICR[1] |= _VAL2FLD(SYSCFG_EXTICR2_EXTI6, 0b001); // PB6
  SYSCFG->EXTICR[1] |= _VAL2FLD(SYSCFG_EXTICR2_EXTI7, 0b001); // PB7
  SYSCFG->EXTICR[3] |= _VAL2FLD(SYSCFG_EXTICR4_EXTI12, 0b000); // PA12

  // Enable interrupts globally
  __enable_irq();

  // Configure mask bits
  EXTI->IMR1 |= _VAL2FLD(EXTI_IMR1_IM0,  1);  // line 0
  EXTI->IMR1 |= _VAL2FLD(EXTI_IMR1_IM6,  1);  // line 6
  EXTI->IMR1 |= _VAL2FLD(EXTI_IMR1_IM7,  1);  // line 7
  EXTI->IMR1 |= _VAL2FLD(EXTI_IMR1_IM12, 1);  // line 12

  // Disable rising edge triggers
  EXTI->RTSR1 |= _VAL2FLD(EXTI_RTSR1_RT0,  0); // line 0
  EXTI->RTSR1 |= _VAL2FLD(EXTI_RTSR1_RT6,  0); // line 6
  EXTI->RTSR1 |= _VAL2FLD(EXTI_RTSR1_RT7,  0); // line 7
  EXTI->RTSR1 |= _VAL2FLD(EXTI_RTSR1_RT12, 0); // line 12

  // Enable falling edge trigger
  EXTI->FTSR1 |= _VAL2FLD(EXTI_FTSR1_FT0,  1); // line 0
  EXTI->FTSR1 |= _VAL2FLD(EXTI_FTSR1_FT6,  1); // line 6
  EXTI->FTSR1 |= _VAL2FLD(EXTI_FTSR1_FT7,  1); // line 7
  EXTI->FTSR1 |= _VAL2FLD(EXTI_FTSR1_FT12, 1); // line 12

  // Turn on EXTI interrupts in NVIC_ISER
  NVIC_EnableIRQ(EXTI0_IRQn);
  NVIC_EnableIRQ(EXTI9_5_IRQn);
  NVIC_EnableIRQ(EXTI15_10_IRQn);

  return;

}

void EXTI0_IRQHandler(void) {
    // Check that the button was what triggered our interrupt
    if (EXTI->PR1 & (1 << 0)) {
        // If so, clear the interrupt (NB: Write 1 to reset.)
        EXTI->PR1 |= (1 << 0);
        
        input_dir = RIGHT;

    }

    return;
}

void EXTI9_5_IRQHandler(void) {
    if (EXTI->PR1 & (1 << 6)) {
        // If so, clear the interrupt (NB: Write 1 to reset.)
        EXTI->PR1 |= (1 << 6);

        input_dir = LEFT;
        

    }

    if (EXTI->PR1 & (1 << 7)) {
        // If so, clear the interrupt (NB: Write 1 to reset.)
        EXTI->PR1 |= (1 << 7);

        input_dir = UP;

    }
    return;
}

void EXTI15_10_IRQHandler(void) {
    // Check that the button was what triggered our interrupt
    if (EXTI->PR1 & (1 << 12)) {
        // If so, clear the interrupt (NB: Write 1 to reset.)
        EXTI->PR1 |= (1 << 12);

        input_dir = DOWN;

    }

    return;
}

/*********************************************************************
*
*       main()
*
*  Function description
*   Application entry point.
*/
int main(void) {

  // Enable GPIOA clock
  RCC->AHB2ENR |= (RCC_AHB2ENR_GPIOAEN | RCC_AHB2ENR_GPIOBEN | RCC_AHB2ENR_GPIOCEN);

  // "clock divide" = master clock frequency / desired baud rate
  // the phase for the SPI clock is 0 and the polarity is 0
  initSPI(0, 0, 0);

  // initialize timer
  RCC->APB1ENR1 |= RCC_APB1ENR1_TIM2EN;
  RCC->APB1ENR1 |= RCC_APB1ENR1_TIM6EN;

  initTIM(DELAY_TIM_MS, 1e3); // give ms delay timing
  initTIM(DELAY_TIM_US, 1e6); // give us delay timing
  
  // button inputs
  pinMode(BUTTON_DOWN, GPIO_INPUT);
  pinMode(BUTTON_UP, GPIO_INPUT);
  pinMode(BUTTON_RIGHT, GPIO_INPUT);
  pinMode(BUTTON_LEFT, GPIO_INPUT);

  // enable pullups
  GPIOA->PUPDR |= _VAL2FLD(GPIO_PUPDR_PUPD12, 0b01); // Set PA12 as pull-up
  GPIOB->PUPDR |= _VAL2FLD(GPIO_PUPDR_PUPD7, 0b01); // Set PB7 as pull-up
  GPIOB->PUPDR |= _VAL2FLD(GPIO_PUPDR_PUPD6, 0b01); // Set PB6 as pull-up
  GPIOB->PUPDR |= _VAL2FLD(GPIO_PUPDR_PUPD0, 0b01); // Set PB0 as pull-up
  init_interrupts();

  while(1)
  {
    clear_screen();
    write_splash_screen(splash_screen);
    input_dir = STOP;
    while(input_dir == STOP); // wait for user input

    clear_screen();
    write_border(WHITE);
    init_game();

    while(!game_over) {
      input(input_dir);
      game_logic();
      delay_millis(DELAY_TIM_MS, 150);
    }
    // game is over
    input_dir = STOP;
    write_border(RED);
    while(input_dir == STOP); // wait for user input
    score = 0;
    

  }
}

/*************************** End of file ****************************/

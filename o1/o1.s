.thumb
.syntax unified

.include "gpio_constants.s"

.text
	.global Start
	
Start:
    ldr r0, =GPIO_BASE + (PORT_SIZE * LED_PORT)  // 0x40006000 + ( 36 * 4 )
    ldr r4, =GPIO_BASE + PORT_SIZE               // 0x40006000 + 36 (BUTTON_PORT = 1)

    ldr r1, =GPIO_PORT_DOUTCLR  // 20
    ldr r2, =GPIO_PORT_DOUTSET  // 16
    ldr r3, =GPIO_PORT_DIN      // 38

    add r1, r0, r1  // Clear
    add r2, r0, r2  // Set
    add r3, r4, r3  // Data input

    // As we want the pins below we shift a 1 to the index of LED_PIN and BUTTON_PIN (Think of the microcontroller)
    // lsl can also be used to acheive this, alternatively write out the address manually, ie: mov r0, 0b100
    mov r0, #1 << LED_PIN     // LED_PIN = 2,    so we get 0100
    mov r4, #1 << BUTTON_PIN  // BUTTON_PIN = 9, so we get 0001 0000 0000

Loop:
    ldr r5, [r3]    // load data input value on r5 from r3
    and r5, r4, r5  // we want to know what the input r4 is when btn0 is pressed, r4 and r5 is this value
    cmp r5, r4      // compare to determain whether pushed or not, if pushed r4 will be the value of r5
    beq On          // jump to On if cmp true

    str r0, [r2]    // str set on LED, turns off
    B Loop          // restarts loops (Branch to Loop)

On:
    str r0, [r1]    // str clear on LED, turns on
    B Loop          // restarts loop

NOP
# File:   Makefile
# Author: M. P. Hayes, UCECE -- Edited by G Lamont and L Brewster
# Date:   12 Sep 2010
# Descr:  Makefile for game

# Definitions.
CC = avr-gcc
CFLAGS = -mmcu=atmega32u2 -Os -Wall -std=c99 -Wstrict-prototypes -Wextra -g -I. -I../../utils -I../../fonts -I../../drivers -I../../drivers/avr
OBJCOPY = avr-objcopy
SIZE = avr-size
DEL = rm


# Default target.
all: game.out


# Compile: create object files from C source files.
game.o: game.c ../../drivers/avr/system.h ../../assignment/team317/pongBall.h ../../assignment/team317/pongPaddle.h ../../assignment/team317/ledController.h ../../drivers/navswitch.h ../../drivers/avr/pio.h ../../utils/tinygl.h ../../utils/pacer.h ../../utils/font.h
	$(CC) -c $(CFLAGS) $< -o $@

ledMat.o: ledMat.c ../../drivers/avr/system.h ../../drivers/avr/pio.h
	$(CC) -c $(CFLAGS) $< -o $@

pongBall.o: pongBall.c ../../drivers/avr/system.h ../../drivers/avr/pio.h ../../utils/pacer.h ../../assignment/team317/ledMat.h ../../assignment/team317/pongPaddle.h
	$(CC) -c $(CFLAGS) $< -o $@

pongPaddle.o: pongPaddle.c ../../drivers/avr/system.h ../../drivers/avr/pio.h ../../utils/pacer.h ../../assignment/team317/ledMat.h
	$(CC) -c $(CFLAGS) $< -o $@

ledController.o: ledController.c ../../drivers/avr/system.h ../../drivers/avr/pio.h ../../assignment/team317/pongPaddle.h ../../assignment/team317/ledMat.h
	$(CC) -c $(CFLAGS) $< -o $@

pongDataSharing.o: pongDataSharing.c ../../drivers/avr/system.h ../../assignment/team317/pongPaddle.h ../../assignment/team317/pongBall.h ../../drivers/avr/ir_uart.h ../../assignment/team317/ledController.h

pio.o: ../../drivers/avr/pio.c ../../drivers/avr/pio.h ../../drivers/avr/system.h
	$(CC) -c $(CFLAGS) $< -o $@

system.o: ../../drivers/avr/system.c ../../drivers/avr/system.h
	$(CC) -c $(CFLAGS) $< -o $@

timer.o: ../../drivers/avr/timer.c ../../drivers/avr/system.h ../../drivers/avr/timer.h
	$(CC) -c $(CFLAGS) $< -o $@

display.o: ../../drivers/display.c ../../drivers/avr/system.h ../../drivers/display.h ../../drivers/ledmat.h
	$(CC) -c $(CFLAGS) $< -o $@

ledmat.o: ../../drivers/ledmat.c ../../drivers/avr/pio.h ../../drivers/avr/system.h ../../drivers/ledmat.h
	$(CC) -c $(CFLAGS) $< -o $@

navswitch.o: ../../drivers/navswitch.c ../../drivers/avr/delay.h ../../drivers/avr/pio.h ../../drivers/avr/system.h ../../drivers/navswitch.h
	$(CC) -c $(CFLAGS) $< -o $@

font.o: ../../utils/font.c ../../drivers/avr/system.h ../../utils/font.h
	$(CC) -c $(CFLAGS) $< -o $@

pacer.o: ../../utils/pacer.c ../../drivers/avr/system.h ../../drivers/avr/timer.h ../../utils/pacer.h
	$(CC) -c $(CFLAGS) $< -o $@

tinygl.o: ../../utils/tinygl.c ../../drivers/avr/system.h ../../drivers/display.h ../../utils/font.h ../../utils/tinygl.h
	$(CC) -c $(CFLAGS) $< -o $@

ir_uart.o: ../../drivers/avr/ir_uart.c ../../drivers/avr/ir_uart.h ../../drivers/avr/pio.h ../../drivers/avr/system.h ../../drivers/avr/timer0.h ../../drivers/avr/usart1.h
	$(CC) -c $(CFLAGS) $< -o $@

usart1.o: ../../drivers/avr/usart1.c ../../drivers/avr/system.h ../../drivers/avr/usart1.h
	$(CC) -c $(CFLAGS) $< -o $@


timer0.o: ../../drivers/avr/timer0.c ../../drivers/avr/bits.h ../../drivers/avr/prescale.h ../../drivers/avr/system.h ../../drivers/avr/timer0.h
	$(CC) -c $(CFLAGS) $< -o $@

prescale.o: ../../drivers/avr/prescale.c ../../drivers/avr/prescale.h ../../drivers/avr/system.h
	$(CC) -c $(CFLAGS) $< -o $@

# Link: create ELF output file from object files.
game.out: game.o pongBall.o pongPaddle.o ledController.o pio.o system.o display.o ledmat.o navswitch.o font.o pacer.o tinygl.o ir_uart.o usart1.o timer.o timer0.o prescale.o ledMat.o pongDataSharing.o
	$(CC) $(CFLAGS) $^ -o $@ -lm
	$(SIZE) $@


# Target: clean project.
.PHONY: clean
clean:
	-$(DEL) *.o *.out *.hex


# Target: program project.
.PHONY: program
program: game.out
	$(OBJCOPY) -O ihex game.out game.hex
	dfu-programmer atmega32u2 erase; dfu-programmer atmega32u2 flash game.hex; dfu-programmer atmega32u2 start


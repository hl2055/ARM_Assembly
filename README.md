ARM Assembly on MCB1700B board with LPC1768 microcontroller. μVision, developed by Keil ( manufacturer of the board) was used to write / debug the code and run it on the board or run the simulations.

This repository contains all the labs that me and my partner Abhiraam Kananathalingam did in the course ECE 222 - Digital Computers.

-------------------------------------------------------------------------------------------------------------------------
Lab 0:
-------------------------------------------------------------------------------------------------------------------------
Objective:
----------
We will familiarize ourselves with the basics of the ARM boards used in the ECE-222 lab. Here is a
short list of what we will do in this session: 
- Introduction to ARM board
- Introduction to µVision4 software
  o How to create or open a project
  o How to build, or assemble, a target
  o How to download object code into memory on the target board 
  o How to debug code 
  o How to use the simulator 

-------------------------------------------------------------------------------------------------------------------------
Lab 1 : Flashing LED
-------------------------------------------------------------------------------------------------------------------------
Objective:
The objective of this lab is to complete, assemble and download a simple assembly language 
program. Here is a short list of what you will do in this session: 
- Write some THUMB assembly language instructions
- Use different memory addressing modes 
- Test and debug the code on the Keil board
Flash an LED (Light Emitting Diode) at an approximate 1 Hz frequency. 

-------------------------------------------------------------------------------------------------------------------------
Lab 2: Subroutines and parameter passing 
-------------------------------------------------------------------------------------------------------------------------
Objective:
In structured programming, big tasks are broken into small routines. A short program is written for 
each routine. The main program brings the subroutines together by calling them.
In most cases when a subroutine is called, some information, parameters, must be communicated 
between the main program and the subroutine. This is called parameter passing. 
In this lab, you will practice subroutine calling and parameter passing by implementing a Morse 
code system. 

What you do:
In this lab you will turn one LED into a Morse code transmitter. You will cause one LED to blink in
Morse code for a four character word.

-------------------------------------------------------------------------------------------------------------------------
Lab 3: Input/Output Interfacing 
-------------------------------------------------------------------------------------------------------------------------
Objective:
The objective of this lab is to learn how to use peripherals connected to a microprocessor. The 
ARM CPU is connected to the outside world using Ports and in this lab you will setup, and use,
Input and Output ports.

What you do:
In this lab you will measure how fast a user responds to an event accurate to a 10th of a 
millisecond. Initially all LEDs are off and after a random amount of time (between 2 to 10 
seconds), one LED turns on and then the user presses the push button. 
Between ‘Turning the LED on’ and ‘Pressing the push button’, a 32 bit counter is incremented
every 10th of a millisecond in a loop. The final value of this 32 bit number should be sent to the 8 
LEDs in separate bytes with a 2 second delay between them. 

-------------------------------------------------------------------------------------------------------------------------
Lab 4: Interrupt Handling
-------------------------------------------------------------------------------------------------------------------------
Objective:
The objective of this lab is to learn about interrupts. You will enable an interrupt source in the
LPC1768 microprocessor, and you will write an interrupt service routine (ISR) that is triggered 
when pressing the INT0 button. The ISR will return to the main program after handling the
interrupt. 

What to do:
The objectives for Lab-4 are achieved by implementing a program similar to the program for Lab-3, 
except using interrupt-drive I/O instead of programmed I/O.





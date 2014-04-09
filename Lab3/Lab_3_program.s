; ECE-222 Lab ... Winter 2013 term*
; Puneet GIll				(p24gill)
; Abhiraam Kananathaligam	(akananat)
; November 13, 2013
; Lab 3 sample code 
				THUMB 		; Thumb instruction set 
                AREA 		My_code, CODE, READONLY
                EXPORT 		__MAIN
				ENTRY  
__MAIN

; The following lines are similar to Lab-1 but use a defined address to make it easier.
; They just turn off all LEDs 
				LDR			R10, =LED_BASE_ADR		; R10 is a permenant pointer to the base address for the LEDs, offset of 0x20 and 0x40 for the ports

				MOV 		R3, #0xB0000000		; Turn off three LEDs on port 1  
				STR 		R3, [r10, #0x20]
				MOV 		R3, #0x0000007C
				STR 		R3, [R10, #0x40] 	; Turn off five LEDs on port 2 
				
				LDR 		R10,=LED_BASE_ADR  ;prepare the push button for a read
				MOV 		R6, #0x00 
				STRB		R6, [R10,#0x41]  ;P2.10 = 0 initiates it for input 
				


; This line is very important in your main program
; Initializes R11 to a 16-bit non-zero value and NOTHING else can write to R11 !!
				MOV			R11, #0xABCD		; Init the random number generator with a non-zero number
loop 			BL 			RandomNum 			;32-bit random number is in R11
				MOV         R0, #0x0			;reset value of delay counter
				
				MOV 		R3, #0xB0000000		; Turn off three LEDs on port 1  
				STR 		R3, [r10, #0x20]
				MOV 		R3, #0x0000007C
				STR 		R3, [R10, #0x40] 	; Turn off five LEDs on port 2 
				
				MOV			R8, #0x64			;value of 100
				MOV         R12,#0x7A			;value of 122
				BFI 		R0, R11, #0, #16	; Replace bit 0 to bit 15 (16 bits) of R0 with
												; bit 0 to bit 15 from R11(random number)
				
				MUL			R0,R12				;R0 will range from 0-6.5 seconds therefore we multiply by 1.2
				UDIV		R0,R8				;so it ranges from 0-8 seconds
				
				MOV			R0, #0x2710			;REMOVE !!!!!!!!!!!!!!!!!!
				
				BL DELAY						;generates a loop from 0 to 8 seconds
				
				MOV			R3,#0xDFFFFFFF		;turns on P1.29 after the random delay set above ;REMOVE REMOVE!
				STR 		R3, [R10, #0x20]	;REMOVMOEMORMOMVORMOEMOVMOERM!!!
				MOV 		R0,#0x4E20			;generates a loop of 2 seconds because we unable to add 20,000 to R0 (above)
				BL DELAY
				
				
				
				MOV			R4,#0x0				;resets our 32-bit counter (reaction time counter)
				
IncrementingLOOP
				MOV 	R0,#0x1 				;creates the 0.1 milliseconds delay
				BL DELAY
				ADD			R4,#0x1
				
				MOV 		R6, #0x00 
				STRB		R6, [R10,#0x41]  	;P2.10 = 0 initiates it for input 
				LDR R9,=FIO2PIN  				;FIO2PIN is used to read P2[31:0] 
				LDR R6,[R9]          			;R6[10] contains the input 
	
				ANDS	   R7,R6, #0x0400
				BNE IncrementingLOOP
								  
				MOV			R3,#0xFFFFFFFF
				STR 		R3, [R10, #0x20]  	;TURNS OFF ALL LIGHTS
				
				BL DISPLAY_NUM
				
				B loop


; Display the number in R3 onto the 8 LEDs
DISPLAY_NUM		STMFD		R13!,{R1, R2, R14}
loopDisplaySTART MOV        R3,R4
loopDisplay		MOV			R0,#0x0
				MOV			R1,#0x0
				MOV			R2,#0x0
				MOV			R5,#0x0

				BFI 		R5, R3, #0, #8 			; Replace bit 0 to bit 7 (8 bits) of R5 with
													; bit 0 to bit 7 from R3

				BFI 		R2, R5, #0, #5 			;P2 ORDER: 2,3,4,5,6. Take the first 5 bits and store it in R2
				
				LSR 		R5, R5, #5				;shifting the 5 bits that are put into R2
				BFI 		R1, R5, #0, #3 			;P1 ORDER: 28,29,31. Take the MSB 3 bits and store it in R1
				
				
				RBIT 		R1, R1 					; Reverse the order of bits in R1 (P1 ORDER: 31,29,28)
				RBIT 		R2, R2 					; Reverse the order of the bits in R2 (P2 ORDER: 6,5,4,3,2,1)
				
				LSR 		R1, R1, #1 				; Shift R1 bits to the right by 1 bit (31st bit is now at 30th bit location)
				LSR 		R2, R2, #25  			; Shift R2 bits to the right by 26 bits 
				
				ADD 		R1,#0x40000000			; ADDS 1 to the 30th bit to brings the ("31st" bit to the 31st location)
											
				EOR 		R1,#0xFFFFFFFF			;0 becomes 1 and 1 becomes 0:	Register for Port 1 is complete
				EOR 		R2,#0xFFFFFFFF			;0 becomes 1 and 1 becomes 0:	Register for Port 2 complete
				
				STR 		R1, [r10, #0x20]
				STR 		R2, [R10, #0x40]
				
								  
				MOV 		R0,#0x00004E20 			;change the delay to random number 
				BL DELAY
				LSR 		R3, R3, #8    			;shifting the counter by 8 bits after the bits are taken
				TEQ 		R3,#0x0					;CHECK IF THERE IS A POINT IN DISPLAYING THE REST OF THE BITS
				BNE loopDisplay
				;AFTER SHOWING 32 BITS
				
				MOV 	 	R1,#0x32 				;run the loop (fiveSecondWait) below 50 times     
				
				MOV 		R6, #0x00 
fiveSecondWait  
				MOV R6, #0x00 
				STRB R6, [R10,#0x41]  				;Tells button to get ready for read
				
				MOV 		R0,#0x000003E8			;Set R0 to 1,000, to get a 0.1 second delay		
				BL DELAY							;Branch to delay
				
				LDR R9,=FIO2PIN  					;FIO2PIN is used to read P2[31:0] 
				LDR R6,[R9]           				;R6[10] contains the input 
				ANDS	   R7,R6, #0x0400
				
				BEQ exitDisplay						;If the button is pressed, go to "exitDisplay"  (0)=button is pressed (1)=button is not pressed
				
				SUBS R1,#0x1						;Subtract 1 from the counter  
				BGT fiveSecondWait				
				B loopDisplaySTART					;the 5 second delay is complete, and no button has been pressed
													;redisplay the 32-bit number
				
exitDisplay		LDMFD		R13!,{R1, R2, R15}

;
; R11 holds a 16-bit random number via a pseudo-random sequence as per the Linear feedback shift register (Fibonacci) on WikiPedia
; R11 holds a non-zero 16-bit number.  If a zero is fed in the pseudo-random sequence will stay stuck at 0
; Take as many bits of R11 as you need.  If you take the lowest 4 bits then you get a number between 1 and 15.
;   If you take bits 5..1 you'll get a number between 0 and 15 (assuming you right shift by 1 bit).
;
; R11 MUST be initialized to a non-zero 16-bit value at the start of the program OR ELSE!
; R11 can be read anywhere in the code but must only be written to by this subroutine
RandomNum		STMFD		R13!,{R1, R2, R3, R14}

				AND			R1, R11, #0x8000
				AND			R2, R11, #0x2000
				LSL			R2, #2
				EOR			R3, R1, R2
				AND			R1, R11, #0x1000
				LSL			R1, #3
				EOR			R3, R3, R1
				AND			R1, R11, #0x0400
				LSL			R1, #5
				EOR			R3, R3, R1				; the new bit to go into the LSB is present
				LSR			R3, #15
				LSL			R11, #1
				ORR			R11, R11, R3
				
				LDMFD		R13!,{R1, R2, R3, R15}

;
;		Delay 0.1ms (100us) * R0 times
DELAY			STMFD		R13!,{R2, R14}
OUTERDELAY
				TEQ R0,#0x0
				BEQ exitDelay
				
				MOV  R2,#0x007D					; R2 is counter for the 100us delay    CHANGE BACK TO 7D
				MOVT R2,#0x0000
MULTIPLEDELAY
				SUBS R2,#1
				BNE MULTIPLEDELAY
				
				SUBS R0,#1
				BNE OUTERDELAY
				
exitDelay		LDMFD		R13!,{R2, R15}

				

LED_BASE_ADR	EQU 	0x2009c000 					; Base address of the memory that controls the LEDs 
PINSEL3			EQU 	0x4002c00c 					; Address of Pin Select Register 3 for P1[31:16]
PINSEL4			EQU 	0x4002c010 					; Address of Pin Select Register 4 for P2[15:0]
FIO2PIN 		EQU 	0x2009c054

;	Useful GPIO Registers
;	FIODIR  - register to set individual pins as input or output
;	FIOPIN  - register to read and write pins
;	FIOSET  - register to set I/O pins to 1 by writing a 1
;	FIOCLR  - register to clr I/O pins to 0 by writing a 1

		ALIGN 
	END 

;LAB REPORT
;1)In  8 bits, we can store up to 25.5 ms
;  In 16 bits, we can store up to 6.5535 seconds
;  In 24 bits, we can store up to 1,677.7215 seconds
;  In 32 bits, we can store up to 429,496.7295 seconds
;2) Since the average human reaction time is about 215 ms. We only need to use 16 bits, since anything above that would
;   just be a waste of bits since it is unused.
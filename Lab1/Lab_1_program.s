;*----------------------------------------------------------------------------
;* Name:    Lab_1_program.s 
;* Purpose: This code flashes one LED at approximately 1 Hz frequency 
;* Author: 	Rasoul Keshavarzi 
;*----------------------------------------------------------------------------*/
	THUMB		; Declare THUMB instruction set 
	AREA		My_code, CODE, READONLY 	; 
	EXPORT		__MAIN 		; Label __MAIN is used externally q
	ENTRY 
__MAIN
; The following operations can be done in simpler methods. They are done in this 
; way to practice different memory addressing methods. 
; MOV moves into the lower word (16 bits) and clears the upper word
; MOVT moves into the upper word
; show several ways to create an address using a fixed offset and register as offset
;   and several examples are used below
; NOTE MOV can move ANY 16-bit, and only SOME >16-bit, constants into a register
	MOV 		R2, #0xC000		; move 0xC000 into R2
	MOV 		R4, #0x0		; init R4 register to 0 to build address
	MOVT 		R4, #0x2009		; assign 0x20090000 into R4
	ADD 		R4, R4, R2 		; add 0xC000 to R4 to get 0x2009C000 
	MOV 		R3, #0x0000007C	; move initial value for port P2 into R3              TURNS OFF
	STR 		R3, [R4, #0x40] 	; Turn off five LEDs on port 2 
	MOV 		R3, #0xB0000000	; move initial value for port P1 into R3              TURNS OFF
	STR 		R3, [R4, #0x20]	; Turn off three LEDs on Port 1 using an offset
	MOV 		R2, #0x20		; put Port 1 offset into R2
				
loop
							  ;SETS THE COUNTER, R0
	MOV 		R0, #0xA120   ;assigns 0x0000A120 to R0
	MOVT        R0, #0x0007   ;assigns 0x0007A120 to R0 
							 
							 
							  ; The number inside R0 is 500,000 in decimal, since each instruction takes 1ms, the decrementloop takes 0.5 seconds to run
							  ;therefore LED blinks off and on every 0.5 seconds
decrementloop	
	SUBS 		R0, #1 			; Decrement r0 and set N,Z,V,C status bits in the status register so that BNE can check Z bit
	BNE 		decrementloop   ; Leaves the decrement loop and enters the toggle loop when R0 reaches 0
								; Keeps branching to decrementloop till the Z status bit is 1 (R0=0) then it leaves
	
	EOR         R3, #0x10000000    ; TOGGLES R3 FROM 0xB0000000 to 0xA0000000
	STR 		R3, [R4, R2] 	   ; Depending on what is in R3 it turns OFF or ON the LED
	B 			loop		; INFINITE LOOP
 	END 



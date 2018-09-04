
cpu "8085.tbl"
hof "int8"

				;motor here refers to stepper motor
org 9000h

MVI A,8BH			;sets 8255 of ADC as port A output and B,C as inputs
OUT 43H				


MVI A,80H			;sets 8255 of Motor board as all outputs (Ports A,B,C)
OUT 03H


MVI A,88H 			;stores position of motor , VARIES IN 88 44 22 00
STA 9300H
MVI A,00H     			;stores actual motor postion in hexadecimal
STA 9301H
LOOP:				;infinite loop, constantly samples Analog input
	CALL DISPLAY		;displays converted ADC value on LED of 83 trainer board
	CALL FUNC		;function to move motor shaft in required direction
	CALL DELAY		;delay function to give motor time to react (finite inertia, and recharge, discharge time of motor coils)
	JMP LOOP

FUNC:

	LDA 9301H		;loads present hexadecimal location into B
	MOV B,A
	MVI D,04H		;D stores location of AC input pin location
	MVI E,04H			
	CALL CONVERT		;convert function, same as defined in first.asm (standard function)
	CMP B
	JC LESSFUNC		;if converted position is less than present position (hex) jumps to LESSFUNC
	JZ ENDFUNC		;if equal ends func call
MOREFUNC:			;else calls MOREFUNC
	LDA 9301H
	CPI 0FAH		;max upper bound on voltage, will not allow motor to rotate further than this value
	JC MOREFUNCL1
	JZ MOREFUNCL2
	JMP MOREFUNCL2
MOREFUNCL1:
	LDA 9300H		;if we havent reached max value, we rotate once to the right
	RRC			;and increment present hex value by 3
	OUT 00H
	STA 9300H
	LDA 9301H
	ADI 03H
MOREFUNCL2:STA 9301H
	JMP ENDFUNC
LESSFUNC:			;similar definition as MOREFUNC, however we rotate once to the left
	LDA 9301H		;and decrement present hex value by 3
	CPI 05H
	JC LESSFUNCL2
	JZ LESSFUNCL2
	JMP LESSFUNCL1
LESSFUNCL1:
	LDA 9300H
	RLC
	OUT 00H
	STA 9300H
	LDA 9301H
	SBI 03H
LESSFUNCL2:STA 9301H
ENDFUNC:
	RET



DELAY:				;fixed delay function, gives constant delay of less than 1 second
	MVI C, 0AH
LOOP4a: MVI D, 16H
LOOP1a: MVI E, 0DEH
LOOP2a: DCR E
	JNZ LOOP2a
	DCR D
	JNZ LOOP1a
	DCR C
	JNZ LOOP4a

RET


CONVERT:			;standard convert function 
	MVI A,00H
	ORA D
	OUT 40H

	; START SIGNAL
	MVI A,20H
	ORA D
	OUT 40H
	
	NOP
	NOP
	
	; START PULSE OVER
	MVI A,00H
	ORA D
	OUT 40H

; EOC = PC0
; CHECK FOR EOC PULSE
WAIT1:
	IN 42H
	ANI 01H
	JNZ WAIT1
WAIT2:
	IN 42H
	ANI 01H
	JZ WAIT2

; READ SIGNAL
	MVI A,40H
	ORA D
	OUT 40H
	NOP

	; GET THE CONVERTED DATA FROM PORT B
	IN 41H

	; SAVE A SO THAT WE CAN DEASSERT THE SIGNAL
	PUSH PSW

	; DEASSERT READ SIGNAL 
	MVI A,00H
	ORA D
	OUT 40H
	POP PSW

	RET

DISPLAY:
		call DELAY
		PUSH PSW

		MOV A,E
		STA 8FEFH
		XRA A
		STA 8FF0H
		POP PSW
		STA 8FF1H
		PUSH D
		MVI B,00H
		CALL 0440H
		MVI B,00H
		CALL 0440H
		MVI B,00
		CALL 044CH
		POP D
		RET

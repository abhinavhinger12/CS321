cpu "8085.tbl"
hof "int8"

org 9000h
GTHEX: EQU 030EH
HXDSP: EQU 034FH
OUTPUT:EQU 0389H
CLEAR: EQU 02BEH
RDKBD: EQU 03BAH

CURDT: EQU 8FF1H
UPDDT: EQU 044cH
CURAD: EQU 8FEFH
UPDAD: EQU 0440H

MVI A,00H
MVI B,00H

LXI H,8840H
MVI M,0CH

LXI H,8841H
MVI M,11H

LXI H,8842H
MVI M,00H

LXI H,8843H
MVI M,0CH

LXI H,8840H
CALL OUTPUT
CALL RDKBD
CALL CLEAR


MVI A,00H
MVI B,00H
Call gthex
MOV H,D
MOV L,E

FIRST:
	MOV A,H
	CPI 24H
	JC SECOND
START:
	MVI H,00H
	JC TWENTY_FOUR
SECOND:
	MOV A,L
	CPI 60H
	JC TWENTY_FOUR
THIRD:
	MVI L,00H 	
	

TWENTY_FOUR:
	;LXI H,0000H

HR_MIN:
	SHLD CURAD
	MVI A,59H
NXT_SEC:
	STA CURDT
	MVI A,0BH
	SIM	;Unmask Interrupt RST 7.5
	EI	;Enable Int Flip Flop
	CALL UPDAD
	CALL UPDDT
	CALL DELAY
	LDA CURDT
	DCR A		;ADI 01H
	STA 9200H
	ANI 0FH
	CPI 0FH
	JZ SEC1
SEC2:	LDA 9200H
	CPI 00H
	JNZ NXT_SEC
	LHLD CURAD
	MOV A,L
	DCR A		;ADI 01H
	STA 9200H
	ANI 0FH
	CPI 0FH
	JZ MIN1
MIN2:	LDA 9200H	
	MOV L,A
	CPI 00H
	JNZ HR_MIN
	MVI L,59H
	MOV A,H
	DCR A		;ADI 01H
	STA 9200H
	ANI 0FH
	CPI 0FH
	JZ HR1
HR2:	LDA 9200H	
	MOV H,A
	CPI 00H
	JNZ HR_MIN
	LXI H,0000H
	JMP TWENTY_FOUR
DELAY:
	MVI C,03H
OUTLOOP:
	LXI D,0AF00H
INLOOP:
	DCX D
	MOV A,D
	ORA E
	JNZ INLOOP
	DCR C
	JNZ OUTLOOP
	RET
INTHANDLE:
	PUSH PSW  ;Save the Contents of program
	CALL RDKBD ;Waits for Keyboard input to restart the timer
	POP PSW  	;Replace the contents back
	EI 		;Enable Interrupt
	RET	;Jump Back to the Normal Routine

SEC1:	LDA 9200H
	SBI 06H
	STA 9200H
	JMP SEC2
MIN1:	LDA 9200H
	SBI 06H
	STA 9200H
	JMP MIN2
HR1:	LDA 9200H
	SBI 06H
	STA 9200H
	JMP HR2
	
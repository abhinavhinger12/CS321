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

CHECK_MIN:
	MOV A,L
	CPI 60H
	JC CORRECT_MIN
	MVI L,00H
	JMP CHECK_HR

CORRECT_MIN:
	JMP CHECK_HR

CHECK_HR:
	MOV A,H
	CPI 13H
	JC TWENTY_FOUR

CORRECT_HR:
	CPI 24H
	JC CONVERT_TW
	MVI H,00H
	JMP TWENTY_FOUR

CONVERT_TW:
	SUI 12H
	MOV H,A
MVI A,00H

TWENTY_FOUR:
	;LXI H,0100H

HR_MIN:
	SHLD CURAD
	MVI A,00H
NXT_SEC:
	STA CURDT
	CALL UPDAD
	CALL UPDDT

	MVI A,1BH
	SIM
	EI
	MVI A,0H

	CALL DELAY
	LDA CURDT
	ADI 01H
	DAA
	CPI 60H
	JNZ NXT_SEC
	LHLD CURAD
	MOV A,L
	ADI 01H
	DAA
	MOV L,A
	CPI 60H
	JNZ HR_MIN
	MVI L,00H
	MOV A,H
	ADI 01H
	DAA
	MOV H,A
	JMP TWENTY_FOUR
DELAY:
	MVI C,03H
OUTLOOP:
	LXI D,9FFFH
INLOOP:
	DCX D
	MOV A,D
	ORA E
	JNZ INLOOP
	DCR C
	JNZ OUTLOOP
	RET

org 8fbfh

HLT

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
	MVI A,00H
NXT_SEC:
	STA CURDT
	CALL UPDAD
	CALL UPDDT
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
	CPI 24H
	JNZ HR_MIN
	LXI H,0000H
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
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

LXI H,8840H	;[H] <- 88H and [L] <- 40H
MVI M,0CH

LXI H,8841H
MVI M,11H

LXI H,8842H
MVI M,00H

LXI H,8843H
MVI M,0CH

LXI H,8840H
CALL OUTPUT	;displays CLOC on the address 7segment display
CALL RDKBD	;waits for key board input from the user
CALL CLEAR


MVI A,00H
MVI B,00H
Call gthex
MOV H,D
MOV L,E

FIRST:
	MOV A,H		;move content of H into A
	CPI 24H		;compare content of accumulator with 24H
	JC SECOND
START:
	MVI H,00H
	JC TWENTY_FOUR
SECOND:
	MOV A,L
	CPI 60H		;compare content of accumlator with 60H 
	JC TWENTY_FOUR
THIRD:
	MVI L,00H 	
	

TWENTY_FOUR:
	;LXI H,0000H

HR_MIN:
	SHLD CURAD	; store H-L pair at CURAD memory location
	MVI A,00H
NXT_SEC:
	STA CURDT	; store content of A at CURDT memory location
	CALL UPDAD	;displays content at CURAD memory location on address 7field
	CALL UPDDT	;displays content at CURDT memory location on data field
	CALL DELAY	;calls the delay 
	LDA CURDT
	ADI 01H		;add 01H to the content of A
	DAA		;decimal adjustment of A (0A is converted to 10)
	CPI 60H
	JNZ NXT_SEC	;jump if not zero to NXT_SEC
	LHLD CURAD	;load H-L pair with value at CURAD memory location
	MOV A,L
	ADI 01H
	DAA
	MOV L,A
	CPI 60H
	JNZ HR_MIN	;jump if not zero to HR_MIN
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
	LXI D,0A700H
INLOOP:
	DCX D		; decrease D-E register pair by 1
	MOV A,D
	ORA E		;logical or of contents of A with contents of E
	JNZ INLOOP
	DCR C		;decrease C by 1
	JNZ OUTLOOP
	RET



cpu "8085.tbl"
hof "int8"
org 9000h

MVI A,8BH			;Sets ADC board's 8255 with A as output and B,C as input ports 
OUT 43H

MVI A,80H			;Sets Motor board's 8255 with A,B,C as output ports
OUT 03H


MVI A,88H			;contains orientation of motor as 10001000
LOOP:
PUSH PSW			;saves present contents in stack
OUT 00H				;sends A to motor board via port A of 8255
MVI D,04H			;D contains pin location of analog voltage source that is to be converted (board can have 20 sources)
MVI E,04H
CALL CONVERT			;convert operation, converts Analog to digital (8 bit)
STA 8501H			;stores A in 8501H mm, where A contains converted DC value
MOV B,A
MVI A,0FFH
SUB B				;subtracts A from FF, A,C, and 8500H now contains distance of DC value from FF
MOV C,A				
STA 8500H			
CALL DELAY			;calls delay, a directlry prop. function of C

MVI D,04H			;sets the required values for preventing any modified values from being sent to the next loop
MVI E,04H
MVI A,32H
MVI C,04H
STA 8500H
LDA 8501H

CALL DISPLAY			;display function to update display with converted value(8501H)
POP PSW
RRC				;circular right rotates value in A 
JMP LOOP


DELAY:
	LOOP4a:  MVI D,01H	;runs proportional to C, hence time gap b/w each step is proportional to distance of DC val from FF
	LOOP1a: LDA 8500H  	;implying speed of rotation is directly prop to voltage value
	MOV E, A
	LOOP2a:  DCR E
	    JNZ LOOP2a
	    DCR D
	    JNZ LOOP1a
	    DCR C
	    JNZ LOOP4a
RET



CONVERT:			;convert function
	MVI A,00H		
	ORA D
	OUT 40H			;sends information of pin number to collect Analog value

	MVI A,20H		;Start signal
	ORA D
	OUT 40H
	NOP			;delays the CPU such that start signal will be set and understood by ADC
	NOP
	MVI A,00H		;ends start signal (starts conversion)
	ORA D
	OUT 40H

				; EOC = C0 (c port, C0)
				; CHECK FOR EOC PULSE
WAIT1:
	IN 42H			;does two checks, EOC needs to be low and then needs to be high to imply end of conversion
	ANI 01H			;(else EOC will be read incorrectly)
	JNZ WAIT1
WAIT2:
	IN 42H
	ANI 01H
	JZ WAIT2
				;read signal, along with location of analog signal pin location
	MVI A,40H
	ORA D
	OUT 40H
	NOP
	IN 41H			;gets converted data from port B
	PUSH PSW		;A contains DC value, saved to allow deassertion of read signal
	MVI A,00H		;deassertion of read signal
	ORA D
	OUT 40H
	POP PSW

RET

DISPLAY:			;standard display function, displays value on LED of 8085 board (83 trainer)
		call DELAY
		LDA 8501H
		PUSH PSW

DISPKBD:
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



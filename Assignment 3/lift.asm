cpu "8085.tbl"
hof "int8"

org	9000H

GTHEX: EQU 030EH
OUTPUT: EQU 0389H
HXDSP: EQU 034FH
RDKBD: EQU 03BAH
CLEAR: EQU 02BEH
				;Lift travels in one direction servicing all requests in that direction only.  Changes
				;direction only if there are no requests above the lift.  In all cases lift returns to
				;floor0 (it is assumed all elevator users have a destination as floor0).  Input is taken
				;in from LCI port B using 8 bit dip switch.  In case boss floor request comes, boss request
				;is given top priority and will be serviced first.  All other requests will have to wait
				;until boss reaches floor0.  Once boss request is serviced, elevator returns to normal
				;functioning.  Note that boss floor must be predefined in memory location 8200H before 
				;running the program

LDA 8200H
MOV H,A				;H stores location of boss floor (01H is first,02H is second, 04H is third and so on)
MVI A, 8BH			;sets 8255 to mode 0 with port A as out port and port B as in port
OUT 43H
				;each floor defines one level of the elevator.  By default the elevator starts from floor zero

FLOOR0:
	MVI B,01H		;B is direction of elevator, set to 01H if moving up and 00H if moving down
	MVI A, 00H		;A holds location of elevator, where 00H is floor0, 01H is floor1, 02H is floor2 and so on(not difference with boss floor definition)
	STA 8202H		;8202H stores location of floor from which we jump to the BOSS subroutine
	OUT 40H			;output to A
	CALL DELAY		;Delay of 2 seconds for human visibility of elevator traversal
	IN 41H			;takes input from port B
	ANA H			;Logical AND of contents of accummulator and register H
	CMP H			;If boss has issued request, jumps to BOSS subroutine
	JZ BOSS			;BOSS subroutine jump
	IN 41H
	CPI 00H			;Compares floor value(A) with 0, if true remains at floor 0, sets direction as down
	JZ FLOOR0		
	JMP FLOOR1		;else direction by default is up (01H) and we go to floor 1
FLOOR1:		
	MVI A, 01H		;NOTE: ALL FLOORS AFTER FLOOR1 FOLLOW SAME SYNTAX, FLOOR1 WILL BE DESCRIBES IN GENERAL CONTEXT
	STA 8202H		
	OUT 40H
	CALL DELAY
	IN 41H
	ANI 01H
	CPI 01H
	JZ FLOOR1		;Lock condition, if same floor request exists, we remain at the same floor until same floor request is removed
	IN 41H
	ANA H
	CMP H
	JZ BOSS			;BOSS condition, jumps to boss floor and executes boss request(ignoring all other requests until boss reaches floor zero)
	MOV A,B
	CPI 00H
	JZ FLOOR0		;Floor 0 comparison
	IN 41H
	ANI 0FFH
	CPI 01H
	MVI B,00H
	JC FLOOR0		;Carry generated if A is less than 01H, in which case we travel down to floor0 (the orev floor)
	JZ FLOOR1
	MVI B,01H		;else direction remains 01H and we move up to floor2 (the next floor)
	JMP FLOOR2 
FLOOR2:		
	MVI A, 02H
	STA 8202H
	OUT 40H
	CALL DELAY
	IN 41H
	ANI 02H
	CPI 02H
	JZ FLOOR2
	IN 41H
	ANA H
	CMP H
	JZ BOSS
	MOV A,B
	CPI 00H
	JZ FLOOR1
	IN 41H
	ANI 0FEH
	CPI 02H
	MVI B,00H
	JC FLOOR1
	JZ FLOOR2
	MVI B,01H
	JMP FLOOR3
FLOOR3:
	MVI A, 04H
	STA 8202H
	OUT 40H
	CALL DELAY
	IN 41H
	ANI 04H
	CPI 04H
	JZ FLOOR3
	IN 41H
	ANA H
	CMP H
	JZ BOSS
	MOV A,B
	CPI 00H
	JZ FLOOR2
	IN 41H
	ANI 0FCH
	CPI 04H
	MVI B,00H
	JC FLOOR2
	JZ FLOOR3
	MVI B,01H
	JMP FLOOR4
FLOOR4:
	MVI A, 08H
	STA 8202H
	OUT 40H
	CALL DELAY
	IN 41H
	ANI 08H
	CPI 08H
	JZ FLOOR4
	IN 41H
	ANA H
	CMP H
	JZ BOSS
	MOV A,B
	CPI 00H
	JZ FLOOR3
	IN 41H
	ANI 0F8H
	CPI 08H
	MVI B,00H
	JC FLOOR3
	JZ FLOOR4
	MVI B,01H
	JMP FLOOR5
FLOOR5:
	MVI A, 10H
	STA 8202H
	OUT 40H
	CALL DELAY
	IN 41H
	ANI 10H
	CPI 10H
	JZ FLOOR5
	IN 41H
	ANA H
	CMP H
	JZ BOSS
	MOV A,B
	CPI 00H
	JZ FLOOR4
	IN 41H
	ANI 0F0H
	CPI 10H
	MVI B,00H
	JC FLOOR4
	JZ FLOOR5
	MVI B,01H
	JMP FLOOR6
FLOOR6:
	MVI A, 20H
	STA 8202H
	OUT 40H
	CALL DELAY
	IN 41H
	ANI 20H
	CPI 20H
	JZ FLOOR6
	IN 41H
	ANA H
	CMP H
	JZ BOSS
	MOV A,B
	CPI 00H
	JZ FLOOR5
	IN 41H
	ANI 0E0H
	CPI 20H
	MVI B,00H
	JC FLOOR5
	JZ FLOOR6
	MVI B,01H
	JMP FLOOR7
FLOOR7:
	MVI A, 40H
	STA 8202H
	OUT 40H
	CALL DELAY
	IN 41H
	ANI 40H
	CPI 40H
	JZ FLOOR7
	IN 41H
	ANA H
	CMP H
	JZ BOSS
	MOV A,B
	CPI 00H
	JZ FLOOR6
	IN 41H
	ANI 0C0H
	CPI 40H
	MVI B,00H
	JC FLOOR6
	JZ FLOOR7
	MVI B,01H
	MVI B,01H
	JMP FLOOR8
FLOOR8:	
	MVI B, 00H
	MVI A, 80H
	STA 8202H
	OUT 40H
	CALL DELAY
	IN 41H
	ANI 80H
	CPI 80H
	JZ FLOOR8
	IN 41H
	ANA H
	CMP H
	JZ BOSS
	IN 41H
	ANI 080H
	CPI 80H
	JC FLOOR7
	JZ FLOOR8
DELAY:				;generates approx. 2 second delay in code operation
	MVI C,06H
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
BOSS:				;BOSS subroutine
	LDA 8202H
	CMP H			;Compares BOSS floor with current floor(8202H memory location)
	JC HIGHBOSS		;If boss floor is higher than present location, goes to HIGHBOSS subroutine
	JZ WAIT			;If boss is at same floor jumps to WAIT subroutine
	JMP LOWBOSS		;If boss floor is lower than present floror, jumps to LOWBOSS subroutine
HIGHBOSS:
	LDA 8202H		;changes elevator position to boss position(incrementing) A, then jumps to WAIT
	CPI 00H
	JZ INCREMENT		;ensures A has a 1 bit somewhere in its 8 bits (highboss can be called from floor0 as well)
	RLC			;logical left circular shift of accumulator(A)
	STA 8202H
RETURN:	OUT 40H
	CALL DELAY
	LDA 8202H
	CMP H
	JC HIGHBOSS
	JZ WAIT
LOWBOSS:			;changes elevator position to boss position(decrementing) A, then jumps to WAIT
	LDA 8202H
	RRC
	STA 8202H
	OUT 40H
	CALL DELAY
	LDA 8202H
	CMP H
	JZ WAIT
	JMP LOWBOSS 	
WAIT:				;waits for boss floor request to go low, then goes to TOZERO subroutine
	IN 41H
	ANA H
	CMP H	
	JZ WAIT
	CALL DELAY
TOZERO:				;Takes elevator with boss in it to ground floor (floor0)
	LDA 8202H
	RRC			;logical right shift of A (circular)
	STA 8202H
	OUT 40H
	CALL DELAY
	LDA 8202H
	CPI 01H
	JZ FLOOR0		;Jumps to floor0 subroutine after boss reaches floor0
	JMP TOZERO
INCREMENT:			;INCREMENTS location 8202H (for HIGHBOSS call from floor0)
	ADI 01H
	STA 8202H
	JMP RETURN
	
	
	
	

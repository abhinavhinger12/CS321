cpu "8085.tbl"
hof "int8"		;NOTE: Repeating opcodes may not be explained in every section, refer ADD section for such opcodes description
org 9000h 

LDA 81FFH		;loads accumulator with value stored in address 81FF (hexadecimal)
CPI 01H			;compares accumulator with value 01
JZ ADD			;if zero, jump to label "ADD" (zero returned if compared numbers are equal)

CPI 02H			;compares accumulator with value 02
JZ SUB 			

CPI 03H
JZ MULT

CPI 04H
JZ DIV

ADD:			;"ADD" label
MVI C,00H     		;stores 01 in register C
LHLD 8200H    		;loads values in address location 8200 into H and 8201 into L (uses HL register pair)
XCHG          		;exchanges value in HL with DE
LHLD 8202H    		;loads values in address location 8202 into H and 8203 into L
DAD D         		;increments DE register pair
JNC LABELA		;checks carry generated from previous instruction, if no carry jumps to "LABELA"
INR C         		;increments C(defined carry register)
LABELA: SHLD 8204H 	;stores values in H into address 8204 and value in L into 8205
MOV A,C      		;moves contents of register C into A
STA 8206H   		;stores A(Accumulator)'s contents into address location 8206
RST 5			;end program statement

SUB:
MVI C,00H    		;loads C with 00
MVI B,00H    
LHLD 8200H    		;loads H and L with values in addresses 8200 and 8201 respectively
XCHG			
LHLD 8202H		;DE contains value from which value in HL need to be subtracted
MOV A,E
SUB L			;subtracts L from A
JNC LABELS1		;borrow generated is treated as carry
INR C
LABELS1: MOV E,A
MOV A,D
SUB C			;subtracts C(borrow/carry) from MSB byte (D)
SUB H			
JNC LABELS2
INR B
LABELS2: MOV D,A
XCHG
MOV A,B
CPI 01H			;compares A(Accumulator) with 01
JNZ LABEL5		
MOV A,L
CMA			;if A is 01 generates 2's complement of result
MOV L,A 
MOV A,H
CMA 
MOV H,A
INX H

LABEL5:
SHLD 8206H
MOV A,B
STA 8208H
RST 5

MULT:
LHLD 8200H
SPHL			;stack pointer used (16 bit) to store first HL pair
LHLD 8202H
XCHG
LXI H,0000H
LXI B,0000H
NEXT: DAD SP		;increments stack pointer as register pair
JNC LOOPM
INX B			;carry generated stored in B
LOOPM: DCX D		;decrements DE register pair
MOV A,E
ORA D			;Checks if DE register pair is zero (takes logical OR of D and E and compares with 0)
JNZ NEXT
SHLD 8204H
MOV L,C
MOV H,B
SHLD 8206H
RST 5

DIV:
LXI B,0000H
LHLD 8202H
XCHG
LHLD 8204H
LOOP2: MOV A,L
SUB E
MOV L,A
MOV A,H
SBB D			;subtracts D from A and borrow generated from subtracting E from L
MOV H,A
JC LOOP1		;if carry generated from subtracting D and borrow from H jump to "LOOP1"
INX B
JMP LOOP2
LOOP1: DAD D		;increments HL with DE register pair
SHLD 8206H
MOV L,C
MOV H,B
SHLD 8208H
RST 5
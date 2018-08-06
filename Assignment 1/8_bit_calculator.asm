cpu "8085.tbl"
hof "int8" 	;NOTE: Repeating opcodes may not be explained in every section, refer ADD section
org 9000h 

LDA 81FFH	;loads accumulator with value stored in address 81FF (hexadecimal)
CPI 01H		;compares accumulator with value 01
JZ ADD		;if zero, jump to label "ADD" (zero returned if compared numbers are equal)

CPI 02H		;compares accumulator with value 02
JZ SUB 

CPI 03H		;compares accumulator with value 03
JZ MULT

CPI 04H		;compares accumulator with value 04
JZ DIV  

ADD:
mvi c,00h	;loads C with 00
lda 8200h	;load value from address location 8200 in a(accumulator)
mov b,a		;move contents of a to register b
lda 8201h	;load value from address location 8201 in a(accumulator)
add b		;[a] <- [a] + [b]
jnc labelA	;jump if not carry to labelA
inr c		;increment register c(Carry Register) by 1
labelA:
sta 8202h	;store a's content in memory loction 8202
mov a,c		;move content of register c in a
sta 8203h	 
rst 5		;end program statement

SUB:
mvi c,00h	;loads C with 00
lda 8201h
mov b,a
lda 8200h
sub b		;[a] <- [a] - [b]
jnc labelB	;jump if not carry to labelB
cma		;compliment the content of a(accumulator) 
inr a		;adding one to a (cma and inr a together used for 2's compliment)
inr c
labelB: sta 8202h
mov a,c
sta 8203h
rst 5

MULT:
MVI C,00H
LDA 8200H
MOV B,A
LDA 8201H
MOV D,A
MVI A,00H	;load A with 00
LABELM1: ADD B	;[A] <- [A] + [B]	
JNC LABELM2
INR C
LABELM2: DCR D	;decrease the content of register D by one
JNZ LABELM1	;repeated addition
STA 8202H	
MOV A,C
STA 8203H
RST 5

DIV:
MVI C,00H
LDA 8200H
MOV B,A
LDA 8201H
LABELD: CMP B	;compare the content of register B with A(if equal zero flag is set)
JC L1		;jump if carry
SUB B
INR C
JMP LABELD	;repeated substraction
L1: STA 8202H
MOV A,C
STA 8203H
RST 5		;end program statement

cpu "8085.tbl"
hof "int8"
org 9000h 

LDA 81FFH
CPI 01H
JZ ADD

CPI 02H
JZ SUB 

CPI 03H
JZ MULT

CPI 04H
JZ DIV  

ADD:
mvi c,00h
lda 8200h
mov b,a
lda 8201h
add b
jnc labelA
inr c
labelA:
sta 8202h
mov a,c
sta 8203h
rst 5

SUB:
mvi c,00h
lda 8201h
mov b,a
lda 8200h
sub b
jnc labelB
cma
inr a
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
MVI A,00H
LABELM1: ADD B
JNC LABELM2
INR C
LABELM2: DCR D
JNZ LABELM1
STA 8202H
MOV A,C
STA 8203H
RST 5

DIV:
MVI C,00H
LDA 8200H
MOV B,A
LDA 8201H
LABELD: CMP B
JC L1
SUB B
INR C
JMP LABELD
L1: STA 8202H
MOV A,C
STA 8203H
RST 5
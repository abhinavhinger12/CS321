cpu "8085.tbl"
hof "int8"

org 9000h
;<Program title>


jmp start

stop_watch: nop ;Interrupt Service Routine

	call loopin


loopin: nop

	lda 9300h
	jmp loopin

stopwatch: nop ;Stopwatch routine

	mvi a,00h
	sta 9290h
	mvi a,00h
	sta 9291h
	mvi a,00h
	sta 9292h
	call loop3
	ret


DELAY: nop ;Delay service routine

	MVI C, 0AH
	LOOP:  MVI D, 64H
	LOOP1:      MVI E, 0DAH
	LOOP2:      DCR E
	JNZ LOOP2
	DCR D
	JNZ LOOP1
	DCR C
	JNZ LOOP
	RET


change_time: nop ;Update time on reaching 12 hour

	mvi a,00h
	sta 9292h
	ret


change_hr: nop ; update time on reaching 60 minutes

	lda 9292h
	inr a
	daa
	sta 9292h
	lda 9292h
	cpi 12h
	cz change_time
	mvi a,00h
	sta 9291h
	ret

change_min: nop ;update time on reaching 60 seconds

	mvi a,00h
	sta 9290h
	lda 9291h
	inr a
	daa
	sta 9291h
	lda 9291h
	cpi 60h
	cz change_hr
	ret

displ: nop ;Display the time on LEDs usnig UPDDT and UPDDA

	lda 9290h
	sta 8ff1h
	lda 9291h
	sta 8fefh
	lda 9292h
	sta 8ff0h
	mvi b, 01h
	CALL 044CH
	call 0440H
	ret


loop3: nop ;Routine for Clock

	call displ
	call delay
	lda 9290h
	inr a
	daa
	sta 9290h
	lda 9290h
	cpi 60h
	cz change_min
	jmp loop3
	RET

check_code: nop ;Call the routine (Clock OR Stopwatch) based the value stored in 9925h

	lda 9295h
	cpi 01h
	cz loop3
	lda 9295h
	cpi 02h
	cz stopwatch
	ret

start: nop

	mvi a,0Bh
	SIM
	EI
	mvi a,0c3h
	sta 8fbfh
	mvi a,03h
	sta 8fc0h
	mvi a,90h
	sta 8fc1h
	mvi a,00h
	sta 9300h
	call check_code
	rst 3

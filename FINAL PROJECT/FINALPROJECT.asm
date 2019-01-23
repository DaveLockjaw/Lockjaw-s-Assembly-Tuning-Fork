; FINAL PROJECT // ASSEMBLY TUNING FORK
; David Mann Jr
; CSI 370-01
; REFERENCED https://codereview.stackexchange.com/questions/87322/a-virtual-piano AND https://stackoverflow.com/questions/44081355/input-output-in-x64-assembly FOR CODE SYNTAX
; TO HELP ME COMPLETE THIS PROGRAM AND FIGURE OUT THE WINDOWS API. GIVING CREDIT TO THOSE PROGRAMMERS.

extrn ExitProcess : proc					; WINDOWS API FUNCTION PROTOTYPES
extrn Beep : proc
extrn GetStdHandle : proc
extrn WriteConsoleA : proc
extrn ReadConsoleA : proc

.DATA
beepA QWORD 440			; Limit of 37 to 32,767 / Represents the frequency in hertz
beepAs QWORD 466		; FREQUENCY TONE VARIABLES FOR EVERY NOTE IN THE CHROMATIC SCALE
beepBb QWORD 466
beepB QWORD 494
beepC QWORD 523
beepCs QWORD 554
beepDb QWORD 554
beepD QWORD 587
beepDs QWORD 622
beepEb QWORD 622
beepE QWORD 659
beepF QWORD 698
beepFs QWORD 740
beepGb QWORD 740
beepG QWORD 784
beepGs QWORD 831
beepAb QWORD 831
beepdur QWORD 5000		; This is in milliseconds

instruction BYTE "WELCOME TO MY ASSEMBLY TUNING FORK!!!! Please enter a note letter (Enter q to quit at any time): ",0		;INSTRUCTION AND UI STRINGS
instruction2 BYTE "Please enter another note letter (Enter q to quit at any time): ",0
sharpOrFlat BYTE "IS THE NOTE NATURAL, SHARP, OR FLAT? (ENTER n, #, or b): ",0
playingTone BYTE "***PLAYING TONE*** -------------",0
sharp BYTE "IS THE NOTE NATURAL OR SHARP (ENTER n or #): ",0
flat BYTE "IS THE NOTE NATURAL OR FLAT (ENTER n or b): ",0
thankYouMessage BYTE "THANK YOU FOR USING MY ASSEMBLY TUNING FORK!",0

tuningNote QWORD ?							; variables for function data
sharpOrFlatNote QWORD ?
charsWritten QWORD 0

.CODE
_main PROC

	sub rsp, 10h							; reserve for return and rbp
	sub rsp, 8h								; reserve for parameters
	sub rsp, 20h							; reserve shadow space for regs

	mov  ecx, -11							; STD_OUTPUT_HANDLE
	call GetStdHandle

	mov  rcx, rax							; handle was returned in RAX
	lea  rdx, OFFSET instruction	
	mov  r8, 97
	lea  r9, charsWritten
	mov  QWORD PTR [rsp+20h], 0
	call WriteConsoleA						;USED WRITECONSOLEA AND READCONSOLEA FROM THE WINDOWS API TO USE THE CONSOLE FOR I/O
		
	keyboardLoop:
		call read_character					;MAIN LOOP
		loop keyboardLoop					;ALLOWS THIS PROGRAM TO GO ON FOREVER UNTIL q IS ENTERED

	read_character:
		mov  ecx, -10						; STD_INPUT_HANDLE
		call GetStdHandle

		mov  rcx, rax						; handle was returned in RAX
		lea  rdx, tuningNote
		mov  r8, 1
		lea  r9, charsWritten
		mov  QWORD PTR [rsp+20h], 0
		call ReadConsoleA					;ReadConsoleA

		cmp tuningNote, "a"					;CMPS USED TO "ROUTE" TO THE CORRECT TONE
		je aSharpFlat						;THE NOTE ENTERED CORRESPONDS TO THE CORRECT FREQUENCY IN THE WINDOWS API BEEP TONE

		cmp tuningNote, "b"
		je bSharpFlat

		cmp tuningNote, "c"
		je cSharpFlat

		cmp tuningNote, "d"
		je dSharpFlat

		cmp tuningNote, "e"
		je eSharpFlat

		cmp tuningNote, "f"
		je fSharpFlat

		cmp tuningNote, "g"
		je gSharpFlat

		cmp tuningNote, "q"
		je quitProgram

		ret

	aSharpFlat:								; STATEMENTS USED TO PROMPT FOR THE SHARP AND FLAT VARIATIONS OF THE NOTES // THERE'S ONE FOR EACH NOTE IN THE CHROMATIC SCALE
		mov  ecx, -11						; STD_OUTPUT_HANDLE
		call GetStdHandle

		mov  rcx, rax						; handle was returned in RAX
		lea  rdx, OFFSET sharpOrFlat
		mov  r8, 57
		lea  r9, charsWritten
		mov  QWORD PTR [rsp+20h], 0
		call WriteConsoleA

		call aCharacter

	aCharacter:
		mov  ecx, -10						; STD_INPUT_HANDLE
		call GetStdHandle
		
		mov  rcx, rax						; handle was returned in RAX
		lea  rdx, sharpOrFlatNote
		mov  r8, 1
		lea  r9, charsWritten
		mov  QWORD PTR [rsp+20h], 0
		call ReadConsoleA
		
		cmp sharpOrFlatNote, "n"			;  THE TONE PLAYED DEPENDS ON WHAT SYMBOL THE USER INPUTS, n FOR NATURAL, # FOR SHARP, b FOR FLAT
		je aNote
		cmp sharpOrFlatNote, "#"
		je aSharp
		cmp sharpOrFlatNote, "b"
		je aFlat
		cmp sharpOrFlatNote, "q"
		je quitProgram

		jmp aCharacter						; jmps back to the beginning of the statement if something else is entered

	bSharpFlat:
		mov  ecx, -11						; STD_OUTPUT_HANDLE
		call GetStdHandle

		mov  rcx, rax						; handle was returned in RAX
		lea  rdx, OFFSET flat
		mov  r8, 45
		lea  r9, charsWritten
		mov  QWORD PTR [rsp+20h], 0
		call WriteConsoleA

		call bCharacter

	bCharacter:
		mov  ecx, -10						; STD_INPUT_HANDLE
		call GetStdHandle
		
		mov  rcx, rax						; handle was returned in RAX
		lea  rdx, sharpOrFlatNote
		mov  r8, 1
		lea  r9, charsWritten
		mov  QWORD PTR [rsp+20h], 0
		call ReadConsoleA
		
		cmp sharpOrFlatNote, "n"
		je bNote
		cmp sharpOrFlatNote, "b"
		je bFlat
		cmp sharpOrFlatNote, "q"
		je quitProgram

		jmp bCharacter

	cSharpFlat:
		mov  ecx, -11						; STD_OUTPUT_HANDLE
		call GetStdHandle

		mov  rcx, rax						; handle was returned in RAX
		lea  rdx, OFFSET sharp
		mov  r8, 45
		lea  r9, charsWritten
		mov  QWORD PTR [rsp+20h], 0
		call WriteConsoleA

		call cCharacter

	cCharacter:
		mov  ecx, -10						; STD_INPUT_HANDLE
		call GetStdHandle
		
		mov  rcx, rax						; handle was returned in RAX
		lea  rdx, sharpOrFlatNote
		mov  r8, 1
		lea  r9, charsWritten
		mov  QWORD PTR [rsp+20h], 0
		call ReadConsoleA
		
		cmp sharpOrFlatNote, "n"
		je cNote
		cmp sharpOrFlatNote, "#"
		je cSharp
		cmp sharpOrFlatNote, "q"
		je quitProgram

		jmp cCharacter

	dSharpFlat:
		mov  ecx, -11						; STD_OUTPUT_HANDLE
		call GetStdHandle

		mov  rcx, rax						; handle was returned in RAX
		lea  rdx, OFFSET sharpOrFlat
		mov  r8, 57
		lea  r9, charsWritten
		mov  QWORD PTR [rsp+20h], 0
		call WriteConsoleA

		call dCharacter

	dCharacter:
		mov  ecx, -10						; STD_INPUT_HANDLE
		call GetStdHandle
		
		mov  rcx, rax						; handle was returned in RAX
		lea  rdx, sharpOrFlatNote
		mov  r8, 1
		lea  r9, charsWritten
		mov  QWORD PTR [rsp+20h], 0
		call ReadConsoleA
		
		cmp sharpOrFlatNote, "n"
		je dNote
		cmp sharpOrFlatNote, "#"
		je dSharp
		cmp sharpOrFlatNote, "b"
		je dFlat
		cmp sharpOrFlatNote, "q"
		je quitProgram

		jmp dCharacter

	eSharpFlat:
		mov  ecx, -11						; STD_OUTPUT_HANDLE
		call GetStdHandle

		mov  rcx, rax						; handle was returned in RAX
		lea  rdx, OFFSET flat
		mov  r8, 45
		lea  r9, charsWritten
		mov  QWORD PTR [rsp+20h], 0
		call WriteConsoleA

		call eCharacter

	eCharacter:
		mov  ecx, -10						; STD_INPUT_HANDLE
		call GetStdHandle
		
		mov  rcx, rax						; handle was returned in RAX
		lea  rdx, sharpOrFlatNote
		mov  r8, 1
		lea  r9, charsWritten
		mov  QWORD PTR [rsp+20h], 0
		call ReadConsoleA
		
		cmp sharpOrFlatNote, "n"
		je eNote
		cmp sharpOrFlatNote, "b"
		je eFlat
		cmp sharpOrFlatNote, "q"
		je quitProgram

		jmp eCharacter

	fSharpFlat:
		mov  ecx, -11						; STD_OUTPUT_HANDLE
		call GetStdHandle

		mov  rcx, rax						; handle was returned in RAX
		lea  rdx, OFFSET sharp
		mov  r8, 45
		lea  r9, charsWritten
		mov  QWORD PTR [rsp+20h], 0
		call WriteConsoleA

		call fCharacter

	fCharacter:
		mov  ecx, -10						; STD_INPUT_HANDLE
		call GetStdHandle
		
		mov  rcx, rax						; handle was returned in RAX
		lea  rdx, sharpOrFlatNote
		mov  r8, 1
		lea  r9, charsWritten
		mov  QWORD PTR [rsp+20h], 0
		call ReadConsoleA
		
		cmp sharpOrFlatNote, "n"
		je fNote
		cmp sharpOrFlatNote, "#"
		je fSharp
		cmp sharpOrFlatNote, "q"
		je quitProgram

		jmp fCharacter

	gSharpFlat:
		mov  ecx, -11						; STD_OUTPUT_HANDLE
		call GetStdHandle

		mov  rcx, rax						; handle was returned in RAX
		lea  rdx, OFFSET sharpOrFlat
		mov  r8, 57
		lea  r9, charsWritten
		mov  QWORD PTR [rsp+20h], 0
		call WriteConsoleA

		call gCharacter

	gCharacter:
		mov  ecx, -10						; STD_INPUT_HANDLE
		call GetStdHandle
		
		mov  rcx, rax						; handle was returned in RAX
		lea  rdx, sharpOrFlatNote
		mov  r8, 1
		lea  r9, charsWritten
		mov  QWORD PTR [rsp+20h], 0
		call ReadConsoleA
		
		cmp sharpOrFlatNote, "n"
		je gNote
		cmp sharpOrFlatNote, "#"
		je gSharp
		cmp sharpOrFlatNote, "b"
		je gFlat
		cmp sharpOrFlatNote, "q"
		je quitProgram

		jmp gCharacter


	aNote:									; WHEN THE USER ENTERS A SPECIFIC NOTE, THE TONE FREQUENCY THAT CORRELATES IS PLAYED OUT OF THE SPEAKERS
		mov  ecx, -11						; STD_OUTPUT_HANDLE
		call GetStdHandle

		mov  rcx, rax						; handle was returned in RAX
		lea  rdx, OFFSET playingTone
		mov  r8, 33
		lea  r9, charsWritten
		mov  QWORD PTR [rsp+20h], 0
		call WriteConsoleA

		mov rcx, beepA						; beep duration
		mov rdx, beepdur					; beep frequency
		call Beep ;call it
		jmp endTuner

	aSharp:
		mov  ecx, -11						; STD_OUTPUT_HANDLE
		call GetStdHandle

		mov  rcx, rax						; handle was returned in RAX
		lea  rdx, OFFSET playingTone
		mov  r8, 33
		lea  r9, charsWritten
		mov  QWORD PTR [rsp+20h], 0
		call WriteConsoleA

		mov rcx, beepAs						; beep duration
		mov rdx, beepdur					; beep frequency
		call Beep ;call it
		jmp endTuner

	aFlat:
		mov  ecx, -11						; STD_OUTPUT_HANDLE
		call GetStdHandle

		mov  rcx, rax						; handle was returned in RAX
		lea  rdx, OFFSET playingTone
		mov  r8, 33
		lea  r9, charsWritten
		mov  QWORD PTR [rsp+20h], 0
		call WriteConsoleA

		mov rcx, beepAb						; beep duration
		mov rdx, beepdur					; beep frequency
		call Beep ;call it
		jmp endTuner

	bFlat:
		mov  ecx, -11						; STD_OUTPUT_HANDLE
		call GetStdHandle

		mov  rcx, rax						; handle was returned in RAX
		lea  rdx, OFFSET playingTone
		mov  r8, 33
		lea  r9, charsWritten
		mov  QWORD PTR [rsp+20h], 0
		call WriteConsoleA
		
		mov rcx, beepBb						; beep duration
		mov rdx, beepdur					; beep frequency
		call Beep ;call it
		jmp endTuner

	bNote:
		mov  ecx, -11						; STD_OUTPUT_HANDLE
		call GetStdHandle

		mov  rcx, rax						; handle was returned in RAX
		lea  rdx, OFFSET playingTone
		mov  r8, 33
		lea  r9, charsWritten
		mov  QWORD PTR [rsp+20h], 0
		call WriteConsoleA
		
		mov rcx, beepB						; beep duration
		mov rdx, beepdur					; beep frequency
		call Beep ;call it
		jmp endTuner

	cNote:
		mov  ecx, -11						; STD_OUTPUT_HANDLE
		call GetStdHandle

		mov  rcx, rax						; handle was returned in RAX
		lea  rdx, OFFSET playingTone
		mov  r8, 33
		lea  r9, charsWritten
		mov  QWORD PTR [rsp+20h], 0
		call WriteConsoleA

		mov rcx, beepC						; beep duration
		mov rdx, beepdur					; beep frequency
		call Beep ;call it
		jmp endTuner

	cSharp:
		mov  ecx, -11						; STD_OUTPUT_HANDLE
		call GetStdHandle

		mov  rcx, rax						; handle was returned in RAX
		lea  rdx, OFFSET playingTone
		mov  r8, 33
		lea  r9, charsWritten
		mov  QWORD PTR [rsp+20h], 0
		call WriteConsoleA

		mov rcx, beepCs						; beep duration
		mov rdx, beepdur					; beep frequency
		call Beep ;call it
		jmp endTuner

	dFlat:
		mov  ecx, -11						; STD_OUTPUT_HANDLE
		call GetStdHandle

		mov  rcx, rax						; handle was returned in RAX
		lea  rdx, OFFSET playingTone
		mov  r8, 33
		lea  r9, charsWritten
		mov  QWORD PTR [rsp+20h], 0
		call WriteConsoleA

		mov rcx, beepDb						; beep duration
		mov rdx, beepdur					; beep frequency
		call Beep ;call it
		jmp endTuner

	dNote:
		mov  ecx, -11						; STD_OUTPUT_HANDLE
		call GetStdHandle

		mov  rcx, rax						; handle was returned in RAX
		lea  rdx, OFFSET playingTone
		mov  r8, 33
		lea  r9, charsWritten
		mov  QWORD PTR [rsp+20h], 0
		call WriteConsoleA

		mov rcx, beepD						; beep duration
		mov rdx, beepdur					; beep frequency
		call Beep ;call it
		jmp endTuner

	dSharp:
		mov  ecx, -11						; STD_OUTPUT_HANDLE
		call GetStdHandle

		mov  rcx, rax						; handle was returned in RAX
		lea  rdx, OFFSET playingTone
		mov  r8, 33
		lea  r9, charsWritten
		mov  QWORD PTR [rsp+20h], 0
		call WriteConsoleA

		mov rcx, beepDs						; beep duration
		mov rdx, beepdur					; beep frequency
		call Beep ;call it
		jmp endTuner


	eFlat:
		mov  ecx, -11						; STD_OUTPUT_HANDLE
		call GetStdHandle

		mov  rcx, rax						; handle was returned in RAX
		lea  rdx, OFFSET playingTone
		mov  r8, 33
		lea  r9, charsWritten
		mov  QWORD PTR [rsp+20h], 0
		call WriteConsoleA

		mov rcx, beepEb						; beep duration
		mov rdx, beepdur					; beep frequency
		call Beep ;call it
		jmp endTuner

	eNote:
		mov  ecx, -11						; STD_OUTPUT_HANDLE
		call GetStdHandle

		mov  rcx, rax						; handle was returned in RAX
		lea  rdx, OFFSET playingTone
		mov  r8, 33
		lea  r9, charsWritten
		mov  QWORD PTR [rsp+20h], 0
		call WriteConsoleA

		mov rcx, beepE						; beep duration
		mov rdx, beepdur					; beep frequency
		call Beep ;call it
		jmp endTuner

	fNote:
		mov  ecx, -11						; STD_OUTPUT_HANDLE
		call GetStdHandle

		mov  rcx, rax						; handle was returned in RAX
		lea  rdx, OFFSET playingTone
		mov  r8, 33
		lea  r9, charsWritten
		mov  QWORD PTR [rsp+20h], 0
		call WriteConsoleA

		mov rcx, beepF						; beep duration
		mov rdx, beepdur					; beep frequency
		call Beep ;call it
		jmp endTuner

	fSharp:
		mov  ecx, -11						; STD_OUTPUT_HANDLE
		call GetStdHandle

		mov  rcx, rax						; handle was returned in RAX
		lea  rdx, OFFSET playingTone
		mov  r8, 33
		lea  r9, charsWritten
		mov  QWORD PTR [rsp+20h], 0
		call WriteConsoleA

		mov rcx, beepFs						; beep duration
		mov rdx, beepdur					; beep frequency
		call Beep ;call it
		jmp endTuner

	gFlat:
		mov  ecx, -11						; STD_OUTPUT_HANDLE
		call GetStdHandle

		mov  rcx, rax						; handle was returned in RAX
		lea  rdx, OFFSET playingTone
		mov  r8, 33
		lea  r9, charsWritten
		mov  QWORD PTR [rsp+20h], 0
		call WriteConsoleA

		mov rcx, beepGb						; beep duration
		mov rdx, beepdur					; beep frequency
		call Beep ;call it
		jmp endTuner

	gNote:
		mov  ecx, -11						; STD_OUTPUT_HANDLE
		call GetStdHandle

		mov  rcx, rax						; handle was returned in RAX
		lea  rdx, OFFSET playingTone
		mov  r8, 33
		lea  r9, charsWritten
		mov  QWORD PTR [rsp+20h], 0
		call WriteConsoleA

		mov rcx, beepG						; beep duration
		mov rdx, beepdur					; beep frequency
		call Beep ;call it
		jmp endTuner

	gSharp:
		mov  ecx, -11						; STD_OUTPUT_HANDLE
		call GetStdHandle

		mov  rcx, rax						; handle was returned in RAX
		lea  rdx, OFFSET playingTone
		mov  r8, 33
		lea  r9, charsWritten
		mov  QWORD PTR [rsp+20h], 0
		call WriteConsoleA

		mov rcx, beepGs						; beep duration
		mov rdx, beepdur					; beep frequency
		call Beep ;call it
		jmp endTuner

	endTuner:								; SHOWS A MESSAGE TO ENTER ANOTHER NOTE
		mov  ecx, -11						; STD_OUTPUT_HANDLE
		call GetStdHandle

		mov  rcx, rax						; handle was returned in RAX
		lea  rdx, OFFSET instruction2
		mov  r8, 64
		lea  r9, charsWritten
		mov  QWORD PTR [rsp+20h], 0
		call WriteConsoleA

		jmp keyboardLoop

	quitProgram:							; QUITS PROGRAM AND SHOWS A THANK YOU MESSAGE 
		mov  ecx, -11						; STD_OUTPUT_HANDLE
		call GetStdHandle
		
		mov  rcx, rax						; handle was returned in RAX
		lea  rdx, OFFSET thankYouMessage
		mov  r8, 45
		lea  r9, charsWritten
		mov  QWORD PTR [rsp+20h], 0
		call WriteConsoleA

	mov rcx, 0								; return value
	call ExitProcess						; exit

_main ENDP
END
; TRY using Immediate addressing as much as possible

; Control/Values for the I/O
		.EQU KBD_CNTL,  	$000
		.EQU KBD_STAT,  	$000
		.EQU KBD_DATA,  	$001
		.EQU KBD_FLUSH, 	$40
		.EQU TIM_CNTL,      	$030
		.EQU TIM_STAT,      	$030
		.EQU TIM_VALUE,     	$031
		.EQU TIM_COUNT,     	$034
         
		.EQU INTERRUPT_ENA,           $80
		.EQU RESET_READY_BIT,         $40
		.EQU START_AFTER_LOAD,        $10
		.EQU ENABLE_RESET_AND_START,  $D0
		.EQU ENABLE_AND_RESET,        $C0

		.EQU CRT_BUFFER,    	$100
		.EQU BOTTOM_RIGHT,  	$313
		.EQU CRT_XREG,      	$314
		.EQU CRT_YREG,      	$315
		.EQU CRT_CNTL,      	$316
		.EQU CRT_DATA,      	$317
		.EQU CRT_ROWS,      	$0E
		.EQU CRT_COLS,      	$26
          		.EQU CLEAR_DISPLAY, 	$01
		.EQU HOME,		$04

		.EQU PUT_NUM,       	$E00      ; MINI_OS JSRS
		.EQU GET_NUM,       	$E01
		.EQU PUT_STR,       	$E05
		.EQU PUT_NL,        	$E06
		.EQU PUT_NUM2,      	$E07
		.EQU PUT_CHR,       	$E08

		.EQU MAX_MAN_Y,	11
		.EQU QUIT,		'x'
		.EQU VERTICLE_LINE,	'|'
		;.EQU HORIZONTAL_LINE,	'-'
		.EQU BALL_CHR,		'*'
		.EQU NONE,		15
		.EQU TOP,		0
		.EQU BOTTOM, 		13
		.EQU LEFT, 		0
		.EQU RIGHT, 		37
		.EQU RIGHT_UP, 		3
		.EQU RIGHT_LEFT, 	4
		.EQU RIGHT_RIGHT, 	5
		.EQU RIGHT_DOWN, 	2
		.EQU PLAY_DELAY, 	1 ; # of timer iterations before ball moves
		.EQU WINNER_DELAY,	10; # of timer iterations while winner shown




; input and Output Data to Screen | MINI_OS
;.EQU PUT_NUM,       	$E00      ;symbol link to MINI_OS to Display the NUm
;.EQU GET_NUM,       	$E01 ; Get Num from User
;.EQU PUT_STR,       	$E05 ; Display the str to the Screen
;.EQU PUT_NL,        	$E06 ;OUTPUT NEWLINE TO SCREEEN


;.EQU BADGUY_CHAR,	'*' ; * to represent the bad guy
;.EQU QUIT, 'x' ; press x to quit the game
;.EQU NONE, 15 ; USed to show if PACMAN destroyed or not!

		LDS# $E00
		CIE
		PSH#	XPOS
		PSH#	YPOS
		JSR	START
		ADS#	2
		LDA#	KEYISR
		STA 	$FF8
		LDA#	ENABLE_AND_RESET
		OUTB 	KBD_CNTL
		SIE
		JMP MAINLOOP
; Start of the Stack
;Output the Map to Console
	.EQU STARTX, 3
	.EQU STARTY, 2
START:     BGN#	0  
	PSH# SCORELEN 
           PSH# SCORE
           JSR  PUT_STR ;output string to console
           ADS# 2
           PSH# LEVELLEN
           PSH# LEVEL
           JSR  PUT_STR ;output string to console
           ADS# 2 ; restore the STACK 
           JSR PUT_NL
           PSH# TOP_Horizontal_LineLEN
           PSH# Horizontal_Line
           JSR  PUT_STR ;output string to console
           ADS# 2
	LDA#	0
	STA* ! STARTX
	LDA#	2
	STA* ! STARTY
	PSH#	STARTX - 3
	PSH#	STARTY
	PSH# '>'
	JSR Show50Man
	ADS#	3
	FIN#	0
	RTN
	


MAINLOOP:  NOP
           JMP MAINLOOP
           

;USING KEY TO MOVE PACMAN #
KEYISR:  	PSHA
	lda#	0
	outb	KBD_CNTL
	INB 	KBD_DATA
	CMA#	'x'
	JNE	KEY1
	HLT		
KEY1:	cma#	$1B	; escape so cursor?
	jne	Keydone	; jump if not escape
	inb	kbd_data	; read second escaped key
	cma#	$4D	; if up cursor
	jeq	MoveR
	cma#	$4B
	jeq  MoveL
	cma# $48
	jeq 	MoveU
	cma#	$50
	jeq MoveD
	jmp Keydone
MoveR:	;load some flag to show the function whether its up,down,left,right
	LDA#	3
	jmp Call
MoveL:	LDA#	4
	jmp Call
MoveU:	LDA#	1
	jmp Call
MoveD:	LDA#	2
Call:	psha
	psh#	YPOS
	psh#	XPOS
	jsr	move50Man
	ads#	3
Keydone:	lda#	INTERRUPT_ENA
	outb	KBD_CNTL
	POPA
	IRTN

;MOVING PACMAN FUNCTION || void movePaddle(char key, int *y, int *x)
            .EQU	 JASPER, 4
	.EQU	moveY, 3
	.EQU	moveX, 2
move50Man:    bgn#	0
	STA	JASPER
	psha
	pshx
	psh* !	moveX
	psh* !	moveY
	psh#	' '
	jsr	show50Man
	ads#	3
	LDA	JASPER
	cma#	3
	JEQ	manRight
	cma# 4
	JEQ 	manLeft
	cma#	1
	JEQ  manUp
	cma#	2
	JEQ  manDown
;	cma#	RIGHT_UP
;	jeq	manUp
;	cma#	LEFT_UP
;	jne	manNotUp
manRight:	lda* !	moveX
	cma#	37
	jge  ShowManR
	inc* !	moveX	; can move up
	jmp	showManR
manLeft:    lda* !	moveX
	cma#	0
	jle  showManL
	dec* !	moveX
	jmp ShowManL
manUp:	lda* !	moveY
	cma#	2
	jle	ShowManU
	dec* !	moveY
	jmp ShowManU
manDown:	lda* !	moveY
	cma#	13
	jge 	ShowManD
	inc* !	moveY
	jmp ShowManD	
showManR:	psh* !	moveX
	psh* !	moveY
	psh#	'>'
	jsr	show50Man
	ads#	3
	popa
	popx
	fin#	0
	rtn	; movePaddle()
ShowManL:   psh* !	moveX
	psh* !	moveY
	psh#	'<'
	jsr	show50Man
	ads#	3
	popa
	popx
	fin#	0
	rtn	; movePaddle()
ShowManU:   psh* !	moveX
	psh* !	moveY
	psh#	'^'
	jsr	show50Man
	ads#	3
	popa
	popx
	fin#	0
	rtn	; movePaddle()
ShowManD:   psh* !	moveX
	psh* !	moveY
	psh#	'v'
	jsr	show50Man
	ads#	3
Return:	popa
	popx
	fin#	0
	rtn	; movePaddle()

; void showPaddle(int x, int y, char letter) 
	.EQU	showX, 4
	.EQU	showY, 3
	.EQU	sprite, 2
show50Man:  bgn# 	0
	psha
	pshx
	ldx#	0
showMan1:	psh !	showX
	psh !	showY
	psh !	sprite
	jsr putChar
	ads# 3
	popx
	popa
	fin# 	0
	rtn	; showPaddle()

	.EQU	putCharX, 5
	.EQU	putCharY, 4
	.EQU	putCharC, 3
	.EQU	putCharTemp, 0

putChar:	bgn#	1
	psha
	lda !	putCharY
	mul#	38
	ada !	putCharX
	ada#		CRT_BUFFER
	sta !	putCharTemp
	lda !	putCharC
	outb* !	putCharTemp
	popa
	fin#	1
	rtn


STOP: HLT ; Halt the Program (if All Good)
SCORE: .Char 'Score:                 ', SCORELEN
LEVEL: .CHAR 'Level: ', LEVELLEN
Horizontal_Line: .CHAR '--------------------------------------', TOP_Horizontal_LineLEN
TIMER:	.WORD 	0 ; Keep Count of the timer
DELAY:	.WORD	2000 ;DELAy
BADGUY_SPEED: .WORD 3000
PACMAN_DESTROYED: .WORD NONE ; if pacman is destroyed by intersecting with BADGUY
DESTROYED_MSG: .CHAR 'PACMAN DESTROYED GAME OVER!', DESTROYED_MSG_LEN
XSTART: .WORD
YSTART: .WORD
YPOS: .WORD
XPOS: .WORD
	.EQU @, $FF8
	.WORD KEYISR ;Used to added 2 and treutn the value lat

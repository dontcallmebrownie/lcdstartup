; File: LCDSTARTUP.asm
; 



;/*
;***************************************************************************
; This section to be modified to move away from code written by David Gray 
;***************************************************************************

     PW 128         ;Page Width (# of char/line)
     PL 60          ;Page Length for HP Laser
     INCLIST ON     ;Add Include files in Listing

				;*********************************************
				;Test for Valid Processor defined in -D option
				;*********************************************
	IF	USING_02
	ELSE
		EXIT         "Not Valid Processor: Use -DUSING_02, etc. ! ! ! ! ! ! ! ! ! ! ! !"
	ENDIF




;****************************************************************************
;****************************************************************************
; End of testing for proper Command line Options for Assembly of this program
;****************************************************************************
;****************************************************************************


			title  "W65C02SXB Startup for LCD - LCDSTARTUP.asm"
			sttl
;*/


; bgnpkhdr
;***************************************************************************
;  FILE_NAME: LCDSTARTUP.asm
;
;  DATA_RIGHTS: (C) David Cramer 2024
;				[Modified from code written by David Gray]
;
;
;  TITLE: LCDSTARTUP
;
;  DESCRIPTION: This File describes the WDC65C02sxb Startup program for LCD.
;
;;
;
;***************************************************************************
;endpkhdr

;***************************************************************************
;                               Local Constants
;***************************************************************************
;
	PORTB:		equ 	$7FC0 ; Port and direction Registers
	PORTA:		equ 	$7FC1
	DDRB:		equ 	$7FC2
	DDRA:		equ 	$7FC3

	E: 			equ 	%10000000 ; Enable/RW/RS pins
	RW:			equ 	%01000000
	RS:			equ		%00100000
	
	.sttl "LCDSTARTUP code"
	.page
;***************************************************************************
;***************************************************************************
;                        LCDSTARTUP Code Section
;***************************************************************************
;***************************************************************************
;		CHIP	65C02
;		LONGI	OFF
;		LONGA	OFF
;
;

		.org	$2000
		
DELAY:
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		rts

; CHOUT tells the display to write the char to the screen
CHOUT:
		lda #RS
		jsr DELAY
		sta PORTA

		lda #(RS|E)  ; This needs to be A0
		jsr DELAY
		sta PORTA

		lda #RS
		jsr DELAY
		sta PORTA

		rts

; INSTOGGLE Subroutine tells the display that the instruction is ready to execute
INSTOGGLE: 
		lda #$00
		jsr DELAY
		sta PORTA
		

		lda #E
		jsr DELAY
		sta PORTA
		

		lda #$00
		jsr DELAY
		sta PORTA
		
		rts

START:
		;sei ??
		cld ;??
	
	; Set output pins
		lda #$ff ; %11111111
		sta DDRB

		lda #$e0 ; %11100000
		sta DDRA
	;.
		jsr INIT  ; Init display
		jmp WRITE ; Write phrase

INIT:
	;init display

	; This executes too damn fast for the display

		; Set mode, 2 line, and font
		lda #$38 ; %00111000
		sta PORTB
		jsr INSTOGGLE

		jsr DELAY
		
		; set display on, cursor on, blink off
		lda #$0e ; %00001110
		sta PORTB
		jsr INSTOGGLE

		jsr DELAY

		; set inc on write, dont shift display
		lda #$06 ; %00000110
		sta PORTB
		jsr INSTOGGLE

		jsr DELAY
		
		rts
		;.

WRITE:
	; Write Chars
		lda #"T" ; "T"
		sta PORTB
		jsr CHOUT

		lda #"e" ; "e"
		sta PORTB
		jsr CHOUT

		lda #"s" ; "s"
		sta PORTB
		jsr CHOUT

		lda #"t" ; "t"
		sta PORTB
		jsr CHOUT

		;jmp WRITE
		;.

		brk

;***************************************************************************
; This section to be modified to move away from code written by David Gray
; I don't fully understand this yet, TODO: Fix that! 
;***************************************************************************

IRQHandler:
		pla
		;rti


badVec:		; $FFE0 - IRQRVD2(134)
	php
	pha
	lda #$FF
				;clear Irq
	pla
	plp
	;rti


;***************************************************************************
;***************************************************************************
; New for WDCMON V1.04
;  Needed to move Shadow Vectors into proper area
;***************************************************************************
;***************************************************************************
	SH_vectors:	section
Shadow_VECTORS	SECTION OFFSET $7EFA
					;65C02 Interrupt Vectors
					; Common 8 bit Vectors for all CPUs

		dw	badVec		; $FFFA -  NMIRQ (ALL)
		dw	START		; $FFFC -  RESET (ALL)
		dw	IRQHandler	; $FFFE -  IRQBRK (ALL)

	        ends


;***************************************************************************

vectors	SECTION OFFSET $FFFA
					;65C02 Interrupt Vectors
					; Common 8 bit Vectors for all CPUs

		dw	badVec		; $FFFA -  NMIRQ (ALL)
		dw	START		; $FFFC -  RESET (ALL)
		dw	IRQHandler	; $FFFE -  IRQBRK (ALL)

	        ends

	        end
;*/
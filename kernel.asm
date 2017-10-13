
        processor 6502

        include "vcs.h"

        include "macro.h"

;===============================================================================
; Z P - V A R I A B L E S
;===============================================================================
    SEG.U vars
    ORG $80

SCRATCH_RAM		ds	32	; Reused in several places under different names


; Overlay for Display time
    org SCRATCH_RAM 	; Here we have 32 bytes 
scalePF1 			ds 2
scalePF2 			ds 2
textureDesign 		ds 2
textureHeight 		ds 1
heightStep 			ds 1
texturePos 			ds 1
textureStep 		ds 1
textureBrightness	ds 1


    SEG 
    ORG $F000

TextureDesign	;256B Texture data
; 16 textures, 16 lines each. Each line is 1 byte (D4-D7 Color, D3-0 Slice)
; The bytes are arranged in columns as the counter advances by 16 for each line
	.hex	10	10	00	00	00	00	00	00	10	10	00	00	00	00	00	00
	.hex	20	10	10	00	00	00	00	00	10	10	10	00	00	00	00	00
	.hex	30	10	10  00	00	00	00	00	10	10	10  00	00	00	00	00
	.hex	40	10	10	00	00	00	00	00	10	10	10	00	00	00	00	00
	.hex	50	30	10	00	00	00	00	00	20	30	10	00	00	00	00	00
	.hex	60	30	00	00	00	00	00	00	20	30	00	00	00	00	00	00
	.hex	70	30	30	00	00	00	00	00	20	30	30	00	00	00	00	00
	.hex	80	30	30	00	00	00	00	00	20	30	30	00	00	00	00	00
	.hex	90	50	30	00	00	00	00	00	30	50	30	00	00	00	00	00
	.hex	A0	50	30	00	00	00	00	00	30	50	30	00	00	00	00	00
	.hex	B0	50	30	00	00	00	00	00	30	50	30	00	00	00	00	00
	.hex	C0	50	00	00	00	00	00	00	30	50	00	00	00	00	00	00
	.hex	D0	70	50	00	00	00	00	00	40	70	50	00	00	00	00	00
	.hex	E0	70	50	00	00	00	00	00	40	70	50	00	00	00	00	00
	.hex	F0	70	50	00	00	00	00	00	40	70	50	00	00	00	00	00
	.hex	00	70	50	00	00	00	00	00	40	70	50	00	00	00	00	00
ScalePF1	;256B 16 heights & 16 types (total 8 bits) each has an 8 bit value to scale PF1
	.hex	00	00	00	00	00	00	00	00	00	00	00	00	00	00	00	00	
	.hex	00	00	00	00	00	00	00	00	00	00	00	00	00	00	00	00	
	.hex	00	00	00	00	00	00	00	00	00	00	00	00	00	00	00	00	
	.hex	00	00	00	00	00	00	00	00	00	00	00	00	00	00	00	00	
	.hex	00	00	00	00	00	00	00	00	00	00	00	00	00	00	00	00	
	.hex	00	00	00	00	00	00	00	00	00	00	00	00	00	00	00	00	
	.hex	00	00	00	00	00	00	00	00	00	00	00	00	00	00	00	00	
	.hex	00	00	00	00	00	00	00	00	00	00	00	00	00	00	00	00	
	.hex	01	01	00	00	00	01	00	01	00	00	00	00	00	00	00	00	
	.hex	03	03	00	00	00	03	01	03	00	00	00	00	00	00	00	00	
	.hex	07	07	00	00	00	06	03	07	00	00	00	00	00	00	00	00	
	.hex	0F	0F	00	00	00	0E	07	0f	00	00	00	00	00	00	00	00	
	.hex	1F	1E	01	00	00	1D	0E	1f	00	00	00	00	00	00	00	00	
	.hex	3F	3E	03	00	00	3B	1D	3f	00	00	00	00	00	00	00	00	
	.hex	7F	7C	07	00	00	7B	3D	7f	00	00	00	00	00	00	00	00	
	.hex	FF	F8	0F	01	00	F7	7D	ff	00	00	00	00	00	00	00	00	
ScalePF2	;256B 16 heights & 16 types (total 8 bits) each has an 8 bit value to scale PF2
	.hex	80	40	00	00	00	80	80	c0	00	00	00	00	00	00	00	00	
	.hex	C0	20	80	00	00	40	80	e0	00	00	00	00	00	00	00	00	
	.hex	E0	10	80	00	00	40	80	f0	00	00	00	00	00	00	00	00	
	.hex	F0	18	80	00	00	50	A0	f8	00	00	00	00	00	00	00	00	
	.hex	F8	0C	C0	80	00	54	A8	fc	00	00	00	00	00	00	00	00	
	.hex	FC	06	60	80	00	6A	D4	fe	00	00	00	00	00	00	00	00	
	.hex	FE	07	70	80	00	6D	DA	ff	00	00	00	00	00	00	00	00	
	.hex	FF	03	38	C0	80	6D	DB	ff	00	00	00	00	00	00	00	00	
	.hex	FF	03	38	C0	80	6D	DB	ff	00	00	00	00	00	00	00	00	
	.hex	FF	01	1C	E0	80	76	ED	ff	00	00	00	00	00	00	00	00	
	.hex	FF	01	1E	F0	80	77	EE	ff	00	00	00	00	00	00	00	00	
	.hex	FF	00	0F	78	80	77	EE	ff	00	00	00	00	00	00	00	00	
	.hex	FF	00	07	3C	C0	7B	F7	ff	00	00	00	00	00	00	00	00	
	.hex	FF	00	07	3E	E0	7B	F7	ff	00	00	00	00	00	00	00	00	
	.hex	FF	00	03	1F	F0	7B	F7	ff	00	00	00	00	00	00	00	00	
	.hex	FF	00	01	0F	F8	7D	F7	ff	00	00	00	00	00	00	00	00	


TestZP ;4 bytes per trapeze:
; 1 heightStep (fixed 4.4)
; 2 textureStep (fixed 4.4)
; 3 0000 D4-7, textureDesign D0-3
; 4 textureHeight D4-7 textureBrightness D0-3 
	.hex	10	10	00	0E
	.hex	FD	03	00	F8
	.hex	03	03	00	04

; Kernel requires 12 bytes in ZP that may be reclaimed, and up to 84 bytes of ZP stack


Reset

; *** initialization routine start
	.hex AB 00 ;lax #0
Clear:
	dex
    txs
    pha
    bne Clear
; After the above, X=A=0, and all of RAM and the TIA has been initialized to 0, and the stack pointer is initialized to $FF.
; Also insures "sta WSYNC" is happening in there to make it deterministic
	inx		
	stx CTRLPF	; Enable reflection		

	ldx #11
FillStack:
	lda TestZP,x
	pha
	dex
	bpl FillStack
	lda #>TextureDesign
	sta textureDesign+1
	lda #>ScalePF1
	sta scalePF1+1
	lda #>ScalePF2
	sta scalePF2+1
KernelReset:
	lda #0
	sta PF1
	sta PF2
	lda #192*76/64
	sta TIM64T

NextTexture: ;10
	ldy #0					;2
KernelEntry: 				; Y == texturePos, S == first texture in ZP going up to $ff, TIM64T == 228
	pla						;4
	sta heightStep			;3
	pla						;4
	sta textureStep			;3
	sty texturePos			;3
	sta	WSYNC				;3
	pla						;4
	sta textureDesign		;3
	ldx #$f0				;2
	pla						;4
	sax textureHeight		;3
	and #$0f				;2
	sta textureBrightness	;2 X == textureBrightness
	clc						;2
DrawKernel:
	lax	(textureDesign),y	;5 Y == texturePos, slice D0-3 color D4-7
	ane #$0f				;2 
	sta scalePF1			;3
	sta scalePF2			;3
	lda textureHeight		;3
	adc heightStep			;3 Carry guaranteed to be clear
	sta textureHeight		;3
	and #$f0				;2 A == Height in D4-7, D0-3 0000
	tay						;2
	lda (scalePF2),y		;5
	sta PF2					;3
	lda (scalePF1),y		;5
	sta PF1					;3
	ane #$f0				;2
	ora textureBrightness	;3
	sta COLUPF				;3
StepKernel: 
	bit TIMINT				;4
	bmi KernelExit			;2
	lda texturePos			;3
	clc						;2
	adc textureStep			;3
	bcs NextTexture			;2
	sta texturePos			;3
	and #$f0				;2
	tay						;2 Y == Texture position
	bcc DrawKernel			;3 BRA
KernelExit:
	sta WSYNC
	ldx #2 	
	stx VBLANK
	ldx #30*76/64
	bit INTIM				;3
	bmi NoAdjust			;2/3 In common cases where NextTexture was not called as last step called
	dex						;2
NoAdjust:
	stx TIM64T				;3 Setup timer for VBLANK

Overscan:
	bit TIMINT
	bpl Overscan
	stx VSYNC
	sta WSYNC
	sta WSYNC
	sta WSYNC
	ldx #0
	stx VSYNC
	lda #37*76/64
	sta TIM64T
VSyncBlank:
	bit TIMINT
	bpl VSyncBlank	
	sta WSYNC	
	stx VBLANK
	ldx #$f3
	txs
	jmp KernelReset


	ORG $FFFC 
	.word Reset			; RESET
	.word Reset			; RESET
END
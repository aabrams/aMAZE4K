
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
    org SC_RAM 	; Here we have 32 bytes 


    SEG 
    ORG $F000

TextureColor	;256B Texture data
; 16 textures, 16 lines each. Each line is 1 byte (D4-D7 Color, D3-0 1111)
; The bytes are arranged in columns as the counter advances by 16 for each line
	.hex	1F	1F	0F	0F	0F	0F	0F	0F	1F	1F	0F	0F	0F	0F	0F	0F
	.hex	1F	1F	1F	0F	0F	0F	0F	0F	1F	1F	1F	0F	0F	0F	0F	0F
	.hex	1F	1F	1F  0F	0F	0F	0F	0F	1F	1F	1F  0F	0F	0F	0F	0F
	.hex	1F	1F	1F	0F	0F	0F	0F	0F	1F	1F	1F	0F	0F	0F	0F	0F
	.hex	2F	3F	1F	0F	0F	0F	0F	0F	2F	3F	1F	0F	0F	0F	0F	0F
	.hex	2F	3F	0F	0F	0F	0F	0F	0F	2F	3F	0F	0F	0F	0F	0F	0F
	.hex	2F	3F	3F	0F	0F	0F	0F	0F	2F	3F	3F	0F	0F	0F	0F	0F
	.hex	2F	3F	3F	0F	0F	0F	0F	0F	2F	3F	3F	0F	0F	0F	0F	0F
	.hex	3F	5F	3F	0F	0F	0F	0F	0F	3F	5F	3F	0F	0F	0F	0F	0F
	.hex	3F	5F	3F	0F	0F	0F	0F	0F	3F	5F	3F	0F	0F	0F	0F	0F
	.hex	3F	5F	3F	0F	0F	0F	0F	0F	3F	5F	3F	0F	0F	0F	0F	0F
	.hex	3F	5F	0F	0F	0F	0F	0F	0F	3F	5F	0F	0F	0F	0F	0F	0F
	.hex	4F	7F	5F	0F	0F	0F	0F	0F	4F	7F	5F	0F	0F	0F	0F	0F
	.hex	4F	7F	5F	0F	0F	0F	0F	0F	4F	7F	5F	0F	0F	0F	0F	0F
	.hex	4F	7F	5F	0F	0F	0F	0F	0F	4F	7F	5F	0F	0F	0F	0F	0F
	.hex	4F	7F	5F	0F	0F	0F	0F	0F	4F	7F	5F	0F	0F	0F	0F	0F
TextureSlice	;256B Texture data
; 16 textures, 16 lines each. Each line is 1 byte (D4-D7 0000, D3-0 Slice)
; The bytes are arranged in columns as the counter advances by 16 for each line
	.hex	17	11	08	00	00	00	00	00	17	11	08	00	00	00	00	00
	.hex	17	12	15	00	00	00	00	00	17	12	15	00	00	00	00	00
	.hex	17	13	15  00	00	00	00	00	17	13	15  00	00	00	00	00
	.hex	17	14	15	00	00	00	00	00	17	14	15	00	00	00	00	00
	.hex	27	31	15	00	00	00	00	00	27	31	15	00	00	00	00	00
	.hex	27	32	08	00	00	00	00	00	27	32	08	00	00	00	00	00
	.hex	27	33	36	00	00	00	00	00	27	33	36	00	00	00	00	00
	.hex	27	34	36	00	00	00	00	00	27	34	36	00	00	00	00	00
	.hex	37	51	36	00	00	00	00	00	37	51	36	00	00	00	00	00
	.hex	37	52	36	00	00	00	00	00	37	52	36	00	00	00	00	00
	.hex	37	53	36	00	00	00	00	00	37	53	36	00	00	00	00	00
	.hex	37	54	08	00	00	00	00	00	37	54	08	00	00	00	00	00
	.hex	47	71	55	00	00	00	00	00	47	71	55	00	00	00	00	00
	.hex	47	72	55	00	00	00	00	00	47	72	55	00	00	00	00	00
	.hex	47	73	55	00	00	00	00	00	47	73	55	00	00	00	00	00
	.hex	47	74	55	00	00	00	00	00	47	74	55	00	00	00	00	00
ScalePF1	;256B 16 heights & 16 types (total 8 bits) each has an 8 bit value to scale PF1
	.hex	10	00	00	00	00	00	00	00	00	00	00	00	00	00	00	00	
	.hex	0f	00	00	00	00	00	00	00	00	00	00	00	00	00	00	00	
	.hex	0e	00	00	00	00	00	00	00	00	00	00	00	00	00	00	00	
	.hex	0d	00	00	00	00	00	00	00	00	00	00	00	00	00	00	00	
	.hex	0c	00	00	00	00	00	00	00	00	00	00	00	00	00	00	00	
	.hex	0b	00	00	00	00	00	00	00	00	00	00	00	00	00	00	00	
	.hex	0a	00	00	00	00	00	00	00	00	00	00	00	00	00	00	00	
	.hex	09	00	00	00	00	00	00	00	00	00	00	00	00	00	00	00	
	.hex	08	01	00	00	00	01	00	01	00	00	00	00	00	00	00	00	
	.hex	07	03	00	00	00	03	01	03	00	00	00	00	00	00	00	00	
	.hex	07	07	00	00	00	06	03	07	00	00	00	00	00	00	00	00	
	.hex	05	0F	00	00	00	0E	07	0f	00	00	00	00	00	00	00	00	
	.hex	04	1E	01	00	00	1D	0E	1f	00	00	00	00	00	00	00	00	
	.hex	03	3E	03	00	00	3B	1D	3f	00	00	00	00	00	00	00	00	
	.hex	02	7C	07	00	00	7B	3D	7f	00	00	00	00	00	00	00	00	
	.hex	01	F8	0F	01	00	F7	7D	ff	00	00	00	00	00	00	00	00	
ScalePF2	;256B 16 heights & 16 types (total 8 bits) each has an 8 bit value to scale PF2
	.hex	20	80	00	00	00	00	00	80	00	00	00	00	00	00	00	00	
	.hex	18	40	00	00	00	80	80	c0	00	00	00	00	00	00	00	00	
	.hex	10	20	80	00	00	40	80	e0	00	00	00	00	00	00	00	00	
	.hex	06	10	80	00	00	40	80	f0	00	00	00	00	00	00	00	00	
	.hex	0a	18	80	00	00	50	A0	f8	00	00	00	00	00	00	00	00	
	.hex	0a	0C	C0	80	00	54	A8	fc	00	00	00	00	00	00	00	00	
	.hex	08	06	60	80	00	6A	D4	fe	00	00	00	00	00	00	00	00	
	.hex	08	07	70	80	00	6D	DA	ff	00	00	00	00	00	00	00	00	
	.hex	06	03	38	C0	80	6D	DB	ff	00	00	00	00	00	00	00	00	
	.hex	06	01	1C	E0	80	76	ED	ff	00	00	00	00	00	00	00	00	
	.hex	06	01	1E	F0	80	77	EE	ff	00	00	00	00	00	00	00	00	
	.hex	04	00	0F	78	80	77	EE	ff	00	00	00	00	00	00	00	00	
	.hex	04	00	07	3C	C0	7B	F7	ff	00	00	00	00	00	00	00	00	
	.hex	04	00	07	3E	E0	7B	F7	ff	00	00	00	00	00	00	00	00	
	.hex	04	00	03	1F	F0	7B	F7	ff	00	00	00	00	00	00	00	00	
	.hex	04	00	01	0F	F8	7D	F7	ff	00	00	00	00	00	00	00	00	

TestZP ;4 bytes per trapeze: heightStep (fixed 4.4), textureStep (fixed 4.4), textureDesign D0-3, textureHeight D4-7 textureBrightness D0-3 
	.hex	02	03	00	5F
	.hex	FE	FD	00	FD
	
; Kernel requires 12 bytes in ZP that may be reclaimed, and up to 84 bytes of ZP stack


Reset

; *** initialization routine start
	lax #0
Clear:
	dex
    txs
    pha
    bne Clear
; After the above, X=A=0, and all of RAM and the TIA has been initialized to 0, and the stack pointer is initialized to $FF.
; Also insures "sta WSYNC" is happening in there to make it deterministic
	inx		
	stx CTRLPF	; Enable reflection		

	ldx #7
FillStack:
	lda TestZP,x
	pha
	dex
	bpl FillStack

NextTexture: ;10
	ldy #0					;2
KernelEntry: 				; Y == texturePos, S == first texture in ZP going up to $ff, TIM64T == 228
	sta	WSYNC				;3
	pla						;4
	sta heightStep			;3
	pla						;4
	sta textureStep			;3
	sty texturePos			;3
	pla						;4
	sta textureSlice+1		;3
	sta textureColor+1		;3
	ldx #$f0				;2
	pla						;4
	sax textureHeight		;3
	ora #$f0				;2
	tax						;2 X == textureBrightness

	clc						;2
DrawKernel:
	lda	(textureSlice),y	;5 Y == texturePos, slice D0-3 
	sta scalePF1+1			;3
	sta scalePF2+1			;3
	lda	(textureColor),y	;5 Y == texturePos, color D4-7, D0-3 1111
	sax COLUPF				;3
	lda textureHeight		;3
	adc heightStep			;3 Carry guaranteed to be clear
	sta textureHeight		;3
	and #$f0				;2 A == Height in D4-7, D0-3 0000
	tay						;2
	lda (scalePF2),y		;5
	sta PF2					;3
	lda (scalePF1),y		;5
	sta PF1					;3
StepKernel: 
	lda #2
	bit TIMINT				;3
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
	ldx #29*76/64
	lda #192				;2
	cmp INTIM				;3
	bcs NoAdjust			;2/3 In rare cases where NextTexture was called
	inx						;2
NoAdjust:
	stx TIM64T				;3 Setup timer for VBLANK
Overscan:
	bit TIMINT
	bpl Overscan
	lda #3*76/64
	sta TIM64T
VSync:
	bit TIMINT
	bpl VSync
	lda #37*76/64
VBlank
	bit TIMINT
	bpl VBlank
	ldx #$f9
	txs
	jmp KernelEntry


	ORG $FFFC 
	.word Reset			; RESET
END
; -------------------------------------------
; TBC-LIB
; -------------------------------------------
;
; Assembler: VASM Oldstyle
; Shell Befehle
;   OPT=-mega65                     # enable 45GS02 instructions
;   OPT="$OPT -Lall"                # list all symbol
;   OPT="$OPT -maxerrors=50"
;   OPT="$OPT -chklabels"
;   OPT="$OPT -Fbin -cbm-prg"       # select binary output: write Commodore PRG header
;   vasm6502_oldstyle $OPT -L $1.list $1.asm -o $1.prg
;
;vasm 1.9b (c) in 2002-2022 Volker Barthelmann
;vasm 6502 cpu backend 0.11a (c) 2002,2006,2008-2012,2014-2022 Frank Wille
;vasm oldstyle syntax module 0.17 (c) 2002-2022 Frank Wille
;vasm test output module 1.0 (c) 2002 Volker Barthelmann

; BASIC PROGRAMS START AT $2001
	org $2001

       word LLINK,2023
        byte $DE,$9C,":"	; GRAPHIC CLR
        byte $FE,$02,"0",":"	; BANK 0
        byte $9E		; SYS 8224
        text "8224:"
        byte $8F		; REM
        text "TBC 231223"	; TBC + yymmdd
        byte 0
LLINK   byte 0,0
;=================

BOOT
 jmp PGMSTART

; -------------------------------------------

num equ $16
numhi equ $17

; -------------------------------------------
prtsgn
; -------------------------------------------
   sta num+0
   stx num+1

        bit num+1
        bpl prtint0
        pha
        lda #"-"
        jsr $ffd2

        sec
        lda #0
        sbc num
        sta num
        lda #0
        sbc num+1
        sta num+1
        pla
        jmp prtint0

;   \ -----------------------------------------------------------------
;   \ Print 16-bit unsigned decimal number
;   \ -----------------------------------------------------------------
;   \ On entry, num=number to print
;   \           pad=0 or pad character (eg '0' or ' ')
;   \ On entry at PrDec16Lp1,
;   \           Y=(number of digits)*2-2, eg 8 for 5 digits
;   \ On exit,  A,X,Y,num,pad corrupted
;   \ Size      69 bytes
;   \ -----------------------------------------------------------------


; -------------------------------------------
prtint
; -------------------------------------------
   sta num+0
   stx num+1

prtint0
   lda #0
   sta prtint_p
   LDY #8                ;                   :\ Offset to powers of ten
prtint1
   LDX #$FF
   SEC                  ; Start with digit=-1
prtint2
   LDA num+0
   SBC prtint10+0,Y
   STA num+0            ; Subtract current tens
   LDA num+1
   SBC prtint10+1,Y
   STA num+1

   INX
   BCS prtint2        ;  Loop until <0

   LDA num+0
   ADC prtint10+0,Y
   STA num+0            ;  Add current tens back in
   LDA num+1
   ADC prtint10+1,Y
   STA num+1
   TXA
   BNE prtint_Digit                     ; Not zero, print it

   LDA prtint_p
   BNE prtint_prt
   BEQ prtint_next

prtint_Digit
   LDX #"0"
   STX prtint_p                      ; No more zero padding
   ORA #"0"                        ; Print this digit

prtint_prt
   JSR $ffd2

prtint_next
   DEY
   DEY
   BPL prtint1                  ; Loop for next digit
   RTS

prtint_p byte 0

prtint10
   word 1
   word 10
   word 100
   word 1000
   word 10000


; -------------------------------------------
muldiv
; -------------------------------------------
 sta 99
 stx 100
 ldx #0
 stx 101
 stx 102
 ldy #16
 bcc mul16
div16
 asl 97
 rol 98
 rol 101
 rol 102
 sec
 lda 101
 sbc 99
 tax
 lda 102
 sbc 100
 bcc *+8
 stx 101
 sta 102
 inc 97
 dey
 bne div16

div16a
 lda 97
 ldx 98
 rts

mul16
 lsr 102
 ror 101
 ror 98
 ror 97
 dey
 bmi div16a
 bcc mul16
 clc
 lda 101
 adc 99
 sta 101
 lda 102
 adc 100
 sta 102
 clc
 bcc mul16
; -------------------------------------------

; -------------------------------------------
sys
; -------------------------------------------
 sta $04
 stx $05
 lda $1a
 sta $02
 lda $1104
 pha
 lda #$01
 trb $1104
 jsr $ff6e
 pla
 sta $1104
 cli
 rts

; -------------------------------------------
poke
;sta_far (.x),y
; -------------------------------------------
 php
 phz
 ldz $2d1
 jsr $ff77
 plz
 plp
 rts

; -------------------------------------------
peek
;lda_far (.a),y
; -------------------------------------------
 php
 phz
 phx
 tax
 ldz $2d1
 lda 1,x
 cmp #$20
 bcs peek1
 ldz #0
peek1 jsr $ff74
 plx
 plz
 plp
 and #$ff
 rts


; fuellen wir die verbleibenden Bytes, 
; damit der Basic-Start bei $2200 erfolgt.

libend
	blk $2200-libend,$55

; -------------------------------------------
PGMSTART
; -------------------------------------------

   END

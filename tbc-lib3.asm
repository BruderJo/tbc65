; -------------------------------------------
; TBC-LIB
; -------------------------------------------
; assemble with Bit Shift Assembler
; https://github.com/MEGA65/BSA
;
; command: bsa tbc-lib3 -n
; -------------------------------------------

.CPU  45GS02
;
; BASIC PROGRAMS START AT $2001
	.org $2001
   .load $2001             ;schreibe Startadr an Dateianfang
   .store $2001,$2200-$2001,"tbc-lib3.prg"

   .word LLINK,2023
   .byte $DE,$9C,':'	      ; GRAPHIC CLR
   .byte $FE,$02,'0',':'	; BANK 0
   .byte $9E		         ; SYS 8224
   .byte '8224:'
   .byte $8F		         ; REM
   .byte 'TBC 231223'	   ; TBC + yymmdd
   .byte 0
LLINK
   .byte 0,0
;=================

BOOT
   jsr init
   jmp PGMSTART

num = $16
numhi = $17

kernel_stop =   $2dc0
kernel_end  =   $2dc2

; -------------------------------------------
; Sprungtabelle
; -------------------------------------------

   jmp init
	jmp prtsgn
	jmp prtint
	jmp muldiv
   jmp bank
	jmp sys
	jmp poke
	jmp peek
   jmp endstop
	.byte 0,0,0

; -------------------------------------------
init
; -------------------------------------------
   rts

; -------------------------------------------
prtsgn
; -------------------------------------------
   sta num+0
   stx num+1

   bit num+1
   bpl prtint0
   pha
   lda #'-'
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

; -----------------------------------------------------------------
;  Print 16-bit unsigned decimal number
;  https://beebwiki.mdfs.net/Number_output_in_6502_machine_code
; -----------------------------------------------------------------
;  On entry, num=number to print
;            pad=0 or pad character (eg '0' or ' ')
;  On entry at PrDec16Lp1,
;            Y=(number of digits)*2-2, eg 8 for 5 digits
;  On exit,  A,X,Y,num,pad corrupted
;  Size      69 bytes
; -----------------------------------------------------------------


; -------------------------------------------
prtint
; -------------------------------------------
   sta num+0   ;lo byte
   stx num+1   ;hi byte

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
   LDX #'0'
   STX prtint_p                      ; No more zero padding
   ORA #'0'                        ; Print this digit

prtint_prt
   JSR $ffd2

prtint_next
   DEY
   DEY
   BPL prtint1                  ; Loop for next digit
   RTS

prtint_p byte 0

prtint10
   .word 1
   .word 10
   .word 100
   .word 1000
   .word 10000


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
bank
; -------------------------------------------
   sta     $02D1
   rts

; -------------------------------------------
sys
; -------------------------------------------
 sta $04 ;pclo
 stx $03 ;pchi
 lda $02d1
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


; -------------------------------------------
endstop
; -------------------------------------------
; Carry =  0 -> end
; Carry <> 0 -> stop

   bcs endstop1
   jmp kernel_end
endstop1
   jmp kernel_stop

   ;fill bytes from here to code start $2200
libend
	.fill $2200-libend ($55)

; -------------------------------------------
PGMSTART
; -------------------------------------------

   END

   10 goto 80
   20 rem 2023-12-22
   30 print "saving to disk: tbc65"
   40 save "@0:tbc65"
   50 print "done":dir "tbc65*"
   60 end
   70 rem
   80 print"{clr}{down}{wht}{swlc}{dish}Tiny-Basic-Compiler"
   90 rem german run 86/7,pg 83  update 19.7.1987
  100 rem micro-compiler by vic cortes - run august 1985,pg 62
  110 rem updated for c64
  120 rem updated and commented for mega65
  130 rem --------------------------------------------
  150 rem
  160 gosub 4550: rem init
  230 gosub 6730: rem pass1
  240 goto  2350: rem pass2
  250 :
  300 rem --------------------------------------------
  310 rem print line to mega-ass format
  320 rem - print#3,a$:return
  330 m1$=m1$+a$
  340 l$=""
  350 if len(m1$)=0 then 390
  360 a$=left$(m1$,1):m1$=mid$(m1$,2)
  369 rem ':' dann neue Zeile
  370 if a$=chr$(58) then print#3,c$+l$+c$:goto 340
  375 l$=l$+a$
  380 goto 350
  390 print#3,c$+l$+c$
  395 return
  400 :
  410 rem --------------------------------------------
  420 rem print line to mega-ass format (no nl)
  430 rem do not output now. just remember
  440 rem - print#3,a$;: return
  450 m1$=m1$+a$
  460 return
  470 :
  600 rem -----------------------------------------------
  610 rem open file a1$ for input as #2
  620 :
  630 a1$=a1$+",p,r"
  640 dopen#2,(a1$)
  650 rem print "file open #2:";a1$
  660 if ds then 700
  670 return
  680 :
  690 rem error reading file
  700 print "error reading "+a1$
  710 dclose#2:rem print "dclose#2"
  720 end
  730 :
  800 rem -----------------------------------------------
  810 rem open file "p-".a1$.",s,w" for output as #3
  820 :
  830 rem a1$="p-"+a1$+".asm"
  835 a1$=a1$+".asm"
  840 dopen#3,("@"+a1$),w
  850 if ds then 930
  860 rem print "file open #3:";a1$
  870 a$="; tiny basic":gosub 320
  880 a$=";":gosub 320
  890 a$=" .basic 'r-"+s$+"'":gosub 320
  900 a$=";":gosub 320
  910 return
  920 :
  930 print "error writing file "+a1$
  940 dclose#3:rem print "dclose#3"
  950 end
 1000 :
 1010 rem"{swlc}  Erste variable"
 1020 :
 1030 gosub 1820
 1040 if v>0 then a$=" lda i"+v$+": ldx i"+v$+"+1":gosub 320
 1050 if v=0 then a$=" lda #<"+str$(n)+": ldx #>"+str$(n):gosub 320
 1060 return
 1070 rem -----------------------------------
 1080 :
 1200 rem -----------------------------------
 1210 rem"{swlc}  Ausdruck"
 1220 rem -----------------------------------
 1230 :
 1240 p=0:if p828(u)=$c2 then u=u+2:p=1  :rem peek
 1250 gosub 1030
 1260 if u>100 then print"{rvon}Overflow":ec=ec+1:return
 1270 o=0:b=p828(u)
 1280 if b=$ad then 1630:rem /
 1290 if b=$ac then 1630:rem *
 1300 if b=$aa then o=109:a$=" clc":gosub 320:rem +
 1310 if b=$ab then o=237:a$=" sec":gosub 320:rem -
 1320 if b=$af then o=45                 :rem and
 1330 if b=$b0 then o=13                 :rem or
 1340 if o=0 then 1740
 1350 u=u+1:gosub 1820:if v=0 then 1420
 1360 if o=109 then a$=" adc i"+v$:gosub 320
 1370 if o=237 then a$=" sbc i"+v$:gosub 320
 1380 if o=45  then a$=" and i"+v$:gosub 320
 1390 if o=13  then a$=" ora i"+v$:gosub 320
 1400 goto 1460
 1410 rem
 1420 if o=109 then a$=" adc #<"+str$(n):gosub 320
 1430 if o=237 then a$=" sbc #<"+str$(n):gosub 320
 1440 if o=45  then a$=" and #<"+str$(n):gosub 320
 1450 if o=13  then a$=" ora #<"+str$(n):gosub 320
 1460 a$=" tay: txa":gosub 320
 1470 if v=0 then 1540
 1480 if o=109 then a$=" adc i"+v$+"+1":gosub 320
 1490 if o=237 then a$=" sbc i"+v$+"+1":gosub 320
 1500 if o=45  then a$=" and i"+v$+"+1":gosub 320
 1510 if o=13  then a$=" ora i"+v$+"+1":gosub 320
 1520 goto 1580
 1530 rem
 1540 if o=109 then a$=" adc #>"+str$(n):gosub 320
 1550 if o=237 then a$=" sbc #>"+str$(n):gosub 320
 1560 if o=45  then a$=" and #>"+str$(n):gosub 320
 1570 if o=13  then a$=" ora #>"+str$(n):gosub 320
 1580 a$=" tax: tya":gosub 320
 1590 goto 1260
 1600 rem ------------------------------
 1610 rem"{swlc}  Mul/Div"
 1620 rem ------------------------------
 1630 a$=" sta 97: stx 98":gosub 320
 1640 u=u+1:gosub 1030
 1650 g=g or 1
 1660 a=24
 1670 if b=173 then a=56:a$=" sec":gosub 320:rem /
 1680 if a=24 then a$=" clc":gosub 320
 1690 a$=" jsr muldiv":gosub 320
 1700 goto 1260
 1710 rem ------------------------------
 1720 rem"{swlc}  PEEK(ausdr)"
 1730 rem ------------------------------
 1740 if p=0 then return
 1745 g = g or 8
 1750 a$=" sta 34: stx 35":gosub 320
 1760 a$=" lda #34: ldy #0":gosub 320
 1770 a$=" jsr peek":gosub 320
 1780 u=u+1:p=0:goto 1260
 1790 rem ------------------------------
 1800 rem"{swlc}  Find"
 1810 rem ------------------------------
 1820 n=0:v=0
 1830 if p828(u)<65 then 1850
 1840 if p828(u)<91 then 2030
 1850 t=0
 1860 if p828(u)=170 then u=u+1:goto 1880
 1870 if p828(u)=171 then u=u+1:t=1
 1880 if p828(u)<48 or p828(u)>57 then print"{rvon}ERROR BEI";u    ;p828(u):ec=ec+1
 1890 if p828(u)>47 and p828(u)<58 then n=n*10+p828(u)-48:u=u+1:goto 1890
 1900 if t=0 then 1920
 1910 n=65536-n
 1920 return
 1930 :
 2000 rem ------------------------------
 2010 rem"{swlc}  VARIABLE"
 2020 rem ------------------------------
 2030 v=p828(u):v$=chr$(v)
 2040 v=p828(u+1)
 2050 if (v>64 and v<91)or(v>47 and v<58) then v$=v$+chr$(v):u=u+1:goto 2040
 2060 u=u+1:t=p828(u)
 2070 if t>90 then 2110:rem if >'z' ?
 2080 if t<32 then 2110
 2090 if (t=59)or(t=44)or(t=41) then 2110:rem ; , )
 2100 if t>35 then 2060:rem if ># ?
 2110 v$=left$(v$,6):if vp=0 then 2170:rem first var at all? -->
 2120 for i=0 to vp-1:if v$=v$(i) then i=998
 2130 next
 2140 v=1
 2150 if i=999 then 2210:rem var found, return
 2160 rem save varname
 2170 v$(vp)=v$:vp=vp+1:d=asc(v$)
 2180 print "var ";v$;", vp=";vp
 2190 rem -----
 2200 rem"{swlc}  H/L"
 2210 h%=d/256:l=d-h%*256:h=h%
 2220 return
 2300 :
 2310 rem ----------------------------------------
 2320 rem"{swlc}  Source lesen"
 2330 rem ----------------------------------------
 2340 :
 2350 print "pass2"
 2360 :
 2370 a1$=s$:gosub 630: rem open read
 2380 dclose#2
 2390 a1$=s$:gosub 630: rem open read
 2400 :
 2410 a1$=s$:gosub 830: rem open write
 2420 :
 2430 a$=" ; program = "+s$
 2440 a$=" ;":gosub 320:a$=" ; *="+s$:gosub 320
 2450 rem print "file#3 opened"
 2460 get#2,a1$,a2$:rem  ti$="000000"
 2470 get#2,a1$,a2$:t=asc(a1$+z$)+256*asc(a2$+z$)
 2480 rem print "lineptr = ";t
 2490 if t=0 then 5020:rem ptr to next line is zero? -> jump
 2500 get#2,a1$,a2$:rem read line number
 2510 t=asc(a1$+z$)+asc(a2$+z$)*256
 2520 print t;" ";
 2530 q=0:rem unset quote flag
 2540 a$=" ; zeile"+str$(t):gosub 320
 2550 s(m)=t:m=m+1: rem print"{left}";t;
 2560 if s(m-1)>=l(ll) then a$="l"+mid$(str$(t),2)+" ":gosub 320:ll=ll+1:rem label
 2570 rem
 2580 j=0  :rem  if peek(653) then 640
 2590 rem read symbol and store into buffer
 2600 get#2,b$:if st then 5020
 2610 b=asc(b$+z$):p828(j)=b
 2620 if q or (b<>32 and b>0) then j=j+1
 2630 if b=0 then 2730
 2640 if b=34 then q=not q
 2650 if b<128 or q then print b$;
 2660 rem -------------------------
 2670 rem print token in b
 2680 rem -------------------------
 2690 rem 
 2700 if b>127 and b<204 and q=0 then gosub 8010:print b$;
 2710 if q then 2600
 2720 rem -------------------------
 2730 if b<32 then print:gosub 2820:goto 2470
 2740 if b=167 then gosub 2820:goto 2580
 2750 goto 2600
 2800 rem -------------------- evaluate command
 2810 rem  command 
 2820 b=p828(0  ):u=1  :p828(j)=0:p828(j+1)=0
 2830 if b=136 then 3100:rem let
 2840 rem if b=128 or b=144 then print#3,"jmp $a474":return:rem c64 end stop
 2850 if b=128 or b=144 then a$=" jmp endstop":gosub 320:return:rem end stop
 2860 if b=142 then a$=" rts":gosub 320:return:rem return
 2870 if b=158 then 4240:rem sys
 2880 if b=159 then 6320:rem open
 2890 if b=139 then 3320:rem if
 2900 if b=160 then 6640:rem close
 2910 if b=153 then 3510:rem print
 2920 if b=152 then 7650:rem print#
 2930 if b=151 then 4310:rem poke
 2940 if b=161 then 7530:rem get
 2950 if b=129 then 3950:rem for
 2960 if b=130 then 4170:rem next
 2970 if b=143 and p828(u)=36 then 5510:rem rem$
 2980 if b=143 then return:rem rem
 2990 if b=137 then a$=" jmp l":gosub440:goto 3890:rem goto
 3000 if b=141 then a$=" jsr l":gosub440:goto 3890:rem gosub
 3005 if b=254 and p828(u)=2 then 4400:rem bank
 3010 if b<48 or b>90 then 3050
 3020 if b>64 then 3110
 3030 if b<58 then u=0  :b=137:goto 2990
 3040 rem command not found. show error
 3050 print"{rvon}ERROR:";u    ;p828(u)
 3060 ec=ec+1
 3070 return
 3080 rem -----
 3090 rem"{swlc}  V=Ausdr."
 3100 for i=0   to 140:p828(i)=p828(i+1):next
 3110 u=0  :if p828(u)<65 or p828(u)>90 then 3050
 3120 rem print "Var=Expr"
 3130 v=p828(u)
 3140 v$=chr$(v):u=u+1
 3150 v=p828(u)
 3160 if(v>64 and v<91)or(v>47 and v<58)then v$=v$+chr$(v):u=u+1:goto 3150
 3170 if p828(u)<>178 then 3050
 3180 vv$=v$:u=u+1:gosub 1240
 3190 v$=vv$:gosub 2110
 3200 a$=" sta i"+v$:gosub 320
 3210 a$=" stx i"+v$+"+1":gosub 320
 3220 return
 3230 rem -----
 3300 :
 3310 rem"{swlc}  IF/THEN"
 3320 print "IF/THEN"
 3330 gosub 1240:w=p828(u):if w<177 then 3050
 3340 if w>179 then 3050
 3350 a$=" sta 36: stx 37":gosub 320
 3360 u=u+1
 3370 if w=179 and p828(u)=177 then w=180:u=u+1
 3380 if w=177 and p828(u)=179 then w=180:u=u+1
 3390 gosub 1240
 3400 a$=" cpx 37: beq *+6":gosub 320
 3410 f=a
 3420 a$=" l"+mid$(str$(l(ll)),2)
 3430 if w=180 then a$=" beq"+a$+": bne *+8: cmp 36: beq"+a$
 3440 if w=178 then a$=" bne"+a$+": bne *+8: cmp 36: bne"+a$
 3450 if w=179 then a$=" bcc"+a$+": bcs *+8: cmp 36: bcc"+a$;": beq"+a$
 3460 if w=177 then a$=" bcs"+a$+": bcc *+8: cmp 36: bcs"+a$;": beq"+a$
 3470 gosub 320
 3480 return
 3490 rem -----
 3500 rem"{swlc}  PRINT"
 3510 w=p828(u):if w<32 then 3850
 3520 if w=59 and p828(u+1)<32 then return
 3530 if w=59 then u=u+1:goto 3510
 3540 if w=199 then 3660:rem" CHR$
 3550 if w=34  then 3720:rem" String
 3560 rem -----
 3570 rem"{swlc}  PRINT Ausdr."
 3580 rem print#3," lda #29"
 3590 rem print#3," jsr $ffd2"
 3600 gosub 1240:rem a$=" stx 34: tax: lda 34":gosub 320:rem a/x tauschen
 3605 g=g or 4
 3610 a$=" jsr prtint":gosub 320:rem Zahl in a/x ausgeben
 3611 rem C64 $bdcd, C128 $8e32, C65 $647f, m65 $????
 3620 a$=" lda #32: jsr $ffd2":gosub 320
 3630 goto 3510
 3640 rem -----
 3650 rem"{swlc}  PRINT CHR$(Ausdr.)"
 3660 u=u+1:if p828(u)<>40 then 3050
 3670 u=u+1:gosub 1240
 3680 a$=" jsr $ffd2":gosub 320
 3690 u=u+1:goto 3510
 3700 rem -----
 3710 rem"{swlc}  PRINT String"
 3720 a$=" jsr print":gosub 320
 3730 g=g or 2
 3740 a$=" .text '":gosub 440
 3750 i=0
 3760 i=i+1:u=u+1:if u>100 then 3820
 3770 if i>20 then i=1:a$="'":gosub 320:a$=" .text '":gosub 440
 3780 if p828(u)=34 then 3820
 3790 if p828(u)=0 then 3820
 3800 a$=chr$(p828(u)):gosub 440
 3810 goto 3760
 3820 a$="'":gosub 320
 3830 a$=" .byte 0":gosub 320
 3840 u=u+1:goto 3510
 3850 a$=" lda #13: jsr $ffd2":gosub 320
 3860 return
 3870 rem -----
 3880 rem"{swlc}  GOTO/GOSUB"
 3890 gosub 1820
 3900 if v=0 then v$=mid$(str$(n),2)
 3910 a$=v$:gosub 320
 3920 return
 3930 rem -----
 3940 rem"{swlc}  FOR"
 3950 u=3:gosub 1240
 3960 lp(lp)=s(m-1)
 3970 a1$=mid$(str$(lp(lp)),2)
 3980 a$=" jmp lf"+a1$:gosub 320
 3990 hu=u:u=1
 4000 a$="f"+a1$+" ":gosub 440
 4010 gosub 1030:u=hu+1
 4020 a$=" sta 36: stx 37":gosub 320
 4030 gosub 1240
 4040 a$=" cpx 37: beq *+6: bcs *+13: bcc *+8":gosub 320
 4050 a$=" cmp 36: beq *+4: bcs *+5":gosub 320
 4060 xa(xa)=s(m-1):xa=xa+1:a$=" jmp ff"+a1$:gosub 320
 4070 if p828(u)<>169 then a$=" lda #1: ldx #0":gosub320:goto 4090
 4080 u=u+1:gosub 1240
 4090 u=0  :b=170:gosub 1300
 4100 d=a:gosub 2210:
 4110 a$="lf"+a1$+" ":gosub 440
 4120 lp=lp+1
 4130 u=1  :gosub 2030:goto 3200
 4140 rem -----
 4150 rem
 4160 rem"{swlc}  NEXT"
 4170 lp=lp-1
 4180 a1$=mid$(str$(lp(lp)),2)
 4190 a$=" jmp f"+a1$:gosub 320
 4200 a$="ff"+a1$+" nop":gosub 320
 4210 return
 4220 rem -----
 4230 rem"{swlc}  SYS"
 4240 gosub 1240
 4245 g = g or 8
 4250 a$=" jsr syscall":gosub 320
 4280 return
 4290 rem -----
 4300 rem"{swlc}  POKE"
 4310 gosub 1240
 4315 g = g or 8
 4320 a$=" sta 36: stx 37":gosub 320
 4330 rem
 4340 if p828(u)<>44 then 3050
 4350 u=u+1:gosub 1240
 4360 a$=" ldy #0: ldx #36":gosub 320
 4370 a$=" jsr poke":gosub 320
 4380 return
 4390 rem"{swlc}  BANK"
 4400 u=u+1:gosub 1240
 4410 g = g or 8
 4420 a$=" sta $2d1": gosub 320
 4430 return
 4450 rem
 4490 :
 4500 rem ------------------------------------
 4510 rem"{swlc}  *** INIT ***"
 4520 rem ------------------------------------
 4530 :
 4540 :
 4550 dim n(200)
 4560 dim a(200)
 4570 dim s(800)    :rem current line
 4580 dim l(800)
 4590 dim t$(200)
 4600 dim lp(10)
 4610 dim xa(10)
 4620 dim v$(200)   :rem variable names
 4630 dim p828(200) :rem read buffer, c64: ab 828, c128: ab adr 2816
 4640 a=0:rem
 4650 b=0:rem
 4660 u=0:rem Ptr to p828()
 4670 i=0:rem
 4680 j=0:rem
 4690 k=0:rem
 4692 m=0:rem
 4700 v=0:rem
 4710 d=0:rem
 4720 c=0:rem
 4730 h=0:rem
 4740 l=0:rem  pointer to ll() line number
 4750 q=0:rem  quote flag (inside strings)
 4760 w=0:rem
 4770 z=0: rem ascflag 
 4780 lp=0:rem loop ptr, index fuer for-next
 4790 xa=0:rem
 4800 vp=0:rem max. index variable pointer
 4810 ec=0:rem error counter
 4820 c$=chr$(34)
 4830 :
 4840 :
 4850 foreground 15:background 0
 4860 s$="test.bas":s=49152
 4870 z$=chr$(0):cr$=chr$(13)
 4880 input "{down}Quellfile (*=Ende) ";s$
 4890 restore:if s$="*" then end
 4900 rem input "Startadr. ";s:print
 4910 rem a1$=s$:gosub 520
 4920 return
 5000 rem --------------------------------------------
 5010 rem"{swlc}  Ende"
 5020 print "End of input file"
 5025 a$=";":gosub 320
 5026 a$=" rts":gosub 320
 5027 a$=";":gosub 320
 5030 if (z and 64)=64 then 5180
 5040 if (g and 1)=0 then 5110
 5050 a$=";":gosub 320
 5060 print:print"MULDIV"
 5070 read d$
 5080 if d$="end" then a$=";":gosub 320:goto 5110
 5090 a$=d$:gosub 320
 5100 goto 5070
 5110 if (g and 2)=0 then 5150
 5120 print"PRINT"
 5130 a$="print pla: sta 34: pla: sta 35: ldy #0"::gosub 320
 5135 a$="print1 inc 34: bne *+4: inc 35: lda (34),y: beq *+8: jsr $ffd2":gosub 320
 5140 a$=" jmp print1: lda 35: pha: lda 34: pha: rts":gosub 320
 5145 a$=";":gosub 320
 5150 if (g and 4)=0 then 5170
 5151 print"PRTINT"
 5152 rem signed print. vorzeichen + 2er komplement
 5153 a$="prtint sta 34: stx 35: bit 35: bpl prtint0: pha: lda #'-': jsr $ffd2":gosub 320
 5154 a$=" sec: lda #0: sbc 34: sta 34: lda #0: sbc 35: sta 35: pla":gosub 320
 5155 rem print num in 22/23
 5156 a$="prtint0 lda #0: sta 24: ldy #8:prtint1 ldx #$ff: sec":gosub 320
 5157 a$="prtint2 lda 34: sbc prt10,y: sta 34: lda 35: sbc prt10+1,y: sta 35":gosub 320
 5158 a$=" inx: bcs prtint2: lda 34: adc prt10,y: sta 34: lda 35: adc prt10+1,y: sta 35":gosub 320
 5160 a$=" txa: bne prtint3: lda 24: bne prtint4: beq prtint5":gosub 320
 5161 a$="prtint3 ldx #'0': stx 24: ora #'0'":gosub 320
 5162 a$="prtint4 jsr $ffd2:prtint5 dey: dey: bpl prtint1: rts":gosub 320
 5163 a$="prt10 .word 1: .word 10: .word 100: .word 1000: .word 10000":gosub 320
 5165 a$=";":gosub 320
 5170 if (g and 8)=0 then 5180
 5171 a$="syscall sta $04: stx $05: lda $1a: sta $02":gosub 320:rem sys, peek, poke function
 5172 a$=" lda $1104: pha: lda #$01: trb $1104: jsr $ff6e":gosub 320
 5173 a$=" pla: sta $1104: cli: rts":gosub320
 5174 rem sta_far (.x),y
 5175 a$="poke php: phz: ldz $2d1: jsr $ff77: plz: plp: rts": gosub 320
 5176 rem lda_far (.a),y
 5177 a$="peek php: phz: phx: tax: lfz $2d1: lda 1,x: cmp #$20: bcs peek1":gosub 320
 5178 a$=" ldz #0:peek1 jsr $ff74: plx: plz: plp: and #$ff: rts":gosub 320
 5179 rem
 5180 a$="endstop rts":gosub 320:rem c64= jmp $a474, m65=?
 5185 print "z=";z:if z>127 then 5280: rem flag: no vars
 5190 print"VARIABLE (";vp;")"
 5200 if vp=0 then 5280: rem jump, if no var read
 5210 a$=" ; variable": gosub 320
 5220 for i=0 to vp-1
 5230    a$="i"+v$(i)+" .word 0"
 5240    print a$
 5250    gosub 320   
 5260 next i
 5270 :
 5280 a$=" .end":gosub 320
 5290 print#3,"*"
 5300 dclose#2:dclose#3:rem print "close 2:close 3"
 5310 :
 5320 print"{down}Errors";ec
 5330 print s$;" compiliert":rem ", Zeit:";ti$
 5340 end
 5350 rem --------------------------------------------
 5360 :
 5370 :
 5380 rem"{swlc}  Mul/Div-Data"
 5390 data"muldiv sta 99: stx 100: ldx #0: stx 101: stx 102"
 5400 data " ldy #16: bcc mul16"
 5410 data "div16 asl 97: rol 98: rol 101: rol 102: sec"
 5420 data " lda 101: sbc 99: tax: lda 102: sbc 100: bcc *+8"
 5430 data " stx 101: sta 102: inc 97: dey: bne div16"
 5440 data "div16a lda 97: ldx 98: rts"
 5450 data "mul16 lsr 102: ror 101: ror 98: ror 97: dey: bmi div16a"
 5460 data " bcc mul16: clc: lda 101: adc 99: sta 101"
 5470 data " lda 102: adc 100: sta 102: clc: bcc mul16"
 5480 data "end"
 5490 rem
 5500 rem"{swlc}  REM$" - compiler flags
 5510 u=u+2:w=p828(u-1):if w<>86 then 5540:rem v (print var def in assembler output)
 5520 z=z and 127
 5530 return
 5540 if w<>78 and p828(u)<>86 then 5560:rem nv (print no vars in assembler output)
 5550 z=z or 128:return
 5560 if w<>81 then 5640:rem q (quit compiler if error count >0)
 5570 if ec=0 then return
 5580 :
 5590 dclose#3:dclose#2:rem print "close 2:close 3"
 5600 :
 5610 print:print"***Abgebrochen nach";ec;"Fehler(n)"
 5620 end
 5630 :
 5640 if w<>65 then 5700:rem a (insert assembler command)
 5650 u=u+1
 5660 w=p828(u):u=u+1
 5670 if w>0 then a$=chr$(w):gosub 440:goto5660
 5680 a$="":gosub 320
 5690 return
 5700 if w<>76 then return:rem l (include mul/div library)
 5710 z=z or 64
 5720 return
 5730 :
 6300 rem"{swlc}  OPEN"
 6310 :
 6320 gosub 1240:a$=" pha":gosub 320:rem parameter fn
 6330 if p828(u)<>44 then 3050
 6340 u=u+1:gosub 1240:a$=" pha":gosub 320:rem parameter gn
 6350 if p828(u)<>44 then 3050
 6360 u=u+1:gosub 1240:a$=" pha":gosub 320:rem parameter sa
 6370 if p828(u)<>44 then 3050
 6380 l$="":u=u+1
 6390 if p828(u)<>34 then 6460
 6400 u=u+1:w=p828(u):if w=0 or w=34 then 6540
 6410 l$=l$+chr$(w)
 6420 a$=" lda #"+str$(w)+": sta"+str$(511+len(l$)):gosub 320
 6430 goto 6400
 6440 :
 6450 rem -----
 6460 if p828(u)<>199 then 3050:rem chr$()
 6470 u=u+1:if p828(u)<>40 then 3050
 6480 u=u+1:gosub 1240:l$=l$+" "
 6490 a$=" sta"+str$(511+len(l$)):gosub 320
 6500 u=u+1:if p828(u)=0 then 6540
 6510 if p828(u)<>170 then 3050
 6520 u=u+1:goto 6460
 6530 :
 6540 a$=" lda #"+len(l$)+";open":gosub 320
 6550 a$=" ldy #2:ldx #0":gosub 320
 6560 a$=" jsr $ffbd":gosub 320
 6570 a$=" pla: tay: pla: tax: pla":gosub 320
 6580 a$=" jsr $ffba":gosub 320
 6590 a$=" jsr $ffc0":gosub 320
 6600 return
 6610 :
 6620 rem"{swlc}  CLOSE"
 6630 :
 6640 a$=" jsr $ffcc ;clrchn":gosub 320
 6650 gosub 1240
 6660 a$=" jsr $ffc3 ;close":gosub 320
 6670 return
 6680 :
 6700 rem ----------------------------------------------
 6710 rem"{swlc}  PASS1 Zeilennummer eintragen"
 6720 :
 6730 print "pass1"
 6740 a1$=s$:gosub 630: rem open file
 6750 :
 6760 get#2,a1$,a2$:ll=0:rem ignore start addr., init line pointer
 6770 get#2,a1$,a2$:t=asc(a1$+z$)+256*asc(a2$+z$):rem read ptr next basic line
 6780 if t=0 then 7090:rem basic end
 6790 get#2,a1$,a2$:t=asc(a1$+z$)+256*asc(a2$+z$):rem read line#
 6800 rem  print "next line num=";t
 6810 q=0:rem reset quote flag
 6820 if f then l(ll)=t:ll=ll+1:print t
 6830 m=m+1:f=0:q=0
 6840 j=0:rem j=828
 6850 get#2,b$:if st then 7090
 6860 b=asc(b$+z$):p828(j)=b:rem poke j,b
 6870 q=(b=34)and(q=0)
 6880 if q or b=32 then 6850
 6890 j=j+1:if b>31 then 6850
 6900 rem basic line read. continue
 6910 u=0:rem u=828
 6920 b=p828(u):u=u+1:
 6930 if b=0 then 6770:rem end of line
 6940 rem 139=if
 6950 if b=139 then f=1:goto 7020:rem set if flag
 6960 rem 137=goto
 6970 rem 141=gosub
 6980 rem remember line number if goto/gosub
 6990 if b=137 or b=141 then gosub 1820:l(ll)=n:ll=ll+1:print n:goto 7000
 7000 goto 6920
 7010 rem 167=then
 7020 b=p828(u):u=u+1:if b<>167 and b<>0 then 7020
 7030 if b=0 then 6770
 7040 b=p828(u)
 7050 if b<48 or b>57 then 6920
 7060 gosub 1820:l(ll)=n:ll=ll+1>:rem print n
 7070 goto 6920
 7080 rem" Finish input line and start post-work"
 7090 print
 7100 rem
 7110 rem
 7120 rem -----
 7130 ll=ll-1:rem set ll to latest line number
 7140 if ll<=0 then l(0)=65535:goto 7350:rem no jumps?
 7150 rem" Array l() sortieren"
 7160 for j=0 to ll-1
 7170 for i=j+1 to ll
 7180 if l(i)>=l(j) then 7210
 7190 rem switch array elements
 7200 a=l(i):l(i)=l(j):l(j)=a
 7210 next i
 7220 next j
 7230 j=0:a=ll
 7240 rem clean duplicate entries
 7250 for i=0 to a-1
 7260 if l(i)=l(i+1) then for j=i+1 to a-1:l(j)=l(j+1):next:l(a)=0:a=a-1
 7270 next i
 7280 if j then a=a+1:j=0:goto 7250
 7290 ll=a
 7300 if l(a)=0 then a=a-1:goto 7290
 7310 l(ll+1)=65535:rem end marker at last array pos
 7320 rem array l() is now sorted
 7330 rem display all line numbers sorted
 7340 for i=0 to ll:print l(i):next
 7350 rem return from subroutine
 7360 ll=0:rem set line# ptr to first pos
 7370 print "pass1 done"
 7380 dclose#2:print "close 2"
 7390 dclose u8:print "dclose u8"
 7400 return
 7500 rem -----------------------------------------
 7510 rem"{swlc}  GET#"
 7520 :
 7530 b=p828(u):if b<>35 then 7570
 7540 u=u+1:gosub 1240:
 7550 a$=" tax: jsr $ffc6 ;chkin":gosub 320
 7560 u=u+1
 7570 a$=" jsr $ffe4 ;getin":gosub 320
 7580 gosub 1820:if v=0 then 3050
 7590 a$=" ldx #0: sta i"+v$+": stx i"+v$+"+1":gosub 320
 7600 if b=35 then a$=" jsr $ffcc ;clrchn":gosub 320
 7610 return
 7620 rem ----------
 7630 rem"{swlc}  PRINT#"
 7640 :
 7650 gosub 1240
 7660 a$=" tax: jsr $ffc9 ;chkout":gosub 320
 7670 u=u+1
 7680 gosub 3510
 7690 a$=" jsr $ffcc ;clrchn":gosub 320
 7700 return
 7710 rem
 8000 rem ----------
 8005 :
 8010 rem convert token in var b into text in var b$
 8015 :
 8020 b$="<"+str$(b)+">":rem default if token out of scope
 8030 if b=$80 then b$="END"
 8040 if b=$81 then b$="FOR"
 8050 if b=$82 then b$="NEXT"
 8060 if b=$88 then b$="LET"
 8070 if b=$89 then b$="GOTO"
 8080 if b=139 then b$="IF"
 8090 if b=$8e then b$="RETURN"
 8100 if b=$8d then b$="GOSUB"
 8110 if b=143 then b$="REM"
 8120 if b=144 then b$="STOP"
 8130 if b=153 then b$="PRINT"
 8140 if b=152 then b$="PRINT#"
 8150 if b=151 then b$="POKE"
 8160 if b=158 then b$="SYS"
 8170 if b=159 then b$="OPEN"
 8180 if b=160 then b$="CLOSE"
 8190 if b=161 then b$="GET"
 8200 if b=$a4 then b$="TO"
 8210 if b=$a7 then b$="THEN"
 8220 if b=$a8 then b$="NOT"
 8230 if b=$a9 then b$="STEP"
 8240 if b=$aa then b$="+"
 8250 if b=$ab then b$="-"
 8260 if b=$ac then b$="*"
 8270 if b=$ad then b$="/"
 8280 if b=$af then b$="AND"
 8290 if b=$b0 then b$="OR"
 8300 if b=$b1 then b$=">"
 8310 if b=$b2 then b$="="
 8320 if b=$b3 then b$=">"
 8330 if b=$c2 then b$="PEEK"
 8340 if b=$cb then b$="GO"
 8350 return

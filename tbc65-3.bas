10 goto 80
20 rem 2023-12-31
30 print "saving to disk"
40 save "@0:tbc3",8
50 print "done":dir "tbc3*"
60 end
70 rem
80 print chr$(147);chr$(17);chr$(5);chr$(14);chr$(8);"Tiny-Basic-Compiler"
90 rem german run 86/7,pg 83  update 19.7.1987
100 rem micro-compiler by vic cortes - run august 1985,pg 62
110 rem updated for c64
120 rem updated and commented for mega65
130 rem --------------------------------------------
150 rem
160 pa=0:gosub 5350: rem init
230 t1%=ti:rem zeit merken
240 pa=1:gosub 2750:rem pass1
245 pa=2:gosub 2750:rem pass2
255 end
300 rem --------------------------------------------
310 rem print line to binary
320 rem op = anzahl bytes
340 print "sub 320, error":end
341 if op=0 then return
350 for a=0 to op-1
360 if pa=2 then print#3,chr(a(a));
370 next
380 pc=pc+op
390 return
400 :
410 rem --------------------------------------------
420 rem print line to library
430 rem do not output now. just remember
440 if len(a$)=0 then return
450 if pa=1 then 455
451 rem print"451: len=";len(a$);
452 for a=1 to len(a$):print#3,mid$(a$,a,1);
453 rem print right$(hex$(asc(mid$(a$,a,1))),2);" ";
454 next:rem print
455 pc=pc+len(a$)
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
810 rem open file "p-".a1$.",p,w" for output as #3
820 :
830 if pa<2 then 920
835 a1$="r-"+a1$+""
837 rem dopen#3,("@"+a1$),w
840 dopen#3,("@"+a1$+",p"),w
850 if ds then 930
860 restore:rem basic stub und rtl schreiben
870 read a$:if left$(a$,1) ="*" then 920
880 h=asc(mid$(a$,1,1))-48:l=asc(mid$(a$,2,1))-48
890 if h>16 then h=h-7
895 if l>16 then l=l-7
900 a=h*16+l
910 print#3,chr$(a);
915 goto 870
920 return
925 :
930 print "error writing file "+a1$
940 dclose#3:rem print "dclose#3"
950 end
1000 :
1010 rem"{ct n}  Erste variable"
1020 :
1030 gosub 1820
1032 rem print"1032: v=";v;"n=";n
1035 rem " lda #<"+str$(n)+": ldx #>"+str$(n)
1040 if v<>0 then 1046
1041 d=n:gosub 2610
1042 a$=chr$($a9)+chr$(l)+chr$($a2)+chr$(h):gosub 440
1043 goto 1060
1045 rem " lda i"+v$+": ldx i"+v$+"+1"
1046 rem print"1045: v$=";v$;" d=";hex$(d);" vl=";hex$(vl);" vh=";hex$(vh)
1047 a$=chr$($ad)+chr$(vl)+chr$(vh):gosub 440
1050 d=d+1:gosub 2610
1055 a$=chr$($ae)+chr$(l)+chr$(h):gosub 440
1060 return
1070 rem -----------------------------------
1080 :
1200 rem -----------------------------------
1210 rem"{ct n}  Ausdruck"
1220 rem -----------------------------------
1230 :
1240 p=0:if p828(u)=$c2 then u=u+2:p=1  :rem peek
1250 gosub 1030
1260 if u>100 then print"{reverse on}Overflow":ec=ec+1:return
1270 o=0:b=p828(u)
1280 if b=$ad then 1630:rem '/
1290 if b=$ac then 1630:rem '*
1300 rem " clc"
1301 if b=$aa then o=109:a$=chr$($18):gosub 440:rem '+
1310 rem " sec"
1311 if b=$ab then o=237:a$=chr$($38):gosub 440:rem '-
1320 if b=$af then o=45                        :rem 'and
1330 if b=$b0 then o=13                        :rem 'or
1340 if o=0 then 1740
1350 u=u+1:gosub 1820:if v=0 then 1420:rem zahl? dann 1420
1352 rem variable
1355 a$=chr$(vl)+chr$(vh):dd=d:rem dezimal merken
1360 if o=109 then a$=chr$($6d)+a$:gosub440:rem adc low
1370 if o=237 then a$=chr$($ed)+a$:gosub440:rem sbc
1380 if o=45  then a$=chr$($2d)+a$:gosub440:rem and
1390 if o=13  then a$=chr$($0d)+a$:gosub440:rem ora
1395 a$=chr$($a8)+chr$($8a):gosub 440
1397 d=d+1:gosub 2610:a$=chr$(l)+chr$(h)
1400 if o=109 then a$=chr$($6d)+a$:gosub440:rem adc hi
1405 if o=237 then a$=chr$($ed)+a$:gosub440:rem sbc
1410 if o=45  then a$=chr$($2d)+a$:gosub440:rem and
1415 if o=13  then a$=chr$($0d)+a$:gosub440:rem ora
1417 goto 1580
1418 rem
1419 rem num. operand
1420 d=n:gosub 2610:a$=chr$(l)
1425 if o=109 then a$=chr$($69)+a$:gosub 440:rem adc #low
1430 if o=237 then a$=chr$($e9)+a$:gosub 440:rem sbc #
1440 if o=45  then a$=chr$($29)+a$:gosub 440:rem and #
1450 if o=13  then a$=chr$($09)+a$:gosub 440:rem ora #
1459 rem  tay: txa
1460 a$=chr$($a8)+chr$($8a):gosub 440
1530 a$=chr$(h)
1540 if o=109 then a$=chr$($69)+a$:gosub 440:rem adc #hi
1550 if o=237 then a$=chr$($e9)+a$:gosub 440:rem sbc #
1560 if o=45  then a$=chr$($29)+a$:gosub 440:rem and #
1570 if o=13  then a$=chr$($09)+a$:gosub 440:rem ora #
1580 rem  tax: tya
1585 a$=chr$($aa)+chr$($98):gosub 440
1590 goto 1260
1595 :
1600 rem ------------------------------
1610 rem"{ct n}  Mul/Div"
1620 rem ------------------------------
1630 a$=chr$($85)+chr$(97)+chr$($86)+chr$(98):gosub 440
1640 u=u+1:gosub 1030
1650 g=g or 1
1660 a=24
1670 if b=173 then a=56:a$=chr$($38):gosub 440:rem /
1680 if a=24 then a$=chr$($18):gosub 440
1690 rem a$=" jsr muldiv"
1695 a$=chr$($20)+chr$($93)+chr$($20):gosub 440
1700 goto 1260
1710 rem ------------------------------
1720 rem"{ct n}  PEEK(ausdr)"
1730 rem ------------------------------
1740 if p=0 then return
1745 g = g or 8
1750 rem a$=" sta 34: stx 35"
1755 a$=chr$($85)+chr$(34)+chr$($86)+chr$(35):gosub 440
1760 rem a$=" lda #34: ldy #0"
1765 a$=chr$($a9)+chr$(34)+chr$($a0)+chr$(0):gosub 440
1770 rem a$=" jsr peek"
1775 a$=chr$($20)+chr$($05)+chr$($21):gosub 440
1780 u=u+1:p=0:goto 1260
1790 rem ------------------------------
1800 rem"{ct n}  Find"
1805 rem return: v=0, dann numerisch in n
1806 rem         v>0, dann variable in v$
1810 rem ------------------------------
1820 n=0:v=0
1830 if p828(u)<65 then 1850
1840 if p828(u)<91 then 2430
1850 t=0
1860 if p828(u)=170 then u=u+1:goto 1880
1870 if p828(u)=171 then u=u+1:t=1
1880 if p828(u)<48 or p828(u)>57 then print"{reverse on}ERROR BEI";u    ;p828(u):ec=ec+1
1890 if p828(u)>47 and p828(u)<58 then n=n*10+p828(u)-48:u=u+1:goto 1890
1900 if t=0 then 1920
1910 n=65536-n
1920 return
1930 :
2000 rem ----------------------------------------
2010 rem"{ct n}  Variable suchen"
2020 rem ----------------------------------------
2030 rem input: v$; output vv
2040 :
2050 vv=0
2060 if v$(vv) = v$ then 2100
2070 vv=vv+1
2080 if vv>=vp then vv=-1:return:rem not found
2090 goto 2060
2100 d=va(vv):gosub 2610
2110 vh=h:vl=l
2120 return
2400 rem ------------------------------
2410 rem"{ct n}  VARIABLE"
2415 rem vv=index var, vh/vl = adresse
2420 rem ------------------------------
2430 v=p828(u):v$=chr$(v)
2440 v=p828(u+1)
2450 if (v>64 and v<91)or(v>47 and v<58) then v$=v$+chr$(v):u=u+1:goto 2440
2460 u=u+1:t=p828(u)
2470 if t>90 then 2510:rem if >'z' ?
2480 if t<32 then 2510
2490 if (t=59)or(t=44)or(t=41) then 2510:rem ; , )
2500 if t>35 then 2460:rem if ># ?
2510 v$=left$(v$,6):if vp=0 then 2570:rem first var at all? -->
2520 i=0:vv=-1:rem vv=index auf gefundene variable, -1 = not found
2525 if v$<>v$(i) then 2550
2530 vv=i:rem var found, index merken
2535 d=vv*2+vo:gosub 2610:vh=h:vl=l
2540 goto 2560
2550 i=i+1: if i<vp then 2525
2555 :
2560 v=1: rem flag: variable gelesen
2565 if vv>=0 then return
2570 v$(vp)=v$:d=vo+2*vp:va(vp)=d
2575 vp=vp+1
2580 rem print "var ";v$;", vp=";vp
2590 rem -----
2600 rem"{ct n}  H/L"
2610 h%=d/256:l=d-h%*256:h=h%
2620 return
2700 :
2710 rem ----------------------------------------
2720 rem"{ct n}  Source lesen"
2730 rem ----------------------------------------
2740 :
2750 print "pass ";pa
2760 ec=0:ll=0:lp=0:sc=0:pc=$2200
2765 ve=vo+2*vp+1:rem variable ende
2770 a1$=s$:gosub 630: rem open read
2780 dclose#2
2790 a1$=s$:gosub 630: rem open read
2800 :
2810 a1$=s$:gosub 830: rem open write
2820 :
2830 rem a$=" ; program = "+s$
2840 rem a$=" ;":a$=" ; *="+s$
2850 rem print "file#3 opened"
2860 get#2,a1$,a2$:rem  ti$="000000"
2870 get#2,a1$,a2$:t=asc(a1$+z$)+256*asc(a2$+z$)
2880 rem print "lineptr = ";t
2890 if t=0 then 6020:rem ptr to next line is zero? -> jump code ende
2900 get#2,a1$,a2$:rem read line number
2910 t=asc(a1$+z$)+asc(a2$+z$)*256
2920 print t;" ": print"{up}";
2930 q=0:rem unset quote flag
2940 rem a$=" ; zeile"+str$(t)
2950 l(ll)=t: la(ll)=pc
2960 ll=ll+1
2970 rem
2980 j=0:rem  eine zeile lesen
2990 rem read symbol and store into buffer
3000 get#2,b$:if st then 6020
3010 b=asc(b$+z$):p828(j)=b
3020 if q or (b<>32 and b>0) then j=j+1
3030 if b=0 then 3130
3040 if b=34 then q=not q
3110 if q then 3000
3130 if b<32 then gosub 3180:goto 2870
3140 if b=$a7 then gosub 3180:goto 2980:rem 'then
3150 goto 3000
3160 rem -------------------- evaluate command
3170 rem  command
3180 b=p828(0  ):u=1  :p828(j)=0:p828(j+1)=0
3190 if b=136 then 3470:rem let
3200 rem if b=128 or b=$90 then print#3,"jmp $a474":return:rem c64 end stop
3210 if b=$80 or b=$90 then 4810:rem 'end stop
3220 if b=142 then a$=chr$($60):gosub 440:return:rem 'return
3230 if b=158 then 4570:rem 'sys
3240 if b=159 then 7320:rem 'open
3250 if b=139 then 3630:rem 'if
3260 if b=160 then 7640:rem 'close
3270 if b=153 then 3820:rem 'print
3280 if b=152 then 8650:rem 'print#
3290 if b=151 then 4630:rem 'poke
3300 if b=161 then 8530:rem 'get
3310 if b=129 then 4280:rem 'for
3320 if b=130 then 4500:rem 'next
3330 if b=143 and p828(u)=36 then 6780:rem 'rem$
3340 if b=143 then return:rem 'rem
3350 if b=137 then a$=chr$($4c):goto 4220:rem 'goto
3360 if b=141 then a$=chr$($20):goto 4220:rem 'gosub
3370 if b=254 and p828(u)=2 then 4730:rem 'bank
3380 if b<48 or b>90 then 3420
3390 if b>64 then 3480
3400 if b<58 then u=0:b=$a9:goto 3350:rem 'goto
3410 rem command not found. show error
3420 print"{down}{reverse on}ERROR:";u    ;p828(u)
3430 ec=ec+1
3440 return
3450 rem -----
3460 rem"{ct n}  V=Ausdr."
3470 for i=0   to 140:p828(i)=p828(i+1):next
3480 u=0  :if p828(u)<65 or p828(u)>90 then 3420
3490 rem print "Var=Expr"
3500 v=p828(u)
3510 v$=chr$(v):u=u+1
3520 v=p828(u)
3530 if(v>64 and v<91)or(v>47 and v<58)then v$=v$+chr$(v):u=u+1:goto 3520
3540 if p828(u)<>178 then 3420:rem '=
3550 v1$=v$:u=u+1:gosub 1240:rem ausdruck auswerten
3560 v$=v1$:gosub 2510:rem variable auswerten
3565 rem d1=d
3570 a$=chr$($8d)+chr$(l)+chr$(h):gosub 440:rem " sta i"+v$
3575 d=d+1:gosub 2610
3580 a$=chr$($8e)+chr$(l)+chr$(h):gosub 440:rem " stx i"+v$+"+1"
3590 return
3600 rem -----
3610 :
3620 rem"{ct n}  IF/THEN"
3630 print "IF/THEN"
3640 gosub 1240:w=p828(u):if w<$b1 then 3420:rem '>
3650 if w>$b3 then 3420:rem '<
3651 rem ab hier nur '<, =, >
3660 rem a$=" sta 36: stx 37"
3661 a$=chr$($85)+chr$(36)+chr$($86)+chr$(37):gosub 440
3670 u=u+1
3680 if w=$b3 and p828(u)=$b1 then w=180:u=u+1:rem '<>
3690 if w=$b1 and p828(u)=$b3 then w=180:u=u+1:rem '><
3700 gosub 1240
3710 rem a$=" cpx 37: beq"
3711 a$=chr$($e4)+chr$(37)+chr$($f0):gosub 440
3720 cm$=chr$($c5)+chr$(36)
3730 a$=" l"+mid$(str$(l(ll)),2): d=la(ll):gosub 2610
3735 a$=""
3740 rem '<>
3741 if w=180 then a$=chr$(05)+chr$($d0)+chr$(07)+chr$($4c)+chr$(l)+chr$(h)+cm$+chr$($f0)+chr$($f9)
3750 rem '=
3751 if w=$b2 then a$=chr$(03)+chr$($4c)+chr$(l)+chr$(h)+cm$+chr$($d0)+chr$($f9)
3760 rem '<
3761 if w=$b3 then a$=chr$(07)+chr$($90)+chr$(2)+chr$($b0)+chr$(9)+chr$($4c)+chr$(l)+chr$(h)+cm$+chr$($90)+chr$($f9)+chr$($f0)+chr$($f7)
3770 rem '>
3771 if w=$b1 then a$=chr$(07)+chr$($b0)+chr$(2)+chr$($90)+chr$(9)+chr$($4c)+chr$(l)+chr$(h)+cm$+chr$($b0)+chr$($f9)+chr$($f0)+chr$($f7)
3780 gosub 440
3790 return
3800 rem -----
3810 rem"{ct n}  PRINT"
3820 w=p828(u):if w<32 then 4180
3830 if w=59 and p828(u+1)<32 then return
3840 if w=59 then u=u+1:goto 3820
3850 if w=199 then 3990:rem" CHR$
3860 if w=34  then 4050:rem" String
3870 rem -----
3880 rem"{ct n}  PRINT Ausdr."
3890 rem print#3," lda #29"
3900 rem print#3," jsr $ffd2"
3910 gosub 1240:rem a$=" stx 34: tax: lda 34":rem a/x tauschen
3920 g=g or 4
3930 a$=chr$($20)+chr$($23)+chr$($20):gosub 440:rem" jsr prtsgn" - zahl in a/x ausgeben
3940 rem c64 $bdcd, c128 $8e32, c65 $647f, m65 $????
3950 a$=chr$($a9)+" "+chr$($20)+chr$($d2)+chr$($ff):gosub 440:rem " lda #32: jsr $ffd2"
3960 goto 3820
3970 rem -----
3980 rem"{ct n}  PRINT CHR$(Ausdr.)"
3990 u=u+1:if p828(u)<>40 then 3420
4000 u=u+1:gosub 1240
4010 a$=chr$($20)+chr$($d2)+chr$($ff):gosub 440:rem " jsr $ffd2"
4020 u=u+1:goto 3820
4030 rem -----
4040 rem"{ct n}  PRINT String"
4050 a$=chr$($20)+chr$($7d)+chr$($ff):gosub 440:rem " jsr primm, $ff7d"
4060 g=g or 2
4070 rem a$=" .text '":gosub 440
4080 i=0
4090 i=i+1:u=u+1:if u>100 then 4150
4100 if i>20 then i=1:rem a$="'":a$=" .text '"
4110 if p828(u)=34 then 4150
4120 if p828(u)=0 then 4150
4130 a$=chr$(p828(u)):gosub 440
4140 goto 4090
4150 rem a$="'"
4160 a$=chr$(0):gosub 440:rem " .byte 0"
4170 u=u+1:goto 3820
4174 rem
4179 rem zeile abschliessen
4180 a$=chr$($a9)+chr$(13)+chr$($20)+chr$($d2)+chr$($ff):gosub 440:rem " lda #13: jsr $ffd2"
4190 return
4200 rem ------------------------------------
4210 rem"{ct n}  GOTO/GOSUB"
4215 rem ------------------------------------
4220 gosub 1820
4230 rem if v=0 then v$=mid$(str$(n),2)
4240 a$=a$+chr$(l)+chr$(h):gosub 440
4250 return
4260 rem ------------------------------------
4270 rem"{ct n}  FOR"
4275 rem ------------------------------------
4280 u=3:gosub 1240
4290 rem
4300 rem a1$=mid$(str$(lp(lp)),2)
4310 rem a$=" jmp lf"+a1$
4315 d=lf(lp):gosub 2610:a$=chr$($4c)+chr$(l)+chr$(h):gosub 440
4320 hu=u:u=1
4330 lp(lp)=pc:rem a$="f"+a1$+" ":gosub 440
4340 gosub 1030:u=hu+1
4350 rem a$=" sta 36: stx 37"
4351 a$=chr$($85)+chr$(36)+chr$($86)+chr$(37)
4356 gosub 440
4360 gosub 1240
4369 rem" cpx $25: beq 4: bcs 11
4370 a$=chr$($e4)+chr$($25)+chr$($f0)+chr$($04)+chr$($b0)+chr$($0b)
4371 gosub 440
4374 rem" bcc 6
4375 a$=chr$($90)+chr$($06)
4376 gosub 440
4379 rem" cmp $24: beq 2: bcs 3
4380 a$=chr$($c5)+chr$($24)+chr$($f0)+chr$($02)+chr$($b0)+chr$($03)
4381 gosub 440
4390 d=xa(la):gosub 2610
4395 a$=chr$($4c)+chr$(l)+chr$(h):gosub 440:rem" jmp ff"+a1$
4400 rem ohne step befehl, dann plus 1 " lda #1: ldx #0"
4405 if p828(u)<>169 then a$=chr$($a9)+chr$(1)+chr$($a2)+chr$(0):gosub440:goto 4420:rem 'step
4410 u=u+1:gosub 1240
4420 u=0  :b=170:gosub 1300:rem '+'
4430 d=pc:gosub 2610:
4440 lf(lp)=pc:rem"lf"+a1$+" "
4450 lp=lp+1
4460 u=1  :gosub 2430:goto 3570
4470 rem
4480 rem ------------------------------------
4490 rem"{ct n}  NEXT"
4495 rem ------------------------------------
4500 lp=lp-1
4510 rem a1$=mid$(str$(lp(lp)),2)
4515 d=lp(lp):gosub 2610
4520 a$=chr$($4c)+chr$(l)+chr$(h):gosub 440:rem" jmp f"+a1$
4525 xa(lp)=pc
4530 a$=chr$($ea):gosub 440:rem"ff"+a1$+" nop"
4540 return
4550 rem ------------------------------------
4560 rem"{ct n}  SYS"
4565 rem ------------------------------------
4570 gosub 1240
4580 a$=chr$($20)+chr$($e0)+chr$($20):rem" jsr syscall"
4590 gosub 440
4600 return
4610 rem ------------------------------------
4620 rem"{ct n}  POKE"
4625 rem ------------------------------------
4630 gosub 1240
4640 a$=chr$($85)+chr$(36)+chr$($86)+chr$(37):rem" sta 36: stx 37"
4650 gosub 440
4660 rem
4670 if p828(u)<>44 then 3420
4680 u=u+1:gosub 1240
4690 a$=chr$($a0)+chr$(0)+chr$($a2)+chr$(36):rem" ldy #0: ldx #36"
4695 gosub 440
4700 a$=chr$($20)+chr$($fa)+chr$($20):rem" jsr poke"
4710 return
4720 rem"{ct n}  BANK"
4730 u=u+1:gosub 1240
4750 a$=chr$($8d)+chr$($d1)+chr$(2):rem" sta $2d1"
4760 return
4770 rem
4780 :
4785 rem ------------------------------------
4790 rem"{ct n}  END, STOP"
4800 rem ------------------------------------
4810 if pa<2 then pc=pc+3:goto 4830
4820 d=vo-1:gosub 2610
4825 a$=chr$($4c)+chr$(l)+chr$(h):gosub 440
4830 return
5300 rem ------------------------------------
5310 rem"{ct n}  *** INIT ***"
5320 rem ------------------------------------
5330 :
5340 if pa>1 then 5500
5350 dim n(200)
5360 rem dim a(200)    :rem opcodes fuer ausgabe
5370 dim sc(200)   :rem string konstante
5380 dim l(800)    :rem relevante zeilennummern; jetzt alle Zeilennummern
5385 dim la(800)   :rem und ihre addressen
5390 dim t$(200)
5400 dim lp(10),lf(10):rem for..next schleifen adressen
5410 dim xa(10)    :rem for..next adressen
5420 dim v$(200)   :rem variable names
5422 dim va(200)   :rem variablen adressen
5430 dim p828(200) :rem read buffer, c64: ab 828, c128: ab adr 2816
5440 l=0:rem  pointer to ll() line number
5445 lp=0:rem loop ptr, index fuer for-next
5450 xa=0:rem
5455 vp=0:rem max. index variable pointer
5460 vo=0:rem variable offset; startadresse var table
5470 ve=0:rem variable area end. beginning of constant strings (e.g. filenames)
5480 sc=0:rem max entry in sc()
5490 :
5500 a=0:rem
5505 b=0:rem
5510 u=0:rem index to p828()
5515 i=0:rem
5520 j=0:rem
5525 k=0:rem
5530 m=0:rem index s()
5535 v=0:rem
5540 d=0:rem
5545 c=0:rem
5550 h=0:rem
5560 q=0:rem  quote flag (inside strings)
5570 w=0:rem
5580 z=0: rem ascflag
5620 ec=0:rem error counter
5630 c$=chr$(34):z$=chr$(0):cr$=chr$(13)
5635 op=0: pc=$2200:rem program counter
5640 t1%=0:rem ti startwert
5650 :
5660 foreground 15:background 0
5670 s$="test.bas":s=49152
5690 print:input "Quellfile (*=Ende) ";s$
5700 restore:if s$="*" or s$="" then end
5710 rem input "Startadr. ";s:print
5720 rem a1$=s$:gosub 520
5730 return
6000 rem --------------------------------------------
6010 rem"{ct n}  Ende"
6015 rem --------------------------------------------
6020 rem print "End of input file"
6030 l(ll)=65535
6040 a$=chr$($60):gosub 440
6050 vo=pc:rem start der tabelle merken fuer pass2
6440 rem a$="endstop rts":rem c64= jmp $a474, m65=?
6450 rem print "z=";z:if z>127 then 6550: rem flag: no vars
6460 if vp=0 then 6550: rem jump, if no var read
6470 if pa>1 then print"variable ($";hex$(vo);")"
6480 a$=chr$(0)+chr$(0):rem 2 byte je variable
6490 for i=0 to vp-1
6500 if pa=1 then va(i)=pc:rem adresse der variablen speichern
6510 gosub 440:rem "i"+v$(i)+" .word 0"
6520 next i
6540 :
6550 rem a$=" .end"
6560 if pa=2 then print#3,chr$(0);
6570 dclose#2:dclose#3:rem print "close 2:close 3"
6580 :
6590 print"{down}Errors";ec
6600 t1%=ti-t1%:if pa=2 then print s$;" compiliert";", Zeit:";t1%;"ticks"
6610 return:rem end
6620 rem --------------------------------------------
6630 :
6640 :
6650 rem"{ct n} TBC-Lib"
6660 data  01,20,1e,20,e7,07,de,9c, 3a,fe,02,30,3a,9e,38,32:rem 0000
6665 data  32,34,3a,8f,54,42,43,20, 32,33,31,32,32,33,00,00:rem 0010
6670 data  00,4c,00,22,85,16,86,17, 24,17,10,1b,48,a9,2d,20:rem 0020
6675 data  d2,ff,38,a9,00,e5,16,85, 16,a9,00,e5,17,85,17,68
6680 data  4c,46,20,85,16,86,17,a9, 00,8d,88,20,a0,08,a2,ff
6685 data  38,a5,16,f9,89,20,85,16, a5,17,f9,8a,20,85,17,e8
6690 data  b0,ef,a5,16,79,89,20,85, 16,a5,17,79,8a,20,85,17
6695 data  8a,d0,07,ad,88,20,d0,09, f0,0a,a2,30,8e,88,20,09
6700 data  30,20,d2,ff,88,88,10,c6, 60,00,01,00,0a,00,64,00
6705 data  e8,03,10,27,85,63,86,64, a2,00,86,65,86,66,a0,10
6710 data  90,22,06,61,26,62,26,65, 26,66,38,a5,65,e5,63,aa
6715 data  a5,66,e5,64,90,06,86,65, 85,66,e6,61,88,d0,e3,a5
6720 data  61,a6,62,60,46,66,66,65, 66,62,66,61,88,30,f0,90
6725 data  f3,18,a5,65,65,63,85,65, a5,66,65,64,85,66,18,90
6730 data  e3,85,04,86,05,a5,1a,85, 02,ad,04,11,48,a9,01,1c
6735 data  04,11,20,6e,ff,68,8d,04, 11,58,60,08,db,ab,d1,02:rem 00f0
6740 data  20,77,ff,fb,28,60,08,db, da,aa,ab,d1,02,b5,01,c9:rem 0100
6745 data  20,b0,02,a3,00,20,74,ff, fa,fb,28,29,ff,60,55,55:rem 0110
6747 data  55,55,55,55,55,55,55,55, 55,55,55,55,55,55,55,55:rem 0120
6748 data  55,55,55,55,55,55,55,55, 55,55,55,55,55,55,55,55:rem 0130
6749 data  55,55,55,55,55,55,55,55, 55,55,55,55,55,55,55,55:rem 0140
6750 data  55,55,55,55,55,55,55,55, 55,55,55,55,55,55,55,55:rem 0150
6751 data  55,55,55,55,55,55,55,55, 55,55,55,55,55,55,55,55:rem 0160
6752 data  55,55,55,55,55,55,55,55, 55,55,55,55,55,55,55,55:rem 0170
6753 data  55,55,55,55,55,55,55,55, 55,55,55,55,55,55,55,55:rem 0180
6754 data  55,55,55,55,55,55,55,55, 55,55,55,55,55,55,55,55:rem 0190
6755 data  55,55,55,55,55,55,55,55, 55,55,55,55,55,55,55,55:rem 01a0
6756 data  55,55,55,55,55,55,55,55, 55,55,55,55,55,55,55,55:rem 01b0
6757 data  55,55,55,55,55,55,55,55, 55,55,55,55,55,55,55,55:rem 01c0
6758 data  55,55,55,55,55,55,55,55, 55,55,55,55,55,55,55,55:rem 01d0
6759 data  55,55,55,55,55,55,55,55, 55,55,55,55,55,55,55,55:rem 01e0
6760 data  55,55,55,55,55,55,55,55, 55,55,55,55,55,55,55,55:rem 01f0
6761 data  55,*                                            :rem 0200
6762 rem
6765 rem
6770 rem"{ct n}  REM$" - compiler flags
6780 u=u+2:w=p828(u-1)
6785 if w<>86 then 6810:rem v (print var def in assembler output)
6790 z=z and 127
6800 return
6810 if w<>78 and p828(u)<>86 then 6830:rem nv (print no vars in assembler output)
6820 z=z or 128:return
6830 if w<>81 then 6910:rem q (quit compiler if error count >0)
6840 if ec=0 then return
6850 :
6860 dclose#3:dclose#2:rem print "close 2:close 3"
6870 :
6880 print:print"***Abgebrochen nach";ec;"Fehler(n)"
6890 end
6900 :
6910 if w<>65 then 6970:rem a (insert assembler command)
6920 u=u+1
6930 w=p828(u):u=u+1
6940 if w>0 then a$=chr$(w):gosub 440:goto6930
6950 a$="":gosub 320
6960 return
6970 if w<>76 then return:rem l (include mul/div library)
6980 z=z or 64
6990 return
7000 :
7299 rem -----------------------------------------
7300 rem"{ct n}  OPEN"
7301 rem -----------------------------------------
7310 :
7320 gosub 1240:a$=" pha":gosub 320:rem parameter fn
7330 if p828(u)<>44 then 3420
7340 u=u+1:gosub 1240:a$=" pha":gosub 320:rem parameter gn
7350 if p828(u)<>44 then 3420
7360 u=u+1:gosub 1240:a$=" pha":gosub 320:rem parameter sa
7370 if p828(u)<>44 then 3420
7380 l$="":u=u+1
7390 if p828(u)<>34 then 7460
7399 rem filename in ""
7400 u=u+1:w=p828(u):if w=0 or w=34 then 7420
7410 l$=l$+chr$(w)
7430 goto 7400
7420 sc(sc)=l$:sc=sc+1
7430 goto 7540
7440 :
7450 rem -----
7460 if p828(u)<>199 then 3420:rem chr$()
7470 u=u+1:if p828(u)<>40 then 3420: rem '('
7480 u=u+1:gosub 1240
7489 rem a$=" sta"+str$(511+len(l$)):gosub 320
7490 d=vo+len(l$):gosub 2610:l$=l$+" "
7495 a$=chr$($xx)+chr$(l)+chr$(h):gosub 440
7500 u=u+1:if p828(u)=0 then 7540
7510 if p828(u)<>$aa then 3420:rem '+'
7520 u=u+1:goto 7460
7530 :
7540 rem a$=" lda #"+len(l$)+";open"
7545 a$=chr$($lda)+chr$(len(l$)):gosub 440
7550 rem a$=" ldy #2:ldx #0"
7560 rem a$=" jsr $ffbd"
7570 rem a$=" pla: tay: pla: tax: pla"
7580 rem a$=" jsr $ffba"
7590 rem a$=" jsr $ffc0"
7595 
7600 return
7610 :
7619 rem -----------------------------------------
7620 rem"{ct n}  CLOSE"
7621 rem -----------------------------------------
7630 :
7640 a$=" jsr $ffcc ;clrchn":gosub 320
7650 gosub 1240
7660 a$=" jsr $ffc3 ;close":gosub 320
7670 return
7680 :
8500 rem -----------------------------------------
8510 rem"{ct n}  GET#"
8515 rem -----------------------------------------
8520 :
8530 b=p828(u):if b<>35 then 8570:rem '#'
8540 u=u+1:gosub 1240:
8550 a$=" tax: jsr $ffc6 ;chkin":gosub 320
8560 u=u+1
8570 a$=" jsr $ffe4 ;getin":gosub 320
8580 gosub 1820:if v=0 then 3420
8590 a$=" ldx #0: sta i"+v$+": stx i"+v$+"+1":gosub 320
8600 if b=35 then a$=" jsr $ffcc ;clrchn":gosub 320
8610 return
8620 rem -----------------------------------------
8630 rem"{ct n}  PRINT#"
8635 rem -----------------------------------------
8640 :
8650 gosub 1240
8660 a$=" tax: jsr $ffc9 ;chkout":gosub 320
8670 u=u+1
8680 gosub 3820
8690 a$=" jsr $ffcc ;clrchn":gosub 320
8700 return
8710 rem
9000 rem ----------

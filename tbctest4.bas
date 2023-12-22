  100 print "tbctest 4 - if..then"
  110 a=12
  120 a=a*3
  130 print "a = 36:  ";
  140 if a=36 then 170
  150 print "error"
  160 goto 180
  170 print "ok"
  180 print "a < 128: ";
  190 if a<128 then 220
  200 print  "error"
  210 goto 230
  220 print "ok"
  230 print "a >  34: ";
  240 if a>34 then 270
  250 print "error"
  260 goto 280
  270 print "ok"
  280 print "a <= 36: ";
  290 if a <= 36 then 320
  300 print  "error"
  310 goto 330
  320 print "ok"
  330 print "a >= 34: ";
  340 if a >= 34 then 370
  350 print "error"
  360 goto 380
  370 print "ok"
  380 print "a <> 42: ";
  390 if a <> 42 then 420
  400 print "error"
  410 goto 430
  420 print "ok"
  430 end

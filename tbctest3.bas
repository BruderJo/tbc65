   10 print "tbctest 3 - goto,gosub"
   20 goto 100
   30 print "zeile 30"
   35 gosub 200
   40 print "zeile 40"
   50 end
  100 print "zeile 100"
  110 goto 30
  200 print "zeile 200"
  210 return

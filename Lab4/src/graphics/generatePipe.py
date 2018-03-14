#!/usr/bin/python
with open('pipe.txt', 'r') as file:
    i=0
    j=0
    firstPrint=True
    while True:
        c = file.read(1)
        if not c:
            break
        if (i==0):
            if (j==0):
                print 'else if (((vc >= pipe1_min_y - 2 && vc < pipe1_min_y) || (vc >= pipe1_max_y && vc < pipe1_max_y + 2)) && (hc >= pipe1_min_x && hc < pipe1_max_x))'
                print '   showBlack();'
                print 'else if (((vc >= pipe1_min_y - 4 && vc < pipe1_min_y - 2) || (vc >= pipe1_max_y + 2 && vc < pipe1_max_y + 4)) && (hc >= pipe1_min_x && hc < pipe1_max_x)) begin'
            elif (j==1):
                print 'else if (((vc >= pipe1_min_y - 16 && vc < pipe1_min_y - 4) || (vc >= pipe1_max_y + 4 && vc < pipe1_max_y + 16)) && (hc >= pipe1_min_x && hc < pipe1_max_x)) begin'
            elif (j==2):
                print 'else if (((vc >= pipe1_min_y - 18 && vc < pipe1_min_y - 16) || (vc >= pipe1_max_y + 16 && vc < pipe1_max_y + 18)) && (hc >= pipe1_min_x && hc < pipe1_max_x)) begin'
            elif (j==3):
                print 'else if (((vc >= pipe1_min_y - 20 && vc < pipe1_min_y - 18) || (vc >= pipe1_max_y + 18 && vc < pipe1_max_y + 20)) && (hc >= pipe1_min_x && hc < pipe1_max_x))'
                print '   showBlack();'
                print 'else if ((vc < pipe1_min_y - 18 || vc >= pipe1_max_y + 20) && (hc >= pipe1_min_x + 2 && hc < pipe1_max_x - 2)) begin'
            firstPrint=True
        if c!='e' and c!='\n':
            if firstPrint:
                print '   if (hc == pipe1_min_x + '+str(i)+')'
                firstPrint=False
            else:
                print '   else if (hc == pipe1_min_x + '+str(i)+')'
            if c=='m':
                print '      showMediumGreen();'
            elif c=='l':
                print '      showLightGreen();'
            elif c=='g':
                print '      showGreen();'
            elif c=='d':
                print '      showDarkGreen();'
            elif c=='b':
                print '      showBlack();'
        if c=='\n':
            print 'end'
            i=0
            j=j+1
        else:
            i=i+1;
with open('pipe.txt', 'r') as file:
    i=0
    j=0
    firstPrint=True
    while True:
        c = file.read(1)
        if not c:
            break
        if (i==0):
            if (j==0):
                print 'else if (((vc >= pipe2_min_y - 2 && vc < pipe2_min_y) || (vc >= pipe2_max_y && vc < pipe2_max_y + 2)) && (hc >= pipe2_min_x && hc < pipe2_max_x))'
                print '   showBlack();'
                print 'else if (((vc >= pipe2_min_y - 4 && vc < pipe2_min_y - 2) || (vc >= pipe2_max_y + 2 && vc < pipe2_max_y + 4)) && (hc >= pipe2_min_x && hc < pipe2_max_x)) begin'
            elif (j==1):
                print 'else if (((vc >= pipe2_min_y - 16 && vc < pipe2_min_y - 4) || (vc >= pipe2_max_y + 4 && vc < pipe2_max_y + 16)) && (hc >= pipe2_min_x && hc < pipe2_max_x)) begin'
            elif (j==2):
                print 'else if (((vc >= pipe2_min_y - 18 && vc < pipe2_min_y - 16) || (vc >= pipe2_max_y + 16 && vc < pipe2_max_y + 18)) && (hc >= pipe2_min_x && hc < pipe2_max_x)) begin'
            elif (j==3):
                print 'else if (((vc >= pipe2_min_y - 20 && vc < pipe2_min_y - 18) || (vc >= pipe2_max_y + 18 && vc < pipe2_max_y + 20)) && (hc >= pipe2_min_x && hc < pipe2_max_x))'
                print '   showBlack();'
                print 'else if ((vc < pipe2_min_y - 18 || vc >= pipe2_max_y + 20) && (hc >= pipe2_min_x + 2 && hc < pipe2_max_x - 2)) begin'
            firstPrint=True
        if c!='e' and c!='\n':
            if firstPrint:
                print '   if (hc == pipe2_min_x + '+str(i)+')'
                firstPrint=False
            else:
                print '   else if (hc == pipe2_min_x + '+str(i)+')'
            if c=='m':
                print '      showMediumGreen();'
            elif c=='l':
                print '      showLightGreen();'
            elif c=='g':
                print '      showGreen();'
            elif c=='d':
                print '      showDarkGreen();'
            elif c=='b':
                print '      showBlack();'
        if c=='\n':
            print 'end'
            i=0
            j=j+1
        else:
            i=i+1;

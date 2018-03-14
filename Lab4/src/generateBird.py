#!/usr/bin/python
with open('bird.txt', 'r') as file:
    i=0
    j=0
    while True:
        c = file.read(1)
        if not c:
            break
        if c!='e' and c!='\n':
            print 'else if (hc == bird_min_x + '+str(i)+' && vc == bird_min_y + '+str(j)+')'
            if c=='b':
                print "   showBlack();"
            elif c=='w':
                print "   showWhite();"
            elif c=='y':
                print "   showYellow1();"
            elif c=='g':
                print "   showYellow2();"
            elif c=='o':
                print "   showOrange();"
        if c=='\n':
            i=0
            j=j+1
        else:
            i=i+1;

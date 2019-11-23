c
c
        implicit real*8 (a-h,o-z)
        character*3 endmark
        dimension ee1(100),ee2(100),fac1(100),fac2(100)
        dimension e1out(100),e2out(100)
c*****************************************
        print*,'# '
        print*,'# range make for v-system. '
        print*,'# '
c*****************************************
        read(10,*) e1,e2

        print*,'# Elow & Eup = ',e1,e2
        de = e2 - e1
        print*,'# DE = ',de

        print*,'# '

        read(10,*) nst
        print*,' N of v states = ',nst
        print*,' ================================================'
c****
        emin= 10000000.0
        emax=-10000000.0

        do kk=nst,1,-1
          read(10,*) idum,ee1(kk),ee2(kk),fac1(kk),fac2(kk)
          write(6,122) idum,ee1(kk),ee2(kk),fac1(kk),fac2(kk)
122       format('# Input:',i3,5(2x,f10.2))

          e1out(kk)=e1+ee1(kk)*de
          e2out(kk)=e1+ee2(kk)*de

          deltae = e2out(kk) - e1out(kk)
          write(6,173) ee1(kk),ee2(kk),e1out(kk),e2out(kk),deltae
173       format('#   range: ',f10.2,2x,f10.2,' ---> ',f10.2,2x,f10.2,
     *            ' : DE = ',f10.2)
          print*,' '

          if(e1out(kk).lt.emin) emin=e1out(kk)
          if(e2out(kk).gt.emax) emax=e2out(kk)

        enddo
c********
        idev= 20

        write(idev,153) nst
153     format("; n of v states ", / ,i3)
        write(idev,154) 
154     format("     <-- input an interval (steps) ")

        do ii=1,nst
          write(idev,152) ii
152       format("; range ",i3)

          write(idev,111) e1out(ii),e2out(ii)
111       format(f12.3,2x,f12.3)
          write(idev,113) fac1(ii),fac2(ii)
113       format(f8.3,2x,f8.3)
        enddo

        write(idev,174)
174     format("; coefs ",/," <-- insert lines ")
!174     format("; coefs ",/,/," <-- insert lines ",/)
        write(idev,112)
112     format("300.0")
c********
        read(10,394) endmark
394     format(a3)

        if(endmark.ne."END") then
          print*,' ?????????????????????????'
          print*,' ? No end mark detected. ?'
          print*,' ?????????????????????????'
          stop
        endif
c****
c Check.
        if(e2.ne.emax) then
          print*,'????????????????????????????'
          print*,'? Strange in the naxium E. ?'
          print*,'????????????????????????????'
          print*,' e2 = ',e2
          print*,' emax = ',emax
          stop
        endif

        if(e1.ne.emin) then
          print*,'?????????????????????????????'
          print*,'? Strange in the minimum E. ?'
          print*,'?????????????????????????????'
          print*,' e2 = ',e2
          print*,' emax = ',emax
          stop
        endif
c*****************************************
        stop
        end

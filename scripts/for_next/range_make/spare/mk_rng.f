c
c
c*****************************************
        print*,'# '
        print*,'# range make for v-McMD. '
        print*,'# '
c*****************************************

        read(10,*) e1,e2

        print*,'# Elow & Eup = ',e1,e2
        de = e2 - e1
        print*,'# DE = ',de

        print*,'# '

        read(10,*) nst
        print*,' N of v states = ',nst

        emin= 10000000.0
        emax=-10000000.0

cc      do kk=1,nst
        do kk=nst,1,-1
          read(10,*) idum,ee1,ee2,fac1,fac2
          print*,'# Input:',idum,ee1,ee2,fac1,fac2
          write(6,122) idum,ee1,ee2,fac1,fac2
122       format('# Input:',i3,5(2x,f10.2))

          e1out=e1+ee1*de
          e2out=e1+ee2*de

          write(9,133) e1out,kk
          write(9,133) e2out,kk
133       format(f10.2,2x,i3)
          print*,'#    range: ',ee1,ee2,' ---> ',e1out,e2out

          if(e1out.lt.emin) emin=e1out
          if(e2out.gt.emax) emax=e2out

          idev=100+kk
          write(idev,111) e1out,e2out
111       format(f8.1,2x,f8.1)
          write(idev,112)
          write(idev,113) fac1,fac2
112       format("300.0")
113       format(f5.3,2x,f5.3)

        enddo
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

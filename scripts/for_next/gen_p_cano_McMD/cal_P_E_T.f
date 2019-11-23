c
c  The discontinuous ln[n(E)] --> continuous ln[n(E)].
c
c*******************************************************************
        implicit real*8 (a-h,o-z)

        parameter (ndat=100000)
        dimension xx(ndat),yy(ndat)
c*******************************************************************
c  Set general parameter(s).
        rgas=8.31451d0/4.184d0/1000.0d0
c*******************************************************************
c  Input T.

        read(5,*) temp
        print*,' '
        print*,'  T (K) = ',temp
        print*,' '
c****
c  Input ln[n(E)].

        icou=0

800     continue

        read(20,*,end=900) aaa,bbb
        icou=icou+1

        xx(icou)=aaa
        yy(icou)=bbb

        goto 800
c****
900     continue

         print*,'  N of inpit data = ',icou
c****
c  Calculate ln[P(E,T)].

        do ii=1,icou
          yy(ii)= -xx(ii)/rgas/temp + yy(ii) 
        enddo
c****
c  Normalization.

        amax=-100000.0

        do ii=1,icou
          if(yy(ii).gt.amax) amax=yy(ii)
        enddo
        do ii=1,icou
          yy(ii)=yy(ii)-amax
          write(40,133) xx(ii),yy(ii)
        enddo

133     format(f12.3,2x,e20.8)
c*******************************************************************
        stop
        end

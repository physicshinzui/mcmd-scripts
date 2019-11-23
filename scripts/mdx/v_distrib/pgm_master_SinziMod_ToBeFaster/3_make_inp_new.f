
c******************************************************
        include "COMDAT"

        dimension iweight(1000)
c******************************************************
cc      print*,' '
cc      print*,'  1) Input inp_c1_all. '
cc      print*,'  2) Input weight information.'
cc      print*,'  3) Output inp_c1_all_new.'
cc      print*,' '
c********************************************
c  Parameter input field.

        read(10,*) de,nene
        read(10,*) emin1
        read(10,601) mark
601     format(a3)

        if(nene.gt.nwin) then
          print*,' ??????????????????????'
          print*,' ? nwin is too small. ?'
          print*,' ??????????????????????'
          print*,' nwin = ',nwin
          print*,' nene = ',nene
          stop
        endif

        if(mark.ne."END") then
          print*,' ??????????????????????????'
          print*,' ? No end mark (1). stop. ?'
          print*,' ??????????????????????????'
          stop
        endif
c****
        read(10,*) nfil

        if(nfil.le.0 .or. nfil.gt.nfilmx) then
          print*,' ????????????????????????'
          print*,' ? Detected wrong nfil. ?'
          print*,' ????????????????????????'
          print*,'  nfil (input) = ',nfil
          print*,'  nfilmx (COMMON) = ',nfilmx
          stop
        endif

        do kk=1,nfil
          read(10,*) kdum,nst(kk),nen(kk),wgt(kk)
        enddo

        read(10,601) mark

        if(mark.ne."END") then
          print*,' ??????????????????????????'
          print*,' ? No end mark (3). stop. ?'
          print*,' ??????????????????????????'
          stop
        endif

c  End of parameter input.
c********************************************
c  Input weight information.

        do ii=1,nfil
          read(55,*) idum,av_lambda(ii)
cc        write(6,499) idum,av_lambda(ii)
        enddo
499     format(i4,2x,f16.5)
c********************************************
c  Assign weights to trajectories.

        fac = 1.0d0
cc      fac = 1.5d0

        fac1=1.0d0
        fac2=1.0d0*fac**1
        fac3=1.0d0*fac**2
        fac4=1.0d0*fac**3
        fac5=1.0d0*fac**4
        fac6=1.0d0*fac**5
        fac7=1.0d0*fac**6
        fac8=1.0d0*fac**7

        print*,' '
        print*,' '
        print*,'      fac1 = ',fac1
        print*,'      fac2 = ',fac2
        print*,'      fac3 = ',fac3
        print*,'      fac4 = ',fac4
        print*,'      fac5 = ',fac5
        print*,'      fac6 = ',fac6
        print*,'      fac7 = ',fac7
        print*,'      fac8 = ',fac8
        print*,' '
        print*,'     If you want to change the factors,'
        print*,'     change this source program. '
        print*,' '

        do ii=1,nfil

          if(av_lambda(ii).lt.11.5d0) then
            wgt(ii)= fac8
            goto 889
          endif

          if(av_lambda(ii).lt.12.0d0) then
            wgt(ii)= fac7
            goto 889
          endif

          if(av_lambda(ii).lt.12.5d0) then
            wgt(ii)= fac6
            goto 889
          endif

          if(av_lambda(ii).lt.13.0d0) then
            wgt(ii)= fac5
            goto 889
          endif

          if(av_lambda(ii).lt.13.5d0) then
            wgt(ii)= fac4
            goto 889
          endif

          if(av_lambda(ii).lt.14.0d0) then
            wgt(ii)= fac3
            goto 889
          endif

          if(av_lambda(ii).lt.14.5d0) then
            wgt(ii)= fac2
            goto 889
          endif

          wgt(ii)= fac1

889       continue
        enddo
c********************************************
        write(66,701) de,nene
        write(66,702) emin1
        write(66,703) mark

701     format(f16.7,i6)
702     format(f16.7)
703     format(a3)

        write(66,705) nfil
705     format(i4)

        do kk=1,nfil
          write(66,704) kk,nst(kk),nen(kk),wgt(kk)
        enddo
704     format(i4,2x,i6,2x,i12,2x,f16.5)

        write(66,703) mark
c********************************************
        stop
        end

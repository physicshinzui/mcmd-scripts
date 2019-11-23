c******************************************************
        implicit real*8 (a-h,o-z)
        parameter (nwin=20000)

        common/dat1/pdf1(nwin)
        common/dat2/nst(10000),nen(10000),nwgt(10000)
        common/dat4/epdf(nwin),epos(nwin)

        character mark*3
        character,dimension(10000) :: filname*60
        character awork*1

c******************************************************
        print*,' ********************************************'
        print*,' * Out the ene. dist. in natural-log scale. *'
        print*,' ********************************************'
        print*,'    If pdf(E) = zero at a point of E, set ln[pdf] = 0.'
        print*,' '
c*******************
c  Parameter input filed.

        read(5,*) de,ne
        read(5,*) emin1
        read(5,601) mark
601     format(a3)

        if(mark.ne."END") then
          print*,' ??????????????????????????'
          print*,' ? No end mark (1). stop. ?'
          print*,' ??????????????????????????'
          stop
        endif

        read(5,*) nfil

        if(nfil.le.0) then
          print*,' ??????????????????????????'
          print*,' ? Detected: nfil .le. 0. ?'
          print*,' ??????????????????????????'
          stop
        endif

        do kk=1,nfil
          read(5,*) kdum,nst(kk),nen(kk),nwgt(kk)
        enddo

        read(5,601) mark

        if(mark.ne."END") then
          print*,' ??????????????????????????'
          print*,' ? No end mark (2). stop. ?'
          print*,' ??????????????????????????'
          stop
        endif

        if(ne.gt.nwin) then
          print*,' ????????????????????????????????'
          print*,' ? parameter nwin is too small. ?'
          print*,' ????????????????????????????????'
          stop
        endif
c****
c  Getting input file name.

        open(unit=15,file="file.name",status="old")
        do kk=1,nfil
          read(15,334) filname(kk)
          print*,'  file names = ',filname(kk)
        enddo
        close(15)
334     format(a60)

        write(6,260) nfil
260     format('       N of input files = ',i3)
        print*,' '
c****
c  Output the parameters to the monitor file.

        do kk=1,nfil
          write(6,278) kk,nst(kk),nen(kk),nwgt(kk)
        enddo

278     format('   fil.; used traj. intv.; weight = ',
     *          i4,2x,i7,2x,i9,2x,i2)
279     format('   fil.; used traj. intv.; weight = ',
     *          i4,2x,i7,2x,i9,2x,f10.5)

        write(6,633)
633     format("  The weight is used only to calc. pdf. ",
     *           "Not used for calculating <E> and SD.")
        print*,' '

        write(6,274) de,ne,emin1
274     format('   bin size, N(bin), E(min) = ',f6.3,2x,i6,2x,f12.3)
c*******************
c  Initializing.

        icou=0
        kktot=0

        av1=0.0
        fl1=0.0

        do jj=1,nwin
          pdf1(jj)=0.0
        enddo

        emin1=emin1 -de/2.0
        print*, "@emin1 -de/2.0=", emin1

        icou1=0

        elowf1=10000.0d0
        emaxf1=-10000000.0d0
c********
c  Loop over input files.
        
        do mm=1,nfil
          idevin=100+mm
          kkone=0
          open(unit=idevin,file=filname(mm),status="old")

          print*,'  Input file No. = ',mm
          print*,'       file name: ',filname(mm)
c**
c  Loop over conformations in an input file.

888       continue

c  data input.
          read(idevin,*, end=900) a1

          kktot=kktot+1
          kkone=kkone+1

c  Pick up the data for statistics.
          if(kkone.gt.nst(mm) .and. kkone.le.nen(mm)) then
            icou=icou+1

            av1=av1+a1
            fl1=fl1+a1**2

c  Sum up for pdf.
            if(a1.lt.emin1) then 
              goto 750
            endif 
            e1=a1-emin1
            jj=int(e1/de)+1

            if(jj.gt.ne) then 
              print*, jj, ">", ne
              stop
              !goto 750
            endif

            icou1=icou1 + nwgt(mm)
            pdf1(jj)=pdf1(jj) + real(nwgt(mm))

            if(a1.lt.elowf1) elowf1=a1
            if(a1.gt.emaxf1) emaxf1=a1

750         continue
          endif

          goto 888

900       continue

          close(idevin)
        enddo

c  End of data input.
c********
c  Output the statisctics to the monitor file.

        print*,'  N of input data = ',kktot
        print*,'  N of used  data = ',icou
        print*,' '

        av1=av1/real(icou)

        fl1=fl1/real(icou)
        fl1=fl1-av1**2
        fl1=sqrt(fl1)

        write(6,200) av1,fl1,elowf1,emaxf1
200     format("  <E1>, SD, E1(min & max) = ",e14.6,2x,e14.6,1x,2f10.1)
c*******************
c  Output the generated pdf.

        do ii=1,ne
          e1=emin1+(ii-1)*de+de/2.0
          aa=pdf1(ii)/real(icou1)
          if(aa.ne.0.0) then
            aa=log(aa)
          endif
          write(20,612) e1,aa

          epdf(ii)=aa
          epos(ii)=e1
        enddo

612     format(e15.7,2x,e15.7)
c******************************************************
        stop
        end

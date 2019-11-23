
        subroutine para_inp
c******************************************************
        include "COMDAT"
c******************************************************
        print*,' '
        print*,' ************************'
        print*,' * Subroutine para_inp. *'
        print*,' ************************'
        print*,'  1) Input some parameters. '
        print*,'  2) Input file names for input. '
        print*,'  3) Initialize some quantities. '
        print*,' '
c********************************************
c  Parameter input field.

        read(5,*) de,nene
        read(5,*) emin1
        read(5,601) mark
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
        read(5,*) nfil

        if(nfil.le.0 .or. nfil.gt.nfilmx) then
          print*,' ????????????????????????'
          print*,' ? Detected wrong nfil. ?'
          print*,' ????????????????????????'
          print*,'  nfil (input) = ',nfil
          print*,'  nfilmx (COMMON) = ',nfilmx
          stop
        endif

        do kk=1,nfil
          read(5,*) kdum,nst(kk),nen(kk),wgt(kk)
        enddo

        read(5,601) mark

        if(mark.ne."END") then
          print*,' ??????????????????????????'
          print*,' ? No end mark (3). stop. ?'
          print*,' ??????????????????????????'
          stop
        endif

c  End of parameter input.
c********************************************
c  Getting input file names.

c  1) Real quantity file.

        open(unit=15,file="file.name",status="old")
        do kk=1,nfil
          read(15,334) filname(kk)
        enddo
        close(15)
334     format(a80)

c  2) Virtual quantity file.

        open(unit=16,file="filev.name",status="old")
        do kk=1,nfil
          read(16,334) filnamev(kk)
        enddo
        close(16)

c  3) Initial virtual no. (start.vart).
        open(unit=17,file="files.name",status="old")
        do kk=1,nfil
          read(17,334) filnames(kk)
        enddo
        close(17)

        write(6,260) nfil
260     format('       N of input files = ',i4)
        print*,' '
c********************************************
c  Output the parameters to the monitor file.

        write(6,274) de,nene,emin1
274     format('       bin size, N(bin), E(min) = ',
     *                               f7.3,2x,i6,2x,f12.3)
c********************************************
c  Initializing counter.

        do mm=1,nvert
          c_icou(mm)=0
          c_icou_rng(mm)=0
        enddo

        kktot=0
        tot=0
c********************************************
c  Input the range for each v-state.
        read(22,*)
        read(22,*) mvert
        read(22,*) intv_v

        do ii=1,mvert
          read(22,*)
          read(22,*) rng(1,ii),rng(2,ii)
          read(22,*)
        enddo

        write(6,420) mvert
420     format('  N of v states = ',i3)
        do ii=1,mvert
          write(6,422) ii,rng(1,ii),rng(2,ii)
        enddo
422     format('  range: ',i3,2x,f12.2,2x,f12.2)
c********************************************
c  Store the ranges of all bins.

          do kk=1,nene
            x1=de*(kk-1) + emin1
            x2=de*kk + emin1
            binpos(1,kk)=x1
            binpos(2,kk)=x2
          enddo

c  Correction if an small numerical error happens.
          do kk=1,nene-1
            if(binpos(2,kk).ne.binpos(1,kk+1)) then
              print*,' ???  bin pos mismatch --> correction ??? '
              print*,'  inpos(2,kk) & binpos(1,kk+1) =',
     *                 kk,binpos(2,kk),binpos(1,kk+1)

              aa=binpos(2,kk)
              bb=binpos(1,kk+1)
              cc=(aa+bb)/2.0d0
              binpos(2,kk)=cc
              binpos(1,kk+1)=cc
            endif
          enddo
c********
c  Higo check again this part later.
c  This part is very important.

c  emin is shifted by half of DE. <-- This is for safety. Not important.
cc      emin1=emin1 - de/2.0

        epsw=0.000001d0

        do mm=1,mvert
          do jj=1,nwin
            pdf(jj,mm)=0.0d0
            wbin(jj,mm)=0.0d0
          enddo

          ipos_bin(1,mm)=0
          ipos_bin(2,mm)=0
        enddo

        do jj=1,mvert

          x1=rng(1,jj)
          x2=rng(2,jj)

          print*,' '
          write(6,321) jj, x1,x2
321       format(' V-state range:',i4,2x,e15.7,2x,e15.7)

          do kk=1,nwin
            r1=binpos(1,kk)
            r2=binpos(2,kk)

c  Lower edge.
            if(x1.ge.r1 .and. x1.lt.r2) then

              if(r2-x1.gt.epsw) then
                ipos_bin(1,jj)=kk
                wbin(kk,jj)=(r2-x1)/de
                write(6,301) kk,r1,r2,wbin(kk,jj)
              else
                ipos_bin(1,jj)=kk+1
                wbin(kk+1,jj)=1.0d0
                write(6,301) kk+1,r1,r2,wbin(kk+1,jj)
              endif

301           format('    start at  bin ',i5,2x,':',
     *                e15.7,2x,e15.7,': w = ',e15.7 )
            endif

c  Upper edge.
            if(x2.gt.r1 .and. x2.le.r2) then

              if(x2-r1.gt.epsw) then
                ipos_bin(2,jj)=kk
                wbin(kk,jj)= (x2-r1)/de
                write(6,302) kk,r1,r2,wbin(kk,jj)
              else
                ipos_bin(2,jj)=kk-1
                wbin(kk-1,jj)=1.0d0
                write(6,302) kk-1,r1,r2,wbin(kk-1,jj)
              endif

302           format('    end   at  bin ',i5,2x,':',
     *                e15.7,2x,e15.7,': w = ',e15.7)
            endif

          enddo
        enddo

c  Memorize the active bins for each v-state.

        do jj=1,mvert
          mm=ipos_bin(2,jj)-ipos_bin(1,jj)
          if(mm.lt.1) then
            print*,' ????????????????????????????????????????'
            print*,' ? N of bins in a v-state is too small. ?'
            print*,' ????????????????????????????????????????'
            print*,' v state: ',jj
            print*,' starting bin No.: ',ipos_bin(1,jj)
            print*,' ending   bin No.* ',ipos_bin(2,jj)
            stop
          endif

          do kk=ipos_bin(1,jj)+1,ipos_bin(2,jj)-1
            wbin(kk,jj)=1.0d0
          enddo
        enddo
c********************************************
        if(mvert.gt.nvert) then
          print*,' ?????????????????????????????'
          print*,' ? nvert is too small. Stop. ?'
          print*,' ?????????????????????????????'
          print*,' nvert = ',nvert
          print*,' mvert = ',mvert
          print*,' Please make nvert larger in COMMON file. '
          stop
        endif

        if(emin1.gt.rng(1,1)) then
          print*,' ???????????????????????????????????????????? '
          print*,' ? emin1 is higher than the variable range. ?'
          print*,' ???????????????????????????????????????????? '
          stop
        endif

        emax1=emin1+de*nene
        if(emax1.lt.rng(2,mvert)) then
          print*,' ?????????????????????? '
          print*,' ? nene is too small. ?'
          print*,' ?????????????????????? '
          stop
        endif
c********************************************
        return
        end

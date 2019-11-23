c
c
c
        include "COMDAT_Mar"
c***********************************************************
        print*,' ******************************************'
        print*,' * Obtain statinary distrib. from t. mat. *'
        print*,' ******************************************'

c***********************************************************
        print*,' '
        print*,'  <<input bin information>> '
        print*,' '
        read(10,*) de,mvert
        print*,'  DE = ',de
        print*,'  N of v-states = ',mvert

        do mm=1,mvert
          read(10,*) i1,nst(mm),nen(mm),nbin(mm)
          print*,' State:',i1,'  N of bins:',nbin(mm)
          print*,'       start & end = ',nst(mm),nen(mm)

          if(i1.ne.mm) then
            print*,' ????????????????????????'
            print*,' ? Strange in i1. Stop. ?'
            print*,' ????????????????????????'
            stop
          endif

          if(nen(mm)-nst(mm)+1.ne.nbin(mm)) then
            print*,'???????????????????????????????????'
            print*,' ? Three digids are inconsistent. ?'
            print*,'???????????????????????????????????'
            stop
          endif

          if (nbin(mm).gt.nbinmx2) then
            print*,' ?????????????????????????????????????????'
            print*,' ? nbinmx2 is too small. Make it larger. ?'
            print*,' ?????????????????????????????????????????'
            stop
          endif

          do ii=1,nbin(mm)
            read(10,*) idum,ibin(ii,mm),reac(ii,mm)
          enddo
        enddo
c************
c  Input ranges used form simulation.

        read(22,*)
        read(22,*) idum
        read(22,*)

        if(idum.ne.mvert) then
          print*,' ???????????????????????????'
          print*,' ? N of v-states mismatch. ?'
          print*,' ???????????????????????????'
          stop
        endif

        do ii=1,mvert
          read(22,*)
          read(22,*) range(1,ii),range(2,ii)
          read(22,*)
        enddo 

        print*,' '
        print*,' reac. coord. ranges for each v-state in simulation. '
        do ii=1,mvert
          write(6,193) ii,range(1,ii),range(2,ii)
        enddo
193     format('   v-state No.: ',i4,2x,f12.4,2x,f12.4)
        print*,'      This info. is used for shifting level of pdf. '

c************
c  Initialization for safety.
        do mm=1,mvert
          do ii=1,nbinmx
          do jj=1,nbinmx
            tmat(jj,ii,mm)=0.0d0
          enddo
          enddo
        enddo
c****
c  Input t. mat.
        print*,' '
        print*,'  <<input tmat>> '
        print*,' '

        read(21,*) idum
        if(idum.ne.mvert) then
          print*,' ?????????????????????????????????'
          print*,' ? Failed in finding first line. ?'
          print*,' ?????????????????????????????????'
          stop
        endif

        do mm=1,mvert
          read(21,*) mdum,k1,k2,ndum
          write(6,130) mdum,k1,k2,ndum
130       format(i4,2x,i4,2x,i4,2x,i4,"      : info. ")

          if(k1.ne.nst(mm)) then
            print*,' ?????????????????????????????'
            print*,' ? Stange starting position. ?'
            print*,' ?????????????????????????????'
            stop
          endif
          if(k2.ne.nen(mm)) then
            print*,' ?????????????????????????????'
            print*,' ? Strange ending  position. ?'
            print*,' ?????????????????????????????'
            stop
          endif
          if(ndum.ne.nbin(mm)) then
            print*,' ??????????????????????'
            print*,' ? Strange N of bins. ?'
            print*,' ??????????????????????'
            stop
          endif

c  The outside of the area below had been set to zero.
          do ii=k1,k2
          do jj=k1,k2
            read(21,*) jdum,idum,tmat(jj,ii,mm)
          enddo
          enddo
        enddo
cc129     format(i4,2x,i4,2x,e22.12)
c************
c  Cehck t. mat.

        print*,' '
        print*,'  Check for the raw t. mat. '
        do mm=1,mvert
          do ii=nst(mm),nen(mm)
            amaxdev=0.0d0
            asum=0.0d0
            do jj=nst(mm),nen(mm) 
              asum = asum + tmat(jj,ii,mm)
            enddo
            aaa=abs(asum-1.0d0)
            if(aaa.gt.amaxdev) amaxdev=aaa
          enddo
          print*,'  ----- v-st: ',mm,'  max dev. from 1.0:  ',amaxdev
        enddo
        print*,' '
c************
c  Multiplicatiom of t. mat.

        print*,' After convert: tmat --> tmat_w1 '
        do mm=1,mvert
          nn=nbin(mm)
c****
c  Matrix convert.
          do ii=1,nn
          do jj=1,nn
            ki=nst(mm)+(ii-1)
            kj=nst(mm)+(jj-1)
            tmat_w1(jj,ii)=tmat(kj,ki,mm)
          enddo
          enddo

c  Normalize tmat_w1.
          do ii=1,nn
            asum=0.0d0
            do jj=1,nn
              asum = asum + tmat_w1(jj,ii)
            enddo
            do jj=1,nn
              tmat_w1(jj,ii)=tmat_w1(jj,ii)/asum
            enddo
          enddo
c**
          do nfold=1,50

            kk=nfold/10
            kk=nfold - kk*10
            if(kk.eq.0) then
              print*,'  N of power = ',nfold,' in ',mm
            endif

            call mat_mul(nn,tmat_w1,tmat_w2,nbinmx2)

            do ii=1,nn
            do jj=1,nn
              tmat_w1(jj,ii)=tmat_w2(jj,ii)
            enddo
            enddo

c  Normalize tmat_w1. <-- maybe this is very important practically.
            do ii=1,nn
              asum=0.0d0
              do jj=1,nn
                asum = asum + tmat_w1(jj,ii)
              enddo
              do jj=1,nn
                tmat_w1(jj,ii)=tmat_w1(jj,ii)/asum
              enddo
            enddo

          enddo
c**
          do ii=1,nn
            amaxdev=0.0d0
            asum=0.0d0
            do jj=1,nn
              asum = asum + tmat_w1(jj,ii)
            enddo
            aaa=abs(asum-1.0d0)
            if(aaa.gt.amaxdev) amaxdev=aaa
          enddo
          print*,'  ----- check: ',mm,'  max dev. from 1.0:  ',amaxdev

          asum=0.0d0
          do jj=1,nn
            do ii=2,nn
              dd=tmat_w1(jj,ii)-tmat_w1(jj,1)
              asum=asum + dd**2
            enddo
          enddo
          asum=asum/(nn*(nn-1))
          print*,' smaller better quantiry = ',asum
          print*,' '

c  Generate log[P].
          do jj=1,nn
            if(tmat_w1(jj,1).ne.0.0) then
              tmat_w1(jj,1)=log(tmat_w1(jj,1))
            endif
            pdf(jj,mm) = tmat_w1(jj,1)
          enddo
c********
        enddo
c******************************
c  Shift the distribution and output.

        do mm=1,mvert-1
          print*,' '
          print*,'  v state No. ',mm,mm+1
          print*,' '

          icou=0
          beta=0.0d0
          do k1=1,nbin(mm)
          do k2=1,nbin(mm+1)
            if(reac(k1,mm).eq.reac(k2,mm+1)) then
              if(reac(k1,mm).lt.range(1,mm)) goto 833
              if(reac(k1,mm).gt.range(2,mm)) goto 833
              if(reac(k2,mm+1).lt.range(1,mm+1)) goto 833
              if(reac(k2,mm+1).gt.range(2,mm+1)) goto 833

              beta=beta + (pdf(k1,mm)-pdf(k2,mm+1))
              icou=icou+1

833           continue
            endif
          enddo
          enddo

          fact=beta/real(icou)
          do ii=1,nbin(mm+1)
            pdf(ii,mm+1)=pdf(ii,mm+1)+fact
          enddo

          print*,'  N. of overlapping data = ',icou
        enddo
c********
        do mm=1,mvert
          idv=100 + mm
          do ii=1,nbin(mm)
            write(idv,153) reac(ii,mm),pdf(ii,mm)
          enddo
        enddo
153     format(e16.7,2x,e16.7)
c***********************************************************
        stop
        end
c############################################################
c############################################################

        subroutine mat_mul(nn,amat,amat_r,nbinmx2)
c***********************************************************
        implicit real*8 (a-h,o-z)
        real*16 amat,amat_r
        dimension amat(nbinmx2,nbinmx2),amat_r(nbinmx2,nbinmx2)
c***********************************************************
cc      print*,' nn = ',nn
cc      print*,' nbinmx2 = ',nbinmx2

        do ii=1,nn
        do jj=1,nn
          amat_r(jj,ii)=0.0d0
        enddo
        enddo
c****
        do ii=1,nn
        do jj=1,nn
        do kk=1,nn
           amat_r(jj,ii)=amat_r(jj,ii) + amat(jj,kk)*amat(kk,ii)
        enddo
        enddo
        enddo
c***********************************************************
        return
        end


        subroutine out_pdf_shft
c******************************************************
        include "COMDAT"
c******************************************************
        print*,' *********************************************'
        print*,' * v-pdfs are shifted to fit the ovrtlapping *'
        print*,' * regions among v-states & and output only  *'
        print*,' * the virtual ranges.                       *'
        print*,' *********************************************'
        print*,'  The fitting is done in the normal scale. '
        print*,' '
c********
c  the pdf comming here is defined in the normal scale.

c  Overlap the pdf by shifting the pdfs.
c  There are twp ways (way A and B) for the shifting the.

c  Way A:  normal scape shifting --> set iset=1
c  Way B: log scape shifting.    --> set iset=2

cc      iset=1
        iset=2

        if(iset.eq.1) then
          print*,' '
          print*,'  The fitting is done in the normal scale. '
          print*,' '
        else
          print*,' '
          print*,'  The fitting is done in the log scale. '
          print*,' '
        endif

        if(iset.ne.1 .and. iset.ne.2) then
          print*,' ??????????????????'
          print*,' ? iset is wrong. ?'
          print*,' ??????????????????'
          stop
        endif
c****
c  Way A:  normal scape shifting.
        if(iset .eq. 1) then

        do ii=1,mvert-1
          m1=ii
          m2=ii+1

          sumgg=0.0d0
          sumfg=0.0d0

c  Note that the index jj is used universary to all of pdf_cut(jj,*).
          ncou=0

          do jj=1,nene
cc          ee=(binpos(1,jj) + binpos(2,jj))/2.0d0
            if(wbin(jj,m1).gt.0.0d0 .and. wbin(jj,m2).gt.0.0d0) then
            if(pdf_cut(jj,m1).gt.0.0d0 .and. pdf_cut(jj,m2).gt.0.0) then
              sumgg=sumgg + pdf_cut(jj,m2)**2
              sumfg=sumfg + pdf_cut(jj,m1)*pdf_cut(jj,m2)
              ncou=ncou+1
            endif
            endif
          enddo

c  If pdf = 0, no modificatoin.
          if(ncou.eq.0) then
            fact=1.0d0
          else
            fact=sumfg / sumgg
          endif

c  Superimpose.
          do jj=1,nene
            if(wbin(jj,m2).gt.0.0d0) then
              pdf_cut(jj,m2)=pdf_cut(jj,m2)*fact
            endif
          enddo
        enddo
        endif
c****
c  Way B: log scape shifting.
        if(iset .eq. 2) then

        do ii=1,mvert-1
          m1=ii
          m2=ii+1

          sumfac=0.0d0

c  Note that the index jj is used universary to all of pdf_cut(jj,*).
          ncou=0

          do jj=1,nene
cc          ee=(binpos(1,jj) + binpos(2,jj))/2.0d0
            if(wbin(jj,m1).gt.0.0d0 .and. wbin(jj,m2).gt.0.0d0) then
            if(pdf_cut(jj,m1).gt.0.0d0 .and. pdf_cut(jj,m2).gt.0.0) then

              sumfac=sumfac + log(pdf_cut(jj,m1)/pdf_cut(jj,m2))
              ncou=ncou+1
            endif
            endif
          enddo

c  If pdf = 0, no modificatoin.
          if(ncou.eq.0) then
            fact=1.0
          else
            fact=sumfac / real(ncou)
            fact=exp(fact)
          endif

c  Superimpose.
          do jj=1,nene
            if(wbin(jj,m2).gt.0.0d0) then
              pdf_cut(jj,m2)=pdf_cut(jj,m2)*fact
            endif
          enddo
        enddo
        endif
c********
c  Output the shifted pdf: overwrite.

        do mm=1,mvert
          idevout= 2000 + mm

          do ii=1,nene
            e1=(binpos(1,ii) + binpos(2,ii))/2.0d0
            if(wbin(ii,mm).gt.0.0d0) then
            if(pdf_cut(ii,mm).gt.0.0d0) then
              write(idevout,612) e1,pdf_cut(ii,mm)
            endif
            endif
          enddo
        enddo

612     format(e15.7,2x,e15.7)
c********
c  Compute single pdf (not v-state pdfs).
c  First, average pdf (integrated pdf) is computed using pdfs for v-state pdfs,
c  which dad been shifted in advance.
c  Normalization is done for both pdfs.

        do ii=1,nene
          inum=0
          pdf_av(ii)=0.0d0

          do mm=1,mvert
            if(wbin(ii,mm).gt.0.0d0) then
            if(pdf_cut(ii,mm).gt.0.0d0) then
              inum=inum+1
              pdf_av(ii)=pdf_av(ii) + pdf_cut(ii,mm)
            endif
            endif
          enddo

          if(inum.ne.0) then
            pdf_av(ii)=pdf_av(ii)/real(inum)
          endif

c  Note that the maximum count for inum is 3.
          if(inum.ge.4) then
            print*,' ????????????????????????????????'
            print*,' ? Too large count is detected. ?'
            print*,' ????????????????????????????????'

            e1=(binpos(1,ii) + binpos(2,ii))/2.0d0
            print*,' bin pos = ',ii,e1
            print*,' count = ',inum
            print*,'   bin range: ',binpos(1,ii),' -- ',binpos(2,ii)

            stop
          endif
        enddo

c  Normalization is done for both pdfs.

        amax=-1.0d0

        do ii=1,nene
          if(pdf_av(ii).gt.amax) then
            amax=pdf_av(ii)
          endif
        enddo
        do ii=1,nene
          pdf_av(ii)=pdf_av(ii)/amax
        enddo

c  Output.

        idevout= 98
        idevout_l= 97

        do ii=1,nene
          acou=0
          do mm=1,mvert
            acou=acou+wbin(ii,mm)
          enddo

          if(acou.ne.0) then
            e1=(binpos(1,ii) + binpos(2,ii))/2.0d0
            write(idevout,612) e1,pdf_av(ii)

            f_log=log(pdf_av(ii))
            write(idevout_l,612) e1,f_log

            write(6,613) e1,pdf_av(ii),f_log
          endif
        enddo
613     format(e15.7,2x,e15.7,2x,f15.7)
c******************************************************
        return
        end

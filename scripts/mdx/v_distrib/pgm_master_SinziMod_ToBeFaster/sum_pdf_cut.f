        subroutine sum_pdf_cut(mm,a1,kvert,ibin)
c******************************************************
        include "COMDAT"
c******************************************************
c  Sum up for pdf.
c    The index ibin is universal for all v-pdf.

        do kk=1,nwin
          r1=binpos(1,kk)
          r2=binpos(2,kk)

          if(a1.ge.r1 .and. a1.lt.r2) then
            ibin=kk
            tot_cut=tot_cut+wgt(mm)
            pdf_cut(ibin,kvert)=pdf_cut(ibin,kvert) + wgt(mm)
          endif
        enddo

750     continue
c******************************************************
        return
        end

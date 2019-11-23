
        subroutine out_pdf_raw
c******************************************************
        include "COMDAT"
c******************************************************
c  Output the pdf which are shifted.

        do mm=1,mvert
          idevout=3000 + mm

          do ii=1,nene
            r1=binpos(1,ii)
            r2=binpos(2,ii)
            e1=(r1+r2)/2.0d0

            pdf(ii,mm)=pdf(ii,mm)/tot

cc          if(wbin(ii,mm).gt.0.0d0) then
            if(pdf(ii,mm).gt.0.0d0) then
cc            pdf(ii,mm)=pdf(ii,mm)/wbin(ii,mm)
              write(idevout,612) e1,log(pdf(ii,mm))
            endif
cc          endif
          enddo
        enddo

612     format(e15.7,2x,e15.7)
613     format(e15.7,2x,e15.7,2x,f15.5)
c******************************************************
        return
        end

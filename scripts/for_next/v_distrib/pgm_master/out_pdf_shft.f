
        subroutine out_pdf_shft
c******************************************************
        include "COMDAT"
c******************************************************
        print*,' ************************************ '
        print*,'  v-pdfs are shifted & overwritten. '
        print*,' '
c********
c  Shift the level of pdf.

        do ii=1,mvert-1
          m1=ii
          m2=ii+1
          ndata=0
          beta=0.0d0

c  Note that the index jj is used universary to all of pdf(jj,*).
          do jj=1,nene
            ee=emin1+de*(jj-1)

c Calculate the shift.
            if(ee.ge.rng(1,m1) .and. ee.le.rng(2,m1)) then
            if(ee.ge.rng(1,m2) .and. ee.le.rng(2,m2)) then
              aa1=pdf(jj,m1)
              aa2=pdf(jj,m2)
              beta=beta + (aa1-aa2)
              ndata=ndata+1
            endif
            endif
          enddo

          fact=beta/real(ndata)

c  Shift the pdf.
          do jj=1,nene
            if(pdf(jj,m2).ne.0.0d0) then
              pdf(jj,m2)=pdf(jj,m2) + fact
            endif
          enddo

          write(6,269) m2,ndata,fact
269       format('      v-state No., Ndata, shift: ',i2,2x,i3,2x,e15.8)
        enddo
c********
c  Output the shifted pdf: overwrite.

        do mm=1,mvert
          if(mm.eq.1) idevout=201
          if(mm.eq.2) idevout=202
          if(mm.eq.3) idevout=203
          if(mm.eq.4) idevout=204
          if(mm.eq.5) idevout=205
          if(mm.eq.6) idevout=206
          if(mm.eq.7) idevout=207
          if(mm.eq.8) idevout=208
          if(mm.eq.9) idevout=209
          if(mm.eq.10) idevout=210
          if(mm.eq.11) idevout=211
          if(mm.eq.12) idevout=212
          if(mm.eq.13) idevout=213
          if(mm.eq.14) idevout=214
          if(mm.eq.15) idevout=215

          do ii=1,nene
            e1=emin1+(ii-1)*de+de/2.0
            write(idevout,612) e1,pdf(ii,mm)
          enddo
        enddo

612     format(e15.7,2x,e15.7)
c******************************************************
        return
        end

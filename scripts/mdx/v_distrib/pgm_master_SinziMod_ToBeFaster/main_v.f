c******************************************************
        include "COMDAT"
c******************************************************
        print*,' '
        print*,' ******************************'
        print*,' * Distrib. for each v state. *'
        print*,' ******************************'
        print*,'  NOTE 1: This pgm treates omegagene output files.'
        print*,' '
        print*,'  NOTE 2: Normalization is dome in the whole range'
        print*,'          not in each range.'
        print*,' '
c********************************************
c  Parameter input field.
        call cpu_time(ti) !(1)
        call para_inp
        call cpu_time(tf)
        print*, "(1)", tf-ti
c********************************************
c  Input trajectories for lambda, v-state $ start_vert.

c  Loop over input files.

        call cpu_time(ti_loop)
        do mm=1,nfil

          print*,'    '
          write(6,107) mm
107       format("  File ordinal No. = ",i6)

          idevinv=100+mm
          open(unit=idevinv,file=filnamev(mm),status="old")

          idevin=200+mm
          open(unit=idevin,file=filname(mm),status="old")

          idevins=300+mm
          open(unit=idevins,file=filnames(mm),status="old")

c  icv & icc are line counter for each file.

          icv=0
          icc=0
c********
c  Loop.
c  v-state file should be read first.

555       continue

          if(icv.eq.0) then
            read(idevins,*) ivv
            icv=icv+1
            istv=1
            nnn=intv_v-1
          else
            read(idevinv,*,end=888) istv,ivv
            icv=icv+1
            nnn=intv_v
          endif

c  Note: only one line for the last virtual input.

!          call cpu_time(ti)!(2-1)
          do jj=1,nnn
            read(idevin,*,end=881) rrr
            icc=icc+1

c  To calcu. <lambda> in each lambda file.
            av_lambda(mm)=av_lambda(mm)+rrr

            goto 771

771         continue

c  Take data only in the specified trajectory window.
            if(icc.gt.nst(mm) .and. icc.le.nen(mm)) then

c  Count in each v-state anyway.
              c_icou(ivv)=c_icou(ivv)+wgt(mm)

c  Sum up data for pdf.
c    The index ibin (outout) is universal for all v-pdf.
c        Maybe this quanbtity is not useful.
              call sum_pdf(mm,rrr,ivv,ibin)


!*******I commented out the following lines to reduce computation time. *******
c  Generate pdf for data only in the allowed v-state interval.
c  Quantity c_icou_rng is important for the next sim.
!              if(rrr.ge.rng(1,ivv) .and. rrr.le.rng(2,ivv)) then
!cc              c_icou_rng(ivv)=c_icou_rng(ivv)+1
!                c_icou_rng(ivv)=c_icou_rng(ivv)+wgt(mm)
!                call sum_pdf_cut(mm,rrr,ivv,ibin)
!              endif
!*****************************************************************************

            endif
          enddo
!          call cpu_time(tf)!(2-1)
!          print*, "(2-1)", tf-ti

          goto 555
881       continue
888       continue

          write(6,201) icv,icc
201       format("      N of data for v-file & lambda file: ",i8,2x,i8)

          close(idevinv)
          close(idevin)
          close(idevins)

          av_lambda(mm)=av_lambda(mm)/real(icc)
          write(55,499) mm,av_lambda(mm)
499       format(i4,2x,f16.5)

        enddo
        call cpu_time(tf_loop)
        print*, "(2)", tf_loop-ti_loop

c********
        print*,' '
        print*,'  Count in each v state (raw & trancated)'
        print*,'    normalize so that the largest prob. = 1.'
        print*,' '
        call cpu_time(ti) !(3)
        do ii=1,mvert
          cc=c_icou_rng(ii)/c_icou(ii)*100
          write(6,337) ii,c_icou(ii),c_icou_rng(ii),cc
        enddo
337     format("    ",i4,2x,f16.2,2x,f16.2," ratio = ",f8.3,"%")

        pmax=0.0
        do ii=1,mvert
          dd=rng(2,ii)-rng(1,ii)
          pp=c_icou_rng(ii)/dd
          if(pp.gt.pmax) pmax=pp
        enddo

        print*,' '
        print*,' Prob. for each v-state.'
        print*,'    normalize so that the largest prob. = 1.'
        print*,' '

        amax=0.0
        do ii=1,mvert
          dd=rng(2,ii)-rng(1,ii)
          pp=c_icou_rng(ii)/dd/pmax
          write(6,320) ii,pp
          write(41,320) ii,pp
        enddo
        call cpu_time(tf) !(3)
        print*, "(3)", tf-ti

320     format(i4,2x,e15.6)

        call cpu_time(ti) !(4)
        call out_pdf_raw
        call out_pdf_cut
        call out_pdf_shft
        call cpu_time(tf) !(4)
        print*, "(4)", tf-ti

        print*,' '
        print*,'  End of all. '
        print*,' '

        stop
c____________________


c**********************
c  Monitor <lambxda>.

        print*,' '
        do ii=1,nfil
          av_lambda(ii)=av_lambda(ii)/real(icc)

          if(av_lambda(ii).lt.11.2d0) then
            write(55,411) ii,av_lambda(ii)
            goto 889
          endif

          if(av_lambda(ii).lt.11.6d0) then
            write(55,412) ii,av_lambda(ii)
            goto 889
          endif

          if(av_lambda(ii).lt.12.0d0) then
            write(55,413) ii,av_lambda(ii)
            goto 889
          endif

          if(av_lambda(ii).lt.12.5d0) then
            write(55,414) ii,av_lambda(ii)
            goto 889
          endif

          if(av_lambda(ii).lt.13.0d0) then
            write(55,415) ii,av_lambda(ii)
            goto 889
          endif

          if(av_lambda(ii).lt.13.5d0) then
            write(55,416) ii,av_lambda(ii)
            goto 889
          endif

          if(av_lambda(ii).lt.14.0d0) then
            write(55,417) ii,av_lambda(ii)
            goto 889
          endif

          if(av_lambda(ii).lt.14.5d0) then
            write(55,418) ii,av_lambda(ii)
            goto 889
          endif

          write(55,500) ii,av_lambda(ii)

889       continue
        enddo

411     format(i4,f16.5,'    9 ')
412     format(i4,f16.5,'    8 ')
413     format(i4,f16.5,'    7 ')
414     format(i4,f16.5,'    6 ')
415     format(i4,f16.5,'    5 ')
416     format(i4,f16.5,'    4 ')
417     format(i4,f16.5,'    3 ')
418     format(i4,f16.5,'    2 ')

500     format(i4,f16.5,'    1 ')
c**********************

        print*,' '
        print*,'  End of all. '
        print*,' '
c******************************************************
        stop
        end

c
        dimension est(100),een(100)
c************************************
        read(20,*) nvert

        read(5,*)
        do ii=1,nvert
          read(5,*)
          read(5,*) est(ii),een(ii)
cc        print*,'  ',ii,est(ii),een(ii)
        enddo

        if(est(1).lt.est(nvert)) then
          isel = 1
        else
          isel = 2
        endif

        if(isel.ne.1 .and. isel.ne.2) then
          print*,'???????????????????????'
          print*,'? Strange isel. Stop. ?'
          print*,'???????????????????????'
        endif

        ivert=-1

        read(10,*) ene

        if(isel.eq.1) then
          do ii=nvert,1,-1
            if(ene.ge.est(ii) .and. ene.lt.een(ii) ) then
              ivert=ii
              goto 999
            endif
          enddo
        else
          do ii=1,nvert
            if(ene.ge.est(ii) .and. ene.lt.een(ii) ) then
              ivert=ii
              goto 999
            endif
          enddo
        endif

999     continue

        if(ivert.eq.-1) then
          if(isel.eq.1) then
            if(ene.lt.est(1)) ivert=1
            if(ene.gt.een(nvert)) ivert=nvert
          endif
          if(isel.eq.2) then
            if(ene.gt.est(1)) ivert=1
            if(ene.lt.een(nvert)) ivert=nvert
          endif
        endif

        if(ivert.eq.-1) then
          print*,'  ???????????????????????????????'
          print*,'  ?  Strange ivert is detected. ?'
          print*,'  ???????????????????????????????'
        endif
        print*,' ene & ivert = ',ene,ivert

        write(11,100) ivert
100     format(i2)
c************************************
        stop
        end

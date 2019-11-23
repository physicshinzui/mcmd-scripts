c
c
c
        parameter (nmax=400)
        dimension ee(nmax)
        dimension pdf(nmax,20)
c****************************
        nfil=5
cc        nfil=6
cc        nfil=9
cc        nfil=13
c****
        de = 50.0
        emin=-45000.0

        do ii=1,nmax
          ee(ii)= (ii-1)*de + emin
cc          print*,'   E = ',ii,ee(ii)
        enddo
c**
        do ii=1,nfil
          do jj=1,nmax
            pdf(jj,ii)=0.0
          enddo
        enddo
c****
        e1= 1000000.0
        e2=-1000000.0

        do ii=1,nfil
          print*,'  File No. = ',ii
          idev=100+ii

          do jj=1,nmax
            read(idev,*,end=900) e,p

            do kk=1,nmax
              emax=ee(kk)+1.0
              emin=ee(kk)-1.0
              if(e.ge.emin .and. e.le.emax) then
                print*,' e & p =',jj,e,p
                pdf(kk,ii)=p

                if(e.lt.e1) e1=e
                if(e.gt.e2) e2=e
                goto 333
              endif
            enddo
            print*,'  Failed in finding a bin.'
            stop
333         continue
          enddo
900       continue
        enddo

        print*,' '
        print*,'  Emin & emax = ',e1,e2
c****
        do ii=1,nfil
          idev=200+ii
          do jj=1,nmax
            write(idev,110) jj,ee(jj),pdf(jj,ii)
          enddo
        enddo
110     format(i6,2x,e12.5,2x,f12.5)
c****************************
        stop
        end

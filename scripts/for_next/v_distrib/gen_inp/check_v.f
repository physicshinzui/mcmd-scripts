c**************************************
        dimension nume(20),a(20)
        dimension nfold(20)
        dimension prob(20),ppp(20)
c**************************************
        nv = 9
cc        print*,'  N of v states = ',nv,' OK? '
c***************************
c  kkk: run No.
        read(11,*) kkk
c****
c  Input a virtual-state trejectory.

        num=0
        do ii=1,nv
          nume(ii)=0
        enddo

400     continue
        read(10,*,end=999) istp,iv
300     format('  step No. & v state = ',i10,i2)

        num=num+1
        nume(iv)=nume(iv)+1

        goto 400
c****
999     continue

        do ii=1,nv
          a(ii)=real(nume(ii))/real(num)
        enddo
c****
        n1=20000
        n2=990000000

        read(5,*) nclass
        if(nclass.gt.nv) then
          print*,' ??????????????????????????????????????????????'
          print*,' ? N of classes is larger than N of v states. ?'
          print*,' ??????????????????????????????????????????????'
          stop
        endif
        
        do ij=1,nclass
          read(5,*) idum,prob(ij),nfold(ij)
        enddo

        do ij=1,nclass
          ppp(ij)=0.0
          do km=1,ij
            ppp(ij)=ppp(ij)+a(km)
          enddo
        enddo

        do mi=1,nclass
          if(ppp(mi).ge.prob(mi))then
            write(20,201) kkk,n1,n2,nfold(mi)
            write(6,101) kkk,a(1),a(2),a(3),a(4),a(5),a(6),a(7),
     *                   a(8),a(9),nfold(mi)
            goto 639
          endif
        enddo

        nlast=1
        write(20,201) kkk,n1,n2,nlast
        write(6,101) kkk,a(1),a(2),a(3),a(4),a(5),a(6),a(7),
     *               a(8),a(9),nlast

201     format(i4,2x,i8,2x,i9,2x,i8)
101     format(i4,9(1x,f10.3),2x,i8)

639     continue
c**************************************
        stop
        end

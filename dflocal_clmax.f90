       program dflocal_clmax
! finds loc density field clusters at given threshold density level 
! dens - local density from b3 scl0*.fits
! deng - global density from b3 scl*.fits
       USE FITS
       USE CLUSTER
       USE PARAM
       IMPLICIT NONE
       
       integer :: NB(6,3)
       real :: densloc(NGRID,NGRID,NGRID)
       real :: densglob(NGRID,NGRID,NGRID)
       logical(1) :: map(NGRID,NGRID,NGRID)
       character(80) ifile1,ifile2,ofile1
       real :: fac_cell,dthr
       integer :: i,j,k,NG
! 
! Variables init section 
!
       fac_cell=float(NGRID)/BoxSize
       NB=0; NB(1,1)=1; NB(3,1)=-1
       NB(4,2)=-1; NB(6,3)=-1
!=============================================================!
!		User interface				      !
!=============================================================!
        print '(1x,a,$)', 'Name of 0-order density fits file: '
        read(*,'(a)') ifile1
        print '(1x,a,$)', 'Name of N-order density fits file: '
        read(*,'(a)') ifile2
        print '(1x,a,$)', 'Name of cluster out file: '
        read(*,'(a)') ofile1
        print '(1x,a,$)', 'Enter minimal local density threshold: '
        read(*,'(f8.2)') dthr
!=============================================================!
!		Fits file reading			      !
!=============================================================!
        call read_fits(ifile1,densloc)
        call read_fits(ifile2,densglob)
       
         DO  k=1,NGRID
           DO j=1,NGRID
             DO i=1,NGRID
               map(i,j,k) = densloc(i,j,k).ge.dthr
             ENDDO
           ENDDO
         ENDDO
     
         NG=0

         open(unit=20,file=ofile1,status="unknown")
         DO  k=1,NGRID
           DO  j=1,NGRID
             DO  i=1,NGRID
               if (map(i,j,k)) then 
                 CALL CLSTRmax(i,j,k,NB,NG,map,densloc,densglob,dthr)
               endif
             ENDDO
           ENDDO
         ENDDO
         
         print '(1x,i9)',NG

       stop 'END OF PROGRAM'
       end program dflocal_clmax

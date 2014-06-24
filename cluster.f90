MODULE CLUSTER
         use PARAM
         IMPLICIT NONE
        contains
         subroutine  CLSTRmax(IST,JST,KST,NB,NG,map1,dens1,dens2,dthr)
!==================================================================!
! Procedure finds a maximum peaking at cell ISTART,JSTART, KSTART. !
!==================================================================!
      integer, INTENT(in) :: NB(6,3)
      real, INTENT(inout) :: dens1(NGRID,NGRID,NGRID)
      real, INTENT(in) :: dens2(NGRID,NGRID,NGRID)
      LOGICAL(1), INTENT(inout) :: map1(NGRID,NGRID,NGRID)
      real, INTENT(in) :: dthr
      integer, INTENT(in) :: IST,JST,KST
      integer, INTENT(inout) :: NG
     
      real :: dmax,den,mpart,dmlim,dmas,dmpeak,dglob
      integer :: m,i,j,k,ii,jj,kk 

! Initialize density peak search:

      dmax=dens1(IST,JST,KST)
      if(dmax.eq.dthr) return
! 
! Look up all neighbour cells:
      do M=1,6
      I=ist+NB(M,1)
      J=jst+NB(M,2)
      K=kst+NB(M,3)
! Now check the indices:
      if (i.lt.1)     i = i + ngrid
      if (i.gt.ngrid) i = i - ngrid
      if (j.lt.1)     j = j + ngrid
      if (j.gt.ngrid) j = j - ngrid
      if (k.lt.1)     k = k + ngrid
      if (k.gt.ngrid) k = k - ngrid
! Index outside range or in low-dens region
      den=dens1(I,J,K)
! if dmax is not maximum, finish further search
      if(den.gt.dmax) return
      enddo 

! find mass in box [-2,2]
      mpart = rhoc0*Omega_m*(BoxSize**3/NGRID**3)
      dmlim = 10.

      dmas=0.

      do i=-2,2
           ii = ist + i
           if(ii.gt.ngrid)ii=ii-ngrid
           if(ii.lt.1)    ii=ii+ngrid

         do j=-2,2
            jj = jst + j
            if(jj.gt.ngrid)jj=jj-ngrid
            if(jj.lt.1)    jj=jj+ngrid

            do k=-2,2
               kk = kst + k
                if(kk.gt.ngrid)kk=kk-ngrid
                if(kk.lt.1)    kk=kk+ngrid

             if( map1(ii,jj,kk)) then
                 dmas = dmas + dens1(ii,jj,kk)
             endif
             map1(ii,jj,kk) = .false.
            enddo
         enddo
      enddo

! ignore low mass clusters
      if(dmas.lt.dmlim) return
! Store results of clusters 
! erase used cells      
      NG=NG+1


! dmax - cluster epak local density
! dmpeak - cluster mass in solar units
! dglob - cluster peak global density

      dmpeak  = dmas*mpart
      dglob   = dens2(ist,jst,kst)

      WRITE(20,'(4i9,f10.4,e15.5,f10.4)')ng,ist,jst,kst,dmax,dmpeak,dglob

      RETURN
      END SUBROUTINE CLSTRmax
END MODULE CLUSTER

MODULE PARAM
      IMPLICIT NONE
!        Basic variables
!       
         integer, parameter :: NGRID = 512.
         integer, parameter :: NTOTAL = NGRID*NGRID*NGRID
         real, parameter :: BoxSize = 256.
         integer, parameter :: MSIZE = 500000
! Cosmological parameters
         real, parameter :: Omega_m = 0.28
         real, parameter :: Omega_L = 0.72
         real, parameter :: h0 = 0.73
         real, parameter :: sigma8 = 0.84
         real, parameter :: rhoc0 = 2.7755E+11
         real, parameter :: G = 6.67259E-11
         real, parameter :: pc2m = 30.85678E+15
         real, parameter :: Msun = 1.989E+30
! Gadget Units
         real, parameter :: GADGET_LUNIT = 1.0e-3
         real, parameter :: GADGET_MUNIT = 1.0e10
! Gadget arrays
         real, dimension(:,:), allocatable  :: pos, vel
         integer(4), dimension(:),allocatable :: id
END MODULE PARAM

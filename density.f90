MODULE DENSITY
	IMPLICIT NONE
! Definition of density and supporting arrays as allocatable arrays

		real, dimension(:,:,:), allocatable  :: densloc, densglob
		logical(1), dimension(:,:,:), allocatable :: map

END MODULE DENSITY

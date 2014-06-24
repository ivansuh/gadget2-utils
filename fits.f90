MODULE FITS
         USE PARAM
         IMPLICIT NONE
        contains
          subroutine read_fits(fname,array)
            real, INTENT(out) :: array(NGRID,NGRID,NGRID)
            character(80), INTENT(in) :: fname
            integer :: status,unit,readwrite,blocksize,naxes(3),nfound
            integer :: group,firstpix,nbuffer,npixels,i
            real    :: datamin,datamax,nullval
            logical :: anynull,simple,extend
          !  The STATUS parameter must always be initialized.
             status=0

          !  Get an unused Logical Unit Number to use to open the FITS file.
             call ftgiou(unit,status)

          !  Open the FITS file
             readwrite=0
             call ftopen(unit,fname,readwrite,blocksize,status)

          !  Determine the size of the image.
             call ftgknj(unit,'NAXIS',1,3,naxes,nfound,status)

          !  Initialize variables
             npixels=naxes(1)*naxes(2)*naxes(3)
             group=1
             firstpix=1
             nullval=-999
             datamin=1.0E30
             datamax=-1.0E30
          !  Get array from file
             call ftgpve(unit,group,firstpix,npixels,nullval,&
                   array,anynull,status)

          !  The FITS file must always be closed before exiting the program.
          !  Any unit numbers allocated with FTGIOU must be freed with FTFIOU.
             call ftclos(unit, status)
             call ftfiou(unit, status)
            RETURN
          end subroutine read_fits
          subroutine write_fits(fname,array)
            real, intent(IN) :: array(NGRID,NGRID,NGRID)
            character(80), INTENT(in) :: fname
            integer :: status,unit,readwrite,blocksize,naxes(3),nfound
            integer :: group,firstpix,nbuffer,npixels,i,bitpix,naxis
            real    :: datamin,datamax,nullval
            logical :: anynull,simple,extend

            status=0
            call ftgiou(unit,status)

          !  Create the new empty FITS file.
            blocksize=1
            call ftinit(unit,fname,blocksize,status)

          !  Initialize parameters about the FITS image.
            simple = .true.
            bitpix = -32
            naxis = 3
            naxes = NGRID
            extend = .true.

          !  Write the required header keywords to the file
            call ftphpr(unit,simple,bitpix,naxis,naxes,0,1,extend,status)

          !  Write the array to the FITS file.
            group = 1
            firstpix = 1
            npixels = naxes(1) * naxes(2) * naxes(3)
            call ftppre(unit,group,firstpix,npixels,array,status)

            call ftclos(unit, status)
            call ftfiou(unit, status)

          end subroutine write_fits
END MODULE FITS

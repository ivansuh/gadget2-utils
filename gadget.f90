       program gadget
       USE PARAM
       USE GADGET_OP
       IMPLICIT NONE
     
       character(80) :: buf,fpath,fpath1,fin,fout
       integer :: narg,nFiles
!=============================================================!
!               User interface                                !
!=============================================================!
       narg=NARGS()

! header case
!DEC$ IF DEFINED (GDT2HDR)
       if(narg.ne.3) STOP 'usage: gadget nFiles fpath_in'
       call GETARG(1,buf)
       nFiles=INUM(buf)
       call GETARG(2,buf)
       fin=buf
       
       fpath=fin(1:len_trim(fin)) 
!DEC$ ELSE       
! write gadget binary out file or ascii out file
       if(narg.ne.6) STOP 'usage: gadget nFiles file_in file_out NGRID BOXSIZE'
       call GETARG(1,buf)
       nFiles=INUM(buf)
       call GETARG(2,buf)
       fin=buf
       call GETARG(3,buf)
       fout=buf
       call GETARG(4,buf)
       read(buf,*) NGRID
       call GETARG(5,buf)
       read(buf,*) BoxSize
       NTOTAL=NGRID*NGRID*NGRID

       fpath=fin(1:len_trim(fin)) 
       fpath1=fout(1:len_trim(fout)) 
!DEC$ ENDIF

!DEC$ IF DEFINED (ASC2GDT)
! allocate array for particles and indices
       allocate(pos(3,NTOTAL), vel(3,NTOTAL), id(NTOTAL))

       call read_ascii(fpath,NTOTAL)
       call gadget_write(fpath1) 

       deallocate(pos,vel,id)
!DEC$ ENDIF 

!DEC$ IF DEFINED (GDT2HDR)
       call gadget_header(fpath,nFiles)
!DEC$ ENDIF

!DEC$ IF DEFINED (GDT2ASC)
! allocate array for particles and indices
       allocate(pos(3,NTOTAL), vel(3,NTOTAL), id(NTOTAL))

       call gadget_read(fpath,nFiles) 
       call write_ascii(fpath1,NTOTAL)

       deallocate(pos,vel,id)
!DEC$ ENDIF
 
       stop 'END OF PROGRAM' 
       end program gadget

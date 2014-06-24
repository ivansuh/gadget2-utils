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
! write gadget out file
       if(narg.ne.4) STOP 'usage: gadget nFiles file_in file_out'
       call GETARG(1,buf)
       nFiles=INUM(buf)
       call GETARG(2,buf)
       fin=buf
       call GETARG(3,buf)
       fout=buf

       fpath=fin(1:len_trim(fin)) 
       fpath1=fout(1:len_trim(fout)) 

! header case
!       if(narg.ne.3) STOP 'usage: gadget nFiles fpath_in'
!       call GETARG(1,buf)
!       nFiles=INUM(buf)
!       call GETARG(2,buf)
!       fin=buf
!       
!       fpath=fin(1:len_trim(fin)) 
       
!= allocate array for particles and indices
       allocate(pos(3,NTOTAL), vel(3,NTOTAL), id(NTOTAL))

!       call read_ascii(fpath,NTOTAL)
!       call gadget_write(fpath1) 
!       call gadget_header(fpath,nFiles) 
       call gadget_read(fpath,nFiles) 
       call write_ascii(fpath1,NTOTAL)
 
       deallocate(pos,vel,id)
       stop 'END OF PROGRAM' 
       end program gadget

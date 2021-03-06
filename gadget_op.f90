MODULE gadget_op
       USE PARAM
       USE func 
       USE ifport
       IMPLICIT NONE
       include 'for_iosdef.for'
      contains
       subroutine  gadget_read(ifile,nFiles)
          character(80),INTENT(IN) :: ifile
          character(80)    :: filename,fnumber
          integer          :: npart(6),SF,Fb,Cool,nFiles,npartot(6)
          double precision :: masses(6),aexpn,z,box_dp, h,Lambda,Om 
          byte             :: c5(96)
          character(4)     :: HEADER
          integer          :: n_o_b,i,j,fn,nFile,ios
          integer(4)       :: N_tot,nstart
          LOGICAL          :: new_format
          real, dimension(:,:), allocatable  :: part_pos, part_vel
          integer(4), dimension(:),allocatable :: part_id
          integer(4)       :: id_max, id_min
          real             :: pos_max(3), pos_min(3), vel_min(3), vel_max(3)

         
!.... create filename 
          if(nFiles.eq.1) filename=ifile(1:len_trim(ifile)) 
          if(nFiles.gt.1) filename=ifile(1:len_trim(ifile)) // '.' // '0'
  
! ... check GADGET format
          new_format = .false.
          open (2, file =filename,form = 'unformatted', STATUS = 'OLD',IOSTAT=ios,ERR=100)
100       if(ios .EQ. FOR$IOS_FILNOTFOU ) then
            print '(1x,a,\)','Error opening file',filename(1:len_trim(filename)),'\n'c 
            STOP ' END PROGRAM'
          endif
          read(2) HEADER,n_o_b
          close(2)
      
          IF(n_o_b.EQ.264 .or. n_o_b.EQ.134283264) new_format = .true.
          open (2, file =filename,form = 'unformatted', STATUS = 'OLD',IOSTAT=ios,ERR=100)

          IF(new_format) read(2) HEADER,n_o_b
!          IF(new_format) write(*,*) 'new GADGET format, HEADER = ',HEADER
          read (2) npart,masses,aexpn,z,SF,Fb, npartot,&      
                  Cool,nFiles,box_dp,Om,Lambda,h,c5

!   print header informations
          write (*,'(a,f8.4,a,f10.2,a)') ' z=',z,'  Box=',&
          box_dp*GADGET_LUNIT,' h^-1 Mpc'
          print '(1x,a,f7.3,$)','aexpn = ',aexpn
          print '(1x,a,f7.3,a,f7.3)','Omega = ',OM,'  Lambda = ',Lambda
          if(nFiles .gt. 1) then
            write(*,*) '    Output is divided in',nFiles,' files.'
          endif
          do i = 1,6
            masses(i) = masses(i)*GADGET_MUNIT
          write (*,'(a,i1,a,i11,a,i1,a,i11,a,i1,a,e11.3,a)') ' np[',i,']=',npart(i),&
                ' nptot[',i,']=',npartot(i),' m[',i,']=',masses(i)
          enddo

          if(npartot(1) .eq. 0) &
            write (*,'(a)')  'dark matter simulation'
          if(npartot(1) .gt. 0) then
            write (*,'(a)')  'simulation with gas'
          if(Cool .eq. 0 )& 
            write (*,'(a,I3,a)') 'Cool = ',Cool,' : adiabatic '
          if(Cool .gt. 0 )& 
            write (*,'(a,I3,a)') 'Cool = ',Cool,' : with cooling'
          if(sf .eq. 0 )& 
            write (*,'(a,I3,a)') 'sf   = ',sf,' : no star formation'
          if(sf .gt. 0 )& 
            write (*,'(a,I3,a)') 'sf   = ',sf,' : with star formation'
          if(fb .eq. 0 )& 
            write (*,'(a,I3,a)') 'fb   = ',fb,' : no feedback'
          if(fb .gt. 0 )& 
            write (*,'(a,I3,a)') 'fb   = ',fb,' : with feedback'
          endif 
!   end header printing
          close(2)
 
          if(npartot(1) .eq. 0) then 
            N_tot=npartot(2) 
!            allocate(pos(3,N_tot), vel(3,N_tot), id(N_tot))
          endif
          
          nstart=0
          do fn=0,nFiles-1
            if(nFiles .gt. 1) then
              write(fnumber,'(I3)') fn 
              filename=ifile(1:len_trim(ifile)) // '.' // fnumber(verify(fnumber,' '):3)
            endif
            if(nFiles.eq.1) filename=ifile(1:len_trim(ifile))
            print *,'reading...'//filename(1:len_trim(filename))

!   now reading files
            open (2, file =filename,form = 'unformatted', STATUS = 'OLD',IOSTAT=ios,ERR=100)
            IF(new_format) read(2) HEADER,n_o_b
            read (2) npart,masses,aexpn,z,SF,Fb, npartot,&      
                  Cool,nFile,box_dp,Om,Lambda,h,c5
!   print header informations
            write (*,'(a,i11)')   ' total DM N=',npartot(2)
            print *,''
            write (*,'(a,i11)')   ' this file DM N=',npart(2)
            masses = masses*GADGET_MUNIT
            write (*,'(a,e11.3,a)')   ' m=',masses(2),' h^-1 M_sun'
            print *,''
!   end header printing
            allocate(part_pos(3,npart(2)), part_vel(3,npart(2)),part_id(npart(2)))
            IF(new_format) read(2) HEADER,n_o_b
            IF(new_format) write(*,*) 'new GADGET format, HEADER = ',HEADER,n_o_b
            print '(1x,a,$)','reading positions...' 
            read(2) part_pos
            print '(1x,a)','done.' 
            IF(new_format) read(2) HEADER,n_o_b
            IF(new_format) write(*,*) 'new GADGET format, HEADER = ',HEADER,n_o_b
            print '(1x,a,$)','reading velocities...' 
            read(2) part_vel
            print '(1x,a)','done.' 
            IF(new_format) read(2) HEADER,n_o_b
            IF(new_format) write(*,*) 'new GADGET format, HEADER = ',HEADER,n_o_b
            print '(1x,a,$)',"reading id's..."
            read(2) part_id
            print '(1x,a)','done.' 
            
            pos(1:3,1+nstart:nstart+npart(2))=part_pos(1:3,1:npart(2))
            vel(1:3,1+nstart:nstart+npart(2))=part_vel(1:3,1:npart(2))
            id(1+nstart:nstart+npart(2))=part_id(1:npart(2))
            nstart=nstart+npart(2)
            deallocate(part_pos,part_vel,part_id)
            close(2)
          enddo
           
          write(*,*)' header.time :',sqrt(aexpn)
          do i=1,N_tot
            do j=1,3
              pos(j,i)=pos(j,i)*GADGET_LUNIT
              vel(j,i)=vel(j,i)*sqrt(aexpn)
            enddo
          enddo
          
          pos_min= 1.E10
          pos_max=-1.E10
          vel_min= 1.E10
          vel_max=-1.E10
          id_min = 1947483648
          id_max =-1947483648
          
          do i=1,N_tot
            do j=1,3
              pos_min(j)=min(pos_min(j),pos(j,i)) 
              pos_max(j)=max(pos_max(j),pos(j,i)) 
              vel_min(j)=min(vel_min(j),vel(j,i)) 
              vel_max(j)=max(vel_max(j),vel(j,i)) 
            enddo
            id_min=min(id_min,id(i))
            id_max=max(id_max,id(i))
          enddo
          write(*,*) ' '
          write(*,*) ' particle min coord   :',(pos_min(j),j=1,3)
          write(*,*) ' particle max coord   :',(pos_max(j),j=1,3)
          write(*,*) ' particle min velocity:',(vel_min(j),j=1,3)
          write(*,*) ' particle max velocity:',(vel_max(j),j=1,3)
          write(*,*) ' particle min id      :',id_min
          write(*,*) ' particle max id      :',id_max

       end subroutine gadget_read
!------------------------------------------------------------------!
!---GADGET FILE Write procedure------------------------------------!
!------------------------------------------------------------------!
       subroutine gadget_write(ofile)
          character(80),INTENT(IN) :: ofile
          integer          :: npart(6),SF,Fb,Cool,nFiles,npartot(6)
          double precision :: masses(6),aexpn,z,box_dp, h,Lambda,Om 
          byte             :: c5(96)
          character(4)     :: HEADER
          integer          :: n_o_b,i,fn,nFile,j,k
          integer(4)       :: N_tot,nstart

           
            N_tot=real(NTOTAL)
            box_dp=BoxSize
            npart=0
            npartot=0
            npart(2)=N_tot
            npartot(2)=N_tot
            masses=0.
            masses(2)=particle_mass(box_dp,real(NGRID))/GADGET_MUNIT
            aexpn=1./(1.+Z_in)
            z=Z_in
            SF=0
            Fb=0
            Cool=0
            nFile=1
            Om=Omega_m
            Lambda=Omega_L
            h=h0
            box_dp=box_dp/GADGET_LUNIT
!
!            allocate(pos(3,N_tot), vel(3,N_tot), id(N_tot))
!            pos=0.
!            vel=0.
!            id=0
!            k=rand(1)
            do j=1,N_tot
            do k=1,3
               pos(k,j)=pos(k,j)/GADGET_LUNIT
               vel(k,j)=vel(k,j)/sqrt(aexpn)
            enddo
               id(j)=j
            enddo
            
            open (2, file =ofile,form = 'unformatted', STATUS = 'NEW')
            write(2)'HEAD',264
            write(2) npart,masses,aexpn,z,SF,Fb, npartot,& 
                  Cool,nFile,box_dp,Om,Lambda,h,c5
            write(2)'POS ',264
            write(2) pos
            write(2)'VEL ',264
            write(2) vel
            write(2)'ID  ',264
            write(2) id
            close(2)
       end subroutine gadget_write
!---------------------------------------------------------------------!
!---GADGET FILE check routine-----------------------------------------!
!---------------------------------------------------------------------!
       subroutine  gadget_header(ifile,nFiles)
          character(80),INTENT(IN) :: ifile
          character(80)    :: filename
          integer          :: npart(6),SF,Fb,Cool,nFiles,npartot(6)
          double precision :: masses(6),aexpn,z,box_dp, h,Lambda,Om
          byte             :: c5(96)
          character(4)     :: HEADER
          integer          :: n_o_b,i,ios
          integer(4)       :: N_tot,nstart
          LOGICAL          :: new_format

!.... create filename 
          if(nFiles.eq.1) filename=ifile(1:len_trim(ifile))
          if(nFiles.gt.1) filename=ifile(1:len_trim(ifile)) // '.' // '0'

! ... check GADGET format
          new_format = .false.
          open (2, file =filename,form = 'unformatted', STATUS = 'OLD',IOSTAT=ios,ERR=100)
100       if(ios .EQ. FOR$IOS_FILNOTFOU ) then
            print '(1x,a,\)','Error opening file',filename(1:len_trim(filename)),'\n'c
            STOP ' END PROGRAM'
          endif
          read(2) HEADER,n_o_b
          close(2)

          IF(n_o_b.EQ.264 .or. n_o_b.EQ.134283264) new_format = .true.
          open (2, file =filename,form = 'unformatted', STATUS = 'OLD',IOSTAT=ios,ERR=100)

          IF(new_format) read(2) HEADER,n_o_b
          read (2) npart,masses,aexpn,z,SF,Fb, npartot,&
                  Cool,nFiles,box_dp,Om,Lambda,h,c5

!   print header informations
          write (*,'(a,f8.4,a,f10.2,a)') ' z=',z,'  Box=',&
          box_dp*GADGET_LUNIT,' h^-1 Mpc'
          print '(1x,a,f7.3,$)','aexpn = ',aexpn
          print '(1x,a,f7.3,a,f7.3)','Omega = ',OM,'  Lambda = ',Lambda
          if(nFiles .gt. 1) then
            write(*,*) '    Output is divided in',nFiles,' files.'
          endif
          do i = 1,6
            masses(i) = masses(i)*GADGET_MUNIT
          write (*,'(a,i1,a,i11,a,i1,a,i11,a,i1,a,e11.3,a)') ' np[',i,']=',npart(i),&
                ' nptot[',i,']=',npartot(i),' m[',i,']=',masses(i)
          enddo

          if(npartot(1) .eq. 0) &
            write (*,'(a)')  'dark matter simulation'
          if(npartot(1) .gt. 0) then
            write (*,'(a)')  'simulation with gas'
          if(Cool .eq. 0 )&
            write (*,'(a,I3,a)') 'Cool = ',Cool,' : adiabatic '
          if(Cool .gt. 0 )&
            write (*,'(a,I3,a)') 'Cool = ',Cool,' : with cooling'
          if(sf .eq. 0 )&
            write (*,'(a,I3,a)') 'sf   = ',sf,' : no star formation'
          if(sf .gt. 0 )&
            write (*,'(a,I3,a)') 'sf   = ',sf,' : with star formation'
          if(fb .eq. 0 )&
            write (*,'(a,I3,a)') 'fb   = ',fb,' : no feedback'
          if(fb .gt. 0 )&
            write (*,'(a,I3,a)') 'fb   = ',fb,' : with feedback'
          endif
!       end header printing
          close(2)
       end subroutine gadget_header
       subroutine read_ascii(ifile,npoints)
          character(80),INTENT(IN) :: ifile
          character(100)           :: HEAD
          integer                  :: ios,i
          integer,INTENT(IN)       :: npoints

!          allocate(pos(3,npoints), vel(3,npoints), id(npoints))
          open (2, file =ifile,STATUS = 'OLD',IOSTAT=ios,ERR=100)
100       if(ios .EQ. FOR$IOS_FILNOTFOU ) then
            print '(1x,a,\)','Error opening file',ifile(1:len_trim(ifile)),'\n'c
            STOP ' END PROGRAM'
          endif
          print *,'reading...'//ifile(1:len_trim(ifile))
          do i=1,9
            read(2,'(a80)') HEAD
            write(*,'(a80)') HEAD
          enddo
          do i=1,npoints
            read(2,*) pos(1:3,i),vel(1:3,i)
          enddo

          write(*,'(a,6f12.3)') 'begin', pos(1,1),pos(2,1),pos(3,1),vel(1,1),vel(2,1),vel(3,1)
          write(*,'(a,6f12.3)') 'end', pos(1,npoints),pos(2,npoints),pos(3,npoints),vel(1,npoints),vel(2,npoints),vel(3,npoints)
          
          close(2)
       end subroutine read_ascii
       subroutine write_ascii(ofile,npoints)
       	  character(80),INTENT(IN) :: ofile
	  integer,INTENT(IN)       :: npoints
          integer		   :: ios,i,j

          open (4, file =ofile,STATUS = 'NEW')

!
! Include AMIGA header if needed
!
 	  write(4,'(i14)') npoints
          write(4,'(f6.1)') 0 !box_dp*GADGET_LUNIT   
          write(4,'(f6.3)') 0 !Om
          write(4,'(f6.3)') 0 !Lambda
          write(4,'(f6.3)') 0 !masses(1)
          write(4,'(f6.3)') 0 !z
          write(4,'(f6.3)') 0 !z
          write(4,'(f6.3)') 0
          write(4,'(a)') 'HEADER is here'
!
          do i=1,npoints
          write(4,'(6f12.3)') pos(1,i),pos(2,i),pos(3,i),vel(1,i),vel(2,i),vel(3,i)
          enddo

          close(4)	
       end subroutine write_ascii
END MODULE gadget_op

MODULE func
     USE PARAM
     IMPLICIT NONE 
     contains 
     function particle_mass(box,grid)
       double precision :: box
       real             :: grid, particle_mass

       particle_mass = rhoc0*Omega_m*(box**3/grid**3)
     end function particle_mass
END MODULE func

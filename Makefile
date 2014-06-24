# Makefile for fof cluster finder programm


FC = ifort 
CC = icc
INCLUDE =
DFLAGS = -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE 
FITS = -L/z/ivan/cfitsio/lib -lcfitsio
OPTFLAGS = -O2 -mcmodel large -shared_intel

OBJ = param.o fits.o cluster.o dflocal_clmax.o 
GOBJ = funcs.o gadget_op.o gadget.o 

all: clean-bin $(OBJ) $(GOBJ) dflocal_clmax gadget

$(OBJ): %.o: %.f90
	$(FC) -c $(OPTFLAGS) $< 

$(GOBJ): %.o: %.f90
	$(FC) -c $(OPTFLAGS) $< 

dflocal_clmax:  $(OBJ) 
	$(FC) $(OBJ) -o $@ $(OPTFLAGS) $(LIBDIR) $(DFLAGS) $(FITS)

gadget:  param.o $(GOBJ) 
	$(FC) param.o $(GOBJ) -o $@ $(OPTFLAGS) $(LIBDIR) $(DFLAGS) 

clean:
	rm -f *.o *.mod
clean-bin:
	rm -f $(PRG)

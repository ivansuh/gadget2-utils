# Makefile for fof cluster finder programm


FC = ifort 
CC = icc
INCLUDE =
DFLAGS = -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE 

DG2BIN = -DASC2GDT

FITS = -lcfitsio

OPTFLAGS = -O2 -mcmodel large -shared_intel

OBJ = param.o density.o fits.o cluster.o dflocal_clmax.o 
GOBJ = funcs.o gadget_op.o 
PRG = dflocal_clmax gadget2header gadget2ascii ascii2gadget

all: clean-bin $(OBJ) $(GOBJ) dflocal_clmax gadget2header gadget2ascii ascii2gadget 

$(OBJ): %.o: %.f90
	$(FC) -c $(OPTFLAGS) $< 

$(GOBJ): %.o: %.f90
	$(FC) -c $(OPTFLAGS) $< 

dflocal_clmax:  $(OBJ) 
	$(FC) $(OBJ) -o $@ $(OPTFLAGS) $(LIBDIR) $(DFLAGS) $(FITS)

gadget2header: param.o $(GOBJ) gadget2header.o
	$(FC) param.o $(GOBJ) gadget2header.o -o $@ $(OPTFLAGS) $(LIBDIR) $(DFLAGS) -DGDT2HDR

gadget2header.o: gadget.f90
	$(FC) -c $(OPTFLAGS) gadget.f90 -DGDT2HDR -o $@

gadget2ascii: param.o $(GOBJ) gadget2ascii.o
	$(FC) param.o $(GOBJ) gadget2ascii.o -o $@ $(OPTFLAGS) $(LIBDIR) $(DFLAGS) -DGDT2ASC

gadget2ascii.o: gadget.f90
	$(FC) -c $(OPTFLAGS) gadget.f90 -DGDT2ASC -o $@

ascii2gadget: param.o $(GOBJ) ascii2gadget.o
	$(FC) param.o $(GOBJ) ascii2gadget.o -o $@ $(OPTFLAGS) $(LIBDIR) $(DFLAGS) -DASC2GDT

ascii2gadget.o: gadget.f90
	$(FC) -c $(OPTFLAGS) gadget.f90 -DASC2GDT -o $@

clean:
	rm -f *.o *.mod
clean-bin:
	rm -f $(PRG)

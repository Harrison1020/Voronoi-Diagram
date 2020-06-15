FC = gfortran
FFLAGS = -fbounds-check
LIBS =

EXE = VDIA
VPATH = mod

.SUFFIXES: .f90 .o

SRCMAIN =		\
	angle.f90	\
	augmen.f90	\
	datin.f90	\
	datout.f90	\
	decode.f90	\
	delete.f90	\
	garbag.f90	\
	main.f90	\
	next.f90	\
	order.f90	\
	same.f90	\
	sort.f90	\
	testpf.f90	\
	update.f90	\
	vorono.f90

OBJ = ${SRCMAIN:.f90=.o}

$(EXE): $(OBJ)
	rm VDIA
	$(FC) $(FFLAGS) $(OBJ) $(LIBS) -o $(EXE)
	rm angle.o augmen.o datin.o datout.o decode.o delete.o garbag.o next.o \
	order.o same.o sort.o testpf.o update.o vorono.o main.o

%.o : %.f90
	$(FC) $(FFLAGS) -c $<

plot:
	rm a.out
	ncargf90 VPLOT.f90
	./a.out

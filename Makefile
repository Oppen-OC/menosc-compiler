###############################################################################
# Compilador de MenosC.  make: construye ./cmc   make test: pasa los tests     #
###############################################################################
# Directorios de trabajo
SRCDIR = src
INCDIR = include
LIBDIR = lib
# Opciones de compilacion
COPT = -Wall
CLIB = -ltds
OBJS = ./alex.o  ./asin.o ./principal.o 
#
cmc:	$(OBJS)  $(LIBDIR)/libtds.a
	gcc $(OBJS) -I$(INCDIR) -L$(LIBDIR) $(COPT) $(CLIB) -o cmc
principal.o: $(SRCDIR)/principal.c
	gcc  -I$(INCDIR) $(COPT) -c $(SRCDIR)/principal.c
asin.o:	asin.c
	gcc  -I$(INCDIR) $(COPT) -c asin.c
alex.o:	alex.c asin.c
	gcc  -I$(INCDIR) $(COPT) -c alex.c
asin.c:	$(SRCDIR)/asin.y
	bison -oasin.c  -d $(SRCDIR)/asin.y
	mv ./asin.h ./include	
alex.c:	$(SRCDIR)/alex.l 
	flex -oalex.c $(SRCDIR)/alex.l 

$(OBJS): $(INCDIR)/header.h

# Compara la salida de cada tests/X.c con tests/X.out (falla si cmc se cuelga)
test: cmc
	@for f in tests/*.c; do \
	  ./cmc $$f > $${f%.c}.got 2>/dev/null || { echo "CRASH  $$f"; exit 1; }; \
	  diff --strip-trailing-cr -u $${f%.c}.out $${f%.c}.got && echo "OK     $$f" || exit 1; \
	done

clean:
	rm -f ./cmc ./alex.c  ./asin.c ./include/asin.h ./tests/*.got
	rm -f ./*.o  ./include/*.?~  ./src/*.?~

.PHONY: test clean
###############################################################################

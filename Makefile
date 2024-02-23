#
# Adjust the following to control which options minitar gets
# built with.  See comments in minitar.c for details.
#
CFLAGS=				\
	-DNO_BZIP2_CREATE	\
	-I./libarchive/libarchive	\
	-g \
	-llz4 -lbz2 -lz  -lzstd -lb2

#
# You may need to add additional libraries or link options here
# For example, many Linux systems require -lacl
#
# LIBS= -lz -lbz2

# How to link against libarchive.
LIBARCHIVE=	./libarchive/libarchive/libarchive.a

all: main

main: main.cpp ./libarchive/libarchive/libarchive.a
	$(CXX) $(CFLAGS) -o main main.cpp $(LIBARCHIVE) $(LIBS)

minitar: minitar.o
	cc -g -o minitar minitar.o $(LIBARCHIVE) $(LIBS)
	strip minitar
	ls -l minitar

minitar.o: minitar.c

clean::
	rm -f *.o
	rm -f main
	rm -f *~

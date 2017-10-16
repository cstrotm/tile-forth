# NAME
#	Makefile - for the tile forth environment
# SYNOPSIS
#	make [option]
# DESCRIPTION
#	General compilation coordinator for the threaded interpreter language
#	environment (TILE). Allow compilation in different modes to simplify
#	program development; compiling, recompiling, debugging, profiling, and
#	benchmarks.
# OPTIONS
#	new
#		Cleans up and compiles a fresh version.
#	opt
#		Use all optimization tricks known by cc.
#	dbx
#		Recompile for debugging with dbx.
#	gprof
#		Recompile for profiling with gprof.
#	lint
#		Verify the source code using lint.
#	bench
#		Some benchmarks to evaluate this threading method
# SEE ALSO
#	make(1), cc(1), touch(1), dbx(1), grof(1), lint(1), time(1)
# AUTHOR
#	Copyright (C) 1990, Mikael R.K. Patel
#	Computer Aided Design Laboratory (CADLAB)
#	Department of Computer and Information Science
#	Linkoping University
#	S-581 83 LINKOPING
#	SWEDEN
#	Email: mip@ida.liu.se
# HISTORY
#	Started on:	 01 April 1989
#	Last updated on: 03 September 1990
#

# C-compiler 
CC = gcc

# Source and object files
SRC = kernel.c io.c error.c memory.c forth.c
VOCS = compiler.v exceptions.v locals.v memory.v queues.v multi-tasking.v string.v float.v
OBJS = kernel.o io.o error.o memory.o
HEADS =  kernel.h io.h error.h memory.h

# Template for your machine dependencies and libraries
# LIBS = -lyourlibrary
# CFLAGS = -youroption -DYOURMACHINE


forth: $(OBJS) forth.o
	$(CC) $(CFLAGS) -o $@ $(OBJS) forth.o $(LIBS)
	mv forth ../bin


# Object code dependencies
forth.o: $(HEADS)

kernel.o: $(HEADS) $(VOCS)

memory.o: $(HEADS)

error.o:  $(HEADS)

io.o:     $(HEADS)


# Cleans up and compiles a new version
new:
	rm -f *.o
	make forth


# Compiles with all optimization tricks	
opt:
	rm -f *.o
	make forth "CFLAGS=$(CFLAGS) -O"


# Compiles for debugging with "dbx" or "dbxtool"
dbx:
	rm -f *.o
	make forth "CFLAGS=$(CFLAGS) -g"


# Compiles for profiling with "gprof"
gprof: 
	rm -f *.o
	make forth "CFLAGS=$(CFLAGS) -DPROFILE -Bstatic -pg"
#	forth 
#	gprof forth

# Verify the source code
lint:
	lint $(CFLAG) -DLINT $(SRC)


# Run the benchmarks
bench:
	time forth byte-sieve.tst -s byte-sieve
	time forth colburn-sieve.tst -s colburn-sieve
	time forth fibonacci.tst -s recursive-fib
	time forth fibonacci.tst -s tail-recursive-fib
	time forth bubble-sort.tst -s bubble-sort
	time forth bubble-sort.tst -s bubble-sort-with-flag
	time forth tree-sort.tst -s tree-sort
	time forth matrix-mult.tst -s matrix-mult
	time forth permutations.tst -s permutations
	time forth towers-of-hanoi.tst -s towers-of-hanoi
	time forth task-sieve.tst -s task-sieve
	time forth minimal.f83 -s bye

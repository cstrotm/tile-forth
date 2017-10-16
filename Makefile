# NAME
#	Makefile - for management of the tile forth environment
# SYNOPSIS
#	make [option]
# DESCRIPTION
#	General environment coordinator for the threaded interpreter language
#	environment (TILE). Allows packaging for distribution etc.
# OPTIONS
#       forth
#		Compiles the forth compiler/interpreter.
#       new
#		Recompile the forth application without optimization.
#       opt
#		Recompile the forth application with optimization.
#       index
#   		Creates index file for available library defintions.
#       help
#               Creates the documentation file for the emacs forth mode.
#	kit
#		Pack the available files for mailing.
#	tar
#		Pack the available files for ftp'ing.
# SEE ALSO
#	make(1), makekit(1), tar(1)
# AUTHOR
#	Copyright (C) 1990, Mikael R.K. Patel
#	Computer Aided Design Laboratory (CADLAB)
#	Department of Computer and Information Science
#	Linkoping University
#	S-581 83 LINKOPING
#	SWEDEN
#	Email: mip@ida.liu.se
# HISTORY
#	Started on: 	 23 May 1990
#	Last updated on: 10 September 1990
#

# Compile tile forth
forth:
	cd src ; make

# Recompile tile forth kernel without optimization
new:
	cd src ; make new

# Recompile tile forth kernel with optimization
opt:
	cd src ; make opt

# Create index file for library definitions
index:
	makeindex lib/* tst/* > INDEX

# Create documentation files for the emacs forth mode
help: 
	rm -f doc/*
	makedoc man/man3/*
	mv man/man3/*.doc doc

# Packs the available source and documentation for mailing
kit:
	touch src/forth.o
	touch bin/forth
	mv src/*.o tmp
	mv bin/forth tmp
	makekit -ntile.kit. \
		Makefile COPYING README PORTING INSTALL INDEX \
		bin bin/* src src/* lib lib/* tst tst/* \
		man man/man1 man/man1/* \
		> tile.kit.index
	mv tile.kit.* shar
	makekit -ntile.man. \
		doc man/man3 man/man3/* \
		> tile.man.index
	mv tile.man.* shar
	mv tmp/*.o src
	mv tmp/forth bin
	date > shar/tile.kit.date

# Packs the available source and documentation for ftp'ing
tar:
	touch src/forth.o
	touch bin/forth
	mv src/*.o tmp
	mv bin/forth tmp
	mv doc/* tmp
	tar -cvf tile.tar \
		Makefile COPYING README PORTING INSTALL INDEX \
		bin src lib tst doc man
	compress tile.tar
	mv tile.tar.Z shar
	mv tmp/*.o src
	mv tmp/forth bin
	mv tmp/*.doc doc
	date > shar/tile.tar.date

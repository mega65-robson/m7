# ************************************************************************************************
# ************************************************************************************************
#
#       Name :      Makefile	
#       Purpose :	Compiler Makefile
#       Date :      23rd March 2026
#       Author :    Paul Robson (paul@robsons.org.uk)
#
# ************************************************************************************************
# ************************************************************************************************

include ../environment/system.make

CC = gcc
SOURCEDIR = source/
CFLAGS = -I include -O2 -Wall -Werror
OBJECTS = $(SOURCEDIR)main.o $(SOURCEDIR)runtime.o $(SOURCEDIR)identifiers.o $(SOURCEDIR)utility.o $(SOURCEDIR)process.o
EXECUTABLE = $(BUILDDIR)m7c

build: $(EXECUTABLE)

$(EXECUTABLE) : $(OBJECTS)
	$(CC) $(LDFLAGS) $^ $(LOADLIBES) $(LDLIBS) -o $@

run: $(EXECUTABLE)
	$(EXECUTABLE) $(BUILDDIR)kernel.prg $(BUILDDIR)m7app.prg test.m7
# *******************************************************************************************
# *******************************************************************************************
#
#       Name :      common.linux.make
#       Purpose :   Common make
#       Date :      21st March 2026
#       Author :    Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

OS = linux

# *******************************************************************************************
#
#										Configuration
#
# *******************************************************************************************

ASSEMBLER = 64tass
PYTHON = PYTHONPATH=$(PYTHONDIRS) python3
MAKE = make --no-print-directory 
EMULATOREXEC = x16emu

# *******************************************************************************************
#
#										Directories
#
# *******************************************************************************************
#
#		Home of the X16 emulator binary and rom.bin
#
X16EMUDIR = /aux/builds/x16-emulator/build/
#
#		Root directory of repo
#
ROOTDIR =  $(dir $(realpath $(lastword $(MAKEFILE_LIST))))../
#
#  		Artefacts of builds.
#
BUILDDIR = $(ROOTDIR)build/
#
#		Where the build environment files are (e.g. like this)
#
BUILDENVDIR = $(ROOTDIR)build_env/
#
# 		Source related files.
#
SOURCEDIR = $(ROOTDIR)kernel/
#
#		Script directory
#
SCRIPTDIR = $(ROOTDIR)scripts/
#
#		Python directories
#
export PYTHONDIRS=$(SCRIPTDIR):$(COMPILERDIR):$(PYTHONPATH)
#
# *******************************************************************************************
#
#								Build Configuration
#
# *******************************************************************************************
#
#		Use zero page from here 
#
ZEROPAGE = 30
#
#		Use non zero page from here. 
#
STORAGE = 400
#
#		Code built for this address
#
CODEADDR = 1000

MEMORYMAP = -D ZEROPAGE=\$$$(ZEROPAGE) -D STORAGE=\$$$(STORAGE) -D CODEADDR=\$$$(CODEADDR)

# *******************************************************************************************
#
#									Build helpers
#
# *******************************************************************************************
#
#		Run the x16 emulator
#
EMULATOR = $(X16EMUDIR)$(EMULATOREXEC) -fsroot $(BUILDDIR) -debug -scale 2 -dump R -run  
#
#		Run the assembler
#
ASSEMBLER = 64tass -q -c -C $(MEMORYMAP) -Wall  -L $(BUILDDIR)asm.lst 


# *******************************************************************************************
#
#				    Uncommenting .SILENT will shut the whole build up.
#
# *******************************************************************************************

ifndef VERBOSE
.SILENT:
endif

default: asm 


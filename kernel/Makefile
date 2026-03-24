# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		Makefile
#		Purpose :	Top level Makefile
#		Date :		21st March 2026
#		Author : 	Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

include ../environment/system.make

KERNELFILE = $(BUILDDIR)KERNEL.PRG
RUNFILE = $(BUILDDIR)M7APP.PRG
MODULES = core 
BUILDROOT = ./

.always:

syntax:
	cp $(ROOTDIR)documents/*sublime-syntax ~/.config/sublime-text/Packages/User -v

autogen:
	$(PYTHON) $(SCRIPTDIR)generators/shiftgen.py >$(SOURCEDIR)core/generated/__shift.asm
	$(PYTHON) $(SCRIPTDIR)generators/copygen.py >$(SOURCEDIR)core/generated/__copyreg.asm
	$(PYTHON) $(SCRIPTDIR)generators/stackgen.py >$(SOURCEDIR)core/generated/__stack.asm
	$(PYTHON) $(SCRIPTDIR)generators/incdecgen.py >$(SOURCEDIR)core/generated/__incdec.asm

prelim: autogen .always
	$(PYTHON) $(SCRIPTDIR)documentation.py $(BUILDROOT) $(MODULES) >$(ROOTDIR)documents/vocabulary.md
	$(PYTHON) $(SCRIPTDIR)constants.py $(BUILDROOT) $(MODULES) >$(SOURCEDIR)core/generated/__byteconst.inc
	$(PYTHON) $(SCRIPTDIR)dictionary.py $(BUILDROOT) $(MODULES) >$(SOURCEDIR)core/generated/__dictionary.asm
	$(PYTHON) $(SCRIPTDIR)vectors.py $(BUILDROOT) $(MODULES) >$(SOURCEDIR)core/generated/__vectors.asm
	$(PYTHON) $(SCRIPTDIR)build.py $(BUILDROOT) $(MODULES) >__main.asm

asmc: prelim .always
	$(ASSEMBLER) __main.asm -o $(KERNELFILE) 
	$(PYTHON) $(SCRIPTDIR)compiler.py $(KERNELFILE) $(RUNFILE) test.m7

asm: prelim .always
	$(ASSEMBLER) __main.asm -o $(KERNELFILE) 
	make -B -C $(ROOTDIR)compiler build
	$(BUILDDIR)m7c $(KERNELFILE) $(RUNFILE) test.m7 >$(BUILDDIR)m7.list
#
#		Assemble code.asm and run it
#
run: .always asm
	$(EMULATOR) -prg $(RUNFILE),$(CODEADDR) 

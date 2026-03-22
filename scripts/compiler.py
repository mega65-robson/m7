# *******************************************************************************************
# *******************************************************************************************
#
#      Name :      compiler.py
#      Purpose :   Ultra simple compiler for testing only.
#      Date :      21st March 2026
#      Author :    Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

import sys,os,re

# *******************************************************************************************
#
#                                   Compiler worker
#
# *******************************************************************************************

class Compiler(object):
    def __init__(self,kernelFile):
        kbin = [x for x in open(kernelFile,"rb").read(-1)]                          # Read the binary file in.
        self.base = kbin[0]+kbin[1] * 256                                           # Load address
        self.memory = kbin[2:]                                                      # The actual kernel.
        if len(self.memory) % 2 != 0:
            self.memory.append(0)
        self.pctr = self.base + len(self.memory)                                    # Current program counter.
        self.dictionary = {}                                                        # Read in dictionary
        p = self.memory[12]+self.memory[13]*256                                     # Address of dictionary.
        while self.read(p) != 0:                                                    # Read it in.
            p = self.readDictionaryItem(p)
    #   
    #       Read in a single dictionary item.
    #
    def readDictionaryItem(self,p):
        done = False
        name = ""
        while not done:
            nc = self.read(p)
            name += chr(nc & 0x7F)
            done = (nc & 0x80) != 0
            p += 1
        address = self.read(p)+self.read(p+1)*256
        assert name not in self.dictionary
        self.dictionary[name] = address
        return p+2
    #
    #       Read a byte
    #
    def read(self,a):
        assert a >= self.base and a < self.base + len(self.memory)
        return self.memory[a-self.base]
    #
    #       Write a byte.
    #
    def writeByte(self,a,d):
        assert a >= self.base and a < self.base + len(self.memory)
        a = a - self.base
        self.memory[a] = d & 0xFF
    #
    #       Write a word.
    #
    def writeWord(self,a,d):
        assert a >= self.base and a+1 < self.base + len(self.memory)
        a = a - self.base
        self.memory[a] = d & 0xFF
        self.memory[a+1] = (d >> 8) & 0xFF
    #
    #       Compile a file
    #
    def compileFile(self,f):
        for s in open(f).readlines():
            s = s if s.find("//") < 0 else s[:s.find("//")]
            for w in s.split():
                self.compile(w)
    #
    #       Compile one element
    #
    def compile(self,s):
        if s.startswith('"') and s.endswith('"'):                                   # Inline string
            s = s[1:-1].replace("_"," ")+chr(0)
            self.compile("string.handler")
            for c in s:
                self.compileByte(ord(c),c)
            return

        s = s.upper()                                                               # Only strings are case sensitive.

        if s.startswith(":"):                                                       # Definition.
            s = s[1:].upper()
            assert s not in self.dictionary,"Duplicate "+s
            print("\n*** {0} ***".format(s.lower()))
            if self.pctr % 2 != 0:                                                  # Force definition to even.
                self.compileByte(0,"(align)")

            self.dictionary[s] = self.pctr
            if s == "MAIN":                                                         # Main specified.
                self.writeWord(self.base+8,self.pctr)
            return

        if s == "VARIABLE":                                                         # handle variable.
                self.compile("var.handler")
                self.compileWord(0,"0",False)
                return

        if re.match("^\\-?\\d+$",s):                                                # Decimal
            self.compileConstant(int(s),s)
            return

        if re.match("^\\$\\-?[0-9A-F]+$",s):                                        # Hexadecimal.
            self.compileConstant(int(s[1:],16),s)
            return

        if s in self.dictionary:                                                    # Word in low RAM, machine code.
            addr = self.dictionary[s]
            if addr < 256:
                self.compileByte(addr,s)
            else:
                addr = ((addr >> 1) & 0x7FFF) | 0x8000
                self.compileWord(addr,s,True)                                  
            return

        assert False,"Word not recognised "+s
    #
    #       Compile a constant
    #
    def compileConstant(self,n,text):
        n = n & 0xFFFF                                                              # Mask
        if n < 256:
            self.compileByte(0,text)
            self.compileByte(n,"")
        else:
            self.compileByte(1,text)
            self.compileWord(n,"",False)
    #
    #       Write one byte at the program counter.
    #
    def compileByte(self,value,text):
        assert len(self.memory)+self.base == self.pctr
        print("{0:04x} :   {1:02x}\t\t{2}".format(self.pctr,value,text.lower()))
        self.memory += [ 0 ]
        self.writeByte(self.pctr,value)
        self.pctr += 1
    #
    #       Write one word at the program counter.
    #
    def compileWord(self,value,text,swap):
        assert len(self.memory)+self.base == self.pctr
        print("{0:04x} : {1:04x}\t\t{2}".format(self.pctr,value,text.lower()))
        self.memory += [ 0,0 ]
        if swap:
            value = ((value & 0xFF) << 8) | ((value & 0xFF00) >> 8)
        self.writeWord(self.pctr,value)
        self.pctr += 2
    #
    #       Write out the final prg file.
    #
    def writeFile(self,tgtFile):
        print("Writing to "+tgtFile)
        self.writeWord(self.base+16,self.pctr)                                      # Update free memory
        h = open(tgtFile,"wb")
        h.write(bytes([self.base & 0xFF,self.base >> 8]))
        h.write(bytes(self.memory))
        h.close()

assert len(sys.argv) > 3,"<kernel> <app> <sources> ....."

cm = Compiler(sys.argv[1])
for s in sys.argv[3:]:
    cm.compileFile(s)
cm.writeFile(sys.argv[2])
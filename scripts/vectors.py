# *******************************************************************************************
# *******************************************************************************************
#
#      Name :      vectors.py
#      Purpose :   Render vector table
#      Date :      22nd March 2026
#      Author :    Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

import sys,os,re

from build import *
from dictionary import *

# *******************************************************************************************
#
#                               Vector Table builder class
#
# *******************************************************************************************

class VectorBuilder(DictionaryBuilder):

    def footer(self):
        idLookup = { }
        for name,info in self.byteCodes.items():
            idLookup[info[0]] = name

        print("\t.section\tcode")
        print("VectorTable:")
        for i in range(0,128):
            if i in idLookup:
                name = idLookup[i]
                label = self.byteCodes[name][1]
            else:
                name = "(undefined)"
                label = "ByteCodeError"
            print("\t.word\t{0:<16}\t; ${1:02x} {2}".format(label,i,name))
        print("\t.endsection")




if __name__ == "__main__":
    VectorBuilder().run()


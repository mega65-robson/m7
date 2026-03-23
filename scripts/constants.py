# *******************************************************************************************
# *******************************************************************************************
#
#      Name :      constants.py
#      Purpose :   Render bytecode constants
#      Date :      23rd March 2026
#      Author :    Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

import sys,os,re

from build import *
from dictionary import *

# *******************************************************************************************
#
#                               Constant Table builder class
#
# *******************************************************************************************

class ConstantBuilder(DictionaryBuilder):

    def footer(self):
        for name,info in self.byteCodes.items():
            print("BYC_{0} = ${1:02x} ; {2}".format(self.convert(name),info[0],name.lower()))

    def convert(self,s):
        s = s.upper()
        s = s.replace(">","GREATER").replace("<","LESS").replace("=","EQUAL").replace("+","PLUS").replace("-","MINUS").replace("@","AT")
        s = s.replace("*","ASTERISK").replace("/","SLASH").replace(".","DOT").replace(";","SEMICOLON").replace("!","PLING").replace("&","AMPERSAND")
        #s = s.replace("","").replace("","").replace("","").replace("","").replace("","").replace("","")
        return s

if __name__ == "__main__":
    ConstantBuilder().run()


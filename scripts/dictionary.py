# *******************************************************************************************
# *******************************************************************************************
#
#      Name :      dictionary.py
#      Purpose :   Render dictionary
#      Date :      21st March 2026
#      Author :    Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

import sys,os,re

from build import *

# *******************************************************************************************
#
#                               Dictionary builder class
#
# *******************************************************************************************

class MainBuilder(AbstractBuilder):
    def __init__(self):
        AbstractBuilder.__init__(self)
        self.byteCodes = {}
        self.codeWords = {}

        self.nextByteCode = 4

    def processInclude(self,f):
        pass

    def processAssembler(self,f):
        last = ""
        for s in open(f).readlines():
            if last.find(".bytecode") > 0:
                m = re.match("^\\s*\\.bytecode\\s*\\\"(.*?)\\\"\\s*$",last)
                assert m is not None,"Dictionary scan ["+s+"]"
                assert re.match("^(.*?)\\:\\s*$",s) is not None,"Bad/Missing Label "+s
                name = m.group(1).strip().lower()
                if name.find("::") > 0:
                    name = name.split("::")
                    code = int(name[1])
                    name = name[0]
                else:
                    code = self.nextByteCode
                    self.nextByteCode += 1
                self.byteCodes[name] = [ code, s.strip()[:-1] ]

            if last.find(".codeword") > 0:
                m = re.match("^\\s*\\.codeword\\s*\\\"(.*?)\\\"\\s*$",last)
                assert m is not None,"Dictionary scan ["+s+"]"
                assert re.match("^(.*?)\\:\\s*$",s) is not None,"Bad/Missing Label "+s
                name = m.group(1).strip().lower()
                self.codeWords[name] = [ s.strip()[:-1] ]

            last = s

    def footer(self):
        print("\t.section\tcode")
        print("Dictionary:")
        for name,info in self.byteCodes.items():
            self.renderDictionaryItemBytecode(name,info)
        for name,info in self.codeWords.items():
            self.renderDictionaryItemCodewords(name,info)
        print("\t.byte\t0")
        print("\t.endsection")

    def renderDictionaryItemBytecode(self,name,value):
        xname = [ord(x) for x in name.upper()]
        xname[-1] |= 0x80
        print("\t.byte\t{0} ; {1}".format(",".join(["${0:02x}".format(x) for x in xname]),name))
        print("\t.word\t{0}".format(value[0]))

    def renderDictionaryItemCodewords(self,name,value):
        xname = [ord(x) for x in name.upper()]
        xname[-1] |= 0x80
        print("\t.byte\t{0} ; {1}".format(",".join(["${0:02x}".format(x) for x in xname]),name))
        print("\t.word\t{0}-1".format(value[0]))

if __name__ == "__main__":
    MainBuilder().run()


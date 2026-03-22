# *******************************************************************************************
# *******************************************************************************************
#
#      Name :      documentation.py
#      Purpose :   Render documentation
#      Date :      21st March 2026
#      Author :    Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

import sys,os,re

from build import *
from synonyms import *

# *******************************************************************************************
#
#                               Documentation builder class
#
# *******************************************************************************************

class DocumentBuilder(AbstractBuilder):
    def __init__(self):
        AbstractBuilder.__init__(self)
        self.documents = {}
        self.currentDoc = ""
        self.synonyms = Synonyms().get()

    def processInclude(self,f):
        pass

    def processAssembler(self,f):
        for s in open(f).readlines():
            if s.startswith(";;"):
                self.currentDoc = (self.currentDoc+" "+s[3:].strip()).strip()
            if s.find(".bytecode") > 0:
                m = re.match("^\\s*\\.bytecode\\s*\\\"(.*?)\\\"\\s*$",s)
                if self.currentDoc != "":
                    self.documents[m.group(1).strip().lower()] = self.currentDoc
                    self.currentDoc = ""
            if s.find(".codeword") > 0:
                m = re.match("^\\s*\\.codeword\\s*\\\"(.*?)\\\"\\s*$",s)
                if self.currentDoc != "":
                    name = m.group(1).strip().lower()
                    self.documents[name] = self.currentDoc
        for syn,real in self.synonyms.items():
            if real in self.documents:
                self.documents[syn] = self.documents[real]

    def header(self):
        print("# M7 Vocabulary")

    def footer(self):
        words = [x for x in self.documents.keys()]
        words.sort()
        for w in words:
            print("## {0}".format(w))
            print(self.documents[w])

if __name__ == "__main__":
    DocumentBuilder().run()


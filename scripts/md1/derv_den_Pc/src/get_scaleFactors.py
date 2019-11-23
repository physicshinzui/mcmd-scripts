#!/work1/t2g-16IJ0004/hayami/anaconda2/bin/python
import sys
import os
import commands

"""
Usage:
    python get_scaleFactors.py [INPUT md1 directory path]

Output:
  List of Termpeatures derived from md.out in md1.

"""

def convert_toTem(factor):
  Tempeature = 503.217 / float(factor)
  return Tempeature

fout = open("TsOut.inp", "w")
Md1Path = sys.argv[1]

DirNames = commands.getoutput("ls -v %s"%(Md1Path)).split()
print DirNames
Ts = []
for DirName in DirNames:
  factor = commands.getoutput("cat %s/%s/n1/md.out | grep 0:"%(Md1Path,DirName)).split()[1]
  fout.write(str(convert_toTem(factor))+"\n")
fout.close()

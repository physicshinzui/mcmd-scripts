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

#Md1Path="/work1/t2g-16IJ0004/siida/02_s100b_ctd_work/md1/"
DirNames = commands.getoutput("ls -v %s"%(Md1Path)).split()
print DirNames
Ts = []
for DirName in DirNames:
  factor = commands.getoutput("cat %s/%s/n1/md.out | grep 0:"%(Md1Path,DirName)).split()[1]
  fout.write(str(convert_toTem(factor))+"\n")
#  fout.write("%s/%s/n1/md.out"%(Md1Path,DirName)+"\n")
#  fout.write("   *Scale factor: "+factor+"\n")
#  fout.write("   *Temperature : "+str(convert_toTem(factor))+"\n")
#  Ts.append(str(convert_toTem(factor)))
fout.close()

#os.system("ifort -o derv_de_Pc.exe derv_den_Pc.f" )
#DistribDirPath="../distrib"
#for i, T in enumerate(Ts,1):
#  print i, T
#  os.system("rm -rf %s"%(i))
#  os.system("mkdir %s"%(i))
#  os.system("ln -s %s/%s/e1.pdf fort.10"%(DistribDirPath, i) )
#  os.system("ln -s %s/dden.dat fort.20"%(i) )
#  os.system("./derv_de_Pc.exe %s"%(T))
#  os.system("rm fort.10 fort.20")
#  

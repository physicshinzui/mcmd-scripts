#!/work1/t2g-16IJ0004/hayami/anaconda2/bin/python

import sys
import commands

#nargs = len(sys.argv)
#print nargs
#if 2 != nargs: sys.exit("Please specify a path containing coefficients.")

TransitionSteps = 10000 #sys.argv[1]
NoOfVStates = 7
PathCoefs = "/work1/t2g-16IJ0004/siida/02_s100b_ctd_work/for_next/fit_dden/md1/e1_fort.20" #sys.argv[2]
PathHeader= "head.info"

#***Read e1.fort20 and save coeffs
finCoefs = open(PathCoefs, "r")
PolyOrder = int(finCoefs.readline().strip())
print "Polynomical order = ", PolyOrder
print "Coefficients: "

Coefs = []
for iter, line in enumerate(finCoefs, 1):
  if iter == PolyOrder+4: break 
  print "  ", iter, line
  Coefs.append(line.strip())

#***
fout = open("ttp_v_mcmd.inp", "w")
header = []
for line in open(PathHeader,"r"):
  if line.strip() == "<-- input an interval (steps)":
    fout.write(line.strip().replace("<-- input an interval (steps)", str(TransitionSteps))+"\n")
  elif line.strip() == "<-- insert lines":
    for iter in xrange(1, NoOfVStates+1):
      fout.write(str(PolyOrder)+"\n")
      print iter
      for coef in Coefs:
        fout.write(coef+"\n")
  else:
    fout.write(line)

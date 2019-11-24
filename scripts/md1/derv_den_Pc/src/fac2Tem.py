#!/usr/local/bin/python
import sys 

def convertToTemperature(factor):
    Tempeature = 503.217 / float(factor)
    return Tempeature

if __name__ == "__main__":
    T = convertToTemperature(sys.argv[1])
    print(T)

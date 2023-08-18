#! /usr/bin/env python

#import importlib
#import yaml
#import inspect
#import os, sys, glob, pathlib, shutil, re, subprocess, signal, shutil, time, calendar
import argparse
import os, sys

lib_path = os.path.join(os.path.dirname(__file__), 'lib', 'python')
sys.path.append(lib_path)

class VHEX2VHEX():

  #==================================
  def __init__(self, args):
    self.addr   = 0
    self.darray = []
    self.final = []

    self.readFile(args.input_file)
    self.outdata(args.bus_width)
    self.printFile()

  #==================================
  def readFile(self, filename):
    if not os.path.exists(args.input_file):
      print("Error...File %s does not exist\n"%(args.input_file))
      exit(1)

    first = True
    with open(args.input_file, "r") as file:
      for line in file:
        line = line.strip()
        if line[0] == '@':
          self.extractAddress(line, first)
          first = False
        else:
          self.parseLine(line)
    
  #==================================
  def extractAddress(self, line, first):
    addr = line[1:]
    aval = int("0x"+addr,16)
    if not first:
      adiff = aval - self.addr
      for r in range(adiff):
        self.darray.append("00")
    self.addr = aval

  #==================================
  def printFile(self):
    with open(args.output_file, "w") as file:
      for f in self.final:
        file.write(f+"\n")

  #==================================
  def parseLine(self, line):
    ll = line.split(" ")
    cnt = len(ll)
    for l in ll:
      self.darray.append(l)
    self.addr += cnt

  #==================================
  def outdata(self, modval):
    lstr =""
    mod = 0
    for a in self.darray:
      lstr  = a+lstr
      mod +=1
      if mod == modval:
        mod = 0
        self.final.append(lstr)
        lstr = ""

if __name__=="__main__":
  #=======================================
  # Options
  #=======================================
  parser = argparse.ArgumentParser(prog="regress.py", description='Run Regression', epilog = 'End')
  parser.add_argument('-b', '--bus_width',  type=int, default = 4, dest='bus_width', help='Set bus width in bytes')
  parser.add_argument("input_file",  type=str, help="Enter input file" )
  parser.add_argument("output_file", type=str, help="Enter output file" )
  args = parser.parse_args()

  
  tr = VHEX2VHEX(args) 


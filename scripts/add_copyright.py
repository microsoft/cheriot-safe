
# =====================================================
# Copyright (c) Microsoft Corporation.
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#    http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# =====================================================


 #!/usr/bin/env python

import argparse
import glob
#from pathlib import Path
import os

copyright = [
  '=====================================================',
  'Copyright (c) Microsoft Corporation.', '',
  'Licensed under the Apache License, Version 2.0 (the "License");',
  'you may not use this file except in compliance with the License.',
  'You may obtain a copy of the License at', '',
  '   http://www.apache.org/licenses/LICENSE-2.0', '',
  'Unless required by applicable law or agreed to in writing, software',
  'distributed under the License is distributed on an "AS IS" BASIS,',
  'WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.',
  'See the License for the specific language governing permissions and',
  'limitations under the License.',
  '====================================================='
]

filetypes = {
  ".rb"  : 1,
  ".py"  : 1,
  ".imk" : 1,
  ".yml" : 1,
  ".tcl" : 1,
  ".xdc" : 1,
  ".sh"  : 1,
  ".mk" : 1,
  ".ucli" : 1,

  ".v"   : 2,
  ".vf"  : 2,
  ".sv"  : 2,
  ".svh" : 2,
  ".c"   : 2,
  ".cc"  : 2,
  ".cpp" : 2,
  ".h"   : 2,


  ".ld"  : 3,
  ".S"   : 3,
  ".s"   : 3,

}


#==================================================
def getCopyRight(exttype):
  string = ""
  if exttype == 1:
    for c in copyright:
      string += "# %s\n"%(c)
  elif exttype == 2:
    for c in copyright:
      string += "// %s\n"%(c)
  elif exttype == 3:
    string += '/*\n'
    for c in copyright:
      string += "%s\n"%(c)
    string += '*/\n'
  return string

#==================================================
def CopyRightCheck(lines, filename):
  cr_found = False
  cr_cnt = 0
  for l in lines:
    if 'Copyright' in l:
      cr_cnt += 1
      cr_found = True
  if cr_cnt > 1:
    print("Copyright found %d times in %s"%(cr_cnt, filename))
  return cr_found
  
#==================================================
def checkCopyRight(path):
  no_cr_list = []
  files = glob.glob(path, recursive=True)
  fcnt = 0
  cr_cnt=0
  for f in files:
    if os.path.isfile(f):
      fcnt += 1

      # Open File
      with open(f,"r") as fh:
        lines = fh.readlines()

      if CopyRightCheck(lines, f):
        cr_cnt +=1
      else:
        no_cr_list.append(f)
                
  print("%4d: Files Scanned"%(fcnt))
  print("%4d: Files with Copyright"%(cr_cnt))
  print("%4d: Files without Copyright"%(fcnt - cr_cnt))
  for ncr in no_cr_list:
    print("      %s"%(ncr))

#==================================================
def addCopyRight(path):
  files = glob.glob(path, recursive=True)
  fcnt = 0
  fchanged = 0
  for f in files:
    # Check if file exist
    if os.path.isfile(f):
      fcnt +=1

      # Check for Makefile and other types of files
      name,ext = os.path.splitext(f)
      if os.path.basename(name) == "Makefile":
        exttype = 1
      elif filetypes.get(ext):
        exttype = filetypes[ext]
      else:
        exttype = 0

      # Only do it if we know what the extenstion type is
      if exttype > 0:

        # Open File
        with open(f,"r") as fh:
          lines = fh.readlines()
      
        has_cr = False
        # Generate Copyright
        fchanged +=1
        with open(f,"w") as fo:
          fo.write('\n')
          fo.write(getCopyRight(exttype))
          fo.write('\n')
          for l in lines:
            fo.write(l)
      else:
        print("File %s not changed"%(f))

    else:
      if not os.path.isdir(f):
        print("File %s not changed"%(f))
    

  num_files = len(files)
  print("%d Files"%(num_files))
  print("%d Dirs"%(num_files-fcnt))
  print("%d Files Scanned"%fcnt)
  print("%d Files Updated"%fchanged)

parser = argparse.ArgumentParser(prog="regress.py", description='Run Regression', epilog = 'End')
parser.add_argument('-c', '--check',  action="store_true", dest='check', help="Check for Copyright" )
parser.add_argument("input_file",  type=str, help="Enter input file (Enter \"./**\" to glob files)" )
args = parser.parse_args()

if args.check:
  checkCopyRight(args.input_file)
else:
  addCopyRight(args.input_file)

  

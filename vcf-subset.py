#!/data004/software//GIF/GIF_kb/bin//python

import random
import sys
import re

text_file = open(sys.argv[1], "r")
#print text_file
import sys
#text_file = sys.stdin
#lines = text_file.readlines()
lines = text_file.readlines()


regionStep=10000
start=1
end=start+regionStep
chrom="Chr01"
i=0
temp=[]
for line in lines:   	
 #print line
 if not re.search('#', line):
    fields = line.strip().split()
    #print int(fields[1]),chrom,fields[0],start,end
    if (int(fields[1])>=end) and (chrom == fields[0]):
       if len(temp)>0:
          print temp[random.sample(range(len(temp)),1)[0]]
          temp=[]
       start=int(fields[1])-1
       end=start+regionStep
       chrom=fields[0]
       temp.append(line) 
    elif (int(fields[1])>=end) or (chrom != fields[0]):
       if len(temp)>0:
          print temp[random.sample(range(len(temp)),1)[0]]
          temp=[]
       start=+1
       end=start+regionStep
       chrom=fields[0]
       temp.append(line)     
    else:
       if (int(fields[1]) > start) and (int(fields[1])<end) and fields[0]==chrom:
        temp.append(line)
        
if len(temp)>0:
          print temp[random.sample(range(len(temp)),1)[0]]
   

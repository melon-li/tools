#!/usr/bin/python 
#coding:utf-8
import os
import sys
import re

def usage():
    help_info="Usage: %s <recinfo_file> <sendinfo_file>" % sys.argv[0]
    print help_info

def main():
    try: 
        recinfo_file=sys.argv[1]
        sendinfo_file=sys.argv[2]
    except:
        usage()
        sys.exit(-1)
    

    if not os.path.exists(recinfo_file):
        print "ERROR: recinfo_file does not exists!"
        usage()
        sys.exit(-1)
    
    if not os.path.exists(sendinfo_file):
        print "ERROR: recinfo_file does not exists!"
        usage()
        sys.exit(-1)

    delays = []
    cnt = 0
    with open(sendinfo_file, 'r') as sf:
         sinfo = sf.read()

    with open(recinfo_file, 'r') as rf:
        rl = rf.readline()
        while True:
            rl = rf.readline()
            if not rl: break
            if re.search('#', rl): continue
            rl_list = rl.split()
            if rl_list[1] == '0': continue
            pattern = rl_list[0] + ".*?\n"
            result = re.search(pattern, sinfo) 
            if result:
                sl = result.group()
                sl_list = sl.split()
                delay_time = int(rl_list[3]) - int(sl_list[3])
                if delay_time == 0:
                    print rl_list[0]
                delays.append(delay_time)
    #print len(delays)
    print(delays)
    print sum(delays)/float(len(delays))
    print sum(delays)/float(cnt)
    print(len(delays), cnt)
          
if __name__ == "__main__":
    sys.exit(main()) 

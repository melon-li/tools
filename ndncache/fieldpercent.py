#!/usr/bin/python 
#coding:utf-8
'''Function:analyze bro conn logs and print specific field percent,
@param: log directory
@param: field list analyze
author:melon li
date: 2016.03.28
'''
import sys
import os
FIELDS=['ts', 'uid', 'id.orig_h', 'id.orig_p', 'id.resp_h', 'id.resp_p', 
       'proto', 'service', 'duration', 'orig_bytes', 'resp_bytes', 'conn_state',
       'local_orig','local_resp', 'missed_bytes', 'history', 'orig_pkts', 'orig_ip_bytes',   
        'resp_pkts', 'resp_ip_bytes', 'tunnel_parents']
#FIELDS_PERCENT=['id.orig_h', 'id.orig_p', 'id.resp_h', 'id.resp_p', 
#       'proto', 'service duration', 'orig_bytes', 'resp_bytes', 'conn_state',
#       'local_orig']
TYPES=['time', 'string', 'addr', 'port', 'addr', 'port', 'enum', 'string', 'interval',
       'count', 'count', 'string', 'bool', 'bool', 'count', 'string', 'count', 'count',
       'count', 'count', 'string']

def usage():
    print "Usage:%s <log_dir> <fields>" % sys.argv[0]
    print "\tFor example: %s /home/ \"id.resp_p id.orig_p\"" % sys.argv[0]
    sys.exit(1)

try:
    log_dir = sys.argv[1]
    fields = sys.argv[2]
except:
    usage()

if not os.path.isdir(log_dir):
    print "ERROR: %s does not exist!" % log_dir
    usage()
    sys.exit(2)


#print log_dir
#print fields
#list conn.log* files
files = os.listdir(log_dir)
files = [elem for elem in files if elem.find('conn.log') != -1 ]
files.sort()

resp_pp = {}

for f in files:
    f_path = os.path.join(log_dir, f)
    with open(f_path, 'r') as fp:
        while 1:
            line = fp.readline()
            if not line: break
            index = FIELDS.index('id.resp_p')
            values = line.split('\t')
            #print values
            #print len(values), len(FIELDS)
            if len(values) == len(FIELDS) and line.find('#') < 0:
                if values[index] in resp_pp: 
                    resp_pp[values[index]] = resp_pp[values[index]] + int(values[FIELDS.index('resp_ip_bytes')])
                else:
                    resp_pp[values[index]] = int(values[FIELDS.index('resp_ip_bytes')])

total = sum(resp_pp.values())
for k,v in resp_pp.iteritems():
    if total: print '%s: %.2f%%' % (k,(v*100.0/total))

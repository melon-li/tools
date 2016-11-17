#!/usr/bin/python
#coding=utf-8
"""argparse template.

None.
"""
import sys
import os
import argparse


def init_parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('-v', '--verbose', type=int, choices=[0, 1],default=1,
          help="verbose, 1 stands for verbose, 0 not") 
    return parser

def main():
    parser = init_parse_args()
    args = parser.parse_args()
    v = args.verbose

    if v:
        pass
    else:
        parser.print_help()
        sys.exit(1)

if __name__ == '__main__':
    sys.exit(main())

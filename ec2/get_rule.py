#!/usr/bin/env python3

import os
import json
import getopt
import sys
def get_content(input_file):
    with open(input_file, 'r') as inFile:
        all_content=inFile.read()
    json_content=json.loads(all_content)
    print(json_content['SecurityGroups'][0]['IpPermissions'][0]['IpRanges'])
                   
            
def printHelp():
    print('Usage: get_ip.py -i INPUT_FILE')
if __name__ == '__main__':
    input_filename=None
    options, remainder = getopt.getopt(sys.argv[1:], 'i:h', ['input=',
                                                         'help'
                                                         ])
    for opt, arg in options:
        if opt in ('-i', '--intput'):
            input_filename = arg
        elif opt in ('-h', '--help'):
            printHelp()
            sys.exit()
    if input_filename  == None:
        print("Missing necessary paramters")
        printHelp()
        sys.exit()
    get_content(input_filename)

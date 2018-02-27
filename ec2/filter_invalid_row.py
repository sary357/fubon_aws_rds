#!/usr/bin/env python3

import os
import getopt
import sys
def filter(input_file, output_file, error_output_file, skip_lines=0):
    index=0
    with open(input_file, 'r') as inFile:
        with open(output_file, 'w') as outFile:
            with open(error_output_file, 'w') as errFile:
                for line in inFile.readlines():
                    if index >= skip_lines: 
                        # 14 commas = 15 columns
                        tmp_arr=line.split(',')
                        if len(tmp_arr) == 15:
                            outFile.write(line)
                        else:
                            errFile.write(line)
                    else:
                         index=index+1
                   
            
def printHelp():
    print('Usage: filter_invalid_row.py -i INPUT_FILE -o OUTPUT_FULE -e ERROR_OUTPUT_FILE -k SKIP_LINES')
if __name__ == '__main__':
    input_filename=None
    output_filename=None
    error_output_filename=None
    skip_lines=0
    options, remainder = getopt.getopt(sys.argv[1:], 'i:o:e:k:h', ['input=','output=', 'error_output='
                                                         'skip_lines=',
                                                         'help',
                                                         ])
    for opt, arg in options:
        if opt in ('-i', '--intput'):
            input_filename = arg
        if opt in ('-o', '--output'):
            output_filename = arg
        elif opt in ('-e', '--error_output'):
            error_output_filename=arg
        elif opt in ('-k', '--skip_lines'):
            skip_lines=int(arg)
        elif opt in ('-h', '--help'):
            printHelp()
            sys.exit()
    if input_filename  == None or output_filename == None or error_output_filename == None:
        print("Missing necessary paramters")
        printHelp()
        sys.exit()
    filter(input_filename, output_filename, error_output_filename, skip_lines=skip_lines)

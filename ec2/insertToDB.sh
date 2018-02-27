#!/bin/sh
#######################################################
#
# Download file from http://www.fia.gov.tw/opendata/bgmopen1.csv
# and upload to RDS if necessary
#
#######################################################
PATH=/bin:/usr/bin:/usr/local/bin
CURRENT_DIR=`dirname $0`
TMP_FOLDER="tmp/"
TARGET_FILE_NAME="bgopen1.csv"
PYTHON_COMMAND="python3.6"

echo "Phase II: import into RDS"
TARGET_FILE_PATH=$CURRENT_DIR/$TMP_FOLDER/$TARGET_FILE_NAME
echo "Started to insert data into RDS at: "
date +%Y-%m-%d' '%H:%M:%S

export PGPASSWORD=ji3g4cl3bp6 

# step 1: delete all data
echo "1. delete from bgopen1"
psql --set=sslmode=require -h fubon-data.ccxwpm2mpssl.us-east-1.rds.amazonaws.com -p 5432 -U fubon fubon_opendata_db -c "delete from bgopen1;"

# step 2: import 
echo "2. import data into bgopen1"
declare -i line_number=`wc -l $TARGET_FILE_PATH | awk '{print $1}'`
echo "Total line number in original data file: $line_number"
$PYTHON_COMMAND $CURRENT_DIR/filter_invalid_row.py -i $TARGET_FILE_PATH -o $TARGET_FILE_PATH\.tmp -e $TARGET_FILE_PATH\.err -k 2
IMPORT_FILE_NAME=$TARGET_FILE_PATH\.tmp
line_number=`wc -l $IMPORT_FILE_NAME | awk '{print $1}'`
echo "Total line number in import data file: $line_number" # the first 2 lines are useless
psql --set=sslmode=require -h fubon-data.ccxwpm2mpssl.us-east-1.rds.amazonaws.com -p 5432 -U fubon fubon_opendata_db  -c "\copy bgopen1 FROM '$IMPORT_FILE_NAME' with delimiter as ',';"
rm -f $IMPORT_FILE_NAME

# step 3: verification
echo "3. current number of records in bgopen1"
psql --set=sslmode=require -h fubon-data.ccxwpm2mpssl.us-east-1.rds.amazonaws.com -p 5432 -U fubon fubon_opendata_db -c "select count(1) from bgopen1;"

echo "Finished to insert data into RDS at: "
date +%Y-%m-%d' '%H:%M:%S

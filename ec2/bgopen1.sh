#!/bin/sh
#######################################################
#
# Download file from http://www.fia.gov.tw/opendata/bgmopen1.csv
# and upload to RDS if necessary
#
#######################################################
PATH=/bin:/usr/bin:/usr/local/bin
CURRENT_DIR=`dirname $0`
SOURCE_URL="http://www.fia.gov.tw/opendata/bgmopen1.csv"
TARGET_FILE_NAME="bgopen1.csv"
TMP_FOLDER="tmp/"
HISTORY_FOLDER="historical/"

echo "Phase I: download the latest bgopen1.csv"
# step 0: prepare folders if they don't exist
mkdir -p $CURRENT_DIR/$TMP_FOLDER
mkdir -p $CURRENT_DIR/$HISTORY_FOLDER
echo "Start downloading file at: "
date +%Y-%m-%d' '%H:%M:%S

# step 1: download from SOURCE_URL
curl -o $CURRENT_DIR/$TMP_FOLDER/$TARGET_FILE_NAME $SOURCE_URL 

echo "Finished downloading file at: "
date +%Y-%m-%d' '%H:%M:%S

# step 2: compare with the one we download yesterday
CURRENT_MD5=`md5sum $CURRENT_DIR/$TMP_FOLDER/$TARGET_FILE_NAME  | awk '{print $1}'`

echo "Current MD5: $CURRENT_MD5"

declare -i NEED_TO_MODIFY_RDS=1

if [ -e $CURRENT_DIR/$HISTORY_FOLDER/$TARGET_FILE_NAME ]; then
    HISTORY_MD5=`md5sum $CURRENT_DIR/$HISTORY_FOLDER/$TARGET_FILE_NAME  | awk '{print $1}'`
    echo "Historical MD5: $HISTORY_MD5"
    if [ $CURRENT_MD5 = $HISTORY_MD5 ]; then
        NEED_TO_MODIFY_RDS=0
        rm -f $CURRENT_DIR/$TMP_FOLDER/$TARGET_FILE_NAME
        echo "No need to update RDS. exit "
    fi 
fi

if [ $NEED_TO_MODIFY_RDS -eq 1 ]; then
    echo "update data in RDS"
    rm -f $CURRENT_DIR/$HISTORY_FOLDER/$TARGET_FILE_NAME
   
    /bin/sh $CURRENT_DIR/insertToDB.sh

    mv  $CURRENT_DIR/$TMP_FOLDER/$TARGET_FILE_NAME  $CURRENT_DIR/$HISTORY_FOLDER/$TARGET_FILE_NAME
fi

sleep 60s
CUR_TIME=`date +%Y-%m-%d' '%H:%M:%S`

echo "I am going to shutdown myself at $CUR_TIME"
/sbin/shutdown -h now

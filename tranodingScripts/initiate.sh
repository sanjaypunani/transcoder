#!/bin/bash
BASEDIR=$(dirname $0)
. ${BASEDIR}/config.sh
file=$1
folder=$2
# fix file named with spaces and create variable withou basename
newfile=$file;

filebase="`basename "${newfile%.*}"`"
echo $filebase
# create folder for storing ts files
cd $folder

MAIN_DIR=$filebase
rm -R $MAIN_DIR

aws s3 rm s3://$s3bucket/$MAIN_DIR/ --region ap-south-1 --recursive > l$
mkdir -p $MAIN_DIR

# create variant m3u8 - ugly way
echo "#EXTM3U" > $MAIN_DIR/$filebase.m3u8

# echo "DONE"
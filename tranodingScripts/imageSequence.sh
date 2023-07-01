#!/bin/bash

# Accepts three parameters
# 1. File that needs to be transcoded
# 2. folder where the transcoded result needs to go
# 3. Random number in which series the ts segments will be named.

# ffmpeg should have binary files in this location
BASEDIR=$(dirname $0)
. ${BASEDIR}/config.sh
FFMPEG=/home/videotap/bin
startTime=$(date)
file=$1
folder=$2
randomNum=$3
# fix file named with spaces and create variable withou basename
newfile=$file;

filebase="`basename "${newfile%.*}"`"
#echo $filebase
# create folder for storing ts files
cd $folder

MAIN_DIR=$filebase
mkdir -p $MAIN_DIR/$filebase-imageSeq
# # encode to the video to different qualities

#720p 5400
#ffmpeg -i input.mov -r 0.25 output_%04d.png

$FFMPEG/ffmpeg -i $newfile -r 1 $MAIN_DIR/$filebase-imageSeq/$filebase-%04d.720p.jpg

# create variant m3u8 - ugly way
cd $MAIN_DIR/$filebase-imageSeq/

USCOUNTER=$randomNum

for fil in *.jpg
do
  USCOUNTER=$(expr $USCOUNTER + 1)
  #mv "$fil" "$R$NUM$(myfunc).ts"
  TEMN="$USCOUNTER"
  
  mv "$fil" "$TEMN.jpg"
done


cd $folder


# aws s3 cp --recursive $filebase/$filebase-imageSeq/ s3://$imagebucket/$filebase-imageSeq --region ap-south-1 --acl public-read > l$
azcopy --recursive --source $filebase/$filebase-imageSeq --destination $imgout --dest-sas $sas --quiet

rm -rf $filebase
rm $newfile
# upload to s3

# cd ../..
# rm -R $MAIN_DIR
# echo "DONE"
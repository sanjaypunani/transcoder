#!/bin/bash

# Accepts three parameters
# 1. File that needs to be transcoded
# 2. File that will be output file

# ffmpeg should have binary files in this location
FFMPEG=/home/videotap/bin
file=$1
fileOut=$2
folder=$3
cd $folder

$FFMPEG/ffmpeg -i $file -codec copy $fileOut
#$FFMPEG/ffmpeg -i $file -map 0 -c:v libx264 -c:a copy $fileOut

rm $file

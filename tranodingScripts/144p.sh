#!/bin/bash

# Accepts three parameters
# 1. File that needs to be transcoded
# 2. folder where the transcoded result needs to go
# 3. Random number in which series the ts segments will be named.

# ffmpeg should have binary files in this location
#FFMPEG=/usr/local/bin/ffmpeg
#FFMPEG=/usr/local/bin/
#FFMPEG=/snap/bin
FFMPEG=/usr/bin/
# FFMPEG=/opt/homebrew/bin/


startTime=$(date)
file=$1
folder=$2
#randomNum=$3
# fix file named with spaces and create variable withou basename
newfile=$file;

filebase="`basename "${newfile%.*}"`"
#echo $filebase
# create folder for storing ts files
cd $folder

MAIN_DIR=$filebase
mkdir -p $MAIN_DIR/$filebase-144p

echo "filebase $filebase"
echo "newfile $newfile"
echo "folder $folder"
#myfunc(){
#      echo "$(date +%N)"
#}
#
#radn(){
#	# R=shuf -i 100000-999999 -n 1
#	echo "$(shuf -i 100000-999999 -n 1)"
#}

# # encode to the video to different qualities

#144p 120
# $FFMPEG/ffmpeg -i $newfile -r 25 \
#  	-acodec aac -b:a 32k -map 0:a:0 -map 0:v -c:s copy -psnr -f segment -vbsf h264_mp4toannexb -flags -global_header  -segment_format mpegts -segment_list_type m3u8 -vcodec libx264 \
# 	-vf "yadif=0, scale=416:trunc(ow/a/2)*2" -vsync -1 -r 15 -hls_flags independent_segments \
# 	-crf 20 -b:v 120k -maxrate 120k -bufsize 120k -refs 3 -profile:v baseline -bf 2 -g 30 -force_key_frames "expr:gte(t,n_forced*1)" -f segment -segment_time 1 -segment_list $MAIN_DIR/$filebase-144p/$filebase-144p.m3u8  $MAIN_DIR/$filebase-144p/"%04d".144p.ts > log/$filebase-144p.log 2>&1 ;

$FFMPEG/ffmpeg -i $newfile -dn -acodec aac -ar 48000 -b:a 32k -map 0 -c:s copy -psnr -f segment \
  -vbsf h264_mp4toannexb -flags -global_header  -segment_format mpegts -segment_list_type m3u8 -vcodec libx264 \
  -vf "yadif=0, scale=256:trunc(ow/a/2)*2" -vsync -1 -r 15 -crf 18 -b:v 240k -maxrate 256k -bufsize 250k \
  -profile:v high -bf 2 -g 30 -force_key_frames "expr:gte(t,n_forced*3)" -f segment -segment_time 3 -segment_list $MAIN_DIR/$filebase-144p/$filebase-144p.m3u8 $MAIN_DIR/$filebase-144p/"%04d".144p.ts
  #> log/$filebase-144p.log 2>&1;
#end144p=$(date)
#COMMAND FOR 5 SECONDNS TS SEGMENTS -hls_time 1
#$FFMPEG/ffmpeg -i $newfile -deinterlace -vf "yadif=0, scale=256:trunc(ow/a/2)*2" \
# -vsync 1 -c:a aac -ar 48000 -b:a 128k -ac 2 -af "aresample=async=1:min_hard_comp=0.100000:first_pts=0" -sample_fmts s32 -c:v h264 -profile:v baseline -crf 20 -g 48 -keyint_min 48 -sc_threshold 0 \
#  -b:v 120k -maxrate 120k -bufsize 120k -force_key_frames "expr:gte(t,n_forced*1)" -async 1 \
#   -hls_time 1 -hls_playlist_type vod -hls_segment_filename $MAIN_DIR/$filebase-144p/"%04d".144p.ts $MAIN_DIR/$filebase-144p/$filebase-144p.m3u8

echo $MAIN_DIR/$filebase-144p/

cd $MAIN_DIR/$filebase-144p/

#USCOUNTER=$randomNum


#rm  $filebase-144p.m3u81
#while read line;
#do
#  if [[ $line == *".ts" ]];
#    then
#      USCOUNTER=$(expr $USCOUNTER + 1)
#      USCOUNTERLEFT=$((7* $USCOUNTER))
#      USCOUNTERRIGHT=$((7*7*7*7*3* $USCOUNTER))
#              TEMN="$USCOUNTERLEFT$USCOUNTER$USCOUNTERRIGHT"
#              #TEMN="$(radn)$USCOUNTER$(myfunc)"
#
#        echo $TEMN.ts  >>  $filebase-144p.m3u81
#        mv "$line" "$TEMN.ts"
#    else
#        echo $line >>  $filebase-144p.m3u81
#    fi
#
#
#
#   # do something with $line here
#done <$filebase-144p.m3u8

#mv $filebase-144p.m3u81 $filebase-144p.m3u8

echo $USCOUNTER
cd $folder
# create variant m3u8 - ugly way
echo "#EXTM3U" >>  $MAIN_DIR/$filebase.m3u8
echo "#EXT-X-STREAM-INF:PROGRAM-ID=1,BANDWIDTH=120000,RESOLUTION=256x144,NAME=\"144p\"" >>  $MAIN_DIR/$filebase.m3u8
echo "$filebase-144p/$filebase-144p.m3u8"  >> $MAIN_DIR/$filebase.m3u8
# upload to s3

# echo "DONE"

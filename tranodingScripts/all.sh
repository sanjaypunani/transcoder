#!/bin/bash

FFMPEG=/home/videotap/bin
startTime=$(date)
file=$1
folder=$2
# fix file named with spaces and create variable withou basename
newfile=$file;

filebase="`basename "${newfile%.*}"`"
echo $filebase
# create folder for storing ts files
cd $folder

MAIN_DIR=$filebase
mkdir -p $MAIN_DIR
mkdir -p $MAIN_DIR/$filebase-1080p
mkdir -p $MAIN_DIR/$filebase-720p
mkdir -p $MAIN_DIR/$filebase-480p
mkdir -p $MAIN_DIR/$filebase-360p
mkdir -p $MAIN_DIR/$filebase-240p
mkdir -p $MAIN_DIR/$filebase-144p
# # encode to the video to different qualities

# #1080p 5400
$FFMPEG/ffmpeg -i $newfile \
   	-acodec copy -map 0 -c:s copy -psnr -f segment -vbsf h264_mp4toannexb -flags -global_header  -segment_format mpegts -segment_list_type m3u8 -vcodec libx264 \
	-vf "yadif=0, scale=-1:1080" \
	-crf 20 -b:v 5400k -maxrate 5400k -bufsize 5400k -g 30 -hls_time 5 -segment_list $MAIN_DIR/$filebase-1080p/$filebase-1080p.m3u8  $MAIN_DIR/$filebase-1080p/$filebase-%04d.1080p.ts > log/$filebase-1080p.log 2>&1 ; 
end1080p=$(date)
#720p 2400
$FFMPEG/ffmpeg -i $newfile \
   	-acodec copy -map 0 -c:s copy -psnr -f segment -vbsf h264_mp4toannexb -flags -global_header  -segment_format mpegts -segment_list_type m3u8 -vcodec libx264 \
	-vf "yadif=0, scale=-1:720" \
	-crf 20 -b:v 2400k -maxrate 2400k -bufsize 2400k -g 30 -hls_time 5 -segment_list $MAIN_DIR/$filebase-720p/$filebase-720p.m3u8  $MAIN_DIR/$filebase-720p/$filebase-%04d.720p.ts > log/$filebase-720p.log 2>&1 ; 
end720p=$(date)
#480p 1200
$FFMPEG/ffmpeg -i $newfile \
   	-acodec copy -map 0 -c:s copy -psnr -f segment -vbsf h264_mp4toannexb -flags -global_header  -segment_format mpegts -segment_list_type m3u8 -vcodec libx264 \
	-vf "yadif=0, scale=-1:480" \
	-crf 20 -b:v 1200k -maxrate 1200k -bufsize 1200k -g 30 -hls_time 5 -segment_list $MAIN_DIR/$filebase-480p/$filebase-480p.m3u8  $MAIN_DIR/$filebase-480p/$filebase-%04d.4800p.ts > log/$filebase-480p.log 2>&1 ; 
end480p=$(date)
#360p 720
$FFMPEG/ffmpeg -i $newfile \
   	-acodec copy -map 0 -c:s copy -psnr -f segment -vbsf h264_mp4toannexb -flags -global_header  -segment_format mpegts -segment_list_type m3u8 -vcodec libx264 \
	-vf "yadif=0, scale=-1:360" \
	-crf 20 -b:v 720k -maxrate 720k -bufsize 720k -g 30 -hls_time 5 -segment_list $MAIN_DIR/$filebase-360p/$filebase-360p.m3u8  $MAIN_DIR/$filebase-360p/$filebase-%04d.360p.ts > log/$filebase-360p.log 2>&1 ; 
end360p=$(date)
#240p 450
$FFMPEG/ffmpeg -i $newfile \
   	-acodec copy -map 0 -c:s copy -psnr -f segment -vbsf h264_mp4toannexb -flags -global_header  -segment_format mpegts -segment_list_type m3u8 -vcodec libx264 \
	-vf "yadif=0, scale=-1:240" \
	-crf 20 -b:v 450k -maxrate 450k -bufsize 450k -g 30 -hls_time 5 -segment_list $MAIN_DIR/$filebase-240p/$filebase-240p.m3u8  $MAIN_DIR/$filebase-240p/$filebase-%04d.240p.ts > log/$filebase-240p.log 2>&1 ; 
end240p=$(date)
#144p 120
$FFMPEG/ffmpeg -i $newfile \
   	-acodec copy -map 0 -c:s copy -psnr -f segment -vbsf h264_mp4toannexb -flags -global_header  -segment_format mpegts -segment_list_type m3u8 -vcodec libx264 \
	-vf "yadif=0, scale=-1:144" \
	-crf 20 -b:v 120k -maxrate 120k -bufsize 120k -g 30 -hls_time 5 -segment_list $MAIN_DIR/$filebase-144p/$filebase-144p.m3u8  $MAIN_DIR/$filebase-144p/$filebase-%04d.144p.ts > log/$filebase-144p.log 2>&1 ; 
end144p=$(date)
# create variant m3u8 - ugly way
echo "#EXTM3U" > $MAIN_DIR/$filebase.m3u8
echo "#EXT-X-STREAM-INF:PROGRAM-ID=1,BANDWIDTH=120000" >>  $MAIN_DIR/$filebase.m3u8
echo "$filebase-144p/$filebase-144p.m3u8"  >> $MAIN_DIR/$filebase.m3u8
echo "#EXT-X-STREAM-INF:PROGRAM-ID=1,BANDWIDTH=450000" >>  $MAIN_DIR/$filebase.m3u8
echo "$filebase-240p/$filebase-240p.m3u8"  >> $MAIN_DIR/$filebase.m3u8
echo "#EXT-X-STREAM-INF:PROGRAM-ID=1,BANDWIDTH=720000" >>  $MAIN_DIR/$filebase.m3u8
echo "$filebase-360p/$filebase-360p.m3u8"  >> $MAIN_DIR/$filebase.m3u8
echo "#EXT-X-STREAM-INF:PROGRAM-ID=1,BANDWIDTH=1200000" >>  $MAIN_DIR/$filebase.m3u8
echo "$filebase-480p/$filebase-480p.m3u8"  >> $MAIN_DIR/$filebase.m3u8
echo "#EXT-X-STREAM-INF:PROGRAM-ID=1,BANDWIDTH=2400000" >>  $MAIN_DIR/$filebase.m3u8
echo "$filebase-720p/$filebase-720p.m3u8"  >> $MAIN_DIR/$filebase.m3u8
echo "#EXT-X-STREAM-INF:PROGRAM-ID=1,BANDWIDTH=5400000" >>  $MAIN_DIR/$filebase.m3u8
echo "$filebase-1080p/$filebase-1080p.m3u8"  >> $MAIN_DIR/$filebase.m3u8
# upload to s3
aws s3 cp --recursive $filebase/ s3://ffmpegtst/$filebase --acl public-read
# echo "DONE"
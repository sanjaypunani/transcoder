#!/bin/bash

GSUTIL="/Users/varun/Projects/indiaott/google-cloud-sdk/bin"

file=$1
folder=$2
source=$1
destination=$2
# # fix file named with spaces and create variable withou basename
newfile=$file

filebase="$(basename "${newfile%.*}")"

cd $folder

# # upload to s3
# echo $s3bucket
# aws s3 cp --recursive $filebase/ s3://$s3bucket/$filebase --region ap-south-1 --acl public-read > l$
# az storage blob upload --container-name $container_name --file $filebase/ --name $out --sas $sas

echo "DONE"
echo "Transfer Strated"
echo "$filebase"
echo "$newfile"

# cp -r $filebase ~/Projects/gnx/vidclick/server/public/upload/videos/video/$filebase
/usr/bin/sshpass -p "Fh23?^Gwe24"  scp -P 5726 -i /root/transcoder/clickvid -r $filebase root@103.117.156.144:/var/www/html/storage

#scp  -P5726 /home/i2k2admin/trancoding/clickvid -i -r $filebase root@103.117.156.144:/var/www/html/storage
#scp -i ~/Data/key/clickvid -r $filebase ubuntu@135.181.251.193:/var/www/html/storage

#$GSUTIL/gsutil cp -r $filebase gs://indiaotthls/
#azcopy --recursive --source $filebase --destination $out --dest-sas $sas --quiet

#aws s3 cp --recursive $filebase/ s3://indiaotthls/$filebase --region ap-south-1 --acl public-read

rm -rf $filebase
rm $newfile

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

rsync -arv   -e 'ssh -p 5726' /Users/sanjaypunani/Desktop/transcoder/transcoder/clickvid $filebase root@103.117.156.144:/var/www/html/storage

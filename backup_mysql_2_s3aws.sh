#!/bin/bash

# date du jour
backupdate=$(date +%Y-%m-%d)

#répertoire de backup
dirbackup=/backup/backup-$backupdate

#nom du bucket
bucket="bucket-houssem"
s3_bucket="s3://" $bucket

# création du répertoire de backup
/bin/mkdir $dirbackup

# tar -cjf /destination/fichier.tar.bz2 /source1 /source2 /sourceN
# créé une archive bz2
# sauvegarde de /home
/bin/tar -cjf $dirbackup/home-$backupdate.tar.bz2 /home

# sauvegarde mysql
/usr/bin/mysqldump --user=xxxx --password=xxxx --all-databases | /usr/bin/gzip > $dirbackup/mysqldump-$backupdate.sql.gz

#connect to AWS
aws configure set aws_access_key_id $ACCESS_KEY_ID; aws configure set aws_secret_access_key $SECRET_ACCESS_KEY; aws configure set default.region $AWS_DEFAULT_REGION


#create a bucket
aws s3 mb $s3_bucket --region $AWS_DEFAULT_REGION

# upload backup files to s3 bucket
aws s3 cp $dirbackup/home-$backupdate.tar.bz2 $s3_bucket
aws s3 cp $dirbackup/mysqldump-$backupdate.sql.gz $s3_bucket

#config life cycle s3
aws s3api put-bucket-lifecycle-configuration --bucket $bucket --lifecycle-configuration file://s3bucketlifecycle.json

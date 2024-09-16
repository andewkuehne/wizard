#!/bin/bash

# MongoDB connection details
MONGO_HOST="localhost"
MONGO_PORT="27017"
MONGO_USER="admin"
MONGO_PASS="$1"  # Password will be passed as an argument

# Backup details
BACKUP_DIR="/tmp/mongodb_backup"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILENAME="mongodb_backup_${TIMESTAMP}.gz"

# GCS bucket details
GCS_BUCKET="PLACEHOLDER_BACKUP_BUCKET"

# Create backup
mongodump --host $MONGO_HOST --port $MONGO_PORT --username $MONGO_USER --password $MONGO_PASS --out $BACKUP_DIR

# Compress backup
tar -zcvf $BACKUP_FILENAME -C $BACKUP_DIR .

# Upload to GCS bucket
gsutil cp $BACKUP_FILENAME gs://$GCS_BUCKET/

# Clean up
rm -rf $BACKUP_DIR
rm $BACKUP_FILENAME

echo "Backup completed and uploaded to gs://$GCS_BUCKET/$BACKUP_FILENAME"

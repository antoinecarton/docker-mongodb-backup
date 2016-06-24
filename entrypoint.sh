#!/bin/bash

set -e

echo "Starting MongoBD backup: $(date)"

DAY=$(date +%Y%m%d)
DATE=$(date +%Y%m%d_%H%M%S)
FILENAME="backup-$MONGO_DATABASE-$DATE"
FILE="$FILENAME.tar.gz"
OUT_DUMP="dump-$DATE"

cd /backup
mkdir -p $DAY/$DATE
cd $DAY/$DATE
mongodump --quiet -h $MONGO_PORT_27017_TCP_ADDR -p $MONGO_PORT_27017_TCP_PORT --db $MONGO_DATABASE --out $OUT_DUMP
mongodump -h $MONGO_PORT_27017_TCP_ADDR -p $MONGO_PORT_27017_TCP_PORT --db $MONGO_DATABASE --archive=$FILENAME.archive
tar -zcvf $FILE $OUT_DUMP
rm -rf $OUT_DUMP

echo "Backup done: $(date)"

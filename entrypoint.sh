#!/bin/bash

set -e

echo "Starting MongoBD backup..."

NOW=$(date +%Y%m%d)
NOW_TIME=$(date +%Y%m%d_%H%M%S)
FILENAME="backup-$MONGO_DATABASE-$NOW_TIME"
FILE_ARCHIVE="$FILENAME.tar.gz"
OUT_DUMP="dump-$NOW_TIME"

cd /backup
mkdir -p $NOW/$NOW_TIME
cd $NOW/$NOW_TIME
mongodump --quiet -h $MONGO_PORT_27017_TCP_ADDR -p $MONGO_PORT_27017_TCP_PORT --db $MONGO_DATABASE --out $OUT_DUMP
mongodump -h $MONGO_PORT_27017_TCP_ADDR -p $MONGO_PORT_27017_TCP_PORT --db $MONGO_DATABASE --archive=$FILENAME.archive
tar -zcvf $FILE_ARCHIVE $OUT_DUMP
rm -rf $OUT_DUMP

echo "Backup done: $(date)"

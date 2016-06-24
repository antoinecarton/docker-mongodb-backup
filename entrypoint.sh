#!/bin/bash

set -e

NOW=$(date +%Y%m%d)
NOW_TIME=$(date +%Y%m%d_%H%M%S)
FILENAME="backup-$MONGO_DATABASE-$NOW_TIME"
FILE_ARCHIVE="$FILENAME.tar.gz"
OUT_DUMP="dump-$NOW_TIME"

cd /backup
mkdir -p $NOW/$NOW_TIME
cd $NOW/$NOW_TIME

# If there is a USER_ID environment variable, create the user with that UID and use it to exec commands
if [[ -n "$USER_ID" ]] ; then
  echo "[$(date)] Starting MongoBD backup with UID $USER_ID..."
  useradd -u $USER_ID -o -c "" -m mongodb-backup
  chown -R mongodb-backup:mongodb-backup /backup

  exec gosu mongodb-backup:mongodb-backup /bin/bash -c "mongodump --quiet -h $MONGO_PORT_27017_TCP_ADDR -p $MONGO_PORT_27017_TCP_PORT --db $MONGO_DATABASE --out $OUT_DUMP \
  && mongodump -h $MONGO_PORT_27017_TCP_ADDR -p $MONGO_PORT_27017_TCP_PORT --db $MONGO_DATABASE --archive=$FILENAME.archive \
  && tar -zcvf $FILE_ARCHIVE $OUT_DUMP \
  && rm -rf $OUT_DUMP \
  && echo [$(date)] Backup done"
else
  # Otherwise, use the root user...
  echo "[$(date)] Starting MongoBD backup with root user..."
  mongodump --quiet -h $MONGO_PORT_27017_TCP_ADDR -p $MONGO_PORT_27017_TCP_PORT --db $MONGO_DATABASE --out $OUT_DUMP
  mongodump -h $MONGO_PORT_27017_TCP_ADDR -p $MONGO_PORT_27017_TCP_PORT --db $MONGO_DATABASE --archive=$FILENAME.archive
  tar -zcvf $FILE_ARCHIVE $OUT_DUMP
  rm -rf $OUT_DUMP
  echo "[$(date)] Backup done"
fi

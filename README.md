# docker-mongodb-backup
Docker container to backup a full MongoDB database from a container with mongodump, on the host machine.

This Dockerfile is based on MongoDB `3.2.6`. Check the MongoDB compatibility if you want to use this tool with another MongoDB version.
It uses `mongodump` tool of MongoDB to create a `tar.gz` as well as an `.archive` file (MongoDB format).

Do not hesitate to contact me if you have any question.

## Build the image
docker build -t mongodb-backup:<new version goes here> .

# Example:
`docker build -t mongodb-backup:3.2.6 .`

# Execute a backup
Use the following command:
docker run --rm -v /absolute/path/that/will/contains/backups:/backup -e MONGO_DATABASE=<database_name_to_backup> --link <name_of_mongo_container>:mongo mongodb-backup:<version>

# Example:
docker run --rm -v /home/acarton/mongodb/backups:/backup -e MONGO_DATABASE=mydb --link my-mongo:mongo mongodb-backup:3.2.6

# Result
Starting MongoBD backup: Fri Jun 24 16:16:15 UTC 2016
2016-06-24T16:16:15.441+0000	writing mydb.user to archive 'backup-mydb-20160624_161615.archive'
2016-06-24T16:16:15.442+0000	done dumping mydb.user (1 document)
dump-20160624_161615/
dump-20160624_161615/mydb/
dump-20160624_161615/mydb/user.bson
dump-20160624_161615/mydb/user.metadata.json
Backup done: Fri Jun 24 16:16:15 UTC 2016

## Information
Running this container will:
1/ Create a folder with the current date (e.g. `2016-06-24`)
2/ Create a subfolder with the current date and time (e.g. `20160624_161615`) (in case there are multiple backups the same day)
3/ Create an archive (MongoDB archive format) (e.g. `backup-mydb-20160624_161615.archive`)
Please refer to https://docs.mongodb.com/v3.2/reference/program/mongodump/#output-to-an-archive-file for more information.
To restore a MongoDB archive file, please refer to https://docs.mongodb.com/v3.2/reference/program/mongorestore/#restore-a-database-from-an-archive-file
4/ It also create a tar.gz file (e.g. `backup-mydb-20160624_161615.tar.gz`) containing the `dump-20160624_161615/` folder. If needed, untar it with `tar -xvf backup-mydb-20160624_161615.tar.gz`.
Once done, use the following documentation to restore data from the extracted folder: https://docs.mongodb.com/v3.2/reference/program/mongorestore/#restore-with-access-control

Do not hesitate to modify `entrypoint.sh` if you only want the .archive or the tar.gz.

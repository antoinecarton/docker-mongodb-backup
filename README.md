# antoinecarton/docker-mongodb-backup
Docker container to backup a full MongoDB database from a container with mongodump, on the host machine.

This Dockerfile is based on MongoDB `3.2.6`. Check the MongoDB compatibility if you want to use this tool with another MongoDB version.
It uses `mongodump` tool to create a `tar.gz` archive as well as an `.archive` file (MongoDB format).

Do not hesitate to contact me if you have any question.

## Build the image
To build the image, clone this repository and use the following command:</br>
`docker build -t mongodb-backup:<new version goes here> .`

### Example:
`docker build -t mongodb-backup:3.2.6 .`

## Usage
To trigger the backup, use the following command:</br>
`docker run --rm -v /absolute/path/to/backups:/backup -e MONGO_DATABASE=<database_name_to_backup> --link <name_of_mongo_container>:mongo mongodb-backup:<version>`

### Example:
`docker run --rm -v /home/acarton/mongodb/backups:/backup -e MONGO_DATABASE=mydb --link my-mongo:mongo mongodb-backup:3.2.6`

## Result
    Starting MongoBD backup...
    writing mydb.user to archive 'backup-mydb-20160624_161615.archive'
    2016-06-24T16:16:15.442+0000	done dumping mydb.user (1 document)
    dump-20160624_161615/
    dump-20160624_161615/mydb/
    dump-20160624_161615/mydb/user.bson
    dump-20160624_161615/mydb/user.metadata.json
    Backup done: Fri Jun 24 16:16:15 UTC 2016

## Information
Running this container will:
- Create a folder with the current date (e.g. `2016-06-24`)

- Create a subfolder with the current date and time (e.g. `20160624_161615`) (in case there are multiple backups the same day)

- Create an archive (MongoDB archive format) (e.g. `backup-mydb-20160624_161615.archive`).</br>
For more information, please refer to https://docs.mongodb.com/v3.2/reference/program/mongodump/#output-to-an-archive-file</br>
To restore a MongoDB archive file, please refer to https://docs.mongodb.com/v3.2/reference/program/mongorestore/#restore-a-database-from-an-archive-file

- It also create a `tar.gz` file (e.g. `backup-mydb-20160624_161615.tar.gz`) containing the `dump-20160624_161615/` folder. If needed, untar it with `tar -xvf backup-mydb-20160624_161615.tar.gz`.
Once done, use the following documentation to restore data from the extracted folder: https://docs.mongodb.com/v3.2/reference/program/mongorestore/#restore-with-access-control

- Do not hesitate to modify `entrypoint.sh` if you only want the `.archive` or the `tar.gz`.

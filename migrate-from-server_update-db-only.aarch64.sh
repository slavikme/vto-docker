#!/usr/bin/env bash

[ ! $DEFAULT ] && echo "Please enter the following information in order to make the script run uninterruptedly."
echo
[ ! $DEFAULT ] && read -p "Remote SSH hostname [ssh-us1.hosth.net]: " REMOTE_HOST
REMOTE_HOST=${REMOTE_HOST:-ssh-us1.hosth.net}
[ ! $DEFAULT ] && read -p "Remote SSH port [55022]: " REMOTE_PORT
REMOTE_PORT=${REMOTE_PORT:-55022}
[ ! $DEFAULT ] && read -p "Remote SSH username [root]: " REMOTE_USER
REMOTE_USER=${REMOTE_USER:-root}
[ ! $DEFAULT ] && read -p "Remote SSH private key location [$(realpath ~/.ssh/id_rsa)]: " REMOTE_PRIVATE_KEY
REMOTE_PRIVATE_KEY=${REMOTE_PRIVATE_KEY:-$(realpath ~/.ssh/id_rsa)}
[ ! $DEFAULT ] && read -p "Remote DB name [vitiok_forum]: " REMOTE_DB_NAME
REMOTE_DB_NAME=${REMOTE_DB_NAME:-vitiok_forum}


echo "Dumping database $REMOTE_DB_NAME into files on remote server... " &&\
ssh -t -i ${REMOTE_PRIVATE_KEY} -p${REMOTE_PORT} ${REMOTE_USER}@${REMOTE_HOST} "rm -rf /tmp/$REMOTE_DB_NAME; mkdir -p /tmp/$REMOTE_DB_NAME; for i in \$(mysql -NBA $REMOTE_DB_NAME -e \"show tables\"); do echo -n \"Dumping table '\$i'... \"; mysqldump $REMOTE_DB_NAME \$i > /tmp/$REMOTE_DB_NAME/\$i.sql; echo \"done\"; done" &&\

echo "Downloading from remote server... " &&\
rsync -r -v --progress --stats -e "ssh -t -i $REMOTE_PRIVATE_KEY -p $REMOTE_PORT" ${REMOTE_USER}@${REMOTE_HOST}:/tmp/${REMOTE_DB_NAME}/ ./initdb/ &&\
ssh -t -i ${REMOTE_PRIVATE_KEY} -p${REMOTE_PORT} ${REMOTE_USER}@${REMOTE_HOST} rm -rf /tmp/${REMOTE_DB_NAME} &&\

MYSQL_DATABASE_TMP=${MYSQL_DATABASE}_tmp

echo -n "Changing the ./initdb/000_init.sql file to comply with aarch64 MariaDB version and set a temp DB '$MYSQL_DATABASE_TMP' to import to... " &&\
echo "DROP SCHEMA IF EXISTS $MYSQL_DATABASE_TMP;" > ./initdb/000_init.sql &&\
echo "CREATE SCHEMA $MYSQL_DATABASE_TMP DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;" >> ./initdb/000_init.sql &&\
echo "GRANT ALL PRIVILEGES ON $MYSQL_DATABASE_TMP.* TO '$MYSQL_USER'@'%';" >> ./initdb/000_init.sql &&\
echo "SET PASSWORD FOR $MYSQL_USER = PASSWORD('$MYSQL_PASSWORD');" >> ./initdb/000_init.sql &&\
echo "USE $MYSQL_DATABASE_TMP;" >> ./initdb/000_init.sql &&\
echo "done" &&\

echo -n "Creating database, user and importing data... " &&\
docker exec vto-db bash -c "cat /docker-entrypoint-initdb.d/*.sql | mysql" &&\
echo "done"

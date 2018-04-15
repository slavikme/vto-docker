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

echo -n "Loading variables from ./env file... " &&\
source ./env &&\
echo "done" &&\

echo "Dumping database $REMOTE_DB_NAME into files on remote server... " &&\
ssh -t -i ${REMOTE_PRIVATE_KEY} -p${REMOTE_PORT} ${REMOTE_USER}@${REMOTE_HOST} "rm -rf /tmp/$REMOTE_DB_NAME; mkdir -p /tmp/$REMOTE_DB_NAME; for i in \$(mysql -NBA $REMOTE_DB_NAME -e \"show tables\"); do echo -n \"Dumping table '\$i'... \"; mysqldump $REMOTE_DB_NAME \$i > /tmp/$REMOTE_DB_NAME/\$i.sql; echo \"done\"; done" &&\

echo "Downloading from remote server... " &&\
rsync -r -v --progress --stats -e "ssh -t -i $REMOTE_PRIVATE_KEY -p $REMOTE_PORT" ${REMOTE_USER}@${REMOTE_HOST}:/tmp/${REMOTE_DB_NAME}/ ./initdb/ &&\
ssh -t -i ${REMOTE_PRIVATE_KEY} -p${REMOTE_PORT} ${REMOTE_USER}@${REMOTE_HOST} rm -rf /tmp/${REMOTE_DB_NAME} &&\

echo -n "Modify the ./initdb/000_init.sql file accordingly... " &&\
echo "DROP SCHEMA IF EXISTS $MYSQL_DATABASE;" > ./initdb/000_init.sql &&\
echo "CREATE SCHEMA $MYSQL_DATABASE DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;" >> ./initdb/000_init.sql &&\
echo "GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';" >> ./initdb/000_init.sql &&\
echo "SET PASSWORD FOR $MYSQL_USER = PASSWORD('$MYSQL_PASSWORD');" >> ./initdb/000_init.sql &&\
echo "USE $MYSQL_DATABASE;" >> ./initdb/000_init.sql &&\
echo "done" &&\

echo -n "Creating database, user and importing data... " &&\
mv ./web/.htaccess ./web/.htaccess_orig &&\
mv ./web/.htaccess_maintenance ./web/.htaccess &&\
docker exec vto-db bash -c "cat /docker-entrypoint-initdb.d/*.sql | mysql" &&\
mv ./web/.htaccess ./web/.htaccess_maintenance &&\
mv ./web/.htaccess_orig ./web/.htaccess &&\
echo "done"

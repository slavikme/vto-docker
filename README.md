# Docker image for VseTutOnline

Below are some basic instructions.

## Quick start
1. Install [Docker](https://www.docker.com/community-edition).
2. Install [Docker Compose](https://docs.docker.com/compose/).
3. Clone this repos recursively (in order to also pull submodules). This [post](https://stackoverflow.com/a/4438292/1291121) may help.
   ```shell
   git clone --recurse-submodules -j8 https://github.com/slavikme/vto-docker.git
   ```
4. `cd` to the cloned directory and run the script `migrate-from-server.sh` and follow the instructions.
   ```shell
   cd vto-docker
   . migrate-from-server.sh
   ```

## Development build
In order to install a dev environment of VTO, use the following steps:
1. Dump MySQL and download it from remote server
   ```shell
   ssh -p $REMOTE_PORT $REMOTE_USER@$REMOTE_HOST \
       'mysqldump -h $REMOTE_DB_HOST-u $REMOTE_DB_USER -p $REMOTE_DB_NAME | gzip > /tmp/$REMOTE_DB_NAME.sql.gz && cat /tmp/$REMOTE_DB_NAME.sql.gz && rm -f /tmp/$REMOTE_DB_NAME.sql.gz' \
       | gunzip -c > ./initdb/$REMOTE_DB_NAME.sql 
   ```
2. Build a development docker environment
   ```shell
   . build-dev.sh
   ```
## Environments

For admin username and password, please refer to the file `env`. You can also update the file `env` to update those configurations. Below are the default configurations.

~~~
MYSQL_HOST=db
MYSQL_PORT=3306
MYSQL_ROOT_PASSWORD=
MYSQL_USER=vto_user
MYSQL_PASSWORD=Z9,+Jhrz4T0E
MYSQL_DATABASE=vto
MYSQL_ALLOW_EMPTY_PASSWORD=1
~~~
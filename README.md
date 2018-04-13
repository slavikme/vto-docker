# Docker image for VseTutOnline

Below are some basic instructions.

## Quick start

The easiest way to start VseTutOnline with MySQL and Memcache is using [Docker Compose](https://docs.docker.com/compose/). Just clone this repo and run following command in the root directory. The default `docker-compose.yml` uses MySQL and Memcache. A build script is predefined to run the Docker Compose command for you. (Note, that if you are in a development environment, it is recommended to run the script `./build-dev.sh`.)

~~~
$ ./build.sh
~~~

For admin username and password, please refer to the file `env`. You can also update the file `env` to update those configurations. Below are the default configurations.

~~~
MYSQL_HOST=db
MYSQL_PORT=3306
MYSQL_ROOT_PASSWORD=
MYSQL_USER=vto_user
MYSQL_PASSWORD=Z9,+Jhrz4T0E
MYSQL_DATABASE=vto
MYSQL_ALLOW_EMPTY_PASSWORD=1

MEMCACHE_HOST=cache
MEMCACHE_PORT=11211
~~~
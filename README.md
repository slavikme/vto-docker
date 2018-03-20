# Docker image for VseTutOnline

Below are some basic instructions.

## Quick start

The easiest way to start VseTutOnline with MySQL and Memcache is using [Docker Compose](https://docs.docker.com/compose/). Just clone this repo and run following command in the root directory. The default `docker-compose.yml` uses MySQL and Memcache. A build script is predefined to run the Docker Compose command for you. (Note, that if you are in a development environmet, it is recomended to run the script `./build-dev.sh`.)

~~~
$ ./build.sh
~~~

For admin username and password, please refer to the file `env`. You can also update the file `env` to update those configurations. Below are the default configurations.

~~~
MYSQL_HOST=db
MYSQL_PORT=3306
MYSQL_ROOT_PASSWORD=myrootpassword
MYSQL_USER=magento
MYSQL_PASSWORD=magento
MYSQL_DATABASE=magento

MEMCACHE_HOST=cache
MEMCACHE_PORT=11211
~~~
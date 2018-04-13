FROM centos:7

MAINTAINER Slavik Meltser <slavik@mlt.sr>

RUN \
    yum -y update \
    && yum -y install --setopt=tsflags=nodocs \
    php \
    php-mysql \
    php-pecl-memcache \
    mod_ssl \
    less \
    which \
    && yum clean all \
    && sed -ri 's/#ServerName www.example.com:80/ServerName localhost:80/g' /etc/httpd/conf/httpd.conf \
    && sed -ri 's/AllowOverride None/AllowOverride All/g' /etc/httpd/conf/httpd.conf \
    && sed -ri -e 's!^(\s*CustomLog)\s+\S+!\1 /proc/self/fd/1!g' \
	       -e 's!^(\s*ErrorLog)\s+\S+!\1 /proc/self/fd/2!g' \
	       /etc/httpd/conf/httpd.conf

#ADD index.php /var/www/html

WORKDIR /var/www/html

EXPOSE 80

ADD bin/run-httpd.sh /run-httpd.sh
RUN chmod -v +x /run-httpd.sh

CMD ["/run-httpd.sh"]
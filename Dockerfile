FROM ubuntu:vivid
MAINTAINER Viciware LLC (Nik Petersen) 


RUN apt-get update

RUN apt-get install -y git wget curl
RUN apt-get install -y php5-fpm php5-cli php5-curl php5-gd php5-json php5-sqlite php5-apcu php5-intl php5-mcrypt php5-mysqlnd php5-imagick

RUN sed -i '/daemonize /c daemonize = no' /etc/php5/fpm/php-fpm.conf
RUN sed -i '/^listen /c listen = 0.0.0.0:9000' /etc/php5/fpm/pool.d/www.conf
RUN sed -i 's/^listen.allowed_clients/;listen.allowed_clients/' /etc/php5/fpm/pool.d/www.conf

RUN rm -rf /etc/php5/cli/php.ini && \
    ln -s /etc/php5/fpm/php.ini /etc/php5/cli/php.ini

RUN echo "phar.readonly = Off" >> /etc/php5/fpm/php.ini

RUN sed -i -e "s/^max_execution_time\s*=.*/max_execution_time = 200/" \
-e "s/^post_max_size\s*=.*/post_max_size = 1G/" \
-e "s/^upload_max_filesize\s*=.*/upload_max_filesize = 1G\nupload_max_size = 1G/" \
-e "s/^memory_limit\s*=.*/memory_limit = 256M/" /etc/php5/fpm/php.ini

RUN cd /tmp && \
    php -r "readfile('https://getcomposer.org/installer');" | php && \
    mv composer.phar /usr/local/bin/composer

RUN apt-get autoremove && \
    apt-get autoclean && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
    
CMD ["php5-fpm"]

EXPOSE 9000


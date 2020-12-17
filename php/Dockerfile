ARG php_version
FROM php:$php_version
COPY ./redis-5.3.2.tgz /redis-5.3.2.tgz
RUN cd /usr/local/bin && \
    ./docker-php-ext-install pdo_mysql && \
    ./docker-php-ext-install pcntl && \
    mkdir -p /usr/src/php/ext/redis && \
    tar -zxvf /redis-5.3.2.tgz && \
    cp -r redis-5.3.2/* /usr/src/php/ext/redis && \
    ./docker-php-ext-install redis
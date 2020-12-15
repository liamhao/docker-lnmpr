ARG php_version
FROM php:$php_version
RUN cd /usr/local/bin && \
    ./docker-php-ext-install pdo_mysql && \
    pecl install -o -f redis && \
    ./docker-php-ext-enable redis && \
    rm -rf /tmp/pear
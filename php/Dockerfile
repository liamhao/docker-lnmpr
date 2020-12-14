ARG php_version
FROM php:$php_version
RUN cd /usr/local/bin \
    ./docker-php-ext-install pdo_mysql \
    ./docker-php-ext-enable pdo_mysql \
    curl -L https://pecl.php.net/get/redis-5.3.2.tgz \
    tar xvz -C /usr/src/php/ext/redis --strip 1 \
    ./docker-php-ext-install redis \
    ./docker-php-ext-enable redis
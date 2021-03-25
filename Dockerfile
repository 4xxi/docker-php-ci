FROM php:7.4-fpm-alpine3.12

RUN apk update && apk add --no-cache openssh libxml2-dev ttf-freefont libzip-dev rabbitmq-c rabbitmq-c-dev icu-dev postgresql-dev \
    && apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
    && apk add --no-cache --no-progress --virtual .build-gpg-deps gpgme-dev \
    && apk add --no-cache --no-progress gpgme \
    && docker-php-ext-install pdo pdo_mysql pdo_pgsql zip intl opcache gd sockets soap bcmath \
    && pecl channel-update pecl.php.net \
    && pecl install redis && docker-php-ext-enable redis \
    && pecl install amqp && docker-php-ext-enable amqp \
    && pecl install gnupg && docker-php-ext-enable gnupg \
    && apk del .build-deps && apk del .build-gpg-deps && apk del --no-cache icu-dev

COPY --from=composer:2.0.8 /usr/bin/composer /usr/bin/composer

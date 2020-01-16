FROM composer:1.9 AS composer

ARG NOME_PROJETO
ENV NOME_PROJETO=$NOME_PROJETO

RUN  composer create-project --prefer-dist laravel/laravel $NOME_PROJETO 

RUN zip -r $NOME_PROJETO.zip $NOME_PROJETO

FROM php:7.4-apache

RUN apt-get update && apt-get install -y \
        zip \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev 

RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd

RUN docker-php-ext-install mysqli pdo_mysql bcmath \
    && pecl install xdebug-2.8.1 \
    && docker-php-ext-enable xdebug

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
COPY --from=composer /app /var/www/

RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini" \
    && chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
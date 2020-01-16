#!/bin/bash
DIR="/var/www/html/$NOME_PROJETO/"

if [ "$(ls -A $DIR)" ]; then
     if [! "$(ls -A $DIR/vendor/)" ]; then
        printf "\t#########################\n\t### Vendor não existe ###\n\t#########################\n\n Para  baixar dependencias execute: docker run --rm -it -v $NOME_PROJETO:/app composer install --ignore-platform-reqs --no-scripts\n"
    else
        printf "\t#########################\n\t###   Nada a fazer!   ###\n\t#########################\n"
    fi
else
    printf "\t#########################\n\t###  Criando projeto  ###\n\t#########################\n"

    unzip -q /var/www/$NOME_PROJETO.zip -d /var/www/html/

    chmod -R 777 /var/www/html/$NOME_PROJETO/ 

    php /var/www/html/$NOME_PROJETO/artisan key:generate
fi

apache2-foreground 
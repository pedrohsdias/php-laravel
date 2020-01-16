#!/bin/bash

unzip /var/www/$NOME_PROJETO.zip -d /var/www/html/

chmod -R 777 /var/www/html/$NOME_PROJETO/ 

php /var/www/html/$NOME_PROJETO/artisan key:generate

apache2-foreground 
FROM php:8.4

WORKDIR /projet

COPY app .

RUN apt update && apt-get install -y libfreetype-dev\
    libjpeg62-turbo-dev\
    libpng-dev\
    libpq-dev\
    zip\
    && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');" \
    && mv composer.phar /usr/local/bin/composer\
    && docker-php-ext-install bcmath\
    && docker-php-ext-install pdo pgsql\
    && docker-php-ext-install pdo_pgsql
    

EXPOSE 8000

RUN adduser www\
   && usermod -aG www www
  
RUN chmod u+x /projet/entrypoint.sh \
   && composer install \
   && php artisan key:gen
#&&php artsan migrate
RUN chown -R www:www /projet\
  &&chmod -R 775 /projet/storage
   
USER www

#ENTRYPOINT ["sleep 1000000000000000000000000000000000000000000000000000000"]


ENTRYPOINT ["php","artisan","serve","--host","0.0.0.0"]

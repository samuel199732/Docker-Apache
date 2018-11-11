FROM php:7.0-apache

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2

ENV APACHE_DOCUMENT_ROOT=/var/www/html/public

RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf && \
 sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf && \
 sed -i 's/Listen\ 80/Listen\ 8080/g' /etc/apache2/ports.conf && \
 sed -i 's/\*\:80/\*\:8080/g' /etc/apache2/sites-available/*.conf

ADD bashrc /home/psycho/.bashrc

RUN echo "---> Instalando Dependências Básicas" && \
     apt-get update -y &&\
     apt-get install -y \
     software-properties-common \
     curl \
     bash \
     fontconfig \
     imagemagick \
     nano \
     vim \
     git \
     unzip \
     wget \
     libxml2-dev \
     make  && \
     echo "---> Instalando Modulos adicionais do PHP" && \
     docker-php-ext-install mysqli pdo pdo_mysql soap && \
     echo "---> Instalando Composer" && \
     curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
     echo "---> Configurando Apache" && \
     a2enmod rewrite && \
     a2dismod mpm_event && \
     a2enmod mpm_prefork && \
     echo "---> Adicionando Novo Usuario" && \
     useradd -s /bin/bash -u 1000 psycho && \
     chown -R psycho:psycho /home/psycho && \
     echo "---> Apagando Pasta Temporaria" && \
     rm -rf /tmp/*;

WORKDIR /var/www/html

USER psycho

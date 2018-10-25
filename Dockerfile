FROM php:7.0-apache

ADD bashrc /home/psycho/.bashrc

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2

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
     echo "---> Configurando Aapche" && \
     a2enmod rewrite && \
     a2dismod mpm_event && \
     a2enmod mpm_prefork && \
     echo "---> Adicionando Novo Usuario" && \
     useradd -s /bin/bash -u 1000 psycho && \
     chown -R psycho:psycho /home/psycho && \
     echo "---> Apagando Pasta Temporaria" && \
     rm -rf /tmp/*;

ENV APACHE_DOCUMENT_ROOT=/var/www/html/public

RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf && sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

ENV PATH=/home/psycho/.composer/vendor/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

WORKDIR "/var/www/html"

# Utilisez l'image PHP officielle avec Apache
FROM php:7.4-apache

# Installez les dépendances nécessaires pour Composer
RUN apt-get update && apt-get install -y \
    unzip \
    git

# Installez Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copiez le contenu de votre application dans le conteneur
COPY . /var/www/html
WORKDIR /var/www/html
RUN composer update
RUN composer install

# Réglez les permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Configurez Apache pour permettre l'accès au répertoire
RUN echo '<VirtualHost *:80>\n\
    DocumentRoot /var/www/html/public\n\
    <Directory /var/www/html/public>\n\
    Options Indexes FollowSymLinks\n\
    AllowOverride All\n\
    Require all granted\n\
    </Directory>\n\
    ErrorLog ${APACHE_LOG_DIR}/error.log\n\
    CustomLog ${APACHE_LOG_DIR}/access.log combined\n\
    </VirtualHost>' > /etc/apache2/sites-available/000-default.conf

# Activez les modules Apache nécessaires
RUN a2enmod rewrite


RUN curl -sL https://deb.nodesource.com/setup_18.x | bash


RUN apt-get install -y nodejs
#!/usr/bin/env bash

# Enable root
sudo -i

# Vagrant user permissions
usermod -a -G www-data vagrant

# Redis
apt-get -y install redis-server
systemctl enable redis-server.service

# Installing PHP
apt-get update
apt-get -y install php7.4 php7.4-cli php7.4-common php7.4-opcache php7.4-curl php7.4-mbstring php7.4-mysql php7.4-zip php7.4-xml php7.4-imap

# Install Apache
apt-get install apache2 -y
a2enmod rewrite
cp /var/www/vagrant/provision/artryazanov-sites.conf /etc/apache2/sites-enabled/artryazanov-sites.conf
echo 127.0.0.1 artryazanov.local >> /etc/hosts
rm -rf /var/www/html/
sed -i 's/var\/www\/html/var\/www/g' /etc/apache2/sites-available/000-default.conf
service apache2 restart

# Configuring PHP
cp /vagrant/provision/php.ini /etc/php/7.4/apache2/php.ini > /dev/null 2>&1
cp /vagrant/provision/php.ini /etc/php/7.4/cli/php.ini > /dev/null 2>&1

# Restart Apache
service apache2 restart

# Installing Composer
apt-get -y install curl
curl --silent https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
cd /var/www && composer install

# Set Env
rm -f /var/www/.env
cp /vagrant/provision/.env /var/www/.env

#!/bin/bash

# Asenna Apache2 ja PHP
sudo apt-get update
sudo apt-get install -y apache2 php libapache2-mod-php php-mysql mariadb-server mariadb-client libapache2-mod-php

# Asenna Composer
sudo apt-get install -y curl php-cli php-mbstring git unzip
cd ~
curl -sS https://getcomposer.org/installer -o composer-setup.php
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer

# Asenna Node.js ja npm Pilvilinna Portaalin kääntämiseksi
sudo snap install node --classic

# Hanki Pilvilinna API ja Portaali
git clone https://github.com/Rscl/pilvilinna-api.git
git clone https://github.com/Rscl/pilvilinna-portal.git

# Siirrä projektit /var/www -kansioon ja asenna riippuvuudet
sudo mv pilvilinna-api /var/www/api
sudo mv pilvilinna-portal /var/www/portal

cd /var/www/api
sudo composer install

cd /var/www/portal
sudo npm install

# Käännä Pilvilinna Portaali
sudo npm run build

# Kopioi Apache2 konfiguraatiot
sudo cp ./Apache2/pilvilinna-api.conf /etc/apache2/sites-available/
sudo cp ./Apache2/pilvilinna-portal.conf /etc/apache2/sites-available/

# Ota uudet sivustot käyttöön ja käynnistä Apache2 uudelleen
sudo a2ensite pilvilinna-api
sudo a2ensite pilvilinna-portal
sudo systemctl restart apache2

echo "Asennus on valmis!"

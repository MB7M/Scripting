#!/bin/bash

apt update
apt install -y php8.0-intl php8.0-bz2 php8.0-ldap php8.0-openssl php8.0-imagick php8.0-gd php8.0-mysql php8.0-xml php8.0-mbstring php8.0-curl php8.0-zip libapache2-mod-php8.0
systemctl restart apache2

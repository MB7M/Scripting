#!/bin/bash

# Mettre à jour les paquets
apt update

# Installer les extensions PHP manquantes
apt install -y php8.0-intl php8.0-bz2 php-ldap php-imagick php8.0-gd php8.0-mysql php8.0-xml php8.0-mbstring php8.0-curl php8.0-zip libapache2-mod-php8.0

# Redémarrer le serveur Apache
systemctl restart apache2

echo "Les extensions PHP manquantes ont été installées et Apache a été redémarré."


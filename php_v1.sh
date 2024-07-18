#!/bin/bash

# Désinstallation de PHP et nettoyage du système
apt-get remove --purge -y php* libapache2-mod-php8.0
apt-get autoremove -y
apt-get autoclean -y

# Ajouter le dépôt Sury pour installer différentes versions de PHP
apt install -y apt-transport-https lsb-release ca-certificates wget
wget -qO - https://packages.sury.org/php/apt.gpg | apt-key add -
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list
apt update

# Installer PHP 8.0 et les modules nécessaires
apt install -y php8.0 php8.0-cli php8.0-common php8.0-fpm php8.0-mysql php8.0-xml php8.0-mbstring php8.0-curl php8.0-zip php8.0-gd php8.0-intl php8.0-bz2 php8.0-ldap libapache2-mod-php8.0

# Vérifier la présence du fichier ldap.so
if [ ! -f /usr/lib/php/20200930/ldap.so ]; then
    echo "Le fichier ldap.so n'a pas été trouvé. Vérifiez le chemin."
    exit 1
fi

# Créer manuellement le fichier ldap.ini s'il n'existe pas
if [ ! -f /etc/php/8.0/mods-available/ldap.ini ]; then
    echo "extension=ldap.so" > /etc/php/8.0/mods-available/ldap.ini
fi

# Activer le module LDAP
phpenmod ldap

# Redémarrer le serveur Apache pour appliquer les changements
systemctl restart apache2

# Vérifier les extensions PHP chargées
php -m | grep ldap && echo "L'extension LDAP est activée." || echo "L'extension LDAP n'est pas activée."

# Afficher un message de succès
echo "L'extension LDAP a été activée et Apache a été redémarré."

#!/bin/bash

# Désinstallation de PHP 8.2.20 et nettoyage du système
apt remove --purge -y 'php*'
apt autoremove -y
apt autoclean -y

# Ajouter le dépôt Sury pour installer différentes versions de PHP
apt install -y apt-transport-https lsb-release ca-certificates wget
wget -qO - https://packages.sury.org/php/apt.gpg | apt-key add -
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list
apt update

# Installer PHP 8.2.0 et les modules nécessaires
apt install -y php8.2 php8.2-cli php8.2-common php8.2-fpm php8.2-mysql php8.2-xml php8.2-mbstring php8.2-curl php8.2-zip php8.2-gd

# Redémarrer le serveur web Apache
systemctl restart apache2

# Télécharger et installer GLPI
cd /tmp
wget https://github.com/glpi-project/glpi/releases/download/9.5.6/glpi-9.5.6.tgz
tar -xvzf glpi-9.5.6.tgz
mv glpi /var/www/html/glpi_domain1

# Configurer les permissions pour GLPI
chown -R www-data:www-data /var/www/html/glpi_domain1
chmod -R 755 /var/www/html/glpi_domain1

# Configurer Apache pour GLPI
tee /etc/apache2/sites-available/glpi_domain1.conf > /dev/null <<EOL
<VirtualHost 172.18.1.60:80>
    # The ServerName directive sets the request scheme, hostname and port that
    # the server uses to identify itself. This is used when creating
    # redirection URLs. In the context of virtual hosts, the ServerName
    # specifies what hostname must appear in the request's Host: header to
    # match this virtual host. For the default virtual host (this file) this
    # value is not decisive as it is used as a last resort host regardless.
    # However, you must set it for any further virtual host explicitly.
    ServerName 172.18.1.60

    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/html
    Alias /glpi_domain1 /var/www/html/glpi_domain1/
    <Directory /var/www/html/glpi_domain1/>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined

    # For most configuration files from conf-available/, which are
    # enabled or disabled at a global level, it is possible to
    # include a line for only one particular virtual host. For example the
    # following line enables the CGI configuration for this host only
    # after it has been globally disabled with "a2disconf".
    #Include conf-available/serve-cgi-bin.conf
</VirtualHost>
EOL

# Activer la configuration et redémarrer Apache
a2ensite glpi_domain1.conf
systemctl reload apache2

# Afficher le message de succès
echo "PHP 8.2.0 et GLPI sont installés et configurés. Accédez à GLPI via votre navigateur à l'adresse http://172.18.1.60/glpi_domain1"

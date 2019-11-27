#!/bin/bash

# This script updates the server before anything else. It installs:
# Python3, Virtualenv, Apache-modwsgi

echo "Installing Python3, Virtualenv, Apache2 mod wsgi for python 3.\n"
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install apache2 libapache2-mod-wsgi-py3 virtualenv

echo "Cloning boiler-plate gitbuh repo into 'mainproject' directory.\n"
git clone git@github.com:j-000/flask-ec2-boilerplate.git mainproject
cd mainproject
echo "Creating virtual environment for project and installing dependencies.\n"
virtualenv venv
source venv/bin/activate
pip install -r requirements.txt

echo "Create a simlink between the project and /www/var/"
sudo ln -sT ~/mainproject /var/www/html/mainproject

echo "Installing certbot and creating SSL certificate.\n"
sudo apt-get install software-properties-common
sudo add-apt-repository universe
sudo add-apt-repository ppa:certbot/certbot
sudo apt-get install certbot python-certbot-apache
sudo certbot certonly --apache

echo "Creating server .conf file.\n"
sudo rm /etc/apache2/sites-enabled/000-default.conf
echo "Enter domain name without the protocol: "
read domain
echo "WSGIDaemonProcess mainproject threads=5
WSGIPassAuthorization On

# HTTPS 
<VirtualHost *:443>
  ServerName $domain
  ServerAdmin webmaster@localhost
  DocumentRoot /var/www/html
  WSGIScriptAlias / /var/www/html/mainproject/app.wsgi
  <Directory mainproject>
    WSGIProcessGroup mainproject
    WSGIApplicationGroup %{GLOBAL}
    Order deny,allow
    Allow from all
  </Directory>
  ErrorLog ${APACHE_LOG_DIR}/error.log
  CustomLog ${APACHE_LOG_DIR}/access.log combined
SSLEngine On
SSLCertificateFile /etc/letsencrypt/live/$domain/fullchain.pem
SSLCertificateKeyFile /etc/letsencrypt/live/$domain/privkey.pem
Include /etc/letsencrypt/options-ssl-apache.conf
</VirtualHost>

# HTTP
<VirtualHost *:80>
  ServerName $domain
  ServerAdmin webmaster@localhost
  DocumentRoot /var/www/html
  WSGIScriptAlias / /var/www/html/mainproject/app.wsgi
  <Directory mainproject>
    WSGIProcessGroup mainproject
    WSGIApplicationGroup %{GLOBAL}
    Order deny,allow
    Allow from all
  </Directory>
  ErrorLog ${APACHE_LOG_DIR}/error.log
  CustomLog ${APACHE_LOG_DIR}/access.log combined
RewriteEngine on
RewriteRule ^(.*)$ https://$domain%{REQUEST_URI} [END,NE,R=permanent]
</VirtualHost>" >> /etc/apache2/sites-enabled/000-default.conf

echo "Restarting"
sudo apachectl restart


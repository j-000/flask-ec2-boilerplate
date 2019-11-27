#!/bin/bash
echo "RUN WITH SUDO!\n"
echo "Creating server .conf file.\n"
sudo rm /etc/apache2/sites-enabled/000-default.conf
echo "Do you have a custom domain? (y/n)"
read customDomain
if [ $customDomain = "y"]
  echo "Make sure the A records in the DNS settings are pointing to the EC2 instance.\n"
  echo "Forcing HTTPS is on.\n"
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
else
  echo "WSGIDaemonProcess mainproject threads=5
  WSGIPassAuthorization On

  # HTTPS 
  <VirtualHost *:443>
    #ServerName domain
    #ServerAdmin webmaster@localhost
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
  #SSLEngine On
  #SSLCertificateFile /etc/letsencrypt/live/domain/fullchain.pem
  #SSLCertificateKeyFile /etc/letsencrypt/live/domain/privkey.pem
  #Include /etc/letsencrypt/options-ssl-apache.conf
  </VirtualHost>

  # HTTP
  <VirtualHost *:80>
    #ServerName domain
    #ServerAdmin webmaster@localhost
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
  #RewriteEngine on
  #RewriteRule ^(.*)$ https://domain%{REQUEST_URI} [END,NE,R=permanent]
  </VirtualHost>" >> /etc/apache2/sites-enabled/000-default.conf

echo "Restarting"
sudo apachectl restart
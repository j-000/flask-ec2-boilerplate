#!/bin/bash

echo "Installing certbot and creating SSL certificate.\n"
sudo apt-get install software-properties-common
sudo add-apt-repository universe
sudo add-apt-repository ppa:certbot/certbot
sudo apt-get install certbot python-certbot-apache
sudo certbot certonly --apache
sudo a2enmod ssl
sudo a2enmod rewrite
#!/bin/bash

# This script updates the server before anything else. It installs:
# Python3, Virtualenv, Apache-modwsgi

echo "Installing Python3, Virtualenv, Apache2 mod wsgi for python 3.\n"
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install apache2 libapache2-mod-wsgi-py3 virtualenv
sudo apt install python-pip
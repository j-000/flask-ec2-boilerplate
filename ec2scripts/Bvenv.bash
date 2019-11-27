#!/bin/bash

cd ~
cd mainproject
echo "Creating virtual environment for project and installing dependencies.\n"
virtualenv venv --python=python3
source venv/bin/activate
pip install -r requirements.txt

echo "Create a simlink between the project and /var/www/html"
sudo ln -sT ~/mainproject /var/www/html/mainproject
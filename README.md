# AWS EC2 Flask Boilerplate

### All you need to deploy your Flask app to EC2
`IMPORTANT: It is assumed your operating system is Ubuntu linux and the instance operating system is also Ubuntu.`

1) Clone this repo:
```sh
git clone https://github.com/j-000/EC2BOILERPLATE.git
```
2) Create a virtual environment and install the requirements:
```sh
cd  EC2BOILERPLATE
virtualenv venv
pip install -r requirements.txt
```
Your virtualenvironment folder is assumed to be called **venv** as that is how it is described in app.wsgi. If you call it something else, ensure you update app.wsgi.

3) Open app.wsgi and replace **YOUR_PROJECT_NAME** with the name of your project. If you cloned this repo then your project name is the name of the root folder, in this case: **EC2BOILERPLATE**. Feel free to rename this to something else.

4) Open **applicationsecrets.py** and define a **SECRET_KEY** and the **SQLALCHEMY_DATABASE_URI**. You can leave the **SQLALCHEMY_TRACK_MODIFICATIONS=False** to stop some unnecessary warnings from being shown all the time.

If you want to use an AWS RDS database connection, simply add the necessary credentials to applicationsecrets.py. You can find the necessary credentials in your AWS console.

To connect to the database, in this case an AWS RDS database, this configuration uses **pymysql** as the driver. This is installed in step 2. There are other ones you can use, so feel free to update this on the applications.py file.

### What next?
Code! Complete your project. 

### I finished my project! Now what?
Once your project is production ready, you need to do the following:
1) Commit your code to github.

This will make it simple to download the code in your EC2 instance. Alternatively, you can use an FTP application like FileZilla.
2) Log into your AWS console account and create an EC2 instance. You will need to download the PEM file that will allow you to connect to the instance via the command prompt or terminal. There are some tutorials online about laucing an EC2 instance. 

3) SSH into your instance. Make sure your PEM file is in the same path when you run the following command. You can find the SSH command by selecting your instance in the AWS console and clicking `connect`. The command looks like:
```sh
ssh -i "yourpemfile.pem" your_instance_connection_string
```
4) Set up your server environement.
```sh
sudo apt-get update
sudo apt-get install python3-pip
sudo pip3 install virtualenv
sudo apt-get install apache2 libapache2-mod-wsgi-py3
```
This updates the server, installs python3, virtualenv and apache server.

5) Clone your project from your github.

```sh
git clone ...
```

6) Create a symlink so that the project directory appears in /var/www/html. Replace **flaskproject** for the name of your project root folder. Enable wsgi.
```sh
sudo ln -sT ~/flaskproject /var/www/html/flaskproject
sudo a2enmod wsgi
```

7) Configure apache (you will need to sudo to edit the file)
```sh
sudo vi /etc/apache2/sites-enabled/000-default.conf
```
Paste this in right after the line with **DocumentRoot /var/www/html**
```sh
WSGIDaemonProcess flaskproject threads=5
WSGIScriptAlias / /var/www/html/flaskproject/app.wsgi
<Directory flaskproject>
	WSGIProcessGroup flaskproject
	WSGIApplicationGroup %{GLOBAL}
	Order deny,allow
	Allow from all
</Directory>
```
8) Restart the Server
```sh
sudo apachectl restart
```
DONE!
Go to your instance public address (something like 1.2.123.123) and confirm everything is working fine. :)


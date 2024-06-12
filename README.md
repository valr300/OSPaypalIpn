Notes for installing the OSPaypalIpn

The OSPaypalIpn allow validated Paypal Transaction Inworld OpenSimulator.

In short, it receive the IPN from Paypal, then a inworld script complete the process.
This product can be found in OpenSim at the Valland Shop, see http://www.vallands.ca for more information.

It consist in 
. installing a few php pages on your secured website (https),  
. creating a database, 
. configure your paypal account to receive the IPN.

These steps assume you know what you are doing. As I can barely help you myself.
You must be the owner of your system, as you will need the root power.

This document show the installation on:

-Linux  Ubuntu 22.04.2 LTS"

-nginx/1.18.0 (Ubuntu) 

-MySql Database  8.0.36-0ubuntu0.22.04.1


It should be compatible for windows and probably MariaDB, although I haven’t tested it, and of course the installation will vary, in that case use these notes as a roughly guide.

Note that for these steps and further down the road, you really need to know what you are doing, and taking these steps I took here won’t necessarily mean success on your installation. as your installation might be slightly different than mine, however, I think that if I show you what I did, it might help you find what you need to do, adapting these instructions to your own environment. And I am not responsible in any way shape or form on whatever you do on your system. Take backups before proceeding.


# Step 1: Get the package
You will need the latest version of OSPaypalIpn, you can get it here: https://github.com/valr300/OSPaypalIpn You can get the folder "ipn" only, the source isn’t needed.
Substitute the {yourwebsite} by your your web site folder.

Create folder /var/www/{yourwebsite}/ipn/ on your linux Machine:

sudo mkdir /var/www/{yourwebsite}/ipn
Put the content of the "ipn" folder in /var/www/{yourwebsite}/ipn/ :

cd {the place you put the package}
    
sudo cp -r * /var/www/{yourwebsite}/ipn/

make sure your web service can access the file. Acces  should be readable for www-data for nginx.

# Step 2: Create the Database
Execute the following script in your Database MySql : 

Paypal_Paypals.sql  		will build the database Rental and the Tables
Paypal_routines.sql     will build the stored procs.  
Step 3: Create The user database for the Rental database
execute the following lines.

mysql -u root --password
(enter your mysql password, or if you haven't set password for MySQL server, type "mysql -u root" instead) You can even use MySQL Command Line Client on the Start menu on Windows. After login, create user, or if you prefer proceed to create you user via the Workbench, much easier!.

CREATE USER 'YourDBUser'@'localhost' IDENTIFIED BY 'YOURPASSWORD';
GRANT ALL PRIVILEGES ON YourDBUser.* TO 'Paypal'@'localhost';





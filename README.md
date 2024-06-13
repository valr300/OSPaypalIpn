# Notes for installing the OSPaypalIpn

The OSPaypalIpn allow validated Paypal Transaction Inworld (OpenSimulator).

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

-nginx/1.18.0 (Ubuntu) with https configured

-MySql Database  8.0.36-0ubuntu0.22.04.1

-PHP Version 8.1.2-1ubuntu2.17

-php8.1-curl

## Good things to know (or where i strugled the most) :

If you are using nginx, make sure your php version fits with your nginx version

    apt list --installed | grep php    or list your current settings with phpinfo(); in a php file
    
You will need the right curl for your php version

    apt list --installed | grep curl

Also know that you can consult the error logs, whenever things dont work as expected

    cd /var/log/nginx
    cat error.log

## compatibility or adapting to your system
It should be compatible for windows and probably MariaDB, although I haven’t tested it, and of course the installation will vary, in that case use these notes as a roughly guide.

Note that for these steps and further down the road, you REALLY need to know what you are doing, and taking these steps I took here won’t necessarily mean success on your installation. as your installation might be slightly different than mine, however, I think that if I show you what I did, it might help you find what you need to do, adapting these instructions to your own environment. And I am not responsible in any way shape or form on whatever you do on your system. Take backups before proceeding. 


# Step 1: Setting up your account

Of course you need a Paypal account for that! If not already done, proceed by first signin up
    https://www.paypal.com
    
You will also need to create a developer account on your paypal account, this will allow you to do some sandbox test:
    https://developer.paypal.com/tools/sandbox/accounts/ and sign up if need be.

You will need to enable your Instant Payment Notification (IPN) in your paypal account.
To do so go in the paypal.com website

    .go into your profile section (the small gear on the right),
    .select "Sellers Tools" on the white bar, 
    .then enable "Instant payment Notification",
    .enter your IPN listner as "https://{YourWebSite}/ipn/Listener.php"


# Step 2: Get the package
You will need the latest version of OSPaypalIpn, you can get it here: https://github.com/valr300/OSPaypalIpn 
You can get the folder "ipn" only, the source isn’t needed.
Substitute the {yourwebsite} by your your web site folder.

Create folder /var/www/{yourwebsite}/ipn/ on your linux Machine:

sudo mkdir /var/www/{yourwebsite}/ipn
Put the content of the "ipn" folder in /var/www/{yourwebsite}/ipn/ :

cd {the place you put the package}
    
sudo cp -r * /var/www/{yourwebsite}/ipn/

make sure your web service can access the file. Acces  should be readable for www-data for nginx.


# Step 3: Create the Database
Execute the following script in your Database MySql : 

Paypal_Paypals.sql  		will build the database Rental and the Tables
Paypal_routines.sql     will build the stored procs.  

# Step 4: Create The user database for the Rental database
execute the following lines.

mysql -u root --password
(enter your mysql password, or if you haven't set password for MySQL server, type "mysql -u root" instead) You can even use MySQL Command Line Client on the Start menu on Windows. After login, create user, or if you prefer proceed to create you user via the Workbench, much easier!.

CREATE USER 'YourDBUser'@'localhost' IDENTIFIED BY 'YOURPASSWORD';
GRANT ALL PRIVILEGES ON YourDBUser.* TO 'Paypal'@'localhost';

# Step 5: Configuring your Listener

cd /var/www/{yourwebsite}/ipn/

        sudo vi login.php

You will need to provide the correct credential for your database

        $servername = "localhost";
        $database = "Paypal";
        $username = "{YourUsername}";
        $password = "{YourPassword}";

enable sandbox mode

         sudo vi ipnconf.php 

make sure enable_sandbox is set to true in these first step, and specify your email(s) address that will be accepted, this should be your paypal email account that will receive the payment.

         $enable_sandbox = true;
         $my_email_addresses = array("{mypaypalemail@example.com}", "{mysecondemail@example.com}");


this will tell to use the sandbox for your transaction, later when you tested everything and you are ready, you will have to set it to false to enable real tranactions.




# Step 6: Your first test


 If you are installing this to use with your Rentals (Complete Rental System) :
 
  edit the "!PaypalConfig" notecard in the Server component.
  
  otherwise edit the current "!PaypalConfig" in the component you want to test, 
  for exemple the "Paypal Donations Box that come with the OSPaypalIpn Box"

  
  Make sure the TestMode is set to 1, and that you write your "sandbox business email adress" given in your developer account .
  and notify_url points to your Listener https://{yourwebsite}/ipn/Listener.php
  and InworldIpn_url points to your inworld api  http://127.0.0.1/ipn/InWorldIPN.php
  
  for a complete explanation of the other fields see the Readme in the OSPaypalIpn package inworld.
  
  
        ####################################################
        # Paypal Configuration  :                                                                                      #
        # try to keep them shorts as we are limited in osl to 255 char for url & post data #
        ####################################################
        TestMode=1                                            # Set to 1 for  SandBoxMode, you must provide your business sandbox mail (https://developer.paypal.com/dashboard/accounts/)
        Invoice_prefix=RT                                    # Prefix Letters for invoice number, must be unique through all your paypal boxes, invoice are  formated 6 digits  ex:  RT000001
        currency=USD                                      # Currency,  by default your account Currency will be used ex, if you are from US, no need to specify USD unless you want another currency.
        cmd=_xclick                                     # command type supported : _donations : Donate Button,   _xclick   : Buy now button  
        item_name=Rental                                   # Product identification  class
        item_number=                                      # Product identification , will be the itemnumber of the parcel ( max 8 char)
        business={MySandboxEmailaddress@example.com}                # Email address used for paypal receiver, or in sandbox mode your sandbox business mail    
        return=                                                # Return page if any: Ex: return to your online catalog
        #
        # ipn config : leave empty if you have'nt install the  github (https://github.com/valr300/paypalIpn) i.e paypal transactions wont be validated,  You'll have to check manually
        #
        notify_url=https://{yourwebsite}/ipn/Listener.php           # your server for ipn or empty if none ( must also be set through your account) ex: https://yourserver/ipn/Listener.php
        InworldIpn_url=http://127.0.0.1/ipn/InWorldIPN.php        # your server to complete transaction inworld    ex : http://127.0.0.1/ipn/InWorldIPN.php 
        



 When ready, go inworld and  trigger some rentals, or paypal donations, or whatever you want to test with.
 When the paypal web page appear, simply proceed, enter your "sandbox personal email"  given in your developer account.
 after a few seconds yous should see the transactions completed if everything went ok.
 
 If everything went ok, you can do the ultimate test in looking in the database :
 
         . select * from Paypal.Paypals order by Payment_date desc

 You should see your avatarname and amont paid on the first line.

 Some points to consider :
 
         . The notify_url must be a https, so you must have configured your ssh on your website in order for this to work,  it will also reject anything that does not match your email address configured in step 2.
             
         . The InworkdIpn_Url will reject anything that does not come from local. you should reference InworldIpn_url with 127.0.0.1 as this is not accessible from outside.

         . As stated per paypal, there could be some delay before you receive the IPN, could even take hours or days, so don't expect this to be instantaneous. For more information on how the timedout are defined inworld see the readme tha comes with the OSPaypalIpn package inworld.
  


# Step 7: Hopefully you're still following and you got this far.

If you succeesfully tested and everything is ok... congratulation ! It took me months to get there!

  edit the current "!PaypalConfig" in the component you want to be set 
  
         set  TestMode=0 
         business={Yourrealpaypypalemail}
         
 edit the "ipnconf.php" to enable real tranactions
 
         sudo vi ipnconf.php  
         
         $enable_sandbox = false; 
         $my_email_addresses = array("{mypaypalemail@example.com}", "{mysecondemail@example.com}");

 Remember that when ever you want to test you need these 2 configure as Test or Live. If you only Enable test in one, it wont work. 

# Step 8:

 These is no step 8. You're done !.

 

         
 



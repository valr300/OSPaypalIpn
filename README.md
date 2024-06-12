Notes for installing the OSPaypalIpn

The OSPaypalIpn allow to receive the IPN from Paypal and and the purpose of collecting Data for the "Vallands Rental System" This product can be found in OpenSim at the Valland Shop, see http://www.vallands.ca for more information.

You need dotnet 6.0 to run the WebApiCoreRental.

These steps assume you know what you are doing. As I can barely help you myself.
You must be the owner of your system, as you will need the root power.

This document show the installation on:

-Linux  Ubuntu 22.04.2 LTS"

-nginx/1.18.0 (Ubuntu) 

-MySql Database  8.0.36-0ubuntu0.22.04.1

-dotnet    6.0.127 [/usr/lib/dotnet/sdk]
It should be compatible for windows and probably MariaDB, although I haven’t tested it, and of course the installation will vary, in that case use these notes as a roughly guide.

Note that for these steps and further down the road, you really need to know what you are doing, and taking these steps I took here won’t necessarily mean success on your installation. as your installation might be slightly different than mine, however, I think that if I show you what I did, it might help you find what you need to do, adapting these instructions to your own environment. And I am not responsible in any way shape or form on whatever you do on your system. Take backups before proceeding.

if you never installed this package, proceed directly to step 1.

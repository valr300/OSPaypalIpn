<?php 

//Set this to true to use the sandbox endpoint during testing:
$enable_sandbox = false;

// Use this to specify all of the email addresses that you have attached to paypal:
$my_email_addresses = array("Youpaypalremail@example.com", "yourpaypalemail2@business.example.com");

// Set this to true to send a confirmation email:
$send_confirmation_email = false;
$confirmation_email_address = "My Name <my_email_address@gmail.com>";
$from_email_address = "My Name <my_email_address@gmail.com>";

// Set this to true to save a log file:
$save_log_file = false;
$log_file_dir = __DIR__ . "/logs";


// Here is some information on how to configure sendmail:
// http://php.net/manual/en/function.mail.php#118210

?>

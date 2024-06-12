<?php namespace Listener;

  
require('login.php');
require('ipnconf.php');


function varPost($varpost, $def)
{
  $ret = $def;
  if (isset($_POST[$varpost]))
  {
	$ret = $_POST[$varpost];
	if ($def == 0.0)
	{
  	  if ($ret =='') $ret = $def;
	}
  }
  return $ret;
}

function WriteData()
{

  global  $servername,$database,$username,$password; 


  try
  {
    $conn = new \PDO("mysql:host=$servername;dbname=$database", $username, $password);
  }
  catch (PDOException $e)
  {
    die("Connection failed ");
      // attempt to retry the connection after some timeout for example
  }
 
  
   $stmt = $conn->prepare("call AddPaypal(:Invoice,:RegionName,:AvatarName,:AvatarId,:Item_name,:Item_number,:Mc_Handling,:Mc_currency,:Mc_fee,:Mc_gross,:Mc_Shipping,:Payment_Date,:Payment_fee,:Payment_gross,:Payment_status,:Payment_type,:Paypal_Payment_Date,:Protection_eligibility,:Quantity,:Tax,:Txn_id,:Txn_type,:Auth_Amount,:Auth_Exp,:Auth_Status,:Echeck_Time_Processed,:Exchange_Rate)");

   $Invoice=VarPost('invoice',0);
   $RegionName=""; 
   $AvatarName="";
   $AvatarId="";

   $Quantity=varPost('quantity',0);
   if (isset($_POST['item_name']))
   {
	   $Item_name=varPost('item_name',''); 
	   $Item_number=varPost('item_number','');
   }
   else
   {
	   $Item_name=varPost('item_name1','');
	   $Item_number=varPost('item_number1','');
   }	   

   $Tax=varPost('tax','0.0');

   $Mc_Handling=varPost('mc_handling',0.0);
   $Mc_Shipping=varPost('mc_shipping',0.0);
   $Mc_currency=varPost('mc_currency',"");
   $Mc_fee=varPost('mc_fee',0.0);
   $Mc_gross=varPost('mc_gross',0.0);

   $Payment_Date=date('Y-m-d H:i:s'); #$_POST['payment_date'];  #date('m/d/Y h:i:s a', time());
   $Payment_fee=varPost('payment_fee',0.0);
   $Payment_gross=varPost('payment_gross',0.0);
   $Payment_status=varPost('payment_status',"");
   $Payment_type=varPost('payment_type',"");
   $Protection_eligibility=varPost('protection_eligibility',"");

   $Txn_id=varPost('txn_id',""); #uniqid();
   $Txn_type=varPost('txn_type',"");
   $Paypal_Payment_Date=varPost('payment_date',"");

   $Auth_Amount=varPost('auth_amount',0.0);
   $Auth_Exp=varPost('auth_exp',"");
   $Auth_Status=varPost('auth_status',0.0);
   $Echeck_Time_Processed=varPost('echeck_time_processed',"");
   $Exchange_Rate=varPost('exchange_rate',0.0);
   $stmt->bindParam('Invoice',$Invoice);
   $stmt->bindParam('RegionName',$RegionName);
   $stmt->bindParam('AvatarName',$AvatarName);
   $stmt->bindParam('AvatarId',$AvatarId);
   $stmt->bindParam('Item_name',$Item_name);
   $stmt->bindParam('Item_number',$Item_number);
   $stmt->bindParam('Mc_Handling',$Mc_Handling);
   $stmt->bindParam('Mc_currency',$Mc_currency);
   $stmt->bindParam('Mc_fee',$Mc_fee);
   $stmt->bindParam('Mc_gross',$Mc_gross);
   $stmt->bindParam('Mc_Shipping',$Mc_Shipping);
   $stmt->bindParam('Payment_Date',$Payment_Date);
   $stmt->bindParam('Payment_fee',$Payment_fee);
   $stmt->bindParam('Payment_gross',$Payment_gross);
   $stmt->bindParam('Payment_status',$Payment_status);
   $stmt->bindParam('Payment_type',$Payment_type);
   $stmt->bindParam('Paypal_Payment_Date',$Paypal_Payment_Date);
   $stmt->bindParam('Protection_eligibility',$Protection_eligibility);
   $stmt->bindParam('Quantity',$Quantity);
   $stmt->bindParam('Tax',$Tax);
   $stmt->bindParam('Txn_id',$Txn_id);
   $stmt->bindParam('Txn_type',$Txn_type);
   $stmt->bindParam('Auth_Amount',$Auth_Amount);
   $stmt->bindParam('Auth_Exp',$Auth_Exp);
   $stmt->bindParam('Auth_Status',$Auth_Status);
   $stmt->bindParam('Echeck_Time_Processed',$Echeck_Time_Processed);
   $stmt->bindParam('Exchange_Rate',$Exchange_Rate);

   $stmt->execute();

   $stmt = null;
   $conn = null;
}

require('PaypalIPN.php');
use PaypalIPN;
$ipn = new PaypalIPN();
if ($enable_sandbox) {
    $ipn->useSandbox();
}
echo"before verify";
$verified = $ipn->verifyIPN();
#$verified=true;
echo"after verify";
$data_text = "";
foreach ($_POST as $key => $value) {
    $data_text .= $key . " = " . $value . "\r\n";
}

$test_text = "";
if ($_POST["test_ipn"] == 1) {
    $test_text = "Test ";
}
// Check the receiver email to see if it matches your list of paypal email addresses
$receiver_email_found = false;
foreach ($my_email_addresses as $a) {
    if (strtolower($_POST["receiver_email"]) == strtolower($a)) {
        $receiver_email_found = true;
        break;
    }
}
date_default_timezone_set("America/Los_Angeles");
list($year, $month, $day, $hour, $minute, $second, $timezone) = explode(":", date("Y:m:d:H:i:s:T"));
$date = $year . "-" . $month . "-" . $day;
$timestamp = $date . " " . $hour . ":" . $minute . ":" . $second . " " . $timezone;
$dated_log_file_dir = $log_file_dir . "/" . $year . "/" . $month;

$paypal_ipn_status = "VERIFICATION FAILED";
# -------------------
# Valid
# -------------------
if ($verified) 
{
    $paypal_ipn_status = "RECEIVER EMAIL MISMATCH";
    if ($receiver_email_found) {
        $paypal_ipn_status = "Completed Successfully";
	WriteData();
  

        }


}
# --------------------------------
#  Invalid 
#  ------------------------------- 
elseif ($enable_sandbox) {
    if ($_POST["test_ipn"] != 1) {
        $paypal_ipn_status = "RECEIVED FROM LIVE WHILE SANDBOXED";
    }
} elseif ($_POST["test_ipn"] == 1) {
    $paypal_ipn_status = "RECEIVED FROM SANDBOX WHILE LIVE";
}

if ($save_log_file) {
    // Create log file directory
    if (!is_dir($dated_log_file_dir)) {
        if (!file_exists($dated_log_file_dir)) {
            mkdir($dated_log_file_dir, 0777, true);
            if (!is_dir($dated_log_file_dir)) {
                $save_log_file = false;
            }
        } else {
            $save_log_file = false;
        }
    }
    // Restrict web access to files in the log file directory
    $htaccess_body = "RewriteEngine On" . "\r\n" . "RewriteRule .* - [L,R=404]";
    if ($save_log_file && (!is_file($log_file_dir . "/.htaccess") || file_get_contents($log_file_dir . "/.htaccess") !== $htaccess_body)) {
        if (!is_dir($log_file_dir . "/.htaccess")) {
            file_put_contents($log_file_dir . "/.htaccess", $htaccess_body);
            if (!is_file($log_file_dir . "/.htaccess") || file_get_contents($log_file_dir . "/.htaccess") !== $htaccess_body) {
                $save_log_file = false;
            }
        } else {
            $save_log_file = false;
        }
    }
    if ($save_log_file) {
        // Save data to text file
        file_put_contents($dated_log_file_dir . "/" . $test_text . "paypal_ipn_" . $date . ".txt", "paypal_ipn_status = " . $paypal_ipn_status . "\r\n" . "paypal_ipn_date = " . $timestamp . "\r\n" . $data_text . "\r\n", FILE_APPEND);
    }
}

if ($send_confirmation_email) {
    // Send confirmation email
    mail($confirmation_email_address, $test_text . "PayPal IPN : " . $paypal_ipn_status, "paypal_ipn_status = " . $paypal_ipn_status . "\r\n" . "paypal_ipn_date = " . $timestamp . "\r\n" . $data_text, "From: " . $from_email_address);
}

// Reply with an empty 200 response to indicate to paypal the IPN was received correctly

header("HTTP/1.1 200 OK");
?>


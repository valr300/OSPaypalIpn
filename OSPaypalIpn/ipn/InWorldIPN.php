<?php

// Only grid-local inworld objects hosted on ALLOWED_HOST may call this scri

$hostip = isset($_SERVER["REMOTE_ADDR"]) ? $_SERVER["REMOTE_ADDR"] : "unknown";

 if ($hostip == "unknown") {
  // couldn't resolve client ip
  http_response_code(401);
  die();
  } 
 else {
      	if(!in_array($hostip, array('127.0.0.1', '24.201.146.244')))  
        {
            http_response_code(401);
            die();
         }
     }
 


require('login.php');




function Finalize()
{

  global  $servername,$database,$username,$password;


   try
   {
       $conn = new \PDO("mysql:host=$servername;dbname=$database", $username, $password);
   }
   catch (PDOException $e)
   {
     echo"error";
    # die("Connection failed: " . $e);
     echo $e.GetMessage();
   }

   $stmt = $conn->prepare("call FinalizePaypal(:Invoice,:RegionName,:AvatarName,:AvatarId)");


   $json = file_get_contents('php://input');
   $data = json_decode($json);

   $Invoice=$data->Invoice;
   $RegionName=$data->RegionName;
   $AvatarName=$data->AvatarName;
   $AvatarId=$data->AvatarId;


   $stmt->bindParam('Invoice',$Invoice);
   $stmt->bindParam('RegionName',$RegionName);
   $stmt->bindParam('AvatarName',$AvatarName);
   $stmt->bindParam('AvatarId',$AvatarId);
   $stmt->execute();
   $amount=0.0;
   $currency="";
   $inworldUpdate="";
   $status="eof";
   $protocol = isset($_SERVER["HTTPS"]) ? 'https' : 'http';
   if ($stmt->rowCount()> 0) {
	   $row = $stmt->fetch();
	   $amount=$row['Mc_gross'];
	   $currency=$row["Mc_currency"];
	   $inworldUpdate=$row["InWorldUpdate"];
	   $status=$row["Payment_status"];
   }
   $stmt = null;
   $conn = null;

   $data = ['invoice' => $Invoice, 'amount' => $amount, 'currency' => $currency, 'status' => $status,
	   'AvatarId' => $AvatarId, 'AvatarName' => $AvatarName, 'InWorldUpdate'=> $inworldUpdate];
   // will encode to JSON object: {"name":"God","age":-1}  
   //     // accessed as example in JavaScript like: result.name or result['name'] (returns "God");
   header('Content-Type: application/json; charset=utf-8');
   echo json_encode($data);
  # header("HTTP/1.1 200 OK");

}



Finalize();

?>

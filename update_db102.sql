USE `Paypal`;

ALTER TABLE `Paypal`.`Paypals` 
ADD COLUMN `ReceiverEmail` VARCHAR(127) NULL DEFAULT NULL AFTER `RegionName`;


DROP procedure IF EXISTS `AddPaypal`;

USE `Paypal`;
DROP procedure IF EXISTS `Paypal`.`AddPaypal`;
;

DELIMITER $$
USE `Paypal`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AddPaypal`(
 Invoice varchar(12) ,
 RegionName varchar(63),
 AvatarName varchar(255),  
 AvatarId varchar(36),  
 Item_name varchar(63),
 Item_number varchar(63),
 Mc_Handling decimal(15,4),
 Mc_currency varchar(12),
 Mc_fee decimal(15,4),
 Mc_gross decimal(15,4),  
 Mc_Shipping decimal(15,4),   
 Payment_Date datetime,
 Payment_fee decimal(15,4),  
 Payment_gross decimal(15,4),    
 Payment_status varchar(36),
 Payment_type varchar(36), 		
 Paypal_Payment_Date varchar(64),
 Protection_eligibility varchar(36),    
 Quantity int,  
 Tax decimal(15,4),      
 Txn_id varchar(36),
 Txn_type varchar(36),
 Auth_Amount decimal(15,4),
 Auth_Exp varchar(28),
 Auth_Status varchar(64),
 Echeck_Time_Processed varchar(28),
 Exchange_Rate decimal(20,8),
 ReceiverEmail varchar(127)
  )
BEGIN

  if exists(select Txn_id from Paypal.Paypals d where d.Txn_id = Txn_id) THEN
     update   Paypal.Paypals u 
         set  u.Payment_status= Payment_status, u.Paypal_Payment_Date=Paypal_Payment_Date;  
  ELSE      
	  INSERT INTO Paypal.Paypals ( Invoice, RegionName, AvatarName, AvatarId, Item_name, Item_number, Mc_Handling, Mc_currency, Mc_fee, Mc_gross,  Mc_Shipping,
                                   Payment_Date, Payment_fee, Payment_gross, Payment_status, Payment_type,   Quantity,  
								   Tax, Txn_id, Txn_type,Paypal_Payment_Date, Echeck_Time_Processed,Exchange_Rate,ReceiverEmail) 
            VALUES ( Invoice, RegionName, AvatarName, AvatarId, Item_name, Item_number, Mc_Handling, Mc_currency, Mc_fee, Mc_gross,  Mc_Shipping,
                                   Payment_Date, Payment_fee, Payment_gross, Payment_status, Payment_type,   Quantity,  
								   Tax, Txn_id, Txn_type,Paypal_Payment_Date,Echeck_Time_Processed,Exchange_Rate,ReceiverEmail);
  END IF;                                 
			
		

  
  
END$$

DELIMITER ;
;


CREATE DATABASE  IF NOT EXISTS `Paypal` /*!40100 DEFAULT CHARACTER SET utf8mb3 */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `Paypal`;
-- MySQL dump 10.13  Distrib 8.0.31, for Win64 (x86_64)
--
-- Host: localhost    Database: Paypal
-- ------------------------------------------------------
-- Server version	8.0.36-0ubuntu0.22.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping routines for database 'Paypal'
--
/*!50003 DROP PROCEDURE IF EXISTS `AddPaypal` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
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
 Exchange_Rate decimal(20,8)
  )
BEGIN

  if exists(select Txn_id from Paypal.Paypals d where d.Txn_id = Txn_id) THEN
     update   Paypal.Paypals u 
         set  u.Payment_status= Payment_status, u.Paypal_Payment_Date=Paypal_Payment_Date;  
  ELSE      
	  INSERT INTO Paypal.Paypals ( Invoice, RegionName, AvatarName, AvatarId, Item_name, Item_number, Mc_Handling, Mc_currency, Mc_fee, Mc_gross,  Mc_Shipping,
                                   Payment_Date, Payment_fee, Payment_gross, Payment_status, Payment_type,   Quantity,  
								   Tax, Txn_id, Txn_type,Paypal_Payment_Date, Echeck_Time_Processed,Exchange_Rate) 
            VALUES ( Invoice, RegionName, AvatarName, AvatarId, Item_name, Item_number, Mc_Handling, Mc_currency, Mc_fee, Mc_gross,  Mc_Shipping,
                                   Payment_Date, Payment_fee, Payment_gross, Payment_status, Payment_type,   Quantity,  
								   Tax, Txn_id, Txn_type,Paypal_Payment_Date,Echeck_Time_Processed,Exchange_Rate);
  END IF;                                 
			
		

  
  
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `FinalizePaypal` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `FinalizePaypal`(
 in vInvoice varchar(127) ,
 in vRegionName varchar(63),
 in vAvatarName varchar(255),  
 in vAvatarId varchar(36)
   )
BEGIN
 
  if exists(select Invoice from Paypal.Paypals d where d.Invoice = vInvoice and d.AvatarName ="" and d.RegionName="") THEN
     update   Paypal.Paypals u 
         set  RegionName= vRegionName, AvatarName=vAvatarName, AvatarId=vAvatarId, InWorldUpdate=now()  
         where u.Invoice=vInvoice;
  END IF;      
 
  select  p.Mc_gross, p.Mc_currency,  p.Payment_status, p.InWorldUpdate 
     from Paypal.Paypals  as p
     where p.Invoice = vInvoice
   limit 1;
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-06-12 14:05:54



/* ************************************************************* */
/*     views                                                     */
/* ************************************************************* */

USE `Paypal`;
CREATE  OR REPLACE VIEW `Paypal_Stats` AS

Select Payment_Date, RegionName, Item_name, Item_Number, Invoice, payment_gross, AvatarName, payment_status
 from  Paypal.Paypals
order by Payment_date desc;

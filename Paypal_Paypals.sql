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
-- Table structure for table `Paypals`
--

DROP TABLE IF EXISTS `Paypals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Paypals` (
  `Txn_id` varchar(36) NOT NULL,
  `RegionName` varchar(63) DEFAULT NULL,
  `AvatarName` varchar(255) DEFAULT NULL,
  `AvatarId` varchar(36) DEFAULT NULL,
  `Item_name` varchar(127) DEFAULT NULL,
  `Item_number` varchar(127) DEFAULT NULL,
  `Invoice` varchar(127) DEFAULT NULL,
  `Mc_Handling` decimal(15,2) DEFAULT NULL,
  `Mc_currency` varchar(12) DEFAULT NULL,
  `Mc_fee` decimal(15,2) DEFAULT NULL,
  `Mc_gross` decimal(15,2) DEFAULT NULL,
  `Mc_Shipping` decimal(15,2) DEFAULT NULL,
  `Payment_Date` datetime DEFAULT NULL,
  `Payment_fee` decimal(15,2) DEFAULT NULL,
  `Payment_gross` decimal(15,2) DEFAULT NULL,
  `Payment_status` varchar(36) DEFAULT NULL,
  `Payment_type` varchar(36) DEFAULT NULL,
  `Paypal_Payment_Date` varchar(64) DEFAULT NULL,
  `Quantity` int DEFAULT NULL,
  `Tax` decimal(15,2) DEFAULT NULL,
  `Txn_type` varchar(36) DEFAULT NULL,
  `Echeck_Time_Processed` varchar(28) DEFAULT NULL,
  `Exchange_Rate` decimal(20,8) DEFAULT NULL,
  `InWorldUpdate` datetime DEFAULT NULL,
  PRIMARY KEY (`Txn_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Contains all Paypal Transactions';
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-06-12 14:05:51

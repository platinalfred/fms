-- MySQL dump 10.13  Distrib 5.7.20, for Linux (x86_64)
--
-- Host: localhost    Database: fms
-- ------------------------------------------------------
-- Server version	5.7.22-0ubuntu0.16.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `deposit_product_feen`
--
DROP TABLE IF EXISTS `deposit_product_feen`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `deposit_product_feen` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `depositProductId` int(11) NOT NULL,
  `depositProductFeeId` int(11) NOT NULL,
  `createdBy` int(11) NOT NULL,
  `dateCreated` int(11) NOT NULL,
  `modifiedBy` int(11) NOT NULL,
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `dateModified` (`dateModified`),
  KEY `fkModifiedBy` (`modifiedBy`),
  KEY `dateCreated` (`dateCreated`),
  KEY `fkCreatedBy` (`createdBy`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1 COMMENT='Fees applicable to a given deposit product';
/*!40101 SET character_set_client = @saved_cs_client */;

INSERT INTO deposit_product_feen(`depositProductId`, `depositProductFeeId`, `dateCreated`, `createdBy`, `modifiedBy`)
SELECT `depositProductId`, `id`, `dateCreated`, `createdBy`, `modifiedBy` FROM `deposit_product_fee`;

ALTER TABLE `fms`.`deposit_product_fee` 
ADD COLUMN `status` TINYINT(1) NULL DEFAULT 1 AFTER `id`;
ALTER TABLE `fms`.`loan_product_fee` 
ADD COLUMN `status` TINYINT(1) NULL DEFAULT 1 AFTER `id`;
ALTER TABLE `fms`.`deposit_product_feen` 
ADD COLUMN `status` TINYINT(1) NULL DEFAULT 1 AFTER `id`;
ALTER TABLE `fms`.`loan_product_feen` 
ADD COLUMN `status` TINYINT(1) NULL DEFAULT 1 AFTER `id`;

/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-05-10 16:09:08

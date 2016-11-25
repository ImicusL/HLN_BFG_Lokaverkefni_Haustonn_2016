CREATE DATABASE  IF NOT EXISTS `0604972069_freshair` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `0604972069_freshair`;
-- MySQL dump 10.13  Distrib 5.7.12, for Win64 (x86_64)
--
-- Host: tsuts.tskoli.is    Database: 0604972069_freshair
-- ------------------------------------------------------
-- Server version	5.7.14-log

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
-- Table structure for table `pricecategories`
--

DROP TABLE IF EXISTS `pricecategories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pricecategories` (
  `categoryID` int(11) NOT NULL AUTO_INCREMENT,
  `categoryName` varchar(35) DEFAULT NULL,
  `validFrom` date DEFAULT NULL,
  `validTo` date DEFAULT NULL,
  `minimumPrice` int(11) DEFAULT NULL,
  `refundable` tinyint(1) DEFAULT NULL,
  `seatNumberRestrictions` int(11) DEFAULT NULL,
  `classID` int(11) DEFAULT NULL,
  PRIMARY KEY (`categoryID`),
  KEY `category_class_FK` (`classID`),
  CONSTRAINT `category_class_FK` FOREIGN KEY (`classID`) REFERENCES `classes` (`classID`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pricecategories`
--

LOCK TABLES `pricecategories` WRITE;
/*!40000 ALTER TABLE `pricecategories` DISABLE KEYS */;
INSERT INTO `pricecategories` VALUES (1,'FullEconomyScandinavia','2016-08-01','2016-09-30',35000,1,0,3),(2,'BasicEconomyScandinavia','2016-08-01','2016-09-30',23000,0,0,3),(3,'ReducedEconomyScandinavia','2016-08-01','2016-09-30',14700,0,15,3),(4,'BusinessClassKEF-OSL','2016-08-01','2016-09-30',70000,1,0,2),(5,'Football Alliance','2016-08-01','2016-12-31',12500,1,0,2),(6,'Ociania special','2016-08-01','2016-12-31',98900,1,35,3),(7,'Ociania supercomfort','2016-08-01','2016-12-31',197200,1,15,2),(8,'Ociania complete','2016-08-01','2016-12-31',311000,1,8,1);
/*!40000 ALTER TABLE `pricecategories` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-11-21 13:29:58

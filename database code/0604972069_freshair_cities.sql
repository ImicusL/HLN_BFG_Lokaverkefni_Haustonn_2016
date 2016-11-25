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
-- Table structure for table `cities`
--

DROP TABLE IF EXISTS `cities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cities` (
  `cityID` int(11) NOT NULL AUTO_INCREMENT,
  `cityName` varchar(35) NOT NULL,
  `countryCode` char(2) DEFAULT NULL,
  PRIMARY KEY (`cityID`),
  KEY `city_countries_FK` (`countryCode`),
  CONSTRAINT `city_countries_FK` FOREIGN KEY (`countryCode`) REFERENCES `countries` (`alpha336612`)
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cities`
--

LOCK TABLES `cities` WRITE;
/*!40000 ALTER TABLE `cities` DISABLE KEYS */;
INSERT INTO `cities` VALUES (1,'Reykjavik','IS'),(2,'Oslo','NO'),(3,'Stockholm','SE'),(4,'Copenhagen','DK'),(5,'Helsinki','FI'),(6,'London','GB'),(7,'Paris','FR'),(8,'Frankfurt','DE'),(9,'Zürich','CH'),(10,'Barcelona','ES'),(11,'Moscow','RU'),(12,'Warsaw','PL'),(13,'Torshavn','FO'),(14,'Milano','IT'),(15,'Vienna','AT'),(16,'Istanbul','TR'),(17,'Tel Aviv','IL'),(18,'Cairo','EG'),(19,'Doha','QA'),(20,'Dar es Salaam','TZ'),(21,'Nairobi','KE'),(22,'Johannesburg','ZA'),(23,'Teheran','IR'),(24,'Baghdad','IQ'),(25,'Mumbai','IN'),(26,'Beijing','CN'),(27,'Bangkok','TH'),(28,'Hanoi','VN'),(29,'Tokyo','JP'),(30,'Sydney','AU'),(31,'Auckland','NZ'),(32,'Boston','US'),(33,'Los Angeles','US'),(34,'Toronto','CA'),(35,'Kingston','JM'),(36,'Rio De Janeiro','BR'),(37,'Mexico City','MX'),(38,'Glasgow','GB'),(39,'Lissabon','PT'),(40,'Prague','CZ'),(41,'Buenos Aires','AR'),(42,'New York','US'),(43,'Athens','GR');
/*!40000 ALTER TABLE `cities` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-11-21 13:29:33

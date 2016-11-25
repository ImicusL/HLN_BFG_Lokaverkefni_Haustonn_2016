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
-- Table structure for table `flights_has_staff`
--

DROP TABLE IF EXISTS `flights_has_staff`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `flights_has_staff` (
  `flights_has_staffID` int(11) NOT NULL AUTO_INCREMENT,
  `flights_flightCode` int(11) NOT NULL,
  `staff_personID` varchar(35) NOT NULL,
  PRIMARY KEY (`flights_has_staffID`),
  KEY `fk_flights_has_staff_staff1_idx` (`staff_personID`),
  KEY `fk_flights_has_staff_flights1_idx` (`flights_flightCode`),
  CONSTRAINT `fk_flights_has_staff_flights1` FOREIGN KEY (`flights_flightCode`) REFERENCES `flights` (`flightCode`),
  CONSTRAINT `fk_flights_has_staff_staff1` FOREIGN KEY (`staff_personID`) REFERENCES `staff` (`personID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flights_has_staff`
--

LOCK TABLES `flights_has_staff` WRITE;
/*!40000 ALTER TABLE `flights_has_staff` DISABLE KEYS */;
INSERT INTO `flights_has_staff` VALUES (1,1,'IS1020313'),(2,1,'DE4015928'),(3,1,'IS4558453'),(4,1,'IS3297520'),(5,1,'IS4558453'),(6,1,'IS3976809');
/*!40000 ALTER TABLE `flights_has_staff` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-11-21 13:30:00

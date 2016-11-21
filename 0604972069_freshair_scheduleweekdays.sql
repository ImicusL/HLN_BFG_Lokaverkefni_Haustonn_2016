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
-- Table structure for table `scheduleweekdays`
--

DROP TABLE IF EXISTS `scheduleweekdays`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `scheduleweekdays` (
  `weekday` int(11) NOT NULL,
  `departure` time NOT NULL,
  `flightNumber` char(5) NOT NULL,
  PRIMARY KEY (`weekday`,`flightNumber`),
  KEY `flightnumber_flightschedule_FK` (`flightNumber`),
  CONSTRAINT `flightnumber_flightschedule_FK` FOREIGN KEY (`flightNumber`) REFERENCES `flightschedules` (`flightNumber`),
  CONSTRAINT `flightnumber_weekdays_FK` FOREIGN KEY (`weekday`) REFERENCES `weekdays` (`weekdayNumber`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `scheduleweekdays`
--

LOCK TABLES `scheduleweekdays` WRITE;
/*!40000 ALTER TABLE `scheduleweekdays` DISABLE KEYS */;
INSERT INTO `scheduleweekdays` VALUES (1,'00:30:00','FA101'),(1,'08:10:00','FA501'),(1,'12:45:00','FA502'),(2,'01:30:00','FA102'),(2,'08:10:00','FA501'),(2,'12:45:00','FA502'),(3,'08:10:00','FA501'),(3,'12:45:00','FA502'),(4,'08:10:00','FA501'),(4,'12:45:00','FA502'),(5,'08:10:00','FA501'),(5,'12:45:00','FA502'),(6,'07:40:00','FA501'),(6,'12:15:00','FA502'),(7,'07:40:00','FA501'),(7,'12:15:00','FA502');
/*!40000 ALTER TABLE `scheduleweekdays` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-11-21 12:43:49

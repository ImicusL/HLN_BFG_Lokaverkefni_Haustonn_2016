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
-- Table structure for table `airports`
--

DROP TABLE IF EXISTS `airports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `airports` (
  `IATAcode` char(3) NOT NULL,
  `airportName` varchar(75) DEFAULT NULL,
  `cityID` int(11) DEFAULT NULL,
  PRIMARY KEY (`IATAcode`),
  KEY `airport_city_FK` (`cityID`),
  CONSTRAINT `airport_city_FK` FOREIGN KEY (`cityID`) REFERENCES `cities` (`cityID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `airports`
--

LOCK TABLES `airports` WRITE;
/*!40000 ALTER TABLE `airports` DISABLE KEYS */;
INSERT INTO `airports` VALUES ('AKL','Auckland International',31),('ARN','Arlanda',3),('ATH','Athens International Airport',43),('BCN','Barcelona International ',10),('BGW','Baghdad International Airport',24),('BKK','Suvarnabhumi',27),('BOM','Chhatrapati Shivaji International Airport',25),('BOS','Logan International',32),('CAI','Cairo International',18),('CDG','Charles de Gaulle International',7),('CPH','Kastrup',4),('DAR','Julius Nyerere International Airport',20),('DOH','Doha International Airport',19),('FAE','Vagar Airport',13),('FRA','Frankfurt am Main International',8),('GIG','Galeão - Antônio Carlos Jobim International',36),('GLA','Glasgow International Airport',38),('HAN','Noi Bai International Airport',28),('HEL','Helsinki Vantaa',5),('HHN','Frankfurt-Hahn',8),('HKG','Hong Kong International Airport',26),('IST','Istanbul Atatürk Airport',16),('IZE','Ministro Pistarini International Airport',41),('JFK','John F. Kennedy Airport',42),('JNB','OR Tambo International',22),('KEF','Keflavik Airport',1),('KIN','Norman Manley International',35),('LAX','Los Angeles International',33),('LHR','London Heathrow',6),('LIS','Lisbon Portela Airport',39),('MEX','Licenciado Benito Juarez International Airport',37),('MXP','Malpensa International',14),('NBO','Jomo Kenyatta International',21),('NRT','Narita International',29),('OSL','Gardermoen',2),('PEK','Beijing Capital International',26),('PRG','Prague Václav Havel Airport',40),('STN','London Stansted',6),('SVO','Sheremetyevo International ',11),('SYD','Sydney Kingsford Smith International',30),('THR','Mehrabad International Airport',23),('TLV','Ben Gurion International',17),('VIE','Vienna International',15),('WAW','Warsaw Chopin Airport',12),('YYZ','Lester B. Pearson International',34),('ZRH','Zürich Airport',9);
/*!40000 ALTER TABLE `airports` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-11-21 13:29:38

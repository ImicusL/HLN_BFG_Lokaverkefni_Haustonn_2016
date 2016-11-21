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
-- Table structure for table `staff`
--

DROP TABLE IF EXISTS `staff`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `staff` (
  `personID` varchar(35) NOT NULL,
  `firstName` varchar(75) NOT NULL,
  `lastName` varchar(75) NOT NULL,
  `dateOfBirth` date NOT NULL,
  `countryOfResidence` char(2) NOT NULL,
  `jobsID` int(11) NOT NULL,
  PRIMARY KEY (`personID`),
  KEY `staff_jobs_FK` (`jobsID`),
  KEY `staff_country_FK` (`countryOfResidence`),
  CONSTRAINT `staff_country_FK` FOREIGN KEY (`countryOfResidence`) REFERENCES `countries` (`alpha336612`),
  CONSTRAINT `staff_jobs_FK` FOREIGN KEY (`jobsID`) REFERENCES `jobs` (`jobsID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff`
--

LOCK TABLES `staff` WRITE;
/*!40000 ALTER TABLE `staff` DISABLE KEYS */;
INSERT INTO `staff` VALUES ('DE1016276','Patrick','Hahn','1987-09-01','DE',19),('DE1635425','Iris','Peters','1976-02-07','DE',19),('DE4015928','Rita','Walter','1961-10-19','DE',19),('DE4091170','Alexander','König','1972-07-12','DE',17),('DE4335275','Thomas','Wolf','1980-06-23','DE',17),('DE5970378','Ernst','König','1969-10-17','DE',14),('DE7129159','Hedwig','Schumacher','1968-09-21','DE',9),('DE7166873','Robert','Wolf','1962-09-05','DE',8),('DE7438966','Heinrich','Werner','1985-11-25','DE',14),('DE8510054','Ingrid','Albrecht','1970-07-01','DE',9),('DE8711960','Alexander','Koch','1967-01-24','DE',16),('DE8855918','Cornelia','Möller','1986-02-21','DE',13),('DE9129813','Florian','Bergmann','1979-07-02','DE',23),('DE9510293','Matthias','Richter','1982-03-13','DE',10),('DE9711240','Norbert','Wagner','1977-05-04','DE',17),('IS1020313','Halldóra','Þórisdóttir','1983-02-26','IS',17),('IS1040873','Þorbjörg','Arnarsdóttir','1974-04-01','IS',9),('IS1057667','Hrafnhildur','Aradóttir','1964-10-26','IS',14),('IS1058167','Guðmundur','Brynjarson','1975-07-14','IS',19),('IS1080685','Guðmundur','Arnórsson','1976-03-22','IS',8),('IS1082027','Jón','Bergsson','1968-02-23','IS',16),('IS1088564','Aron','Pétursson','1975-01-28','IS',9),('IS1090279','Ósk','Hauksdóttir','1962-06-16','IS',17),('IS1091517','Daði','Hafsteinsson','1986-01-09','IS',9),('IS1490240','Jóhann','Darrason','1979-07-25','IS',8),('IS1582229','Róbert','Þórisson','1967-09-14','IS',9),('IS1676650','Íris','Viktorsdóttir','1973-03-19','IS',9),('IS1967643','Sigurður','Hjaltason','1956-09-24','IS',1),('IS2109280','Ólafur','Gunnarsson','1984-03-19','IS',9),('IS2619919','Elvar','Heiðarsson','1964-10-28','IS',19),('IS2782657','Hanna','Vignisdóttir','1967-03-02','IS',5),('IS3010789','Guðmundur','Pétursson','1971-01-07','IS',19),('IS3227268','Magnús','Hafsteinsson','1973-08-23','IS',9),('IS3297520','Rúnar','Jóhannsson','1977-02-19','IS',9),('IS3695649','Sigrún','Leósdóttir','1981-11-01','IS',9),('IS3976809','Halldóra','Egilsdóttir','1961-01-15','IS',9),('IS4027852','Sigurður','Ísaksson','1984-07-24','IS',8),('IS4160916','Gunnar','Guðjónsson','1964-07-11','IS',9),('IS4195049','Axel','Geirsson','1983-06-28','IS',9),('IS4287694','Erla','Júlíusdóttir','1968-02-21','IS',17),('IS4338718','Guðrún','Fannarsdóttir','1965-06-02','IS',14),('IS4340997','Inga','Steinarsdóttir','1973-10-23','IS',11),('IS4508672','Marta','Ómarsdóttir','1977-02-16','IS',19),('IS4558453','Lind','Atladóttir','1986-04-11','IS',9),('IS4698257','Anna','Atladóttir','1983-05-20','IS',14),('IS4775977','Skúli','Þorsteinsson','1973-03-25','IS',9),('IS5158995','Guðrún','Traustadóttir','1973-09-02','IS',9),('IS5487187','Kári','Hilmarsson','1964-11-08','IS',9),('IS5517359','Kolbrún','Hjartardóttir','1975-10-30','IS',5),('IS5584466','Páll','Gunnlaugsson','1980-09-05','IS',11),('IS5623569','Kári','Haraldsson','1975-09-18','IS',17),('IS5626040','Orri','Halldórsson','1975-11-20','IS',9),('IS5835590','Jóhanna','Hafsteinsdóttir','1974-02-11','IS',6),('IS5883868','Mist','Pálsdóttir','1985-03-21','IS',5),('IS5902062','Þóra','Sveinsdóttir','1983-08-01','IS',21),('IS6070448','Reynir','Andrason','1976-06-02','IS',9),('IS6133268','Þórir','Ragnarsson','1979-10-10','IS',10),('IS6423585','Tinna','Sindradóttir','1976-11-13','IS',3),('IS6669362','Gunnhildur','Bragadóttir','1981-09-05','IS',9),('IS6943391','Guðmundur','Bergmannsson','1976-11-17','IS',14),('IS7485797','Darri','Valsson','1984-05-18','IS',19),('IS7561298','Páll','Birgisson','1985-11-19','IS',11),('IS7886955','Anna','Freysdóttir','1974-08-03','IS',9),('IS8025519','Alda','Jóhannsdóttir','1971-01-10','IS',10),('IS8722679','Kristjana','Brynjardóttir','1980-11-28','IS',21),('IS8734277','Tómas','Garðarsson','1969-08-20','IS',15),('IS8978154','Guðrún','Eiríksdóttir','1983-09-17','IS',8),('IS9084848','Guðrún','Friðriksdóttir','1985-06-02','IS',19),('IS9375808','Guðni','Tómasson','1965-08-05','IS',17),('IS9886282','Ómar','Garðarsson','1976-05-19','IS',19),('IS9989055','Guðlaug','Guðjónsdóttir','1974-03-20','IS',12),('NO1036932','Else','Hansen','1978-08-17','NO',19),('NO3541093','Marius','Solberg','1959-06-15','NO',2),('NO3806792','Kim','Kristensen','1950-01-19','NO',9),('NO5151029','Lars','Johnsen','1974-03-27','NO',9),('NO5300449','Ellen','Kristiansen','1961-10-16','NO',19),('NO5898713','Aud','Johannessen','1971-06-20','NO',9),('NO6555544','Stine','Strand','1985-08-28','NO',22),('NO6916885','Svein','Nilsen','1967-10-01','NO',17),('NO8054184','Jorunn','Nilsen','1979-09-22','NO',9),('NO8395297','Emma','Kristoffersen','1987-01-12','NO',19),('NO9407671','Ole','Aune','1971-11-02','NO',17),('NO9645914','Kristin','Larsen','1967-03-01','NO',17),('NO9863005','Frode','Bakke','1965-09-28','NO',9),('SE1016265','Wilmer','Nilsson','1966-11-06','SE',17),('SE1199800','Oscar','Karlsson','1964-07-18','SE',8),('SE3260289','Love','Davis','1962-05-10','SE',20),('SE3327154','Erik','Nilsson','1981-03-21','SE',8),('SE3350252','Alice','Persson','1987-09-28','SE',14),('SE3669145','Iris','Karlsson','1974-11-07','SE',19),('SE5833049','Elvira','Hansson','1984-10-28','SE',9),('SE5921827','Adam','Andersson','1966-08-29','SE',14),('SE6283026','Filip','Pettersson','1960-03-13','SE',19),('SE6863731','Liam','Andersson','1971-11-03','SE',17),('SE6866923','Sigrid','Andersson','1964-03-13','SE',19),('SE6910133','Olle','Mattsson','1967-06-08','SE',19),('SE7263702','Viggo','Johansson','1968-02-21','SE',17),('SE7812512','Leia','Holmqvist','1972-10-16','SE',23),('SE8399384','Oscar','Johansson','1978-04-18','SE',19),('SE8668778','Nova','Isaksson','1963-10-21','SE',17),('SE8969706','Olle','Johansson','1975-08-23','SE',19),('SE9971296','Otto','Eriksson','1972-06-29','SE',17),('US1030569','Timothy','Andersson','1981-06-22','CA',18),('US1041107','Melissa','White','1974-04-01','US',21),('US1058105','Arthur','Garcia','1973-04-06','US',17),('US1059020','John','Hill','1970-05-05','US',9),('US3048812','Larry','Howard','1987-08-13','US',9),('US4681485','Martha','Green','1966-02-04','US',16),('US5110585','Nancy','Jones','1963-11-09','US',9),('US5468380','Christopher','Allen','1974-09-18','US',17),('US5501283','Mark','Smith','1966-09-13','US',18),('US6734805','Joshua','Smith','1976-01-05','US',17),('US6786294','Jeffrey','Harris','1940-10-11','US',19),('US7599112','Eugene','Edwards','1954-08-03','US',14),('US7768136','Sandra','Wright','1964-06-28','US',11);
/*!40000 ALTER TABLE `staff` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-11-21 12:43:44

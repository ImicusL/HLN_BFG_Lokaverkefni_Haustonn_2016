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
-- Dumping routines for database '0604972069_freshair'
--
/*!50003 DROP FUNCTION IF EXISTS `flightcodewithdateandnumber` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`0604972069`@`%` FUNCTION `flightcodewithdateandnumber`(flight_date date, flight_number char(5)) RETURNS int(11)
BEGIN
	RETURN(SELECT flightcode FROM flights WHERE flights.flightDate = flight_date AND flights.flightNumber = flight_number);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `GetIDwFlightCode` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`0604972069`@`%` FUNCTION `GetIDwFlightCode`(daflightcode INT) RETURNS varchar(10) CHARSET utf8
begin
	RETURN(SELECT DISTINCT AircraftID FROM flights WHERE flightCode = daflightcode);
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `getOccupiedSeats` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ALLOW_INVALID_DATES,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`0604972069`@`%` FUNCTION `getOccupiedSeats`(Flight_Number CHAR(5), Flight_Date DATE) RETURNS int(11)
BEGIN
      DECLARE number_of_seats INT;
      DECLARE number_of_booked_seats INT;
      DECLARE aircraft_ID CHAR(6);

      SET aircraft_ID = (SELECT aircraftID FROM Flights WHERE flightNumber = Flight_Number AND flightDate = Flight_Date);
      SET number_of_seats = NumberOfSeats(aircraft_ID);

      SELECT COUNT(seatingID) into number_of_booked_seats
      FROM Passengers
      JOIN BookedFlights ON Passengers.bookedFlightID = BookedFlights.bookedFlightID
      JOIN Flights ON BookedFlights.flightCode = Flights.flightCode
      JOIN FlightSchedules ON Flights.flightNumber = FlightSchedules.flightNumber
      AND FlightSchedules.flightNumber = Flight_Number
      AND Flights.flightDate = Flight_Date;

RETURN number_of_booked_seats;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `getUnoccupiedSeats` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ALLOW_INVALID_DATES,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`0604972069`@`%` FUNCTION `getUnoccupiedSeats`(Flight_Number CHAR(5), Flight_Date DATE) RETURNS int(11)
BEGIN
	DECLARE number_of_seats INT;
	DECLARE number_of_booked_seats INT;
	DECLARE aircraft_ID CHAR(6);

	SET aircraft_ID = (SELECT aircraftID FROM Flights WHERE flightNumber = Flight_Number AND flightDate = Flight_Date);
	SET number_of_seats = NumberOfSeats(aircraft_ID);

	SELECT COUNT(seatingID) into number_of_booked_seats
	FROM Passengers
	JOIN BookedFlights ON Passengers.bookedFlightID = BookedFlights.bookedFlightID
	JOIN Flights ON BookedFlights.flightCode = Flights.flightCode
	JOIN FlightSchedules ON Flights.flightNumber = FlightSchedules.flightNumber
	AND FlightSchedules.flightNumber = Flight_Number
	AND Flights.flightDate = Flight_Date;

	RETURN number_of_seats - number_of_booked_seats;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `listAircraft` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ALLOW_INVALID_DATES,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`0604972069`@`%` FUNCTION `listAircraft`() RETURNS varchar(6) CHARSET utf8
BEGIN
	RETURN(SELECT aircraftID FROM aircrafts);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `NumberOfSeats` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`0604972069`@`%` FUNCTION `NumberOfSeats`(Aircraft_ID Char(6)) RETURNS int(11)
begin
	RETURN(SELECT COUNT(*) FROM aircraftseats WHERE aircraftID = Aircraft_ID);
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `passengerCountByFlight` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ALLOW_INVALID_DATES,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`0604972069`@`%` FUNCTION `passengerCountByFlight`(Flight_Number CHAR(5), Flight_Date DATE) RETURNS int(11)
BEGIN
      DECLARE number_of_seats INT;
      DECLARE number_of_booked_seats INT;
      DECLARE aircraft_ID CHAR(6);

      SET aircraft_ID = (SELECT aircraftID FROM Flights WHERE flightNumber = Flight_Number AND flightDate = Flight_Date);
      SET number_of_seats = (SELECT COUNT(*) FROM aircraftseats WHERE aircraftID = Aircraft_ID);

      SELECT COUNT(seatingID) into number_of_booked_seats
      FROM Passengers
      JOIN BookedFlights ON Passengers.bookedFlightID = BookedFlights.bookedFlightID
      JOIN Flights ON BookedFlights.flightCode = Flights.flightCode
      JOIN FlightSchedules ON Flights.flightNumber = FlightSchedules.flightNumber
      AND FlightSchedules.flightNumber = Flight_Number
      AND Flights.flightDate = Flight_Date;

RETURN number_of_booked_seats;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `addCabinCrew` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`0604972069`@`%` PROCEDURE `addCabinCrew`(flight_code int)
BEGIN
	declare x INT default 0;
    declare maxruns INT default 0;
    SET x = 1;
    SET maxruns = (SELECT NumberOfSeats((SELECT GetIDwFlightCode(flight_code)))) / 45; #1 þjónn fyrir 45 farðega samkvæmt verkefni
    
    WHILE x <= maxruns DO
		INSERT INTO flights_has_staff VALUES (DEFAULT, flight_code, (SELECT personID FROM staff WHERE jobsID = 9 ORDER BY RAND() LIMIT 1)); #velja flight attendant handahófi
		SET x = x + 1;
    END WHILE;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `addFlightDeck` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`0604972069`@`%` PROCEDURE `addFlightDeck`(flight_code int, flugstjori_Person_ID varchar(35), flugmadur_Person_ID varchar(35))
BEGIN
	declare stopmessage varchar(255);
	IF((SELECT staff.jobsID FROM staff WHERE staff.personID = flugstjori_Person_ID) = 17 AND (SELECT staff.jobsID FROM staff WHERE staff.personID = flugmadur_Person_ID) = 19)
    THEN
    INSERT INTO flights_has_staff VALUES (DEFAULT,flight_code,flugstjori_Person_ID),(DEFAULT,flight_code,flugmadur_Person_ID);
    ELSE
    set stopmessage = concat('Vinsamlegast veldu flugstjóra og flugmann.');
	signal sqlstate '45000' set message_text = stopmessage;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `AddFlightGeneralStaff` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`0604972069`@`%` PROCEDURE `AddFlightGeneralStaff`(flight_number CHAR(5), flight_date DATE, person_id VARCHAR(35))
BEGIN

INSERT INTO flights_has_staff(flights_has_staffID, flights_flightCode, staff_personID)
VALUES(DEFAULT, (SELECT(flightcodewithdateandnumber(flight_date, flight_number))), person_id);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `BokaFlug` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ALLOW_INVALID_DATES,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`0604972069`@`%` PROCEDURE `BokaFlug`(texti text)
BEGIN

	declare flight_date1 date;
    declare flight_number1 char(5);
    declare flight_date2 date;
    declare flight_number2 char(5);
    
    declare person_ID varchar(35);
    declare cardholders_Name varchar(55);
    declare cardissued_by varchar(35);
    declare payment_type bit(1);
    declare class_ID int(11);
    
    declare passengerID varchar(35);
    declare passengerName varchar(75);
    declare passengerflightseatID1 int(11);
    declare passengerpriceID1 int(11);
    declare passengerflightseatID2 int(11);
    declare passengerpriceID2 int(11);
    declare booked_flight_ID1 int(11);
    declare booked_flight_ID2 int(11);
    declare booking_number int(11);
    
    declare strlength int;
    
    set payment_type = cast(substring_index(texti,':',1)as unsigned);
	set texti = substring(texti,locate(':',texti) + 1);
        
	set cardissued_by = substring_index(texti,':',1);
	set texti = substring(texti,locate(':',texti) + 1);
        
	set cardholders_Name = substring_index(texti,':',1);
	set texti = substring(texti,locate(':',texti) + 1);
        
	set class_ID = substring_index(texti,':',1);
	set texti = substring(texti,locate(':',texti) + 1);
    
    set flight_date1 = substring_index(texti,':',1);
	set texti = substring(texti,locate(':',texti) + 1);
    
    set flight_number1 = substring_index(texti,':',1);
	set texti = substring(texti,locate(':',texti) + 1);
    
    set flight_date2 = substring_index(texti,':',1);
	set texti = substring(texti,locate(':',texti) + 1);
    
    set flight_number2 = substring_index(texti,':',1);
	set texti = substring(texti,locate(':',texti) + 1);
    
    insert into Bookings(bookingnumber,timeofbooking,paymenttype,cardissuedby,cardholdersname,classid,returnflight)
		values(DEFAULT,NOW(),payment_type,cardissued_by,cardholders_Name,class_ID,1);
	set booking_number = LAST_INSERT_ID();
    
    insert into BookedFlights(bookedflightid,bookingnumber,flightcode,flightorder)
		values(DEFAULT,booking_number,(select flightcodewithdateandnumber(flight_date1,flight_number1)),1); #outgoing flight
	set booked_flight_id1 = LAST_INSERT_ID();
    
	insert into BookedFlights(bookedflightid,bookingnumber,flightcode,flightorder)
		values(DEFAULT,booking_number,(select flightcodewithdateandnumber(flight_date2,flight_number2)),1); #return flight
	set booked_flight_id2 = LAST_INSERT_ID();
	
    set strlength = char_length(texti);
    while (strlength > 0) do
        
        set person_ID = substring_index(texti,':',1);
        set texti = substring(texti,locate(':',texti) + 1);
        
        set passengerName = substring_index(texti,':',1);
        set texti = substring(texti,locate(':',texti) + 1);
        
        set passengerflightseatID1 = substring_index(texti,':',1);
        set texti = substring(texti,locate(':',texti) + 1);
        
        set passengerpriceID1 = substring_index(texti,':',1);
        set texti = substring(texti,locate(':',texti) + 1);
        
        set passengerflightseatID2 = substring_index(texti,':',1);
        set texti = substring(texti,locate(':',texti) + 1);
        
        set passengerpriceID2 = substring_index(texti,':',1);
        set texti = substring(texti,locate(':',texti) + 1);
        
        insert into Passengers(seatingid,personid,personname,priceID,seatID,bookedflightid)
		values (DEFAULT,person_ID,passengerName,passengerpriceID1,passengerflightseatID1,booked_flight_ID1);# outgoing flight        
        insert into Passengers(seatingid,personid,personname,priceID,seatID,bookedflightid)
		values (DEFAULT,person_ID,passengerName,passengerpriceID2,passengerflightseatID2,booked_flight_ID2);# return flight
        
        set strlength = char_length(texti);
	end while;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `createAircraft` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ALLOW_INVALID_DATES,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`0604972069`@`%` PROCEDURE `createAircraft`(aircraft_ID CHAR(6),aircraft_Type VARCHAR(35),max_Number_Of_Passengers SMALLINT(6),entered_Service DATE,aircraft_Name VARCHAR(55))
BEGIN
	INSERT INTO aircrafts VALUES (aircraft_ID,aircraft_Type,max_Number_Of_Passengers,entered_service,aircraft_Name);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `createStaff` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`0604972069`@`%` PROCEDURE `createStaff`(person_ID varchar(35), first_Name varchar(75), last_Name varchar(75), date_Of_Birth datetime, countryOfResidence char(2), jobsID int)
BEGIN
	INSERT INTO Staff VALUES (person_ID,first_Name,last_Name,date_Of_Birth,countryOfResidence,jobsID);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `deleteAircraft` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ALLOW_INVALID_DATES,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`0604972069`@`%` PROCEDURE `deleteAircraft`(aircraft_ID char(6))
BEGIN
	DELETE FROM aircrafts WHERE aircraftID = aircraft_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Initial_staff` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`0604972069`@`%` PROCEDURE `Initial_staff`(texti text)
BEGIN

    declare person_ID varchar(35);
    declare first_name varchar(75);
    declare last_name varchar(75);
    declare dob date;
    declare resident_country char(2);
    declare jobs_ID int(11);
    
    
    declare strlength int;

    set strlength = char_length(texti);
    while (strlength > 0) do
        
        set person_ID = substring_index(texti,':',1);
        set texti = substring(texti,locate(':',texti) + 1);
        
        set first_name = substring_index(texti,':',1);
        set texti = substring(texti,locate(':',texti) + 1);
        
        set last_name = substring_index(texti,':',1);
        set texti = substring(texti,locate(':',texti) + 1);
        
		set dob = substring_index(texti,':',1);
        set texti = substring(texti,locate(':',texti) + 1);
        
		set resident_country = substring_index(texti,':',1);
        set texti = substring(texti,locate(':',texti) + 1);
        
		set jobs_ID = substring_index(texti,':',1);
        set texti = substring(texti,locate(':',texti) + 1);
        
        
        insert into staff(personID,firstName,lastName,dateOfBirth,countryOfResidence,jobsID)
        values (person_ID,first_name,last_name,dob,resident_country,jobs_ID);    
        
        set strlength = char_length(texti);
    end while;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `list` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ALLOW_INVALID_DATES,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`0604972069`@`%` PROCEDURE `list`()
BEGIN
	SELECT countrynames FROM countries;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `listAircrafts` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ALLOW_INVALID_DATES,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`0604972069`@`%` PROCEDURE `listAircrafts`()
BEGIN
	SELECT aircraftID FROM aircrafts;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `listAirports` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ALLOW_INVALID_DATES,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`0604972069`@`%` PROCEDURE `listAirports`()
BEGIN
	SELECT IATACode, AirportName FROM Airports;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `listDestinations` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ALLOW_INVALID_DATES,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`0604972069`@`%` PROCEDURE `listDestinations`()
BEGIN
	SELECT countryname FROM countries ORDER BY countryname ASC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `listFlightSchedules` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ALLOW_INVALID_DATES,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`0604972069`@`%` PROCEDURE `listFlightSchedules`()
BEGIN
	SELECT * FROM flightschedules;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `listPriceCategories` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ALLOW_INVALID_DATES,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`0604972069`@`%` PROCEDURE `listPriceCategories`()
BEGIN
	SELECT categoryname, minimumprice FROM pricecategories;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `readAircraft` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ALLOW_INVALID_DATES,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`0604972069`@`%` PROCEDURE `readAircraft`(aircraft_ID CHAR(6))
BEGIN
	SELECT * FROM aircrafts WHERE aircraftID = aircraft_ID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `updateAircraft` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ALLOW_INVALID_DATES,ERROR_FOR_DIVISION_BY_ZERO,TRADITIONAL,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`0604972069`@`%` PROCEDURE `updateAircraft`(aircraft_ID CHAR(6),aircraft_Type VARCHAR(35),max_Number_Of_Passengers SMALLINT(6),entered_Service DATE,aircraft_Name VARCHAR(55))
BEGIN
	UPDATE aircrafts SET aircraftType = aircraft_Type, maxNumberOfPassangers = max_Number_Of_Passengers, enteredservice = entered_Service, aircraftName = aircraft_Name WHERE aircraftID = aircraft_ID;
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

-- Dump completed on 2016-11-21 13:30:09

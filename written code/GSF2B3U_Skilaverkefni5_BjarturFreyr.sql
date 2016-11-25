#-----------------------------CREATE TABLES------------------------------
use 0604972069_FreshAir;

drop table if exists Jobs;
create table Jobs
(
    jobsID int not null auto_increment,
    jobsTitle varchar(75) not null,
    constraint jobsPK primary key(jobsID)
);

DROP TABLE IF EXISTS flights_has_staff;# disgusting
CREATE TABLE IF NOT EXISTS `0604972069_freshair`.`flights_has_staff` (
  `flights_has_staffID` INT NOT NULL AUTO_INCREMENT,
  `flights_flightCode` INT(11) NOT NULL,
  `staff_personID` VARCHAR(35) NOT NULL,
  PRIMARY KEY (`flights_has_staffID`),
  
  CONSTRAINT `fk_flights_has_staff_flights1`
    FOREIGN KEY (`flights_flightCode`)
    REFERENCES `0604972069_freshair`.`flights` (`flightCode`),
    
  CONSTRAINT `fk_flights_has_staff_staff1`
    FOREIGN KEY (`staff_personID`)
    REFERENCES `0604972069_freshair`.`staff` (`personID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;
CREATE INDEX `fk_flights_has_staff_staff1_idx` ON `0604972069_freshair`.`flights_has_staff` (`staff_personID` ASC);
CREATE INDEX `fk_flights_has_staff_flights1_idx` ON `0604972069_freshair`.`flights_has_staff` (`flights_flightCode` ASC);

drop table if exists Staff;
create table Staff
(
    personID varchar(35) not null,
    firstName varchar(75) not null,
    lastName varchar(75) not null,
    dateOfBirth date not null,
    countryOfResidence char(2) not null,
    jobsID int not null,
    constraint staffPK primary key(personID),
    constraint staff_jobs_FK foreign key(jobsID) references Jobs(jobsID),
    constraint staff_country_FK foreign key(countryOfResidence) references countries(alpha336612)
);

drop table if exists CrewMemberHistory;
create table CrewMemberHistory
(
	personID varchar(35) not null,
    originalAirport varchar(35),
    destinationAirport varchar(35),
    jobTitle varchar(75) not null,
    logdate datetime not null
);

#-----------------------------MANUAL INSERTS------------------------------
INSERT INTO Jobs (jobsTitle) VALUES ('Chief Executive Officer'),
									('Chairman of the Board'),
                                    ('Director of Operations'),
                                    ('Training'),
                                    ('Trainee'),
                                    ('Treasurer'),
                                    ('Flight Operation Manager'),
                                    ('Office'),
                                    ('Flight Attendant'),
                                    ('Dispatcher'),
                                    ('Technician'),
                                    ('Human Resources'),
                                    ('Marketing Director'),
                                    ('Engineer'),
                                    ('Training Manager'),
                                    ('Training'),
                                    ('Captain'),
                                    ('Maintenance'),
                                    ('First Officer'),
                                    ('Marketing'),
                                    ('Public Relations'),
                                    ('Ticket Office'),
                                    ('Quality control');

#-----------------------------TRIGGERS------------------------------
#ALL OF THIS IS NONSENSE BTW
/*
drop trigger if exists crewMemberHistoryInsertTrigger;
drop trigger if exists crewMemberHistoryUpdateTrigger;

delimiter $$
create trigger crewMemberHistoryInsertTrigger
after insert on Staff
for each row
begin
	INSERT INTO CrewMemberHistory (personID, originalAiport, destinationAirport, jobTitle, logDate) VALUES (new.personID,,,new.jobTitle,CURDATE());
end $$
delimiter ;

delimiter $$
create trigger crewMemberHistoryUpdateTrigger
after update on Staff
for each row
begin
	INSERT INTO CrewMemberHistory (personID, originalAiport, destinationAirport, jobTitle, logDate) VALUES (new.personID,,,new.jobTitle,CURDATE());
end $$
delimiter ;
*/

/*
DROP PROCEDURE IF EXISTS dummyprocedure; #comment here
DELIMITER $$
CREATE PROCEDURE dummyprocedure(dummyvarchar varchar(35))
BEGIN

END $$
DELIMITER ;
*/

#-----------------------------PROCEDURES------------------------------
DROP PROCEDURE IF EXISTS createStaff; #Starfsmannaskráning
DELIMITER $$
CREATE PROCEDURE createStaff(person_ID varchar(35), first_Name varchar(75), last_Name varchar(75), date_Of_Birth datetime, countryOfResidence char(2), jobsID int)
BEGIN
	INSERT INTO Staff VALUES (person_ID,first_Name,last_Name,date_Of_Birth,countryOfResidence,jobsID);
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS assignStaff; #Áhafnaskráning
DELIMITER $$
CREATE PROCEDURE assignStaff(person_ID varchar(35), flight_Code int)
BEGIN
	UPDATE Staff SET flightCode = flight_Code WHERE personID = person_ID;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS addFlightDeck; #Nýskrá Flugstjóra
DELIMITER $$
#CAPTAIN = 17
#FIRST OFFICER = 19
CREATE PROCEDURE addFlightDeck(flight_code int, flugstjori_Person_ID varchar(35), flugmadur_Person_ID varchar(35))
BEGIN
	declare stopmessage varchar(255);
	IF((SELECT staff.jobsID FROM staff WHERE staff.personID = flugstjori_Person_ID) = 17 AND (SELECT staff.jobsID FROM staff WHERE staff.personID = flugmadur_Person_ID) = 19)
    THEN
    INSERT INTO flights_has_staff VALUES (DEFAULT,flight_code,flugstjori_Person_ID),(DEFAULT,flight_code,flugmadur_Person_ID);
    ELSE
    set stopmessage = concat('Vinsamlegast veldu flugstjóra og flugmann.');
	signal sqlstate '45000' set message_text = stopmessage;
    END IF;
END $$
DELIMITER ;

drop function if exists NumberOfSeats; #Tekið úr verkefni 1
delimiter $$
create function NumberOfSeats(Aircraft_ID Char(6))
returns int
begin
	RETURN(SELECT COUNT(*) FROM aircraftseats WHERE aircraftID = Aircraft_ID);
end $$
delimiter ;

drop function if exists GetIDwFlightCode; #Tekið úr verkefni 1
delimiter $$
create function GetIDwFlightCode(daflightcode INT)
returns varchar(10)
begin
	RETURN(SELECT DISTINCT AircraftID FROM flights WHERE flightCode = daflightcode);
end $$
delimiter ;

drop function if exists flightcodewithdateandnumber; #tekið úr verkefni 1
DELIMITER $$
create function flightcodewithdateandnumber(flight_date date, flight_number char(5))
returns int(11)
BEGIN
	RETURN(SELECT flightcode FROM flights WHERE flights.flightDate = flight_date AND flights.flightNumber = flight_number);
END $$
DELIMITER ;

/*
SELECT NumberOfSeats("TF-LUS");
SELECT GetIDwFlightCode(3);
select flightcodewithdateandnumber(2015-3-03,TF-LUR)
*/

DROP PROCEDURE IF EXISTS addCabinCrew; #Skrá flugþjóna í flug
DELIMITER $$
#FLIGHT ATTENDANT ER 9
CREATE PROCEDURE addCabinCrew(flight_code int)
BEGIN
	declare x INT default 0;
    declare maxruns INT default 0;
    SET x = 1;
    SET maxruns = (SELECT NumberOfSeats((SELECT GetIDwFlightCode(flight_code)))) / 45; #1 þjónn fyrir 45 farðega samkvæmt verkefni
    
    WHILE x <= maxruns DO
		INSERT INTO flights_has_staff VALUES (DEFAULT, flight_code, (SELECT personID FROM staff WHERE jobsID = 9 ORDER BY RAND() LIMIT 1)); #velja flight attendant handahófi
		SET x = x + 1;
    END WHILE;
END $$
DELIMITER ;
      
DROP PROCEDURE IF EXISTS AddFlightGeneralStaff;
DELIMITER $$
CREATE PROCEDURE AddFlightGeneralStaff(flight_number CHAR(5), flight_date DATE, person_id VARCHAR(35))
BEGIN
INSERT INTO flights_has_staff(flights_has_staffID, flights_flightCode, staff_personID)
VALUES(DEFAULT, (SELECT(flightcodewithdateandnumber(flight_number, flight_date))), person_id);
END $$
DELIMITER ;

#-----------------------------TEST CODE------------------------------
call createStaff('NOR32423','Jorgen','Blorgen',CURDATE(),'AQ',1); #PERSONID, FIRSTNAME, LASTNAME, DATEOFBIRTH, COUNTRYCODE, JOBSID
call addFlightDeck(1,'IS1020313','DE4015928'); #FLIGHTCODE, CAPTAINPERSONID, FIRSTOFFICERPERSONID
call addCabinCrew(1); #FLIGHTCODE
#-----------------------------CREATE TABLES------------------------------
use 0604972069_FreshAir;

drop table if exists Jobs;
create table Jobs
(
    jobsID int not null auto_increment,
    jobsTitle varchar(75) not null,
    constraint jobsPK primary key(jobsID)
);

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

drop table if exists flights_has_staff;
create table flights_has_staff
(
	flights_has_staffID int not null auto_increment,
    flights_flightCode int not null,
    staff_personID varchar(35) not null,
    constraint flights_has_staffPK primary key(flights_has_staffID),
    constraint flights_has_staff_flightsFK foreign key(flights_flightCode) references flights(flightCode),
    constraint flights_has_staff_staffFK foreign key(staff_personID) references staff(personID)
);

DROP TABLE IF EXISTS aircraftSpecifications;
CREATE TABLE aircraftSpecifications
(
	aircraftSpecificationsID int not null auto_increment,
    manufacturer varchar(255),
    aircraftType varchar(255) not null,
    variant varchar(255),
    cockpitCrew tinyint,
    typicalSeating int,
    exitLimit int, #Maximum seating
    lengthOverall float, #meters
    wingspan float, #meters
    height float, #meters
    wheelbase float, #meters
    wheelTrack float, #meters, total
    fuselageWidth float, #meters
    fuselageHeight float, #meters
    maximumCabinWidth float, #meters, main deck
    cabinLength float, #meters, main deck
    wingArea int, #^2
    aspectRatio float,
    wingSweep varchar(4), #°
    maximumRampWeight float, #tons
    maximumTakeoffWeight float, #tons
    maximumLandingWeight float, #tons
    maximumZeroFuelWeight float, #tons
    operatingEmpyWeight float, #tons
    maximumStructuralPayload float, #tons
    maximumCargoVolume float, #^3
    maximumOperatingSpeed int, #km/hr
    maximumDesignSpeed int, #km/hr
    cruiseSpeed int, #km/hr
    takeOff int, #length of runway needed in meters
    landingSpeed int, #km/hr
    `range` int, #km
    serviceCeiling int, #m
    maximumFuelCapacity int, #liters
    engineCount int,
    turbopropenginespecificationsID int,
    turbojetenginespecificationsID int,
    constraint aircraftSpecificationsPK primary key(aircraftspecificationsID),
    constraint aircraftturbopropSpecificationsFK foreign key(turbopropengineSpecificationsID) references turbopropengineSpecifications(turbopropengineSpecificationsID),
    constraint aircraftturbojetSpecificationsFK foreign key(turbojetengineSpecificationsID) references turbojetengineSpecifications(turbojetengineSpecificationsID)
);

DROP TABLE IF EXISTS turbopropenginespecifications;
CREATE TABLE turbopropenginespecifications
(
	engineSpecificationsID int auto_increment,
    manufacturer varchar(255),
    model varchar(255),
    applications varchar(255),
    totalShaftHorsepower int,
    totalSpecificFuelConsumption float, #pounds/hr
    totalAirflow int, #pounds/sec
    overallPressureRatio float,
    numberOfSpools varchar(255),
    lowPressureCompressors varchar(255),
    highPressureCompressors varchar(255),
    highPressureTurbines int,
    intermediatePressureTurbines int,
    lowPressureTurbines int,
    length float, #inches
    width float, #inches
    dryweight int, #pounds
    constraint engineSpecificationsPK primary key(engineSpecificationsID)
);

DROP TABLE IF EXISTS turbojetenginespecifications;
CREATE TABLE turbojetenginespecifications
(
	engineSpecificationsID int auto_increment,
    
)

#-----------------------------MANUAL INSERTS------------------------------
INSERT INTO Jobs (jobsTitle) VALUES ('Chief Executive Officer'),
									('Chairman of the Board'),
                                    ('Director of Operations'),
                                    ('whoops'),
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
drop trigger if exists maincabinattendantinsertcheck;
delimiter $$
create trigger maincabinattendantinsertcheck
before insert on flights_has_staff
for each row
begin
	declare stopmessage varchar(255);
    if (new.mainCabinAttendant = 1 AND new.staff_personID != ANY(SELECT personID FROM staff WHERE jobsID = 9)) then
		set stopmessage = concat('Aðeins flugðþjónar geta verið aðalflugþjónar. Vinsamlegast reyndu aftur.');
        signal sqlstate '45000' set message_text = stopmessage;
	end if;
end $$
delimiter ;

drop trigger if exists maincabinattendantupdatecheck;
delimiter $$
create trigger maincabinattendantupdatecheck
before update on flights_has_staff
for each row
begin
	declare stopmessage varchar(255);
    if (new.mainCabinAttendant = 1 AND new.staff_personID != ANY(SELECT personID FROM staff WHERE jobsID = 9)) then
		set stopmessage = concat('Aðeins flugþjónar geta verið aðalflugþjónar. Vinsamlegast reyndu aftur.');
        signal sqlstate '45000' set message_text = stopmessage;
    end if;
end $$
delimiter ;

#-----------------------------PROCEDURES------------------------------
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

DROP PROCEDURE IF EXISTS createStaff; #Starfsmannaskráning
DELIMITER $$
CREATE PROCEDURE createStaff(person_ID varchar(35), first_Name varchar(75), last_Name varchar(75), date_Of_Birth datetime, countryOfResidence char(2), jobsID int)
BEGIN
	INSERT INTO Staff VALUES (person_ID,first_Name,last_Name,date_Of_Birth,countryOfResidence,jobsID);
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS createFlightCrew; #Áhafnaskráning
DELIMITER $$
CREATE PROCEDURE createFlightCrew(captain_ID varchar(35), firstofficer_ID varchar(35), flight_code int)
BEGIN
	call addFlightDeck(flight_code, captain_ID, firstofficer_ID);
    call addCabinCrew(flight_code);
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

DROP PROCEDURE IF EXISTS addCabinCrew; #Skrá flugþjóna í flug
DELIMITER $$
#FLIGHT ATTENDANT JOBID = 9
CREATE PROCEDURE addCabinCrew(flight_code int)
BEGIN
	declare x INT default 0;
    declare maxruns INT default 0;
    declare mainattendant INT default 0;
    declare attendant varchar(35) default '';
    SET x = 1;
    SET mainattendant = 1;
    SET maxruns = (SELECT NumberOfSeats((SELECT GetIDwFlightCode(flight_code)))) / 45; #1 þjónn fyrir 45 farðega samkvæmt verkefni
    
    WHILE x <= maxruns DO
		SELECT personID INTO attendant FROM staff WHERE jobsID = 9 AND personID != ALL(SELECT staff_personID FROM flights_has_staff WHERE flights_flightCode = flight_code) ORDER BY RAND() LIMIT 1; #workaround
		INSERT INTO flights_has_staff (flights_has_staffID, flights_flightCode, staff_personID, mainCabinAttendant) VALUES (DEFAULT, flight_code, attendant, mainattendant); #velja flight attendant handahófi
		SET x = x + 1;
        SET mainattendant = 0;
    END WHILE;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS UpdateCabinCrew; #Uppfæra flugþjón
DELIMITER $$
CREATE PROCEDURE UpdateCabinCrew(flight_code int, person_ID varchar(35))
BEGIN
	declare newattendant varchar(35) default '';
    SELECT personID INTO newattendant FROM staff WHERE jobsID = 9 AND personID != ALL(SELECT staff_personID FROM flights_has_staff WHERE flights_flightCode = flight_code) ORDER BY RAND() LIMIT 1;
	UPDATE flights_has_staff SET staff_personID = newattendant WHERE staff_personID = person_ID AND flights_flightCode = flight_code;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS CrewMemberHistory; #Skilar lista yfir öll flug viðkomandi starfsmanns.
DELIMITER $$
CREATE PROCEDURE CrewMemberHistory(person_ID varchar(35))
BEGIN
	SELECT flights.flightNumber as Flugnúmer, originatingAirport as Upphafsstað, destinationAirport as Áfangastað, jobsTitle AS Hlutverk FROM flights_has_staff 
		JOIN staff ON flights_has_staff.staff_personID = staff.personID
		JOIN jobs ON staff.jobsID = jobs.jobsID
		JOIN flights ON flights_has_staff.flights_flightCode = flights.flightcode
		JOIN flightschedules ON flights.flightNumber = flightschedules.flightNumber
		WHERE staff_personID = person_ID;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS AddFlightGeneralStaff; #skrá aðra sem koma að ákveðnu flugi
DELIMITER $$
CREATE PROCEDURE AddFlightGeneralStaff(flight_number CHAR(5), flight_date DATE, person_id VARCHAR(35))
BEGIN
	INSERT INTO flights_has_staff(flights_has_staffID, flights_flightCode, staff_personID)
	VALUES(DEFAULT, (SELECT(flightcodewithdateandnumber(flight_number, flight_date))), person_id);
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS createAircraft; #i have become DIE(); the destroyer of my keyboard
DELIMITER $$
CREATE PROCEDURE createAircraft(man varchar(255),
                                ait varchar(255),
                                var varchar(255),
                                coc tinyint,
                                tys int,
                                exl int,
                                leo float,
                                wis float,
                                hei float,
                                wbs float,
                                wtr float,
                                fuw float,
                                fuh float,
                                mcw float,
                                cl float,
                                wa int,
                                ar float,
                                ws varchar(4),
                                mrw float,
                                mtw float,
                                mlw float,
                                mfw float,
                                oew float,
                                msp float,
                                mcv float,
                                mos int,
                                mds int,
                                cs int,
                                tao int,
                                ls int,
                                rng int,
                                sc int,
                                mfc int,
                                ec int,
                                esi int,
                                tt int)
BEGIN
	INSERT INTO aircraftspecifications VALUES (DEFAULT, man, ait, var, coc, tys, exl, leo, wis, hei, wbs, wtr, fuw, fuh, mcw, cl, wa, ar, ws, mrw, mtw, mlw, mfw, oew, msp, mcv, mos, mds, cs, tao, ls, rng, sc, mfc, ec, esi, tt);
END $$
DELIMITER ;

#-----------------------------OTHER---------------------------------
UPDATE `0604972069_freshair`.`aircrafts` SET `aircraftType`='5' WHERE `aircraftID`='TF-NEI';
UPDATE `0604972069_freshair`.`aircrafts` SET `aircraftType`='6' WHERE `aircraftID`='TF-BUS';
UPDATE `0604972069_freshair`.`aircrafts` SET `aircraftType`='7' WHERE `aircraftID`='TF-CHM';
UPDATE `0604972069_freshair`.`aircrafts` SET `aircraftType`='7' WHERE `aircraftID`='TF-CNA';
UPDATE `0604972069_freshair`.`aircrafts` SET `aircraftType`='7' WHERE `aircraftID`='TF-GRT';
UPDATE `0604972069_freshair`.`aircrafts` SET `aircraftType`='7' WHERE `aircraftID`='TF-GSF';
UPDATE `0604972069_freshair`.`aircrafts` SET `aircraftType`='7' WHERE `aircraftID`='TF-LOK';
UPDATE `0604972069_freshair`.`aircrafts` SET `aircraftType`='7' WHERE `aircraftID`='TF-LUS';
UPDATE `0604972069_freshair`.`aircrafts` SET `aircraftType`='7' WHERE `aircraftID`='TF-PHY';
UPDATE `0604972069_freshair`.`aircrafts` SET `aircraftType`='7' WHERE `aircraftID`='TF-YES';
UPDATE `0604972069_freshair`.`aircrafts` SET `aircraftType`='1' WHERE `aircraftID`='TF-ASA';
UPDATE `0604972069_freshair`.`aircrafts` SET `aircraftType`='1' WHERE `aircraftID`='TF-TUR';
UPDATE `0604972069_freshair`.`aircrafts` SET `aircraftType`='2' WHERE `aircraftID`='TF-LUR';
UPDATE `0604972069_freshair`.`aircrafts` SET `aircraftType`='3' WHERE `aircraftID`='TF-ELP';
UPDATE `0604972069_freshair`.`aircrafts` SET `aircraftType`='4' WHERE `aircraftID`='TF-BRA';
UPDATE `0604972069_freshair`.`aircrafts` SET `aircraftType`='4' WHERE `aircraftID`='TF-HUX';
UPDATE `0604972069_freshair`.`aircrafts` SET `aircraftType`='4' WHERE `aircraftID`='TF-LIN';
UPDATE `0604972069_freshair`.`aircrafts` SET `aircraftType`='4' WHERE `aircraftID`='TF-MUR';
UPDATE `0604972069_freshair`.`aircrafts` SET `aircraftType`='4' WHERE `aircraftID`='TF-RUM';
UPDATE `0604972069_freshair`.`aircrafts` SET `aircraftType`='4' WHERE `aircraftID`='TF-WIN';
ALTER TABLE flights_has_staff ADD COLUMN mainCabinAttendant TINYINT(1) NOT NULL DEFAULT 0;   #main cabin attendant
ALTER TABLE flights_has_staff ADD UNIQUE distinctperson(flights_flightCode, staff_personID); #make sure we dont have some guy working double time
ALTER TABLE aircrafts CHANGE COLUMN aircraftType aircraftSpecificationsID int;
ALTER TABLE aircrafts DROP COLUMN maxNumberOfPassangers;

#-----------------------------TEST CODE------------------------------
call createStaff('NOR32423','Jorgen','Blorgen',CURDATE(),'AQ',1); #PERSONID, FIRSTNAME, LASTNAME, DATEOFBIRTH, COUNTRYCODE, JOBSID
call addFlightDeck(1,'IS1020313','DE4015928'); #FLIGHTCODE, CAPTAINPERSONID, FIRSTOFFICERPERSONID
call addCabinCrew(20); #FLIGHTCODE
call UpdateCabinCrew(1,'US3048812'); #FLIGHTCODE, PERSONID
call crewMemberHistory('IS3976809'); #PERSONID
call AddFlightGeneralStaff('FA501','2016-08-1','DE7438966'); #FLIGHTNUMBER, FLIGHTDATE, PERSONID
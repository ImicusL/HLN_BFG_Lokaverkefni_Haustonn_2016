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
    totalShaftHorsepower varchar(255),
    totalSpecificFuelConsumption varchar(255), #pounds/hr
    totalAirflow varchar(255), #pounds/sec
    overallPressureRatio varchar(255),
    numberOfSpools varchar(255),
    lowPressureCompressors varchar(255),
    highPressureCompressors varchar(255),
    highPressureTurbines varchar(255),
    intermediatePressureTurbines varchar(255),
    lowPressureTurbines varchar(255),
    length varchar(255), #inches
    width varchar(255), #inches
    dryweight varchar(255), #pounds
    constraint engineSpecificationsPK primary key(engineSpecificationsID)
);

DROP TABLE IF EXISTS turbojetenginespecifications;
CREATE TABLE turbojetenginespecifications
(
	engineSpecificationsID int auto_increment,
    manufacturer varchar(255),
    model varchar(255),
    applications varchar(255),
    drythrust varchar(255),
    wetthrust varchar(255),
    cruisethrust varchar(255),
    totalSpecificFuelConsumptiondry varchar(255),
    totalSpecificFuelConsumptionwet varchar(255),
    totalSpecificFuelConsumptioncruise varchar(255),
    totalAirflow varchar(255),
    overallPressureRatio varchar(255),
    FPR varchar(255),
    bypassRatio varchar(255),
    cruiseAltitude varchar(255),
    numberOfSpools varchar(255),
    fanStages varchar(255),
    lowPressureCompressors varchar(255),
    highPressureCompressors varchar(255),
    highPressureTurbines varchar(255),
    intermediatePressureTurbines varchar(255),
    lowPressureTurbines varchar(255),
    fanWidth varchar(255),
    length varchar(255),
    width varchar(255),
    dryweight varchar(255),
    constraint engineSpecificationsPK primary key(engineSpecificationsID)
);

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

#-----------------------------CSV INSERTS----------------------------
#all on one line to prevent accidental spaces during insert
SET @staffinfo = 'IS1967643:Sigurður:Hjaltason:1956-09-24:IS:1:NO3541093:Marius:Solberg:1959-06-15:NO:2:DE8711960:Alexander:Koch:1967-01-24:DE:16:NO3806792:Kim:Kristensen:1950-01-19:NO:9:SE9971296:Otto:Eriksson:1972-06-29:SE:17:DE4091170:Alexander:König:1972-07-12:DE:17:DE7438966:Heinrich:Werner:1985-11-25:DE:14:DE5970378:Ernst:König:1969-10-17:DE:14:US7599112:Eugene:Edwards:1954-08-03:US:14:NO9863005:Frode:Bakke:1965-09-28:NO:9:US6786294:Jeffrey:Harris:1940-10-11:US:19:SE1016265:Wilmer:Nilsson:1966-11-06:SE:17:US3048812:Larry:Howard:1987-08-13:US:9:SE8969706:Olle:Johansson:1975-08-23:SE:19:DE4335275:Thomas:Wolf:1980-06-23:DE:17:NO6916885:Svein:Nilsen:1967-10-01:NO:17:NO5151029:Lars:Johnsen:1974-03-27:NO:9:US1058105:Arthur:Garcia:1973-04-06:US:17:IS3297520:Rúnar:Jóhannsson:1977-02-19:IS:9:SE7263702:Viggo:Johansson:1968-02-21:SE:17:IS6070448:Reynir:Andrason:1976-06-02:IS:9:US1059020:John:Hill:1970-05-05:US:9:IS4195049:Axel:Geirsson:1983-06-28:IS:9:IS6943391:Guðmundur:Bergmannsson:1976-11-17:IS:14:IS1058167:Guðmundur:Brynjarson:1975-07-14:IS:19:DE9510293:Matthias:Richter:1982-03-13:DE:10:SE5921827:Adam:Andersson:1966-08-29:SE:14:SE8399384:Oscar:Johansson:1978-04-18:SE:19:DE9129813:Florian:Bergmann:1979-07-02:DE:23:IS9375808:Guðni:Tómasson:1965-08-05:IS:17:IS5623569:Kári:Haraldsson:1975-09-18:IS:17:IS7561298:Páll:Birgisson:1985-11-19:IS:11:IS3010789:Guðmundur:Pétursson:1971-01-07:IS:19:IS1582229:Róbert:Þórisson:1967-09-14:IS:9:IS2109280:Ólafur:Gunnarsson:1984-03-19:IS:9:IS5584466:Páll:Gunnlaugsson:1980-09-05:IS:11:IS4160916:Gunnar:Guðjónsson:1964-07-11:IS:9:IS1091517:Daði:Hafsteinsson:1986-01-09:IS:9:IS3227268:Magnús:Hafsteinsson:1973-08-23:IS:9:IS8734277:Tómas:Garðarsson:1969-08-20:IS:15:IS2619919:Elvar:Heiðarsson:1964-10-28:IS:19:IS9886282:Ómar:Garðarsson:1976-05-19:IS:19:IS1082027:Jón:Bergsson:1968-02-23:IS:16:IS5626040:Orri:Halldórsson:1975-11-20:IS:9:IS4775977:Skúli:Þorsteinsson:1973-03-25:IS:9:IS4027852:Sigurður:Ísaksson:1984-07-24:IS:8:IS1088564:Aron:Pétursson:1975-01-28:IS:9:IS6133268:Þórir:Ragnarsson:1979-10-10:IS:10:IS1490240:Jóhann:Darrason:1979-07-25:IS:8:IS5487187:Kári:Hilmarsson:1964-11-08:IS:9:SE7812512:Leia:Holmqvist:1972-10-16:SE:23:SE3669145:Iris:Karlsson:1974-11-07:SE:19:US7768136:Sandra:Wright:1964-06-28:US:11:IS7886955:Anna:Freysdóttir:1974-08-03:IS:9:IS1676650:Íris:Viktorsdóttir:1973-03-19:IS:9:IS4558453:Lind:Atladóttir:1986-04-11:IS:9:IS3695649:Sigrún:Leósdóttir:1981-11-01:IS:9:IS5158995:Guðrún:Traustadóttir:1973-09-02:IS:9:NO5898713:Aud:Johannessen:1971-06-20:NO:9:IS1040873:Þorbjörg:Arnarsdóttir:1974-04-01:IS:9:DE8510054:Ingrid:Albrecht:1970-07-01:DE:9:US5110585:Nancy:Jones:1963-11-09:US:9:NO1036932:Else:Hansen:1978-08-17:NO:19:SE6866923:Sigrid:Andersson:1964-03-13:SE:19:SE8668778:Nova:Isaksson:1963-10-21:SE:17:DE8855918:Cornelia:Möller:1986-02-21:DE:13:IS8978154:Guðrún:Eiríksdóttir:1983-09-17:IS:8:NO9645914:Kristin:Larsen:1967-03-01:NO:17:SE3350252:Alice:Persson:1987-09-28:SE:14:IS4508672:Marta:Ómarsdóttir:1977-02-16:IS:19:IS5517359:Kolbrún:Hjartardóttir:1975-10-30:IS:5:IS3976809:Halldóra:Egilsdóttir:1961-01-15:IS:9:IS6669362:Gunnhildur:Bragadóttir:1981-09-05:IS:9:IS5883868:Mist:Pálsdóttir:1985-03-21:IS:5:IS9084848:Guðrún:Friðriksdóttir:1985-06-02:IS:19:IS1057667:Hrafnhildur:Aradóttir:1964-10-26:IS:14:IS8025519:Alda:Jóhannsdóttir:1971-01-10:IS:10:IS5902062:Þóra:Sveinsdóttir:1983-08-01:IS:21:IS1020313:Halldóra:Þórisdóttir:1983-02-26:IS:17:IS4698257:Anna:Atladóttir:1983-05-20:IS:14:IS1090279:Ósk:Hauksdóttir:1962-06-16:IS:17:IS4338718:Guðrún:Fannarsdóttir:1965-06-02:IS:14:IS8722679:Kristjana:Brynjardóttir:1980-11-28:IS:21:IS9989055:Guðlaug:Guðjónsdóttir:1974-03-20:IS:12:IS6423585:Tinna:Sindradóttir:1976-11-13:IS:3:IS4287694:Erla:Júlíusdóttir:1968-02-21:IS:17:IS2782657:Hanna:Vignisdóttir:1967-03-02:IS:5:IS5835590:Jóhanna:Hafsteinsdóttir:1974-02-11:IS:6:SE5833049:Elvira:Hansson:1984-10-28:SE:9:DE7129159:Hedwig:Schumacher:1968-09-21:DE:9:NO8054184:Jorunn:Nilsen:1979-09-22:NO:9:IS4340997:Inga:Steinarsdóttir:1973-10-23:IS:11:US1041107:Melissa:White:1974-04-01:US:21:NO8395297:Emma:Kristoffersen:1987-01-12:NO:19:NO6555544:Stine:Strand:1985-08-28:NO:22:DE4015928:Rita:Walter:1961-10-19:DE:19:NO5300449:Ellen:Kristiansen:1961-10-16:NO:19:DE1635425:Iris:Peters:1976-02-07:DE:19:US4681485:Martha:Green:1966-02-04:US:16:US5468380:Christopher:Allen:1974-09-18:US:17:NO9407671:Ole:Aune:1971-11-02:NO:17:US6734805:Joshua:Smith:1976-01-05:US:17:DE9711240:Norbert:Wagner:1977-05-04:DE:17:US5501283:Mark:Smith:1966-09-13:US:18:US1030569:Timothy:Andersson:1981-06-22:CA:18:SE3260289:Love:Davis:1962-05-10:SE:20:IS1080685:Guðmundur:Arnórsson:1976-03-22:IS:8:SE1199800:Oscar:Karlsson:1964-07-18:SE:8:SE3327154:Erik:Nilsson:1981-03-21:SE:8:DE7166873:Robert:Wolf:1962-09-05:DE:8:SE6283026:Filip:Pettersson:1960-03-13:SE:19:SE6910133:Olle:Mattsson:1967-06-08:SE:19:SE6863731:Liam:Andersson:1971-11-03:SE:17:IS7485797:Darri:Valsson:1984-05-18:IS:19:DE1016276:Patrick:Hahn:1987-09-01:DE:19:';

DROP PROCEDURE IF EXISTS Initial_staff;
DELIMITER $$
CREATE PROCEDURE Initial_staff(texti text)
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

END $$
delimiter ;
CALL Initial_staff(@staffinfo);



SET @engineinfo = 'Allison;250-B15;Courier, Twin Stallion;317;;;;1 + FT;-;6 + 1C;2;-;2;;;;Allison;250-B15A;SM1019;317;;;;1 + FT;-;6 + 1C;2;-;2;;;;Allison;250-B15G;SM1019;317;;;;1 + FT;-;6 + 1C;2;-;2;;;;Allison;250-B17;Cessna 402/414, Nomad N-22;400;0,657;4;7,2;1 + FT;-;6 + 1C;2;-;2;;;;Allison;250-B17B;Cessna 402/414, Nomad N-22, SM1019E;400;0,657;4;7,2;1 + FT;-;6 + 1C;2;-;2;;;;Allison;250-B17C;Cessna 402/414, Nomad N-22/-24, BN-2T, P68TP, A36, GZ22, AT-35;420;0,657;4;7,2;1 + FT;-;6 + 1C;2;-;2;44,9;22,5;198;Allison;250-B17D;SF260TP, KM2D, HTT34, CT-4C;420;0,657;4;7,2;1 + FT;-;6 + 1C;2;-;2;44,9;22,5;202;Allison;250-B17E;Nomad N-22/-24;420;0,657;4;7,2;1 + FT;-;6 + 1C;2;-;2;44,9;22,5;202;Allison;250-B17F;AT-34, Grob 140TP;450;0,61;4;7,9;1 + FT;-;4 + 1C;2;-;2;44,9;22,5;212;Allison;250-B17F/1;BN-2T, Defender 4000;450;0,61;4;7,9;1 + FT;-;4 + 1C;2;-;2;;;;Allison;250-B17F/2;P-210, A36, Cessna 206H;450;0,61;4;7,9;1 + FT;-;4 + 1C;2;-;2;;;;Allison;250-C14;AB206A/C, A206B (not produced);370;;;;1 + FT;-;6 + 1C;2;-;2;;;;Allison;250-C18;Bell 206A, AB206A, MD500, MD500C;317;0,64;4;7,2;1 + FT;-;6 + 1C;2;-;2;;;;Allison;250-C18A;MD500, MD500C;317;0,64;4;7,2;1 + FT;-;6 + 1C;2;-;2;;;;Allison;250-C18B;Bell 206A, AB206A;317;0,64;4;7,2;1 + FT;-;6 + 1C;2;-;2;;;;Allison;250-C20;Bell 206B, MD500C, A109A, BO105C/CB, Fokker H5;400;0,65;4;7,2;1 + FT;-;6 + 1C;2;-;2;;;;Allison;250-C20B;Bell 47G, Bell 206B-1/B-3, AB206B, MD500D/E, A109A, BO105CBS/CBS-4/CBS-5, RH-1100, UH-12E, KA226;420;0,65;4;7,2;1 + FT;-;6 + 1C;2;-;2;38,8;23,2;161;Allison;250-C20F;AS355E/F1/F2;420;0,65;4;7,2;1 + FT;-;6 + 1C;2;-;2;38,8;23,2;161;Allison;250-C20F/2R;AS355F2R;450;;;;1 + FT;-;6 + 1C;2;-;2;38,8;23,2;161;Allison;250-C20J;Bell 206B-3/L;420;0,65;4;7,2;1 + FT;-;6 + 1C;2;-;2;38,8;23,2;161;Allison;250-C20R;Bell 206LT, Gemini ST, Bell 400/440 (not produced);450;0,608;;7,9;1 + FT;-;4 + 1C;2;-;2;38,8;23,2;173;Allison;250-C20R/1;A109A Mk.2, A109C/C Max, Gemini ST;450;0,608;;7,9;1 + FT;-;4 + 1C;2;-;2;38,8;23,2;173;Allison;250-C20R/2;Bell 260B-3/L, MD500D/ER, MD520N, KA-226A;450;0,608;;7,9;1 + FT;-;4 + 1C;2;-;2;38,8;23,2;173;Allison;250-C20R/3;BO108 (not produced/see EC135);450;0,608;;7,9;1 + FT;-;4 + 1C;2;-;2;38,8;23,2;173;Allison;250-C20R/4;Bell 206B-3/L;450;0,608;;7,9;1 + FT;-;4 + 1C;2;-;2;38,8;23,2;173;Allison;250-C20R/9;;450;0,608;;7,9;1 + FT;-;4 + 1C;2;-;2;38,8;23,2;173;Allison;250-C20S;Cessna 185, 206, 207 conversions;420;0,65;4;7,2;1 + FT;-;6 + 1C;2;-;2;;;;Allison;250-C20W;TH330, TH333, TH480A/B;420;0,65;4;7,2;1 + FT;-;6 + 1C;2;-;2;;;;Allison;250-C22;A109D;;;;;1 + FT;-;6 + 1C;2;-;2;;;;Allison;250-C28B;Bell 206L-1, AB206L;500;0,606;4;8,4;1 + FT;-;1C;2;-;2;47,3;25,1;230;Allison;250-C28C;BO105LS/LS-A1/LS-A3;500;0,606;4;8,4;1 + FT;-;1C;2;-;2;47,3;25,1;230;Allison;250-C30;MD530, FT600, S-76A;650;0,592;6;8,4;1 + FT;-;1C;2;-;2;41;25,1;240;Allison;250-C30C;;650;0,592;6;8,4;1 + FT;-;1C;2;-;2;;;;Allison;250-C30G;Bell 222;650;0,592;6;8,6;1 + FT;-;1C;2;-;2;43,2;25,5;258;Allison;250-C30G/2;Bell 230;650;0,592;6;8,6;1 + FT;-;1C;2;-;2;43,2;25,5;258;Allison;250-C30L;(see military turboshaft specifications);;;;;;;;;;;;;;Allison;250-C30M;AS350D;650;0,592;6;8,6;1 + FT;-;1C;2;-;2;43,2;25,5;258;Allison;250-C30P;Bell 206L-3/L-4;650;0,592;6;8,6;1 + FT;-;1C;2;-;2;43,2;25,5;258;Allison;250-C30R;(see military turboshaft specifications);;;;;;;;;;;;;;Allison;250-C30R/1;(see military turboshaft specifications);;;;;;;;;;;;;;Allison;250-C30R/2;(see military turboshaft specifications);;;;;;;;;;;;;;Allison;250-C30R/3;(see military turboshaft specifications);;;;;;;;;;;;;;Allison;250-C30R/3M;(see military turboshaft specifications);;;;;;;;;;;;;;Allison;250-C30S;S-76A-2;650;0,592;6;8,6;1 + FT;-;1C;2;-;2;43,2;25,5;258;Allison;250-C30U;(see military turboshaft specifications);;;;;;;;;;;;;;Allison;250-C40B;Bell 430;715;0,57;;9,2;1 + FT;-;1C;2;-;2;41;25,1;280;Allison (Rolls-Royce);250-C47B;Bell 407;650;0,58;6;9,2;1 + FT;-;1C;2;-;2;41;25,1;274;Allison (Rolls-Royce);250-C47M;MD600N;650;0,58;6;9,2;1 + FT;-;1C;2;-;2;41;25,1;274;Allison;501-D13;L-188A/C Electra;3.750;;;;1;-;14;4;-;-;;;;Allison;501-D13A;L-188A/C Electra;3.750;;;;1;-;14;4;-;-;;;;Allison;501-D13D;Convair CV-580;3.460;;;;1;-;14;4;-;-;;;;Allison;501-D13H;Convair CV-580;;;;;1;-;14;4;-;-;;;;Allison;501-D15;L-188A/C Electra;4.050;;;;1;-;14;4;-;-;;;;Allison;501-D22;Lockheed L-382;3.755;;;;1;-;14;4;-;-;146;44,6;;Allison;501-D22A;Lockheed L-100-20/-30;4.590;0,52;33;9,6;1;-;14;4;-;-;146;44,6;1.834;Allison;501-D22C;B-377GT Guppy 201;4.368;0,52;33;9,6;1;-;14;4;-;-;146;44,6;;Allison;501-D22G;Convair CV-5800;4.368;0,52;33;9,6;1;-;14;4;-;-;146;44,6;;Allison (Rolls-Royce);AE 2100A;Saab 2000;4.152;0,46;;17;1 + FT;-;14;2;-;2;118;28,7;1.641;Allison (Rolls-Royce);AE 2100C;N-250-50/-100 (not produced);;;;;1 + FT;-;14;2;-;2;;;;Avco Lycoming;AL5512;Boeing 234ER/LR/UT, Boeing 360 (not produced);4.200;0,52;;8,2;2;-;7 + 1C;2;-;2;;;;Avco Lycoming;LTC 4B-8D;Bell 214A;2.250;0,63;;6;1 + FT;-;7 + 1C;2;-;2;44;24;605;Avco Lycoming;LTC 4B-12;;4.600;0,52;27;8,5;1 + FT;-;7 + 1C;2;-;2;;;;Avco Lycoming;LTC 4R-1;;3.750;0,55;25;8;1 + FT;-;7 + 1C;2;-;2;;;;Avco Lycoming;LTC 4R-3;;4.526;0,52;27;8;1 + FT;-;7 + 1C;2;-;2;;;;Avco Lycoming;LTC 4V-1;;5.000;0,41;26;;2 + FT;-;8;2;-;2;;;;Avco Lycoming;LTP 101-600A-1A;Cessna/Riley 421, Turbo Thrush, Ag-Cat, AT-302/-302A, Do 28D-5X;615;0,544;;8,5;1 + FT;-;1 + 1C;1;-;1;37,4;21;325;Avco Lycoming;LTP 101-700A-1A;Cessna/Riley 421, Turbo Thrush, Ag-Cat, Piaggio P166;700;0,544;;8,6;1 + FT;-;1 + 1C;1;-;1;37,4;21;335;Avco Lycoming;LTS 101-600A-2;AS350C/D/D1;615;0,571;5;8,5;1 + FT;-;1 + 1C;1;-;1;30,9;22,4;253;Avco Lycoming;LTS 101-600A-3;AS350C/D/D1;615;0,582;;8,4;1 + FT;-;1 + 1C;1;-;1;31,5;22,4;265;Avco Lycoming;LTS 101-600A-3A;AS350C/D/D1;650;;;;1 + FT;-;1 + 1C;1;-;1;31,5;22,4;;Avco Lycoming;LTS 101-650B-1;BK117A1/A3/A4;650;0,577;;8,4;1 + FT;-;1 + 1C;1;-;1;31,1;25,4;273;Avco Lycoming;LTS 101-650C-2;Bell 222;675;0,572;;;1 + FT;-;1 + 1C;1;-;1;31,3;22,6;241;Avco Lycoming;LTS 101-650C-3;Bell 222;675;0,572;;8,4;1 + FT;-;1 + 1C;1;-;1;31,3;22,6;241;Avco Lycoming;LTS 101-650C-3A;Bell 222;675;0,572;;8,4;1 + FT;-;1 + 1C;1;-;1;31,3;22,6;241;Avco Lycoming;LTS 101-700D-2;AS350SuperB2;;;;;1 + FT;-;1 + 1C;1;-;1;;;;Avco Lycoming;LTS 101-750B-1;BK117B/B1/B2;727;0,577;;8,4;1 + FT;-;1 + 1C;1;-;1;31,3;25,4;271;Avco Lycoming;LTS 101-750B-2;AS366;742;0,57;;8,8;1 + FT;-;1 + 1C;1;-;1;32,4;24,7;268;Avco Lycoming;LTS 101-750C-1;Bell 222B/UT;735;0,577;;8,8;1 + FT;-;1 + 1C;1;-;1;31,3;22,6;244;Avco Lycoming;T5311A;Bell 204B, AB204A;1.100;0,68;11;6,1;1 + FT;-;5 + 1C;1;-;2;47,6;23;496;Avco Lycoming;T5313A;Bell 205A, AB205A-1;1.400;0,58;13;7,4;1 + FT;-;5 + 1C;2;-;2;47,6;23;;Avco Lycoming;T5313B;Bell 204B-2, Bell 205A1;1.400;0,58;13;7,4;1 + FT;-;5 + 1C;2;-;2;47,6;23;544;Avco Lycoming;T5317A;Bell 205A1, Kaman K-Max;1.500;0,59;12;8;1 + FT;-;5 + 1C;2;-;2;47,6;23;564;Avco Lycoming;T5319A;;1.800;0,59;12;8;1 + FT;-;5 + 1C;2;-;2;;;;Avco Lycoming;T5321A;;1.800;0,59;12;8;1 + FT;-;5 + 1C;2;-;2;;;;Avco Lycoming;T5508D;Bell 214B/B-1/C;2.930;0,592;;;1 + FT;-;7 + 1C;2;-;2;44;24;605;Avco Lycoming (Textron Lycoming);T55-L-714A;Boeing 414-100 Super D;4.867;0,5;;9,3;1 + FT;-;7 + 1C;2;-;2;48,5;28,7;832;Baranov (OMSK);TVD-20-03;An-38-200, T-101V;1.380;0,506;;;1 + FT;-;7 + 1C;2;-;2;69,7;33,5;628;Bristol;Proteus 625;Britannia 101 prototypes;2.660;;;;;;;;;;;;;Bristol;Proteus 705;Britannia 101/102;3.600;;;;;;;;;;;;;Bristol;Proteus 755;Britannia 301/302/306/307/307F/308/308F/309, 200 (not produced);3.925;;;;;;;;;;;;;Bristol;Proteus 765;Britannia 311/312/312F/313/314/317/318/324;4.440;;;;;;;;;;;;;de Havilland;Gnome H.1000 Mk.501;Whirlwind 3, Bell 204B;;;;;1 + FT;-;10;2;-;1;;;;de Havilland (Bristol Siddeley);Gnome H.1200 Mk.610;Bell 203, AZ-101G (not produced);1.350;0,62;12;8,1;1 + FT;-;10;2;-;1;;;;de Havilland (Bristol Siddeley);Gnome H.1200 Mk.640;Vertol 107-2;;;;;1 + FT;-;10;2;-;1;;;;Garrett;TPE331-1-100F;Porter;705;0,571;;;1;-;2C;3;-;-;43;26;336;Garrett;TPE331-1-101;Interceptor 400, PC-6/C1 Turbo-Porter;705;0,571;;;1;-;2C;3;-;-;43;26;336;Garrett;TPE331-1-101B;Turbo 18 (Turboliner);705;0,571;;;1;-;2C;3;-;-;43;26;336;Garrett;TPE331-1-101E;Jetliner 600;705;0,571;;;1;-;2C;3;-;-;43;26;336;Garrett;TPE331-1-101F;PC-6/C2-H2 Turbo-Porter, Peacemaker;705;0,571;;;1;-;2C;3;-;-;43;26;336;Garrett;TPE331-1-101Z;S2R Turbo Thrush;705;0,571;;;1;-;2C;3;-;-;43;26;336;Garrett;TPE331-1-151A;MU-2DP/F/G;705;0,571;;8,3;1;-;2C;3;-;-;43;26;336;Garrett;TPE331-1-151G;Merlin IIB;705;0,571;;8,3;1;-;2C;3;-;-;43;26;336;Garrett;TPE331-1-151K;Turbo Commander;705;0,571;;8,3;1;-;2C;3;-;-;43;26;336;Garrett;TPE331-1-151Z;G164B;705;0,571;;8,3;1;-;2C;3;-;-;43;26;336;Garrett;TPE331-1U;;705;;;;1;-;2C;3;-;-;43;26;336;Garrett;TPE331-1UA;;705;;;;1;-;2C;3;-;-;43;26;336;Garrett;TPE331-2-201C;C-212;715;0,556;;8,3;1;-;2C;3;-;-;43;26;336;Garrett;TPE331-2-251A;Skyvan III;715;0,556;;8,3;1;-;2C;3;-;-;43;26;336;Garrett;TPE331-2U-201A;;;;;;1;-;2C;3;-;-;43;26;336;Garrett;TPE331-2UA-203D;Goose;755;;;;1;-;2C;3;-;-;43;26;336;Garrett;TPE331-3-301;;840;0,548;;10,3;1;-;2C;3;-;-;43;26;355;Garrett;TPE331-3-303;;840;0,548;;10,3;1;-;2C;3;-;-;43;26;355;Garrett;TPE331-3A-301W;Jetstream 3M (not produced);840;0,548;;10,3;1;-;2C;3;-;-;43;26;355;Garrett;TPE331-3U-303G;Merlin III/IIIA/IV/IVA, Metro;904;0,548;;10,3;1;-;2C;3;-;-;43;26;355;Garrett;TPE331-3U-303N;S55T;904;0,548;;10,3;1;-;2C;3;-;-;43;26;355;Garrett;TPE331-3U-303V;Jetstream 3;904;0,548;;10,3;1;-;2C;3;-;-;43;26;355;Garrett;TPE331-3U-304G;Merlin III/IIIA/IV/IVA, Metro I/II/IIA;904;0,548;;10,3;1;-;2C;3;-;-;43;26;355;Garrett;TPE331-3UW-304G;Metro II/IIA;904;0,548;;10,3;1;-;2C;3;-;-;43;26;355;Garrett;TPE331-3W-301A;;904;;;;1;-;2C;3;-;-;43;26;355;Garrett;TPE331-3W-304G;;904;;;;1;-;2C;3;-;-;43;26;355;Garrett;TPE331-5-251C;C-211-100;840;0,577;;10,3;1;-;2C;3;-;-;43;26;355;Garrett;TPE331-5-251K;Turbo Commander 690/690A/680B;840;0,577;;10,3;1;-;2C;3;-;-;43;26;355;Garrett;TPE331-5-252C;C-212-100;840;0,577;;10,3;1;-;2C;3;-;-;43;26;355;Garrett;TPE331-5-252D;Do 228-101/-201/-202/-202K;840;0,577;;10,3;1;-;2C;3;-;-;43;26;355;Garrett;TPE331-5-252K;Turbo Commander 690A/690B;840;0,577;;10,3;1;-;2C;3;-;-;43;26;355;Garrett;TPE331-5-252M;MU-2N/P;840;0,577;;10,3;1;-;2C;3;-;-;43;26;355;Garrett;TPE331-5-254K;Jetprop Commander 690C/690D;840;0,577;;10,3;1;-;2C;3;-;-;43;26;355;Garrett;TPE331-5-255K;Turbo Commander 690/690A/690B, Jetprop Commander 690C/690D;840;0,577;;10,3;1;-;2C;3;-;-;43;26;355;Garrett;TPE331-5A-252D;Do 228-212;834;;;;1;-;2C;3;-;-;43;26;355;Garrett;TPE331-5AB-252D;Do 228-212;834;;;;1;-;2C;3;-;-;43;26;355;Garrett;TPE331-5B-252D;Do 228-212;834;;;;1;-;2C;3;-;-;43;26;355;Garrett;TPE331-6-251M;MU-2J/K/L/M;808;0,577;;10,3;1;-;2C;3;-;-;43;26;355;Garrett;TPE331-6-252B;King Air B100;808;0,577;;10,3;1;-;2C;3;-;-;43;26;355;Garrett;TPE331-6-252L;Merlin IIB;808;0,577;;10,3;1;-;2C;3;-;-;43;26;355;Garrett;TPE331-6-252M;MU-2J/K/L/M, FU24-950/954, FU24A-950/954;808;0,577;;10,3;1;-;2C;3;-;-;43;26;355;Garrett;TPE331-6-252T;Skyvan;808;0,577;;10,3;1;-;2C;3;-;-;43;26;355;Garrett;TPE331-6-253B;King Air B100;808;0,577;;10,3;1;-;2C;3;-;-;43;26;355;Garrett;TPE331-6A-251M;MU-2J/K/L/M;808;0,577;;10,3;1;-;2C;3;-;-;43;26;355;Garrett;TPE331-6A-252M;MU-2J/K/L/M;808;0,577;;10,3;1;-;2C;3;-;-;43;26;355;Garrett;TPE331-8-401S;Conquest II;;0,568;;10,3;1;-;2C;3;-;-;43;26;370;Garrett;TPE331-8-402S;Conquest II;;0,568;;10,3;1;-;2C;3;-;-;43;26;370;Garrett;TPE331-8-422S;Conquest II;;0,568;;10,3;1;-;2C;3;-;-;43;26;370;Garrett;TPE331-9-???S;Conquest II;;0,568;;10,3;1;-;2C;3;-;-;43;26;370;Garrett;TPE331-10-501C;C-212-200;;0,55;;10,8;1;-;2C;3;-;-;46;26;380;Garrett;TPE331-10-501K;Commander 980;;0,55;;10,8;1;-;2C;3;-;-;46;26;380;Garrett;TPE331-10-501M;MU-2J/K/L/M;;0,55;;10,8;1;-;2C;3;-;-;46;26;380;Garrett;TPE331-10-501C;C-212-200;;0,55;;10,8;1;-;2C;3;-;-;46;26;380;Garrett;TPE331-10-511K;Commander 1000;;0,55;;10,8;1;-;2C;3;-;-;46;26;380;Garrett;TPE331-10-511M;MU-2J/K/L/M;;0,55;;10,8;1;-;2C;3;-;-;46;26;380;Garrett;TPE331-10A;;984;0,55;;10,8;1;-;2C;3;-;-;46;26;380;Garrett;TPE331-10AV-511B;King Air B100;984;0,55;;10,8;1;-;2C;3;-;-;46;26;380;Garrett;TPE331-10AV-511KA;Kilo Alpha 290;984;0,55;;10,8;1;-;2C;3;-;-;46;26;380;Garrett;TPE331-10AV-511M;MU-2J/K/L/M, FU24-950/954, FU24A-950/954;984;0,55;;10,8;1;-;2C;3;-;-;46;26;380;Garrett;TPE331-10G-511D;Do 228-???;984;0,55;;10,8;1;-;2C;3;-;-;46;26;380;Garrett;TPE331-10GP-511D;Do 228-???;984;0,55;;10,8;1;-;2C;3;-;-;46;26;380;Garrett;TPE331-10GT-511D;Do 228-???;984;0,55;;10,8;1;-;2C;3;-;-;46;26;380;Garrett;TPE331-10N-511S;Conquest II;984;0,55;;10,8;1;-;2C;3;-;-;46;26;380;Garrett;TPE331-10N-512S;;984;0,55;;10,8;1;-;2C;3;-;-;46;26;380;Garrett;TPE331-10N-513S;;984;0,55;;10,8;1;-;2C;3;-;-;46;26;380;Garrett;TPE331-10N-514S;;984;0,55;;10,8;1;-;2C;3;-;-;46;26;380;Garrett;TPE331-10N-515S;;984;0,55;;10,8;1;-;2C;3;-;-;46;26;380;Garrett;TPE331-10N-531S;Conquest II;984;0,55;;10,8;1;-;2C;3;-;-;46;26;380;Garrett;TPE331-10N-532S;;984;0,55;;10,8;1;-;2C;3;-;-;46;26;380;Garrett;TPE331-10N-533S;;984;0,55;;10,8;1;-;2C;3;-;-;46;26;380;Garrett;TPE331-10N-534S;;984;0,55;;10,8;1;-;2C;3;-;-;46;26;380;Garrett;TPE331-10N-535S;;984;0,55;;10,8;1;-;2C;3;-;-;46;26;380;Garrett;TPE331-10P-511D;Do 228-???;984;0,55;;10,8;1;-;2C;3;-;-;46;26;380;Garrett;TPE331-10R-501C;;984;0,55;;10,8;1;-;2C;3;-;-;46;26;380;Garrett;TPE331-10R-502C;;984;0,55;;10,8;1;-;2C;3;-;-;46;26;380;Garrett;TPE331-10R-511C;C-212-200;984;0,55;;10,8;1;-;2C;3;-;-;46;26;380;Garrett;TPE331-10R-512C;C-212-200;984;0,55;;10,8;1;-;2C;3;-;-;46;26;380;Garrett;TPE331-10R-513C;C-212-300;984;0,55;;10,8;1;-;2C;3;-;-;46;26;380;Garrett;TPE331-10T-511D;Do 228-202K;984;0,55;;10,8;1;-;2C;3;-;-;46;26;380;Garrett;TPE331-10T-511K;Turbo Commander 690A/690B, Commander 840/900;984;0,55;;10,8;1;-;2C;3;-;-;46;26;380;Garrett;TPE331-10T-511M;MU-2N/P;984;0,55;;10,8;1;-;2C;3;-;-;46;26;380;Garrett;TPE331-10T-512K;;984;0,55;;10,8;1;-;2C;3;-;-;46;26;380;Garrett;TPE331-10T-513K;;984;0,55;;10,8;1;-;2C;3;-;-;46;26;380;Garrett;TPE331-10T-515K;;984;0,55;;10,8;1;-;2C;3;-;-;46;26;380;Garrett;TPE331-10T-516K;Turbo Commander 690A/690B, Commander 840/900;984;0,55;;10,8;1;-;2C;3;-;-;46;26;380;Garrett;TPE331-10T-517K;;984;0,55;;10,8;1;-;2C;3;-;-;46;26;380;Garrett;TPE331-10U-501G;Merlin IIIB;984;0,55;;10,8;1;-;2C;3;-;-;46;26;380;Garrett;TPE331-10U-502G;;984;0,55;;10,8;1;-;2C;3;-;-;46;26;380;Garrett;TPE331-10U-503G;Merlin 300 (IIIC);984;0,55;;10,8;1;-;2C;3;-;-;46;26;380;Garrett;TPE331-10U-511G;Merlin IIIB;984;0,55;;10,8;1;-;2C;3;-;-;46;26;380;Garrett;TPE331-10U-512G;;984;0,55;;10,8;1;-;2C;3;-;-;46;26;380;Garrett;TPE331-10U-513G;Merlin 300 (IIIC);984;0,55;;10,8;1;-;2C;3;-;-;46;26;380;Garrett;TPE331-10UA-511G;Metro II/IIA;984;0,55;;10,8;1;-;2C;3;-;-;46;26;380;Garrett;TPE331-10UA-511G;Metro II/IIA;984;0,55;;10,8;1;-;2C;3;-;-;46;26;380;Garrett;TPE331-10UF-501H;;984;0,55;;10,8;1;-;2C;3;-;-;46;26;380;Garrett;TPE331-10UF-511H;Jetstream 3108;984;0,55;;10,8;1;-;2C;3;-;-;46;26;380;Garrett;TPE331-10UF-512H;;984;0,55;;10,8;1;-;2C;3;-;-;46;26;380;Garrett;TPE331-10UF-513H;Jetstream 3101/3103/3107;984;0,55;;10,8;1;-;2C;3;-;-;46;26;380;Garrett;TPE331-10UF-514H;;984;0,55;;10,8;1;-;2C;3;-;-;46;26;380;Garrett;TPE331-10UF-515H;Jetstream 3101;984;0,55;;10,8;1;-;2C;3;-;-;46;26;380;Garrett;TPE331-10UF-516H;;984;0,55;;10,8;1;-;2C;3;-;-;46;26;380;Garrett;TPE331-10UG-513H;Jetstream 3101/3102/3108;984;0,55;;10,8;1;-;2C;3;-;-;46;26;380;Garrett;TPE331-10UG-514H;Jetstream 3101/3102;984;0,55;;10,8;1;-;2C;3;-;-;46;26;380;Garrett;TPE331-10UG-515H;;984;0,55;;10,8;1;-;2C;3;-;-;46;26;380;Garrett;TPE331-10UG-516H;;984;0,55;;10,8;1;-;2C;3;-;-;46;26;380;Garrett;TPE331-10UGR-513H;Jetstream 3101/3102;984;0,55;;10,8;1;-;2C;3;-;-;46;26;380;Garrett;TPE331-10UGR-514H;Jetstream 3101/3102/3109;984;0,55;;10,8;1;-;2C;3;-;-;46;26;380;Garrett;TPE331-10UGR-515H;Jetstream 3112;984;0,55;;10,8;1;-;2C;3;-;-;46;26;380;Garrett;TPE331-10UGR-516H;Jetstream 3112;984;0,55;;10,8;1;-;2C;3;-;-;46;26;380;Garrett;TPE331-10UK;;1.045;0,55;;10,8;1;-;2C;3;-;-;46;26;380;Garrett;TPE331-10UR-513H;Jetstream 3101/3102/3103/3112;984;0,55;;10,8;1;-;2C;3;-;-;46;26;380;Garrett;TPE331-11-601W;(see military turboshaft specifications);;;;;;;;;;;;;;Garrett;TPE331-11U-601G;Metro III, Metro 23-11;1.000;0,53;;10,8;1;-;2C;3;-;-;46;26;400;Garrett;TPE331-11U-602G;;1.000;0,53;;10,8;1;-;2C;3;-;-;46;26;400;Garrett;TPE331-11U-611G;Metro III, Metro 23-11;1.000;0,53;;10,8;1;-;2C;3;-;-;46;26;400;Garrett;TPE331-11U-612G;Metro III, Metro 23-11;1.000;0,53;;10,8;1;-;2C;3;-;-;46;26;400;Garrett;TPE331-12;;1.151;0,522;;10,8;1;-;2C;3;-;-;46;26;400;Garrett;TPE331-12B;(see military turboshaft specifications);;;;;;;;;;;;;;Garrett;TPE331-12JR-701C;C-212-400;1.151;0,522;;10,8;1;-;2C;3;-;-;46;26;400;Garrett;TPE331-12JR-701S;Caravan;1.151;0,522;;10,8;1;-;2C;3;-;-;46;26;400;Garrett;TPE331-12U-701G;Metro 23-12, Merlin 5/6 (not produced);1.151;0,522;;10,8;1;-;2C;3;-;-;46;26;400;Garrett;TPE331-12UA-701G;Metro 23-12;1.151;0,522;;10,8;1;-;2C;3;-;-;46;26;400;Garrett;TPE331-12UA-701H;Jetstream 3201/3201EP/3206;1.151;0,522;;10,8;1;-;2C;3;-;-;46;26;400;Garrett;TPE331-12UAR-701G;Metro V, Metro 23-12;1.151;0,522;;10,8;1;-;2C;3;-;-;46;26;400;Garrett;TPE331-12UH-701G;Metro 23-12;1.151;0,522;;10,8;1;-;2C;3;-;-;46;26;400;Garrett;TPE331-12UHR-701G;Metro 23-12;1.151;0,522;;10,8;1;-;2C;3;-;-;46;26;400;Garrett;TPE331-12UHR-701H;Jetstream 3201/3217;1.151;0,522;;10,8;1;-;2C;3;-;-;46;26;400;Garrett (Allied-Signal);TPE331-14;Merlin 6 (not produced);;;;;1;-;2C;3;-;-;53;32;620;Garrett (Allied-Signal);TPE331-14A;Cheyenne 400;;0,515;;11;1;-;2C;3;-;-;53;32;620;Garrett (Allied-Signal);TPE331-14A-801Z;Turbo Tracker;;0,515;;11;1;-;2C;3;-;-;53;32;620;Garrett (Allied-Signal);TPE331-14B;Cheyenne 400;1.312;0,515;;11;1;-;2C;3;-;-;53;32;620;Garrett (Allied-Signal);TPE331-14F-801L;G520, G520T;;0,515;;11;1;-;2C;3;-;-;53;32;620;Garrett (Allied-Signal);TPE331-14G;;;0,51;;11,4;1;-;2C;3;-;-;53;36;620;Garrett (Allied-Signal);TPE331-14GR-801E;An-38-100;;0,51;;11,4;1;-;2C;3;-;-;53;36;620;Garrett (Allied-Signal);TPE331-14GR-801H;Jetstream 4102;1.723;0,51;;11,4;1;-;2C;3;-;-;53;32;620;Garrett (Allied-Signal);TPE331-14GR-802H;;1.723;0,51;;11,4;1;-;2C;3;-;-;53;32;620;Garrett (Allied-Signal);TPE331-14GR-805H;Jetstream 4101;1.723;0,51;;11,4;1;-;2C;3;-;-;53;32;620;Garrett (Allied-Signal);TPE331-14H;;;0,51;;11,4;1;-;2C;3;-;-;53;36;620;Garrett (Allied-Signal);TPE331-14HR-801E;An-38-100;;0,51;;11,4;1;-;2C;3;-;-;53;36;620;Garrett (Allied-Signal);TPE331-14HR-801H;Jetstream 4102;1.723;0,51;;11,4;1;-;2C;3;-;-;53;32;620;Garrett (Allied-Signal);TPE331-14HR-802H;;1.723;0,51;;11,4;1;-;2C;3;-;-;53;32;620;Garrett (Allied-Signal);TPE331-14HR-805H;Jetstream 4101;1.723;0,51;;11,4;1;-;2C;3;-;-;53;32;620;Garrett (Allied-Signal);TPE331-14UA-801G;Fairchild 400 (not produced);;0,51;;11,4;1;-;2C;3;-;-;53;36;620;Garrett (Allied-Signal);TPE331-14UB-801G;Fairchild 400 (not produced);;0,51;;11,4;1;-;2C;3;-;-;53;36;620;Garrett (Allied-Signal);TPE331-15A;(see military turboshaft specifications);;;;;;;;;;;;;;Garrett;TPE331-25D;PC-6/C Turbo-Porter;575;0,665;;8,2;1;-;2C;3;-;-;46;26;335;Garrett;TPE331-25/61;MU-2A/2E1/25D, Heliporter 43, Hawk Commander 47, Volpar Super Turbo 18;575;0,665;;8,2;1;-;2C;3;-;-;46;26;335;Garrett;TPE331-29;;575;;;;1;-;2C;3;-;-;;;;Garrett;TPE331-43;Turbo Commander 680T;575;;;;1;-;2C;3;-;-;;;;Garrett;TPE331-43A;;575;;;;1;-;2C;3;-;-;;;;Garrett;TPE331-45;;575;;;;1;-;2C;3;-;-;;;;Garrett;TPE331-47;;575;;;;1;-;2C;3;-;-;;;;Garrett;TPE331-49;;575;;;;1;-;2C;3;-;-;;;;Garrett;TPE331-51;;575;;;;1;-;2C;3;-;-;;;;Garrett;TPE331-55;;575;;;;1;-;2C;3;-;-;;;;Garrett;TPF351-20;CBA-123 prototype;1.300;;;;;;;;;;;;;Garrett;TSE231-P2400;Gates Twinjet;474;0,6;4;8,6;;;;;;;;;;Garrett;TSE331-3U-303N;S-55QT;800;0,6;8;10,3;;;;;;;;;;Garrett;TSE331-10UA-511SW;S-55QT;1.040;;;;;;;;;;;;;Garrett;TSE36-1;T-28A (not produced);240;0,83;3;4,3;;;;;;;;;;GE;CT7-2A;Bell 214ST, EH101 prototypes;1.625;0,473;;;1 + FT;-;5 + 1C;2;-;2;47;26;442;GE;CT7-2B;Westland 30 Series 200;1.712;;;;1 + FT;-;5 + 1C;2;-;2;;;;GE;CT7-2D;S-70;1.625;0,473;;;1 + FT;-;5 + 1C;2;-;2;47;26;442;GE;CT7-2D1;S-70;1.625;0,473;;;1 + FT;-;5 + 1C;2;-;2;47;26;466;GE;CT7-5A;Saab 340;1.735;;;;1 + FT;-;5 + 1C;2;-;2;96;29;783;GE;CT7-5A2;;;;;;1 + FT;-;5 + 1C;2;-;2;96;29;783;GE;CT7-6;EH101 Mk.300/Mk.500;2.000;0,47;;;1 + FT;-;5 + 1C;2;-;2;48,2;26;493;GE;CT7-6A;;2.000;;;;1 + FT;-;5 + 1C;2;-;2;48,2;26;493;GE;CT7-7A;CN-235;1.700;0,474;;14;1 + FT;-;5 + 1C;2;-;2;96;29;783;GE;CT7-8;CL-160;2.520;;;;1 + FT;-;5 + 1C;2;-;2;;;;GE;CT7-8A;S-92;2.740;;;;1 + FT;-;5 + 1C;2;-;2;48,8;;537;GE;CT7-9B;CN-235, Saab 340B, S-80;1.750;;;;1 + FT;-;5 + 1C;2;-;2;96;29;805;GE;CT7-9C;CN-235, Saab 340B;1.750;;;;1 + FT;-;5 + 1C;2;-;2;96;29;805;GE;CT7-9D;L-610G (not produced);1.750;;;;1 + FT;-;5 + 1C;2;-;2;96;29;805;GE;CT58-GE-110-1;S-62B/C, HH-52A, V107/II;1.400;0,62;14;8,4;2;-;10;2;-;2;20,7;63,3;440;GE;CT58-GE-110-2;;1.400;;;;2;-;10;2;-;2;20,7;63,3;440;IHI;CT58-IHI-110-1;KV107/II-2/II-7;1.400;0,62;14;8,4;2;-;10;2;-;2;20,7;63,3;440;IHI;CT58-IHI-110-2;;1.400;;;;2;-;10;2;-;2;20,7;63,3;440;GE;CT64-P4C;DHC-5B (not produced);;;;;2;-;14;2;-;2;;;;GE;CT64-820-1;DHC-5A;2.825;;;;2;-;14;2;-;2;;;;Fiat;CT64-820-2;G222 SAMA;2.938;;;;2;-;14;2;-;2;;;;GE;CT64-820-3;DHC-5A;3.060;;;;2;-;14;2;-;2;;;;GE;CT64-820-4;DHC-5D;3.133;;;;2;-;14;2;-;2;;;;Glushenkov (OMKB);TVD-10B;An-3, An-28, Be-30, T-106, T-501;;;;;;;;;;;;;;Honeywell;HTS900;Bell 407X, Bell 429;925;;;;;;;;;;;;;Honeywell;HTS1000;;;;;;;;;;;;;;;Isotov (Klimov);GTD-350;Mi-2/-2B/-2R;394;0,84;5;6,1;1 + FT;-;7 + 1C;1;-;2;54,4;24,8;307;Isotov (Klimov);TV2-117;Tu-91, Mi-8;1.480;;;;;;;;;;;;;Isotov (Klimov);TV3-117;Mi-4, Mi-7, Mi-8;2.195;;;;1 + FT;-;10;2;-;2;;;;Isotov (Klimov);TV3-117VMA;Ka-32A/A1/A2;2.200;;;;1 + FT;-;10;2;-;2;;;;Isotov (Klimov);TV3-117VMA-02;Ka-32A/A1/A2;3.221;;;;;;;;;;;;;Isotov (Klimov);TV3-117VMA-SB2;An-140;;;;;;;;;;;;;;Ivchenko;AI-20-5;An-32;4.973;;;;1;-;10;3;-;-;;;;Ivchenko;AI-20D-3;An-8, Be-12;4.022;;;;1;-;10;3;-;-;;;;Ivchenko;AI-20D-4;An-8, Be-12;4.973;;;;1;-;10;3;-;-;;;;Ivchenko;AI-20D-5;An-32A;;;;;1;-;10;3;-;-;;;;Ivchenko;AI-20D-6;An-12, Il-18, Il-20, Il-22, Il-38;4.080;0,529;46;8;1;-;10;3;-;-;;;;Ivchenko;AI-20K;An-10/10A, An-12, Il-18V;3.840;;;;1;-;10;3;-;-;;;;Ivchenko;AI-20M;Il-18D/E, Il-38, An-32;3.900;0,44;46;7,6;1;-;10;3;-;-;121,9;46,5;2.293;Ivchenko;AI-20V;KA22;;;;;;;;;;;;;;Ivchenko;AI-24;An-24V-1;2.448;;;;1;-;10;3;-;-;92,4;42,3;1.323;Ivchenko;AI-24A;An-24V-2, An-24RV;2.448;;;;1;-;10;3;-;-;;;;Ivchenko;AI-24T;An-24T, An-26;2.560;0,51;32;7,1;1;-;10;3;-;-;;;;Ivchenko;AI-24TV;An-30;;;;;1;-;10;3;-;-;;;;Ivchenko;AI-26-2;An-24A/B/PV/T/V;2.550;;29;7,6;1;-;10;3;-;-;;;;Ivchenko;AI-26P;SM-6;;;;;1;-;10;3;-;-;;;;Ivchenko;AI-26T;An-24A/B/T;2.820;;;7,9;1;-;10;3;-;-;;;;Ivchenko;AI-26VT;An-26, An-30;;;;;1;-;10;3;-;-;;;;Ivchenko;D-27;An-180;14.000;;;;;;;;;;;;;Ivchenko (Progress);D-236;;10.850;0,462;;;2 + FT;-;7;1;-;2;;;;Klimov;TV7-117;Il-114 prototype;2.466;;;16;1 + FT;-;5 + 1C;2;-;2;;;;Klimov;TV7-117E;Raketa 2.2;2.467;;;;1 + FT;-;5 + 1C;2;-;2;;;;Klimov;TV7-117S;Il-114;;;;;1 + FT;-;5 + 1C;2;-;2;84,4;37;1.146;Klimov;TV7-117SD;An-140;;;;;1 + FT;-;5 + 1C;2;-;2;;;;Klimov;TV7-117SV;MiG-110;;;;;1 + FT;-;5 + 1C;2;-;2;;;;Klimov;TV7-117V;Mi-38 (proposed);;;;;1 + FT;-;5 + 1C;2;-;2;;;;Klimov;TV7-117VMA-S;An-38;1.900;0,496;;;1 + FT;-;5 + 1C;2;-;2;;;;Klimov;TV7-117VMA-SB2;An-140;2.150;0,503;;;1 + FT;-;5 + 1C;2;-;2;;;;Klimov;TV7-117VMA-SB3;(see VK-2500);;;;;;;;;;;;;;Klimov;VK-1500;An-3, An-38, Be-132 (proposed);;;;;;;;;;;;;;Klimov;VK-1500VK;Ka-60, Ka-62 (proposed);;;;;;;;;;;;;;Klimov;VK-1500VM;Mi-8 (proposed);;;;;;;;;;;;;;Klimov;VK-3000;Mi-38 (proposed);;;;;;;;;;;;;;Klimov;VK-3500;;3.500;;;;;;;;;;;;;Kuznetsov;NK-4;An-10 prototype;4.000;;;;;;;;;;;;;Kuznetsov;NK-12M;;12.000;;143;13;1;-;14;5;-;-;;;;Kuznetsov;NK-12MA;An-22, Tu-20;14.795;0,36;143;13;1;-;14;5;-;-;;;;Kuznetsov;NK-12MK;S-90-200;;;;;1;-;14;5;-;-;;;;Kuznetsov;NK-12MV;Tu-114/-114D;14.795;0,36;143;13;1;-;14;5;-;-;;;;LHTEC;CTP800-4T;Ayres LM200;2.700;0,47;;14,1;1 + FT;-;2C;2;-;2;69;50;1.140;LHTEC;CTS800-2;A129 (test aircraft);1.360;0,448;;14,1;1 + FT;-;2C;2;-;2;31,5;26,8;330;Lyulka (Saturn);AL-34;S-86;700;;;;;;;;;;;;;Mitsubishi;CT63-M-5A;HS-369;317;0,65;;6,2;2;-;6 + 1C;2;-;2;41;19;139;Mitsubishi;MG5-110;MH-2000;876;0,27;;11;1;-;1;2;-;-;47,2;29;340;Napier;Eland NEl.1;Convair CV-540;2.920;;;;;;;;;;;;;Napier;Eland NEl.6 Mk.504A;Canadair 540C;3.500;;;;;;;;;;;;;Napier;Eland NEl.7;(see military turboshaft specifications);;;;;;;;;;;;;;Pratt Whitney;JTFTD12A-1;S-64A;4.050;0,695;;;1 + FT;-;9;2;-;2;;34;882;Pratt Whitney;JTFTD12A-3;;;;;;1 + FT;-;9;2;-;2;;34;;Pratt Whitney;JTFTD12A-4A;S-64E;4.500;0,69;;;1 + FT;-;9;2;-;2;;34;920;Pratt Whitney;JTFTD12A-5A;S-64F;4.800;0,688;;;1 + FT;-;9;2;-;2;;34;935;Pratt Whitney Canada;PT6A-6A;PC-6/B Turbo-Porter, P-841 Potez;550;;;;1 + FT;-;3 + 1C;2;-;1;62;19;;Pratt Whitney Canada;PT6A-11;Cheyenne I/IA, T-1040;500;0,647;;;1 + FT;-;3 + 1C;2;-;1;62;19;328;Pratt Whitney Canada;PT6A-11AG;Turbo-Thrush S2R-T11, Ag-Cat, 620 TP;500;0,647;;;1 + FT;-;3 + 1C;2;-;1;62;19;330;Pratt Whitney Canada;PT6A-15AG;Turbo-Thrush S2R-T15, Turbo-Cat, Ag-Cat D, AT-400/-402/-502;680;0,602;;;1 + FT;-;3 + 1C;2;-;1;62;19;328;Pratt Whitney Canada;PT6A-20;DHC-6 Twin Otter 1/100/110/200/210, King Air A90, Merlin IIA, PC-6/B1 Turbo-Porter;550;;;;1 + FT;-;3 + 1C;2;-;1;62;19;;Pratt Whitney Canada;PT6A-20A;;550;;;;1 + FT;-;3 + 1C;2;-;1;62;19;;Pratt Whitney Canada;PT6A-20B;;550;;;;1 + FT;-;3 + 1C;2;-;1;62;19;;Pratt Whitney Canada;PT6A-21;King Air C90B;550;0,63;;;1 + FT;-;3 + 1C;2;-;1;62;19;328;Pratt Whitney Canada;PT6A-25A;PC-7, Firecracker;550;0,63;;;1 + FT;-;3 + 1C;2;-;1;62;19;343;Pratt Whitney Canada;PT6A-25C;PC-7 Mk.II;750;0,595;;;1 + FT;-;3 + 1C;2;-;1;62;19;335;Pratt Whitney Canada;PT6A-27;DHC-6 Twin Otter 300/320, Westwind II/III, Airliner A99, L-410A/F, EMB-110, Y-12 II, PC-6/B2;620;0,602;7;6,7;1 + FT;-;3 + 1C;2;-;1;62;19;328;Pratt Whitney Canada;PT6A-28;King Air E90/A100, Cheyenne II, EMB-121A Xingu I;680;0,602;;;1 + FT;-;3 + 1C;2;-;1;62;19;328;Pratt Whitney Canada;PT6A-34;Commuter C99, 101/101B/102 Avara, ST-28, EMB-110K1/P1/P2;750;0,595;;;1 + FT;-;3 + 1C;2;-;1;62;19;331;Pratt Whitney Canada;PT6A-34AG;Ag-Cat, AT-402/502/503A, Fieldmaster, Turbo-Thrush S2R-T34;750;0,595;;;1 + FT;-;3 + 1C;2;-;1;62;19;331;Pratt Whitney Canada;PT6A-36;Commuter C99;750;0,59;;;1 + FT;-;3 + 1C;2;-;1;62;19;331;Pratt Whitney Canada;PT6A-41;King Air 200, Cheyenne III;850;0,591;;;1 + FT;-;3 + 1C;2;-;2;67;19;403;Pratt Whitney Canada;PT6A-41AG;Turbo Cat, Turbo Ag-Cat;850;;;;1 + FT;-;3 + 1C;2;-;2;67;19;412;Pratt Whitney Canada;PT6A-42;King Air B200, EMB-121V Xingu III;850;0,601;;;1 + FT;-;3 + 1C;2;-;2;67;19;403;Pratt Whitney Canada;PT6A-42A;;850;;;;1 + FT;-;3 + 1C;2;-;2;67;19;403;Pratt Whitney Canada;PT6A-45A;Shorts 330, Mowhawk 298;850;0,554;;;1 + FT;-;3 + 1C;2;-;2;72;19;434;Pratt Whitney Canada;PT6A-45B;Shorts 330, Mowhawk 298;850;0,554;;;1 + FT;-;3 + 1C;2;-;2;72;19;434;Pratt Whitney Canada;PT6A-45R;Shorts 330-200/360-100, Mowhawk 298;850;0,553;;;1 + FT;-;3 + 1C;2;-;2;72;19;448;Pratt Whitney Canada;PT6A-50;DHC-7 Dash 7 1/100/101/150/151;1.120;0,56;;;1 + FT;-;3 + 1C;2;-;2;84;19;607;Pratt Whitney Canada;PT6A-50/7;DHC-7 Dash 7 200 (not produced);1.120;;;;1 + FT;-;3 + 1C;2;-;2;84;19;607;Pratt Whitney Canada;PT6A-60A;King Air 300, King Air 350;1.050;0,548;;;1 + FT;-;3 + 1C;2;-;2;72;19;475;Pratt Whitney Canada;PT6A-61;Cheyenne IIIA;850;0,591;;;1 + FT;-;3 + 1C;2;-;2;67;19;429;Pratt Whitney Canada;PT6A-62;Orlik;950;0,567;;;1 + FT;-;3 + 1C;2;-;2;70;19;454;Pratt Whitney Canada;PT6A-64;TBM 700;700;0,703;;;1 + FT;-;3 + 1C;2;-;2;;19;456;Pratt Whitney Canada;PT6A-65AG;Turbo Thrush, AT-802/802A, Firemaster;1.300;0,509;;;1 + FT;-;4 + 1C;2;-;2;75;19;486;Pratt Whitney Canada;PT6A-65AR;Shorts 360-200, AMI DC-3;1.424;0,509;;;1 + FT;-;4 + 1C;2;-;2;75;19;486;Pratt Whitney Canada;PT6A-65B;Commuter 1900, PZL-M-18, Be-32;1.100;0,536;10;10;1 + FT;-;4 + 1C;2;-;2;74;19;481;Pratt Whitney Canada;PT6A-65R;Shorts 360-200, AMI DC-3;1.376;0,512;;;1 + FT;-;4 + 1C;2;-;2;75;19;481;Pratt Whitney Canada;PT6A-66;Avanti, M-102;850;0,62;;;1 + FT;-;4 + 1C;2;-;2;70;19;470;Pratt Whitney Canada;PT6A-67;RC-12K/N/P/Q;1.100;0,547;;;1 + FT;-;4 + 1C;2;-;2;76;19;506;Pratt Whitney Canada;PT6A-67A;Starship 2000;1.200;0,549;;;1 + FT;-;4 + 1C;2;-;2;;19;506;Pratt Whitney Canada;PT6A-67AF;Turbo Firecat;1.424;0,52;;;1 + FT;-;4 + 1C;2;-;2;;19;532;Pratt Whitney Canada;PT6A-67B;PC-12;1.200;0,552;;;1 + FT;-;4 + 1C;2;-;2;;19;515;Pratt Whitney Canada;PT6A-67D;1900D;1.220;0,53;;;1 + FT;-;4 + 1C;2;-;2;;19;515;Pratt Whitney Canada;PT6A-67R;Shorts 360-300, Basler Turbo BT-67;1.424;0,52;;;1 + FT;-;4 + 1C;2;-;2;76;19;515;Pratt Whitney Canada;PT6A-110;Do 128-6;400;;;;1 + FT;-;3 + 1C;2;-;1;62;19;334;Pratt Whitney Canada;PT6A-112;Conquest I, Corsair I, F406 Caravan II;500;0,637;;;1 + FT;-;3 + 1C;2;-;1;62;19;334;Pratt Whitney Canada;PT6A-114;Caravan I/IA;600;0,64;;;1 + FT;-;3 + 1C;2;-;1;62;19;350;Pratt Whitney Canada;PT6A-114A;Super Caravan;675;;;;1 + FT;-;3 + 1C;2;-;1;62;19;350;Pratt Whitney Canada;PT6A-135;King Air F90, EMB-121A1 Xingu II, Cheyenne IIXL, Comanchero 750;750;0,585;;;1 + FT;-;3 + 1C;2;-;1;62;19;344;Pratt Whitney Canada;PT6A-135A;King Air F90-1, ST-50, Seastar;750;0,585;;;1 + FT;-;3 + 1C;2;-;1;62;19;344;Pratt Whitney Canada;PT6B-36;S-76B;981;0,594;;;1 + FT;-;4 + 1C;2;-;2;59,2;19,5;372;Pratt Whitney Canada;PT6B-36A;;;0,581;;;1 + FT;-;4 + 1C;2;-;2;59,2;19,5;378;Pratt Whitney Canada;PT6B-36B;;;0,581;;;1 + FT;-;4 + 1C;2;-;2;59,2;19,5;386;Pratt Whitney Canada;PT6C;;;;;;1 + FT;-;4 + 1C;2;-;2;59,2;19,5;;Pratt Whitney Canada;PT6T-3;Bell 212, S-58T;1.290;;;;1 + FT;-;4 + 1C;2;-;2;67;44;648;Pratt Whitney Canada;PT6T-3B;Bell 212;1.290;0,596;;;1 + FT;-;4 + 1C;2;-;2;67;44;660;Pratt Whitney Canada;PT6T-3B-1;Bell 412/412SP;1.800;0,596;;;1 + FT;-;4 + 1C;2;-;2;67;44;660;Pratt Whitney Canada;PT6T-3BE;Bell 412HP;1.800;;;;1 + FT;-;4 + 1C;2;-;2;67;44;660;Pratt Whitney Canada;PT6T-3D;Bell 412EP;1.800;0,601;;;1 + FT;-;4 + 1C;2;-;2;67;44;690;Pratt Whitney Canada;PT6T-3DF;;;;;;1 + FT;-;4 + 1C;2;-;2;67;44;690;Pratt Whitney Canada;PT6T-6;S-58T, AB212;1.875;0,602;;;1 + FT;-;4 + 1C;2;-;2;67;44;660;Pratt Whitney Canada;PT6T-6B;AB212HP;1.875;;;;1 + FT;-;4 + 1C;2;-;2;67;44;660;Pratt Whitney Canada;PW115;EMB-120;1.500;;;;2 + FT;1C;1C;1;1;2;81;31;;Pratt Whitney Canada;PW118;EMB-120/-120ER;1.800;0,498;;;2 + FT;1C;1C;1;1;2;81;31;861;Pratt Whitney Canada;PW118A;EMB-120/-120ER;1.800;0,504;;;2 + FT;1C;1C;1;1;2;81;31;866;Pratt Whitney Canada;PW119B;Do 328-100/-110;2.180;0,49;;;2 + FT;1C;1C;1;1;2;81;31;916;Pratt Whitney Canada;PW119C;;;;;;2 + FT;1C;1C;1;1;2;81;31;;Pratt Whitney Canada;PW120;ATR42, SA210TA;2.000;0,485;;;2 + FT;1C;1C;1;1;2;84;31;921;Pratt Whitney Canada;PW120A;Dash 8-100/-100A;2.000;0,485;;;2 + FT;1C;1C;1;1;2;84;31;933;Pratt Whitney Canada;PW121;Dash 8-100/-100A/-100B, ATR42;2.150;0,476;;;2 + FT;1C;1C;1;1;2;84;31;936;Pratt Whitney Canada;PW123;Dash 8-300;2.380;0,47;;;2 + FT;1C;1C;1;1;2;84;33;992;Pratt Whitney Canada;PW123AF;CL-215/415;2.380;0,47;;;2 + FT;1C;1C;1;1;2;84;33;992;Pratt Whitney Canada;PW123B;Dash 8-300;2.500;0,463;;;2 + FT;1C;1C;1;1;2;84;33;992;Pratt Whitney Canada;PW123C;Dash 8-200A/-Q300;2.150;0,483;;;2 + FT;1C;1C;1;1;2;84;33;1.060;Pratt Whitney Canada;PW123D;Dash 8-200B/-Q300;2.150;0,483;;;2 + FT;1C;1C;1;1;2;84;33;1.060;Pratt Whitney Canada;PW123E;Dash 8-Q300;2.380;;;;2 + FT;1C;1C;1;1;2;84;33;1.060;Pratt Whitney Canada;PW124B;ATR72;2.380;0,468;;13,9;2 + FT;1C;1C;1;1;2;84;33;1.060;Pratt Whitney Canada;PW125B;Fokker 50-100;2.380;0,463;;;2 + FT;1C;1C;1;1;2;84;33;1.060;Pratt Whitney Canada;PW126;BAe ATP;2.653;0,463;;;2 + FT;1C;1C;1;1;2;84;33;1.060;Pratt Whitney Canada;PW126A;BAe ATP;2.662;0,461;;;2 + FT;1C;1C;1;1;2;84;33;1.060;Pratt Whitney Canada;PW127A;An-140, Fokker 50-300;2.380;;;;2 + FT;1C;1C;1;1;2;84;33;1.060;Pratt Whitney Canada;PW127B;Fokker 50-400;2.750;0,459;;;2 + FT;1C;1C;1;1;2;84;33;1.060;Pratt Whitney Canada;PW127C;Y7-200A;2.750;0,459;;;2 + FT;1C;1C;1;1;2;84;33;1.060;Pratt Whitney Canada;PW127D;Jetstream 61;2.750;;;;2 + FT;1C;1C;1;1;2;84;33;1.060;Pratt Whitney Canada;PW127E;ATR42-500;2.400;;;;2 + FT;1C;1C;1;1;2;84;33;1.060;Pratt Whitney Canada;PW127F;ATR72-500;2.750;0,459;;;2 + FT;1C;1C;1;1;2;84;33;1.060;Pratt Whitney Canada;PW127J;MA-60;2.750;;;;2 + FT;1C;1C;1;1;2;84;33;1.060;Pratt Whitney Canada;PW127T/S;Mi-38 (proposed);3.356;;;;2 + FT;1C;1C;1;1;2;;;;Pratt Whitney Canada;PW130;Fokker 50-200 (not produced);;;;;2 + FT;1C;1C;1;1;2;84;33;1.060;Pratt Whitney Canada;PW150A;Dash 8-Q400;5.075;;;;2 + FT;1C;1C;1;1;2;84;33;1.060;Pratt Whitney Canada;PW206A;MD Explorer;640;0,543;;;1 + FT;-;1C;1;-;1;35,9;22,3;;Pratt Whitney Canada;PW206B;EC135P1;635;0,548;;;1 + FT;-;1C;1;-;1;41;24,7;;Pratt Whitney Canada;PW206B2;EC135P2;;;;;1 + FT;-;1C;1;-;1;41;24,7;;Pratt Whitney Canada;PW206C;A109E;732;;;;1 + FT;-;1C;1;-;1;;;;Pratt Whitney Canada;PW206E;;;;;;1 + FT;-;1C;1;-;1;;;;Pratt Whitney Canada;PW207E;;;;;;1 + FT;-;1C;1;-;1;;;;Pratt Whitney Canada;PW207K;Ansat;;;;;1 + FT;-;1C;1;-;1;;;;Pratt Whitney Canada;PW210S;S-76D;1.000;;;;;-;;;;;;;;PZL Rzeszów;TWD-10B;An-28;1.011;0,57;10;7,4;1 + FT;-;6 + 1A;2;-;1;81,1;35,4;661;PZL Rzeszów;TWD-10W;W-3 Sokol;888;0,6;10;7,4;1 + FT;-;6 + 1A;2;-;1;73,8;30,1;310;Rolls-Royce;Dart RDa.1 Mk.502;Viscount 630;900;;;;1;-;2C;3;-;-;;;;Rolls-Royce;Dart RDa.3 Mk.505;Viscount 700;1.400;;;;1;-;2C;3;-;-;;;;Rolls-Royce;Dart RDa.3 Mk.506;Viscount 700;1.400;;;;1;-;2C;3;-;-;;;;Rolls-Royce;Dart RDa.?? Mk.507;F27 Prototype 1;;;;;1;-;2C;3;-;-;;;;Rolls-Royce;Dart RDa.6 Mk.510;Viscount 700D/800;1.600;;;;1;-;2C;3;-;-;;;;Rolls-Royce;Dart RDa.6 Mk.511;;;;;;1;-;2C;3;-;-;;;;Rolls-Royce;Dart RDa.6 Mk.511-7E;F-27, F27 Prototype 2;;;;;1;-;2C;3;-;-;;;;Rolls-Royce;Dart RDa.6 Mk.512;ATL.90 Accountant;1.660;;;;1;-;2C;3;-;-;;;;Rolls-Royce;Dart RDa.6 Mk.514;Andover 1;1.660;;;;1;-;2C;3;-;-;;;;Rolls-Royce;Dart RDa.6 Mk.514-7;F-27/-27B, F27 Mk.100/Mk.300/Mk.700;1.715;;;;1;-;2C;3;-;-;;;;Rolls-Royce;Dart RDa.7 Mk.520;Viscount 806;1.742;;;;1;-;2C;3;-;-;;;;Rolls-Royce;Dart RDa.7/1 Mk.525-F;Viscount 810;1.834;;;;1;-;2C;3;-;-;;;;Rolls-Royce;Dart RDa.7 Mk.526;A.W.650 Argosy 100;1.940;;;;1;-;2C;3;-;-;;;;Rolls-Royce;Dart RDa.7 Mk.527;A.W.650 Argosy 200, Herald 100/200;2.000;;;;1;-;2C;3;-;-;;;;Rolls-Royce;Dart RDa.7 Mk.528;;;;;;1;-;2C;3;-;-;;;;Rolls-Royce;Dart RDa.7 Mk.528-7E;F-27A, F27 Mk.200/Mk.400;2.000;;;;1;-;2C;3;-;-;;;;Rolls-Royce;Dart RDa.7 Mk.528D-7E;;;;;;1;-;2C;3;-;-;;;;Rolls-Royce;Dart RDa.7 Mk.529-7;F-27F;2.016;;;;1;-;2C;3;-;-;;;;Rolls-Royce;Dart RDa.7 Mk.529-7E;;;;;;1;-;2C;3;-;-;;;;Rolls-Royce;Dart RDa.7 Mk.529D-7E;;;;;;1;-;2C;3;-;-;;;;Rolls-Royce;Dart RDa.7 Mk.529-7H;;;;;;1;-;2C;3;-;-;;;;Rolls-Royce;Dart RDa.7 Mk.529D-7H;;;;;;1;-;2C;3;-;-;;;;Rolls-Royce;Dart RDa.7 Mk.529-8E;;;;;;1;-;2C;3;-;-;;;;Rolls-Royce;Dart RDa.7 Mk.529D-8E;;;;;;1;-;2C;3;-;-;;;;Rolls-Royce;Dart RDa.7 Mk.529-8H;;;;;;1;-;2C;3;-;-;;;;Rolls-Royce;Dart RDa.7 Mk.529D-8H;;;;;;1;-;2C;3;-;-;;;;Rolls-Royce;Dart RDa.7 Mk.529-8X;Gulfstream I/I-C;1.895;;;;1;-;2C;3;-;-;;;;Rolls-Royce;Dart RDa.7 Mk.529D-8X;;;;;;1;-;2C;3;-;-;;;;Rolls-Royce;Dart RDa.7 Mk.529-8Y;;;;;;1;-;2C;3;-;-;;;;Rolls-Royce;Dart RDa.7 Mk.529D-8Y;;;;;;1;-;2C;3;-;-;;;;Rolls-Royce;Dart RDa.7 Mk.529-8Z;;;;;;1;-;2C;3;-;-;;;;Rolls-Royce;Dart RDa.7 Mk.529D-8Z;;;;;;1;-;2C;3;-;-;;;;Rolls-Royce;Dart RDa.7/1 Mk.530;Viscount 830;1.940;;;;1;-;2C;3;-;-;;;;Rolls-Royce;Dart RDa.7 Mk.531;Viscount 830, Andover 2;1.940;;;;1;-;2C;3;-;-;;;;Rolls-Royce;Dart RDa.7 Mk.532;Herald 600/800;2.030;0,57;24;5,6;1;-;2C;3;-;-;;;;Rolls-Royce;Dart RDa.7 Mk.532-2L;;;;;;1;-;2C;3;-;-;;;;Rolls-Royce;Dart RDa.7 Mk.532-2S;;;;;;1;-;2C;3;-;-;;;;Rolls-Royce;Dart RDa.7 Mk.532-7;F-27J, FH-227/-227B/-227C F27 Mk.400;2.150;;;;1;-;2C;3;-;-;;;;Rolls-Royce;Dart RDa.7 Mk.532-7L;FH-227D/E;2.190;;;;1;-;2C;3;-;-;;;;Rolls-Royce;Dart RDa.7 Mk.532-7N;F-27M;2.190;;;;1;-;2C;3;-;-;;;;Rolls-Royce;Dart RDa.7 Mk.532-7R;;;;;;1;-;2C;3;-;-;;;;Rolls-Royce;Dart RDa.7 Mk.533-2;Andover 2;;;;;1;-;2C;3;-;-;;;;Rolls-Royce;Dart RDa.7 Mk.534-2;Andover 2A;;;;;1;-;2C;3;-;-;;;;Rolls-Royce;Dart RDa.7 Mk.535-2;;;;;;1;-;2C;3;-;-;;;;Rolls-Royce;Dart RDa.7 Mk.535-7;;;;;;1;-;2C;3;-;-;;;;Rolls-Royce;Dart RDa.7 Mk.535-7R;;;;;;1;-;2C;3;-;-;;;;Rolls-Royce;Dart RDa.7 Mk.536;Andover 2B;2.210;;;;1;-;2C;3;-;-;;;;Rolls-Royce;Dart RDa.7 Mk.536-2;;;;;;1;-;2C;3;-;-;;;;Rolls-Royce;Dart RDa.7 Mk.536-2T;;;;;;1;-;2C;3;-;-;;;;Rolls-Royce;Dart RDa.7 Mk.536-7;;;;;;1;-;2C;3;-;-;;;;Rolls-Royce;Dart RDa.7 Mk.536-7P;;;;;;1;-;2C;3;-;-;;;;Rolls-Royce;Dart RDa.7 Mk.536-7R;F27 Mk.500/Mk.600/Mk.600RF;2.210;;;;1;-;2C;3;-;-;;;;Rolls-Royce;Dart RDa.10/1 Mk.542;Convair CV-600/640, YS-11-100, YS-11A200/300/400/500/600;2.915;0,55;27;6,4;1;-;2C;3;-;-;;;;Rolls-Royce;Dart RDa.10 Mk.542-4;;;;;;1;-;2C;3;-;-;;;;Rolls-Royce;Dart RDa.10 Mk.542-4K;;;;;;1;-;2C;3;-;-;;;;Rolls-Royce;Dart RDa.10 Mk.542-10;;;;;;1;-;2C;3;-;-;;;;Rolls-Royce;Dart RDa.10 Mk.542-10J;;;;;;1;-;2C;3;-;-;;;;Rolls-Royce;Dart RDa.10 Mk.542-10K;;;;;;1;-;2C;3;-;-;;;;Rolls-Royce;Dart RDa.10 Mk.543-10;;;;;;1;-;2C;3;-;-;;;;Rolls-Royce;Dart RDa.10 Mk.543-10K;;;;;;1;-;2C;3;-;-;;;;Rolls-Royce;Dart RDa.?? Mk.550-2;;;;;;1;-;2C;3;-;-;;;;Rolls-Royce;Dart RDa.?? Mk.552;Andover 2B;2.210;;;;1;-;2C;3;-;-;;;;Rolls-Royce;Dart RDa.?? Mk.552-2;;;;;;1;-;2C;3;-;-;;;;Rolls-Royce;Dart RDa.?? Mk.552-7;;;;;;1;-;2C;3;-;-;;;;Rolls-Royce;Dart RDa.?? Mk.552-7R;;;;;;1;-;2C;3;-;-;;;;Rolls-Royce;Dart RDa.12 Mk.???;DHC-5C (not produced);;;;;1;-;2C;3;-;-;;;;Rolls-Royce;Gem 42-1 Mk.204;Westland 30 Series 100;1.135;0,65;;;3;4;1C;1;1;2;43,2;23,5;404;Rolls-Royce;Gem 60-3 Mk.530;Westland 30 Series 100-60;1.260;0,61;;;3;;;;;;;;407;Rolls-Royce;Tyne RTy.11 Mk.506;Vanguard 951/953;4.900;;;;2;6;9;1;-;3;;;;Rolls-Royce;Tyne RTy.11 Mk.512;Vanguard 952;5.545;;;;2;6;9;1;-;3;;;;Rolls-Royce;Tyne RTy.12 Mk.515;Canadair 400;5.095;0,39;47;13,5;2;6;9;1;-;3;;;;Rolls-Royce;Tyne RTy.12 Mk.515/10;CL-44D/D-4/J;5.095;0,39;47;13,5;2;6;9;1;-;3;109;43,2;2.219;Rolls-Royce/Turbomeca;RTM 322-??;CL 160 (candidate engine);;;;;1 + FT;-;3 + 1C;2;-;2;;;;Rolls-Royce/Turbomeca;RTM 322-??;S-92 (candidate engine);;;;;1 + FT;-;3 + 1C;2;-;2;;;;Samara;NK-123;Il-100;650;;;;;;;;;;;;;Saturn;RD-600V;Ka-62;1.302;;;;;;;;;;;;;Saturn;TVD-1500;An-38;1.302;;;14,4;1 + FT;-;3 + 1C;2;-;2;77,4;29,9;529;Soloviev;D-25V;Mi-6/6K, Mi-10, Mi-12, KA22;5.500;0,64;58;5,6;1 + FT;-;6;1;-;2;;;;Soloviev;D-25VF;Mi-10K, Mi-12;6.500;;;;1 + FT;-;6;1;-;2;;;;Turbomeca;Ardiden 1H;EC155, A149, KMH (candidate engine);993;;;;1 + FT;;2C;1;-;1;;;;Turbomeca;Arriel 1A;SA365C;641;0,573;;9;1 + FT;-;1 + 1C;2;-;1;42,9;22,4;265;Turbomeca;Arriel 1A1;SA365C1;641;0,573;;9;1 + FT;-;1 + 1C;2;-;1;42,9;22,4;265;Turbomeca;Arriel 1A2;SA365C2;641;0,573;;9;1 + FT;-;1 + 1C;2;-;1;42,9;22,4;265;Turbomeca;Arriel 1B;AS350B/BA;641;0,573;;9;1 + FT;-;1 + 1C;2;-;1;42,9;22,4;265;Turbomeca;Arriel 1C;AS365N;660;;;;1 + FT;-;1 + 1C;2;-;1;;;;Turbomeca;Arriel 1C1;AS365N1, S-76A+;700;;;;1 + FT;-;1 + 1C;2;-;1;;;;Turbomeca;Arriel 1C2;AS365N2;700;;;;1 + FT;-;1 + 1C;2;-;1;;;;Turbomeca;Arriel 1D;AS350B1;684;;;;1 + FT;-;1 + 1C;2;-;1;;;;Turbomeca;Arriel 1D1;AS350B1/B2, AS-550, KA128;732;;;;1 + FT;-;1 + 1C;2;-;1;;;;Turbomeca;Arriel 1E;BK117C1;708;;;;1 + FT;-;1 + 1C;2;-;1;;;;Turbomeca;Arriel 1E2;BK117C1C, EC145 (BK117C2);738;;;;1 + FT;-;1 + 1C;2;-;1;;;;Turbomeca;Arriel 1K;A109K;;;;;1 + FT;-;1 + 1C;2;-;1;;;;Turbomeca;Arriel 1K1;A109K2;738;;;;1 + FT;-;1 + 1C;2;-;1;;;;Turbomeca;Arriel 1M;AS365F;691;;;;1 + FT;-;1 + 1C;2;-;1;;;;Turbomeca;Arriel 1M1;AS365F1;783;;;;1 + FT;-;1 + 1C;2;-;1;;;;Turbomeca;Arriel 1S;S-76A+;700;;;;1 + FT;-;1 + 1C;2;-;1;;;;Turbomeca;Arriel 1S1;S-76A++/C;723;;;;1 + FT;-;1 + 1C;2;-;1;60,6;31;;Turbomeca;Arriel 2B;AS350B3;848;;;;1 + FT;-;1 + 1C;2;-;1;;;;Turbomeca;Arriel 2B1;EC130B4;848;;;;1 + FT;-;1 + 1C;2;-;1;;;;Turbomeca;Arriel 2B1A;Z11;;;;;1 + FT;-;1 + 1C;2;-;1;;;;Turbomeca;Arriel 2C;AS365N3, H410A;839;;;;1 + FT;-;1 + 1C;2;-;1;;;;Turbomeca;Arriel 2C1;EC155B;839;;;;1 + FT;-;1 + 1C;2;-;1;;;;Turbomeca;Arriel 2C2;EC155B1;944;;;;1 + FT;-;1 + 1C;2;-;1;39,9;22,7;;Turbomeca;Arriel 2S1;S-76C+;856;;;;1 + FT;-;1 + 1C;2;-;1;;;;Turbomeca;Arriel 2S2;S-76C++;;;;;1 + FT;-;1 + 1C;2;-;1;;;;Turbomeca;Arrius 1A;AS355N;480;;;;1 + FT;-;1C;1;-;1;30,8;21,3;192;Turbomeca;Arrius 1B;BO108 (not produced/see EC135);480;;;;1 + FT;-;1C;1;-;1;32,5;23,2;245;Turbomeca;Arrius 1D;Socata Oméga;480;;;;1 + FT;-;1C;1;-;1;32,5;23,2;245;Turbomeca;Arrius 1M;AS355N;480;;;;1 + FT;-;1C;1;-;1;30,8;21,3;192;Turbomeca;Arrius 2B1;MD Explorer, EC135T1;;;;;1 + FT;-;1C;1;-;1;;;;Turbomeca;Arrius 2B1A;EC135T1;;;;;1 + FT;-;1C;1;-;1;;;;Turbomeca;Arrius 2B1A1;EC135T1;;;;;1 + FT;-;1C;1;-;1;;;;Turbomeca;Arrius 2B2;EC135T2;;;;;1 + FT;-;1C;1;-;1;;;;Turbomeca;Arrius 2D;Socata Oméga;;;;;1 + FT;-;1C;1;-;1;;;;Turbomeca;Arrius 2F;EC120B;;;;;1 + FT;-;1C;1;-;1;;;;Turbomeca;Arrius 2K1;;;;;;1 + FT;-;1C;1;-;1;;;;Turbomeca;Arrius 2K2;;;;;;1 + FT;-;1C;1;-;1;;;;Turbomeca;Artouste I;SE313B;360;;;;1;-;1 + 1C;3;-;-;;;;Turbomeca;Artouste IIC5;SE313B;360;;7;3,9;1;-;1 + 1C;3;-;-;;;;Turbomeca;Artouste IIC6;SE313B;360;;7;3,9;1;-;1 + 1C;3;-;-;;;;Turbomeca;Artouste IIIB;SA315B, SA316B;570;0,76;10;5,2;1;-;1 + 1C;3;-;-;;;;Turbomeca;Artouste IIIC;SA315B, SA316B;;;;;1;-;2 + 1C;3;-;-;;;;Turbomeca;Artouste IIID;SA316C;;;;;1;-;1 + 1C;3;-;-;;;;Turbomeca;Astazou II;P-840.01 Potez;440;;;;1;-;1 + 1C;3;-;-;50;18;;Turbomeca;Astazou IIA;SA318C;523;0,623;;;1;-;1 + 1C;3;-;-;50;18;;Turbomeca;Astazou IIE;PC-6/A Turbo-Porter;523;;;;1;-;1 + 1C;3;-;-;50;18;;Turbomeca;Astazou IIG;PC-6/A Turbo-Porter;523;;;;1;-;1 + 1C;3;-;-;50;18;;Turbomeca;Astazou III;;591;0,643;6;;1;-;1 + 1C;3;-;-;56,3;18;324;Turbomeca;Astazou III-2;;645;0,65;;;1;-;1 + 1C;3;-;-;;;330;Turbomeca;Astazou IIA;SA341G;645;0,65;;;1;-;1 + 1C;3;-;-;;;;Turbomeca;Astazou XII;Skyvan 2, PC-6/A1 Turbo-Porter, P-840.02/-842 Potez;690;;;;1;-;2 + 1C;3;-;-;;;;Turbomeca;Astazou XIV;SA342J, Jetstream 1, Hirondelle;800;;;;1;-;2 + 1C;3;-;-;;;;Turbomeca;Astazou XIVB;SA319B;573;0,624;;;1;-;2 + 1C;3;-;-;56,3;;366;Turbomeca;Astazou XIVE;PC-6/A2 Turbo-Porter;573;;;;1;-;2 + 1C;3;-;-;56,3;;;Turbomeca;Astazou XIVF;SA319B;573;;;;1;-;2 + 1C;3;-;-;56,3;;;Turbomeca;Astazou XIVH;SA342H;;;;;1;-;2 + 1C;3;-;-;57,9;18;353;Turbomeca;Astazou XVI;Jetstream 2;;0,5;7;8,2;1;-;2 + 1C;3;-;-;;;;Turbomeca;Astazou XVID;Jetstream 201;940;0,5;7;8,2;1;-;2 + 1C;3;-;-;;;;Turbomeca;Astazou XVIII;;;;;;1;-;2 + 1C;3;-;-;;;;Turbomeca;Astazou XVIIIA;SA360C;591;0,54;;;1;-;2 + 1C;3;-;-;52,2;27,5;341;Turbomeca;Bastan 3A;IA 50 Guarani I;850;;;;1;-;1 + 1C;3;-;-;;;;Turbomeca;Bastan 6A;IA 50A Guarani II;930;;;;1;-;1 + 1C;3;-;-;;;;Turbomeca;Bastan 6C1;AS262A/B;1.000;0,62;10;5,7;1;-;1 + 1C;3;-;-;;;;Turbomeca;Bastan 7A;AS262C;1.060;0,6;13;6,8;1;-;2 + 1C;3;-;-;;;;Turbomeca;Bastan 16;;1.728;;;;1;-;2 + 1C;3;-;-;;;;Turbomeca;Makila 1A;AS332C/L;1.757;0,496;;;1 + FT;-;3 + 1C;2;-;2;54,9;20,3;535;Turbomeca;Makila 1A1;AS332C1/L1;1.877;0,481;;;1 + FT;-;3 + 1C;2;-;2;54,9;20,3;535;Turbomeca;Makila 1A2;AS332L2;2.100;;;;1 + FT;-;3 + 1C;2;-;2;54,9;20,3;535;Turbomeca;Makila 1A4;EC225;2.400;;;;1 + FT;-;3 + 1C;2;-;2;54,9;20,3;535;Turbomeca;Makila 2A;EC225;;;;;1 + FT;-;3 + 1C;2;-;2;;;;Turbomeca;TM 333-2B;Indian ALH;1.001;0,529;;;1 + FT;-;2 + 1C;1;-;1;41,1;28;345;Turbomeca;Turmastazou 14;;900;0,53;7;8;1 + FT;-;2 + 1C;2;-;2;;;;Turbomeca;Turmo 3C3;SA321F;1.480;0,603;13;5,9;1 + FT;-;1 + 1C;2;-;1;;;;Turbomeca;Turmo 3C5;SA321J;1.500;0,632;;;1 + FT;-;1 + 1C;2;-;1;;;;Turbomeca;Turmo 4A;;1.417;0,629;;;1 + FT;-;1 + 1C;2;-;2;;;;Turbomeca;Turmo 4C;SA330J;1.417;0,629;;;1 + FT;-;1 + 1C;2;-;??;;;;Turbomeca;Turmo 6;SA330L;1.700;;;;1 + FT;-;3 + 1C;2;-;2;;;;Turbomeca;Turmo 10;SA321;1.600;;;;1 + FT;-;3 + 1C;2;-;2;;;;Turbomeca;Turmo 16;;2.000;;;;1 + FT;-;3 + 1C;2;-;2;;;;Walter;M 601 A;L-410M;691;;;;1 + FT;-;2 +1C;1;-;1;65,9;25,6;;Walter;M 601 B;L-410MA/UVP;691;0,656;7;6,4;1 + FT;-;2 +1C;1;-;1;65,9;25,6;426;Walter;M 601 D;L-410UVP;724;0,654;8;6,6;1 + FT;-;2 +1C;1;-;1;65,3;25,6;426;Walter;M 601 E;L-410UVP-E;751;0,649;8;6,7;1 + FT;-;2 +1C;1;-;1;65,9;25,6;441;Walter;M 601 F;L-420, M-101, Ae-270;778;0,633;8;6,7;1 + FT;-;2 +1C;1;-;1;65,9;25,6;445;Walter;M 601 T;PZL-130TM/TB;751;0,649;8;6,7;1 + FT;-;2 +1C;1;-;1;65,9;25,6;445;Walter;M 601 Z;Z-137T;512;0,804;;;1 + FT;-;2 +1C;1;-;1;65,9;25,6;434;Walter;M 602;L-610;1.824;0,559;16;13;2 + FT;1C;1C;1;1;2;105,1;34,3;1.257;';

DROP PROCEDURE IF EXISTS Initial_turbo_eng;
DELIMITER $$
CREATE PROCEDURE Initial_turbo_eng(texti text)
BEGIN
    declare engine_specifications_ID int;
    declare manufacturers varchar(255);
    declare models varchar(255);
    declare application varchar(255);
    declare total_ShaftHorsepower varchar(255);
    declare total_Specific_FuelConsumption varchar(255); #pounds/hr
    declare total_Airflow varchar(255); #pounds/sec
    declare overall_PressureRatio varchar(255);
    declare number_Of_Spools varchar(255);
    declare lowPressure_Compressors varchar(255);
    declare highPressure_Compressors varchar(255);
    declare highPressure_Turbines varchar(255);
    declare intermediate_PressureTurbines varchar(255);
    declare lowPressure_Turbines varchar(255);
    declare lengths varchar(255); #inches
    declare widths varchar(255); #inches
    declare dryweights varchar(255); #pounds  
    
    
    declare strlength int;

    set strlength = char_length(texti);
    while (strlength > 0) do
    
        set manufacturers = substring_index(texti,';',1);
        set texti = substring(texti,locate(';',texti) + 1);
        
        set models = substring_index(texti,';',1);
        set texti = substring(texti,locate(';',texti) + 1);
        
        set application = substring_index(texti,';',1);
        set texti = substring(texti,locate(';',texti) + 1);
        
        set total_ShaftHorsepower = substring_index(texti,';',1);
        set texti = substring(texti,locate(';',texti) + 1);
        
        set total_Specific_FuelConsumption = substring_index(texti,';',1);
        set texti = substring(texti,locate(';',texti) + 1);
        
        set total_Airflow = substring_index(texti,';',1);
        set texti = substring(texti,locate(';',texti) + 1);
        
        set overall_PressureRatio = substring_index(texti,';',1);
        set texti = substring(texti,locate(';',texti) + 1);
        
        set number_Of_Spools = substring_index(texti,';',1);
        set texti = substring(texti,locate(';',texti) + 1);
        
        set lowPressure_Compressors = substring_index(texti,';',1);
        set texti = substring(texti,locate(';',texti) + 1);
        
        set highPressure_Compressors = substring_index(texti,';',1);
        set texti = substring(texti,locate(';',texti) + 1);
        
        set highPressure_Turbines = substring_index(texti,';',1);
        set texti = substring(texti,locate(';',texti) + 1);
        
        set intermediate_PressureTurbines = substring_index(texti,';',1);
        set texti = substring(texti,locate(';',texti) + 1);
        
        set lowPressure_Turbines = substring_index(texti,';',1);
        set texti = substring(texti,locate(';',texti) + 1);
        
        set lengths = substring_index(texti,';',1);
        set texti = substring(texti,locate(';',texti) + 1);
        
        set widths = substring_index(texti,';',1);
        set texti = substring(texti,locate(';',texti) + 1);
        
        set dryweights = substring_index(texti,';',1);
        set texti = substring(texti,locate(';',texti) + 1);
        
        
        
        
        insert into turbopropenginespecifications(engineSpecificationsID,manufacturer,model,applications,totalShaftHorsepower,totalSpecificFuelConsumption,totalAirflow,overallPressureRatio,numberOfSpools,lowPressureCompressors,highPressureCompressors,highPressureTurbines,intermediatePressureTurbines,lowPressureTurbines,length,width,dryweight)
        values (DEFAULT,manufacturers,models,application,total_ShaftHorsepower,total_Specific_FuelConsumption,total_Airflow,overall_PressureRatio,number_Of_Spools,lowPressure_Compressors,highPressure_Compressors,highPressure_Turbines,intermediate_PressureTurbines,lowPressure_Turbines,lengths,widths,dryweights);    
        set strlength = char_length(texti);
    end while;

END $$
delimiter ;

CALL Initial_turbo_eng(@engineinfo);

#-----------------------------TEST CODE------------------------------
call createStaff('NOR32423','Jorgen','Blorgen',CURDATE(),'AQ',1); #PERSONID, FIRSTNAME, LASTNAME, DATEOFBIRTH, COUNTRYCODE, JOBSID
call addFlightDeck(1,'IS1020313','DE4015928'); #FLIGHTCODE, CAPTAINPERSONID, FIRSTOFFICERPERSONID
call addCabinCrew(20); #FLIGHTCODE
call UpdateCabinCrew(1,'US3048812'); #FLIGHTCODE, PERSONID
call crewMemberHistory('IS3976809'); #PERSONID
call AddFlightGeneralStaff('FA501','2016-08-1','DE7438966'); #FLIGHTNUMBER, FLIGHTDATE, PERSONID
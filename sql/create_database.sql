-- DROP all tables
@drop_database

-- CREATE or RECREATE all tables
CREATE TABLE Subscriber(
	CreditCard VARCHAR(30) PRIMARY KEY NOT NULL,
	Lastname Varchar(20) NOT NULL,
	Firstname VARCHAR(20) NOT NULL,
	Birthdate DATE NOT NULL,
	Address VARCHAR(50)
);

CREATE TABLE VehicleClass(
	ClassName VARCHAR(20) PRIMARY KEY NOT NULL,
	MaxDuration INTEGER NOT NULL,
	HourlyPrice FLOAT NOT NULL,
	Deposit FLOAT NOT NULL,
	CONSTRAINT ck_MaxDuration CHECK (MaxDuration > 0),
	CONSTRAINT ck_HourlyPrice CHECK (HourlyPrice > 0),
	CONSTRAINT ck_Deposit CHECK (Deposit >= 0)
);

CREATE TABLE Vehicle(
	IdVehicle NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY NOT NULL,
	ClassName VARCHAR(20) NOT NULL,
	Seats INTEGER NOT NULL,
	CONSTRAINT fk_VehicleClassName FOREIGN KEY(ClassName) REFERENCES VehicleClass(ClassName),
	CONSTRAINT ck_Seats CHECK (Seats > 0)
);

CREATE TABLE Station(
	StationName VARCHAR(20) PRIMARY KEY NOT NULL,
	StationAddress VARCHAR(50) NOT NULL
);

CREATE TABLE Location(
	IdLocation NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY NOT NULL,
	StartStationName VARCHAR(20) NOT NULL,
	CreditCard VARCHAR(30) NOT NULL,
	IdVehicle INTEGER NOT NULL,
	StartDate DATE NOT NULL,
	CONSTRAINT fk_LocationStation FOREIGN KEY(StartStationName) REFERENCES Station(StationName),
	CONSTRAINT fk_LocationSubscriber FOREIGN KEY(CreditCard) REFERENCES Subscriber(CreditCard),
	CONSTRAINT fk_LocationVehicle FOREIGN KEY(IdVehicle) REFERENCES Vehicle(IdVehicle)
);

CREATE TABLE UserClassIllimitedRate(
	CreditCard VARCHAR(30) NOT NULL,
	ClassName VARCHAR(20) NOT NULL,
	Duration INTEGER NOT NULL,
	StartDate DATE NOT NULL,
	Price FLOAT NOT NULL,
	CONSTRAINT pk_UserClassIllimitedRate PRIMARY KEY(CreditCard,ClassName),
	CONSTRAINT fk_IllimitedRateUser FOREIGN KEY(CreditCard) REFERENCES Subscriber(CreditCard),
	CONSTRAINT fk_IllimitedRateClass FOREIGN KEY(ClassName) REFERENCES VehicleClass(ClassName),
	CONSTRAINT ck_UserClassIllimitedRatePrice CHECK (Price > 0)
);

CREATE TABLE UserClassLimitedRate(
	CreditCard VARCHAR(30),
	ClassName VARCHAR(20),
	NbLocation INTEGER,
	Price FLOAT,
	CONSTRAINT pk_UserClassLimitedRate PRIMARY KEY(CreditCard,ClassName),
	CONSTRAINT fk_LimitedRateUser FOREIGN KEY(CreditCard) REFERENCES Subscriber(CreditCard),
	CONSTRAINT fk_LimitedRateClass FOREIGN KEY(ClassName) REFERENCES VehicleClass(ClassName),
	CONSTRAINT ck_UserClassLimitedRatePrice CHECK (Price > 0)
);

CREATE TABLE StationVehicle(
	IdVehicle NUMBER NOT NULL,
	StationName VARCHAR(20) NOT NULL,
	CONSTRAINT fk_StationVehicleVehicle FOREIGN KEY(IdVehicle) REFERENCES Vehicle(IdVehicle),
	CONSTRAINT fk_StationVehicleStation FOREIGN KEY(StationName) REFERENCES Station(StationName)
);

CREATE TABLE StationLocation(
	IdLocation INTEGER PRIMARY KEY NOT NULL,
	EndStationName VARCHAR(20) NOT NULL,
	EndDate DATE NOT NULL,
	CONSTRAINT fk_StationLocationId FOREIGN KEY(IdLocation) REFERENCES Location(IdLocation),
	CONSTRAINT fk_StationLocationName FOREIGN KEY(EndStationName) REFERENCES Station(StationName)
);

CREATE TABLE StationClass(
	StationName VARCHAR(20) NOT NULL,
	ClassName VARCHAR(20) NOT NULL,
	MaxSpots INTEGER NOT NULL,
	CONSTRAINT pk_StationClass PRIMARY KEY(StationName,ClassName),
	CONSTRAINT fk_StationClassStationName FOREIGN KEY(StationName) REFERENCES Station(StationName),
	CONSTRAINT fk_StationClassClassName FOREIGN KEY(ClassName) REFERENCES VehicleClass(ClassName),
	CONSTRAINT ck_StationClassMaxSpots CHECK (MaxSpots >= 0)
);

-- INSERTION
@inserts_database

-- Facturation d'une location
SELECT 	Vehicle.IdVehicle,
				Vehicle.ClassName,
				CASE WHEN (CURRENT_DATE - Location.StartDate) > (VehicleClass.MaxDuration/24)
						 THEN (CURRENT_DATE - Location.StartDate) * 24 * VehicleClass.HourlyPrice + VehicleClass.Deposit
						 ELSE (CURRENT_DATE - Location.StartDate) * 24 * VehicleClass.HourlyPrice
						 END AS Price
FROM Location, Vehicle, VehicleClass
WHERE Location.IdLocation = 1
AND		Location.IdVehicle = Vehicle.IdVehicle
AND		VehicleClass.ClassName = Vehicle.ClassName;

-- Temps moyen d'utilisation par véhicule par mois
SELECT 	TO_CHAR(Location.StartDate, 'YYYY-MM') AS Month,
		Vehicle.IdVehicle AS IdVehicle,
		SUM(StationLocation.EndDate - Location.StartDate) / COUNT(Location.IdLocation) AS AverageDuration,
		COUNT(Location.IdLocation) AS NbLocation
FROM Location, StationLocation, Vehicle
WHERE Location.IdLocation = StationLocation.IdLocation
AND Vehicle.IdVehicle = Location.IdVehicle
GROUP BY TO_CHAR(Location.StartDate, 'YYYY-MM'), Vehicle.IdVehicle;

-- Temps moyen d'utilisation par catégorie de véhicule par mois
SELECT 	TO_CHAR(Location.StartDate, 'YYYY-MM') AS Month,
		Vehicle.ClassName AS VehicleClass,
		SUM(StationLocation.EndDate - Location.StartDate) / COUNT(Location.IdLocation) AS AverageDuration,
		COUNT(Location.IdLocation) AS NbLocation
FROM Location, StationLocation, Vehicle
WHERE Location.IdLocation = StationLocation.IdLocation
AND Vehicle.IdVehicle = Location.IdVehicle
GROUP BY TO_CHAR(Location.StartDate, 'YYYY-MM'), Vehicle.ClassName;

-- Catégorie de véhicule la plus utilisée par tranche d'age de 10 ans
SELECT 	Vehicle.ClassName,
				SUM(StationLocation.EndDate - Location.StartDate) AS AverageDuration
FROM Location, StationLocation, Vehicle
WHERE Location.IdLocation = StationLocation.IdLocation
AND Vehicle.IdVehicle = Location.IdVehicle
AND Location.StartDate > add_months(CURRENT_DATE, -120)
GROUP BY Vehicle.ClassName;

SELECT 	MAX(SUM(StationLocation.EndDate - Location.StartDate)) AS AverageDuration
FROM Location, StationLocation, Vehicle
WHERE Location.IdLocation = StationLocation.IdLocation
AND Vehicle.IdVehicle = Location.IdVehicle
AND Location.StartDate > add_months(CURRENT_DATE, -120)
GROUP BY Vehicle.ClassName;

-- Taux d'occupation des stations dans la journée (PAS FINI)
SELECT 	Location.IdVehicle,
				Location.IdLocation,
				StationLocation.EndStationName,
				StationLocation.EndDate
FROM	Location, StationLocation
WHERE Location.IdLocation = StationLocation.IdLocation
AND		StationLocation.EndStationName = 'Austerlitz'
ORDER BY 4;

SELECT	Location.IdVehicle,
				'15-NOV-16'
FROM 	Location, StationLocation
WHERE	Location.IdLocation = StationLocation.IdLocation
AND		StationLocation.EndStationName = 'Austerlitz'
AND		StationLocation.EndDate < TO_DATE('15/11/2016 12:00', 'dd/mm/yyyy hh24:mi');

-- VERIFIER LES CONTRAINTES AVANT DE D'EXECUTER LES FONCTIONNALITES

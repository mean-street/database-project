-- DROP all tables
DROP TABLE UserClassIllimitedRate PURGE;
DROP TABLE UserClassLimitedRate PURGE;
DROP TABLE StationVehicle PURGE;
DROP TABLE StationLocation PURGE;
DROP TABLE StationClass PURGE;
DROP TABLE Location PURGE;
DROP TABLE Subscriber PURGE;
DROP TABLE Vehicle PURGE;
DROP TABLE VehicleClass PURGE;
DROP TABLE Station PURGE;

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
	IdVehicle INTEGER PRIMARY KEY NOT NULL,
	ClassName VARCHAR(20) NOT NULL,
	Seats INTEGER NOT NULL,
	CONSTRAINT fk_VehicleClassName FOREIGN KEY(ClassName) REFERENCES VehicleClass(ClassName),
	CONSTRAINT ck_Seats CHECK (Seats > 0)
);

CREATE TABLE Station(
	StationName VARCHAR(20) PRIMARY KEY NOT NULL,
	StationAddress VARCHAR(20) NOT NULL
);

CREATE TABLE Location(
	IdLocation INTEGER PRIMARY KEY NOT NULL,
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
	IdVehicle INTEGER PRIMARY KEY NOT NULL,
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
-- VehicleClass
-- INSERT INTO VehicleClass (ClassName, MaxDuration, HourlyPrice, Deposit) VALUES ('Voiture', 20, 15.0, 300.0);

-- Vehicle
--INSERT INTO Vehicle (IdVehicle, ClassName, Seat) VALUES (20, 15.0, 300.0);

-- VERIFIER LES CONTRAINTES AVANT DE D'EXECUTER LES FONCTIONNALITES

-- IdVehicle INTEGER PRIMARY KEY NOT NULL,
-- ClassName VARCHAR(20) NOT NULL,
-- Seats INTEGER,
-- CONSTRAINT fk_VehicleClassName FOREIGN KEY(ClassName) REFERENCES VehicleClass(ClassName),
-- CONSTRAINT ck_Seats CHECK (Seats > 0)

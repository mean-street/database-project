-- DROP all tables
DROP TABLE UserClassIllimitedRate PURGE;
DROP TABLE UserClassLimitedRate PURGE;
DROP TABLE SubscriberClass PURGE;
DROP TABLE StationVehicle PURGE;
DROP TABLE StationLocation PURGE;
DROP TABLE StationClass PURGE;
DROP TABLE Location PURGE;
DROP TABLE Spot PURGE;
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
	Seats INTEGER,
	CONSTRAINT fk_VehicleClassName FOREIGN KEY(ClassName) REFERENCES VehicleClass(ClassName),
	CONSTRAINT ck_Seats CHECK (Seats > 0)
);

CREATE TABLE Station(
	StationName VARCHAR(20) PRIMARY KEY NOT NULL,
	StationAddress VARCHAR(20) NOT NULL
);

CREATE TABLE Location(
	IdLocation INTEGER PRIMARY KEY NOT NULL,
	StationName VARCHAR(20),
	CreditCard VARCHAR(30),
	IdVehicle INTEGER,
	StartDate DATE,
	CONSTRAINT fk_LocationSation FOREIGN KEY(StationName) REFERENCES Station(StationName),
	CONSTRAINT fk_LocationSubscriber FOREIGN KEY(CreditCard) REFERENCES Subscriber(CreditCard),
	CONSTRAINT fk_LocationVehicle FOREIGN KEY(IdVehicle) REFERENCES Vehicle(IdVehicle)
);

CREATE TABLE UserClassIllimitedRate(
	CreditCard VARCHAR(30),
	ClassName VARCHAR(20),
	Duration FLOAT(4),
	StartDate DATE,
	PRICE FLOAT(4),
	CONSTRAINT pk_UserClassIllimitedRate PRIMARY KEY(CreditCard,ClassName),
	CONSTRAINT fk_IllimitedRateUser FOREIGN KEY(CreditCard) REFERENCES Subscriber(CreditCard),
	CONSTRAINT fk_IllimitedRateClass FOREIGN KEY(ClassName) REFERENCES VehicleClass(ClassName)
);

CREATE TABLE UserClassLimitedRate(
	CreditCard VARCHAR(30),
	ClassName VARCHAR(20),
	MaxAmount INTEGER,
	PRICE FLOAT(4),
	CONSTRAINT pk_UserClassLimitedRate PRIMARY KEY(CreditCard,ClassName),
	CONSTRAINT fk_LimitedRateUser FOREIGN KEY(CreditCard) REFERENCES Subscriber(CreditCard),
	CONSTRAINT fk_LimitedRateClass FOREIGN KEY(ClassName) REFERENCES VehicleClass(ClassName)
);

CREATE TABLE SubscriberClass(
	ClassName VARCHAR(20),
	CreditCard VARCHAR(30),
	CONSTRAINT pk_SubscriberClass PRIMARY KEY(ClassName,CreditCard),
	CONSTRAINT fk_SubscriberClassName FOREIGN KEY(ClassName) REFERENCES VehicleClass(ClassName),
	CONSTRAINT fk_SubscriberClassCard FOREIGN KEY(CreditCard) REFERENCES Subscriber(CreditCard)
);


CREATE TABLE StationVehicle(
	IdVehicle INTEGER PRIMARY KEY,
	StationName VARCHAR(20),
	CONSTRAINT fk_StationVehicle FOREIGN KEY(IdVehicle) REFERENCES Vehicle(IdVehicle)
);


CREATE TABLE StationLocation(
	IdLocation INTEGER PRIMARY KEY,
	StationName VARCHAR(20),
	EndDate DATE,
	CONSTRAINT fk_StationLocationId FOREIGN KEY(IdLocation) REFERENCES Location(IdLocation),
	CONSTRAINT fk_StationLocationName FOREIGN KEY(StationName) REFERENCES Station(StationName)
);

CREATE TABLE StationClass(
	StationName VARCHAR(20),
	ClassName VARCHAR(20),
	MaxSpots INTEGER,
	CONSTRAINT pk_StationClass PRIMARY KEY(StationName,ClassName),
	CONSTRAINT fk_StationClassStationName FOREIGN KEY(StationName) REFERENCES Station(StationName),
	CONSTRAINT fk_StationClassClassName FOREIGN KEY(ClassName) REFERENCES VehicleClass(ClassName)
);

-- INSERT INTO Station VALUES("ISS","orbite terrestre basse");
-- INSERT INTO VehicleClass VALUES(1,"Rocket",6);

CREATE TABLE Subscriber(
	CreditCard VARCHAR(30) PRIMARY KEY,
	Lastname Varchar(20),
	Firstname VARCHAR(20),
	Birthdate VARCHAR(20),
	Adress VARCHAR(50)
);

CREATE TABLE VehicleClass(
	ClassName VARCHAR(20) PRIMARY KEY,
	MaxDuration FLOAT(4),
	HourlyPrice FLOAT(4),
	Deposit FLOAT(4)
);

CREATE TABLE Vehicle(
	IdVehicle INTEGER PRIMARY KEY,
	ClassName VARCHAR(20),
	Seats INTEGER,
	CONSTRAINT fk_VehicleClassName FOREIGN KEY(ClassName) REFERENCES VehicleClass(ClassName)
);

CREATE TABLE Station(
	StationName VARCHAR(20) PRIMARY KEY,
	AdressName VARCHAR(20)
);

CREATE TABLE Location(
	IdLocation INTEGER PRIMARY KEY,
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
	EmptySpots INTEGER,
	CONSTRAINT pk_StationClass PRIMARY KEY(StationName,ClassName),
	CONSTRAINT fk_StationClassStationName FOREIGN KEY(StationName) REFERENCES Station(StationName),
	CONSTRAINT fk_StationClassClassName FOREIGN KEY(ClassName) REFERENCES VehicleClass(ClassName)
);

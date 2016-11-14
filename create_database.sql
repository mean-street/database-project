CREATE TABLE Subscriber(
	CreditCard VARCHAR(30) PRIMARY KEY,
	Lastname Varchar(20),
	Firstname VARCHAR(20),
	Birthdate VARCHAR(20),
	Adress VARCHAR(50)
);

CREATE TABLE Vehicle(
	IdVehicle INTEGER PRIMARY KEY,
	Seats INTERGER
);

CREATE TABLE Class(
	ClassName VARCHAR(20) PRIMARY KEY,
	MaxDuration FLOAT(4),
	HourlyPrice FLOAT(4),
	Deposit FLOAT(4)
);

CREATE TABLE Station(
	StationName VARCHAR(20) PRIMARY KEY,
	AdressName VARCHAR(20)
);

CREATE TABLE Location(
	idLocation INTEGER PRIMARY KEY,
	StationName VARCHAR(20),
	CreditCard VARCHAR(30),
	idVehicle VARCHAR(20),
	StartDate DATE,
	CONSTRAINT fk_LocationSation FOREIGN KEY(StationName) REFERENCES Station(StationName),
	CONSTRAINT fk_LocationSubscriber FOREIGN KEY(CreditCard) REFERENCES Subscriber(CreditCard),
	CONSTRAINT fk_LocationVehicle FOREIGN KEY(idVehicle) REFERENCES Vehicle(idVehicle)
);

CREATE TABLE UserClassIllimitedRate(
	CreditCard VARCHAR(30),
	ClassName VARCHAR(20),
	Duration FLOAT(4),
	StartDate DATE,
	PRICE FLOAT(4),
	CONSTRAINT pk_UserClassIllimitedRate PRIMARY KEY(CreditCard,ClassName),
	CONSTRAINT fk_IllimitedRateUser FOREIGN KEY(CreditCard) REFERENCES Subscriber(CreditCard),
	CONSTRAINT fk_IllimitedRateClass FOREIGN KEY(ClassName) REFERENCES Class(ClassName)
);

CREATE TABLE UserClassLimitedRate(
	CreditCard VARCHAR(30),
	ClassName VARCHAR(20),
	MaxAmount INTEGER,
	PRICE FLOAT(4),
	CONSTRAINT pk_UserClassLimitedRate PRIMARY KEY(CreditCard,ClassName),
	CONSTRAINT fk_IllimitedRateUser FOREIGN KEY(CreditCard) REFERENCES Subscriber(CreditCard),
	CONSTRAINT fk_IllimitedRateClass FOREIGN KEY(ClassName) REFERENCES Class(ClassName)
);

CREATE TABLE Spot(
	StationName VARCHAR(20),
	ClassName VARCHAR(20),
	CONSTRAINT pk_SpotStationClass PRIMARY KEY(StationName,ClassName),
	CONSTRAINT fk_SpotStation FOREIGN KEY(StationName) REFERENCES Station(StationName),
	CONSTRAINT fk_SpotStation FOREIGN KEY(ClassName) REFERENCES Class(ClassName)
);

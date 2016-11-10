CREATE TABLE Subscriber(
	CreditCard VARCHAR(30) PRIMARY KEY,
	Lastname Varchar(20),
	Firstname VARCHAR(20),
	Birthdate VARCHAR(20),
	Adress VARCHAR(50)
);

CREATE TABLE Vehicule(
	IdVehicule INTEGER PRIMARY KEY,
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
	StartDate DATE,
	EndDate DATE
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
);

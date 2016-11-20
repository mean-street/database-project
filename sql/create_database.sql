-- DROP all tables
-- @drop_database

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

CREATE TABLE UserClassLimitedRate(
	CreditCard VARCHAR(30) NOT NULL,
	ClassName VARCHAR(20) NOT NULL,
	Duration INTEGER NOT NULL,
	StartDate DATE NOT NULL,
	Price FLOAT NOT NULL,
	Reduction FLOAT NOT NULL,
	CONSTRAINT pk_UserClassLimitedRate PRIMARY KEY(CreditCard,ClassName),
	CONSTRAINT fk_LimitedRateUser FOREIGN KEY(CreditCard) REFERENCES Subscriber(CreditCard),
	CONSTRAINT fk_LimitedRateClass FOREIGN KEY(ClassName) REFERENCES VehicleClass(ClassName),
	CONSTRAINT ck_UserClassLimitedRatePrice CHECK (Price > 0),
	CONSTRAINT ck_ReductionMin CHECK (Reduction >= 0),
	CONSTRAINT ck_ReductionMax CHECK (Reduction < 1)
);

CREATE TABLE UserClassIllimitedRate(
	CreditCard VARCHAR(30) NOT NULL,
	ClassName VARCHAR(20) NOT NULL,
	NbLocation INTEGER NOT NULL,
	Price FLOAT NOT NULL,
	CONSTRAINT pk_UserClassIllimitedRate PRIMARY KEY(CreditCard,ClassName),
	CONSTRAINT fk_IllimitedRateUser FOREIGN KEY(CreditCard) REFERENCES Subscriber(CreditCard),
	CONSTRAINT fk_IllimitedRateClass FOREIGN KEY(ClassName) REFERENCES VehicleClass(ClassName),
	CONSTRAINT ck_UCIRNbLocation CHECK (NbLocation > 0),
	CONSTRAINT ck_UCIRPrice CHECK (Price > 0)
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
-- @inserts_database

-- Facturation d'une location
SELECT	Location.IdLocation
FROM	Location, StationLocation
WHERE	Location.IdLocation = 2
AND 	Location.IdLocation = StationLocation.IdLocation;

SELECT 	UserClassIllimitedRate.NbLocation
FROM	Subscriber, Location, Vehicle, UserClassIllimitedRate
WHERE 	Location.IdLocation = 2
AND		Subscriber.CreditCard = Location.CreditCard
AND		Vehicle.IdVehicle = Location.IdVehicle
AND		Subscriber.CreditCard = UserClassIllimitedRate.CreditCard
AND 	UserClassIllimitedRate.ClassName = Vehicle.ClassName;

SELECT 	CASE WHEN (MONTHS_BETWEEN(CURRENT_DATE, S.Birthdate)/12 < 25 OR MONTHS_BETWEEN(CURRENT_DATE, S.Birthdate)/12 > 65)
			THEN
				CASE WHEN (CURRENT_DATE - L.StartDate) * 24 <= 1
					THEN 0
					ELSE
						CASE WHEN UCIR.Reduction > 0
							THEN
								CASE WHEN (CURRENT_DATE - L.StartDate) > (VC.MaxDuration/24)
									THEN (((CURRENT_DATE - L.StartDate) * 24 - 1) * VC.HourlyPrice * 0.75 * UCIR.Reduction) + VC.Deposit
									ELSE (((CURRENT_DATE - L.StartDate) * 24 - 1) * VC.HourlyPrice * 0.75 * UCIR.Reduction)
								END
							ELSE
								CASE WHEN (CURRENT_DATE - L.StartDate) > (VC.MaxDuration/24)
									THEN (((CURRENT_DATE - L.StartDate) * 24 - 1) * VC.HourlyPrice * 0.75) + VC.Deposit
									ELSE (((CURRENT_DATE - L.StartDate) * 24 - 1) * VC.HourlyPrice * 0.75)
								END
						END
				END
			ELSE
				CASE WHEN (CURRENT_DATE - L.StartDate) * 24 <= 1
					THEN 0
					ELSE
						CASE WHEN UCIR.Reduction > 0
							THEN
								CASE WHEN (CURRENT_DATE - L.StartDate) > (VC.MaxDuration/24)
									THEN (((CURRENT_DATE - L.StartDate) * 24 - 1) * VC.HourlyPrice * UCIR.Reduction) + VC.Deposit
									ELSE (((CURRENT_DATE - L.StartDate) * 24 - 1) * VC.HourlyPrice * UCIR.Reduction)
								END
							ELSE
							CASE WHEN (CURRENT_DATE - L.StartDate) > (VC.MaxDuration/24)
								THEN (((CURRENT_DATE - L.StartDate) * 24 - 1) * VC.HourlyPrice) + VC.Deposit
								ELSE (((CURRENT_DATE - L.StartDate) * 24 - 1) * VC.HourlyPrice)
							END
						END
				END
		END AS PRICE
FROM Location L
INNER JOIN Vehicle V ON V.IdVehicle = L.IdVehicle
INNER JOIN VehicleClass VC ON VC.ClassName = V.ClassName
INNER JOIN Subscriber S ON S.CreditCard = L.CreditCard
LEFT JOIN UserClassLimitedRate UCIR ON (UCIR.CreditCard = S.CreditCard AND UCIR.ClassName = V.ClassName)
WHERE L.IdLocation = 2;

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

-- Taux d'occupation des stations dans la journée
SELECT 	EndStationName,
		COUNT(IdVehicle)
FROM (	SELECT 	StationLocation.EndStationName,
				Location.IdVehicle
		FROM 	StationLocation, Location
		WHERE 	StationLocation.IdLocation = Location.IdLocation
		AND		StationLocation.EndDate = (SELECT MAX(S.EndDate)
											FROM 	StationLocation S, Location L
											WHERE 	S.IdLocation = L.IdLocation
											AND		L.IdVehicle = Location.IdVehicle
											AND 	S.EndDate <= TO_DATE('15/11/2016 12:00', 'dd/mm/yyyy hh24:mi'))
		AND	    Location.IdVehicle NOT IN (SELECT 	L.IdVehicle
											FROM 	StationLocation S, Location L
											WHERE	L.IdLocation = S.IdLocation
											AND		L.StartDate <= TO_DATE('15/11/2016 12:00', 'dd/mm/yyyy hh24:mi')
											AND		S.EndDate > TO_DATE('15/11/2016 12:00', 'dd/mm/yyyy hh24:mi'))
		AND		Location.IdVehicle NOT IN (SELECT 	L.IdVehicle
											FROM 	Location L
											WHERE	L.StartDate <= TO_DATE('15/11/2016 12:00', 'dd/mm/yyyy hh24:mi')
											AND		L.IdLocation NOT IN (SELECT S.IdLocation
																		FROM	StationLocation S))
		UNION
		SELECT	StationVehicle.StationName,
				Vehicle.IdVehicle
		FROM	Vehicle, StationVehicle
		WHERE	StationVehicle.IdVehicle = Vehicle.IdVehicle
		AND		Vehicle.IdVehicle NOT IN (SELECT 	L.IdVehicle
											FROM 	Location L
											WHERE 	L.StartDate <= TO_DATE('15/11/2016 12:00', 'dd/mm/yyyy hh24:mi')))
GROUP BY EndStationName;

-- Vérifier que les vehicules garés ont le droit d'être garé là
SELECT  StationVehicle.StationName,
		Vehicle.ClassName,
		StationClass.MaxSpots,
		COUNT(Vehicle.IdVehicle)
FROM    Vehicle, StationVehicle, StationClass
WHERE   Vehicle.IdVehicle = StationVehicle.IdVehicle
AND		StationVehicle.StationName = StationClass.StationName
AND		StationClass.ClassName = Vehicle.ClassName
GROUP BY StationVehicle.StationName, Vehicle.ClassName, StationClass.MaxSpots;

-- 2) Vérifier que les stations où les véhicules sont garés sont cohérentes
-- par rapport aux locations terminées
SELECT 	Location.IdVehicle,
		StationLocation.EndStationName,
		StationVehicle.StationName
FROM 	Location
INNER JOIN StationLocation ON StationLocation.IdLocation = Location.IdLocation
LEFT JOIN StationVehicle ON (StationVehicle.IdVehicle = Location.IdVehicle AND StationVehicle.StationName = StationLocation.EndStationName)
WHERE	StationLocation.EndDate = (SELECT MAX(S.EndDate)
									FROM 	StationLocation S, Location L
									WHERE 	S.IdLocation = L.IdLocation
									AND		L.IdVehicle = Location.IdVehicle)
AND		Location.IdVehicle NOT IN (SELECT 	L.IdVehicle
									FROM 	Location L
									WHERE	L.IdLocation NOT IN (SELECT S.IdLocation
																FROM	StationLocation S));

-- Vérifier qu'il y a au plus un forfait par catégorie et par abonné
SELECT	Subscriber.CreditCard,
		UserClassLimitedRate.ClassName
FROM	Subscriber, UserClassLimitedRate
WHERE	UserClassLimitedRate.CreditCard = Subscriber.CreditCard
AND		UserClassLimitedRate.ClassName IN (SELECT UCIR.ClassName
											FROM UserClassIllimitedRate UCIR
											WHERE UCIR.CreditCard = Subscriber.CreditCard);

-- Vérifier qu'il n'y a pas de forfait terminer
SELECT	Subscriber.CreditCard,
		TO_CHAR(UserClassLimitedRate.StartDate + UserClassLimitedRate.Duration, 'dd/mm/yyyy'),
		CASE WHEN (UserClassLimitedRate.StartDate + UserClassLimitedRate.Duration) < CURRENT_DATE
			THEN 1
			ELSE 0
		END AS isFinished
FROM	Subscriber, UserClassLimitedRate
WHERE	UserClassLimitedRate.CreditCard = Subscriber.CreditCard;

SELECT	Subscriber.CreditCard,
		UserClassIllimitedRate.NbLocation,
		CASE WHEN UserClassIllimitedRate.NbLocation <= 0
			THEN 1
			ELSE 0
		END AS isFinished
FROM	Subscriber, UserClassIllimitedRate
WHERE	UserClassIllimitedRate.CreditCard = Subscriber.CreditCard;

-- Pas deux locations pour le même vehicule en même temps
SELECT 	Location.IdLocation,
		Location.IdVehicle
FROM 	Location
WHERE	Location.IdVehicle IN (SELECT L.IdVehicle
								FROM Location L, StationLocation SL
								WHERE SL.IdLocation = L.IdLocation
								AND L.IdLocation <> Location.IdLocation
								AND	Location.StartDate > L.StartDate
								AND	Location.StartDate < SL.EndDate)
OR     Location.IdVehicle IN (SELECT L.IdVehicle
								FROM Location L
								WHERE L.IdLocation NOT IN (SELECT SL.IdLocation
															FROM StationLocation SL)
								AND L.IdLocation <> Location.IdLocation
								AND	Location.StartDate > L.StartDate)
ORDER BY 1;

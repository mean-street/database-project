Fonctionnalités requises
========================

1 - Facturation d'une location
------------------------------
Explication FORUM: Il s'agit ici de calculer le montant de la facture correspondant à une location qui se termine. La facturation des anciennes locations n'est pas indispensable.

<!-- VERSION 1 : ne retourne que les données, le calcul se ferait en java -->
<!-- Input : idLocationInput -->
<!-- Output : StartDate, MaxDuration, HourlyPrice, Deposit -->
<!-- 	SELECT StartDate, MaxDuration, HourlyPrice, Deposit -->
<!-- 	FROM VehicleClass, Vehicle, Location -->
<!-- 	WHERE Location.IdLocation = idLocationInput -->
<!-- 	AND VehicleClass.ClassName = Vehicle.ClassName -->
<!-- 	AND Location.IdVehicle = Vehicle.IdVehicle; -->

VERSION 2 : calcul le prix total
Input: IdLocation
Output: Price
1) Vérifier que la location n'a pas déjà été facturé
INFO: Si la requete renvoie une ligne c'est que la location a déjà été facturé
	SELECT	Location.IdLocation
	FROM	Location
	WHERE	Location.IdLocation = 2;

2) Vérifier si il existe un forfait (UserClassIllimitedRate) en cours
INFO: La requete renvoie le NbLocation du forfait si le forfait existe
	SELECT 	UserClassIllimitedRate.NbLocation
	FROM	Subscriber, Location, Vehicle, UserClassIllimitedRate
	WHERE 	Location.IdLocation = 2
	AND		Subscriber.CreditCard = Location.CreditCard
	AND		Vehicle.IdVehicle = Location.IdVehicle
	AND		Subscriber.CreditCard = UserClassIllimitedRate.CreditCard
	AND 	UserClassIllimitedRate.ClassName = Vehicle.ClassName;

3) Si il n'y a pas de forfait (UserClassIllimitedRate) alors on applique la tarification
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

2 - Temps moyen d'utilisation par véhicule par mois
---------------------------------------------------
Explication FORUM: Il s'agit de calculer la durée de location d'un véhicule durant un mois calendaire donné.

VERSION 1 : retourne la valeur pour un mois donné
Input : MonthYearInput (format YYYY-MM)
Output : tuples (ID of the vehicle, average time of use)
	SELECT 	Vehicle.IdVehicle,COUNT(Location.IdLocation),
			SUM(StationLocation.EndDate - Location.StartDate) / COUNT(Location.IdLocation)
	FROM Location, StationLocation, Vehicle
	WHERE Location.IdLocation = StationLocation.IdLocation
	AND Vehicle.IdVehicle = Location.IdVehicle
	AND TO_CHAR(Location.StartDate, 'YYYY-MM') = MonthYearInput
	GROUP BY Vehicle.IdVehicle;

<!-- VERSION 2 : retourne la valeur pour tous les mois -->
<!-- SELECT TO_CHAR(Location.StartDate, 'YYYY-MM') AS Month, -->
<!-- 		Vehicle.IdVehicle AS IdVehicle, -->
<!-- 		SUM(StationLocation.EndDate - Location.StartDate) / COUNT(Location.IdLocation) AS AverageDuration, -->
<!-- 		COUNT(Location.IdLocation) AS NbLocation -->
<!-- FROM Location, StationLocation, Vehicle -->
<!-- WHERE Location.IdLocation = StationLocation.IdLocation -->
<!-- AND Vehicle.IdVehicle = Location.IdVehicle -->
<!-- GROUP BY TO_CHAR(Location.StartDate, 'YYYY-MM'), Vehicle.IdVehicle; -->

3 - Temps moyen d'utilisation par catégorie de véhicule par mois
----------------------------------------------------------------
Explication FORUM: Il s'agit de calculer la durée de location moyenne d'un véhicule d'une catégorie donnée lors d'un mois calendaire donné.

VERSION 1 : retourne la valeur pour un mois donné
Input : MonthYearInput (format YYYY-MM)
Output : tuples (name of the class, average time of use)
	SELECT 	Vehicle.ClassName,
			SUM(StationLocation.EndDate - Location.StartDate) / COUNT(Location.IdLocation)
	FROM Location, StationLocation, Vehicle
	WHERE Location.IdLocation = StationLocation.IdLocation
	AND Vehicle.IdVehicle = Location.IdVehicle
	AND TO_CHAR(Location.StartDate, 'YYYY-MM') = MonthYearInput
	GROUP BY Vehicle.ClassName;

<!-- VERSION 2 : retourne la valeur pour tous les mois -->
<!-- SELECT TO_CHAR(Location.StartDate, 'YYYY-MM') AS Month, -->
<!-- 		Vehicle.ClassName AS VehicleClass, -->
<!-- 		SUM(StationLocation.EndDate - Location.StartDate) / COUNT(Location.IdLocation) AS AverageDuration, -->
<!-- 		COUNT(Location.IdLocation) AS NbLocation -->
<!-- FROM Location, StationLocation, Vehicle -->
<!-- WHERE Location.IdLocation = StationLocation.IdLocation -->
<!-- AND Vehicle.IdVehicle = Location.IdVehicle -->
<!-- GROUP BY TO_CHAR(Location.StartDate, 'YYYY-MM'), Vehicle.ClassName; -->

4 - Catégorie de véhicule la plus utilisée par tranche d'age de 10 ans
----------------------------------------------------------------------
Explication FORUM: Ce calcul prend en compte la durée de location des véhicules concernés.

VERSION 1 : prend une date d'entrée, et calcule sur cette date + 10 ans
Input : StartDateInput (format Date)
Output : tuples (name of the class, total time of use)
	SELECT 	Vehicle.ClassName AS Class,
			SUM(StationLocation.EndDate - Location.StartDate)
	FROM Location, StationLocation, Vehicle
	WHERE Location.IdLocation = StationLocation.IdLocation
	AND Vehicle.IdVehicle = Location.IdVehicle
	AND Location.StartDate > StartDateInput
	AND StationLocation.EndDate < add_months(StartDateInput, 120)
	GROUP BY Vehicle.ClassName;

<!-- VERSION 2 : calcule sur la date d'aujourd'hui - 10 ans -->
<!-- 	SELECT MAX(SUM(StationLocation.EndDate - Location.StartDate)) AS AverageDuration -->
<!-- 	FROM Location, StationLocation, Vehicle -->
<!-- 	WHERE Location.IdLocation = StationLocation.IdLocation -->
<!-- 	AND Vehicle.IdVehicle = Location.IdVehicle -->
<!-- 	AND Location.StartDate > add_months(CURRENT_DATE, -120) -->
<!-- 	GROUP BY Vehicle.ClassName; -->

5 - Taux d'occupation des stations dans la journée
--------------------------------------------------
Explication FORUM: Il s'agit de calculer le rapport entre le nombre de places occupées (au maximum) et le nombre de places totales disponibles dans une station sur une journée.

<!-- VERSION 1 : calcule le nombre de véhicules par station à une date DateInput -->
<!-- Input : DateInput -->
<!-- Output : tuples (Station, occupancy rate) -->
<!--  -->
<!-- 	SELECT 	EndStationName, -->
<!-- 			COUNT(IdVehicle) -->
<!-- 	FROM (	SELECT 	StationLocation.EndStationName, -->
<!-- 					Location.IdVehicle -->
<!-- 			FROM 	StationLocation, Location -->
<!-- 			WHERE 	StationLocation.IdLocation = Location.IdLocation -->
<!-- 			AND		StationLocation.EndDate = (SELECT MAX(S.EndDate) -->
<!-- 												FROM 	StationLocation S, Location L -->
<!-- 												WHERE 	S.IdLocation = L.IdLocation -->
<!-- 												AND		L.IdVehicle = Location.IdVehicle -->
<!-- 												AND 	S.EndDate <= DateInput) -->
<!-- 			AND	    Location.IdVehicle NOT IN (SELECT 	L.IdVehicle -->
<!-- 												FROM 	StationLocation S, Location L -->
<!-- 												WHERE	L.IdLocation = S.IdLocation -->
<!-- 												AND		L.StartDate <= DateInput -->
<!-- 												AND		S.EndDate > DateInput) -->
<!-- 			AND		Location.IdVehicle NOT IN (SELECT 	L.IdVehicle -->
<!-- 												FROM 	Location L -->
<!-- 												WHERE	L.StartDate <= DateInput -->
<!-- 												AND		L.IdLocation NOT IN (SELECT S.IdLocation -->
<!-- 																			FROM	StationLocation S)) -->
<!-- 			UNION -->
<!-- 			SELECT	StationVehicle.StationName, -->
<!-- 					Vehicle.IdVehicle -->
<!-- 			FROM	Vehicle, StationVehicle -->
<!-- 			WHERE	StationVehicle.IdVehicle = Vehicle.IdVehicle -->
<!-- 			AND		Vehicle.IdVehicle NOT IN (SELECT 	L.IdVehicle -->
<!-- 												FROM 	Location L -->
<!-- 												WHERE 	L.StartDate <= DateInput)) -->
<!-- 	GROUP BY EndStationName; -->


VERSION 2 : retourne le taux d'occupation
(faire les étapes 1 à 3 uniquement lors de la fin d'une location)
Input : StationNameInput

1) Récupérer les dernières infos pour une Station
	SELECT  StationOccupation.StationName,
	        StationOccupation.Day,
	        StationOccupation.CurrentOccupation,
	        StationOccupation.MaxOccupation
	FROM    StationOccupation
	WHERE   StationOccupation.StationName = StationNameInput
	AND     StationOccupation.Day = (SELECT MAX(SO.Day)
										FROM 	StationOccupation SO
										WHERE 	SO.StationName = StationOccupation.StationName);

2) Si aucune ligne apparait à l'étape 1:
	INSERT INTO StationOccupation (StationName, Day, CurrentOccupation, MaxOccupation)
	VALUES (StationNameInput, TRUNC(CURRENT_DATE), 1, 1);

3) Si une ligne apparait à l'étape 1:
	Si la date (colonne 2) correspond à la date d'aujourd'hui
		Si le CurrentOccupation (colonne 3) + 1 > MaxOccupation (colonne 4)
			UPDATE	StationOccupation
			SET 	CurrentOccupation = CurrentOccupation de l'étape(1) + 1,
					MaxOccupation = CurrentOccupation de l'étape(1) + 1
			WHERE 	StationName = StationNameInput
			AND 	Day = TRUNC(CURRENT_DATE) --Day de l'étape(1)
		Sinon
			UPDATE	StationOccupation
			SET 	CurrentOccupation = CurrentOccupation de l'étape(1) + 1,
			WHERE 	StationName = StationNameInput
			AND 	Day = TRUNC(CURRENT_DATE) --Day de l'étape(1)
	Sinon
		INSERT INTO StationOccupation (StationName, Day, CurrentOccupation, MaxOccupation)
		VALUES (StationNameInput, TRUNC(CURRENT_DATE), CurrentOccupation de l'étape(1) + 1, CurrentOccupation de l'étape(1) + 1);

4) Récupérer le rapport demandé
Input : dateInput, stationNameInput
Output : tupes (station, ratio)
	SELECT	StationOccupation.StationName,
			StationOccupation.MaxOccupation / SUM(StationClass.MaxSpots) AS RAPPORT
	FROM 	StationOccupation, StationClass
	WHERE	StationOccupation.StationName = StationClass.StationName
	AND		StationClass.StationName = StationInput
	AND		StationOccupation.Day = TO_DATE(dateInput, 'dd/mm/yyyy')
	GROUP BY StationOccupation.StationName, StationOccupation.MaxOccupation;

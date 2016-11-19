Fonctionnalités requises
========================
Everything seems to work

1 - Facturation d'une location
------------------------------
Explication FORUM: Il s'agit ici de calculer le montant de la facture correspondant à une location qui se termine. La facturation des anciennes locations n'est pas indispensable.

<!-- VERSION 1 -->
<!-- Input : idLocationInput -->
<!-- Output : StartDate, MaxDuration, HourlyPrice, Deposit -->
<!-- 	SELECT StartDate, MaxDuration, HourlyPrice, Deposit -->
<!-- 	FROM VehicleClass, Vehicle, Location -->
<!-- 	WHERE Location.IdLocation = idLocationInput -->
<!-- 	AND VehicleClass.ClassName = Vehicle.ClassName -->
<!-- 	AND Location.IdVehicle = Vehicle.IdVehicle; -->

VERSION 2 => à implémenter
Input: IdLocation
Output: Price
1) Vérifier que la location n'a pas déjà été facturé
INFO: Si la requete renvoie une ligne c'est que la location a déjà été facturé
	SELECT	Location.IdLocation
	FROM	Location, StationLocation
	WHERE	Location.IdLocation = 2
	AND 	Location.IdLocation = StationLocation.IdLocation;

2) Vérifier si il existe un forfait (UserClassLimitedRate) en cours
INFO: La requete renvoie le NbLocation du forfait si le forfait existe
	SELECT 	UserClassLimitedRate.NbLocation
	FROM	Subscriber, Location, Vehicle, UserClassLimitedRate
	WHERE 	Location.IdLocation = 2
	AND		Subscriber.CreditCard = Location.CreditCard
	AND		Vehicle.IdVehicle = Location.IdVehicle
	AND		Subscriber.CreditCard = UserClassLimitedRate.CreditCard
	AND 	UserClassLimitedRate.ClassName = Vehicle.ClassName;

3) Si il n'y a pas de forfait (UserClassLimitedRate) alors on applique la tarification
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
	LEFT JOIN UserClassIllimitedRate UCIR ON (UCIR.CreditCard = S.CreditCard AND UCIR.ClassName = V.ClassName)
	WHERE L.IdLocation = 2;

4) INSERT dans StationLocation


2 - Temps moyen d'utilisation par véhicule par mois
---------------------------------------------------
Explication FORUM: Il s'agit de calculer la durée de location d'un véhicule durant un mois calendaire donné.

VERSION 1 => à implémenter
Input : MonthYearInput (format YYYY-MM)
Output : tuples (ID of the vehicle, average time of use)
	SELECT 	Vehicle.IdVehicle,COUNT(Location.IdLocation),
			SUM(StationLocation.EndDate - Location.StartDate) / COUNT(Location.IdLocation)
	FROM Location, StationLocation, Vehicle
	WHERE Location.IdLocation = StationLocation.IdLocation
	AND Vehicle.IdVehicle = Location.IdVehicle
	AND TO_CHAR(Location.StartDate, 'YYYY-MM') = MonthYearInput
	GROUP BY Vehicle.IdVehicle;

<!-- VERSION 2 -->
<!-- SELECT 	TO_CHAR(Location.StartDate, 'YYYY-MM') AS Month, -->
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

VERSION 1 => à implémenter
Input : MonthYearInput (format YYYY-MM)
Output : tuples (name of the class, average time of use)
	SELECT 	Vehicle.ClassName,
			SUM(StationLocation.EndDate - Location.StartDate) / COUNT(Location.IdLocation)
	FROM Location, StationLocation, Vehicle
	WHERE Location.IdLocation = StationLocation.IdLocation
	AND Vehicle.IdVehicle = Location.IdVehicle
	AND TO_CHAR(Location.StartDate, 'YYYY-MM') = MonthYearInput
	GROUP BY Vehicle.ClassName;

<!-- VERSION 2 -->
<!-- SELECT 	TO_CHAR(Location.StartDate, 'YYYY-MM') AS Month, -->
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

VERSION 1
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

<!-- VERSION 2 -->
<!-- 	SELECT MAX(SUM(StationLocation.EndDate - Location.StartDate)) AS AverageDuration -->
<!-- 	FROM Location, StationLocation, Vehicle -->
<!-- 	WHERE Location.IdLocation = StationLocation.IdLocation -->
<!-- 	AND Vehicle.IdVehicle = Location.IdVehicle -->
<!-- 	AND Location.StartDate > add_months(CURRENT_DATE, -120) -->
<!-- 	GROUP BY Vehicle.ClassName; -->

5 - Taux d'occupation des stations dans la journée ???
--------------------------------------------------
Explication FORUM: Il s'agit de calculer le rapport entre le nombre de places occupées (au maximum) et le nombre de places totales disponibles dans une station sur une journée.

Input : null
Output : tuples (Station, occupancy rate)
	SELECT Station.StationName, COUNT(StationVehicle.IdVehicle)
	FROM Station, StationVehicle, StationClass
	WHERE Station.StationName = StationClass.StationName
	AND Station.StationName = StationVehicle.StationName
	GROUP BY Station.StationName;

VERSION 2
A FINIR

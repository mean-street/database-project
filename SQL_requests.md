Fonctionnalités requises
========================

Facturation d'une location => OK
--------------------------
Input : idLocationInput
Output : StartDate, MaxDuration, HourlyPrice, Deposit
	SELECT StartDate, MaxDuration, HourlyPrice, Deposit
	FROM VehicleClass, Vehicle, Location
	WHERE Location.IdLocation = idLocationInput
	AND VehicleClass.ClassName = Vehicle.ClassName
	AND Location.IdVehicle = Vehicle.IdVehicle;

Temps moyen d'utilisation par véhicule par mois => OK
-----------------------------------------------
Input : null
Output : tuples (Month/Year, ID of the vehicle, average time of use)
	SELECT 	TO_CHAR(Location.StartDate, 'YYYY-MM') AS Date,
			Vehicle.IdVehicle AS Vehicle,
			COUNT(StationLocation.EndDate - Location.StartDate) / COUNT(Location.IdLocation) AS AverageTimeOfUse
	FROM Location, StationLocation, Vehicle
	WHERE Location.IdLocation = StationLocation.IdLocation
	AND Vehicle.IdVehicle = Location.IdVehicle
	GROUP BY to_char(Location.StartDate, 'YYYY-MM'), Vehicle.IdVehicle;

Temps moyen d'utilisation par catégorie de véhicule par mois => OK
------------------------------------------------------------
Input : null
Output : tuples (Month/Year, name of the class, average time of use)
	SELECT 	TO_CHAR(Location.StartDate, 'YYYY-MM') AS Date,
			Vehicle.ClassName AS VehicleClass,
			SUM(StationLocation.EndDate - Location.StartDate) / COUNT(Location.IdLocation) AS AverageTimeOfUse
	FROM Location, StationLocation, Vehicle
	WHERE Location.IdLocation = StationLocation.IdLocation
	AND Vehicle.IdVehicle = Location.IdVehicle
	GROUP BY to_char(Location.StartDate, 'YYYY-MM'), Vehicle.ClassName;

Catégorie de véhicule la plus utilisée par tranche d'age de 10 ans
------------------------------------------------------------------
Input : StartDateInput, EndDateInput
Output : tuples (name of the most used class, total time of use)
	SELECT 	Vehicle.ClassName AS Class,
			MAX(SUM(StationLocation.EndDate - Location.StartDate)) AS UseTime
	FROM Location, StationLocation, Vehicle
	WHERE Location.IdLocation = StationLocation.IdLocation
	AND Vehicle.IdVehicle = Location.IdVehicle
	AND Location.StartDate > StartDateInput
	AND StationLocation.EndDate < EndDateInput
	GROUP BY Vehicle.ClassName;

Taux d'occupation des stations dans la journée
----------------------------------------------
Input : null
Output : tuples (Station, occupancy rate)
	SELECT Station.StationName, COUNT(StationVehicle.IdVehicle)
	FROM Station, StationVehicle, StationClass
	WHERE Station.StationName = StationClass.StationName
	AND Station.StationName = StationVehicle.StationName
	GROUP BY Station.StationName;


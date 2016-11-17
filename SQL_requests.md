Fonctionnalités requises
========================

	set transaction isolation level ???;
	set autocommit off;

Facturation d'une location
--------------------------
Input : idLocationInput
Output : StartDate, MaxDuration, HourlyPrice, Deposit
	begin;
	SELECT StartDate, MaxDuration, HourlyPrice, Deposit

	FROM VehicleClass, Vehicle, Location

	WHERE Location.IdLocation = idLocationInput
	AND VehicleClass.ClassName = Vehicle.ClassName
	AND Location.IdVehicle = Vehicle.IdVehicle;
	commit;

Temps moyen d'utilisation par véhicule par mois
-----------------------------------------------
Input : null
Output : tuples (Month/Year, ID of the vehicle, average time of use)
	begin;
	SELECT 	to_char(Location.StartDate, 'YYYY-MM'),
			Vehicle.IdVehicle,
			sum(Location.StartDate - StationLocation.EndDate) / count(Location.IdLocation)

	FROM Location, StationLocation, Vehicle

	WHERE Location.IdLocation = StationLocation.IdLocation
	AND Vehicle.IdVehicle = Location.IdVehicule

	GROUP BY to_char(Location.StartDate, 'YYYY-MM'), Vehicle.IdVehicle;
	commit;

Temps moyen d'utilisation par catégorie de véhicule par mois
------------------------------------------------------------
Input : null
Output : tuples (Month/Year, name of the class, average time of use)
	begin;
	SELECT 	to_char(Location.StartDate, 'YYYY-MM'),
			Vehicle.ClassName,
			sum(Location.StartDate - StationLocation.EndDate) / count(Location.IdLocation)

	FROM Location, StationLocation, Vehicle

	WHERE Location.IdLocation = StationLocation.IdLocation
	AND Vehicle.IdVehicle = Location.IdVehicule

	GROUP BY to_char(Location.StartDate, 'YYYY-MM'), Vehicle.ClassName;
	commit;

Catégorie de véhicule la plus utilisée par tranche d'age de 10 ans
------------------------------------------------------------------
Input : null
Output : tuples (Decade, name of the class, total time of use)
	begin;
	SELECT Decade, Class, MAX(UseTime)

	FROM (
			SELECT 	to_char(extract(year FROM Location.StartDate) / 10 * 10) AS Decade,
					Vehicle.ClassName AS Class,
					sum(Location.StartDate - StationLocation.EndDate) AS UseTime

			FROM Location, StationLocation, Vehicle

			WHERE Location.IdLocation = StationLocation.IdLocation
			AND Vehicle.IdVehicle = Location.IdVehicle

			GROUP BY extract(year FROM Location.StartDate) / 10, Vehicle.ClassName;
	)

	GROUP BY Decade;
	commit;

Taux d'occupation des stations dans la journée
----------------------------------------------
Input : null
Output : tuples (Station, occupancy rate)
	begin;
	SELECT Station.StationName, COUNT(StationVehicle.IdVehicle) / StationClass.MaxSpots

	FROM Station, StationVehicle, StationClass

	WHERE Station.StationName = StationClass.StationName
	AND Station.StationName = StationVehicle.StationName

	GROUP BY Station.StationName;
	commit;


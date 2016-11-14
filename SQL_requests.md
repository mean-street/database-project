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
Output : tuples (Month/Year, ClassName, average time of use)
	begin;
	SELECT 	to_char(Location.StartDate, 'YYYY-MM'),
			Vehicle.ClassName,
			sum(Location.StartDate - StationLocation.EndDate) / count(Location.IdLocation)
	FROM Location, StationLocation, Vehicle
	WHERE Location.IdLocation = StationLocation.IdLocation
	AND Vehicle.IdVehicle = Location.IdVehicule
	GROUP BY to_char(Location.StartDate, 'YYYY-MM'), Vehicle.ClassName;
	commit;

Temps moyen d'utilisation par catégorie de véhicule par mois
------------------------------------------------------------
	begin;

	commit;

Catégorie de véhicule la plus utilisée par tranche d'age de 10 ans
------------------------------------------------------------------
	begin;
	...
	commit;

Taux d'occupation des stations dans la journée
----------------------------------------------
	begin;
	...
	commit;


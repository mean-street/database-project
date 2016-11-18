SELECT Vehicle.ClassName, SUM(StationLocation.EndDate - Location.StartDate)
FROM Location, StationLocation, Vehicle
WHERE Location.IdLocation = StationLocation.IdLocation
AND Vehicle.IdVehicle = Location.IdVehicle
GROUP BY Vehicle.ClassName;

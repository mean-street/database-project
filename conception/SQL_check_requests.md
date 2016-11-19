1) Vérifier que les vehicules garés ont le droit d'être garé là
CHECK: Vérifier que la dernière colonnes est bien inférieure ou égale à l'avant-dernière

SELECT  StationVehicle.StationName,
		Vehicle.ClassName,
		StationClass.MaxSpots,
		COUNT(Vehicle.IdVehicle)
FROM    Vehicle, StationVehicle, StationClass
WHERE   Vehicle.IdVehicle = StationVehicle.IdVehicle
AND		StationVehicle.StationName = StationClass.StationName
AND		StationClass.ClassName = Vehicle.ClassName
GROUP BY StationVehicle.StationName, Vehicle.ClassName, StationClass.MaxSpots;

2) Vérifier que les stations où les véhicules sont garés sont cohérentes
par rapport aux locations terminées
CHECK: Vérifier que les deux dernières colonnes sont identiques lignes par lignes

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

3) Vérifier qu'il y a au plus un forfait par catégorie et par abonné
CHECK: Si au moins un ligne apparait => ERREUR

SELECT	Subscriber.CreditCard,
		UserClassLimitedRate.ClassName
FROM	Subscriber, UserClassLimitedRate
WHERE	UserClassLimitedRate.CreditCard = Subscriber.CreditCard
AND		UserClassLimitedRate.ClassName IN (SELECT UCIR.ClassName
											FROM UserClassIllimitedRate UCIR
											WHERE UCIR.CreditCard = Subscriber.CreditCard);

4) Vérifier qu'il n'y a pas de forfait terminer
CHECK: Colonne 'isFinished' = 1 alors ERREUR

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

5) Pas deux locations pour le même vehicule en même temps
CHECK: Si au moins un ligne apparait => ERREUR

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

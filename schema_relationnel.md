Relations (à revoir)
====================

STATION
-------
NomS (PK)
Adresse

PLACES
------
NbPlacesDispo

LOCATION
--------
idLocation (PK)
NomS (FK -> STATION.NomS)
NoCB (FK -> ABONNE.NoCB)
idV (FK -> VEHICULE.idV)
DateDebut
DateFin
HeureDebut
HeureFin

StationLocation (0..1)
---------------
NomS (FK -> STATION.NomS)
idLocation (PK) (FK -> LOCATION.idLocation)

CATEGORIE
---------
NomC (PK)
DureeMax
PrixHeure
MontantCaution

StationCategorie ( * )
----------------
NbPlacesDispo
NomS (PK) (FK -> STATION.NomS)
NomC (PK) (FK -> CATEGORIE.NomC)

VEHICULE
--------
idV	(PK)
NomC (FK -> CATEGORIE.NomC)
NbPlaces

StationVehicule (0..1)
---------------
NomS (FK -> STATION.NomS)
idV (PK) (FK -> VEHICULE.idV)

ABONNE
------
NoCB (PK)
Nom
Prenom
DateNaissance
Adresse

CategorieAbonne ( * )
---------------
NomC (PK) (FK -> CATEGORIE.NomC)
NoCB (PK) (FK -> ABONNE.NoCB)

FORFAITILLIMITE
---------------
NoCB (PK) (FK -> ABONNE.NoCB)
NomC (PK) (FK -> CATEGORIE.NomC)
Duree
DateDebut
FCT
Prix

FORFAITLOCATION
---------------
NoCB (PK) (FK -> ABONNE.NoCB)
NomC (PK) (FK -> CATEGORIE.NomC)
NbMaxLoc
Prix


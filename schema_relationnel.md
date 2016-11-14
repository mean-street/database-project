Relations
=========

Noms en CAPS LOCK = tables "classiques"
Autres noms = tables d'association

STATION
-------
NomS (PK)
Adresse

Places
------
NomS (PK) (FK -> STATION.NomS)
NomC (PK) (FK -> CATEGORIE.NomC)
NbPlacesDispo

LOCATION
--------
idLocation (PK)
NomS (FK -> STATION.NomS)
NoCB (FK -> ABONNE.NoCB)
idV (FK -> VEHICULE.idV)
DateTimeDebut

StationLocation (0..1)
---------------
NomS (FK -> STATION.NomS)
idLocation (PK) (FK -> LOCATION.idLocation)
DateTimeFin

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

ForfaitIllimite
---------------
NoCB (PK) (FK -> ABONNE.NoCB)
NomC (PK) (FK -> CATEGORIE.NomC)
Duree
DateTimeDebut
FCT
Prix

ForfaitLocation
---------------
NoCB (PK) (FK -> ABONNE.NoCB)
NomC (PK) (FK -> CATEGORIE.NomC)
NbMaxLoc
Prix


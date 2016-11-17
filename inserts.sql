-- Subscribers #################################################################
INSERT INTO Subscriber (CreditCard, LastName, FirstName, Birthdate, Adress) 
VALUES (00122478, "Mouchet", "Alexandre", TO_DATE('17/03/1993', 'dd/mm/yyyy'), "Paris");
INSERT INTO Subscriber (CreditCard, LastName, FirstName, Birthdate, Adress) 
VALUES (00482956, "Carre", "Ludovic", TO_DATE('08/07/1995', 'dd/mm/yyyy'), "Marseille");
INSERT INTO Subscriber (CreditCard, LastName, FirstName, Birthdate, Adress) 
VALUES (00996314, "Lefoulon", "Vincent", TO_DATE('24/04/1994', 'dd/mm/yyyy'), "Paris");
INSERT INTO Subscriber (CreditCard, LastName, FirstName, Birthdate, Adress) 
VALUES (00685321, "Deloche", "Maxime", TO_DATE('13/11/1996', 'dd/mm/yyyy'), "Lyon");

-- Vehicle #####################################################################
INSERT INTO Vehicle (IdVehicle, ClassName, Seats)
VALUES (1, "VeloElectrique", 1);
INSERT INTO Vehicle (IdVehicle, ClassName, Seats)
VALUES (2, "Velo", 1);
INSERT INTO Vehicle (IdVehicle, ClassName, Seats)
VALUES (3, "Velo", 1);
INSERT INTO Vehicle (IdVehicle, ClassName, Seats)
VALUES (4, "VoitureElectrique", 4);
INSERT INTO Vehicle (IdVehicle, ClassName, Seats)
VALUES (5, "Utilitaire", 8);
INSERT INTO Vehicle (IdVehicle, ClassName, Seats)
VALUES (6, "VeloElectrique", 1);

-- VehicleClass ################################################################
INSERT INTO VehicleClass(ClassName, MaxDuration, HourlyPrice, Deposit)
VALUES ("VoitureElectrique", 24, 8, 800);
INSERT INTO VehicleClass(ClassName, MaxDuration, HourlyPrice, Deposit)
VALUES ("Velo", 12, 3, 50);
INSERT INTO VehicleClass(ClassName, MaxDuration, HourlyPrice, Deposit)
VALUES ("VeloElectrique", 12, 6, 400);
INSERT INTO VehicleClass(ClassName, MaxDuration, HourlyPrice, Deposit)
VALUES ("VeloRemorque", 12, 7, 200);
INSERT INTO VehicleClass(ClassName, MaxDuration, HourlyPrice, Deposit)
VALUES ("Utilitaire", 48, 10, 1000);

-- Station #####################################################################
INSERT INTO Station(StationName, StationAddress) VALUES ("Chatelet", "Paris");
INSERT INTO Station(StationName, StationAddress) VALUES ("Austerlitz", "Paris");
INSERT INTO Station(StationName, StationAddress) VALUES ("JeanJaurès", "Lyon");

-- Location ####################################################################
-- UserClassIllimitedRate ######################################################
-- UserClassLimitedRate ########################################################
-- SubscriberClass #############################################################
-- StationVehicle ##############################################################
-- StationLocation #############################################################
-- StationClass ################################################################
-- Spot ########################################################################

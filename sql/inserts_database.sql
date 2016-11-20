-- Subscribers #################################################################
INSERT INTO Subscriber (CreditCard, LastName, FirstName, Birthdate, Address)
VALUES (001, 'Mouchet', 'Alexandre', TO_DATE('31/03/1995', 'dd/mm/yyyy'), 'Paris');
INSERT INTO Subscriber (CreditCard, LastName, FirstName, Birthdate, Address)
VALUES (002, 'Carre', 'Ludovic', TO_DATE('08/07/1995', 'dd/mm/yyyy'), 'Marseille');
INSERT INTO Subscriber (CreditCard, LastName, FirstName, Birthdate, Address)
VALUES (003, 'Lefoulon', 'Vincent', TO_DATE('24/04/1994', 'dd/mm/yyyy'), 'Paris');
INSERT INTO Subscriber (CreditCard, LastName, FirstName, Birthdate, Address)
VALUES (004, 'Deloche', 'Maxime', TO_DATE('13/11/1996', 'dd/mm/yyyy'), 'Lyon');

-- VehicleClass ################################################################
INSERT INTO VehicleClass(ClassName, MaxDuration, HourlyPrice, Deposit)
VALUES ('VoitureElectrique', 96, 8, 800);
INSERT INTO VehicleClass(ClassName, MaxDuration, HourlyPrice, Deposit)
VALUES ('Velo', 72, 3, 50);
INSERT INTO VehicleClass(ClassName, MaxDuration, HourlyPrice, Deposit)
VALUES ('VeloElectrique', 72, 6, 400);
INSERT INTO VehicleClass(ClassName, MaxDuration, HourlyPrice, Deposit)
VALUES ('VeloRemorque', 72, 7, 200);
INSERT INTO VehicleClass(ClassName, MaxDuration, HourlyPrice, Deposit)
VALUES ('Utilitaire', 96, 10, 1000);

-- Vehicle #####################################################################
INSERT INTO Vehicle (ClassName, Seats) VALUES ('VeloElectrique', 1);
INSERT INTO Vehicle (ClassName, Seats) VALUES ('Velo', 1);
INSERT INTO Vehicle (ClassName, Seats) VALUES ('Velo', 1);
INSERT INTO Vehicle (ClassName, Seats) VALUES ('VoitureElectrique', 4);
INSERT INTO Vehicle (ClassName, Seats) VALUES ('Utilitaire', 2);
INSERT INTO Vehicle (ClassName, Seats) VALUES ('VeloElectrique', 1);
INSERT INTO Vehicle (ClassName, Seats) VALUES ('VeloRemorque', 2);

-- Station #####################################################################
INSERT INTO Station (StationName, StationAddress) VALUES ('Chatelet', 'Paris');
INSERT INTO Station (StationName, StationAddress) VALUES ('Austerlitz', 'Paris');
INSERT INTO Station (StationName, StationAddress) VALUES ('JeanJaures', 'Lyon');

-- Location ####################################################################
INSERT INTO Location (StartStationName, CreditCard, IdVehicle, StartDate)
VALUES ('Austerlitz', 004, 1, TO_DATE('14/11/2016 08:05', 'dd/mm/yyyy hh24:mi'));
INSERT INTO Location (StartStationName, CreditCard, IdVehicle, StartDate)
VALUES ('Chatelet', 001, 4, TO_DATE('16/11/2016 15:14', 'dd/mm/yyyy hh24:mi'));
INSERT INTO Location (StartStationName, CreditCard, IdVehicle, StartDate)
VALUES ('Austerlitz', 002, 5, TO_DATE('14/11/2016 12:52', 'dd/mm/yyyy hh24:mi'));
INSERT INTO Location (StartStationName, CreditCard, IdVehicle, StartDate)
VALUES ('JeanJaures', 001, 2, TO_DATE('11/11/2016 05:18', 'dd/mm/yyyy hh24:mi'));
INSERT INTO Location (StartStationName, CreditCard, IdVehicle, StartDate)
VALUES ('Austerlitz', 004, 5, TO_DATE('5/11/2016 20:39', 'dd/mm/yyyy hh24:mi'));
INSERT INTO Location (StartStationName, CreditCard, IdVehicle, StartDate)
VALUES ('JeanJaures', 001, 6, TO_DATE('25/12/2015 18:02', 'dd/mm/yyyy hh24:mi'));
INSERT INTO Location (StartStationName, CreditCard, IdVehicle, StartDate)
VALUES ('Austerlitz', 003, 2, TO_DATE('05/09/2015 16:30', 'dd/mm/yyyy hh24:mi'));
INSERT INTO Location (StartStationName, CreditCard, IdVehicle, StartDate)
VALUES ('JeanJaures', 002, 4, TO_DATE('08/09/2015 12:30', 'dd/mm/yyyy hh24:mi'));
INSERT INTO Location (StartStationName, CreditCard, IdVehicle, StartDate)
VALUES ('Chatelet', 002, 1, TO_DATE('13/03/2015 17:25', 'dd/mm/yyyy hh24:mi'));
INSERT INTO Location (StartStationName, CreditCard, IdVehicle, StartDate)
VALUES ('Austerlitz', 002, 5, TO_DATE('29/08/2006 16:55', 'dd/mm/yyyy hh24:mi'));
INSERT INTO Location (StartStationName, CreditCard, IdVehicle, StartDate)
VALUES ('Chatelet', 004, 3, TO_DATE('11/01/2005 11:31', 'dd/mm/yyyy hh24:mi'));
INSERT INTO Location (StartStationName, CreditCard, IdVehicle, StartDate)
VALUES ('JeanJaures', 001, 3, TO_DATE('01/11/2016 05:18', 'dd/mm/yyyy hh24:mi'));

-- UserClassLimitedRate ######################################################
INSERT INTO UserClassLimitedRate (CreditCard, ClassName, Duration, StartDate, Price, Reduction)
VALUES (002, 'Utilitaire', 365, TO_DATE('07/07/2016 21:45', 'dd/mm/yyyy hh24:mi'), 200, 0.6);
INSERT INTO UserClassLimitedRate (CreditCard, ClassName, Duration, StartDate, Price, Reduction)
VALUES (001, 'VoitureElectrique', 365, TO_DATE('07/07/2016 21:45', 'dd/mm/yyyy hh24:mi'), 200, 0.6);

-- UserClassIllimitedRate ########################################################
INSERT INTO UserClassIllimitedRate (CreditCard, ClassName, NbLocation, Price)
VALUES (004, 'Utilitaire', 12, 100);

-- StationVehicle ##############################################################
INSERT INTO StationVehicle (IdVehicle, StationName) VALUES (2, 'Austerlitz');
INSERT INTO StationVehicle (IdVehicle, StationName) VALUES (3, 'Austerlitz');
INSERT INTO StationVehicle (IdVehicle, StationName) VALUES (5, 'Austerlitz');
INSERT INTO StationVehicle (IdVehicle, StationName) VALUES (6, 'JeanJaures');
INSERT INTO StationVehicle (IdVehicle, StationName) VALUES (7, 'Austerlitz');

-- StationLocation #############################################################
INSERT INTO StationLocation (IdLocation, EndStationName, EndDate)
VALUES (12, 'Austerlitz', TO_DATE('02/11/2016 05:18', 'dd/mm/yyyy hh24:mi'));
INSERT INTO StationLocation (IdLocation, EndStationName, EndDate)
VALUES (3, 'Austerlitz', TO_DATE('15/11/2016 12:52', 'dd/mm/yyyy hh24:mi'));
INSERT INTO StationLocation (IdLocation, EndStationName, EndDate)
VALUES (4, 'Austerlitz', TO_DATE('12/11/2016 17:56', 'dd/mm/yyyy hh24:mi'));
INSERT INTO StationLocation (IdLocation, EndStationName, EndDate)
VALUES (5, 'Austerlitz', TO_DATE('07/11/2016 15:26', 'dd/mm/yyyy hh24:mi'));
INSERT INTO StationLocation (IdLocation, EndStationName, EndDate)
VALUES (9, 'JeanJaures', TO_DATE('15/03/2015 21:40', 'dd/mm/yyyy hh24:mi'));
INSERT INTO StationLocation (IdLocation, EndStationName, EndDate)
VALUES (8, 'Chatelet', TO_DATE('10/09/2015 18:30', 'dd/mm/yyyy hh24:mi'));
INSERT INTO StationLocation (IdLocation, EndStationName, EndDate)
VALUES (6, 'JeanJaures', TO_DATE('01/01/2016 18:02', 'dd/mm/yyyy hh24:mi'));
INSERT INTO StationLocation (IdLocation, EndStationName, EndDate)
VALUES (11, 'Austerlitz', TO_DATE('13/01/2005 11:21', 'dd/mm/yyyy hh24:mi'));
INSERT INTO StationLocation (IdLocation, EndStationName, EndDate)
VALUES (10, 'JeanJaures', TO_DATE('30/08/2006 21:21', 'dd/mm/yyyy hh24:mi'));
INSERT INTO StationLocation (IdLocation, EndStationName, EndDate)
VALUES (7, 'Chatelet', TO_DATE('05/09/2015 18:30', 'dd/mm/yyyy hh24:mi'));

-- StationClass ################################################################
INSERT INTO StationClass (StationName, ClassName, MaxSpots)
VALUES ('Chatelet', 'VoitureElectrique', 10);
INSERT INTO StationClass (StationName, ClassName, MaxSpots)
VALUES ('Chatelet', 'Velo', 5);
INSERT INTO StationClass (StationName, ClassName, MaxSpots)
VALUES ('Chatelet', 'VeloElectrique', 3);
INSERT INTO StationClass (StationName, ClassName, MaxSpots)
VALUES ('Chatelet', 'VeloRemorque', 7);
INSERT INTO StationClass (StationName, ClassName, MaxSpots)
VALUES ('Chatelet', 'Utilitaire', 9);

INSERT INTO StationClass (StationName, ClassName, MaxSpots)
VALUES ('Austerlitz', 'VoitureElectrique', 5);
INSERT INTO StationClass (StationName, ClassName, MaxSpots)
VALUES ('Austerlitz', 'Velo', 3);
INSERT INTO StationClass (StationName, ClassName, MaxSpots)
VALUES ('Austerlitz', 'VeloElectrique', 4);
INSERT INTO StationClass (StationName, ClassName, MaxSpots)
VALUES ('Austerlitz', 'VeloRemorque', 6);
INSERT INTO StationClass (StationName, ClassName, MaxSpots)
VALUES ('Austerlitz', 'Utilitaire', 10);

INSERT INTO StationClass (StationName, ClassName, MaxSpots)
VALUES ('JeanJaures', 'VoitureElectrique', 7);
INSERT INTO StationClass (StationName, ClassName, MaxSpots)
VALUES ('JeanJaures', 'Velo', 3);
INSERT INTO StationClass (StationName, ClassName, MaxSpots)
VALUES ('JeanJaures', 'VeloElectrique', 4);
INSERT INTO StationClass (StationName, ClassName, MaxSpots)
VALUES ('JeanJaures', 'VeloRemorque', 10);
INSERT INTO StationClass (StationName, ClassName, MaxSpots)
VALUES ('JeanJaures', 'Utilitaire', 8);

-- StationOccupation ###########################################################
INSERT INTO StationOccupation (StationName, Day, CurrentOccupation, MaxOccupation)
VALUES ('Austerlitz', TRUNC(CURRENT_DATE), 3, 3);
INSERT INTO StationOccupation (StationName, Day, CurrentOccupation, MaxOccupation)
VALUES ('JeanJaures', TRUNC(CURRENT_DATE), 1, 1);

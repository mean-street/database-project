package model;

import java.lang.IllegalArgumentException;
import java.util.ArrayList;
import java.sql.*;
import controller.*;
import view.*;

public class DataAccess {
	private Connection connection;
	private Statement statement;

	public DataAccess(){
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			String database = "jdbc:oracle:thin:@ensioracle1.imag.fr:1521:ensioracle1";
			String user = "carrel";
			String password = "carrel";
			this.connection = DriverManager.getConnection(database,user,password);
			this.connection.setAutoCommit(false);
		} catch(SQLException e){
			System.out.println("Couldn't connect to database.");
		} catch(ClassNotFoundException e){
			System.out.println("Couldn't find plugin");
		}
	}

	public void closeConnection(){
		try {
			this.connection.close();
		} catch(SQLException e){
			System.out.println(e.getMessage());
		}
	}

	public boolean checkParkedVehicles(){
		try {
			String query = "SELECT StationVehicle.StationName,Vehicle.ClassName, StationClass.MaxSpots, COUNT(Vehicle.IdVehicle) FROM Vehicle, StationVehicle, StationClass WHERE Vehicle.IdVehicle = StationVehicle.IdVehicle AND StationVehicle.StationName = StationClass.StationName AND StationClass.ClassName = Vehicle.ClassName GROUP BY StationVehicle.StationName, Vehicle.ClassName, StationClass.MaxSpots";
			Statement statement = this.connection.createStatement();
			ResultSet result_set = statement.executeQuery(query);
			while(result_set.next()){
				if(result_set.getInt(3) < result_set.getInt(4)){
					IO.printParkedVehicles(result_set.getString(1),result_set.getString(2),result_set.getInt(3),result_set.getInt(4));
					return false;
				}
			}
			result_set.close();
			statement.close();
			return true;
		} catch(SQLException e){
			System.out.println("Connection error.");
			return false;
		}
	}

	public boolean checkStationParkedVehicles(){
		try {
			String query = "SELECT Location.IdVehicle, StationLocation.EndStationName, StationVehicle.StationName FROM Location INNER JOIN StationLocation ON StationLocation.IdLocation = Location.IdLocation LEFT JOIN StationVehicle ON (StationVehicle.IdVehicle = Location.IdVehicle AND StationVehicle.StationName = StationLocation.EndStationName) WHERE StationLocation.EndDate = (SELECT MAX(S.EndDate) FROM 	StationLocation S, Location L WHERE S.IdLocation = L.IdLocation AND	L.IdVehicle = Location.IdVehicle) AND Location.IdVehicle NOT IN (SELECT	L.IdVehicle	FROM Location L	WHERE L.IdLocation NOT IN (SELECT S.IdLocation FROM	StationLocation S))";
			Statement statement = this.connection.createStatement();
			ResultSet result_set = statement.executeQuery(query);
			while(result_set.next()){
				if(!result_set.getString(2).equals(result_set.getString(3))){
					IO.printStationParkedVehicles(result_set.getInt(1),result_set.getString(2),result_set.getString(3));
					return false;
				}
			}
			result_set.close();
			statement.close();
			return true;
		} catch(SQLException e){
			System.out.println("Connection error.");
			return false;
		}
	}

	public boolean checkSubscriberLocation() {
		try {
			String query = "SELECT Subscriber.CreditCard, UserClassLimitedRate.ClassName FROM Subscriber, UserClassLimitedRate WHERE UserClassLimitedRate.CreditCard = Subscriber.CreditCard AND UserClassLimitedRate.ClassName IN (SELECT UCIR.ClassName FROM UserClassIllimitedRate UCIR WHERE UCIR.CreditCard = Subscriber.CreditCard)";
			Statement statement = this.connection.createStatement();
			ResultSet result_set = statement.executeQuery(query);
			if(result_set.next()){
				IO.printSubscriberLocation(result_set.getString(1),result_set.getString(2));
				return false;
			}
			result_set.close();
			return true;
		} catch(SQLException e){
			System.out.println("Connection error.");
			return false;
		}
	}

	public void updateStationMaxSpots(Statement statement,String stationName){
		;
	}

	public boolean checkLocationId(Statement statement,int idLocation) throws IllegalArgumentException {
		try {
			String query = "SELECT IdLocation FROM StationLocation WHERE IdLocation = "+idLocation;
			ResultSet result_set = statement.executeQuery(query);
			boolean result = result_set.next();
			result_set.close();
			return result;
		} catch(SQLException e){
			try {
				this.connection.rollback();
			} catch(SQLException se){
				System.out.println("This shouldn't happen !!!!!");
				throw new IllegalArgumentException();
			}
			throw new IllegalArgumentException();
		}
	}

	public boolean checkIllimitedLocation(Statement statement,int idLocation,int creditCard) throws IllegalArgumentException {
		try {
			//String query = "SELECT IdLocation FROM Location NATURAL JOIN UserClassIllimitedRate WHERE CreditCard = "+creditCard+"+ AND IdLocation = "+idLocation;
			String query = "SELECT IdLocation FROM Location NATURAL JOIN UserClassIllimitedRate WHERE CreditCard = "+creditCard+" AND IdLocation = "+idLocation;
			ResultSet result_set = statement.executeQuery(query);
			boolean result = result_set.next();
			result_set.close();
			return result;
		} catch(SQLException e){
			try {
				e.printStackTrace();
				this.connection.rollback();
			} catch(SQLException se){
				System.out.println("This shouldn't happen !!!!!");
				throw new IllegalArgumentException();
			}
			throw new IllegalArgumentException();
		}
	}

	// 4th check, first part
	public boolean checkEndedRatesLimited(String currentDate) throws IllegalArgumentException {
		try {
			String query = "SELECT Subscriber.CreditCard, TO_CHAR(UserClassLimitedRate.StartDate + UserClassLimitedRate.Duration, 'dd/mm/yyyy'), CASE WHEN (UserClassLimitedRate.StartDate + UserClassLimitedRate.Duration) < TO_DATE('"+currentDate+"', 'YYYY-MM-DD') THEN 1 ELSE 0 END AS isFinished FROM Subscriber, UserClassLimitedRate WHERE UserClassLimitedRate.CreditCard = Subscriber.CreditCard";
			Statement statement = this.connection.createStatement();
			ResultSet result_set = statement.executeQuery(query);
			while (result_set.next()){
				if (result_set.getInt(3) == 1) {
					result_set.close();
					return false;
				}
			}
			result_set.close();
			statement.close();
			return true;

		} catch(SQLException e){
			e.printStackTrace();
			System.out.println("Connection error.");
			return false;
		}
	}

	// 4th check, second part
	public boolean checkEndedRatesIllimited() throws IllegalArgumentException {
		try {
			String query = "SELECT Subscriber.CreditCard, UserClassIllimitedRate.NbLocation, CASE WHEN UserClassIllimitedRate.NbLocation <= 0 THEN 1 ELSE 0 END AS isFinished FROM Subscriber, UserClassIllimitedRate WHERE UserClassIllimitedRate.CreditCard = Subscriber.CreditCard";
			Statement statement = this.connection.createStatement();
			ResultSet result_set = statement.executeQuery(query);
			while (result_set.next()){
				if (result_set.getInt(3) == 1) {
					result_set.close();
					return false;
				}
			}
			result_set.close();
			statement.close();
			return true;

		} catch(SQLException e){
			e.printStackTrace();
			System.out.println("Connection error.");
			return false;
		}
	}




	// 5th check
	public boolean checkLocationsVehicles() throws IllegalArgumentException {
		try {
			String query = "SELECT Location.IdLocation, Location.IdVehicle FROM Location WHERE Location.IdVehicle IN (SELECT L.IdVehicle FROM Location L, StationLocation SL WHERE SL.IdLocation = L.IdLocation AND L.IdLocation <> Location.IdLocation AND Location.StartDate > L.StartDate AND Location.StartDate < SL.EndDate) OR Location.IdVehicle IN (SELECT L.IdVehicle FROM Location L WHERE L.IdLocation NOT IN (SELECT SL.IdLocation FROM StationLocation SL) AND L.IdLocation <> Location.IdLocation AND Location.StartDate > L.StartDate) ORDER BY 1";
			Statement statement = this.connection.createStatement();
			ResultSet result_set = statement.executeQuery(query);
			boolean result = result_set.next(); // False if nothing in result
			result_set.close();
			statement.close();
			return !result;
		} catch(SQLException e){
			System.out.println("Connection error.");
			return false;
		}
	}


	public void insertStationLocation(Statement statement,int idLocation,String stationName,String endDate) throws IllegalArgumentException {
		try {
			String query = "INSERT INTO StationLocation VALUES("+idLocation+",'"+stationName+"',TO_DATE('"+endDate+"','YYYY-MM-DD'))";
			statement.executeUpdate(query);
		} catch(SQLException e){
			try {
				this.connection.rollback();
			} catch(SQLException se){
				System.out.println("This shouldn't happen !!!!!");
				throw new IllegalArgumentException();
			}
			throw new IllegalArgumentException();
		}
	}

	public ArrayList<LocationBill> getLocationBill(int idLocation,String stationName,String endDate,int creditCard) throws IllegalArgumentException {
		try {
			Statement statement = this.connection.createStatement();
			if(statement == null)
			this.statement.executeQuery("SET TRANSACTION ISOLATION LEVEL REPEATABLE READ");
			if(this.checkLocationId(statement,idLocation)){
				this.connection.commit();
				throw new IllegalArgumentException();
			}
			this.insertStationLocation(statement,idLocation,stationName,endDate);
			if(this.checkIllimitedLocation(statement,idLocation,creditCard)){
				this.connection.commit();
				return null;
			}


			String query = "SELECT V.IdVehicle,VC.ClassName, CASE WHEN (MONTHS_BETWEEN(CURRENT_DATE, S.Birthdate)/12 < 25 OR MONTHS_BETWEEN(CURRENT_DATE, S.Birthdate)/12 > 65) THEN CASE WHEN (CURRENT_DATE - L.StartDate) * 24 <= 1 THEN 0 ELSE CASE WHEN UCIR.Reduction > 0 THEN CASE WHEN (CURRENT_DATE - L.StartDate) > (VC.MaxDuration/24) THEN (((CURRENT_DATE - L.StartDate) * 24 - 1) * VC.HourlyPrice * 0.75 * UCIR.Reduction) + VC.Deposit ELSE (((CURRENT_DATE - L.StartDate) * 24 - 1) * VC.HourlyPrice * 0.75 * UCIR.Reduction)	END	ELSE CASE WHEN (CURRENT_DATE - L.StartDate) > (VC.MaxDuration/24) THEN (((CURRENT_DATE - L.StartDate) * 24 - 1) * VC.HourlyPrice * 0.75) + VC.Deposit ELSE (((CURRENT_DATE - L.StartDate) * 24 - 1) * VC.HourlyPrice * 0.75) END END END ELSE CASE WHEN (CURRENT_DATE - L.StartDate) * 24 <= 1 THEN 0 ELSE CASE WHEN UCIR.Reduction > 0 THEN CASE WHEN (CURRENT_DATE - L.StartDate) > (VC.MaxDuration/24) THEN (((CURRENT_DATE - L.StartDate) * 24 - 1) * VC.HourlyPrice * UCIR.Reduction) + VC.Deposit ELSE (((CURRENT_DATE - L.StartDate) * 24 - 1) * VC.HourlyPrice * UCIR.Reduction) END ELSE CASE WHEN (CURRENT_DATE - L.StartDate) > (VC.MaxDuration/24) THEN (((CURRENT_DATE - L.StartDate) * 24 - 1) * VC.HourlyPrice) + VC.Deposit	ELSE (((CURRENT_DATE - L.StartDate) * 24 - 1) * VC.HourlyPrice) END END END END AS PRICE FROM Location L INNER JOIN Vehicle V ON V.IdVehicle = L.IdVehicle INNER JOIN VehicleClass VC ON VC.ClassName = V.ClassName	INNER JOIN Subscriber S ON S.CreditCard = L.CreditCard LEFT JOIN UserClassLimitedRate UCIR ON (UCIR.CreditCard = S.CreditCard AND UCIR.ClassName = V.ClassName) WHERE L.IdLocation = ?";
			PreparedStatement preparedStatement = this.connection.prepareStatement(query);
			preparedStatement.setInt(1,idLocation);
			ResultSet result_set = preparedStatement.executeQuery();

			ArrayList<LocationBill> result_list = new ArrayList<LocationBill>();
			while(result_set.next()){
				LocationBill location_bill = new LocationBill();
				location_bill.setIdVehicle(result_set.getInt(1));
				location_bill.setClassName(result_set.getString(2));
				location_bill.setPrice(result_set.getFloat(3));
				result_list.add(location_bill);
			}
			this.connection.commit();
			result_set.close();
			preparedStatement.close();
			return result_list;
		} catch(SQLException e){
			try {
				e.printStackTrace();
				this.connection.rollback();
				return null;
			} catch(SQLException se){
				System.out.println("This shouldn't happen !!!!!");
				throw new IllegalArgumentException();
			}
		}
	}

	public ArrayList<MonthlyVehicle> getMonthlyVehicle(String monthDate){
		try {
			String query = "SELECT Vehicle.IdVehicle,COUNT(Location.IdLocation),SUM(StationLocation.EndDate - Location.StartDate) / COUNT(Location.IdLocation) FROM Location, StationLocation,Vehicle WHERE Location.IdLocation = StationLocation.IdLocation AND Vehicle.IdVehicle = Location.IdVehicle AND TO_CHAR(Location.StartDate, 'YYYY-MM') = ? GROUP BY Vehicle.IdVehicle";
			PreparedStatement statement = this.connection.prepareStatement(query);
			statement.setString(1,monthDate);
			ResultSet result_set = statement.executeQuery();

			ArrayList<MonthlyVehicle> result_list = new ArrayList<MonthlyVehicle>();
			while(result_set.next()){
				MonthlyVehicle monthly_vehicle = new MonthlyVehicle();
				monthly_vehicle.setDate(monthDate);
				monthly_vehicle.setVehicleId(result_set.getInt(1));
				monthly_vehicle.setLocationCount(result_set.getInt(2));
				monthly_vehicle.setAverageTime(result_set.getFloat(3));
				result_list.add(monthly_vehicle);
			}
			result_set.close();
			statement.close();
			return result_list;
		} catch(SQLException e){
			return null;
		}
	}
	
	public ArrayList<MonthlyClass> getMonthlyClass(String monthDate){
		try {
			String query = "SELECT Vehicle.ClassName,COUNT(Location.IdLocation), SUM(StationLocation.EndDate - Location.StartDate) / COUNT(Location.IdLocation) FROM Location, StationLocation, Vehicle WHERE Location.IdLocation = StationLocation.IdLocation AND Vehicle.IdVehicle = Location.IdVehicle AND TO_CHAR(Location.StartDate, 'YYYY-MM') = ? GROUP BY Vehicle.ClassName";
			PreparedStatement statement = this.connection.prepareStatement(query);
			statement.setString(1,monthDate);
			ResultSet result_set = statement.executeQuery();

			ArrayList<MonthlyClass> result_list = new ArrayList<MonthlyClass>();
			while(result_set.next()){
				MonthlyClass monthly_class = new MonthlyClass();
				monthly_class.setDate(monthDate);
				monthly_class.setClassName(result_set.getString(1));
				monthly_class.setAverageTime(result_set.getFloat(2));
				monthly_class.setLocationCount(result_set.getInt(3));
				result_list.add(monthly_class);
			}
			result_set.close();
			statement.close();
			return result_list;
		} catch(SQLException e){
			return null;
		}
	}

	public ArrayList<DecadeClass> getDecadeClass(Date startDate){
		try {
			String query = "SELECT Vehicle.ClassName AS Class, SUM(StationLocation.EndDate - Location.StartDate) FROM Location, StationLocation, Vehicle WHERE Location.IdLocation = StationLocation.IdLocation AND Vehicle.IdVehicle = Location.IdVehicle	AND Location.StartDate > ? AND StationLocation.EndDate < add_months(?, 120) GROUP BY Vehicle.ClassName";
			PreparedStatement statement = this.connection.prepareStatement(query);
			statement.setDate(1,startDate);
			statement.setDate(2,startDate);
			ResultSet result_set = statement.executeQuery();

			ArrayList<DecadeClass> result_list = new ArrayList<DecadeClass>();
			while(result_set.next()){
				DecadeClass decade_class = new DecadeClass();
				decade_class.setClassName(result_set.getString(1));
				decade_class.setAverageTime(result_set.getFloat(2));
				result_list.add(decade_class);
			}
			result_set.close();
			statement.close();
			return result_list;
		} catch(SQLException e){
			return null;
		}
	}

	public int getMaxSpots(String station_name,String class_name){
		try {
			String query = "SELECT MaxSpots FROM StationClass WHERE StationName = ? and ClassName = ?";
			PreparedStatement statement = this.connection.prepareStatement(query);
			statement.setString(1,station_name);
			statement.setString(2,class_name);
			ResultSet result_set = statement.executeQuery();
			result_set.next();
			int result = result_set.getInt(1);
			result_set.close();
			statement.close();
			return result;
		} catch(SQLException e){
			return -1;
		}
	}


	public double getOccupationRate(Date date, String stationName) throws IllegalArgumentException {
		try {
			String query = "";
			PreparedStatement statement = this.connection.prepareStatement(query);
			statement.setDate(1, date);
			statement.setString(2, stationName);
			ResultSet result_set = statement.executeQuery();
			result_set.next();
			double result = result_set.getDouble(2);
			result_set.close();
			statement.close();
			return result;
		} catch(SQLException e){
			throw new IllegalArgumentException();
		}
	}
}


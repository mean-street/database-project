package model;

import java.util.ArrayList;
import java.sql.*;
import controller.*;

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
			e.printStackTrace();
		} catch(ClassNotFoundException e){
			e.printStackTrace();
		}
	}

	public void closeConnection(){
		try {
			this.connection.close();
		} catch(SQLException e){
			System.out.println(e.getMessage());
		}
	}

	public ArrayList<LocationBill> getLocationBill(int id_location){
		try {
			String query = "SELECT StartDate,MaxDuration,HourlyPrice,Deposit FROM VehicleClass,Vehicle,Location WHERE Location.IdLocation = ? AND VehicleClass.ClassName = Vehicle.ClassName AND Location.IdVehicle = Vehicle.IdVehicle";
			PreparedStatement statement = this.connection.prepareStatement(query);
			statement.setInt(1,id_location);
			ResultSet result_set = statement.executeQuery();

			ArrayList<LocationBill> result_list = new ArrayList<LocationBill>();
			while(result_set.next()){
				LocationBill location_bill = new LocationBill();
				location_bill.setDate(result_set.getDate(1));
				location_bill.setMaxDuration(result_set.getInt(2));
				location_bill.setHourlyPrice(result_set.getFloat(3));
				location_bill.setDeposit(result_set.getFloat(4));
				result_list.add(location_bill);
			}
			result_set.close();
			statement.close();
			return result_list;
		} catch(SQLException e){
			e.printStackTrace();
			return null;
		}
	}

	public ArrayList<MonthlyVehicle> getMonthlyVehicle(){
		try {
			String query = "SELECT TO_CHAR(Location.StartDate,'YYYY-MM') AS LocationDate, Vehicle.IdVehicle AS Vehicle,SUM(StationLocation.EndDate - Location.StartDate) / COUNT(Location.IdLocation) AS AverageTimeOfUse FROM Location, StationLocation, Vehicle WHERE Location.IdLocation = StationLocation.IdLocation AND Vehicle.IdVehicle = Location.IdVehicle GROUP BY TO_CHAR(Location.StartDate, 'YYYY-MM'), Vehicle.IdVehicle";
			Statement statement = this.connection.createStatement();
			ResultSet result_set = statement.executeQuery(query);

			ArrayList<MonthlyVehicle> result_list = new ArrayList<MonthlyVehicle>();
			while(result_set.next()){
				MonthlyVehicle monthly_vehicle = new MonthlyVehicle();
				monthly_vehicle.setDate(result_set.getString(1));
				monthly_vehicle.setVehicleId(result_set.getInt(2));
				monthly_vehicle.setAverageTime(result_set.getFloat(3));
				result_list.add(monthly_vehicle);
			}
			result_set.close();
			statement.close();
			return result_list;
		} catch(SQLException e){
			e.printStackTrace();
			return null;
		}
	}
	
	public ArrayList<MonthlyClass> getMonthlyClass(){
		try {
			String query = "SELECT TO_CHAR(Location.StartDate,'YYYY-MM') AS StartDate, Vehicle.ClassName AS VehicleClass, SUM(StationLocation.EndDate - Location.StartDate) / COUNT(Location.IdLocation) AS AverageTimeOfUse	FROM Location, StationLocation, Vehicle WHERE Location.IdLocation = StationLocation.IdLocation AND Vehicle.IdVehicle = Location.IdVehicle GROUP BY to_char(Location.StartDate, 'YYYY-MM'), Vehicle.ClassName";
			Statement statement = this.connection.createStatement();
			ResultSet result_set = statement.executeQuery(query);

			ArrayList<MonthlyClass> result_list = new ArrayList<MonthlyClass>();
			while(result_set.next()){
				MonthlyClass monthly_class = new MonthlyClass();
				monthly_class.setDate(result_set.getString(1));
				monthly_class.setClassName(result_set.getString(2));
				monthly_class.setAverageTime(result_set.getFloat(3));
				result_list.add(monthly_class);
			}
			result_set.close();
			statement.close();
			return result_list;
		} catch(SQLException e){
			e.printStackTrace();
			return null;
		}
	}

	public ArrayList<DecadeClass> getDecadeClass(){
		try {
			String query = "SELECT Vehicle.ClassName AS Class, MAX(SUM(StationLocation.EndDate - Location.StartDate)) AS UseTime FROM Location, StationLocation, Vehicle WHERE Location.IdLocation = StationLocation.IdLocation	AND Vehicle.IdVehicle = Location.IdVehicle AND Location.StartDate > StartDateInputAND StationLocation.EndDate < EndDateInput GROUP BY Vehicle.ClassName";
			Statement statement = this.connection.createStatement();
			ResultSet result_set = statement.executeQuery(query);

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
			e.printStackTrace();
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
			e.printStackTrace();
			return -1;
		}
	}

}

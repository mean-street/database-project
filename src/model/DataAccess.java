package model;

import java.util.ArrayList;
import java.sql.*;

public class DataAccess {
	private Connection connection;

	public DataAccess(){
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			//DriverManager.registerDriver(new oracle.jdbc.driver.OracleDriver());
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
			String query = "SELECT StartDate,MaxDuration,HourlyPrice,Deposit FROM FROM VehicleClass,Vehicle,Location WHERE Location.IdLocation = ? AND VehicleClass.ClassName = Vehicle.ClassName AND Location.IdVehicle = Vehicle.IdVehicle";
			PreparedStatement statement = this.connection.prepareStatement(query);
			statement.setInt(1,id_location);
			ResultSet result_set = statement.executeQuery();
			ResultSetMetaData rsmd = result_set.getMetaData();

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

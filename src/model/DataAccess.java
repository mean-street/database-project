package model;


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

	public int getMaxSpots(String station_name,String class_name){
		try {
			PreparedStatement statement = this.connection.prepareStatement("SELECT MaxSeats FROM StationClass WHERE StationName = ? and ClassName = ?");
			statement.setString(1,station_name);
			statement.setString(2,class_name);

			ResultSet result_set = statement.executeQuery();
			result_set.first();
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

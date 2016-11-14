import java.sql.*;

public class DataAccess {
	private Access connection;
	private static Statement statement;

	public DataAccess(){
		this.connection = new Access();
		this.statement = this.connection.getStatement();
	}

	public static int getEmptySpots(String station_name,String class_name){
		try {
			this.connection.prepareStatement("SELECT EmptySeats FROM StationClass WHERE StationName = ? and ClassName = ?");
			this.statement.setString(1,station_name);
			this.statement.setString(1,class_name);

			ResultSet result_set = this.statement.executeQuery();
			result_set.first();
			int result = result_set.getInt(1);
			result_set.close();
			return result;
		} catch(SQLException e){
			e.printStackTrace();
		}
	}

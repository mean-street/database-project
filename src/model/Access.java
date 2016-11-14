import java.sql.*;

public class Access {
	private Connection connection = null;
	private Statement statement = null;

	public Access(){
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			String database = "jdbc:oracle:thin:@ensioracle1.imag.fr:1521:ensioracle1";
			String user = "carrel";
			String password = "carrel";
			this.connection = DriverManager.getConnection(database,user,password);
		} catch(SQLException e){
			System.out.println(e.getMessage());
		} catch(ClassNotFoundException e){
			System.out.println(e.getMessage());
		}
	}

	public Statement getStatement(){
		try {
			this.statement = this.connection.createStatement();
		} catch(SQLException e){
			System.out.println(e.getMessage());
		}
		return this.statement;
	}

	public void closeConnection(){
		try {
			this.statement.close();
			this.connection.close();
		} catch(SQLException e){
			System.out.println(e.getMessage());
		}
	}
}

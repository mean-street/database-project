import model.DataAccess;

public class Application {
	public static void main(String[] args){
		DataAccess model = new DataAccess();
		int maxSpots = model.getMaxSpots("ISS","BIKE");
		System.out.println("Number of empty spots: "+maxSpots);
		model.closeConnection();
	}
}

import java.util.ArrayList;
import model.*;

public class Application {
	public static void main(String[] args){
		DataAccess model = new DataAccess();
		int maxSpots = model.getMaxSpots("Austerlitz","Velo");
		System.out.println("Number of empty spots: "+maxSpots);
		ArrayList<LocationBill> location_list = model.getLocationBill(1);
		for(LocationBill location: location_list){
			System.out.println(location.toString());
		}
		model.closeConnection();
	}
}

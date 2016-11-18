import java.util.ArrayList;
import model.*;
import controller.*;

public class Application {
	public static void main(String[] args){
		DataAccess model = new DataAccess();
		ArrayList<LocationBill> location_list = model.getLocationBill(1);
		for(LocationBill location: location_list){
			System.out.println(location.toString());
		}

		ArrayList<MonthlyVehicle> monthly_vehicle_list = model.getMonthlyVehicle();
		for(MonthlyVehicle monthly_utilisation: monthly_vehicle_list){
			System.out.println(monthly_utilisation.toString());
		}

		ArrayList<MonthlyClass> monthly_class_list = model.getMonthlyClass();
		for(MonthlyClass monthly_class: monthly_class_list){
			System.out.println(monthly_class.toString());
		}

		model.closeConnection();
	}
}

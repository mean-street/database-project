import java.util.ArrayList;
import java.sql.Date;
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

		/* Date(year,month,day) */
		ArrayList<DecadeClass> decade_class_list = model.getDecadeClass(new Date(2006,3,1),new Date(2016,11,8));
		for(DecadeClass decade_class: decade_class_list){
			System.out.println(decade_class.toString());
		}

		ArrayList<DailyStation> daily_station_list = model.getDailyStation();
		for(DailyStation daily_station: daily_station_list){
			System.out.println(daily_station.toString());
		}

		model.closeConnection();
	}
}

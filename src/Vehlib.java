import view.*;
import model.*;
import controller.*;
import java.util.ArrayList;
import java.sql.Date;

public class Vehlib {
    public static void main(String[] args){ 
        IO io = new IO();
        DataAccess model = new DataAccess();
		DateParser dateParser = new DateParser();
		Action currentAction = Action.NOTHING;

        boolean running = true;
        while(running) {
            switch(currentAction) {
                case QUIT:
                    running = false;
                break;
                case NOTHING:
                    currentAction = io.askForAction();
                break;
                case HIRE_BILLING:
					int locationId = io.askForHireId();
					if(!model.checkLocationEndDate(locationId)){
						String stationName = io.askForStationName();
						Date endDate = dateParser.getSQLCurrentDate();
						model.insertStationLocation(locationId,stationName,endDate);

						ArrayList<LocationBill> location_list = model.getLocationBill(locationId);
						IO.startBlock();
						for(LocationBill location: location_list){
							System.out.println(location.toString());
						}
						IO.endBlock();
					}
					else {
						System.out.println("Location déjà payée.");
					}
                    currentAction = Action.NOTHING;
                break;
                case VEHICLE_MEAN_USE_TIME:
					ArrayList<MonthlyVehicle> monthly_vehicle_list = model.getMonthlyVehicle();
					IO.startBlock();
					for(MonthlyVehicle monthly_utilisation: monthly_vehicle_list){
						System.out.println(monthly_utilisation.toString());
					}
					IO.endBlock();
                    currentAction = Action.NOTHING;
                break;
                case CATEGORY_MEAN_USE_TIME:
					ArrayList<MonthlyClass> monthly_class_list = model.getMonthlyClass();
					IO.startBlock();
					for(MonthlyClass monthly_class: monthly_class_list){
						System.out.println(monthly_class.toString());
					}
					IO.endBlock();
                    currentAction = Action.NOTHING;
                break;
                case MOST_USED_CATEGORY:
					Date startDate = dateParser.getSQLDate(io.askForStartDate());
					Date endDate = dateParser.getSQLDate(io.askForEndDate());
					ArrayList<DecadeClass> decade_class_list = model.getDecadeClass(startDate,endDate);
					IO.startBlock();
					for(DecadeClass decade_class: decade_class_list){
						System.out.println(decade_class.toString());
					}
					IO.endBlock();
                    currentAction = Action.NOTHING;
                break;
                case STATION_USAGE_RATE:
					ArrayList<DailyStation> daily_station_list = model.getDailyStation();
					IO.startBlock();
					for(DailyStation daily_station: daily_station_list){
						System.out.println(daily_station.toString());
					}
					IO.endBlock();
                    currentAction = Action.NOTHING;
                break;
                default:
					model.closeConnection();
                    throw new IllegalStateException();
            }
        }
		model.closeConnection();
        System.out.println("I don't blame you.");
    }
}

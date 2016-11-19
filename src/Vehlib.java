import view.*;
import model.*;
import controller.*;
import java.lang.IllegalArgumentException;
import java.util.ArrayList;
import java.sql.Date;

public class Vehlib {
    public static void main(String[] args){
		int locationId;
        IO io = new IO();
        DataAccess model = new DataAccess();
		DateParser dateParser = new DateParser();
		Action currentAction = Action.NOTHING;
		Date startDate,endDate;
		String stationName,firstname,lastname,address;

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
					locationId = io.askForHireId();
					stationName = io.askForStationName();
					firstname = io.askForFirstname();
					lastname = io.askForLastname();
					address = io.askForAddress();
					endDate = dateParser.getSQLCurrentDate();
					try {
						ArrayList<LocationBill> location_list = model.getLocationBill(locationId,stationName,endDate,firstname,lastname,address);
						if(location_list == null)
							System.out.println("Location illimitée ===> rien à payer.");
						else {
							IO.startBlock();
							for(LocationBill location: location_list){
								System.out.println(location.toString());
							}
							IO.endBlock();
						}
					} catch(IllegalArgumentException e){
						System.out.println("Cette location n'existe pas.\n");
					}
                    currentAction = Action.NOTHING;
                break;
                case VEHICLE_MEAN_USE_TIME:
					ArrayList<MonthlyVehicle> monthly_vehicle_list = model.getMonthlyVehicle(io.askForStartMonth());
					IO.startBlock();
					for(MonthlyVehicle monthly_utilisation: monthly_vehicle_list){
						System.out.println(monthly_utilisation.toString());
					}
					IO.endBlock();
                    currentAction = Action.NOTHING;
                break;
                case CATEGORY_MEAN_USE_TIME:
					ArrayList<MonthlyClass> monthly_class_list = model.getMonthlyClass(io.askForStartMonth());
					IO.startBlock();
					for(MonthlyClass monthly_class: monthly_class_list){
						System.out.println(monthly_class.toString());
					}
					IO.endBlock();
                    currentAction = Action.NOTHING;
                break;
                case MOST_USED_CATEGORY:
					startDate = dateParser.getSQLDate(io.askForStartDate());
					ArrayList<DecadeClass> decade_class_list = model.getDecadeClass(startDate);
					IO.startBlock();
					for(DecadeClass decade_class: decade_class_list){
						System.out.println(decade_class.toString());
					}
					IO.endBlock();
                    currentAction = Action.NOTHING;
                break;
                case STATION_USAGE_RATE:
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

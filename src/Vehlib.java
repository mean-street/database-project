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
		Action currentAction;
		Date startDate,endDate;
		String stationName,stringDate;
		int creditCard;

        boolean running = true;
        while(running) {
			currentAction = io.askForAction();
            switch(currentAction) {
                case QUIT:
                    running = false;
					break;
                case HIRE_BILLING:
					locationId = io.askForHireId();
					stationName = io.askForStationName();
					creditCard = io.askForCreditCard();
					stringDate = dateParser.getCurrentStringDate();
					try {
						ArrayList<LocationBill> location_list = model.getLocationBill(locationId,stationName,stringDate,creditCard);
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
					break;
                case VEHICLE_MEAN_USE_TIME:
					ArrayList<MonthlyVehicle> monthly_vehicle_list = model.getMonthlyVehicle(io.askForStartMonth());
					IO.startBlock();
					for(MonthlyVehicle monthly_utilisation: monthly_vehicle_list){
						System.out.println(monthly_utilisation.toString());
					}
					IO.endBlock();
					break;
                case CATEGORY_MEAN_USE_TIME:
					ArrayList<MonthlyClass> monthly_class_list = model.getMonthlyClass(io.askForStartMonth());
					IO.startBlock();
					for(MonthlyClass monthly_class: monthly_class_list){
						System.out.println(monthly_class.toString());
					}
					IO.endBlock();
					break;
                case MOST_USED_CATEGORY:
					startDate = dateParser.getSQLDate(io.askForStartDate());
					ArrayList<DecadeClass> decade_class_list = model.getDecadeClass(startDate);
					IO.startBlock();
					for(DecadeClass decade_class: decade_class_list){
						System.out.println(decade_class.toString());
					}
					IO.endBlock();
					break;
                case STATION_USAGE_RATE:
					stationName = io.askForStationName();
					startDate = dateParser.getSQLDate(io.askForStartDate());
					double result = model.getOccupationRate(startDate, stationName);
					IO.startBlock();
					System.out.println(stationName + " : " + result);
					IO.endBlock();
					
					break;
				case INTEGRITY_CHECK:
					System.out.println("checkLocationsVehicles = " + model.checkLocationsVehicles());
					System.out.println("checkEndedRatesLimited = " + model.checkEndedRatesLimited(dateParser.getCurrentStringDate()));
					System.out.println("checkEndedRatesIllimited = " + model.checkEndedRatesIllimited());
					model.checkParkedVehicles();
					model.checkStationParkedVehicles();
					model.checkSubscriberLocation();
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

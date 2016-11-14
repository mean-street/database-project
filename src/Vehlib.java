import io.*;
import models.*;

class Vehlib {
    public static void main(String[] args){ 
        IO io = new IO();
        // Model model = new Model();
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
                    int id = io.askForHireId();

                    /*
                    try {
                        io.printHireBill(model.computeHireBill());
                    } catch(NoObjectException e) {
                        System.out.println(e.getMessage());
                    }
                    */

                    io.printHireBill(100); // TODO: test

                    currentAction = Action.NOTHING;
                break;
                case VEHICLE_MEAN_USE_TIME:
                    currentAction = Action.NOTHING;
                break;
                case CATEGORY_MEAN_USE_TIME:
                    currentAction = Action.NOTHING;
                break;
                case MOST_USED_CATEGORY:
                    currentAction = Action.NOTHING;
                break;
                case STATION_USAGE_RATE:
                    currentAction = Action.NOTHING;
                break;
                default:
                    throw new IllegalStateException();
            }
        }

        System.out.println("Ciao !");
    }
}

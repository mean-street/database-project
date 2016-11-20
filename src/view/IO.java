package view;

import java.io.Console;

public class IO {
    protected Console console = System.console();

	public static void startBlock(){
		System.out.println('\n'+"-------------------------------------------------------------------------------");
	}

	public static void endBlock(){
		System.out.println("-------------------------------------------------------------------------------"+'\n');
	}

	public static void startErrorBlock(){
		System.out.println('\n'+"========================================== ERROR ==========================================");
	}

	public static void endErrorBlock(){
		System.out.println("========================================== ERROR =========================================="+'\n');
	}

	public static void printParkedVehicles(String stationName,String className,int maxSpots,int parkedVehicles){
		IO.startErrorBlock();
		System.out.println("Station name: "+stationName+"\tClass name: "+className+"\tMax spots: "+maxSpots+"\tParked vehicles: "+parkedVehicles);
		IO.endErrorBlock();
	}

	public static void printStationParkedVehicles(int locationId,String endStationName,String stationName){
	IO.startErrorBlock();
		System.out.println("Location id: "+locationId+"\tEnd station name: "+endStationName+"\tStation name: "+stationName);
		IO.endErrorBlock();
	}

	public static void printSubscriberLocation(String creditCard,String className){
	IO.startErrorBlock();
		System.out.println("Credit card: "+creditCard+"\tClass name: "+className);
		IO.endErrorBlock();
	}

    public Action askForAction() {
        int action = -1;
        System.out.println(
            "Les actions possibles sont les suivantes :\n" +
            "\t0. Quitter\n" +
            "\t1. Facturation d'une location\n" +
            "\t2. Temps moyen d’utilisation par véhicules par mois\n" +
            "\t3. Temps moyen d’utilisation par catégorie de véhicule par mois\n" +
            "\t4. Catégorie de véhicule la plus utilisée par tranche d’âge de 10 ans\n" +
            "\t5. Taux d’occupation des stations sur la journée\n" + 
            "\t6. Vérifier l'intégrité de la base de données\n"
        );

        while(action < 0 || action >= Action.values().length - 1) {
            try {
                action = Integer.parseInt(this.console.readLine("Sélectionner une action [0/1/2/3/4/5/6] : "));
            } catch(NumberFormatException e) {
                action = -1;
            }
        }
        return Action.values()[action];
    }

    public int askForHireId() {
        int id = -1;
        while(id < 0) {
            try {
                id = Integer.parseInt(this.console.readLine("Identifiant de la location : "));
            } catch(NumberFormatException e) {
                id = -1;
            }
        }
        return id;
    }

    public int askForCreditCard() {
        int creditCard = -1;
        while(creditCard < 0) {
            try {
                creditCard = Integer.parseInt(this.console.readLine("Credit card number : "));
            } catch(NumberFormatException e) {
			   	creditCard = -1;
            }
        }
        return creditCard;
    }

    public String askForStationName() {
        String stationName = this.console.readLine("Nom de la station : ");
        return stationName;
    }

    public String askForFirstname() {
        String firstname = this.console.readLine("Prénom : ");
        return firstname;
    }

    public String askForLastname() {
        String lastname = this.console.readLine("Nom de famille : ");
        return lastname;
    }

    public String askForAddress() {
        String address = this.console.readLine("Adresse : ");
        return address;
    }

	public String askForStartDate() {
        String date = this.console.readLine("Debut de la période (YYYY-MM-DD): ");
        return date;
    }

	public String askForStartMonth() {
        String date = this.console.readLine("Debut de la période (YYYY-MM): ");
        return date;
    }

	public String askForEndDate() {
        String date = this.console.readLine("Fin de la période (YYYY-MM-DD): ");
        return date;
    }

    public void printHireBill(int bill) {
        System.out.println("Facturation : " + bill);
    }
}

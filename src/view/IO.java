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

    public Action askForAction() {
        int action = -1;
        System.out.println(
            "Les actions possibles sont les suivantes :\n" +
            "\t0. Quitter\n" +
            "\t1. Facturation d'une location\n" +
            "\t2. Temps moyen d’utilisation par véhicules par mois\n" +
            "\t3. Temps moyen d’utilisation par catégorie de véhicule par mois\n" +
            "\t4. Catégorie de véhicule la plus utilisée par tranche d’âge de 10 ans\n" +
            "\t5. Taux d’occupation des stations sur la journée\n"
        );

        while(action < 0 || action >= Action.values().length - 1) {
            try {
                action = Integer.parseInt(this.console.readLine("Sélectionner une action [0/1/2/3/4/5] : "));
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

    public void printHireBill(int bill) {
        System.out.println("Facturation : " + bill);
    }
}

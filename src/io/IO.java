package io;

import java.io.Console;

public class IO {
    protected Console console = System.console();
    protected Action currentAction = Action.NOTHING;

    protected Action askForAction() {
        if(this.currentAction != Action.NOTHING) {
            throw(new IllegalStateException());
        }

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

        while(action < 0 || action >= Action.values().length) {
            try {
                action = Integer.parseInt(this.console.readLine(
                    "Sélectionner une action [0/1/2/3/4/5] : "
                ));
            } catch(NumberFormatException e) {
                action = -1;
            }
        }

        return Action.values()[action];
    }

    public boolean next() {
        boolean quit = false;

        switch(this.currentAction) {
            case NOTHING:
                this.currentAction = this.askForAction();
            break;
            case QUIT:
                quit = true;
            break;
            default:
                throw(new IllegalStateException());
        }

        return !quit;
    }
}

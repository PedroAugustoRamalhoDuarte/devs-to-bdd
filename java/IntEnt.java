/* Do not remove or modify this comment!  It is required for file identification!
DNL
platform:/resource/ChemicalReactionExample/src/Models/dnl/Hydrogen.dnl
 Do not remove or modify this comment!  It is required for file identification! */
package Models.java;

import java.io.Serializable;

public class IntEnt implements Serializable {
    private static final long serialVersionUID = 1L;

    //ID:VAR:IntEnt:0
    int value;

    //ENDIF
    public IntEnt() {
    }

    public IntEnt(int value) {
        this.value = value;
    }

    public void setValue(int value) {
        this.value = value;
    }

    public int getValue() {
        return this.value;
    }

    public String toString() {
        String str = "IntEnt";
        str += "\n\tvalue: " + this.value;
        return str;
    }
}

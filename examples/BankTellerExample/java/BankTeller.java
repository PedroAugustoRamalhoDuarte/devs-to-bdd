/* Do not remove or modify this comment!  It is required for file identification!
DNL
platform:/resource/BankTeller/src/Models/examples.ChemicalReaction.dnl/BankTeller.examples.ChemicalReaction.dnl
-148672963
 Do not remove or modify this comment!  It is required for file identification! */
package examples.BankTellerExample.java;

import java.beans.PropertyChangeListener;
import java.beans.PropertyChangeSupport;

import java.io.File;
import java.io.Serializable;

import java.net.URI;
import java.net.URISyntaxException;

import java.util.ArrayList;

import com.ms4systems.devs.core.message.Message;
import com.ms4systems.devs.core.message.MessageBag;
import com.ms4systems.devs.core.message.Port;
import com.ms4systems.devs.core.message.impl.MessageBagImpl;
import com.ms4systems.devs.core.model.impl.AtomicModelImpl;
import com.ms4systems.devs.core.simulation.Simulation;
import com.ms4systems.devs.core.simulation.Simulator;
import com.ms4systems.devs.core.simulation.impl.SimulationImpl;
import com.ms4systems.devs.extensions.PhaseBased;
import com.ms4systems.devs.extensions.StateVariableBased;
import com.ms4systems.devs.helpers.impl.SimulationOptionsImpl;
import com.ms4systems.devs.simviewer.standalone.SimViewer;

@SuppressWarnings("unused")
public class BankTeller extends AtomicModelImpl implements PhaseBased,
    StateVariableBased {
    private static final long serialVersionUID = 1L;

    // Declare state variables
    private PropertyChangeSupport propertyChangeSupport =
        new PropertyChangeSupport(this);
    String phase = "waitforHello";
    String previousPhase = null;
    Double sigma = Double.POSITIVE_INFINITY;
    Double previousSigma = Double.NaN;

    // End state variables

    // Input ports
    //ID:INP:0
    public final Port<Serializable> inMoney =
        addInputPort("inMoney", Serializable.class);

    //ENDID
    //ID:INP:1
    public final Port<Serializable> inHello =
        addInputPort("inHello", Serializable.class);

    //ENDID
    //ID:INP:2
    public final Port<Serializable> inRequestWithdrawal =
        addInputPort("inRequestWithdrawal", Serializable.class);

    //ENDID
    // End input ports

    // Output ports
    //ID:OUTP:0
    public final Port<Serializable> outWithdrawal =
        addOutputPort("outWithdrawal", Serializable.class);

    //ENDID
    //ID:OUTP:1
    public final Port<Serializable> outHi =
        addOutputPort("outHi", Serializable.class);

    //ENDID
    //ID:OUTP:2
    public final Port<Serializable> outRetrieveMoney =
        addOutputPort("outRetrieveMoney", Serializable.class);

    //ENDID
    // End output ports
    protected SimulationOptionsImpl options = new SimulationOptionsImpl();
    protected double currentTime;

    // This variable is just here so we can use @SuppressWarnings("unused")
    private final int unusedIntVariableForWarnings = 0;

    public BankTeller() {
        this("BankTeller");
    }

    public BankTeller(String name) {
        this(name, null);
    }

    public BankTeller(String name, Simulator simulator) {
        super(name, simulator);
    }

    public void initialize() {
        super.initialize();

        currentTime = 0;

        passivateIn("waitforHello");

    }

    @Override
    public void internalTransition() {
        currentTime += sigma;

        if (phaseIs("sendHi")) {
            getSimulator().modelMessage("Internal transition from sendHi");

            //ID:TRA:sendHi
            passivateIn("waitforRequestWithdrawal");

            //ENDID
            return;
        }
        if (phaseIs("sendRetrieveMoney")) {
            getSimulator()
                .modelMessage("Internal transition from sendRetrieveMoney");

            //ID:TRA:sendRetrieveMoney
            passivateIn("waitforMoney");

            //ENDID
            return;
        }
        if (phaseIs("sendWithdrawal")) {
            getSimulator()
                .modelMessage("Internal transition from sendWithdrawal");

            //ID:TRA:sendWithdrawal
            passivateIn("passive");

            //ENDID
            return;
        }

        //passivate();
    }

    @Override
    public void externalTransition(double timeElapsed, MessageBag input) {
        currentTime += timeElapsed;
        // Subtract time remaining until next internal transition (no effect if sigma == Infinity)
        sigma -= timeElapsed;

        // Store prior data
        previousPhase = phase;
        previousSigma = sigma;

        // Fire state transition functions
        if (phaseIs("waitforHello")) {
            if (input.hasMessages(inHello)) {
                ArrayList<Message<Serializable>> messageList =
                    inHello.getMessages(input);

                holdIn("sendHi", 1.0);

                return;
            }
        }

        if (phaseIs("waitforRequestWithdrawal")) {
            if (input.hasMessages(inRequestWithdrawal)) {
                ArrayList<Message<Serializable>> messageList =
                    inRequestWithdrawal.getMessages(input);

                holdIn("sendRetrieveMoney", 1.0);

                return;
            }
        }

        if (phaseIs("waitforMoney")) {
            if (input.hasMessages(inMoney)) {
                ArrayList<Message<Serializable>> messageList =
                    inMoney.getMessages(input);

                holdIn("sendWithdrawal", 1.0);

                return;
            }
        }
    }

    @Override
    public void confluentTransition(MessageBag input) {
        // confluentTransition with internalTransition first (by default)
        internalTransition();
        externalTransition(0, input);
    }

    @Override
    public Double getTimeAdvance() {
        return sigma;
    }

    @Override
    public MessageBag getOutput() {
        MessageBag output = new MessageBagImpl();

        if (phaseIs("sendHi")) {
            output.add(outHi, null);
        }
        if (phaseIs("sendRetrieveMoney")) {
            output.add(outRetrieveMoney, null);
        }
        if (phaseIs("sendWithdrawal")) {
            output.add(outWithdrawal, null);
        }
        return output;
    }

    // Custom function definitions

    // End custom function definitions
    public static void main(String[] args) {
        SimulationOptionsImpl options = new SimulationOptionsImpl(args, true);

        // Uncomment the following line to disable SimViewer for this model
        // options.setDisableViewer(true);

        // Uncomment the following line to disable plotting for this model
        // options.setDisablePlotting(true);

        // Uncomment the following line to disable logging for this model
        // options.setDisableLogging(true);
        BankTeller model = new BankTeller();
        model.options = options;

        if (options.isDisableViewer()) { // Command line output only
            Simulation sim =
                new SimulationImpl("BankTeller Simulation", model, options);
            sim.startSimulation(0);
            sim.simulateIterations(Long.MAX_VALUE);
        } else { // Use SimViewer
            SimViewer viewer = new SimViewer();
            viewer.open(model, options);
        }
    }

    public void addPropertyChangeListener(String propertyName,
        PropertyChangeListener listener) {
        propertyChangeSupport.addPropertyChangeListener(propertyName, listener);
    }

    public void removePropertyChangeListener(PropertyChangeListener listener) {
        propertyChangeSupport.removePropertyChangeListener(listener);
    }

    // State variables
    public String[] getStateVariableNames() {
        return new String[] {  };
    }

    public Object[] getStateVariableValues() {
        return new Object[] {  };
    }

    public Class<?>[] getStateVariableTypes() {
        return new Class<?>[] {  };
    }

    public void setStateVariableValue(int index, Object value) {
        switch (index) {

            default:
                return;
        }
    }

    // Convenience functions
    protected void passivate() {
        passivateIn("passive");
    }

    protected void passivateIn(String phase) {
        holdIn(phase, Double.POSITIVE_INFINITY);
    }

    protected void holdIn(String phase, Double sigma) {
        this.phase = phase;
        this.sigma = sigma;
        getSimulator()
            .modelMessage("Holding in phase " + phase + " for time " + sigma);
    }

    protected static File getModelsDirectory() {
        URI dirUri;
        File dir;
        try {
            dirUri = BankTeller.class.getResource(".").toURI();
            dir = new File(dirUri);
        } catch (URISyntaxException e) {
            e.printStackTrace();
            throw new RuntimeException(
                "Could not find Models directory. Invalid model URL: " +
                BankTeller.class.getResource(".").toString());
        }
        boolean foundModels = false;
        while (dir != null && dir.getParentFile() != null) {
            if (dir.getName().equalsIgnoreCase("java") &&
                  dir.getParentFile().getName().equalsIgnoreCase("models")) {
                return dir.getParentFile();
            }
            dir = dir.getParentFile();
        }
        throw new RuntimeException(
            "Could not find Models directory from model path: " +
            dirUri.toASCIIString());
    }

    protected static File getDataFile(String fileName) {
        return getDataFile(fileName, "txt");
    }

    protected static File getDataFile(String fileName, String directoryName) {
        File modelDir = getModelsDirectory();
        File dir = new File(modelDir, directoryName);
        if (dir == null) {
            throw new RuntimeException("Could not find '" + directoryName +
                "' directory from model path: " + modelDir.getAbsolutePath());
        }
        File dataFile = new File(dir, fileName);
        if (dataFile == null) {
            throw new RuntimeException("Could not find '" + fileName +
                "' file in directory: " + dir.getAbsolutePath());
        }
        return dataFile;
    }

    protected void msg(String msg) {
        getSimulator().modelMessage(msg);
    }

    // Phase display
    public boolean phaseIs(String phase) {
        return this.phase.equals(phase);
    }

    public String getPhase() {
        return phase;
    }

    public String[] getPhaseNames() {
        return new String[] {
            "waitforHello", "sendHi", "waitforRequestWithdrawal",
            "sendRetrieveMoney", "waitforMoney", "sendWithdrawal", "passive"
        };
    }
}

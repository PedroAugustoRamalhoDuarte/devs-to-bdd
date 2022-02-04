/* Do not remove or modify this comment!  It is required for file identification!
DNL
platform:/resource/ChemicalReactionExample/src/Models/examples.ChemicalReaction.dnl/ReactProcess.examples.ChemicalReaction.dnl
1803280508
 Do not remove or modify this comment!  It is required for file identification! */
package examples.ChemicalReaction.java;

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
public class ReactProcess extends AtomicModelImpl implements PhaseBased,
    StateVariableBased {
    private static final long serialVersionUID = 1L;

    //ID:SVAR:0
    private static final int ID_RELEASE = 0;

    //ENDID
    //ID:SVAR:1
    private static final int ID_RELEASETIME = 1;

    // Declare state variables
    private PropertyChangeSupport propertyChangeSupport =
        new PropertyChangeSupport(this);
    protected IntEnt Release;
    protected double releaseTime = 0;

    //ENDID
    String phase = "sendRelease";
    String previousPhase = null;
    Double sigma = releaseTime;
    Double previousSigma = Double.NaN;

    // End state variables

    // Input ports
    //ID:INP:0
    public final Port<Serializable> inStartUp =
        addInputPort("inStartUp", Serializable.class);

    //ENDID
    //ID:INP:1
    public final Port<IntEnt> inRelease =
        addInputPort("inRelease", IntEnt.class);

    //ENDID
    // End input ports

    // Output ports
    //ID:OUTP:0
    public final Port<Serializable> outAcceptOneMolecule =
        addOutputPort("outAcceptOneMolecule", Serializable.class);

    //ENDID
    //ID:OUTP:1
    public final Port<Serializable> outReleaseTwoMolecules =
        addOutputPort("outReleaseTwoMolecules", Serializable.class);

    //ENDID
    //ID:OUTP:2
    public final Port<Serializable> outReleaseOneMolecule =
        addOutputPort("outReleaseOneMolecule", Serializable.class);

    //ENDID
    //ID:OUTP:3
    public final Port<Serializable> outRelease =
        addOutputPort("outRelease", Serializable.class);

    //ENDID
    // End output ports
    protected SimulationOptionsImpl options = new SimulationOptionsImpl();
    protected double currentTime;

    // This variable is just here so we can use @SuppressWarnings("unused")
    private final int unusedIntVariableForWarnings = 0;

    public ReactProcess() {
        this("ReactProcess");
    }

    public ReactProcess(String name) {
        this(name, null);
    }

    public ReactProcess(String name, Simulator simulator) {
        super(name, simulator);
    }

    public void initialize() {
        super.initialize();

        currentTime = 0;

        // Default state variable initialization
        releaseTime = 0;

        holdIn("sendRelease", releaseTime);

    }

    @Override
    public void internalTransition() {
        currentTime += sigma;

        if (phaseIs("sendRelease")) {
            getSimulator().modelMessage("Internal transition from sendRelease");

            //ID:TRA:sendRelease
            passivateIn("waitForInput");

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
        if (phaseIs("waitForInput")) {
            if (input.hasMessages(inStartUp)) {
                ArrayList<Message<Serializable>> messageList =
                    inStartUp.getMessages(input);

                holdIn("sendRelease", releaseTime);

                return;
            }
            if (input.hasMessages(inRelease)) {
                ArrayList<Message<IntEnt>> messageList =
                    inRelease.getMessages(input);

                holdIn("sendRelease", releaseTime);

                // Fire state and port specific external transition functions
                //ID:EXT:waitForInput:inRelease
                IntEnt Release = null;
                for (Message<IntEnt> msg : messageList) {
                    Release = msg.getData();
                    if (Release.getValue() == -1) {
                        break;
                    }
                }
                int income = Release.getValue();
                if (income > 0) {
                    releaseTime = 1;
                } else {
                    releaseTime = Double.POSITIVE_INFINITY;
                }

                //ENDID
                // End external event code
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

        if (phaseIs("sendRelease")) {
            // Output event code
            //ID:OUT:sendRelease
            output.add(outReleaseTwoMolecules, "ReleaseTwoMolecules");
            output.add(outReleaseOneMolecule, "ReleaseOneMolecule");
            output.add(outAcceptOneMolecule, "AcceptOneMolecule");

            //ENDID
            // End output event code
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
        ReactProcess model = new ReactProcess();
        model.options = options;

        if (options.isDisableViewer()) { // Command line output only
            Simulation sim =
                new SimulationImpl("ReactProcess Simulation", model, options);
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

    // Getter/setter for Release
    public void setRelease(IntEnt Release) {
        propertyChangeSupport.firePropertyChange("Release", this.Release,
            this.Release = Release);
    }

    public IntEnt getRelease() {
        return this.Release;
    }

    // End getter/setter for Release

    // Getter/setter for releaseTime
    public void setReleaseTime(double releaseTime) {
        propertyChangeSupport.firePropertyChange("releaseTime",
            this.releaseTime, this.releaseTime = releaseTime);
    }

    public double getReleaseTime() {
        return this.releaseTime;
    }

    // End getter/setter for releaseTime

    // State variables
    public String[] getStateVariableNames() {
        return new String[] { "Release", "releaseTime" };
    }

    public Object[] getStateVariableValues() {
        return new Object[] { Release, releaseTime };
    }

    public Class<?>[] getStateVariableTypes() {
        return new Class<?>[] { IntEnt.class, Double.class };
    }

    public void setStateVariableValue(int index, Object value) {
        switch (index) {

            case ID_RELEASE:
                setRelease((IntEnt) value);
                return;

            case ID_RELEASETIME:
                setReleaseTime((Double) value);
                return;

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
            dirUri = ReactProcess.class.getResource(".").toURI();
            dir = new File(dirUri);
        } catch (URISyntaxException e) {
            e.printStackTrace();
            throw new RuntimeException(
                "Could not find Models directory. Invalid model URL: " +
                ReactProcess.class.getResource(".").toString());
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
        return new String[] { "sendRelease", "waitForInput" };
    }
}

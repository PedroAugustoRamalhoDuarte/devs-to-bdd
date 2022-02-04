package Models.java;

import com.ms4systems.devs.core.model.impl.AtomicModelImpl;
import com.ms4systems.devs.core.message.Port;
import java.io.Serializable;
import com.ms4systems.devs.extensions.PhaseBased;
import com.ms4systems.devs.extensions.ProvidesTooltip;
import com.ms4systems.devs.extensions.StateVariableBased;

public class HighH_Hydrogen extends Hydrogen { 
	private static final long serialVersionUID = 1L;
	public HighH_Hydrogen(){
		this("HighH_Hydrogen");
	}
	public HighH_Hydrogen(String nm) {
		super(nm);
	}
}
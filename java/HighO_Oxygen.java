package Models.java;

import com.ms4systems.devs.core.model.impl.AtomicModelImpl;
import com.ms4systems.devs.core.message.Port;
import java.io.Serializable;
import com.ms4systems.devs.extensions.PhaseBased;
import com.ms4systems.devs.extensions.ProvidesTooltip;
import com.ms4systems.devs.extensions.StateVariableBased;

public class HighO_Oxygen extends Oxygen { 
	private static final long serialVersionUID = 1L;
	public HighO_Oxygen(){
		this("HighO_Oxygen");
	}
	public HighO_Oxygen(String nm) {
		super(nm);
	}
}
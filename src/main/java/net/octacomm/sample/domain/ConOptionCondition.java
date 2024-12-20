package net.octacomm.sample.domain;

import lombok.Data;

@Data
public class ConOptionCondition implements Domain {
	
	private String fcName;
	
	private String secretCode;
	
	private String longCalYn;
	
	private String ubcYn;
	
	private String originDataYn;
	
	private String showPdfYn;

}

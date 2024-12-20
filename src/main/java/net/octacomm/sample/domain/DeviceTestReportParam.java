package net.octacomm.sample.domain;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString(callSuper = true)
public class DeviceTestReportParam extends DomainParam {
	
	private String searchField;
	
	private String searchWord;
	
	private String searchMfr;
	
	


	
	
}

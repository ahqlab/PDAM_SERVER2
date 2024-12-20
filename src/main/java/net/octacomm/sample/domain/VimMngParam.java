package net.octacomm.sample.domain;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString(callSuper = true)
public class VimMngParam extends DomainParam {
	
	private int groupIdx;
	
	private int fcIdx;  
	
	private String searchField;
	
	private String searchWord;
	
	private String startDate;
	
	private String endDate;

}

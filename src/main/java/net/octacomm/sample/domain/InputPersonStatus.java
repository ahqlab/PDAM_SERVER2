package net.octacomm.sample.domain;

import lombok.Data;

@Data
public class InputPersonStatus implements Domain {

	private int ipsIdx;
	
	private int constructionIdx;
	
	private int deviceIdx;
	
	private String type;
	
	private String name;
	
	private int preDay;
	
	private int today;
	
	private String bigo;
	
	private String operDate;

}

package net.octacomm.sample.domain;

import lombok.Data;

@Data
public class PileStandard implements Domain{
	
	private int id;
	
	private String type;
	
	private String value;

}

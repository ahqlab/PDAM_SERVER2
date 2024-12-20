package net.octacomm.sample.domain;

import lombok.Data;

@Data
public class PileTickness implements Domain{
	
	private int id;
	
	private int pileStandardIdx;
	
	private String value;


}

package net.octacomm.sample.domain;

import lombok.Data;

@Data
public class PileSrossSection implements Domain{
	
	private int id;
	
	private int pileStandardIdx;
	
	private int pileTicknessIdx;
	
	private String value;

}

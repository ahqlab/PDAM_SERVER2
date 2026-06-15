package net.octacomm.sample.domain;

import lombok.Data;

@Data
public class PileSelectValue implements Domain{
	
	private int id;
	
	private String pileType;
	
	private String pileStandard; 
	
	private String thickness;
	
	private String crossSection;
	
	private int sortSeq;
	
	private int subSortSeq; 
	
}

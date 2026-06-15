package net.octacomm.sample.domain;


import java.util.List;

import lombok.Data;

@Data
public class PileSelectValueParent implements Domain{
	
	private List<PileSelectValue> pileSelectValues;
	
	private List<PileSelectMethodValue> pileSelectMethodValue;
	
}

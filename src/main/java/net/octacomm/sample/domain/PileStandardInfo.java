package net.octacomm.sample.domain;

import java.util.List;

import lombok.Data;

@Data
public class PileStandardInfo implements Domain{
	
	private List<PileStandard> pileStandardList;
	
	private List<PileTickness> pileTicknessList;
	
	private List<PileSrossSection> pileSrossSectionList;
}

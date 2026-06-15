package net.octacomm.sample.domain;

import java.util.List;

import lombok.Data;

@Data
public class MultiFileUsingChartObj {

	private FileUsingChart chart1;
	private FileUsingChart chart2;
	private FileUsingChart chart3;
	private FileUsingChart chart4;
	
	private List<FileInventoryOfChart> fileInventoryChartList;
	
	private FileInventoryOfChart sumChart;
	private FileInventoryOfChart surplusChart;
	private Construction  construction;
	private String pileName;
	private String separateSinglePileType;
	private String separateBottomPileType;
	
	
}

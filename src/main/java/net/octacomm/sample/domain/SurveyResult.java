package net.octacomm.sample.domain;

import lombok.Data;

@Data
public class SurveyResult implements Domain{
	
	private int num;
	
	private int totalCnt;
	
	private String surveyContent;
	
	private int survey1;
	
	private int survey2;
	
	private int survey3;
	
	private int survey4;
	
	private int survey5;
}

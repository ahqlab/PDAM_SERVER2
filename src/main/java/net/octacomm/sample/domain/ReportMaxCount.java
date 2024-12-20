package net.octacomm.sample.domain;

import lombok.Data;

@Data
public class ReportMaxCount implements Domain{
	
	private int deviceIdx;
	
	private int cnt;
}

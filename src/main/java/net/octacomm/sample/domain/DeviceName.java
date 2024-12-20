package net.octacomm.sample.domain;

import lombok.Data;

@Data
public class DeviceName implements Domain{
	
	private int id;
	
	private int deviceIdx;
	
	private String deviceName;
	
	private String createDate;
	
	private String lastModified;
	

}

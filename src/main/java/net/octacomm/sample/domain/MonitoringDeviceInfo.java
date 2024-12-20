package net.octacomm.sample.domain;

import lombok.Data;

@Data
public class MonitoringDeviceInfo implements Domain{
	
	private int id; 
	
	private int monitoringIdx;
	
	private String deviceName;
	
	private String deviceId;
	
	private String devicePassword; 
	
	private String createDate; 
	
	private String lastModifiedDate;

}

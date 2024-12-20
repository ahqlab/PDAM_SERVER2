package net.octacomm.sample.domain;

import java.util.List;

import lombok.Data;

@Data
public class MonitoringInfo implements Domain{
	
	private int id; 
	
	private int constructionIdx;
	
	private String webId; 
	
	private String webPassword; 
	
	private String firstDeviceId;
	
	private String secondDeviceId;
	
	private String thirdDeviceId;
	
	private String createDate; 
	
	private String lastModifiedDate;

}

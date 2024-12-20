package net.octacomm.sample.domain;

import lombok.Data;

@Data
public class Customer implements Domain{
	
	private int id;
	
	private String groupName;
	
	private String conName;
	
	private String conLocation;
	
	private String conManager;
	
	private String conContact;
	

}

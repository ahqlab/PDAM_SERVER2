package net.octacomm.sample.domain;

import lombok.Data;

@Data
public class Group  implements Domain{
	
	private int idx;
	
	private String groupName;
	
	private String deviceAmount;
	
	private String cprtCompanyAmount;
	
	private String franchAmount;
	
	private int spareDeviceAmount;
	
	private int isDel;
	
	private String createDate;
	
	private String lastModifiedDate;
	
	private String userId;
	
	private String password;
	
	private int role;
	
	private int newContent;
	
}

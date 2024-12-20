package net.octacomm.sample.domain;

import lombok.Data;

@Data
public class Franchise  implements Domain{
	
	private int idx;
	
	private int constructionIdx;
	
	private String fcName;
	
	private String userId;
	
	private String password;
	
	private int isDel;
	
	private String createDate;
	
	private String lastModifiedDate;
	
	private int role;
	
}

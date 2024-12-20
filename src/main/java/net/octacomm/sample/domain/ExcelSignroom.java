package net.octacomm.sample.domain;

import lombok.Data;

@Data
public class ExcelSignroom implements Domain {
	
	private int id; 
	
	private int constructionIdx;
	
	private int seq;
	
	private String approver;
	
	private String creator;
	
	private String createDate;
	
	private String modifyter;
	
	private String lastModifiedDate;
	
}

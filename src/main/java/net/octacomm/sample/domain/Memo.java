package net.octacomm.sample.domain;

import lombok.Data;

@Data
public class Memo implements Domain{
	
	private int id;
	
	private int constructionIdx;
	
	private String userId;
	
	private String content;
	
	private String memoDate;
	
	private String createDate;
	
	private String modifyDate;

}

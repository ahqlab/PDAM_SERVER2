package net.octacomm.sample.domain;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class PileQntPlanMng  implements Domain{

	private int id;
	
	private int constructionIdx;
	
	private String localName;
	
	private String planCount;
	
	private String localReport;
	
	private String createDate;
	
	private String lastModifiedDate;
	
	private MultipartFile file;
	  
	private int fcIdx;
	
}

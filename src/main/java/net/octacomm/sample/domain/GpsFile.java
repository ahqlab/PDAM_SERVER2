package net.octacomm.sample.domain;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class GpsFile  implements Domain{

	private int id;
	
	private int constructionIdx;
	
	private String point;
	
	private String xAxis;
	
	private String yAxis;
	
	private String zAxis;
	
	private String code;
	
	private String createDate;
	
	private String lastModifiedDate;
	
	private MultipartFile file;
	  
	private int fcIdx;
	 
	
	
}

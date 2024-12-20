package net.octacomm.sample.domain;


import org.springframework.web.multipart.MultipartFile;

import com.mysql.jdbc.Blob;

import lombok.Data;

@Data
public class DeviceTestReport implements Domain{
	
	private int idx;
	
	private int no;
	
	private String mfr;
	
	private String type; 
	
	private String sn;
	
	private String fileName;
	
	private String filePath;
	
	private MultipartFile file;
	
	private String bigo;
	
	private int fcIdx;
	
}

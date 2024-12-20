package net.octacomm.sample.domain;

import lombok.Data;

@Data
public class Gps  implements Domain{
	
	private int id;
	
	private int constructionIdx;
	
	private String xAxis;
	
	private String yAxis;
	
	private String zAxis;
	
	private String code;
	
	private String point;
}

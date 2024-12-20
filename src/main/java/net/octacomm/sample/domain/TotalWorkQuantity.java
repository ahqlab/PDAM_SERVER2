package net.octacomm.sample.domain;

import lombok.Data;

@Data
public class TotalWorkQuantity implements Domain{

	private int id;
	
	private int quantity;
	
	private int executedQuantity;

	private int constructionIdx;
	
	private int processRate;
	
	private int quantityLeft;
	
	private int ngQuantity;
	
	private String createDate;
	
	private String lastModified;
	
	
}

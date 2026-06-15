package net.octacomm.sample.domain;

import lombok.Data;

@Data
public class ExtensivePileUsage implements Domain {

	private int id;
	
	private int constructionIdx;
	
	private int isUsed;
	
}

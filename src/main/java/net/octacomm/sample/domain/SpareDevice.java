package net.octacomm.sample.domain;

import lombok.Data;

@Data
public class SpareDevice implements Domain{
	
	private int id;
	
	private int constructionIdx;
	//0 : 예비용,
	private int type;
	
	private int quantity;
	
	private String bluetoothNo;
	//자동측정기 S/N
	private String lavelNo;
	
	private String bigo;
	
	//0 : 예비용, 1 : 교체됨, 2 : 회수
	private String status;
	
	private String createDate;
	
	
}

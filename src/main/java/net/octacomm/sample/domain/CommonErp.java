package net.octacomm.sample.domain;

import lombok.Data;

@Data
public class CommonErp implements Domain {

	private int id;
	private int constructionIdx;
	private int deviceIdx;
	private int erpDiv;
	private String dmiCol;
	private String preDay;
	private String today;
	private String dSum;
	private String bigo;
	private String operDate;
}

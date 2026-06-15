package net.octacomm.sample.domain;

import lombok.Data;

@Data
public class ContractParam {
	private int constructionIdx;
	private int role;
	private String status;
	private int currentPage = 1;
	private int pageSize = 20;
	private int pageGroupSize = 5;
	private String searchWord;

	public int getStartRow() {
		return (currentPage - 1) * pageSize;
	}
}

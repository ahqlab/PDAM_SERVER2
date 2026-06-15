package net.octacomm.sample.domain;

import lombok.Data;

@Data
public class ContractClauseParam {
	private int currentPage = 1;
	private int pageSize = 20;
	private int pageGroupSize = 5;
	private String searchWord;
}

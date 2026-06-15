package net.octacomm.sample.domain;

import lombok.Data;

@Data
public class ContractClause implements Domain {
	private int clauseIdx;
	private String contractType;   // DAILY, MONTHLY
	private int clauseNo;
	private String clauseTitle;
	private String clauseContent;
	private int isActive;          // 1=활성, 0=비활성
	private int sortOrder;
	private String createdAt;
	private String updatedAt;
}

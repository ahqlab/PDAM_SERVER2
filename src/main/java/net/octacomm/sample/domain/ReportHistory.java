package net.octacomm.sample.domain;

import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
public class ReportHistory extends Report {
	private int id;
	private int reportId;
	private String status;
	private String userId;
	private String modifiedAt;
	private String balanceSnapshot;
	private String singleLevel;
	private String bottomLevel;
	private String middleLevel;
	private String topLevel;
	private String p1;
	private String p2;
	private String p3;
	private String p4;
	private String p5;
	private String p6;
	private String p7;
	private String p8;
	private String p9;
	private String p10;
	private String changeSummary;
	private int changeCount;
}

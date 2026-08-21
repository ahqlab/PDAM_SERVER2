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
}
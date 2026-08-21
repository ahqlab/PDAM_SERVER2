package net.octacomm.sample.domain;

import lombok.Data;

@Data
public class ReportHistory implements Domain {
	private long id;
	private int reportId;
	private String status;
	private String userId;
}
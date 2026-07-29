package net.octacomm.sample.domain;

import java.util.List;

import lombok.Data;

@Data
public class DeviceBackupSnapshot implements Domain {

	private List<Report> reports;
	private List<ReportOneLine> excelReports;
	private boolean big;
	private int extensivePileUsage;
}

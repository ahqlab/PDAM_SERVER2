package net.octacomm.sample.domain;

import java.math.BigDecimal;

import lombok.Data;

@Data
public class ReportExcelUploadRecord implements Domain {

	private int id;
	private int deviceId;
	private String constructionDate;
	private String pileType;
	private String method;
	private String location;
	private String pileNo;
	private String pileStandard;
	private String drillingDepth;
	private String directDrillingDepth;
	private String soilDrillingDepth;
	private String stoneDrillingDepth;
	private String intrusionDepth;
	private BigDecimal balance;
	private String connectLength;
	private String managedStandard;
	private String avgPenetrationValue;
	private String totalPenetrationValue;
	private String hammaT;
	private String fallMeter;
	private String totalConnectWidth;
	private BigDecimal gongSac;
	private String ultimateBearingCapacity;
	private String hammaEfficiency;
	private String modulusElasticity;
	private String crossSection;
	private String bigo;
	private String memo;
}

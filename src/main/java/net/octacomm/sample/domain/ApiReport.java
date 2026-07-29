package net.octacomm.sample.domain;

import lombok.Data;

@Data
public class ApiReport implements Domain {

	private int id;
	private int deviceIdx;
	private String currentDateTime;
	private String location;
	private String pileNo;
	private String pileStandard;
	private String drillingDepth;
	private String directDrillingDepth;
	private String stDrillingDepth;
	private String sdDrillingDepth;
	private String intrusionDepth;
	private String balance;
	private String connectLength;
	private String managedStandard;
	private String avgPenetrationValue;
	private String totalPenetrationValue;
	private String hammaT;
	private String fallMeter;
	private String createDate;
	private String pileType;
	private String method;
	private String totalConnectWidth;
	private int isDel;
	private String ultimateBearingCapacity;
	private String crossSection;
	private String hammaEfficiency;
	private String modulusElasticity;
	private String bigo;
	private int isDuple;
	private String sprCol1;

	private String constructionName;
	private String machineNumber;
}

package net.octacomm.sample.domain;

import java.util.List;

import lombok.Data;

@Data
public class Report implements Domain {
	
	private int rownum;
	
	private int id;
	
	private int constructionIdx;
	
	private int deviceIdx;
	//호기추가
	private String machineNumber;
	//시공일자
	private String currentDateTime;
	//파일종류 2020-05-13 new
	private String pileType;
	//공법 2020-05-13 new
	private String method;
	//파일규격
	private String pileStandard;
	//위치
	private String location;
	//헤머무게
	private String hammaT;
	//낙하높이
	private String fallMeter;
	//관리기준
	private String managedStandard;
	//잔량
	private float balance;
	//파일넘버
	private String pileNo;
	//천공깊이
	private String drillingDepth;
	//직타깊이
	private String directDrillingDepth;
	//전석층천공
	private String stDrillingDepth;
	//토사천공
	private String sdDrillingDepth;
	//관잎깊이
	private String intrusionDepth;
	//조각
	private List<Piece> piece;
	//용접개소
	private String connectLength;
	//합계
	private String totalConnectWidth;
	
	private List<Penetration> penetrations;
	//평균관입량
	private String avgPenetrationValue;
	//최종관입량
	private String totalPenetrationValue;
	//join
	private String name;
	//join
	private String lavelNo;
	//join
	private String createDate;
	//극한 지지력
	private String ultimateBearingCapacity;
    //단면적
    private String crossSection;
    //함마 효율
    private String hammaEfficiency;
    //탄성 계수
    private String modulusElasticity;

	private float gongSac;
	
	private String bigo;
	
	private String sprCol1;
	
	private int todayConstruction;
	
	private int totalConstruction;
	
	private int isDel;
	
	private int isDuple;
	
	private int isUpload;
	
	private int longCalYn;
	
	private int ubcYn;
	
	private int duplicated;
	
	private int totalDuplicated;
	
	private int role;
	//신규버전만 추가
	private int fcIdx;
	
	private String zone;
	
	/** new **/
	/**
	public float getGongSac() {
		float value = (Float.parseFloat(getIntrusionDepth() != "" ? getIntrusionDepth() : "0") + getBalance()) - (Float.parseFloat(getTotalConnectWidth() != "" ? getTotalConnectWidth() : "0"));
		return Float.parseFloat(String.format("%.1f", value));
	}
	
	public void setGongSac(float gongSac) {
		this.gongSac = gongSac;
	}
	
	
	public float getBalance() {
		return Float.parseFloat(String.format("%.1f", balance));
	}
	//잔량
	public void setBalance(float balance) {
		this.balance = balance;
	}
	**/
	
	/** old **/
	public float getGongSac() {
		return Float.parseFloat(String.format("%.1f", gongSac));
	}
	
	public void setGongSac(float gongSac) {
		this.gongSac = gongSac;
	}
	//잔량
	public float getBalance() {
		float value;
		try {
			if(getConstructionIdx() == 944 || getConstructionIdx() == 1136){
				value = Float.parseFloat(getTotalConnectWidth()) - Float.parseFloat(getIntrusionDepth() != "" ? getIntrusionDepth() : "0") - Float.parseFloat(getDrillingDepth() != "" ? getDrillingDepth() : "0");;
			}else {
				value = Float.parseFloat(getTotalConnectWidth()) - Float.parseFloat(getIntrusionDepth() != "" ? getIntrusionDepth() : "0");
			}
		}catch (Exception e) {
			value = 0;
		}
		if(value < 0)
		{
			setGongSac(value);
			return 0;
		}
		float result;
		try {
			if(getConstructionIdx() == 944 || getConstructionIdx() == 1136) {
				result = Float.parseFloat(getTotalConnectWidth()) - Float.parseFloat(getIntrusionDepth() != "" ? getIntrusionDepth() : "0") - Float.parseFloat(getDrillingDepth() != "" ? getDrillingDepth() : "0");
			}else {
				result = Float.parseFloat(getTotalConnectWidth()) - Float.parseFloat(getIntrusionDepth() != "" ? getIntrusionDepth() : "0");
			}
		}catch (Exception e) {
			result = 0;
		}
		return Float.parseFloat(String.format("%.2f", result));
	}
	//잔량
	public void setBalance(float balance) {
		this.balance = balance;
	}
	
	
}

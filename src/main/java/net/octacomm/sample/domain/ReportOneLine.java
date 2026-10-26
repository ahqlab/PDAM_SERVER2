package net.octacomm.sample.domain;

import java.util.List;
import java.math.BigDecimal;
import lombok.Data;

@Data
public class ReportOneLine implements Domain {
	
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
	// 항타기 종류
	private String machineType;
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
	// v2 화면 자동 계산용. DB 저장 대상 gongSac과 분리
	private float calculatedGongSac;
	
	private boolean gongSacNull = true;
	
	private String bigo;
	
	private String sprCol1;
	// 상부RPM
	private String topRpm;
	
	private int todayConstruction;
	
	private int totalConstruction;
	
	private int isDel;
	
	private int isDuple;
	
	private int isUpload;
	
	private int longCalYn;
	
	private int ubcYn;
	
	private String peOne;
	
	private String peTwo;
	
	private String peThree;
	
	private String peFour;
	
	private String peFive;
	
	private String peSix;
	
	private String peSeven;
	
	private String peEight;
	
	private String peNine;
	
	private String peTen;
	
	
	private String peidOne;
	
	private String peidTwo;
	
	private String peidThree;
	
	private String peidFour;
	
	private String peidFive;
	
	private String peidSix;
	
	private String peidSeven;
	
	private String peidEight;
	
	private String peidNine;
	
	private String peidTen;
	
	
	private String piOne;
	
	private String piTwo;
	
	private String piThree;
	
	private String piFour;
	
	private String piFive;
	
	private String piSix;
	
	private String piSeven;
	
	private String pidOne;
	
	private String pidTwo;
	
	private String pidThree;
	
	private String pidFour;
	
	private String pidFive;
	
	private String pidSix;
	
	private String pidSeven;
	
	private int duplicated;
	
	private int totalDuplicated;
	
	private int role;
	
	private int peLength;
	
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
	/** public float getGongSac() {
		//if (getDeviceIdx() == 3042 || "isoo".equals(getSprCol1())) {
		if ("isoo".equals(getSprCol1())) {
		//if (getConstructionIdx() == 1482) {
			// 역산: 천공깊이 - 관입깊이
			try {
				float drilling = Float.parseFloat(getDrillingDepth() != null && !getDrillingDepth().isEmpty() ? getDrillingDepth() : "0");
				float intrusion = Float.parseFloat(getIntrusionDepth() != null && !getIntrusionDepth().isEmpty() ? getIntrusionDepth() : "0");
				//System.err.println("Float.parseFloat(String.format(\"%.1f\", drilling - intrusion)) : " + Float.parseFloat(String.format("%.1f", drilling - intrusion)));
				return Float.parseFloat(String.format("%.2f", drilling - intrusion));
			} catch (Exception e) {
				return 0;
			}
		}
		return Float.parseFloat(String.format("%.1f", gongSac));
	} **/

	public float getGongSac() {
	    if ("isoo".equals(getSprCol1())) {
	        try {
	            float drilling = Float.parseFloat(
	                getDrillingDepth() != null && !getDrillingDepth().isEmpty()
	                    ? getDrillingDepth() : "0"
	            );

	            float intrusion = Float.parseFloat(
	                getIntrusionDepth() != null && !getIntrusionDepth().isEmpty()
	                    ? getIntrusionDepth() : "0"
	            );

	            return Float.parseFloat(
	                String.format("%.2f", drilling - intrusion)
	            );
	        } catch (Exception e) {
	            return 0.0f;
	        }
	    }

	    if (gongSacNull) {
	        calculatedGongSac = calculateV2GongSac();
	        return Math.round(calculatedGongSac * 10.0f) / 10.0f;
	    }

	    return Math.round(gongSac * 10.0f) / 10.0f;
	}

	private float calculateV2GongSac() {
	    try {
	        float result = parseFloatOrZero(getTotalConnectWidth())
                - parseFloatOrZero(getIntrusionDepth());

        if (getConstructionIdx() == 944 || getConstructionIdx() == 1136) {
            float drillingDepth = parseFloatOrZero(getDrillingDepth());
            result -= drillingDepth;
        }

	        return result < 0 ? result : 0.0f;
	    } catch (Exception e) {
	        return 0.0f;
	    }
	}

	public void setGongSac(Float gongSac) {
	    resetCalculatedGongSac();
	    this.gongSacNull = gongSac == null;
	    this.gongSac = gongSac == null ? 0.0f : gongSac;
	}

	private void resetCalculatedGongSac() {
	    this.calculatedGongSac = 0.0f;
	}

	public void setTotalConnectWidth(String totalConnectWidth) {
	    this.totalConnectWidth = totalConnectWidth;
	    resetCalculatedGongSac();
	}

	public void setIntrusionDepth(String intrusionDepth) {
	    this.intrusionDepth = intrusionDepth;
	    resetCalculatedGongSac();
	}

	public void setDrillingDepth(String drillingDepth) {
	    this.drillingDepth = drillingDepth;
	    resetCalculatedGongSac();
	}
	
	public void setGongSacNull() {
	    this.gongSac = 0.0f;
	    this.gongSacNull = true;
	}

	
	public boolean isGongSacNull() {
	    return gongSacNull;
	}
	
	//잔량
	public float getBalance() {
	    return gongSacNull ? getBalanceV2() : getBalanceV3();
	}

	private float getBalanceV2() {
	    try {
	        float total = parseFloatOrZero(getTotalConnectWidth());
	        float intrusion = parseFloatOrZero(getIntrusionDepth());

	        float result = total - intrusion;

	        if (getConstructionIdx() == 944 || getConstructionIdx() == 1136) {
	            float drillingDepth = parseFloatOrZero(getDrillingDepth());
	            result -= drillingDepth;
	        }

	        if (result < 0) {
	        if (calculatedGongSac == 0.0f) {
	            calculatedGongSac = result;
	        }
	            return 0.0f;
	        }

	        calculatedGongSac = 0.0f;
	        return Float.parseFloat(String.format("%.2f", result));
	    } catch (Exception e) {
	        calculatedGongSac = 0.0f;
	        return 0.0f;
	    }
	}

	private float getBalanceV3() {
	    try {
	        float result = parseFloatOrZero(getTotalConnectWidth())
	                - parseFloatOrZero(getIntrusionDepth());

        if (getConstructionIdx() == 944 || getConstructionIdx() == 1136) {
            result -= parseFloatOrZero(getDrillingDepth());
        }

        return Float.parseFloat(String.format("%.2f", result));
	    } catch (Exception e) {
	        return 0.0f;
	    }
	}

	private float parseFloatOrZero(String value) {
	    return value == null || value.trim().isEmpty()
	            ? 0.0f
	            : Float.parseFloat(value);
	}
	//잔량
	public void setBalance(float balance) {
		this.balance = balance;
	}
	
	private String groupName;
	
	private String constructionName;
    // 표시용 자동 계산과 분리한 DB 저장 원본값. NULL과 실제 0을 구분한다.
    @org.codehaus.jackson.annotate.JsonIgnore
    public Float getStoredGongSac() {
        return gongSacNull ? null : Float.valueOf(gongSac);
    }
}

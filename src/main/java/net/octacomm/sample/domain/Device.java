package net.octacomm.sample.domain;

import lombok.Data;

@Data
public class Device extends Construction  implements Domain {
	
	private int id;
	//시공사
	private int constructionIdx;
	//삼성엔지니어링만을 위한 zone 추가 
	private String zone;
	//삼성엔지니어링만을 위한 zone Count 추가
	private int countByZone;
	//삼성엔지니어링만을 위한 zone Count 추가
	private int totalCountByZone;
	//자동측정기번호    
	private String lavelNo;
	//블루투스번호
	private String bluetoothNo;
	//PDAM 테블릿 번호
	private String tabletNo;
	//유심번호
	private String usimNo;
	//비밀번호
	private String password;
	//우리시스템 매니저
	private String tabletManager;
	//우리시스템 매니저 연락처
	private String weContact;
	//시작일 
	private String startDate;
	//종료일
	private String endDate;
	//호기
	private String machineNumber;
	
	private String name;
	
	//사업시행여부
	private int conduct;
	//총 시공수량
	private int totalCnt;
	//금일 시공수량
	private int todayCnt;
	//하루전 시공수량
	private int yesterdayCnt;
	
	private String deviceName;
	
}

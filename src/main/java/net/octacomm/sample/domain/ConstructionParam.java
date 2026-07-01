package net.octacomm.sample.domain;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString(callSuper = true)
public class ConstructionParam extends DomainParam {
	
	private int groupIdx;
	
	private int fcIdx;  
	
	private String searchField;
	
	private String searchWord;
	
	private String startDate;

	private String endDate;

	// 상단 검색영역 체크박스 필터 (1이면 해당 조건 적용)
	// - 다른 묶음끼리는 AND, 같은 묶음(계약서 상태 / 시행상태) 안에서는 OR
	private int hasMemo;            // 메모가 있는 현장만
	private int contractRegistered; // 계약서 등록됨(미서명) 현장
	private int contractSigned;     // 계약서 서명됨 현장
	private int blockedOnly;        // 이용제한 설정된 현장만
	private int conductActive;      // 시행 현장 포함
	private int conductDone;        // 종료 현장 포함

	//private boolean vimManaged;

}

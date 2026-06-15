package net.octacomm.sample.domain;

import lombok.Data;

@Data
public class ConstructionSetting implements Domain{
	
	private static final long serialVersionUID = 1L;
	
	private int constructionIdx;   // PK
	
	private int role;

	private boolean isHiddenManager;
	
    private boolean useAdminReportTime; //기록지 시간 사용
    
    private boolean useGuestReportTime; //기록지 시간 사용
    
    private boolean useAdminOriginData; //원본 데이터 사용
    
    private boolean useGuestOriginData; //원본 데이터 사용
    
    private boolean useAdminFileMenu; //파일 반입 메뉴 사용
    
    private boolean useGuestFileMenu; //파일 반입 메뉴 사용
    
    private boolean useAdminPdf; //PDF 사용
    
    private boolean useGuestPdf; //PDF 사용
    
    private boolean useAdminExcel; //엑셀 사용
    
    private boolean useGuestExcel; //엑셀 사용
    
    private boolean useAdminTrash; //휴지통 사용
    
    private boolean useGuestTrash; //휴지통 사용
    
    private boolean useAdminEditReport; //기록지 수정
    
    private boolean useGuestEditReport; //기록지 수정
    
    private boolean useAdminDeleteReport; //기록지 삭제
    
    private boolean useGuestDeleteReport; //기록지 삭제
    
    private boolean useAdminRestoreReport; //기록지 복구
    
    private boolean useGuestRestoreReport; //기록지 복구
    
    private boolean useAdminEditDai; //천공,관입깊이 수정
    
    private boolean useGuestEditDai; //천공,관입깊이 수정
    
    private boolean useAdminUbc; //극한지지력 사용
    
    private boolean useGuestUbc; //극한지지력 사용

}

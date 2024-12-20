package net.octacomm.sample.domain;

import lombok.Data;

@Data
public class Construction implements Domain{

	//식별자
	private int id;
	//권한
	private int role;
	//시공사
	private String name;
	//현장명
	private String location;
	//현장주소
	private String address;
	//현장 담당자
	private String manager;
	//연락처
	private String contact;
	//현장 담당자
	private String conManager;
	//연락처
	private String conContact;
	//아이디
	private String userId;
	//비밀번호
	private String password;
	//보안코드
	private String secretCode;
	//그룹아이디
	private int groupIdx;
	//그룹아이디
	private String groupName;
	//생성일자
	private String createDate;
	//삭제여부
	private int isDel;
	//사업시행여부
	private int conduct;
	//가맹점 아이디
	private int fcIdx;
	//날짜여부
	private int longCalYn;
	//극한지지력 출력 여부
	private int ubcYn;
	//원본데이터 출력 여부
	private int originDataYn;
	//파일 항타기록지 PDF 노출 여부
	private int showPdfYn;
	//MOU 체결한 빔파트너스 의 관리여부
	//private int vimManaged;

}



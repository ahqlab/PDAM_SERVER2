package net.octacomm.sample.domain;

import lombok.Data;

@Data
public class ConstructionForAjax implements Domain{

	//식별자
	private String id;
	//권한
	private String role;
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
	//아이디
	private String userId;
	//비밀번호
	private String password;
	//보안코드
	private String secretCode;
	//그룹아이디
	private String groupIdx;
	//생성일자
	private String createDate;
	//삭제여부
	private String isDel;
	//사업시행여부
	private String conduct;
	//가맹점 아이디
	private String fcIdx;
	//날짜여부
	private String longCalYn;
	
	private String isDuplicate;
	
	private String confirmPassword;
	
	
}



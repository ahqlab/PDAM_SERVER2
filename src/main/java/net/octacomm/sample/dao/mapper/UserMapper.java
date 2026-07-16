package net.octacomm.sample.dao.mapper;


import net.octacomm.sample.domain.Construction;
import net.octacomm.sample.domain.User;

import org.apache.ibatis.annotations.CacheNamespace;
import org.apache.ibatis.annotations.Select;

/**
 * The MyBatis Mapper of "user" table  
 * 
 * @author tykim
 * 
 */
@CacheNamespace
public interface UserMapper {
	
//	@Select("SELECT * FROM TB_CONSTRUCTION WHERE userId = #{userId} and isDel = 0")
	// TB_SYSTEM_ADMIN.id는 TB_CONSTRUCTION.id와 겹치지 않도록 SYSTEM_ADMIN_ID_OFFSET(90000000)만큼 offset해서 내려준다.
	// LoginServiceImpl의 동일 상수와 짝을 맞춰야 시스템관리자 로그인 판별이 정확하다.
	@Select("SELECT * FROM (" +
			"	SELECT  userId , name, id , role, password, groupIdx, 0 as fcIdx, showPdfYn FROM TB_CONSTRUCTION where isDel = 0 " +
			"	UNION ALL " +
			"	SELECT userId, groupName as name,  1000, role, password , idx as groupIdx, 0 as fcIdx, 0 as showPdfYn FROM TB_GROUP WHERE TB_GROUP.userid is not null " +
			"	UNION ALL " +
			"	SELECT userId, fcName as name, 2000, role, password , 0 as groupIdx, idx as fcIdx, 0 as showPdfYn FROM TB_FRANCHISE WHERE TB_FRANCHISE.userid is not null " +
			"	UNION ALL " +
			"   SELECT userId, userName, constructionIdx, role, password , 0 as groupIdx, idx as fcIdx, 0 as showPdfYn FROM TB_MOU_USER WHERE TB_MOU_USER.userid is not null " +
			"	UNION ALL " +
			"	SELECT userId, name, (id + 90000000) as id, 0 as role, password, 0 as groupIdx, 0 as fcIdx, 0 as showPdfYn FROM TB_SYSTEM_ADMIN WHERE isDel = 0 " +
			") A WHERE userId = #{userId} ")
	Construction getUser(Construction construction);

//	@Select("SELECT * FROM TB_CONSTRUCTION WHERE userId = #{userId} AND password = #{password} and isDel = 0")
	@Select("SELECT * FROM (" +
			"	SELECT  userId , name, id , role, password, groupIdx, 0 as fcIdx, showPdfYn FROM TB_CONSTRUCTION where isDel = 0 " +
			"	UNION ALL " +
			"	SELECT userId, groupName as name,  1000, role, password , idx as groupIdx, 0 as fcIdx, 0 as showPdfYn FROM TB_GROUP WHERE TB_GROUP.userid is not null " +
			"	UNION ALL " +
			"	SELECT userId, fcName as name, 2000, role, password , 0 as groupIdx, idx as fcIdx, 0 as showPdfYn FROM TB_FRANCHISE WHERE TB_FRANCHISE.userid is not null " +
			"	UNION ALL " +
			"   SELECT userId, userName, constructionIdx, role, password , 0 as groupIdx, idx as fcIdx, 0 as showPdfYn FROM TB_MOU_USER WHERE TB_MOU_USER.userid is not null " +
			"	UNION ALL " +
			"	SELECT userId, name, (id + 90000000) as id, 0 as role, password, 0 as groupIdx, 0 as fcIdx, 0 as showPdfYn FROM TB_SYSTEM_ADMIN WHERE isDel = 0 " +
			") A WHERE userId = #{userId}  AND password = #{password} ")
	Construction getUserForAuth(Construction construction);
	
	@Select("SELECT * FROM TB_CONSTRUCTION WHERE userId = #{userId} AND CONCAT(password ,secretCode) = #{password} and isDel = 0")
	Construction findByHiddenManagerPassword(Construction construction);

}

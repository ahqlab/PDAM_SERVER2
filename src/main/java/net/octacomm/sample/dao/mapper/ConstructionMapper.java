package net.octacomm.sample.dao.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.CacheNamespace;
import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import net.octacomm.sample.dao.CRUDMapper;
import net.octacomm.sample.domain.ConOptionCondition;
import net.octacomm.sample.domain.Construction;
import net.octacomm.sample.domain.ConstructionForAjax;
import net.octacomm.sample.domain.ConstructionParam;

@CacheNamespace
public interface ConstructionMapper extends CRUDMapper<Construction, ConstructionParam, Integer>{
	
	public String INSERT_FIELDS = " ( role, name, location , address , manager, contact, conManager, conContact, userId , password , groupIdx, secretCode , fcIdx, createDate, isDel, longCalYn, ubcYn, originDataYn, showPdfYn  )";
	
	public String INSERT_VALUES = " ( 1, #{name}, #{location}, #{address}, #{manager}, #{contact},  #{conManager}, #{conContact}, #{userId}, #{password}, #{groupIdx} , #{secretCode} , if(#{fcIdx} = 0, null, #{fcIdx}) , now(), 0 , #{longCalYn}, #{ubcYn}, #{originDataYn} , #{showPdfYn} )";
	
	public String TABLE_NAME = " TB_CONSTRUCTION ";
	
	public String UPDATE_VALUES = " role = #{role} , name = #{name} ,  location = #{location} , address = #{address}, manager = #{manager} , contact = #{contact} , conManager = #{conManager} , conContact = #{conContact} , userId = #{userId}, password = #{password} , groupIdx = #{groupIdx} , secretCode = #{secretCode}  , longCalYn = #{longCalYn} , ubcYn = #{ubcYn}, originDataYn = #{originDataYn} , showPdfYn = #{showPdfYn}  ";
	
	public String SELECT_FIELDS = " id, name, manager, password, contact, createDate, location, role, userId, address, isDel, groupIdx, secretCode, conduct, fcIdx, longCalYn, ubcYn, originDataYn, showPdfYn ";
	
	@Insert("INSERT INTO " + TABLE_NAME + " " + INSERT_FIELDS + " VALUES " + INSERT_VALUES)
	@Override
	int insert(Construction domain);
	
	
	@Insert("INSERT INTO " + TABLE_NAME + " " + INSERT_FIELDS + " VALUES " + INSERT_VALUES)
	int insertOfAjax(ConstructionForAjax domain);
		
	@Select("SELECT TB_CONSTRUCTION.*, (SELECT groupName FROM TB_GROUP WHERE idx = TB_CONSTRUCTION.groupIdx) as groupName FROM " + TABLE_NAME + " WHERE id =  #{id} and isDel = 0")
	@Override
	Construction get(Integer id);
	
	@Override
	int update(Construction domain);
	
	@Delete("DELETE FROM " + TABLE_NAME + " WHERE id =  #{id} and isDel = 0")
	@Override
	int delete(Integer id);
	
	@Select("SELECT" + SELECT_FIELDS + "FROM " + TABLE_NAME)
	@Override
	public List<Construction> getList();
	
	@Select("SELECT" + SELECT_FIELDS + "FROM " + TABLE_NAME + " WHERE userId = #{userId} and isDel = 0")
	List<Construction> getFindByContact(String userId);
	
	
	@Select("SELECT" + SELECT_FIELDS + "FROM " + TABLE_NAME + " WHERE id = #{constructionIdx} and isDel = 0")
	List<Construction> getListByConstructionIdx(int constructionIdx);
	
	@Update("UPDATE " + TABLE_NAME + " SET isDel = 1 where id = #{id}")
	int doDelete(int id);
	
	//@Select(" SELECT IF(id = 815, LOCATION , CONCAT(CONCAT(IFNULL((SELECT  groupName  FROM TB_GROUP  WHERE TB_GROUP.idx = TB_CONSTRUCTION.groupIdx), ''), CONCAT(' ', NAME)), CONCAT(' ', LOCATION))) AS NAME  FROM TB_CONSTRUCTION WHERE id = #{id}")
//	@Select(" SELECT IF(${role} = 0,CONCAT(CONCAT(IFNULL((SELECT groupName from TB_GROUP WHERE TB_GROUP.idx = TB_CONSTRUCTION.groupIdx), ''),  CONCAT(' ',NAME)), CONCAT(' ',LOCATION)) , LOCATION) AS NAME  FROM TB_CONSTRUCTION WHERE id = #{id}")
//	Construction getFullName(@Param("id") int id, @Param("role") int role);
	@Select("SELECT \r\n" + 
			"  (SELECT groupName \r\n" + 
			"   FROM TB_GROUP \r\n" + 
			"   WHERE TB_GROUP.idx = TB_CONSTRUCTION.groupIdx) AS groupName ,\r\n" + 
			"  NAME AS constructionName ,\r\n" + 
			"  LOCATION AS constructionLocation ,\r\n" + 
			"  ADDRESS AS constructionAddress\r\n" + 
			"FROM TB_CONSTRUCTION\r\n" + 
			"WHERE id = #{id}")
	Map<String, Object> getFullName(@Param("id") int id, @Param("role") int role);
	
	@Select(" SELECT IF(${role} = 0,CONCAT(CONCAT(IFNULL((SELECT groupName from TB_GROUP WHERE TB_GROUP.idx = TB_CONSTRUCTION.groupIdx), ''),  CONCAT(' ',NAME)), CONCAT(' ',LOCATION)) , LOCATION) AS NAME  FROM TB_CONSTRUCTION WHERE id = #{id}")
	Construction getFullNameByConstruction(@Param("id") int id, @Param("role") int role);

	@Update("UPDATE " + TABLE_NAME + " SET conduct = #{conduct} where id = #{id}")
	int updateConduct(@Param("id") int id, @Param("conduct") int conduct);

	@Update("INSERT INTO TB_CONSTRUCTION_BLOCK (constructionIdx, blockedYn) VALUES (#{id}, #{blockedYn}) "
			+ "ON DUPLICATE KEY UPDATE blockedYn = #{blockedYn}")
	int updateBlockedYn(@Param("id") int id, @Param("blockedYn") int blockedYn);

	@Select("SELECT IFNULL((SELECT blockedYn FROM TB_CONSTRUCTION_BLOCK WHERE constructionIdx = #{id}), 0)")
	int getBlockedYn(@Param("id") int id);

	// 계약서 적용 대상 여부. 1이면 관리자가 지정한 계약 대상 현장.
	@Select("SELECT IFNULL((SELECT targetYn FROM TB_CONTRACT_TARGET WHERE constructionIdx = #{id}), 0)")
	int getContractTargetYn(@Param("id") int id);

	@Update("INSERT INTO TB_CONTRACT_TARGET (constructionIdx, targetYn) VALUES (#{id}, #{targetYn}) "
			+ "ON DUPLICATE KEY UPDATE targetYn = #{targetYn}")
	int updateContractTargetYn(@Param("id") int id, @Param("targetYn") int targetYn);
		
	@Select("\r\n" + 
			"SELECT \r\n" + 
			"	IFNULL((SELECT fcName FROM TB_FRANCHISE WHERE idx =  A.fcIdx ), '없음') AS fcName\r\n" + 
			"    , A.secretCode\r\n" + 
			"	, IF(A.longCalYn = 0 , 'OFF', 'ON') as longCalYn\r\n" + 
			"	, IF(A.ubcYn = 0 , 'OFF', 'ON') as ubcYn\r\n" + 
			"	, IF(A.originDataYn = 0 , 'OFF', 'ON') as originDataYn\r\n" + 
			"	, IF(A.showPdfYn= 0 , 'OFF', 'ON') as showPdfYn\r\n" + 
			"FROM TB_CONSTRUCTION A WHERE A.id =  #{constructionIdx} ;")
	ConOptionCondition getConOptionCondition(@Param("constructionIdx") int constructionIdx);


	String getConstructionName(@Param("constructionIdx") int constructionIdx);

	@Select(" SELECT * FROM TB_CONSTRUCTION WHERE ID = #{id}  AND now() > DATE_ADD(createDate, INTERVAL 14 DAY) ")
	Construction findByIdAndCreateDate(@Param("id") int id);

	// 계약 게이팅용: 이 현장이 계약서 적용 대상으로 지정됐는지. 1이면 계약 프로세스 적용.
	@Select("SELECT IFNULL((SELECT targetYn FROM TB_CONTRACT_TARGET WHERE constructionIdx = #{id}), 0)")
	int isContractTarget(@Param("id") int id);

	@Select("SELECT COUNT(*) FROM TB_CONSTRUCTION t, TB_CONSTRUCTION_SETTING_CONFIG c WHERE t.id = #{id} AND t.createDate >= c.APPLY_FROM_DATE")
	int isSettingRequired(@Param("id") int id);

	@Update("UPDATE " + TABLE_NAME + " SET password = #{password} WHERE id = #{id}")
	int updatePasswordById(@Param("id") int id, @Param("password") String password);

	@Update("UPDATE " + TABLE_NAME + " SET secretCode = #{secretCode} WHERE id = #{id}")
	int updateSecretCodeById(@Param("id") int id, @Param("secretCode") String secretCode);

	int updateBasicInfo(Construction domain);

}

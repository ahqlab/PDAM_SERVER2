package net.octacomm.sample.dao.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import net.octacomm.sample.dao.CRUDMapper;
import net.octacomm.sample.domain.SpareDevice;
import net.octacomm.sample.domain.SpareDeviceParam;

public interface SpareDeviceMapper  extends CRUDMapper<SpareDevice, SpareDeviceParam, Integer>{
	
	public String INSERT_FIELDS = " ( id , constructionIdx, type, status, quantity, bluetoothNo, lavelNo, bigo, createDate )";
	
	public String INSERT_VALUES = " ( null, #{constructionIdx}, #{type}, #{status}, #{quantity}, #{bluetoothNo}, #{lavelNo}, #{bigo}, now() )";
	
	public String TABLE_NAME = " TB_SPARE_DEVICE ";
	
	public String UPDATE_VALUES = "constructionIdx = #{constructionIdx}, "
			+ "type = #{type}, "
			+ "quantity = #{quantity}, "
			+ "bluetoothNo = #{bluetoothNo}, "
			+ "lavelNo = #{lavelNo}, "
			+ "bigo = #{bigo}";
	
	public String SELECT_FIELDS = " id , constructionIdx, type, status, quantity,  bluetoothNo, lavelNo, IFNULL(bigo, '') as bigo, createDate ";
	
	@Insert("INSERT INTO " + TABLE_NAME + " " + INSERT_FIELDS + " VALUES " + INSERT_VALUES)
	@Override
	int insert(SpareDevice domain);
	
	@Select("SELECT * FROM " + TABLE_NAME + " WHERE id =  #{id}")
	@Override
	SpareDevice get(Integer id);
	
	@Update("UPDATE  " + TABLE_NAME + " SET " + UPDATE_VALUES  + " WHERE id =  #{id}")
	@Override
	int update(SpareDevice domain);
	
	@Delete("DELETE FROM " + TABLE_NAME + " WHERE id =  #{id}")
	@Override
	int delete(Integer id);

	@Select("SELECT" + SELECT_FIELDS + "FROM " + TABLE_NAME)
	@Override
	List<SpareDevice> getList();
	
	@Select("SELECT "
			+ 	"id, "
			+ 	"constructionIdx, "
			+ 	"type, "
			+ 	"status, "
			+ 	"quantity, "
			+ 	"bluetoothNo, "
			+ 	"lavelNo, "
			+ 	"IFNULL(bigo, '') as bigo, "
			+ 	"createDate "
			+ " FROM " + TABLE_NAME + " "
			+ "WHERE constructionIdx = #{constructionIdx} "
			+ "  AND type = #{type} "
			+ "  AND status = 0 ")
	List<SpareDevice> getListBySpareDevice(SpareDevice spareDevice);
	
	@Select("SELECT "
			+ 	"id, "
			+ 	"constructionIdx, "
			+ 	"type, "
			+ 	"status, "
			+ 	"quantity, "
			+ 	"bluetoothNo, "
			+ 	"lavelNo, "
			+ 	"IFNULL(bigo, '') as bigo, "
			+ 	"createDate "
			+ " FROM " + TABLE_NAME + " "
			+ "WHERE constructionIdx = #{constructionIdx} "
			+ "  AND type = 0 "
			+ "  AND status = 1 ")
	List<SpareDevice> getListByChageDevice(SpareDevice spareDevice);
	
	@Delete("DELETE FROM " + TABLE_NAME + " WHERE constructionIdx =  #{constructionIdx} and type = #{type} and status = #{status}")
	int deleteByConstructionIdxAndType(@Param("constructionIdx") int constructionIdx, @Param("type") int type , @Param("status") int status);

	@Delete("DELETE FROM " + TABLE_NAME + " WHERE id =  #{changeId}")
	int deleteByIdx(@Param("changeId") int changeId);
	
	@Select("SELECT \r\n" + 
			"	(select count(*) from TB_SPARE_DEVICE where constructionIdx = #{constructionIdx} and type = 0 and status = 0) as spareDeviceCount\r\n" + 
			"    , (select IFNULL(sum(quantity),0) from TB_SPARE_DEVICE where constructionIdx = #{constructionIdx} and type = 1) as tripodCount\r\n" + 
			"	 , (select count(*) from TB_SPARE_DEVICE where constructionIdx = #{constructionIdx} and type = 0 and status = 1) as changeDeviceCount\r\n" + 
			"FROM TB_CONSTRUCTION WHERE TB_CONSTRUCTION.id = #{constructionIdx}  AND TB_CONSTRUCTION.conduct = 0 ")
	Map<String, String> getRegQuantity(@Param("constructionIdx") int constructionIdx);
	
	@Update("UPDATE \r\n" + 
			"	TB_DEVICE A , (SELECT bluetoothNo, lavelNo FROM TB_SPARE_DEVICE WHERE id = #{changeId}) B\r\n" + 
			"SET\r\n" + 
			"	A.bluetoothNo = B.bluetoothNo\r\n" + 
			"   , A.lavelNo = B.lavelNo\r\n" + 
			"WHERE A.id = #{targetId}" + 
			"")
	int doChangeDevice(@Param("targetId") int targetId, @Param("changeId") int changeId);
	
	@Update("UPDATE\r\n" + 
			"	TB_SPARE_DEVICE A\r\n" + 
			"SET\r\n" + 
			"	A.status = #{status}\r\n" + 
			"where A.id = #{changeId}")
	int changeStatus(@Param("changeId") int changeId, @Param("status") int status);
	
	void leftToRight(@Param("constructionIdx") int constructionIdx, @Param("targetId") int targetId, @Param("status") int status);
	
	@Select("SELECT" + SELECT_FIELDS + "FROM " + TABLE_NAME + " WHERE constructionIdx = #{constructionIdx} and type = 0 and status <> 1")
	List<SpareDevice> getNotChangeListBySpareDevice(SpareDevice spareDevice);


	@Select("SELECT sum(quantity) as  quantity FROM " + TABLE_NAME + " WHERE constructionIdx = #{constructionIdx} and type = 1 and status = #{status}")
	String getTripodCount(@Param("constructionIdx") int constructionIdx,  @Param("status") int status);
	
	@Select("SELECT count(*) FROM " + TABLE_NAME + " WHERE constructionIdx = #{constructionIdx} and type = 1 and status = #{status}")
	int tripodFindByConstructionIdxAndType(@Param("constructionIdx") int constructionIdx, @Param("status") int status);
	
	@Update("UPDATE " + TABLE_NAME + " SET quantity = #{quantity} WHERE constructionIdx = #{constructionIdx} and type = 1 and status = #{status}")
	int setTripodCount(@Param("constructionIdx") int constructionIdx, @Param("quantity") int quantity, @Param("status") int status);


	
	
	
}

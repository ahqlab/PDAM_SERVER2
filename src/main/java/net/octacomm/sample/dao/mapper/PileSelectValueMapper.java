package net.octacomm.sample.dao.mapper;

import java.util.List;

import org.apache.ibatis.annotations.CacheNamespace;
import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import net.octacomm.sample.domain.PileSelectValue;

@CacheNamespace
public interface PileSelectValueMapper {
	
	public String INSERT_FIELDS = " ( id, pileType, pileStandard , thickness, crossSection   )";
	
	public String INSERT_VALUES = " ( null, #{pileType}, #{pileStandard} , #{thickness}, #{crossSection} )";
	
	public String TABLE_NAME = " TB_PILE_SELECT_VALUE ";
	
	public String UPDATE_VALUES = " pileType = #{pileType} , pileStandard = #{pileStandard},  thickness = #{thickness}, crossSection = #{crossSection}, ";
	
	public String SELECT_FIELDS = " id, pileType, pileStandard , thickness, crossSection, sortSeq , subSortSeq ";
	
	@Insert("INSERT INTO " + TABLE_NAME + " " + INSERT_FIELDS + " VALUES " + INSERT_VALUES)
	int insert(PileSelectValue domain);
		
	@Select("SELECT * FROM " + TABLE_NAME + " WHERE id =  #{id} ")
	PileSelectValue get(Integer id);
	
	@Update("UPDATE " + TABLE_NAME + " SET " + UPDATE_VALUES + " WHERE id =  #{id} ")
	int update(PileSelectValue domain);
	
	@Delete("DELETE FROM " + TABLE_NAME + " WHERE id =  #{id} ")
	int delete(Integer id);
	
	@Select("SELECT" + SELECT_FIELDS + " FROM " + TABLE_NAME)
	public List<PileSelectValue> getList();
	
	@Select("SELECT pileType FROM " + SELECT_FIELDS + " GROUP BY pileType")
	public List<PileSelectValue> getPileTypeList();

	@Select("SELECT" + SELECT_FIELDS + " FROM " + TABLE_NAME + " WHERE deviceIdx =  #{deviceIdx} ")
	public List<PileSelectValue> getListByDeviceIdx(@Param("deviceIdx") int deviceIdx);

}

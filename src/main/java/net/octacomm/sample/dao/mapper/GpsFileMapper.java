package net.octacomm.sample.dao.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import net.octacomm.sample.dao.CRUDMapper;
import net.octacomm.sample.domain.DesignDepth;
import net.octacomm.sample.domain.DesignDepthParam;
import net.octacomm.sample.domain.GpsFile;
import net.octacomm.sample.domain.GpsFileParam;
import net.octacomm.sample.domain.TotalWorkQuantity;
import net.octacomm.sample.domain.TotalWorkQuantityParam;

public interface GpsFileMapper extends CRUDMapper<GpsFile, GpsFileParam, Integer> {
	
	public String INSERT_FIELDS = " ( id , constructionIdx, point, xAxis, yAxis , zAxis , code , createDate, lastModifiedDate )";
	
	public String INSERT_VALUES = " ( null, #{constructionIdx} , #{point}, #{xAxis}, #{yAxis}, #{zAxis}, #{code}, now(),  now() )";
	
	public String TABLE_NAME = " TB_GPS_FILE ";
	
	public String UPDATE_VALUES = " point = #{point} , xAxis = #{xAxis} , yAxis = #{yAxis} , zAxis = #{zAxis} , code = #{code} , lastModifiedDate = now() ";
	
	public String SELECT_FIELDS = " id , constructionIdx, point, xAxis, yAxis , zAxis , code , createDate, lastModifiedDate ";

	
	@Insert("INSERT INTO " + TABLE_NAME + " " + INSERT_FIELDS + " VALUES " + INSERT_VALUES)
	@Override
	int insert(GpsFile gpsFile);
	
	@Select("SELECT * FROM " + TABLE_NAME + " WHERE constructionIdx =  #{constructionIdx}")
	@Override
	GpsFile get(Integer id);

	@Update("UPDATE  " + TABLE_NAME + " SET " + UPDATE_VALUES  + " WHERE id =  #{id}")
	@Override
	int update(GpsFile gpsFile);
	
	@Delete("DELETE FROM " + TABLE_NAME + " WHERE id =  #{id}")
	@Override
	int delete(Integer id);

	@Select("SELECT * FROM " + TABLE_NAME)
	@Override
	List<GpsFile> getList();
	
	
	@Delete("DELETE FROM " + TABLE_NAME + " WHERE  constructionIdx =  #{constructionIdx}")
	void deleteByConstructionIdx(@Param("constructionIdx") int constructionIdx);
	
	@Select("SELECT * FROM " + TABLE_NAME + " WHERE constructionIdx =  #{constructionIdx} order by id asc")
	List<GpsFile>  selectByConstructionIdx(int constructionIdx);
	
	int insertMulti(@Param("list") List<GpsFile> list);
}

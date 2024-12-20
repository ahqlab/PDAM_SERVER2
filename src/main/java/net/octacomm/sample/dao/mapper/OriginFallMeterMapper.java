package net.octacomm.sample.dao.mapper;

import java.util.List;

import org.apache.ibatis.annotations.CacheNamespace;
import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import net.octacomm.sample.dao.CRUDMapper;
import net.octacomm.sample.domain.DefaultParam;
import net.octacomm.sample.domain.FallMeter;
import net.octacomm.sample.domain.Piece;

@CacheNamespace
public interface OriginFallMeterMapper extends CRUDMapper<FallMeter, DefaultParam, Integer>{
	
	public String INSERT_FIELDS = " ( reportIdx, name, value )";
	
	public String INSERT_VALUES = " ( #{reportIdx}, #{name}, #{value} )";
	
	public String TABLE_NAME = " TB_FALL_METER_ORIGIN ";
	
	public String UPDATE_VALUES = " name = #{name} , value = #{value} ";
	
	public String SELECT_FIELDS = " id, reportIdx, name,  IF(value = 0, '', value) AS value ";
	
	@Insert("INSERT INTO " + TABLE_NAME + " " + INSERT_FIELDS + " VALUES " + INSERT_VALUES)
	@Override
	int insert(FallMeter domain);
	
	@Insert("INSERT INTO  " + TABLE_NAME + " ( id, reportIdx, name, value ) VALUES ( #{id}, #{reportIdx}, #{name}, #{value} )")
	int insertOrigin(FallMeter domain);
	
	@Select("SELECT * FROM " + TABLE_NAME + " WHERE id =  #{id}")
	@Override
	FallMeter get(Integer id);
	
	@Override
	@Update("UPDATE  " + TABLE_NAME + " SET " + UPDATE_VALUES  + " WHERE id =  #{id}")
	int update(FallMeter domain);
	
	@Delete("DELETE FROM " + TABLE_NAME + " WHERE id =  #{id}")
	@Override
	int delete(Integer id);
	
	@Select("SELECT" + SELECT_FIELDS + "FROM " + TABLE_NAME)
	@Override
	public List<FallMeter> getList();



}

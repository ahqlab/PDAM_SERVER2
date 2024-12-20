package net.octacomm.sample.dao.mapper;

import java.util.List;

import org.apache.ibatis.annotations.CacheNamespace;
import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import net.octacomm.sample.dao.CRUDMapper;
import net.octacomm.sample.domain.Construction;
import net.octacomm.sample.domain.ConstructionParam;
import net.octacomm.sample.domain.DefaultParam;
import net.octacomm.sample.domain.Device;
import net.octacomm.sample.domain.DeviceParam;
import net.octacomm.sample.domain.Penetration;
import net.octacomm.sample.domain.Piece;

@CacheNamespace
public interface OriginPenetrationMapper extends CRUDMapper<Penetration, DefaultParam, Integer>{
	
	public String INSERT_FIELDS = " ( reportIdx, name, value )";
	
	public String INSERT_VALUES = " ( #{reportIdx}, #{name}, #{value} )";
	
	public String TABLE_NAME = " TB_PENETRATION_ORIGIN ";
	
	public String UPDATE_VALUES = " name = #{name} , value = #{value} ";
	
	public String SELECT_FIELDS = " id, reportIdx, name, value ";
	
	@Insert("INSERT INTO " + TABLE_NAME + " " + INSERT_FIELDS + " VALUES " + INSERT_VALUES)
	@Override
	int insert(Penetration domain);
	
	@Insert("INSERT INTO TB_PENETRATION_ORIGIN ( id, reportIdx, name, value ) VALUES ( #{id}, #{reportIdx}, #{name}, #{value} )")
	int insertOrigin(Penetration domain);
		
	@Select("SELECT * FROM " + TABLE_NAME + " WHERE id =  #{id}")
	@Override
	Penetration get(Integer id);
	
	@Update("UPDATE TB_PENETRATION_ORIGIN SET value = #{value} WHERE id =  #{id}")
	@Override
	int update(Penetration domain);
	
	@Delete("DELETE FROM " + TABLE_NAME + " WHERE id =  #{id}")
	@Override
	int delete(Integer id);
	
	@Select("SELECT" + SELECT_FIELDS + "FROM " + TABLE_NAME)
	@Override
	public List<Penetration> getList();
	
	@Select("SELECT" + SELECT_FIELDS + "FROM " + TABLE_NAME + " where reportIdx = #{reportIdx} and TB_PENETRATION_ORIGIN.value > 0")
	List<Penetration> getListByReportIdx(@Param("reportIdx") int reportIdx);
	
	
	@Select("SELECT id, reportIdx, name , value FROM " + TABLE_NAME + " where reportIdx = #{reportIdx}")
	List<Penetration> getListByReportIdxOfCopy(@Param("reportIdx") int reportIdx);


}

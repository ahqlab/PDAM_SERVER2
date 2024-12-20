package net.octacomm.sample.dao.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import net.octacomm.sample.dao.CRUDMapper;
import net.octacomm.sample.domain.WeManager;
import net.octacomm.sample.domain.WeManagerParam;

public interface WeManagerMapper extends CRUDMapper<WeManager, WeManagerParam, Integer>{
	
	public String INSERT_FIELDS = " ( id, name, position, phone )";
	
	public String INSERT_VALUES = " ( null, #{name} , #{position}, #{phone} )";
	
	public String TABLE_NAME = " TB_WE_MANAGER ";
	
	public String UPDATE_VALUES = " name = #{name}, position = #{position}, phone = #{phone} ";
	
	public String SELECT_FIELDS = " id, name, position, phone  ";
	
	@Insert("INSERT INTO " + TABLE_NAME + " " + INSERT_FIELDS + " VALUES " + INSERT_VALUES)
	@Override
	int insert(WeManager domain);
	
	@Select("SELECT * FROM " + TABLE_NAME + " WHERE id =  #{id}")
	@Override
	WeManager get(Integer id);

	@Update("UPDATE  " + TABLE_NAME + " SET " + UPDATE_VALUES  + " WHERE id =  #{id}")
	@Override
	int update(WeManager domain);
	
	@Delete("DELETE FROM " + TABLE_NAME + " WHERE id =  #{id}")
	@Override
	int delete(Integer id);

	@Select("SELECT" + SELECT_FIELDS + "FROM " + TABLE_NAME)
	@Override
	List<WeManager> getList();
	
	
	

}

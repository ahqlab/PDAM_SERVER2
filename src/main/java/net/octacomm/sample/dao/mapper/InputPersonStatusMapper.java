package net.octacomm.sample.dao.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import net.octacomm.sample.dao.CRUDMapper;
import net.octacomm.sample.domain.InputPersonStatus;
import net.octacomm.sample.domain.InputPersonStatusParam;

public interface InputPersonStatusMapper extends CRUDMapper<InputPersonStatus, InputPersonStatusParam, Integer>{
	
	public String INSERT_FIELDS = " ( ipsIdx, constructionIdx , deviceIdx , operDate, type, name, preDay, today, bigo )";
	
	public String INSERT_VALUES = " ( #{ipsIdx}, #{constructionIdx} , #{deviceIdx} ,  #{operDate}, #{type}, #{name}, #{preDay}, #{today}, #{bigo} )";
	
	public String TABLE_NAME = " TB_INPUT_PERSON_STATUS ";
	
	public String UPDATE_VALUES = " operDate = #{operDate} , type = #{type} , name = #{name} , preDay = #{preDay} , today = #{today} , bigo = #{bigo} ";
	
	public String SELECT_FIELDS = " ipsIdx, constructionIdx , deviceIdx , operDate, type, name, preDay, today, bigo ";
	
	@Insert("INSERT INTO " + TABLE_NAME + " " + INSERT_FIELDS + " VALUES " + INSERT_VALUES)
	@Override
	int insert(InputPersonStatus domain);
	
	@Select("SELECT * FROM " + TABLE_NAME + " WHERE ddidx =  #{ddidx}")
	@Override
	InputPersonStatus get(Integer id);

	@Update("UPDATE  " + TABLE_NAME + " SET " + UPDATE_VALUES  + " WHERE ipsIdx =  #{ipsIdx}")
	@Override
	int update(InputPersonStatus domain);
	
	@Delete("DELETE FROM " + TABLE_NAME + " WHERE ipsIdx =  #{ipsIdx}")
	@Override
	int delete(Integer id);

	@Select("SELECT" + SELECT_FIELDS + "FROM " + TABLE_NAME)
	@Override
	List<InputPersonStatus> getList();
	
	
	

}

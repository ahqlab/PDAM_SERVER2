package net.octacomm.sample.dao.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import net.octacomm.sample.dao.CRUDMapper;
import net.octacomm.sample.domain.CommonErp;
import net.octacomm.sample.domain.CommonErpParam;
import net.octacomm.sample.domain.InputPersonStatus;
import net.octacomm.sample.domain.InputPersonStatusParam;

public interface CommonErpMapper extends CRUDMapper<CommonErp, CommonErpParam, Integer>{
	
	public String INSERT_FIELDS = " ( id, constructionIdx , deviceIdx, operDate, erpDiv,  dmiCol,  preDay, today, dSum, bigo )";
	
	public String INSERT_VALUES = " ( null, #{constructionIdx} , #{deviceIdx}, #{operDate}, #{erpDiv}, #{dmiCol},  #{preDay}, #{today}, #{dSum}, #{bigo} )";
	
	public String TABLE_NAME = " TB_COMMON_ERP ";
	
	public String UPDATE_VALUES = " dmiCol = #{dmiCol}, preDay = #{preDay}, today = #{today}, dSum = #{dSum},  bigo = #{bigo} ";
	
	public String SELECT_FIELDS = " id, constructionIdx , deviceIdx, operDate, erpDiv, dmiCol, preDay, today, dSum, bigo ";
	
	@Insert("INSERT INTO " + TABLE_NAME + " " + INSERT_FIELDS + " VALUES " + INSERT_VALUES)
	@Override
	int insert(CommonErp domain);
	
	@Select("SELECT * FROM " + TABLE_NAME + " WHERE id =  #{id}")
	@Override
	CommonErp get(Integer id);

	@Update("UPDATE  " + TABLE_NAME + " SET " + UPDATE_VALUES  + " WHERE id =  #{id}")
	@Override
	int update(CommonErp domain);
	
	@Delete("DELETE FROM " + TABLE_NAME + " WHERE id =  #{id}")
	@Override
	int delete(Integer id);

	@Select("SELECT" + SELECT_FIELDS + "FROM " + TABLE_NAME)
	@Override
	List<CommonErp> getList();
	
	
	

}

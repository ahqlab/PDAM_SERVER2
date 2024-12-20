package net.octacomm.sample.dao.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import net.octacomm.sample.dao.CRUDMapper;
import net.octacomm.sample.domain.DesignDepth;
import net.octacomm.sample.domain.DesignDepthParam;
import net.octacomm.sample.domain.TotalWorkQuantity;
import net.octacomm.sample.domain.TotalWorkQuantityParam;

public interface TotalWorkQuantityMapper extends CRUDMapper<TotalWorkQuantity, TotalWorkQuantityParam, Integer> {
	
	public String INSERT_FIELDS = " ( id, constructionIdx, quantity, quantityLeft, processRate, createDate )";
	
	public String INSERT_VALUES = " ( null, #{constructionIdx}, #{quantity}, #{quantityLeft}, #{processRate},  now() )";
	
	public String TABLE_NAME = " TB_TOTAL_WORK_QUANTITY ";
	
	public String UPDATE_VALUES = " quantity = #{quantity} , quantityLeft = #{quantityLeft} , processRate = #{processRate} , lastModified = now() ";
	
	public String SELECT_FIELDS = " id, constructionIdx, quantity, quantityLeft, processRate, createDate , lastModified ";

	
	@Insert("INSERT INTO " + TABLE_NAME + " " + INSERT_FIELDS + " VALUES " + INSERT_VALUES)
	@Override
	int insert(TotalWorkQuantity domain);
	
	@Select("SELECT * FROM " + TABLE_NAME + " WHERE constructionIdx =  #{constructionIdx}")
	@Override
	TotalWorkQuantity get(Integer id);

	@Update("UPDATE  " + TABLE_NAME + " SET " + UPDATE_VALUES  + " WHERE constructionIdx =  #{constructionIdx}")
	@Override
	int update(TotalWorkQuantity domain);
	
	@Delete("DELETE FROM " + TABLE_NAME + " WHERE id =  #{id}")
	@Override
	int delete(Integer id);

	@Select("SELECT * FROM " + TABLE_NAME)
	@Override
	List<TotalWorkQuantity> getList();
}

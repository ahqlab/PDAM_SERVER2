package net.octacomm.sample.dao.mapper;

import java.util.List;

import org.apache.ibatis.annotations.CacheNamespace;
import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import net.octacomm.sample.dao.CRUDMapper;
import net.octacomm.sample.domain.Franchise;
import net.octacomm.sample.domain.FranchiseParam;
import net.octacomm.sample.domain.Group;

@CacheNamespace
public interface FranchiseMapper extends CRUDMapper<Franchise, FranchiseParam, Integer>{
	
	public String INSERT_FIELDS = " ( idx, fcName, userId, password, createDate , lastModifiedDate, role  )";
	
	public String INSERT_VALUES = " ( null, #{fcName}, #{userId}, #{password}, now(), now(), #{role} )";
	
	public String TABLE_NAME = " TB_FRANCHISE ";
	
	public String UPDATE_VALUES = " fcName = #{fcName} , isDel = #{isDel} lastModifiedDate = now() ";
	
	public String SELECT_FIELDS = " idx, fcName,  isDel,  createDate, lastModifiedDate ";
	
	@Insert("INSERT INTO " + TABLE_NAME + " " + INSERT_FIELDS + " VALUES " + INSERT_VALUES)
	@Override
	int insert(Franchise domain);
		
	@Select("SELECT * FROM " + TABLE_NAME + " WHERE idx =  #{idx} and isDel = 0")
	@Override
	Franchise get(Integer id);
	
	@Override
	int update(Franchise domain);
	
	@Delete("DELETE FROM " + TABLE_NAME + " WHERE idx =  #{idx} and isDel = 0")
	@Override
	int delete(Integer id);
	
	@Select("SELECT" + SELECT_FIELDS + "FROM " + TABLE_NAME + " WHERE  isDel = 0")
	@Override
	public List<Franchise> getList();
	
	@Select("SELECT * FROM TB_FRANCHISE WHERE userId = #{userId} and isDel = 0")
	Franchise selectByUserId(@Param("userId") String userId);
	
	
	

}

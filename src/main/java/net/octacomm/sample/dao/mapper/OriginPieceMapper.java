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
import net.octacomm.sample.domain.Piece;

@CacheNamespace
public interface OriginPieceMapper extends CRUDMapper<Piece, DefaultParam, Integer>{
	
	public String INSERT_FIELDS = " ( reportIdx, name, value )";
	
	public String INSERT_VALUES = " ( #{reportIdx}, #{name}, #{value} )";
	
	public String TABLE_NAME = " TB_PIECE_ORIGIN ";
	
	public String UPDATE_VALUES = " name = #{name} , value = #{value} ";
	
	public String SELECT_FIELDS = " id, reportIdx, name,  IF(value = 0, '', value) AS value ";
	
	@Insert("INSERT INTO " + TABLE_NAME + " " + INSERT_FIELDS + " VALUES " + INSERT_VALUES)
	@Override
	int insert(Piece domain);
	
	@Insert("INSERT INTO TB_PIECE_ORIGIN ( id, reportIdx, name, value ) VALUES ( #{id}, #{reportIdx}, #{name}, #{value} )")
	int insertOrigin(Piece domain);
	
	@Select("SELECT * FROM " + TABLE_NAME + " WHERE id =  #{id}")
	@Override
	Piece get(Integer id);
	
	@Override
	@Update("UPDATE  " + TABLE_NAME + " SET " + UPDATE_VALUES  + " WHERE id =  #{id}")
	int update(Piece domain);
	
	@Delete("DELETE FROM " + TABLE_NAME + " WHERE id =  #{id}")
	@Override
	int delete(Integer id);
	
	@Select("SELECT" + SELECT_FIELDS + "FROM " + TABLE_NAME)
	@Override
	public List<Piece> getList();

	
	@Select("SELECT" + SELECT_FIELDS + "FROM " + TABLE_NAME + " where reportIdx = #{reportIdx} AND name = '단본'"
			+ " UNION "
			+ "SELECT" + SELECT_FIELDS + "FROM " + TABLE_NAME + " where reportIdx = #{reportIdx} AND name = '하단'"
			+ " UNION "
			+ "SELECT" + SELECT_FIELDS + "FROM " + TABLE_NAME + " where reportIdx = #{reportIdx} AND name = '중단'" 
			+ " UNION "
			+ "SELECT" + SELECT_FIELDS + "FROM " + TABLE_NAME + " where reportIdx = #{reportIdx} AND name = '상단'")
	List<Piece> getListByReportIdx(@Param("reportIdx") int reportIdx);
	
	@Select("SELECT id, reportIdx, name , value FROM " + TABLE_NAME + " where reportIdx = #{reportIdx}")
	List<Piece> getListByReportIdxOfCopy(@Param("reportIdx") int reportIdx);

	Piece isDhere(Piece piese);

}

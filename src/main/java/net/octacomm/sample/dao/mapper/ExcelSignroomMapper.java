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
import net.octacomm.sample.domain.ExcelSignroom;
import net.octacomm.sample.domain.ExcelSignroomParam;
import net.octacomm.sample.domain.PdfSignroom;
import net.octacomm.sample.domain.PdfSignroomParam;

public interface ExcelSignroomMapper extends CRUDMapper<ExcelSignroom, ExcelSignroomParam, Integer> {
	
	public String INSERT_FIELDS = " ( id, constructionIdx, seq, approver , creator , createDate , modifyter , lastModifiedDate )";
	
	public String INSERT_VALUES = " ( null, #{constructionIdx}, #{seq}, #{approver} , #{creator} , now() , #{modifyter} , now() )";
	
	public String TABLE_NAME = " TB_EXCEL_SIGNROOM ";
	
	public String UPDATE_VALUES = " constructionIdx = #{constructionIdx} , seq = #{seq} , approver = #{approver} , modifyter = #{modifyter} , lastModifiedDate = now() ";
	
	public String SELECT_FIELDS = " id, constructionIdx, seq, approver , creator , createDate , modifyter , lastModifiedDate ";
	
	@Insert("INSERT INTO " + TABLE_NAME + " " + INSERT_FIELDS + " VALUES " + INSERT_VALUES)
	@Override
	int insert(ExcelSignroom domain);
		
	@Select("SELECT * FROM " + TABLE_NAME + " WHERE id =  #{id}")
	@Override
	ExcelSignroom get(Integer id);
	
	@Override
	@Update("UPDATE  " + TABLE_NAME + " SET " + UPDATE_VALUES  + " WHERE id =  #{id}")
	int update(ExcelSignroom domain);
	
	@Delete("DELETE FROM " + TABLE_NAME + " WHERE id =  #{id}")
	@Override
	int delete(Integer ddIdx);
	
	@Select("SELECT" + SELECT_FIELDS + "FROM " + TABLE_NAME)
	@Override
	public List<ExcelSignroom> getList();
	
	@Select("SELECT" + SELECT_FIELDS + "FROM " + TABLE_NAME + " WHERE constructionIdx =  #{constructionIdx}  ORDER BY seq ASC")
	List<ExcelSignroom> getFindByConstructionIdx(@Param("constructionIdx") int constructionIdx);

	int registAll(@Param("list") List<ExcelSignroom> list);

	int updateAll(@Param("list") List<ExcelSignroom> list);

	
	@Select("SELECT" + SELECT_FIELDS + "FROM " + TABLE_NAME + " WHERE constructionIdx =  #{constructionIdx} AND approver IS NOT NULL ORDER BY seq ASC")
	List<ExcelSignroom> getFindByConstructionIdxAndOrderBy(int constructionIdx);
	
	
}

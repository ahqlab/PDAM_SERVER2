package net.octacomm.sample.dao.mapper;



import java.util.List;

import org.apache.ibatis.annotations.CacheNamespace;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import net.octacomm.sample.domain.Survey;

/**
 * The MyBatis Mapper of "user" table  
 * 
 * @author tykim
 * 
 */
@CacheNamespace
public interface SurveyMapper {
	
	public String INSERT_FIELDS = " ( id,  checkbox1, checkbox2, checkbox3, checkbox4, checkbox5, checkbox6,  guitar, constructionIdx, conManager,  createDate )";
	
	public String INSERT_VALUES = " ( null, #{checkbox1}, #{checkbox2}, #{checkbox3}, #{checkbox4}, #{checkbox5}, #{checkbox6},  #{guitar}, #{constructionIdx},  #{conManager}, now() )";
	
	public String TABLE_NAME = " TB_SURVEY ";
	
	@Insert("INSERT INTO " + TABLE_NAME + " " + INSERT_FIELDS + " VALUES " + INSERT_VALUES)
	int insert(Survey survey);
	
	@Select("SELECT * FROM TB_SURVEY WHERE constructionIdx = #{constructionIdx} or replace(conManager,' ', '') = replace(#{conManager},' ', '')")
	List<Survey> findByConstructioIdx(@Param("constructionIdx") int constructionIdx, @Param("conManager") String conManger);
	
}

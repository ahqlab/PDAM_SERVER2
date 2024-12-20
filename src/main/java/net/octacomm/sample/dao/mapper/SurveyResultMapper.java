package net.octacomm.sample.dao.mapper;

import java.util.List;

import org.apache.ibatis.annotations.CacheNamespace;
import org.apache.ibatis.annotations.Select;

import net.octacomm.sample.domain.SurveyResult;

@CacheNamespace
public interface SurveyResultMapper {
	
	
	@Select("SELECT * FROM  ( " + 
			"	SELECT  " + 
			"		1 AS NUM, " + 
			"		COUNT(checkbox1) AS TOTAL_CNT, " + 
			"		'1) PDAM 시스템 사용 방법은 간단합니까?' AS SURVEY_CONTENT, " + 
			"		(SELECT COUNT(*) FROM TB_SURVEY WHERE checkbox1 = 1) AS SURVEY1, " + 
			"		(SELECT COUNT(*) FROM TB_SURVEY WHERE checkbox1 = 2) AS SURVEY2, " + 
			"		(SELECT COUNT(*) FROM TB_SURVEY WHERE checkbox1 = 3) AS SURVEY3, " + 
			"		(SELECT COUNT(*) FROM TB_SURVEY WHERE checkbox1 = 4) AS SURVEY4, " + 
			"		(SELECT COUNT(*) FROM TB_SURVEY WHERE checkbox1 = 5) AS SURVEY5 " + 
			"	FROM TB_SURVEY " + 
			"	UNION ALL " + 
			"	SELECT  " + 
			"		2 AS NUM, " + 
			"		COUNT(checkbox2) AS TOTAL_CNT, " + 
			"		'2) PDAM 시스템 적용으로 업무에 도움이 되었습니까?' AS SURVEY_CONTENT, " + 
			"		(SELECT COUNT(*) FROM TB_SURVEY WHERE checkbox2 = 1) AS SURVEY1, " + 
			"		(SELECT COUNT(*) FROM TB_SURVEY WHERE checkbox2 = 2) AS SURVEY2, " + 
			"		(SELECT COUNT(*) FROM TB_SURVEY WHERE checkbox2 = 3) AS SURVEY3, " + 
			"		(SELECT COUNT(*) FROM TB_SURVEY WHERE checkbox2 = 4) AS SURVEY4, " + 
			"		(SELECT COUNT(*) FROM TB_SURVEY WHERE checkbox2 = 5) AS SURVEY5 " + 
			"	FROM TB_SURVEY " + 
			"	UNION ALL " + 
			"	SELECT  " + 
			"		3 AS NUM, " + 
			"		COUNT(checkbox3) AS TOTAL_CNT, " + 
			"		'3) PDAM 도입으로 안전사고예방에 도움이 되었습니까?' AS SURVEY_CONTENT, " + 
			"		(SELECT COUNT(*) FROM TB_SURVEY WHERE checkbox3 = 1) AS SURVEY1, " + 
			"		(SELECT COUNT(*) FROM TB_SURVEY WHERE checkbox3 = 2) AS SURVEY2, " + 
			"		(SELECT COUNT(*) FROM TB_SURVEY WHERE checkbox3 = 3) AS SURVEY3, " + 
			"		(SELECT COUNT(*) FROM TB_SURVEY WHERE checkbox3 = 4) AS SURVEY4, " + 
			"		(SELECT COUNT(*) FROM TB_SURVEY WHERE checkbox3 = 5) AS SURVEY5 " + 
			"	FROM TB_SURVEY " + 
			"	UNION ALL " + 
			"	SELECT " + 
			"		4 AS NUM,  " + 
			"		COUNT(checkbox4) AS TOTAL_CNT, " + 
			"		'4) PDAM 도입으로 시공 시 신뢰성이 확보 되었습니까?' AS SURVEY_CONTENT, " + 
			"		(SELECT COUNT(*) FROM TB_SURVEY WHERE checkbox4 = 1) AS SURVEY1, " + 
			"		(SELECT COUNT(*) FROM TB_SURVEY WHERE checkbox4 = 2) AS SURVEY2, " + 
			"		(SELECT COUNT(*) FROM TB_SURVEY WHERE checkbox4 = 3) AS SURVEY3, " + 
			"		(SELECT COUNT(*) FROM TB_SURVEY WHERE checkbox4 = 4) AS SURVEY4, " + 
			"		(SELECT COUNT(*) FROM TB_SURVEY WHERE checkbox4 = 5) AS SURVEY5 " + 
			"	FROM TB_SURVEY " + 
			"	UNION ALL " + 
			"	SELECT  " + 
			"		5 AS NUM, " + 
			"		COUNT(checkbox5) AS TOTAL_CNT, " + 
			"		'5) PDAM 시스템을 다음 현장에도 적용하시겠습니까?' AS SURVEY_CONTENT, " + 
			"		(SELECT COUNT(*) FROM TB_SURVEY WHERE checkbox5 = 1) AS SURVEY1, " + 
			"		(SELECT COUNT(*) FROM TB_SURVEY WHERE checkbox5 = 2) AS SURVEY2, " + 
			"		(SELECT COUNT(*) FROM TB_SURVEY WHERE checkbox5 = 3) AS SURVEY3, " + 
			"		(SELECT COUNT(*) FROM TB_SURVEY WHERE checkbox5 = 4) AS SURVEY4, " + 
			"		(SELECT COUNT(*) FROM TB_SURVEY WHERE checkbox5 = 5) AS SURVEY5 " + 
			"FROM TB_SURVEY) SERVEY ORDER BY NUM ASC")
	List<SurveyResult> selectResult();

}

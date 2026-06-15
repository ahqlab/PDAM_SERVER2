package net.octacomm.sample.dao.mapper;


import net.octacomm.sample.domain.AuthCode;
import net.octacomm.sample.domain.Construction;
import net.octacomm.sample.domain.ExtensivePileUsage;
import net.octacomm.sample.domain.User;

import org.apache.ibatis.annotations.CacheNamespace;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

/**
 * The MyBatis Mapper of "user" table  
 * 
 * @author tykim
 * 
 */
@CacheNamespace
public interface ExtensivePileUsageMapper {
	
 	@Select("SELECT * FROM TB_EXTENSIVE_PILE_USAGE WHERE constructionIdx = #{constructionIdx}")
 	ExtensivePileUsage findByConstructionIdx(@Param("constructionIdx") int constructionIdx);
	 	
 }

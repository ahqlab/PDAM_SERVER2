package net.octacomm.sample.dao.mapper;

import java.util.List;

import org.apache.ibatis.annotations.CacheNamespace;
import org.apache.ibatis.annotations.Select;

import net.octacomm.sample.domain.PileSrossSection;

@CacheNamespace
public interface PileCrosSectionMapper {
	
	
	@Select("SELECT * FROM TB_PILE_CROSS_SECTION ORDER BY id asc")
	List<PileSrossSection> getList();

}

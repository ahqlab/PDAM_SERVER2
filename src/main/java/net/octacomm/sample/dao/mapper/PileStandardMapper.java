package net.octacomm.sample.dao.mapper;

import java.util.List;

import org.apache.ibatis.annotations.CacheNamespace;
import org.apache.ibatis.annotations.Select;

import net.octacomm.sample.domain.PileStandard;

@CacheNamespace
public interface PileStandardMapper {
	
	@Select("SELECT * FROM TB_PILE_STANDARD ORDER BY id asc")
	List<PileStandard> getList();

}

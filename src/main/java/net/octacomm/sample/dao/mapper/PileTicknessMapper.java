package net.octacomm.sample.dao.mapper;

import java.util.List;

import org.apache.ibatis.annotations.CacheNamespace;
import org.apache.ibatis.annotations.Select;

import net.octacomm.sample.domain.PileTickness;

@CacheNamespace
public interface PileTicknessMapper {
	
	@Select("SELECT * FROM TB_PILE_TICKNESS ORDER BY id asc")
	List<PileTickness> getList();
}

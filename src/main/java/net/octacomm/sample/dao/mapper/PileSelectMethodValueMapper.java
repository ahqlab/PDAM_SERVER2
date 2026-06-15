package net.octacomm.sample.dao.mapper;

import java.util.List;

import org.apache.ibatis.annotations.CacheNamespace;
import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import net.octacomm.sample.domain.PileSelectMethodValue;
import net.octacomm.sample.domain.PileSelectValue;

@CacheNamespace
public interface PileSelectMethodValueMapper {
	
	
	public String TABLE_NAME = " TB_PILE_SELECT_METHOD_VALUE ";
	public List<PileSelectValue> getPileTypeList();

	@Select("SELECT * FROM " + TABLE_NAME + " WHERE deviceIdx =  #{deviceIdx} ")
	public List<PileSelectMethodValue> getListByDeviceIdx(@Param("deviceIdx") int deviceIdx);

}

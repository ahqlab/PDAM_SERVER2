package net.octacomm.sample.dao.mapper;

import java.util.List;

import org.apache.ibatis.annotations.CacheNamespace;
import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import net.octacomm.sample.dao.CRUDMapper;
import net.octacomm.sample.domain.DeviceTestReport;
import net.octacomm.sample.domain.DeviceTestReportParam;

@CacheNamespace
public interface DeviceTestReportMapper extends CRUDMapper<DeviceTestReport, DeviceTestReportParam, Integer>{
	
	public String INSERT_FIELDS = " ( idx, mfr, type , sn , fileName , bigo  )";
	
	public String INSERT_VALUES = " ( null, #{mfr} , #{type} , #{sn} , #{fileName} , #{bigo} )";
	
	public String TABLE_NAME = " TB_DEVICE_TEST_REPORT ";
	
	public String UPDATE_VALUES = " mfr = #{mfr} , type = #{type} , bigo = #{bigo} ";
	
	public String SELECT_FIELDS = " idx, mfr, type , sn , fileName , file , bigo ";
	
	@Insert("INSERT INTO " + TABLE_NAME + " " + INSERT_FIELDS + " VALUES " + INSERT_VALUES)
	@Override
	int insert(DeviceTestReport domain);
		
	@Select("SELECT * FROM " + TABLE_NAME + " WHERE idx =  #{idx}")
	@Override
	DeviceTestReport get(Integer idx);
	
	@Update("UPDATE  " + TABLE_NAME + " SET " + UPDATE_VALUES  + " WHERE idx =  #{idx}")
	@Override
	int update(DeviceTestReport domain);
	
	@Delete("DELETE FROM " + TABLE_NAME + " WHERE idx =  #{idx}")
	@Override
	int delete(Integer id);
	
	@Select("SELECT" + SELECT_FIELDS + "FROM " + TABLE_NAME)
	@Override
	public List<DeviceTestReport> getList();

	
	@Select("SELECT * FROM " + TABLE_NAME + " WHERE sn =  #{sn}")
	DeviceTestReport getFindBySn(String sn);

	
		
}

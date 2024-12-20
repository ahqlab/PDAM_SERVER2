package net.octacomm.sample.dao.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import net.octacomm.sample.dao.CRUDMapper;
import net.octacomm.sample.domain.DefaultParam;
import net.octacomm.sample.domain.DeviceName;

public interface DeviceNameMapper extends CRUDMapper<DeviceName, DefaultParam, Integer>{
	
	public String INSERT_FIELDS = " ( id, deviceIdx, deviceName, createDate, lastModified  )";
	
	public String INSERT_VALUES = " ( null, #{deviceIdx}, #{deviceName}, now(), now() )";
	
	public String TABLE_NAME = " TB_DEVICE_NAME ";
	
	public String UPDATE_VALUES = " deviceName = #{deviceName} , lastModified = now() ";
	
	public String SELECT_FIELDS = " id, deviceIdx, deviceName, createDate, lastModified ";
	
	@Insert("INSERT INTO " + TABLE_NAME + " " + INSERT_FIELDS + " VALUES " + INSERT_VALUES)
	@Override
	int insert(DeviceName domain);
	
	@Select("SELECT * FROM " + TABLE_NAME + " WHERE id =  #{id}")
	@Override
	DeviceName get(Integer id);

	@Update("UPDATE  " + TABLE_NAME + " SET " + UPDATE_VALUES  + " WHERE deviceIdx =  #{deviceIdx}")
	@Override
	int update(DeviceName domain);
	
	@Delete("DELETE FROM " + TABLE_NAME + " WHERE id =  #{id} ")
	@Override
	int delete(Integer id);

	@Select("SELECT * FROM " + TABLE_NAME)
	@Override
	List<DeviceName> getList();
	
	@Select("SELECT * FROM " + TABLE_NAME + " WHERE deviceIdx =  #{deviceIdx}")
	List<DeviceName> getListByDeviceIdx(int deviceIdx);
	
	@Select("SELECT count(*) FROM " + TABLE_NAME + " WHERE deviceIdx =  #{deviceIdx}")
	int findByDeviceIdx(int deviceIdx);
	
}

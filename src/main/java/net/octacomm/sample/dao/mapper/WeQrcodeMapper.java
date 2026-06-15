package net.octacomm.sample.dao.mapper;



import java.util.List;

import org.apache.ibatis.annotations.CacheNamespace;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import net.octacomm.sample.dao.CRUDMapper;
import net.octacomm.sample.domain.DefaultParam;
import net.octacomm.sample.domain.FallMeter;
import net.octacomm.sample.domain.Survey;
import net.octacomm.sample.domain.WeQrcode;
import net.octacomm.sample.domain.WeQrcodeParam;

/**
 * The MyBatis Mapper of "user" table  
 * 
 * @author tykim
 * 
 */
@CacheNamespace
public interface WeQrcodeMapper extends CRUDMapper<WeQrcode, WeQrcodeParam, Integer>{
	
	
	public String TABLE_NAME = " TB_WE_QRCODE ";
	
	int insert(WeQrcode qrcode);
	
	@Select("SELECT * FROM  " + TABLE_NAME + " WHERE id = #{id} ")
	WeQrcode get(@Param("id") int id);

	
	@Update("UPDATE TB_WE_QRCODE SET qrSaveFilename = #{qrSaveFilename} WHERE id = #{qrId}")
	int updateQrCode(@Param("qrId") String prId , @Param("qrSaveFilename") String qrSaveFilename);
	
}

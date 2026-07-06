package net.octacomm.sample.dao.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Select;

import net.octacomm.sample.domain.BleDeviceMap;

/**
 * BLE 장비 매핑(blueNo ↔ MAC) 매퍼. 애노테이션 기반(별도 XML 없음).
 * TB_BLE_DEVICE_MAP 은 보조 테이블로 신규 생성(기존 테이블 ALTER 지양).
 */
public interface BleDeviceMapMapper {

	String TABLE_NAME = " TB_BLE_DEVICE_MAP ";

	// blueNo 는 문자열이지만 숫자 순서로 정렬해 응답한다.
	@Select("SELECT blueNo, macAddress, date_format(createDate, '%Y-%m-%d %H:%i:%s') AS createDate "
			+ "FROM " + TABLE_NAME + " ORDER BY CAST(blueNo AS UNSIGNED), blueNo")
	List<BleDeviceMap> getList();

	@Select("SELECT macAddress FROM " + TABLE_NAME + " WHERE blueNo = #{blueNo}")
	String getMacByBlueNo(String blueNo);

	// 관리자 등록/수정: blueNo 중복 시 MAC 갱신
	@Insert("INSERT INTO " + TABLE_NAME + " (blueNo, macAddress) VALUES (#{blueNo}, #{macAddress}) "
			+ "ON DUPLICATE KEY UPDATE macAddress = #{macAddress}")
	int upsert(BleDeviceMap domain);

	@Delete("DELETE FROM " + TABLE_NAME + " WHERE blueNo = #{blueNo}")
	int delete(String blueNo);

}

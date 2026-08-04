package net.octacomm.sample.dao.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import net.octacomm.sample.domain.DeviceBackupHistory;
import net.octacomm.sample.domain.Report;

public interface DeviceBackupHistoryMapper {

	List<DeviceBackupHistory> getListByDevice(
			@Param("constructionIdx") int constructionIdx,
			@Param("deviceId") int deviceId);

	DeviceBackupHistory getById(
			@Param("id") int id,
			@Param("constructionIdx") int constructionIdx,
			@Param("deviceId") int deviceId);

	int insertBackup(DeviceBackupHistory history);

	List<Report> getDeviceBackupReports(
			@Param("deviceId") int deviceId);

	int deleteDeviceBackupPieces(
			@Param("deviceId") int deviceId);

	int deleteDeviceBackupPenetrations(
			@Param("deviceId") int deviceId);

	int deleteDeviceBackupReports(
			@Param("deviceId") int deviceId);
}

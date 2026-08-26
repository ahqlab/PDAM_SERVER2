package net.octacomm.sample.dao.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import net.octacomm.sample.domain.ReportHistory;

public interface ReportHistoryMapper {
	int insertReportHistory(ReportHistory history);
	int insertPenetrationHistory(ReportHistory history);
	int insertPieceHistory(ReportHistory history);
	int countByDeviceAndDate(
			@Param("deviceIdx") int deviceIdx,
			@Param("workDate") String workDate);
	List<ReportHistory> findPageByDeviceAndDate(
			@Param("deviceIdx") int deviceIdx,
			@Param("workDate") String workDate,
			@Param("startRow") int startRow,
			@Param("pageSize") int pageSize);
	ReportHistory findSnapshotById(@Param("id") long id);
	ReportHistory findNextSnapshot(
			@Param("reportId") int reportId,
			@Param("historyId") int historyId);
	ReportHistory findCurrentSnapshot(@Param("reportId") int reportId);
}

package net.octacomm.sample.dao.mapper;

import net.octacomm.sample.domain.ReportHistory;

public interface ReportHistoryMapper {
	int insertReportHistory(ReportHistory history);
	int insertPenetrationHistory(ReportHistory history);
	int insertPieceHistory(ReportHistory history);
}

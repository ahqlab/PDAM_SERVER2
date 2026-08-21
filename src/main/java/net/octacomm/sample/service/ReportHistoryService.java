package net.octacomm.sample.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import net.octacomm.sample.dao.mapper.ReportHistoryMapper;
import net.octacomm.sample.domain.ReportHistory;

@Service
public class ReportHistoryService {
	public static final String STATUS_UPDATE = "UPDATE";
	public static final String STATUS_DELETE = "DELETE";
	public static final String STATUS_RESTORE = "RESTORE";
	
	@Autowired
	private ReportHistoryMapper reportHistoryMapper;
	@Transactional
	public long saveBeforeChange(int reportId, String status, String userId) {
		validate(status, userId);

		ReportHistory history = new ReportHistory();
		history.setReportId(reportId);
		history.setStatus(status);
		history.setUserId(userId);

		if (reportHistoryMapper.insertReportHistory(history) != 1) {
			throw new IllegalStateException("기록지 이력 저장에 실패했습니다. reportId=" + reportId);
		}

		reportHistoryMapper.insertPenetrationHistory(history);
		reportHistoryMapper.insertPieceHistory(history);

		return history.getId();
	}

	private void validate(String status, String userId) {
		if (!STATUS_UPDATE.equals(status) && !STATUS_DELETE.equals(status) && !STATUS_RESTORE.equals(status)) {
			throw new IllegalArgumentException("지원하지 않는 기록지 이력 상태입니다: " + status);
		}
		if (userId == null || userId.trim().isEmpty()) {
			throw new IllegalStateException("기록지 이력에 저장할 로그인 사용자 정보가 없습니다.");
		}
	}
}
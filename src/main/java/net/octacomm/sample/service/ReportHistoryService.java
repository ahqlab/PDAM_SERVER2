package net.octacomm.sample.service;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

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

	@Transactional(readOnly = true)
	public int countByDeviceAndDate(int deviceIdx, String workDate) {
		return reportHistoryMapper.countByDeviceAndDate(deviceIdx, workDate);
	}

	@Transactional(readOnly = true)
	public List<ReportHistory> findPageByDeviceAndDate(int deviceIdx, String workDate, int startRow, int pageSize) {
		List<ReportHistory> histories = reportHistoryMapper.findPageByDeviceAndDate(
				deviceIdx, workDate, startRow, pageSize);
		for (ReportHistory history : histories) {
			List<Map<String, String>> changes = findChanges(history);
			history.setChangeCount(changes.size());
			history.setChangeSummary(buildSummary(history.getStatus(), changes));
		}
		return histories;
	}

	@Transactional(readOnly = true)
	public List<Map<String, String>> findChanges(long historyId) {
		ReportHistory history = reportHistoryMapper.findSnapshotById(historyId);
		if (history == null) {
			return new ArrayList<Map<String, String>>();
		}
		return findChanges(history);
	}

	@Transactional(readOnly = true)
	public ReportHistory findById(long historyId) {
		return reportHistoryMapper.findSnapshotById(historyId);
	}

	private List<Map<String, String>> findChanges(ReportHistory before) {
		List<Map<String, String>> changes = new ArrayList<Map<String, String>>();

		if (STATUS_DELETE.equals(before.getStatus())) {
			changes.add(change("기록 상태", "사용", "삭제"));
			return changes;
		}
		if (STATUS_RESTORE.equals(before.getStatus())) {
			changes.add(change("기록 상태", "삭제", "복구"));
			return changes;
		}

		ReportHistory after = reportHistoryMapper.findNextSnapshot(before.getReportId(), before.getId());
		if (after == null) {
			after = reportHistoryMapper.findCurrentSnapshot(before.getReportId());
		}
		if (after == null) {
			return changes;
		}

		Map<String, String> beforeValues = snapshotValues(before);
		Map<String, String> afterValues = snapshotValues(after);
		for (Map.Entry<String, String> entry : beforeValues.entrySet()) {
			String beforeValue = normalize(entry.getValue());
			String afterValue = normalize(afterValues.get(entry.getKey()));
			if (!beforeValue.equals(afterValue)) {
				changes.add(change(entry.getKey(), beforeValue, afterValue));
			}
		}
		return changes;
	}

	private Map<String, String> snapshotValues(ReportHistory history) {
		Map<String, String> values = new LinkedHashMap<String, String>();
		values.put("호기", history.getMachineNumber());
		values.put("시공일", firstNonBlank(history.getCreateDate(), history.getCurrentDateTime()));
		values.put("파일종류", history.getPileType());
		values.put("시공공법", history.getMethod());
		values.put("시공위치", history.getLocation());
		values.put("파일번호", history.getPileNo());
		values.put("파일규격", history.getPileStandard());
		values.put("단본", history.getSingleLevel());
		values.put("하단", history.getBottomLevel());
		values.put("중단", history.getMiddleLevel());
		values.put("상단", history.getTopLevel());
		values.put("파일합계", history.getTotalConnectWidth());
		values.put("이음(개소)", history.getConnectLength());
		values.put("천공깊이", history.getDrillingDepth());
		values.put("직타깊이", history.getDirectDrillingDepth());
		values.put("전석층천공", history.getStDrillingDepth());
		values.put("토사천공", history.getSdDrillingDepth());
		values.put("관입깊이", history.getIntrusionDepth());
		values.put("파일잔량", history.getBalanceSnapshot());
		values.put("해머무게", history.getHammaT());
		values.put("낙하높이", history.getFallMeter());
		values.put("관리기준", history.getManagedStandard());
		values.put("1회 측정", history.getP1());
		values.put("2회 측정", history.getP2());
		values.put("3회 측정", history.getP3());
		values.put("4회 측정", history.getP4());
		values.put("5회 측정", history.getP5());
		values.put("6회 측정", history.getP6());
		values.put("7회 측정", history.getP7());
		values.put("8회 측정", history.getP8());
		values.put("9회 측정", history.getP9());
		values.put("10회 측정", history.getP10());
		values.put("평균관입", history.getAvgPenetrationValue());
		values.put("최종관입", history.getTotalPenetrationValue());
		values.put("극한지지력", history.getUltimateBearingCapacity());
		values.put("해머효율", history.getHammaEfficiency());
		values.put("탄성계수", history.getModulusElasticity());
		values.put("파일단면적", history.getCrossSection());
		values.put("비고", history.getBigo());
		values.put("메모", history.getSprCol1());
		return values;
	}

	private Map<String, String> change(String fieldName, String beforeValue, String afterValue) {
		Map<String, String> change = new LinkedHashMap<String, String>();
		change.put("fieldName", fieldName);
		change.put("beforeValue", beforeValue);
		change.put("afterValue", afterValue);
		return change;
	}

	private String normalize(String value) {
		if (value == null || value.trim().isEmpty() || "null".equalsIgnoreCase(value.trim())) {
			return "-";
		}
		return value.trim();
	}

	private String firstNonBlank(String primary, String fallback) {
		if (primary != null && !primary.trim().isEmpty() && !"null".equalsIgnoreCase(primary.trim())) {
			return primary;
		}
		return fallback;
	}

	private String buildSummary(String status, List<Map<String, String>> changes) {
		if (STATUS_DELETE.equals(status)) {
			return "기록 삭제";
		}
		if (STATUS_RESTORE.equals(status)) {
			return "삭제 기록 복구";
		}
		if (changes.isEmpty()) {
			return "기록 수정";
		}
		if (changes.size() == 1) {
			return changes.get(0).get("fieldName") + " 변경";
		}
		return changes.get(0).get("fieldName") + " 외 " + (changes.size() - 1) + "건 변경";
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

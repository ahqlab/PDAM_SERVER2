package net.octacomm.sample.service;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.codehaus.jackson.map.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import net.octacomm.sample.dao.mapper.DeviceBackupHistoryMapper;
import net.octacomm.sample.dao.mapper.ExtensivePileUsageMapper;
import net.octacomm.sample.dao.mapper.PenetrationMapper;
import net.octacomm.sample.dao.mapper.PieceMapper;
import net.octacomm.sample.dao.mapper.ReportMapper;
import net.octacomm.sample.domain.DeviceBackupHistory;
import net.octacomm.sample.domain.DeviceBackupSnapshot;
import net.octacomm.sample.domain.ExtensivePileUsage;
import net.octacomm.sample.domain.Penetration;
import net.octacomm.sample.domain.Piece;
import net.octacomm.sample.domain.Report;
import net.octacomm.sample.domain.ReportOneLine;
import net.octacomm.sample.domain.ReportParam;

@Service
public class DeviceBackupHistoryService {

	private static final String WORK_TYPE_INITIAL_SNAPSHOT = "초기 기록 보관";
	private static final String WORK_TYPE_CURRENT_SNAPSHOT = "현재 상태 보관";
	private static final String WORK_TYPE_APPLY_COMPLETED = "엑셀 수정 반영";
	private static final String WORK_TYPE_AUTO_BACKUP = "수정 전 자동 백업";

	@Autowired
	private DeviceBackupHistoryMapper deviceBackupHistoryMapper;

	@Autowired
	private ReportMapper reportMapper;

	@Autowired
	private PieceMapper pieceMapper;

	@Autowired
	private PenetrationMapper penetrationMapper;

	@Autowired
	private ExtensivePileUsageMapper extensivePileUsageMapper;

	private final ObjectMapper objectMapper = new ObjectMapper();

	@Transactional
	public DeviceBackupHistory createAutomaticBackup(
			int constructionIdx, int deviceId) {
		return insertBackup(
				constructionIdx,
				deviceId,
				WORK_TYPE_AUTO_BACKUP,
				createSnapshotData(constructionIdx, deviceId));
	}

	@Transactional
	public DeviceBackupHistory createCurrentBackupIfChanged(
			int constructionIdx, int deviceId) {
		String snapshotData = createSnapshotData(constructionIdx, deviceId);
		DeviceBackupHistory latestHistory =
				deviceBackupHistoryMapper.getLatestByDevice(
						constructionIdx, deviceId);
		if (latestHistory != null && hasSameReportData(
				snapshotData, latestHistory.getSnapshotData())) {
			return null;
		}

		return insertBackup(
				constructionIdx,
				deviceId,
				latestHistory == null
						? WORK_TYPE_INITIAL_SNAPSHOT : WORK_TYPE_CURRENT_SNAPSHOT,
				snapshotData);
	}

	@Transactional
	public DeviceBackupHistory createAppliedBackup(
			int constructionIdx, int deviceId) {
		String snapshotData = createSnapshotData(constructionIdx, deviceId);
		DeviceBackupHistory latestHistory =
				deviceBackupHistoryMapper.getLatestByDevice(
						constructionIdx, deviceId);
		if (latestHistory != null && hasSameReportData(
				snapshotData, latestHistory.getSnapshotData())) {
			return null;
		}

		return insertBackup(
				constructionIdx,
				deviceId,
				WORK_TYPE_APPLY_COMPLETED,
				snapshotData);
	}

	@Transactional
	public DeviceBackupHistory restoreBackup(
			int constructionIdx, int deviceId, int historyId) {
		DeviceBackupHistory selectedHistory =
				deviceBackupHistoryMapper.getById(
						historyId, constructionIdx, deviceId);
		if (selectedHistory == null
				|| selectedHistory.getSnapshotData() == null
				|| selectedHistory.getSnapshotData().isEmpty()) {
			throw new IllegalArgumentException("복구할 백업 데이터를 찾을 수 없습니다.");
		}

		if (hasSameReportData(createSnapshotData(constructionIdx, deviceId),
				selectedHistory.getSnapshotData())) {
			return selectedHistory;
		}

		createCurrentBackupIfChanged(constructionIdx, deviceId);

		DeviceBackupSnapshot selectedSnapshot =
				readSnapshot(selectedHistory.getSnapshotData());
		replaceDeviceReports(deviceId, selectedSnapshot.getReports());

		return insertBackup(
				constructionIdx,
				deviceId,
				selectedHistory.getVersion() + "기준 복구",
				selectedHistory.getSnapshotData());
	}

	public DeviceBackupSnapshot getSnapshot(
			int historyId, int constructionIdx, int deviceId) {
		DeviceBackupHistory history = deviceBackupHistoryMapper.getById(
				historyId, constructionIdx, deviceId);
		if (history == null
				|| history.getSnapshotData() == null
				|| history.getSnapshotData().isEmpty()) {
			return null;
		}
		return readSnapshot(history.getSnapshotData());
	}

	public DeviceBackupHistory getHistory(
			int historyId, int constructionIdx, int deviceId) {
		return deviceBackupHistoryMapper.getById(
				historyId, constructionIdx, deviceId);
	}

	private DeviceBackupHistory insertBackup(
			int constructionIdx,
			int deviceId,
			String workType,
			String snapshotData) {
		DeviceBackupHistory history = new DeviceBackupHistory();
		history.setConstructionIdx(constructionIdx);
		history.setDeviceId(deviceId);
		history.setWorkType(workType);
		history.setSnapshotData(snapshotData);

		if (deviceBackupHistoryMapper.insertBackup(history) != 1) {
			throw new IllegalStateException("백업 버전을 생성하지 못했습니다.");
		}
		return deviceBackupHistoryMapper.getById(
				history.getId(), constructionIdx, deviceId);
	}

	private String createSnapshotData(int constructionIdx, int deviceId) {
		DeviceBackupSnapshot snapshot = new DeviceBackupSnapshot();
		List<Report> reports = deviceBackupHistoryMapper.getDeviceBackupReports(deviceId);

		for (Report report : reports) {
			report.setPiece(
					pieceMapper.getListByReportIdxOfCopy(report.getId()));
			report.setPenetrations(
					penetrationMapper.getListByReportIdxOfCopy(report.getId()));
		}

		ReportParam param = new ReportParam();
		param.setId(deviceId);
		param.setConstructionIdx(constructionIdx);

		int isBig = reportMapper.isBigAllReports(param, constructionIdx);
		ExtensivePileUsage usage =
				extensivePileUsageMapper.findByConstructionIdx(constructionIdx);
		int extensivePileUsage = usage == null ? 0 : usage.getIsUsed();
		List<ReportOneLine> excelReports;

		if (isBig > 0) {
			excelReports = extensivePileUsage > 0
					? reportMapper.getListByParamExtensivePileUsageExcelTen(param)
					: reportMapper.getListByParamExcelTen(param);
		} else {
			excelReports = extensivePileUsage > 0
					? reportMapper.getListByParamExtensivePileUsageExcelFive(param)
					: reportMapper.getListByParamExcelFive(param);
		}

		snapshot.setReports(reports);
		snapshot.setExcelReports(excelReports);
		snapshot.setBig(isBig > 0);
		snapshot.setExtensivePileUsage(extensivePileUsage);

		try {
			return objectMapper.writeValueAsString(snapshot);
		} catch (IOException e) {
			throw new IllegalStateException("기록지 백업 데이터를 생성하지 못했습니다.", e);
		}
	}

	private DeviceBackupSnapshot readSnapshot(String snapshotData) {
		try {
			return objectMapper.readValue(
					snapshotData, DeviceBackupSnapshot.class);
		} catch (IOException e) {
			throw new IllegalStateException("백업 데이터를 읽지 못했습니다.", e);
		}
	}

	private boolean hasSameReportData(
			String leftSnapshotData, String rightSnapshotData) {
		if (leftSnapshotData == null || rightSnapshotData == null) {
			return false;
		}
		try {
			return createReportFingerprint(readSnapshot(leftSnapshotData))
					.equals(createReportFingerprint(readSnapshot(rightSnapshotData)));
		} catch (IllegalStateException e) {
			return false;
		}
	}

	private String createReportFingerprint(DeviceBackupSnapshot snapshot) {
		List<Report> reports = snapshot.getReports() == null
				? new ArrayList<Report>() : snapshot.getReports();
		for (Report report : reports) {
			report.setId(0);
			for (Piece piece : report.getPiece() == null
					? new ArrayList<Piece>() : report.getPiece()) {
				piece.setId(0);
				piece.setReportIdx(0);
			}
			for (Penetration penetration : report.getPenetrations() == null
					? new ArrayList<Penetration>() : report.getPenetrations()) {
				penetration.setId(0);
				penetration.setReportIdx(0);
			}
		}
		try {
			return objectMapper.writeValueAsString(reports);
		} catch (IOException e) {
			throw new IllegalStateException("기록지 백업 데이터를 비교하지 못했습니다.", e);
		}
	}

	private void replaceDeviceReports(
			int deviceId, List<Report> snapshotReports) {
		deviceBackupHistoryMapper.deleteDeviceBackupPieces(deviceId);
		deviceBackupHistoryMapper.deleteDeviceBackupPenetrations(deviceId);
		deviceBackupHistoryMapper.deleteDeviceBackupReports(deviceId);

		List<Report> reports = snapshotReports == null
				? new ArrayList<Report>() : snapshotReports;
		for (Report report : reports) {
			List<Piece> pieces = report.getPiece();
			List<Penetration> penetrations = report.getPenetrations();

			report.setId(0);
			report.setDeviceIdx(deviceId);
			if (reportMapper.insert(report) != 1) {
				throw new IllegalStateException("기록지 복구에 실패했습니다.");
			}

			if (pieces != null) {
				for (Piece piece : pieces) {
					piece.setId(0);
					piece.setReportIdx(report.getId());
					if (pieceMapper.insert(piece) != 1) {
						throw new IllegalStateException(
								"파일 구분 데이터 복구에 실패했습니다.");
					}
				}
			}

			if (penetrations != null) {
				for (Penetration penetration : penetrations) {
					penetration.setId(0);
					penetration.setReportIdx(report.getId());
					if (penetrationMapper.insert(penetration) != 1) {
						throw new IllegalStateException(
								"관입량 데이터 복구에 실패했습니다.");
					}
				}
			}
		}
	}
}

package net.octacomm.sample.service;

import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DataFormatter;
import org.apache.poi.ss.usermodel.FormulaEvaluator;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import net.octacomm.sample.dao.mapper.DeviceMapper;
import net.octacomm.sample.dao.mapper.ExtensivePileUsageMapper;
import net.octacomm.sample.dao.mapper.PenetrationMapper;
import net.octacomm.sample.dao.mapper.PieceMapper;
import net.octacomm.sample.dao.mapper.ReportMapper;
import net.octacomm.sample.domain.Device;
import net.octacomm.sample.domain.DeviceBackupHistory;
import net.octacomm.sample.domain.ExtensivePileUsage;
import net.octacomm.sample.domain.Penetration;
import net.octacomm.sample.domain.Piece;
import net.octacomm.sample.domain.ReportExcelUploadAnalysis;
import net.octacomm.sample.domain.ReportExcelUploadAnalysis.ChangeDetail;
import net.octacomm.sample.domain.ReportExcelUploadAnalysis.DuplicateDetail;
import net.octacomm.sample.domain.ReportExcelUploadAnalysis.DuplicateGroup;
import net.octacomm.sample.domain.ReportExcelUploadRecord;
import net.octacomm.sample.domain.ReportOneLine;
import net.octacomm.sample.domain.ReportParam;

@Service
public class ReportExcelUploadService {

	private static final int FIRST_DATA_ROW_INDEX = 4;
	private static final long MAX_UPLOAD_SIZE = 20L * 1024L * 1024L;

	@Autowired
	private ReportMapper reportMapper;

	@Autowired
	private DeviceMapper deviceMapper;

	@Autowired
	private ExtensivePileUsageMapper extensivePileUsageMapper;

	@Autowired
	private PieceMapper pieceMapper;

	@Autowired
	private PenetrationMapper penetrationMapper;

	@Autowired
	private DeviceBackupHistoryService deviceBackupHistoryService;

	public ReportExcelUploadAnalysis analyze(MultipartFile file, int deviceId, int constructionIdx) {
		return analyze(file, deviceId, constructionIdx, null);
	}

	public ReportExcelUploadAnalysis analyze(MultipartFile file, int deviceId, int constructionIdx,
			ReportParam comparisonParam) {
		try {
			AnalysisContext context = createAnalysisContext(
					file, deviceId, constructionIdx, comparisonParam);
			ReportExcelUploadAnalysis result = context.result;
			result.setSuccess(true);
			result.setAnalysisToken(createAnalysisToken(context));
			return result;
		} catch (Exception e) {
			ReportExcelUploadAnalysis result = new ReportExcelUploadAnalysis();
			result.setFileName(file == null ? "" : file.getOriginalFilename());
			result.setSuccess(false);
			result.setMessage(e.getMessage() == null ? "엑셀 분석 중 오류가 발생했습니다." : e.getMessage());
			return result;
		}
	}

	/**
	 * 화면에서 확인한 파일을 서버에서 다시 분석한 뒤, 현재 상태 백업과 실제
	 * 기록지 반영을 하나의 트랜잭션으로 처리한다.
	 */
	@Transactional(rollbackFor = Exception.class)
	public ReportExcelUploadAnalysis apply(MultipartFile file, int deviceId,
			int constructionIdx, ReportParam comparisonParam,
			String expectedAnalysisToken) throws Exception {
		AnalysisContext context = createAnalysisContext(
				file, deviceId, constructionIdx, comparisonParam);
		ReportExcelUploadAnalysis result = context.result;
		String currentToken = createAnalysisToken(context);

		if (normalize(expectedAnalysisToken).isEmpty()
				|| !currentToken.equals(expectedAnalysisToken)) {
			throw new IllegalStateException(
					"분석 이후 원본 기록지 또는 업로드 파일이 변경되었습니다. 중복 검사를 다시 진행해 주세요.");
		}
		if (result.getDuplicateCount() > 0) {
			throw new IllegalStateException(
					"중복 데이터가 있는 파일은 반영할 수 없습니다. 중복 항목을 먼저 정리해 주세요.");
		}

		int changeCount = result.getModifiedCount()
				+ result.getAddedCount() + result.getDeletedCount();
		if (changeCount == 0) {
			result.setSuccess(true);
			result.setApplied(false);
			result.setAnalysisToken(currentToken);
			result.setMessage("변경된 내용이 없어 기록지를 반영하지 않았습니다.");
			return result;
		}

		DeviceBackupHistory backup =
				deviceBackupHistoryService.createAutomaticBackup(
						constructionIdx, deviceId);
		applyChanges(context, deviceId);

		result.setSuccess(true);
		result.setApplied(true);
		result.setAnalysisToken(currentToken);
		result.setBackupVersion(backup.getVersion());
		result.setMessage("기록지 백업 및 반영이 완료되었습니다.");
		return result;
	}

	private AnalysisContext createAnalysisContext(MultipartFile file,
			int deviceId, int constructionIdx, ReportParam comparisonParam)
			throws Exception {
		validateFile(file);
		Device device = validateDevice(deviceId, constructionIdx);
		List<UploadedReportRow> uploadedRows = readRows(file);
		if (uploadedRows.isEmpty()) {
			throw new IllegalArgumentException(
					"분석할 기록지 데이터가 없습니다. 파일이 정확한지 확인해주세요.");
		}

		ReportParam effectiveComparisonParam =
				prepareComparisonParam(comparisonParam, uploadedRows);
		List<ReportOneLine> originalRows =
				getOriginalRows(deviceId, constructionIdx, effectiveComparisonParam);
		originalRows = filterOriginalRowsByComparisonScope(
				originalRows, effectiveComparisonParam, uploadedRows);

		ReportExcelUploadAnalysis result = new ReportExcelUploadAnalysis();
		result.setFileName(file.getOriginalFilename());
		buildAnalysis(result, uploadedRows, originalRows, device);

		AnalysisContext context = new AnalysisContext();
		context.result = result;
		context.uploadedRows = uploadedRows;
		context.originalRows = originalRows;
		return context;
	}

	private ReportParam prepareComparisonParam(ReportParam comparisonParam, List<UploadedReportRow> uploadedRows) {
		ReportParam param = comparisonParam == null ? new ReportParam() : comparisonParam;
		boolean allHistory = "all".equalsIgnoreCase(normalize(param.getType()));
		boolean hasDate = !normalize(param.getDate()).isEmpty();
		boolean hasDateRange = !normalize(param.getStartDate()).isEmpty() && !normalize(param.getEndDate()).isEmpty();

		if (allHistory || hasDate || hasDateRange) {
			return param;
		}

		String firstDate = "";
		String lastDate = "";
		for (UploadedReportRow row : uploadedRows) {
			String rowDate = normalizeDate(row.constructionDate);
			if (rowDate.isEmpty()) {
				continue;
			}
			if (firstDate.isEmpty() || rowDate.compareTo(firstDate) < 0) {
				firstDate = rowDate;
			}
			if (lastDate.isEmpty() || rowDate.compareTo(lastDate) > 0) {
				lastDate = rowDate;
			}
		}

		if (firstDate.isEmpty()) {
			return param;
		}
		if (firstDate.equals(lastDate)) {
			param.setDate(firstDate);
		} else {
			param.setStartDate(firstDate);
			param.setEndDate(lastDate);
		}
		return param;
	}

	private List<ReportOneLine> filterOriginalRowsByComparisonScope(List<ReportOneLine> originalRows,
			ReportParam comparisonParam, List<UploadedReportRow> uploadedRows) {
		List<ReportOneLine> filteredRows = new ArrayList<ReportOneLine>();
		if (originalRows == null || originalRows.isEmpty()) {
			return filteredRows;
		}

		String date = normalizeDate(comparisonParam.getDate());
		String startDate = normalizeDate(comparisonParam.getStartDate());
		String endDate = normalizeDate(comparisonParam.getEndDate());
		String location = normalizeIdentifier(comparisonParam.getLocation());
		String pileNo = normalizeIdentifier(comparisonParam.getPileNo());

		if ("today".equalsIgnoreCase(date)) {
			date = firstUploadedDate(uploadedRows);
		}

		boolean hasDate = !date.isEmpty();
		boolean hasDateRange = !startDate.isEmpty() && !endDate.isEmpty();
		boolean hasLocation = !location.isEmpty();
		boolean hasPileNo = !pileNo.isEmpty();
		if (!hasDate && !hasDateRange && !hasLocation && !hasPileNo) {
			return originalRows;
		}

		for (ReportOneLine original : originalRows) {
			String originalDate = originalDate(original);
			if (hasDate && !date.equals(originalDate)) {
				continue;
			}
			if (hasDateRange && (originalDate.compareTo(startDate) < 0 || originalDate.compareTo(endDate) > 0)) {
				continue;
			}
			if (hasLocation && !location.equals(normalizeIdentifier(original.getLocation()))) {
				continue;
			}
			if (hasPileNo && !pileNo.equals(normalizeIdentifier(original.getPileNo()))) {
				continue;
			}
			filteredRows.add(original);
		}
		return filteredRows;
	}

	private String firstUploadedDate(List<UploadedReportRow> uploadedRows) {
		for (UploadedReportRow row : uploadedRows) {
			String rowDate = normalizeDate(row.constructionDate);
			if (!rowDate.isEmpty()) {
				return rowDate;
			}
		}
		return "";
	}

	private void validateFile(MultipartFile file) {
		if (file == null || file.isEmpty()) {
			throw new IllegalArgumentException("업로드할 엑셀 파일을 선택해 주세요.");
		}
		if (file.getSize() > MAX_UPLOAD_SIZE) {
			throw new IllegalArgumentException("업로드 파일은 20MB를 초과할 수 없습니다.");
		}
		String name = file.getOriginalFilename();
		String lowerName = name == null ? "" : name.toLowerCase(Locale.ENGLISH);
		if (!lowerName.endsWith(".xls") && !lowerName.endsWith(".xlsx")) {
			throw new IllegalArgumentException("XLS 또는 XLSX 파일만 업로드할 수 있습니다.");
		}
	}

	private Device validateDevice(int deviceId, int constructionIdx) {
		Device device = deviceMapper.get(deviceId);
		if (device == null || device.getConstructionIdx() != constructionIdx) {
			throw new IllegalArgumentException("현재 현장에 속한 호기 정보를 찾을 수 없습니다.");
		}
		return device;
	}

	private List<UploadedReportRow> readRows(MultipartFile file) throws Exception {
		InputStream input = null;
		Workbook workbook = null;
		try {
			input = file.getInputStream();
			workbook = WorkbookFactory.create(input);
			if (workbook.getNumberOfSheets() == 0) {
				throw new IllegalArgumentException("엑셀 시트를 찾을 수 없습니다.");
			}

			Sheet sheet = workbook.getSheetAt(0);
			DataFormatter formatter = new DataFormatter();
			FormulaEvaluator evaluator = workbook.getCreationHelper().createFormulaEvaluator();
			ColumnLayout layout = detectColumnLayout(sheet, formatter, evaluator);
			List<UploadedReportRow> rows = new ArrayList<UploadedReportRow>();

			for (int index = FIRST_DATA_ROW_INDEX; index <= sheet.getLastRowNum(); index++) {
				Row row = sheet.getRow(index);
				if (row == null) {
					continue;
				}
				String firstValue = cellValue(row, 0, formatter, evaluator);
				if ("합계".equals(firstValue)) {
					break;
				}

				UploadedReportRow uploaded = readRow(row, layout, formatter, evaluator);
				if (uploaded.isEmpty()) {
					continue;
				}
				rows.add(uploaded);
			}
			return rows;
		} catch (IllegalArgumentException e) {
			throw e;
		} catch (Exception e) {
			throw new IllegalArgumentException("엑셀 파일을 읽을 수 없습니다. 손상 여부와 양식을 확인해 주세요.", e);
		} finally {
			if (workbook != null) {
				try {
					workbook.close();
				} catch (IOException ignored) {
				}
			}
			if (input != null) {
				try {
					input.close();
				} catch (IOException ignored) {
				}
			}
		}
	}

	private ColumnLayout detectColumnLayout(Sheet sheet, DataFormatter formatter, FormulaEvaluator evaluator) {
		ColumnLayout layout = new ColumnLayout();
		boolean tenMeasurement = findHeaderColumn(sheet, "10회", 20, 45, formatter, evaluator) >= 0;
		layout.totalConnectWidth = findHeaderColumn(sheet, "합계", 8, 22, formatter, evaluator);
		layout.connectLength = findHeaderColumn(sheet, "이음개소", 8, 25, formatter, evaluator);
		layout.drillingDepth = findHeaderColumn(sheet, "천공깊이", 8, 28, formatter, evaluator);
		layout.intrusionDepth = findHeaderColumn(sheet, "관입깊이", 8, 30, formatter, evaluator);
		if (layout.intrusionDepth < 0) {
			layout.intrusionDepth = findHeaderColumn(
					sheet, "경타깊이", 8, 32, formatter, evaluator);
		}
		if (layout.intrusionDepth < 0) {
			layout.intrusionDepth = findHeaderColumn(
					sheet, "경타길이", 8, 32, formatter, evaluator);
		}
		layout.directDrillingDepth = findHeaderColumn(
				sheet, "직타깊이", 8, 32, formatter, evaluator);
		layout.soilDrillingDepth = findHeaderColumn(
				sheet, "토사천공", 8, 32, formatter, evaluator);
		layout.stoneDrillingDepth = findHeaderColumn(
				sheet, "전석층천공", 8, 32, formatter, evaluator);
		layout.balance = findHeaderColumn(sheet, "파일잔량", 8, 32, formatter, evaluator);
		layout.gongSac = findHeaderColumn(sheet, "공삭공", 8, 34, formatter, evaluator);
		layout.hammaT = findHeaderColumn(sheet, "해머무게", 8, 36, formatter, evaluator);
		layout.fallMeter = findHeaderColumn(sheet, "낙하높이", 8, 38, formatter, evaluator);
		layout.managedStandard = findHeaderColumn(sheet, "관리기준", 8, 40, formatter, evaluator);
		layout.avgPenetrationValue = findHeaderColumn(sheet, "평균관입", 20, 48, formatter, evaluator);
		layout.totalPenetrationValue = findHeaderColumn(sheet, "총관입량", 20, 50, formatter, evaluator);
		layout.ultimateBearingCapacity =
				findHeaderColumn(sheet, "극한지지력", 20, 55, formatter, evaluator);
		layout.hammaEfficiency =
				findHeaderColumn(sheet, "해머효율", 20, 55, formatter, evaluator);
		layout.modulusElasticity =
				findHeaderColumn(sheet, "탄성계수", 20, 55, formatter, evaluator);
		layout.crossSection =
				findHeaderColumn(sheet, "파일단면적", 20, 55, formatter, evaluator);
		layout.bigo = findHeaderColumn(sheet, "비고", 20, 55, formatter, evaluator);
		layout.memo = findHeaderColumn(sheet, "메모", 20, 56, formatter, evaluator);

		int pieceOffset = layout.totalConnectWidth >= 0 ? layout.totalConnectWidth - 13 : 0;
		layout.totalConnectWidth = fallback(layout.totalConnectWidth, 13);
		layout.connectLength = fallback(layout.connectLength, 14 + pieceOffset);
		layout.drillingDepth = fallback(layout.drillingDepth, 15 + pieceOffset);
		layout.intrusionDepth = fallback(layout.intrusionDepth, 16 + pieceOffset);
		layout.balance = fallback(layout.balance, 17 + pieceOffset);
		layout.gongSac = fallback(layout.gongSac, 18 + pieceOffset);
		layout.hammaT = fallback(layout.hammaT, 19 + pieceOffset);
		layout.fallMeter = fallback(layout.fallMeter, 20 + pieceOffset);
		layout.managedStandard = fallback(layout.managedStandard, 21 + pieceOffset);
		layout.avgPenetrationValue = fallback(layout.avgPenetrationValue, (tenMeasurement ? 32 : 27) + pieceOffset);
		layout.totalPenetrationValue = fallback(layout.totalPenetrationValue, layout.avgPenetrationValue + 1);
		layout.bigo = fallback(layout.bigo, layout.totalPenetrationValue + 1);
		layout.memo = fallback(layout.memo, layout.bigo + 1);

		Row bottomHeader = sheet.getRow(3);
		for (int index = 8; index < layout.totalConnectWidth; index++) {
			String label = bottomHeader == null ? ""
					: cellValue(bottomHeader, index, formatter, evaluator);
			String pieceName = pieceName(label);
			if (!pieceName.isEmpty()) {
				PieceColumn column = new PieceColumn();
				column.columnIndex = index;
				column.originalIndex = layout.pieceColumns.size() + 1;
				column.label = pieceName;
				layout.pieceColumns.add(column);
			}
		}

		for (int index = layout.managedStandard + 1;
				index < layout.avgPenetrationValue; index++) {
			String label = bottomHeader == null ? ""
					: cellValue(bottomHeader, index, formatter, evaluator);
			String penetrationName = penetrationName(label);
			if (!penetrationName.isEmpty()) {
				PenetrationColumn column = new PenetrationColumn();
				column.columnIndex = index;
				column.originalIndex = layout.penetrationColumns.size() + 1;
				column.label = penetrationName;
				layout.penetrationColumns.add(column);
			}
		}

		if (layout.pieceColumns.isEmpty()
				|| layout.penetrationColumns.isEmpty()) {
			throw new IllegalArgumentException(
					"파일 구분 또는 관입량 열을 찾을 수 없습니다. 시스템에서 출력한 엑셀 양식인지 확인해 주세요.");
		}
		return layout;
	}

	private UploadedReportRow readRow(Row row, ColumnLayout layout, DataFormatter formatter,
			FormulaEvaluator evaluator) {
		UploadedReportRow uploaded = new UploadedReportRow();
		uploaded.rowNumber = row.getRowNum() + 1;
		uploaded.constructionDate = normalizeDate(cellValue(row, 1, formatter, evaluator));
		uploaded.machineNumber = cellValue(row, 2, formatter, evaluator);
		uploaded.pileType = cellValue(row, 3, formatter, evaluator);
		uploaded.method = cellValue(row, 4, formatter, evaluator);
		uploaded.location = cellValue(row, 5, formatter, evaluator);
		uploaded.pileNo = cellValue(row, 6, formatter, evaluator);
		uploaded.pileStandard = cellValue(row, 7, formatter, evaluator);
		uploaded.totalConnectWidth = cellValue(row, layout.totalConnectWidth, formatter, evaluator);
		uploaded.connectLength = cellValue(row, layout.connectLength, formatter, evaluator);
		uploaded.drillingDepth = cellValue(row, layout.drillingDepth, formatter, evaluator);
		uploaded.directDrillingDepthPresent = layout.directDrillingDepth >= 0;
		uploaded.soilDrillingDepthPresent = layout.soilDrillingDepth >= 0;
		uploaded.stoneDrillingDepthPresent = layout.stoneDrillingDepth >= 0;
		uploaded.directDrillingDepth = uploaded.directDrillingDepthPresent
				? cellValue(row, layout.directDrillingDepth, formatter, evaluator) : "";
		uploaded.soilDrillingDepth = uploaded.soilDrillingDepthPresent
				? cellValue(row, layout.soilDrillingDepth, formatter, evaluator) : "";
		uploaded.stoneDrillingDepth = uploaded.stoneDrillingDepthPresent
				? cellValue(row, layout.stoneDrillingDepth, formatter, evaluator) : "";
		uploaded.intrusionDepth = cellValue(row, layout.intrusionDepth, formatter, evaluator);
		uploaded.balance = cellValue(row, layout.balance, formatter, evaluator);
		uploaded.gongSac = cellValue(row, layout.gongSac, formatter, evaluator);
		uploaded.hammaT = cellValue(row, layout.hammaT, formatter, evaluator);
		uploaded.fallMeter = cellValue(row, layout.fallMeter, formatter, evaluator);
		uploaded.managedStandard = cellValue(row, layout.managedStandard, formatter, evaluator);
		uploaded.avgPenetrationValue = cellValue(row, layout.avgPenetrationValue, formatter, evaluator);
		uploaded.totalPenetrationValue = cellValue(row, layout.totalPenetrationValue, formatter, evaluator);
		uploaded.ultimateBearingCapacityPresent = layout.ultimateBearingCapacity >= 0;
		uploaded.hammaEfficiencyPresent = layout.hammaEfficiency >= 0;
		uploaded.modulusElasticityPresent = layout.modulusElasticity >= 0;
		uploaded.crossSectionPresent = layout.crossSection >= 0;
		uploaded.ultimateBearingCapacity = uploaded.ultimateBearingCapacityPresent
				? cellValue(row, layout.ultimateBearingCapacity, formatter, evaluator) : "";
		uploaded.hammaEfficiency = uploaded.hammaEfficiencyPresent
				? cellValue(row, layout.hammaEfficiency, formatter, evaluator) : "";
		uploaded.modulusElasticity = uploaded.modulusElasticityPresent
				? cellValue(row, layout.modulusElasticity, formatter, evaluator) : "";
		uploaded.crossSection = uploaded.crossSectionPresent
				? cellValue(row, layout.crossSection, formatter, evaluator) : "";
		uploaded.bigo = cellValue(row, layout.bigo, formatter, evaluator);
		uploaded.memo = cellValue(row, layout.memo, formatter, evaluator);

		for (PieceColumn column : layout.pieceColumns) {
			UploadedPieceValue piece = new UploadedPieceValue();
			piece.originalIndex = column.originalIndex;
			piece.label = column.label;
			piece.value = cellValue(row, column.columnIndex, formatter, evaluator);
			uploaded.pieceValues.add(piece);
		}
		for (PenetrationColumn column : layout.penetrationColumns) {
			UploadedPenetrationValue penetration =
					new UploadedPenetrationValue();
			penetration.originalIndex = column.originalIndex;
			penetration.label = column.label;
			penetration.value =
					cellValue(row, column.columnIndex, formatter, evaluator);
			uploaded.penetrationValues.add(penetration);
		}
		return uploaded;
	}

	private String pieceName(String header) {
		String normalized = normalizeHeader(header);
		if (normalized.contains("단본")) {
			return "단본";
		}
		if (normalized.contains("하단")) {
			return "하단";
		}
		if (normalized.contains("중단")) {
			return "중단";
		}
		if (normalized.contains("상단")) {
			return "상단";
		}
		return "";
	}

	private String penetrationName(String header) {
		String normalized = normalizeHeader(header);
		return normalized.matches("[0-9]+회") ? normalized : "";
	}

	private int findHeaderColumn(Sheet sheet, String label, int startIndex, int endIndex, DataFormatter formatter,
			FormulaEvaluator evaluator) {
		String normalizedLabel = normalizeHeader(label);
		Row topHeader = sheet.getRow(2);
		Row bottomHeader = sheet.getRow(3);
		for (int index = startIndex; index <= endIndex; index++) {
			String topValue = topHeader == null ? "" : cellValue(topHeader, index, formatter, evaluator);
			String bottomValue = bottomHeader == null ? "" : cellValue(bottomHeader, index, formatter, evaluator);
			String header = normalizeHeader(topValue + bottomValue);
			if (header.contains(normalizedLabel)) {
				return index;
			}
		}
		return -1;
	}

	private String normalizeHeader(String value) {
		return value == null ? "" : value.replaceAll("[\\s\\(\\)\\[\\]\\\\/]", "");
	}

	private int fallback(int value, int fallbackValue) {
		return value >= 0 ? value : fallbackValue;
	}

	private String cellValue(Row row, int index, DataFormatter formatter, FormulaEvaluator evaluator) {
		Cell cell = row.getCell(index);
		if (cell == null) {
			return "";
		}
		return formatter.formatCellValue(cell, evaluator).trim();
	}

	private List<ReportOneLine> getOriginalRows(int deviceId, int constructionIdx, ReportParam comparisonParam) {
		ReportParam param = comparisonParam == null ? new ReportParam() : comparisonParam;
		param.setId(deviceId);
		param.setConstructionIdx(constructionIdx);

		ExtensivePileUsage usage = extensivePileUsageMapper.findByConstructionIdx(constructionIdx);
		boolean extensive = usage != null && usage.getIsUsed() > 0;
		boolean tenMeasurement = reportMapper.isBigAllReports(param, constructionIdx) > 0;

		if (tenMeasurement) {
			return extensive ? reportMapper.getListByParamExtensivePileUsageExcelTen(param)
					: reportMapper.getListByParamExcelTen(param);
		}
		return extensive ? reportMapper.getListByParamExtensivePileUsageExcelFive(param)
				: reportMapper.getListByParamExcelFive(param);
	}

	private void buildAnalysis(ReportExcelUploadAnalysis result, List<UploadedReportRow> uploadedRows,
			List<ReportOneLine> originalRows, Device device) {
		Map<String, List<UploadedReportRow>> uploadedByKey = new LinkedHashMap<String, List<UploadedReportRow>>();
		Map<String, List<ReportOneLine>> originalByKey = new LinkedHashMap<String, List<ReportOneLine>>();
		int modifiedCount = 0;

		for (UploadedReportRow row : uploadedRows) {
			if (normalizeDate(row.constructionDate).isEmpty()
					|| normalizeIdentifier(row.machineNumber).isEmpty()
					|| normalizeIdentifier(row.location).isEmpty()
					|| normalizeIdentifier(row.pileNo).isEmpty()) {
				throw new IllegalArgumentException(
						row.rowNumber + "행의 시공일, 시공장비, 시공위치 또는 파일번호가 비어 있습니다.");
			}
			if (!normalize(row.machineNumber).equals(normalize(device.getMachineNumber()))) {
				throw new IllegalArgumentException("업로드 파일에 현재 호기와 다른 시공장비가 포함되어 있습니다.");
			}
			addUploaded(uploadedByKey, row.key(), row);
		}
		for (ReportOneLine row : originalRows) {
			addOriginal(originalByKey, originalKey(row), row);
		}

		for (Map.Entry<String, List<UploadedReportRow>> entry : uploadedByKey.entrySet()) {
			List<UploadedReportRow> uploadedGroup = entry.getValue();
			List<ReportOneLine> originals = originalByKey.get(entry.getKey());
			if (originals == null) {
				originals = new ArrayList<ReportOneLine>();
			}

			if (uploadedGroup.size() > 1 || originals.size() > 1) {
				addDuplicateResult(result, entry.getKey(), uploadedGroup, originals);
				continue;
			}

			UploadedReportRow uploaded = uploadedGroup.get(0);
			if (originals.isEmpty()) {
				result.setAddedCount(result.getAddedCount() + 1);
				addRecordChange(result, uploaded.target(), "기록 추가", "-", "추가");
			} else {
				if (addChanges(result, uploaded, originals.get(0))) {
					modifiedCount++;
				}
			}
		}

		for (Map.Entry<String, List<ReportOneLine>> entry : originalByKey.entrySet()) {
			if (uploadedByKey.containsKey(entry.getKey())) {
				continue;
			}
			for (ReportOneLine original : entry.getValue()) {
				result.setDeletedCount(result.getDeletedCount() + 1);
				addRecordChange(result, originalTarget(original), "기록 삭제", "원본 기록", "-");
			}
		}

		result.setTotalCount(uploadedRows.size());
		result.setDuplicateCount(result.getDuplicateGroups().size());
		result.setModifiedCount(modifiedCount);
	}

	private void addDuplicateResult(ReportExcelUploadAnalysis result, String key, List<UploadedReportRow> uploadedRows,
			List<ReportOneLine> originalRows) {
		UploadedReportRow sample = uploadedRows.get(0);
		DuplicateGroup group = new DuplicateGroup();
		group.setKey(key);
		group.setConstructionDate(sample.constructionDate);
		group.setMachineNumber(sample.machineNumber);
		group.setLocation(sample.location);
		group.setPileNo(sample.pileNo);
		group.setOriginalCount(originalRows.size());
		result.getDuplicateGroups().add(group);

		for (UploadedReportRow uploaded : uploadedRows) {
			DuplicateDetail detail = new DuplicateDetail();
			detail.setKey(key);
			detail.setType("사용자 업로드");
			detail.setConstructionDate(uploaded.constructionDate);
			detail.setMachineNumber(uploaded.machineNumber);
			detail.setLocation(uploaded.location);
			detail.setPileNo(uploaded.pileNo);
			detail.setJudgment("확인대상");
			result.getDuplicateDetails().add(detail);
		}
		for (ReportOneLine original : originalRows) {
			DuplicateDetail detail = new DuplicateDetail();
			detail.setKey(key);
			detail.setType("원본 파일");
			detail.setConstructionDate(originalDate(original));
			detail.setMachineNumber(original.getMachineNumber());
			detail.setLocation(original.getLocation());
			detail.setPileNo(original.getPileNo());
			detail.setJudgment("중복");
			result.getDuplicateDetails().add(detail);
		}
	}

	private boolean addChanges(ReportExcelUploadAnalysis result, UploadedReportRow uploaded, ReportOneLine original) {
		int changeCountBefore = result.getChanges().size();
		String target = uploaded.target();
		compare(result, target, "파일종류", original.getPileType(), uploaded.pileType);
		compare(result, target, "시공공법", original.getMethod(), uploaded.method);
		compare(result, target, "파일규격", original.getPileStandard(), uploaded.pileStandard);
		for (UploadedPieceValue pieceValue : uploaded.pieceValues) {
			compare(result, target, pieceValue.label, originalPieceValue(original, pieceValue.originalIndex),
					pieceValue.value);
		}
		if (uploaded.pieceValues.isEmpty()) {
			compare(result, target, "파일 합계", original.getTotalConnectWidth(), uploaded.totalConnectWidth);
		}
		compare(result, target, "이음개소", original.getConnectLength(), uploaded.connectLength);
		compare(result, target, "천공깊이", original.getDrillingDepth(), uploaded.drillingDepth);
		if (uploaded.directDrillingDepthPresent) {
			compare(result, target, "직타깊이",
					original.getDirectDrillingDepth(),
					uploaded.directDrillingDepth);
		}
		if (uploaded.soilDrillingDepthPresent) {
			compare(result, target, "토사천공",
					original.getSdDrillingDepth(),
					uploaded.soilDrillingDepth);
		}
		if (uploaded.stoneDrillingDepthPresent) {
			compare(result, target, "전석층천공",
					original.getStDrillingDepth(),
					uploaded.stoneDrillingDepth);
		}
		compare(result, target, "관입깊이", original.getIntrusionDepth(), uploaded.intrusionDepth);
		compare(result, target, "파일잔량", String.valueOf(original.getBalance()), uploaded.balance);
		compare(result, target, "공삭공", String.valueOf(original.getGongSac()), uploaded.gongSac);
		compare(result, target, "해머무게", original.getHammaT(), uploaded.hammaT);
		compare(result, target, "낙하높이", original.getFallMeter(), uploaded.fallMeter);
		compare(result, target, "관리기준", original.getManagedStandard(), uploaded.managedStandard);
		for (UploadedPenetrationValue penetrationValue : uploaded.penetrationValues) {
			compare(result, target, penetrationValue.label,
					originalPenetrationValue(original, penetrationValue.originalIndex),
					penetrationValue.value);
		}
		compare(result, target, "평균관입", original.getAvgPenetrationValue(), uploaded.avgPenetrationValue);
		compare(result, target, "총관입량", original.getTotalPenetrationValue(), uploaded.totalPenetrationValue);
		if (uploaded.ultimateBearingCapacityPresent) {
			compare(result, target, "극한지지력", original.getUltimateBearingCapacity(),
					uploaded.ultimateBearingCapacity);
		}
		if (uploaded.hammaEfficiencyPresent) {
			compare(result, target, "해머효율", original.getHammaEfficiency(),
					uploaded.hammaEfficiency);
		}
		if (uploaded.modulusElasticityPresent) {
			compare(result, target, "탄성계수", original.getModulusElasticity(),
					uploaded.modulusElasticity);
		}
		if (uploaded.crossSectionPresent) {
			compare(result, target, "파일단면적", original.getCrossSection(),
					uploaded.crossSection);
		}
		compare(result, target, "비고", original.getBigo(), uploaded.bigo);
		compare(result, target, "메모", original.getSprCol1(), uploaded.memo);
		return result.getChanges().size() > changeCountBefore;
	}

	private String originalPieceValue(ReportOneLine original, int pieceIndex) {
		switch (pieceIndex) {
		case 1:
			return original.getPiOne();
		case 2:
			return original.getPiTwo();
		case 3:
			return original.getPiThree();
		case 4:
			return original.getPiFour();
		case 5:
			return original.getPiFive();
		case 6:
			return original.getPiSix();
		case 7:
			return original.getPiSeven();
		default:
			return "";
		}
	}

	private String originalPenetrationValue(ReportOneLine original,
			int penetrationIndex) {
		switch (penetrationIndex) {
		case 1:
			return original.getPeOne();
		case 2:
			return original.getPeTwo();
		case 3:
			return original.getPeThree();
		case 4:
			return original.getPeFour();
		case 5:
			return original.getPeFive();
		case 6:
			return original.getPeSix();
		case 7:
			return original.getPeSeven();
		case 8:
			return original.getPeEight();
		case 9:
			return original.getPeNine();
		case 10:
			return original.getPeTen();
		default:
			return "";
		}
	}

	private void applyChanges(AnalysisContext context, int deviceId) {
		Map<String, List<UploadedReportRow>> uploadedByKey =
				new LinkedHashMap<String, List<UploadedReportRow>>();
		Map<String, List<ReportOneLine>> originalByKey =
				new LinkedHashMap<String, List<ReportOneLine>>();

		for (UploadedReportRow uploaded : context.uploadedRows) {
			addUploaded(uploadedByKey, uploaded.key(), uploaded);
		}
		for (ReportOneLine original : context.originalRows) {
			addOriginal(originalByKey, originalKey(original), original);
		}

		for (Map.Entry<String, List<UploadedReportRow>> entry
				: uploadedByKey.entrySet()) {
			List<UploadedReportRow> uploadedGroup = entry.getValue();
			List<ReportOneLine> originalGroup = originalByKey.get(entry.getKey());
			int originalCount = originalGroup == null ? 0 : originalGroup.size();
			if (uploadedGroup.size() != 1 || originalCount > 1) {
				throw new IllegalStateException(
						"반영 직전에 중복 데이터가 확인되었습니다. 중복 검사를 다시 진행해 주세요.");
			}

			UploadedReportRow uploaded = uploadedGroup.get(0);
			if (originalCount == 0) {
				insertUploadedReport(uploaded, deviceId);
				continue;
			}

			ReportOneLine original = originalGroup.get(0);
			if (isChanged(uploaded, original)) {
				updateUploadedReport(uploaded, original, deviceId);
			}
		}

		for (Map.Entry<String, List<ReportOneLine>> entry
				: originalByKey.entrySet()) {
			if (uploadedByKey.containsKey(entry.getKey())) {
				continue;
			}
			for (ReportOneLine original : entry.getValue()) {
				if (reportMapper.doDelete(original.getId()) != 1) {
					throw new IllegalStateException(
							"기록지 삭제 처리에 실패했습니다. 반영 작업이 취소되었습니다.");
				}
			}
		}
	}

	private boolean isChanged(UploadedReportRow uploaded,
			ReportOneLine original) {
		ReportExcelUploadAnalysis changes = new ReportExcelUploadAnalysis();
		return addChanges(changes, uploaded, original);
	}

	private void insertUploadedReport(UploadedReportRow uploaded,
			int deviceId) {
		ReportExcelUploadRecord record =
				toUploadRecord(uploaded, null, deviceId);
		if (reportMapper.insertExcelUploadReport(record) != 1
				|| record.getId() <= 0) {
			throw new IllegalStateException(
					"새 기록지 저장에 실패했습니다. 반영 작업이 취소되었습니다.");
		}
		replaceReportDetails(record.getId(), uploaded);
	}

	private void updateUploadedReport(UploadedReportRow uploaded,
			ReportOneLine original, int deviceId) {
		ReportExcelUploadRecord record =
				toUploadRecord(uploaded, original, deviceId);
		record.setId(original.getId());
		if (reportMapper.updateExcelUploadReport(record) != 1) {
			throw new IllegalStateException(
					"기록지 수정에 실패했습니다. 반영 작업이 취소되었습니다.");
		}
		replaceReportDetails(original.getId(), uploaded);
	}

	private ReportExcelUploadRecord toUploadRecord(
			UploadedReportRow uploaded, ReportOneLine original,
			int deviceId) {
		ReportExcelUploadRecord record = new ReportExcelUploadRecord();
		record.setDeviceId(deviceId);
		record.setConstructionDate(uploaded.constructionDate);
		record.setPileType(uploaded.pileType);
		record.setMethod(uploaded.method);
		record.setLocation(uploaded.location);
		record.setPileNo(uploaded.pileNo);
		record.setPileStandard(uploaded.pileStandard);
		record.setDrillingDepth(uploaded.drillingDepth);
		record.setDirectDrillingDepth(optionalValue(
				uploaded.directDrillingDepthPresent,
				uploaded.directDrillingDepth,
				original == null ? "" : original.getDirectDrillingDepth()));
		record.setSoilDrillingDepth(optionalValue(
				uploaded.soilDrillingDepthPresent,
				uploaded.soilDrillingDepth,
				original == null ? "" : original.getSdDrillingDepth()));
		record.setStoneDrillingDepth(optionalValue(
				uploaded.stoneDrillingDepthPresent,
				uploaded.stoneDrillingDepth,
				original == null ? "" : original.getStDrillingDepth()));
		record.setIntrusionDepth(uploaded.intrusionDepth);
		record.setBalance(decimalValue(uploaded.balance, uploaded.rowNumber,
				"파일잔량"));
		record.setConnectLength(uploaded.connectLength);
		record.setManagedStandard(uploaded.managedStandard);
		record.setAvgPenetrationValue(uploaded.avgPenetrationValue);
		record.setTotalPenetrationValue(uploaded.totalPenetrationValue);
		record.setHammaT(uploaded.hammaT);
		record.setFallMeter(uploaded.fallMeter);
		record.setTotalConnectWidth(uploaded.totalConnectWidth);
		record.setGongSac(decimalValue(uploaded.gongSac,
				uploaded.rowNumber, "공삭공"));
		record.setUltimateBearingCapacity(optionalValue(
				uploaded.ultimateBearingCapacityPresent,
				uploaded.ultimateBearingCapacity,
				original == null ? "" : original.getUltimateBearingCapacity()));
		record.setHammaEfficiency(optionalValue(
				uploaded.hammaEfficiencyPresent, uploaded.hammaEfficiency,
				original == null ? "" : original.getHammaEfficiency()));
		record.setModulusElasticity(optionalValue(
				uploaded.modulusElasticityPresent, uploaded.modulusElasticity,
				original == null ? "" : original.getModulusElasticity()));
		record.setCrossSection(optionalValue(uploaded.crossSectionPresent,
				uploaded.crossSection,
				original == null ? "" : original.getCrossSection()));
		record.setBigo(uploaded.bigo);
		record.setMemo(uploaded.memo);
		return record;
	}

	private String optionalValue(boolean present, String uploadedValue,
			String originalValue) {
		return present ? uploadedValue : originalValue;
	}

	private BigDecimal decimalValue(String value, int rowNumber,
			String fieldName) {
		String normalized = normalize(value).replace(",", "");
		if (normalized.isEmpty()) {
			return BigDecimal.ZERO;
		}
		try {
			return new BigDecimal(normalized);
		} catch (NumberFormatException e) {
			throw new IllegalArgumentException(
					rowNumber + "행의 " + fieldName
					+ " 값이 숫자가 아닙니다: " + value);
		}
	}

	private void replaceReportDetails(int reportId,
			UploadedReportRow uploaded) {
		pieceMapper.deleteByReportIdx(reportId);
		for (UploadedPieceValue value : uploaded.pieceValues) {
			if (normalize(value.value).isEmpty()) {
				continue;
			}
			Piece piece = new Piece();
			piece.setReportIdx(reportId);
			piece.setName(value.label);
			piece.setValue(value.value);
			if (pieceMapper.insert(piece) != 1) {
				throw new IllegalStateException(
						"파일 구성 저장에 실패했습니다. 반영 작업이 취소되었습니다.");
			}
		}

		penetrationMapper.deleteByReportIdx(reportId);
		for (UploadedPenetrationValue value : uploaded.penetrationValues) {
			if (normalize(value.value).isEmpty()) {
				continue;
			}
			Penetration penetration = new Penetration();
			penetration.setReportIdx(reportId);
			penetration.setName(value.label);
			penetration.setValue(value.value);
			if (penetrationMapper.insert(penetration) != 1) {
				throw new IllegalStateException(
						"관입량 저장에 실패했습니다. 반영 작업이 취소되었습니다.");
			}
		}
	}

	private String createAnalysisToken(AnalysisContext context)
			throws Exception {
		List<String> sourceRows = new ArrayList<String>();
		for (UploadedReportRow row : context.uploadedRows) {
			StringBuilder value = new StringBuilder("U|");
			appendToken(value, row.constructionDate, row.machineNumber,
					row.pileType, row.method, row.location, row.pileNo,
					row.pileStandard, row.totalConnectWidth,
					row.connectLength, row.drillingDepth,
					row.directDrillingDepth, row.soilDrillingDepth,
					row.stoneDrillingDepth,
					row.intrusionDepth, row.balance, row.gongSac,
					row.hammaT, row.fallMeter, row.managedStandard,
					row.avgPenetrationValue, row.totalPenetrationValue,
					row.ultimateBearingCapacity, row.hammaEfficiency,
					row.modulusElasticity, row.crossSection, row.bigo,
					row.memo);
			for (UploadedPieceValue piece : row.pieceValues) {
				appendToken(value, piece.label, piece.value);
			}
			for (UploadedPenetrationValue penetration
					: row.penetrationValues) {
				appendToken(value, penetration.label, penetration.value);
			}
			sourceRows.add(value.toString());
		}
		for (ReportOneLine row : context.originalRows) {
			StringBuilder value = new StringBuilder("O|");
			appendToken(value, String.valueOf(row.getId()),
					originalDate(row), row.getMachineNumber(),
					row.getPileType(), row.getMethod(), row.getLocation(),
					row.getPileNo(), row.getPileStandard(),
					row.getTotalConnectWidth(), row.getConnectLength(),
					row.getDrillingDepth(), row.getDirectDrillingDepth(),
					row.getSdDrillingDepth(), row.getStDrillingDepth(),
					row.getIntrusionDepth(),
					String.valueOf(row.getBalance()),
					String.valueOf(row.getGongSac()), row.getHammaT(),
					row.getFallMeter(), row.getManagedStandard(),
					row.getAvgPenetrationValue(),
					row.getTotalPenetrationValue(),
					row.getUltimateBearingCapacity(),
					row.getHammaEfficiency(), row.getModulusElasticity(),
					row.getCrossSection(), row.getBigo(), row.getSprCol1());
			for (int index = 1; index <= 7; index++) {
				appendToken(value, originalPieceValue(row, index));
			}
			for (int index = 1; index <= 10; index++) {
				appendToken(value,
						originalPenetrationValue(row, index));
			}
			sourceRows.add(value.toString());
		}
		Collections.sort(sourceRows);

		MessageDigest digest = MessageDigest.getInstance("SHA-256");
		for (String sourceRow : sourceRows) {
			digest.update(sourceRow.getBytes(StandardCharsets.UTF_8));
		}
		byte[] hash = digest.digest();
		StringBuilder token = new StringBuilder(hash.length * 2);
		for (byte item : hash) {
			token.append(String.format("%02x", item & 0xff));
		}
		return token.toString();
	}

	private void appendToken(StringBuilder builder, String... values) {
		for (String value : values) {
			String normalized = value == null ? "" : value.trim();
			builder.append(normalized.length()).append(':')
					.append(normalized).append('|');
		}
	}

	private void addRecordChange(ReportExcelUploadAnalysis result, String target, String field, String beforeValue,
			String afterValue) {
		ChangeDetail change = new ChangeDetail();
		change.setTarget(target);
		change.setField(field);
		change.setBeforeValue(beforeValue);
		change.setAfterValue(afterValue);
		result.getChanges().add(change);
	}

	private void compare(ReportExcelUploadAnalysis result, String target, String field, String beforeValue,
			String afterValue) {
		if (sameValue(beforeValue, afterValue)) {
			return;
		}
		ChangeDetail change = new ChangeDetail();
		change.setTarget(target);
		change.setField(field);
		change.setBeforeValue(displayValue(beforeValue));
		change.setAfterValue(displayValue(afterValue));
		result.getChanges().add(change);
	}

	private boolean sameValue(String left, String right) {
		String normalizedLeft = normalize(left);
		String normalizedRight = normalize(right);
		if (normalizedLeft.equals(normalizedRight)) {
			return true;
		}
		try {
			return new BigDecimal(normalizedLeft).compareTo(new BigDecimal(normalizedRight)) == 0;
		} catch (Exception ignored) {
			return false;
		}
	}

	private String displayValue(String value) {
		return normalize(value).isEmpty() ? "-" : value.trim();
	}

	private String originalKey(ReportOneLine row) {
		return key(originalDate(row), row.getMachineNumber(), row.getLocation(), row.getPileNo());
	}

	private String originalDate(ReportOneLine row) {
		String createDate = normalizeDate(row.getCreateDate());
		return createDate.isEmpty() ? normalizeDate(row.getCurrentDateTime()) : createDate;
	}

	private String key(String constructionDate, String machineNumber, String location, String pileNo) {
		return normalizeDate(constructionDate) + "|" + normalizeIdentifier(machineNumber) + "|"
				+ normalizeIdentifier(location) + "|" + normalizeIdentifier(pileNo);
	}

	private String normalizeIdentifier(String value) {
		String normalized = normalize(value).replace('\u00a0', ' ').replaceAll("\\s+", "");
		if (normalized.isEmpty()) {
			return "";
		}
		try {
			return new BigDecimal(normalized).stripTrailingZeros().toPlainString();
		} catch (NumberFormatException ignored) {
			return normalized;
		}
	}

	private String originalTarget(ReportOneLine original) {
		return originalDate(original) + " | " + displayValue(original.getMachineNumber()) + " | "
				+ displayValue(original.getLocation()) + " | " + displayValue(original.getPileNo());
	}

	private String normalize(String value) {
		return value == null ? "" : value.trim().toLowerCase(Locale.KOREAN);
	}

	private String normalizeDate(String value) {
		String normalized = value == null ? "" : value.trim();
		normalized = normalized.replace('.', '-').replace('/', '-');
		while (normalized.endsWith("-")) {
			normalized = normalized.substring(0, normalized.length() - 1);
		}
		if (normalized.length() >= 10 && normalized.charAt(4) == '-' && normalized.charAt(7) == '-') {
			return normalized.substring(0, 10);
		}
		return normalized;
	}

	private void addUploaded(Map<String, List<UploadedReportRow>> map, String key, UploadedReportRow row) {
		List<UploadedReportRow> rows = map.get(key);
		if (rows == null) {
			rows = new ArrayList<UploadedReportRow>();
			map.put(key, rows);
		}
		rows.add(row);
	}

	private void addOriginal(Map<String, List<ReportOneLine>> map, String key, ReportOneLine row) {
		List<ReportOneLine> rows = map.get(key);
		if (rows == null) {
			rows = new ArrayList<ReportOneLine>();
			map.put(key, rows);
		}
		rows.add(row);
	}

	private class UploadedReportRow {
		private int rowNumber;
		private String constructionDate;
		private String machineNumber;
		private String pileType;
		private String method;
		private String location;
		private String pileNo;
		private String pileStandard;
		private List<UploadedPieceValue> pieceValues = new ArrayList<UploadedPieceValue>();
		private String totalConnectWidth;
		private String connectLength;
		private String drillingDepth;
		private boolean directDrillingDepthPresent;
		private String directDrillingDepth;
		private boolean soilDrillingDepthPresent;
		private String soilDrillingDepth;
		private boolean stoneDrillingDepthPresent;
		private String stoneDrillingDepth;
		private String intrusionDepth;
		private String balance;
		private String gongSac;
		private String hammaT;
		private String fallMeter;
		private String managedStandard;
		private List<UploadedPenetrationValue> penetrationValues =
				new ArrayList<UploadedPenetrationValue>();
		private String avgPenetrationValue;
		private String totalPenetrationValue;
		private boolean ultimateBearingCapacityPresent;
		private String ultimateBearingCapacity;
		private boolean hammaEfficiencyPresent;
		private String hammaEfficiency;
		private boolean modulusElasticityPresent;
		private String modulusElasticity;
		private boolean crossSectionPresent;
		private String crossSection;
		private String bigo;
		private String memo;

		private boolean isEmpty() {
			return normalize(machineNumber).isEmpty() && normalize(location).isEmpty() && normalize(pileNo).isEmpty();
		}

		private String key() {
			return ReportExcelUploadService.this.key(constructionDate, machineNumber, location, pileNo);
		}

		private String target() {
			return constructionDate + " | " + machineNumber + " | " + location + " | " + pileNo;
		}
	}

	private static class UploadedPieceValue {
		UploadedPieceValue() {
		}

		private int originalIndex;
		private String label;
		private String value;
	}

	private static class UploadedPenetrationValue {
		private int originalIndex;
		private String label;
		private String value;
	}

	private static class PieceColumn {
		PieceColumn() {
		}

		private int columnIndex;
		private int originalIndex;
		private String label;
	}

	private static class PenetrationColumn {
		private int columnIndex;
		private int originalIndex;
		private String label;
	}

	private static class AnalysisContext {
		private ReportExcelUploadAnalysis result;
		private List<UploadedReportRow> uploadedRows;
		private List<ReportOneLine> originalRows;
	}

	private static class ColumnLayout {
		ColumnLayout() {
		}

		private List<PieceColumn> pieceColumns = new ArrayList<PieceColumn>();
		private List<PenetrationColumn> penetrationColumns =
				new ArrayList<PenetrationColumn>();
		private int totalConnectWidth;
		private int connectLength;
		private int drillingDepth;
		private int directDrillingDepth = -1;
		private int soilDrillingDepth = -1;
		private int stoneDrillingDepth = -1;
		private int intrusionDepth;
		private int balance;
		private int gongSac;
		private int hammaT;
		private int fallMeter;
		private int managedStandard;
		private int avgPenetrationValue;
		private int totalPenetrationValue;
		private int ultimateBearingCapacity = -1;
		private int hammaEfficiency = -1;
		private int modulusElasticity = -1;
		private int crossSection = -1;
		private int bigo;
		private int memo;
	}
}

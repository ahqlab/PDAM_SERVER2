<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/tagLib.jsp"%>
<style>
.backup-history-content {
	padding-bottom: 70px;
}
.backup-history-dashboard {
	box-sizing: border-box;
	margin-bottom: 55px;
	padding: 30px;
	border-radius: 7px;
	background: #0d819e;
	color: #fff;
}
.backup-history-dashboard__top {
	display: flex;
	align-items: center;
	margin-bottom: 35px;
}
.backup-history-dashboard__title {
	font-size: 28px;
	font-weight: 700;
}
.backup-history-search {
	display: grid;
	grid-template-columns: 1fr 2.5fr 50px;
	gap: 15px;
	align-items: end;
}
.backup-history-filter {
	min-width: 0;
}
.backup-history-filter label {
	display: block;
	margin-bottom: 7px;
	color: #fff;
	font-size: 13px;
	font-weight: 600;
}
.backup-history-filter select {
	box-sizing: border-box;
	width: 100%;
	height: 50px;
	padding: 0 20px;
	border: 0;
	border-radius: 7px;
	background: #fff;
	color: #333;
	font-size: 16px;
	cursor: pointer;
}
.backup-history-search__button {
	display: flex;
	align-items: center;
	justify-content: center;
	height: 50px;
	padding: 0;
	border: 0;
	border-radius: 7px;
	background: #fff;
	cursor: pointer;
}
.backup-history-search__button img {
	width: 35px;
	height: 22px;
}
.backup-history-count {
	margin-bottom: 10px;
	text-align: right;
	font-size: 14px;
}
.backup-history-success {
	margin: 0 0 22px;
	padding: 17px 20px;
	border: 1px solid #0d819e;
	border-radius: 7px;
	background: #e8f7fb;
	color: #175367;
	font-size: 16px;
}
.backup-history-success strong {
	color: #0b718b;
}
.backup-download-helptxt {
	margin: 0 0 12px;
	color: #666;
	font-size: 14px;
	line-height: 1.5;
}
.backup-history-table {
	width: 100%;
	border-collapse: collapse;
	border: 1px solid #c8c8c8;
	background: #fff;
	table-layout: fixed;
}
.backup-history-table th {
	height: 58px;
	background: #e8f7fb;
	font-size: 16px;
	font-weight: 700;
}
.backup-history-table td {
	height: 84px;
	border-top: 1px solid #d4d4d4;
	text-align: center;
	font-size: 17px;
}
.backup-history-row--restored td {
	background: #fff9df;
}
.backup-history-table__empty {
	color: #777;
}
.backup-history-management {
	display: flex;
	align-items: center;
	justify-content: center;
	gap: 8px;
}
.backup-history-restore-button,
.backup-history-download-button {
	width: 110px;
	height: 40px;
	border: 0;
	border-radius: 5px;
	color: #fff;
	font-size: 15px;
	font-weight: 600;
	cursor: pointer;
}
.backup-history-restore-button {
	background: #0d819e;
}
.backup-history-download-button {
	background: #245568;
}
.backup-history-confirm {
	display: none;
}
.backup-history-confirm__notice {
	margin: 25px 0 40px;
	font-size: 17px;
	font-weight: 600;
}
.backup-history-version-card {
	box-sizing: border-box;
	min-height: 238px;
	margin-bottom: 48px;
	padding: 38px 45px;
	border: 1px solid #aaa;
	border-radius: 20px;
	background: #f3f3f3;
}
.backup-history-version-card--selected {
	border-color: #0d819e;
	background: #fbfeff;
}
.backup-history-version-card h2 {
	margin-bottom: 20px;
	font-size: 27px;
	font-weight: 700;
}
.backup-history-version-card dl {
	display: grid;
	grid-template-columns: 100px 1fr;
	row-gap: 13px;
	font-size: 20px;
}
.backup-history-version-card dt {
	color: #777;
	font-weight: 600;
	white-space: nowrap;
}
.backup-history-confirm__actions {
	display: flex;
	justify-content: flex-end;
	gap: 15px;
	margin-top: 80px;
}
.backup-history-confirm__apply,
.backup-history-confirm__cancel {
	height: 38px;
	border: 0;
	border-radius: 5px;
	font-weight: 600;
	cursor: pointer;
}
.backup-history-confirm__apply {
	width: 200px;
	background: #0d819e;
	color: #fff;
}
.backup-history-confirm__apply:disabled {
	cursor: wait;
	opacity: 0.65;
}
.backup-history-confirm__cancel {
	width: 100px;
	background: #edf1f3;
	color: #333;
}
@media screen and (max-width: 1023px) {
	.backup-history-dashboard {
		margin-bottom: 25px;
		padding: 20px;
	}
	.backup-history-dashboard__top {
		align-items: flex-start;
		gap: 15px;
		margin-bottom: 20px;
	}
	.backup-history-dashboard__title {
		font-size: 21px;
	}
	.backup-history-search {
		grid-template-columns: 1fr 1fr;
	}
	.backup-history-search__button {
		grid-column: 1 / -1;
	}
	.backup-history-table {
		min-width: 720px;
	}
	.backup-history-table-wrap {
		overflow-x: auto;
	}
	.backup-history-version-card {
		min-height: 190px;
		padding: 28px 25px;
	}
	.backup-history-version-card h2 {
		font-size: 22px;
	}
	.backup-history-version-card dl {
		font-size: 16px;
	}
}
</style>

<div class="section-right backup-history-content">
	<div id="backupHistoryListView">
		<div class="backup-history-dashboard">
			<div class="backup-history-dashboard__top">
				<h1 class="backup-history-dashboard__title">
					<c:choose>
						<c:when test="${not empty selectedDevice}">
							${fn:escapeXml(selectedDevice.machineNumber)} 기록지 백업·반영 이력
						</c:when>
						<c:otherwise>호기별 기록지 백업·반영 이력</c:otherwise>
					</c:choose>
				</h1>
			</div>

			<div class="backup-history-search">
				<div class="backup-history-filter">
					<label for="backupDeviceFilter">호기 선택</label>
					<select id="backupDeviceFilter"
						onchange="changeBackupHistoryDevice(this.value);">
						<option value=""
							<c:if test="${empty selectedDevice}">selected="selected"</c:if>>전체</option>
						<c:forEach var="device" items="${deviceList}">
							<option value="${device.id}"
								<c:if test="${device.id == selectedDevice.id}">selected="selected"</c:if>>
								${fn:escapeXml(device.machineNumber)}
							</option>
						</c:forEach>
					</select>
				</div>

				<div class="backup-history-filter backup-history-filter--work-type">
					<label for="backupWorkTypeFilter">작업 구분</label>
					<select id="backupWorkTypeFilter">
						<option value="" selected="selected">전체</option>
						<option value="초기 기록 보관">초기 기록 보관</option>
						<option value="현재 상태 보관">현재 상태 보관</option>
						<option value="엑셀 수정 반영">엑셀 수정 반영</option>
						<option value="기준 복구">기준 복구</option>
						<option value="수정 전 자동 백업">수정 전 자동 백업</option>
					</select>
				</div>

				<button type="button" class="backup-history-search__button"
					aria-label="백업 이력 검색" onclick="filterBackupHistory();">
					<img src="${pageContext.request.contextPath}/new/img/search.png" alt="">
				</button>
			</div>
		</div>

		<c:if test="${not empty param.restoredVersion}">
			<div class="backup-history-success" role="status" aria-live="polite">
				<strong>&#48152;&#50689; &#50756;&#47308;</strong>
				&#49440;&#53469;&#54620; &#48177;&#50629; &#44592;&#51456;&#51004;&#47196; &#44592;&#47197;&#51648;&#47484; &#48152;&#50689;&#54616;&#44256;
				&#49352; &#48260;&#51204; <strong>${fn:escapeXml(param.restoredVersion)}</strong>&#51012; &#49373;&#49457;&#54664;&#49845;&#45768;&#45796;.
			</div>
		</c:if>

		<div class="backup-download-helptxt">특정 날짜에 해당하는 기록지만 다운로드 하는 것이 아니라, 해당 호기의 전체 기록지를 다운로드 합니다.</div>

		<div class="backup-history-count">
			전체
			<strong id="backupHistoryVisibleCount">${fn:length(backupHistoryList)}</strong>건
		</div>

		<div class="backup-history-table-wrap">
			<table class="backup-history-table">
				<colgroup>
					<col style="width: 14%;">
					<col style="width: 14%;">
					<col style="width: 25%;">
					<col style="width: 29%;">
					<col style="width: 18%;">
				</colgroup>
				<thead>
					<tr>
						<th>호기</th>
						<th>버전</th>
						<th>생성 일시</th>
						<th>작업 구분</th>
						<th>관리</th>
					</tr>
				</thead>
				<tbody id="backupHistoryTableBody">
					<c:choose>
						<c:when test="${not empty backupHistoryList}">
							<c:forEach var="history" items="${backupHistoryList}" varStatus="status">
								<tr class="backup-history-row<c:if test="${history.version == param.restoredVersion}"> backup-history-row--restored</c:if>"
									data-device-id="${history.deviceId}"
									data-version="${fn:escapeXml(history.version)}"
									data-created-at="${fn:escapeXml(history.createdAt)}"
									data-work-type="${fn:escapeXml(history.workType)}">
									<td>
										<c:forEach var="device" items="${deviceList}">
											<c:if test="${device.id == history.deviceId}">
												${fn:escapeXml(device.machineNumber)}
											</c:if>
										</c:forEach>
									</td>
									<td>${fn:escapeXml(history.version)}</td>
									<td>${fn:escapeXml(history.createdAt)}</td>
									<td>${fn:escapeXml(history.workType)}</td>
									<td>
										<div class="backup-history-management">
											<button type="button" class="backup-history-restore-button"
												data-history-id="${history.id}"
												data-device-id="${history.deviceId}"
												data-version="${fn:escapeXml(history.version)}"
												data-created-at="${fn:escapeXml(history.createdAt)}"
												data-work-type="${fn:escapeXml(history.workType)}"
												onclick="openBackupRestoreConfirm(this);">
												복구
											</button>
										<button type="button" class="backup-history-download-button"
											data-history-id="${history.id}"
											data-device-id="${history.deviceId}"
											title="${fn:escapeXml(history.version)} ${fn:escapeXml(history.workType)} 기록지 다운로드"
											onclick="downloadBackupHistory(this);">
											다운로드
											</button>
										</div>
									</td>
								</tr>
							</c:forEach>
						</c:when>
						<c:otherwise>
							<tr>
								<td colspan="5" class="backup-history-table__empty">
									조회된 백업 이력이 없습니다.
								</td>
							</tr>
						</c:otherwise>
					</c:choose>
				</tbody>
			</table>
		</div>
	</div>

	<div id="backupHistoryConfirmView" class="backup-history-confirm">
		<p class="backup-history-confirm__notice">
			선택한 버전을 현재 기록지에 반영합니다. 현재 기록지가 최신 이력과 다를 때만
			별도로 보관하며, 기존 버전은 삭제되지 않습니다.
		</p>

		<div class="backup-history-version-card">
			<h2>현재 기록지</h2>
			<dl>
				<dt>버전</dt>
				<dd id="currentBackupVersion">-</dd>
				<dt>생성일시</dt>
				<dd id="currentBackupCreatedAt">-</dd>
				<dt>작업</dt>
				<dd id="currentBackupWorkType">-</dd>
			</dl>
		</div>

		<div class="backup-history-version-card backup-history-version-card--selected">
			<h2>선택한 복구 기준</h2>
			<dl>
				<dt>버전</dt>
				<dd id="selectedBackupVersion">-</dd>
				<dt>생성일시</dt>
				<dd id="selectedBackupCreatedAt">-</dd>
				<dt>작업</dt>
				<dd id="selectedBackupWorkType">-</dd>
			</dl>
		</div>

		<input type="hidden" id="selectedBackupHistoryId">
		<input type="hidden" id="selectedBackupDeviceId">
		<div class="backup-history-confirm__actions">
			<button type="button" class="backup-history-confirm__apply"
				onclick="requestBackupRestore();">선택 버전으로 복구</button>
			<button type="button" class="backup-history-confirm__cancel"
				onclick="closeBackupRestoreConfirm();">취소</button>
		</div>
	</div>
</div>

<script>
var backupHistoryContextPath = '${pageContext.request.contextPath}';
var backupHistoryConstructionIdx = '${constructionIdx}';
var currentBackupsByDevice = {};
<c:forEach var="history" items="${backupHistoryList}">
	if (!currentBackupsByDevice['${history.deviceId}']) {
		currentBackupsByDevice['${history.deviceId}'] = {
			version: '<c:out value="${history.version}" />',
			createdAt: '<c:out value="${history.createdAt}" />',
			workType: '<c:out value="${history.workType}" />'
		};
	}
</c:forEach>
function changeBackupHistoryDevice(deviceId) {
	var destination = backupHistoryContextPath
		+ '/device/backup-history?constructionIdx='
		+ encodeURIComponent(backupHistoryConstructionIdx);
	if (deviceId) {
		destination += '&deviceId=' + encodeURIComponent(deviceId);
	}
	location.href = destination;
}

function filterBackupHistory() {
	var workType = $.trim($('#backupWorkTypeFilter').val()).toLowerCase();
	var visibleCount = 0;

	$('.backup-history-row').each(function() {
		var row = $(this);
		var rowWorkType = String(row.data('work-type')).toLowerCase();
		var matches = !workType || rowWorkType.indexOf(workType) >= 0;

		row.toggle(matches);
		if (matches) {
			visibleCount++;
		}
	});

	$('#backupHistoryVisibleCount').text(visibleCount);
}

function openBackupRestoreConfirm(button) {
	var selected = $(button);
	var selectedDeviceId = String(selected.data('device-id'));
	var currentBackup = currentBackupsByDevice[selectedDeviceId] || {};

	$('#currentBackupVersion').text(currentBackup.version || '-');
	$('#currentBackupCreatedAt').text(currentBackup.createdAt || '-');
	$('#currentBackupWorkType').text(currentBackup.workType || '-');
	$('#selectedBackupHistoryId').val(selected.data('history-id'));
	$('#selectedBackupDeviceId').val(selectedDeviceId);
	$('#selectedBackupVersion').text(selected.data('version'));
	$('#selectedBackupCreatedAt').text(selected.data('created-at'));
	$('#selectedBackupWorkType').text(selected.data('work-type'));

	$('#backupHistoryListView').hide();
	$('#backupHistoryConfirmView').show();
	window.scrollTo(0, 0);
}

function closeBackupRestoreConfirm() {
	$('#backupHistoryConfirmView').hide();
	$('#backupHistoryListView').show();
	window.scrollTo(0, 0);
}

function downloadBackupHistory(button) {
	var historyId = $(button).data('history-id');
	var deviceId = $(button).data('device-id');
	location.href = backupHistoryContextPath
		+ '/device/backup-history/download?constructionIdx='
		+ encodeURIComponent(backupHistoryConstructionIdx)
		+ '&deviceId=' + encodeURIComponent(deviceId)
		+ '&historyId=' + encodeURIComponent(historyId);
}

function requestBackupRestore() {
	var historyId = $('#selectedBackupHistoryId').val();
	var deviceId = $('#selectedBackupDeviceId').val();
	var applyButton = $('.backup-history-confirm__apply');
	var applyButtonText = applyButton.text();

	if (!historyId || !deviceId) {
		alert('복구할 버전을 다시 선택해 주세요.');
		return;
	}

	applyButton.prop('disabled', true).text('복구 처리 중...');
	$.ajax({
		type: 'POST',
		url: backupHistoryContextPath + '/device/backup-history/restore',
		dataType: 'json',
		data: {
			constructionIdx: backupHistoryConstructionIdx,
			deviceId: deviceId,
			historyId: historyId
		},
		success: function(result) {
			if (result && result.success) {
				alert(result.created
					? '복구가 완료되어 ' + result.version + ' 버전이 생성되었습니다.'
					: '선택한 버전이 이미 현재 기록지와 같습니다.');
				location.href = backupHistoryContextPath
					+ '/device/backup-history?constructionIdx='
					+ encodeURIComponent(backupHistoryConstructionIdx)
					+ '&deviceId='
					+ encodeURIComponent(deviceId)
					+ '&restoredVersion='
					+ encodeURIComponent(result.version);
				return;
			}
			alert(result && result.message
					? result.message
					: '복구 처리에 실패했습니다.');
		},
		error: function() {
			alert('복구 처리 중 오류가 발생했습니다.');
		},
		complete: function() {
			applyButton.prop('disabled', false).text(applyButtonText);
		}
	});
}
</script>

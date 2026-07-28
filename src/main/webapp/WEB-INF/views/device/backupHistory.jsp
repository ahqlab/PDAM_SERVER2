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
	grid-template-columns: 1fr 1fr 1.5fr 50px;
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
.backup-history-table {
	width: 100%;
	border-collapse: collapse;
	border: 1px solid #c8c8c8;
	background: #fff;
	table-layout: fixed;
}
.backup-history-table th {
	height: 82px;
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
	.backup-history-filter--work-type {
		grid-column: 1 / -1;
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
						<c:forEach var="device" items="${deviceList}">
							<option value="${device.id}"
								<c:if test="${device.id == selectedDevice.id}">selected="selected"</c:if>>
								${fn:escapeXml(device.machineNumber)}
							</option>
						</c:forEach>
					</select>
				</div>

				<div class="backup-history-filter">
					<label for="backupVersionFilter">버전</label>
					<select id="backupVersionFilter">
						<option value="">전체</option>
						<c:forEach var="history" items="${backupHistoryList}">
							<option value="${fn:escapeXml(history.version)}">
								${fn:escapeXml(history.version)}
							</option>
						</c:forEach>
					</select>
				</div>

				<div class="backup-history-filter backup-history-filter--work-type">
					<label for="backupWorkTypeFilter">작업 구분</label>
					<select id="backupWorkTypeFilter">
						<option value="" selected="selected">전체</option>
						<option value="수정 전 자동 백업">수정 전 자동 백업</option>
						<option value="복구">복구</option>
					</select>
				</div>

				<button type="button" class="backup-history-search__button"
					aria-label="백업 이력 검색" onclick="filterBackupHistory();">
					<img src="${pageContext.request.contextPath}/new/img/search.png" alt="">
				</button>
			</div>
		</div>

		<div class="backup-history-count">
			전체
			<strong id="backupHistoryVisibleCount">${fn:length(backupHistoryList)}</strong>건
		</div>

		<div class="backup-history-table-wrap">
			<table class="backup-history-table">
				<colgroup>
					<col style="width: 20%;">
					<col style="width: 28%;">
					<col style="width: 32%;">
					<col style="width: 20%;">
				</colgroup>
				<thead>
					<tr>
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
								<tr class="backup-history-row"
									data-version="${fn:escapeXml(history.version)}"
									data-created-at="${fn:escapeXml(history.createdAt)}"
									data-work-type="${fn:escapeXml(history.workType)}">
									<td>${fn:escapeXml(history.version)}</td>
									<td>${fn:escapeXml(history.createdAt)}</td>
									<td>${fn:escapeXml(history.workType)}</td>
									<td>
										<div class="backup-history-management">
											<button type="button" class="backup-history-restore-button"
												data-history-id="${history.id}"
												data-version="${fn:escapeXml(history.version)}"
												data-created-at="${fn:escapeXml(history.createdAt)}"
												data-work-type="${fn:escapeXml(history.workType)}"
												onclick="openBackupRestoreConfirm(this);">
												복구
											</button>
											<button type="button" class="backup-history-download-button"
												data-history-id="${history.id}"
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
								<td colspan="4" class="backup-history-table__empty">
									선택한 호기의 백업 이력이 없습니다.
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
			현재 버전을 먼저 다시 백업한 뒤 선택한 내용으로 새로운 버전을 생성합니다.
			기존 버전은 삭제되지 않습니다.
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
		<div class="backup-history-confirm__actions">
			<button type="button" class="backup-history-confirm__apply"
				onclick="requestBackupRestore();">기록 백업 후 반영</button>
			<button type="button" class="backup-history-confirm__cancel"
				onclick="closeBackupRestoreConfirm();">취소</button>
		</div>
	</div>
</div>

<script>
var backupHistoryContextPath = '${pageContext.request.contextPath}';
var backupHistoryConstructionIdx = '${constructionIdx}';
var backupHistoryDeviceId = '<c:out value="${selectedDevice.id}" />';
var currentBackup = {
	version: '<c:out value="${currentBackup.version}" />',
	createdAt: '<c:out value="${currentBackup.createdAt}" />',
	workType: '<c:out value="${currentBackup.workType}" />'
};
function changeBackupHistoryDevice(deviceId) {
	location.href = backupHistoryContextPath
		+ '/device/backup-history?constructionIdx='
		+ encodeURIComponent(backupHistoryConstructionIdx)
		+ '&deviceId=' + encodeURIComponent(deviceId);
}

function filterBackupHistory() {
	var version = $.trim($('#backupVersionFilter').val()).toLowerCase();
	var workType = $.trim($('#backupWorkTypeFilter').val()).toLowerCase();
	var visibleCount = 0;

	$('.backup-history-row').each(function() {
		var row = $(this);
		var rowVersion = String(row.data('version')).toLowerCase();
		var rowWorkType = String(row.data('work-type')).toLowerCase();
		var matches = (!version || rowVersion === version)
			&& (!workType || rowWorkType === workType);

		row.toggle(matches);
		if (matches) {
			visibleCount++;
		}
	});

	$('#backupHistoryVisibleCount').text(visibleCount);
}

function openBackupRestoreConfirm(button) {
	var selected = $(button);

	$('#currentBackupVersion').text(currentBackup.version || '-');
	$('#currentBackupCreatedAt').text(currentBackup.createdAt || '-');
	$('#currentBackupWorkType').text(currentBackup.workType || '-');
	$('#selectedBackupHistoryId').val(selected.data('history-id'));
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
	location.href = backupHistoryContextPath
		+ '/device/backup-history/download?constructionIdx='
		+ encodeURIComponent(backupHistoryConstructionIdx)
		+ '&deviceId=' + encodeURIComponent(backupHistoryDeviceId)
		+ '&historyId=' + encodeURIComponent(historyId);
}

function requestBackupRestore() {
	var historyId = $('#selectedBackupHistoryId').val();
	var applyButton = $('.backup-history-confirm__apply');

	if (!historyId) {
		alert('복구할 버전을 다시 선택해 주세요.');
		return;
	}

	applyButton.prop('disabled', true);
	$.ajax({
		type: 'POST',
		url: backupHistoryContextPath + '/device/backup-history/restore',
		dataType: 'json',
		data: {
			constructionIdx: backupHistoryConstructionIdx,
			deviceId: backupHistoryDeviceId,
			historyId: historyId
		},
		success: function(result) {
			if (result && result.success) {
				alert('복구가 완료되어 ' + result.version
					+ ' 버전이 생성되었습니다.');
				location.href = backupHistoryContextPath
					+ '/device/backup-history?constructionIdx='
					+ encodeURIComponent(backupHistoryConstructionIdx)
					+ '&deviceId='
					+ encodeURIComponent(backupHistoryDeviceId);
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
			applyButton.prop('disabled', false);
		}
	});
}
</script>

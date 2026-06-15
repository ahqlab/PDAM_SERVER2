<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/tagLib.jsp" %>
<div class="section-right">
	<%@ include file="/WEB-INF/views/common/welcomeMsg.jsp" %>
	<div class="TopContArea">
		<div class="titArea">
			<p class="h1Tit">계약 조항 관리</p>
			<c:if test="${sessionInfo.role == 0}">
				<div class="popBtn" onclick="addNewRow()" style="cursor:pointer;">+ 조항 추가</div>
			</c:if>
		</div>
		<div style="margin-top:16px;display:flex;gap:0;border-bottom:2px solid #337ab7;">
			<div id="tab-DAILY"   onclick="loadTab('DAILY')"   style="cursor:pointer;padding:8px 24px;border:1px solid #ddd;border-bottom:none;background:#337ab7;color:#fff;font-weight:bold;">일사용료</div>
			<div id="tab-MONTHLY" onclick="loadTab('MONTHLY')" style="cursor:pointer;padding:8px 24px;border:1px solid #ddd;border-bottom:none;background:#f5f5f5;color:#666;">월사용료</div>
		</div>
	</div>

	<div class="listArea" style="padding:20px;">
		<table id="clauseTable" style="width:100%;border-collapse:collapse;">
			<thead>
				<tr style="background:#f5f5f5;border-bottom:2px solid #ddd;">
					<th style="padding:10px;text-align:center;width:70px;">조번호</th>
					<th style="padding:10px;text-align:left;">내용</th>
					<th style="padding:10px;text-align:center;width:60px;">정렬</th>
					<c:if test="${sessionInfo.role == 0}">
					<th style="padding:10px;text-align:center;width:150px;">관리</th>
					</c:if>
				</tr>
			</thead>
			<tbody id="clauseBody">
				<tr><td colspan="4" style="text-align:center;padding:30px;color:#999;">로딩 중...</td></tr>
			</tbody>
		</table>
	</div>
</div>

<script>
var isAdmin = ${sessionInfo.role == 0};
var currentType = 'DAILY';
var ctx = '${pageContext.request.contextPath}';

$(function() { loadTab('DAILY'); });

function loadTab(type) {
	currentType = type;
	$('#tab-DAILY').css({background: type==='DAILY' ? '#337ab7' : '#f5f5f5', color: type==='DAILY' ? '#fff' : '#666', fontWeight: type==='DAILY' ? 'bold' : 'normal'});
	$('#tab-MONTHLY').css({background: type==='MONTHLY' ? '#337ab7' : '#f5f5f5', color: type==='MONTHLY' ? '#fff' : '#666', fontWeight: type==='MONTHLY' ? 'bold' : 'normal'});
	$.get(ctx + '/contractClause/get/list', { contractType: type }, function(data) {
		renderList(data);
	});
}

function renderList(clauses) {
	var tbody = $('#clauseBody').empty();
	if (!clauses || clauses.length === 0) {
		tbody.append('<tr><td colspan="4" style="text-align:center;padding:30px;color:#999;">등록된 조항이 없습니다. [+ 조항 추가]를 눌러 등록하세요.</td></tr>');
		return;
	}
	$.each(clauses, function(i, c) { tbody.append(makeViewRow(c)); });
}

function makeViewRow(c) {
	var preview = (c.clauseContent || '').replace(/</g,'&lt;');
	if (preview.length > 80) preview = preview.substring(0, 80) + '...';
	var adminTd = isAdmin
		? '<td style="text-align:center;padding:8px;white-space:nowrap;">'
		  + '<button onclick="editRow(this,' + c.clauseIdx + ')" class="changeBtn" style="margin-right:4px;">수정</button>'
		  + '<button onclick="deleteRow(this,' + c.clauseIdx + ')" class="changeBtn" style="background:#dc3545;color:#fff;">삭제</button>'
		  + '</td>'
		: '';
	return $('<tr data-idx="' + c.clauseIdx + '" style="border-bottom:1px solid #eee;">'
		+ '<td style="text-align:center;padding:10px;">제' + c.clauseNo + '조</td>'
		+ '<td style="padding:10px;font-size:12px;color:#555;">' + preview + '</td>'
		+ '<td style="text-align:center;padding:10px;">' + (c.sortOrder || 0) + '</td>'
		+ adminTd
		+ '</tr>');
}

function makeEditRow(c) {
	var idx     = c ? c.clauseIdx  : 0;
	var no      = c ? c.clauseNo   : '';
	var content = c ? (c.clauseContent || '') : '';
	var sort    = c ? (c.sortOrder     || 0)  : 0;
	var saveTd = isAdmin
		? '<td style="text-align:center;padding:8px;vertical-align:top;white-space:nowrap;">'
		  + '<button onclick="saveRow(this)" class="popAdd" style="cursor:pointer;display:block;width:64px;margin-bottom:4px;">저장</button>'
		  + '<button onclick="cancelRow(this,' + idx + ')" class="popAdd" style="cursor:pointer;background:#999;display:block;width:64px;">취소</button>'
		  + '</td>'
		: '';
	return $('<tr data-idx="' + idx + '" data-type="' + currentType + '" class="edit-row" style="border-bottom:1px solid #eee;background:#fffde7;">'
		+ '<td style="text-align:center;padding:8px;vertical-align:top;"><input type="number" name="clauseNo" value="' + no + '" placeholder="조번호" style="width:55px;text-align:center;padding:4px;"/></td>'
		+ '<td style="padding:8px;vertical-align:top;"><textarea name="clauseContent" rows="6" style="width:100%;resize:vertical;padding:4px;">' + escHtml(content) + '</textarea></td>'
		+ '<td style="text-align:center;padding:8px;vertical-align:top;"><input type="number" name="sortOrder" value="' + sort + '" style="width:50px;text-align:center;padding:4px;"/></td>'
		+ saveTd
		+ '</tr>');
}

function editRow(btn, clauseIdx) {
	var tr = $(btn).closest('tr');
	$.get(ctx + '/contractClause/get/list', { contractType: currentType }, function(data) {
		var clause = null;
		$.each(data, function(i, c) { if (c.clauseIdx == clauseIdx) { clause = c; return false; } });
		if (clause) tr.replaceWith(makeEditRow(clause));
	});
}

function cancelRow(btn, clauseIdx) {
	var tr = $(btn).closest('tr');
	if (clauseIdx === 0) {
		tr.remove();
		return;
	}
	$.get(ctx + '/contractClause/get/list', { contractType: currentType }, function(data) {
		var clause = null;
		$.each(data, function(i, c) { if (c.clauseIdx == clauseIdx) { clause = c; return false; } });
		if (clause) tr.replaceWith(makeViewRow(clause));
	});
}

function addNewRow() {
	$('#clauseBody tr[data-idx="0"]').remove();
	var newRow = makeEditRow(null);
	var noDataRow = $('#clauseBody tr td[colspan]').closest('tr');
	if (noDataRow.length > 0) noDataRow.remove();
	$('#clauseBody').append(newRow);
	newRow.find('[name=clauseNo]').focus();
}

function saveRow(btn) {
	var tr = $(btn).closest('tr');
	var clauseIdx    = parseInt(tr.data('idx')) || 0;
	var contractType = tr.data('type') || currentType;
	var clauseNo     = tr.find('[name=clauseNo]').val();
	var clauseContent = tr.find('[name=clauseContent]').val();
	var sortOrder    = tr.find('[name=sortOrder]').val() || 0;

	if (!clauseNo)      { alert('조번호를 입력하세요.'); return; }
	if (!clauseContent) { alert('내용을 입력하세요.');   return; }

	$.post(ctx + '/contractClause/ajax/save', {
		clauseIdx:    clauseIdx,
		contractType: contractType,
		clauseNo:     clauseNo,
		clauseContent: clauseContent,
		sortOrder:    sortOrder,
		isActive:     1
	}, function(newIdx) {
		var saved = {
			clauseIdx:    newIdx,
			contractType: contractType,
			clauseNo:     clauseNo,
			clauseContent: clauseContent,
			sortOrder:    parseInt(sortOrder)
		};
		tr.replaceWith(makeViewRow(saved));
		alert('저장되었습니다.');
	}).fail(function() {
		alert('저장에 실패했습니다. 다시 시도하세요.');
	});
}

function deleteRow(btn, clauseIdx) {
	if (!confirm('해당 조항을 비활성화 하시겠습니까?')) return;
	var tr = $(btn).closest('tr');
	$.post(ctx + '/contractClause/ajax/delete', { clauseIdx: clauseIdx }, function(ok) {
		if (ok) {
			tr.fadeOut(200, function() {
				$(this).remove();
				if ($('#clauseBody tr').length === 0) {
					$('#clauseBody').append('<tr><td colspan="4" style="text-align:center;padding:30px;color:#999;">등록된 조항이 없습니다.</td></tr>');
				}
			});
		} else {
			alert('삭제에 실패했습니다.');
		}
	});
}

function escHtml(s) {
	return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');
}
function escAttr(s) {
	return String(s).replace(/"/g,'&quot;').replace(/'/g,'&#39;');
}
</script>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/tagLib.jsp" %>
<div class="section-right">
	<%@ include file="/WEB-INF/views/common/welcomeMsg.jsp" %>
	<div class="TopContArea">
		<div class="titArea">
			<p class="h1Tit">사업자정보 관리</p>
			<div class="popBtn" onclick="openForm(0)" style="cursor:pointer;">+ 사업자 등록</div>
		</div>
	</div>

	<div class="listArea" style="padding:20px;">
		<!-- 검색영역 -->
		<div class="company-searchArea" style="margin-bottom:15px;display:flex;gap:8px;align-items:center;flex-wrap:wrap;">
			<select id="searchType" class="company-search-input" style="width:130px;">
				<option value="name">상호명</option>
				<option value="businessNo">사업자번호</option>
				<option value="representative">대표자</option>
				<option value="tel">전화번호</option>
				<option value="address">주소</option>
			</select>
			<input type="text" id="searchKeyword" class="company-search-input" style="width:220px;" placeholder="검색어를 입력하세요" />
			<div class="company-search-btn" onclick="searchCompany()">검색</div>
			<div class="company-search-btn" onclick="resetSearch()" style="background:#999;">초기화</div>
		</div>

		<!-- 데스크탑 테이블 -->
		<div class="pc-table-wrap" style="overflow-x:auto;">
			<table style="width:100%;min-width:700px;border-collapse:collapse;">
				<thead>
					<tr style="background:#f5f5f5;border-bottom:2px solid #ddd;">
						<th style="padding:10px;text-align:center;width:50px;white-space:nowrap;">No</th>
						<th style="padding:10px;text-align:center;min-width:120px;white-space:nowrap;">상호명</th>
						<th style="padding:10px;text-align:center;min-width:130px;white-space:nowrap;">사업자번호</th>
						<th style="padding:10px;text-align:center;min-width:90px;white-space:nowrap;">대표자</th>
						<th style="padding:10px;text-align:center;min-width:120px;white-space:nowrap;">전화번호</th>
						<th style="padding:10px;text-align:center;">주소</th>
						<th style="padding:10px;text-align:center;min-width:100px;white-space:nowrap;">관리</th>
					</tr>
				</thead>
				<tbody id="companyTbody">
					<tr><td colspan="7" style="text-align:center;padding:24px;color:#999;">불러오는 중...</td></tr>
				</tbody>
			</table>
		</div>
		<!-- 모바일 카드 -->
		<div id="companyCards" style="display:none;"></div>

		<!-- 페이지네이션 -->
		<div id="companyPagination" style="display:flex;justify-content:center;gap:5px;margin-top:20px;"></div>
	</div>

<style>
@media (max-width: 600px) {
	.pc-table-wrap { display: none !important; }
	#companyCards  { display: block !important; }
}
.company-search-input {
	border: 1px solid #d1d1d1;
	border-radius: 7px;
	height: 40px;
	line-height: 40px;
	padding: 0 12px;
	font-size: 14px;
	box-sizing: border-box;
}
.company-search-btn {
	display: inline-block;
	background: #077b9c;
	border-radius: 7px;
	height: 40px;
	line-height: 40px;
	padding: 0 20px;
	text-align: center;
	font-size: 14px;
	color: #fff;
	cursor: pointer;
	box-sizing: border-box;
}
.pageBtn {
	min-width:32px;
	height:32px;
	padding:0 8px;
	border:1px solid #ddd;
	background:#fff;
	color:#333;
	border-radius:3px;
	cursor:pointer;
	font-size:13px;
}
.pageBtn.active {
	background:#337ab7;
	color:#fff;
	border-color:#337ab7;
}
.pageBtn:disabled {
	cursor:default;
	color:#ccc;
}
</style>
</div>

<!-- 등록/수정 모달 -->
<div id="companyModal" style="display:none;position:fixed;top:0;left:0;width:100%;height:100%;background:rgba(0,0,0,0.45);z-index:9999;align-items:center;justify-content:center;">
	<div style="background:#fff;border-radius:6px;padding:30px 30px 24px;width:500px;max-width:95%;box-shadow:0 4px 20px rgba(0,0,0,0.2);">
		<h3 id="modalTitle" style="font-size:16px;margin:0 0 20px;color:#333;">사업자 등록</h3>
		<input type="hidden" id="m_id" value="0" />

		<div class="inputArea02 mb-20">
			<p class="inputTxt02">상호명</p>
			<input type="text" id="m_name" class="Input02" placeholder="상호명" />
		</div>
		<div class="inputArea02 mb-20">
			<p class="inputTxt02">사업자번호</p>
			<input type="text" id="m_businessNo" class="Input02" placeholder="000-00-00000" />
		</div>
		<div class="inputArea02 mb-20">
			<p class="inputTxt02">대표자</p>
			<input type="text" id="m_representative" class="Input02" placeholder="대표자 성명" />
		</div>
		<div class="inputArea02 mb-20">
			<p class="inputTxt02">전화번호</p>
			<input type="text" id="m_tel" class="Input02" placeholder="전화번호" />
		</div>
		<div class="inputArea02 mb-20">
			<p class="inputTxt02">주소</p>
			<input type="text" id="m_address" class="Input02" placeholder="주소" />
		</div>

		<div style="display:flex;gap:8px;justify-content:flex-end;margin-top:24px;">
			<div class="popAdd" onclick="saveCompany()" style="cursor:pointer;">저장</div>
			<div class="popAdd" onclick="closeModal()" style="cursor:pointer;background:#999;">취소</div>
		</div>
	</div>
</div>

<script>
var ctx = '${pageContext.request.contextPath}';

var BTN_EDIT = 'cursor:pointer;padding:5px 14px;background:#337ab7;color:#fff;border:none;border-radius:3px;font-size:13px;margin-right:4px;';
var BTN_DEL  = 'cursor:pointer;padding:5px 14px;background:#d9534f;color:#fff;border:none;border-radius:3px;font-size:13px;';

var PAGE_SIZE = 10;
var currentPage = 1;
var allCompanyData = [];

function loadList() {
	$.getJSON(ctx + '/company/ajax/list', function(data) {
		allCompanyData = data || [];
		currentPage = 1;
		renderList();
	});
}

function getFilteredData() {
	var type    = $('#searchType').val();
	var keyword = $.trim($('#searchKeyword').val()).toLowerCase();
	if (!keyword) return allCompanyData;
	return $.grep(allCompanyData, function(c) {
		var val = String(c[type] || '').toLowerCase();
		return val.indexOf(keyword) !== -1;
	});
}

function searchCompany() {
	currentPage = 1;
	renderList();
}

function resetSearch() {
	$('#searchType').val('name');
	$('#searchKeyword').val('');
	currentPage = 1;
	renderList();
}

function renderList() {
	var filtered = getFilteredData();
	/* ── 테이블 (데스크탑) ── */
	var tbody = $('#companyTbody');
	/* ── 카드 (모바일) ── */
	var cards = $('#companyCards');

	if (!filtered || filtered.length === 0) {
		var emptyMsg = allCompanyData.length === 0 ? '등록된 사업자정보가 없습니다.' : '검색 결과가 없습니다.';
		tbody.html('<tr><td colspan="7" style="text-align:center;padding:24px;color:#999;">' + emptyMsg + '</td></tr>');
		cards.html('<p style="text-align:center;padding:24px;color:#999;">' + emptyMsg + '</p>');
		renderPagination(0);
		return;
	}

	var totalPages = Math.ceil(filtered.length / PAGE_SIZE) || 1;
	if (currentPage > totalPages) currentPage = totalPages;
	var startIdx  = (currentPage - 1) * PAGE_SIZE;
	var pageData  = filtered.slice(startIdx, startIdx + PAGE_SIZE);

	var rows = '', cardHtml = '';
	$.each(pageData, function(i, c) {
		var editBtn = '<button onclick="openForm(' + c.id + ')" style="' + BTN_EDIT + '">수정</button>';
		var delBtn  = '<button onclick="deleteCompany(' + c.id + ')" style="' + BTN_DEL + '">삭제</button>';

		/* 테이블 행 */
		rows += '<tr style="border-bottom:1px solid #eee;">'
			+ '<td style="padding:10px;text-align:center;border:1px solid #eee;white-space:nowrap;">' + (startIdx + i + 1) + '</td>'
			+ '<td style="padding:10px;text-align:center;border:1px solid #eee;white-space:nowrap;">' + escHtml(c.name) + '</td>'
			+ '<td style="padding:10px;text-align:center;border:1px solid #eee;white-space:nowrap;">' + escHtml(c.businessNo) + '</td>'
			+ '<td style="padding:10px;text-align:center;border:1px solid #eee;white-space:nowrap;">' + escHtml(c.representative) + '</td>'
			+ '<td style="padding:10px;text-align:center;border:1px solid #eee;white-space:nowrap;">' + escHtml(c.tel) + '</td>'
			+ '<td style="padding:10px;border:1px solid #eee;">' + escHtml(c.address) + '</td>'
			+ '<td style="padding:10px;text-align:center;border:1px solid #eee;white-space:nowrap;">' + editBtn + delBtn + '</td>'
			+ '</tr>';

		/* 모바일 카드 */
		cardHtml += '<div style="background:#fff;border:1px solid #ddd;border-radius:6px;padding:14px 16px;margin-bottom:10px;">'
			+ '<div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:8px;">'
			+   '<span style="font-weight:bold;font-size:15px;color:#333;">' + escHtml(c.name) + '</span>'
			+   '<span>' + editBtn + delBtn + '</span>'
			+ '</div>'
			+ '<table style="width:100%;font-size:13px;border-collapse:collapse;">'
			+ '<tr><td style="color:#888;padding:3px 8px 3px 0;width:80px;">사업자번호</td><td style="padding:3px 0;">' + escHtml(c.businessNo) + '</td></tr>'
			+ '<tr><td style="color:#888;padding:3px 8px 3px 0;">대표자</td><td style="padding:3px 0;">' + escHtml(c.representative) + '</td></tr>'
			+ '<tr><td style="color:#888;padding:3px 8px 3px 0;">전화번호</td><td style="padding:3px 0;">' + escHtml(c.tel) + '</td></tr>'
			+ '<tr><td style="color:#888;padding:3px 8px 3px 0;">주소</td><td style="padding:3px 0;">' + escHtml(c.address) + '</td></tr>'
			+ '</table></div>';
	});

	tbody.html(rows);
	cards.html(cardHtml);
	renderPagination(filtered.length);
}

function renderPagination(totalItems) {
	var totalPages = Math.ceil(totalItems / PAGE_SIZE);
	var wrap = $('#companyPagination');
	if (totalPages <= 1) { wrap.html(''); return; }

	var html = '';
	html += '<button class="pageBtn" onclick="goPage(' + (currentPage - 1) + ')"' + (currentPage <= 1 ? ' disabled' : '') + '>이전</button>';
	for (var p = 1; p <= totalPages; p++) {
		html += '<button class="pageBtn' + (p === currentPage ? ' active' : '') + '" onclick="goPage(' + p + ')">' + p + '</button>';
	}
	html += '<button class="pageBtn" onclick="goPage(' + (currentPage + 1) + ')"' + (currentPage >= totalPages ? ' disabled' : '') + '>다음</button>';
	wrap.html(html);
}

function goPage(p) {
	var totalPages = Math.ceil(getFilteredData().length / PAGE_SIZE) || 1;
	if (p < 1 || p > totalPages || p === currentPage) return;
	currentPage = p;
	renderList();
}

function openForm(id) {
	$('#m_id').val(id);
	$('#m_name,#m_businessNo,#m_representative,#m_tel,#m_address').val('');
	$('#modalTitle').text(id === 0 ? '사업자 등록' : '사업자 수정');
	if (id !== 0) {
		$.getJSON(ctx + '/company/ajax/detail', {id: id}, function(c) {
			$('#m_name').val(c.name);
			$('#m_businessNo').val(c.businessNo);
			$('#m_representative').val(c.representative);
			$('#m_tel').val(c.tel);
			$('#m_address').val(c.address);
		});
	}
	$('#companyModal').css('display', 'flex');
}

function closeModal() {
	$('#companyModal').css('display', 'none');
}

function saveCompany() {
	var id  = parseInt($('#m_id').val());
	var url = id === 0 ? ctx + '/company/ajax/regist' : ctx + '/company/ajax/update';
	var data = {
		id:             id,
		name:           $.trim($('#m_name').val()),
		businessNo:     $.trim($('#m_businessNo').val()),
		representative: $.trim($('#m_representative').val()),
		tel:            $.trim($('#m_tel').val()),
		address:        $.trim($('#m_address').val())
	};
	if (!data.name || !data.businessNo) {
		alert('상호명과 사업자번호는 필수입니다.');
		return;
	}
	$.post(url, data, function(res) {
		if (res.success) { closeModal(); loadList(); }
		else alert('저장 실패: ' + (res.message || '사업자번호가 중복되었을 수 있습니다.'));
	});
}

function deleteCompany(id) {
	if (!confirm('삭제하시겠습니까?')) return;
	$.post(ctx + '/company/ajax/delete', {id: id}, function(res) {
		if (res.success) loadList();
		else alert('삭제 실패');
	});
}

function escHtml(s) {
	return String(s || '').replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');
}

$(function() {
	loadList();
	$('#searchKeyword').on('keypress', function(e) {
		if (e.which === 13) searchCompany();
	});
});
</script>

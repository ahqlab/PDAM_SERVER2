<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/tagLib.jsp" %>

<div class="section-right">
	<%@ include file="/WEB-INF/views/common/welcomeMsg.jsp" %>
	<div class="TopContArea">
		<div class="titArea">
			<p class="h1Tit">고객관리</p>
			<a class="popBtn popBtn01" style="cursor:pointer;">+ 고객 등록</a>
		</div>
	</div>

	<div class="listArea" style="padding:20px; background:#fff; border-radius:8px; box-shadow:0 2px 10px rgba(0,0,0,0.05);">
		<div class="company-searchArea" style="margin-bottom:15px;display:flex;gap:8px;align-items:center;flex-wrap:wrap;">
			<select id="searchType" class="company-search-input" style="width:130px;">
				<option value="groupName">시공사</option>
				<option value="conName">협력사</option>
				<option value="conLocation">현장주소</option>
				<option value="conManager">관리자</option>
				<option value="conContact">연락처</option>
			</select>
			<input type="text" id="searchKeyword" class="company-search-input" style="width:220px;" placeholder="검색어를 입력하세요" />
			<div class="company-search-btn" onclick="searchCustomer()">검색</div>
			<div class="company-search-btn" onclick="resetSearch()" style="background:#999;">초기화</div>
		</div>

		<div class="pc-table-wrap" style="overflow-x:auto;">
			<table style="width:100%;min-width:700px;border-collapse:collapse;">
				<thead>
					<tr style="background:#f5f5f5;border-bottom:2px solid #ddd;">
						<th style="padding:10px;text-align:center;width:50px;white-space:nowrap;">No</th>
						<th style="padding:10px;text-align:center;min-width:120px;white-space:nowrap;">시공사</th>
						<th style="padding:10px;text-align:center;min-width:120px;white-space:nowrap;">협력사</th>
						<th style="padding:10px;text-align:center;">현장주소</th>
						<th style="padding:10px;text-align:center;min-width:90px;white-space:nowrap;">관리자</th>
						<th style="padding:10px;text-align:center;min-width:120px;white-space:nowrap;">연락처</th>
						<!-- <th style="padding:10px;text-align:center;min-width:100px;white-space:nowrap;">관리</th> -->
					</tr>
				</thead>
				<tbody id="customerTbody">
					<tr><td colspan="7" style="text-align:center;padding:24px;color:#999;">불러오는 중...</td></tr>
				</tbody>
			</table>
		</div>
		<div id="customerCards" style="display:none;"></div>

		<div id="customerPagination" style="display:flex;justify-content:center;gap:5px;margin-top:20px;"></div>
	</div>

<style>
@media (max-width: 600px) {
	.pc-table-wrap { display: none !important; }
	#customerCards { display: block !important; }
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
#customerTbody tr:hover {
	background-color: #f9f9f9;
}
</style>
</div>

<div class="popUp popUp01">
	<form id="regForm" name="regForm" method="POST" onsubmit="return false;">
		<div class="popTit">
			<p>고객등록</p>
			<img class="popClose" src="${pageContext.request.contextPath}/new/img/popclose.png" style="cursor:pointer;" />
		</div>
		<div class="popCont">
			<div class="inputArea02 mb-20">
				<p class="inputTxt02">시공사</p>
				<input type="text" autocomplete="off" class="Input02" name="groupName" id="groupName" placeholder="시공사명을 입력하세요.">
			</div>
			<div class="inputArea02 mb-20">
				<p class="inputTxt02">협력사</p>
				<input type="text" autocomplete="off" class="Input02" name="conName" id="conName" placeholder="협력사명을 입력하세요.">
			</div>
			<div class="inputArea02 mb-20">
				<p class="inputTxt02">현장주소</p>
				<input type="text" autocomplete="off" class="Input02" name="conLocation" id="conLocation" placeholder="현장주소를 입력하세요.">
			</div>
			<div class="inputArea02 mb-20">
				<p class="inputTxt02">관리자</p>
				<input type="text" autocomplete="off" class="Input02" name="conManager" id="conManager" placeholder="관리자 이름을 입력하세요.">
			</div>
			<div class="inputArea02 mb-20">
				<p class="inputTxt02">연락처</p>
				<input type="text" autocomplete="off" class="Input02" name="conContact" id="conContact" placeholder="관리자 연락처를 입력하세요.">
			</div>
			<div class="popAdd" onclick="return formCheck();" style="cursor:pointer;">등록</div>
		</div>
	</form>
</div>

<div class="popUp popUp02">
	<form id="updateForm" name="updateForm" method="POST" onsubmit="return false;">
		<div class="popTit">
			<p>고객수정</p>
			<img class="popClose" src="${pageContext.request.contextPath}/new/img/popclose.png" style="cursor:pointer;" />
		</div>
		<div class="popCont">
			<div class="inputArea02 mb-20">
				<p class="inputTxt02">시공사</p>
				<input type="hidden" name="id" id="up_id">
				<input type="text" autocomplete="off" class="Input02" name="groupName" id="up_groupName" placeholder="시공사명을 입력하세요.">
			</div>
			<div class="inputArea02 mb-20">
				<p class="inputTxt02">협력사</p>
				<input type="text" autocomplete="off" class="Input02" name="conName" id="up_conName" placeholder="협력사명을 입력하세요.">
			</div>
			<div class="inputArea02 mb-20">
				<p class="inputTxt02">현장주소</p>
				<input type="text" autocomplete="off" class="Input02" name="conLocation" id="up_conLocation" placeholder="현장주소를 입력하세요.">
			</div>
			<div class="inputArea02 mb-20">
				<p class="inputTxt02">관리자</p>
				<input type="text" autocomplete="off" class="Input02" name="conManager" id="up_conManager" placeholder="관리자 이름을 입력하세요.">
			</div>
			<div class="inputArea02 mb-20">
				<p class="inputTxt02">연락처</p>
				<input type="text" autocomplete="off" class="Input02" name="conContact" id="up_conContact" placeholder="관리자 연락처를 입력하세요.">
			</div>
			<div class="popAdd" onclick="return updateFormCheck();" style="cursor:pointer;">수정</div>
		</div>
	</form>
</div>

<div class="popLayer"></div>

<script>
var ctx = '${pageContext.request.contextPath}';

/* var BTN_EDIT = 'cursor:pointer;padding:5px 14px;background:#337ab7;color:#fff;border:none;border-radius:3px;font-size:13px;margin-right:4px;';
var BTN_DEL  = 'cursor:pointer;padding:5px 14px;background:#d9534f;color:#fff;border:none;border-radius:3px;font-size:13px;';
 */
 
var PAGE_SIZE = 10;
var currentPage = 1;
var allCustomerData = [];

function getGroupList() {
	jQuery.ajax({
		type: "GET",
		url: ctx + "/customer/get/list",
		dataType: "JSON",
		success: function(data) {
			allCustomerData = data || [];
			currentPage = 1;
			renderList();
		},
		error: function(xhr, status, error) {
			$('#customerTbody').html('<tr><td colspan="7" style="text-align:center;padding:24px;color:#999;">데이터를 불러오지 못했습니다.</td></tr>');
		}
	});
}

function getFilteredData() {
	var type = $('#searchType').val();
	var keyword = $.trim($('#searchKeyword').val()).toLowerCase();
	if (!keyword) return allCustomerData;
	return $.grep(allCustomerData, function(c) {
		var val = String(c[type] || '').toLowerCase();
		return val.indexOf(keyword) !== -1;
	});
}

function searchCustomer() {
	currentPage = 1;
	renderList();
}

function resetSearch() {
	$('#searchType').val('groupName');
	$('#searchKeyword').val('');
	currentPage = 1;
	renderList();
}

function renderList() {
	var filtered = getFilteredData();
	var tbody = $('#customerTbody');
	var cards = $('#customerCards');

	if (!filtered || filtered.length === 0) {
		var emptyMsg = allCustomerData.length === 0 ? '등록된 고객 정보가 없습니다.' : '검색 결과가 없습니다.';
		tbody.html('<tr><td colspan="7" style="text-align:center;padding:24px;color:#999;">' + emptyMsg + '</td></tr>');
		cards.html('<p style="text-align:center;padding:24px;color:#999;">' + emptyMsg + '</p>');
		renderPagination(0);
		return;
	}

	var totalPages = Math.ceil(filtered.length / PAGE_SIZE) || 1;
	if (currentPage > totalPages) currentPage = totalPages;
	var startIdx = (currentPage - 1) * PAGE_SIZE;
	var pageData = filtered.slice(startIdx, startIdx + PAGE_SIZE);

	var rows = '', cardHtml = '';
	$.each(pageData, function(i, c) {
		var cid = c.id !== undefined ? c.id : (c.idx !== undefined ? c.idx : '');
		
		/* var editBtn = '<button onclick="showUpdateDialog(\'' + cid + '\',\'' + escQuote(c.groupName) + '\',\'' + escQuote(c.conName) + '\',\'' + escQuote(c.conLocation) + '\',\'' + escQuote(c.conManager) + '\',\'' + escQuote(c.conContact) + '\')" style="' + BTN_EDIT + '">수정</button>';
		var delBtn  = '<button onclick="deleteCustomer(\'' + ctx + '/customer/delete?id=' + cid + '\',\'' + cid + '\')" style="' + BTN_DEL + '">삭제</button>'; */

		rows += '<tr style="border-bottom:1px solid #eee;">'
			+ '<td style="padding:10px;text-align:center;border:1px solid #eee;white-space:nowrap;">' + (startIdx + i + 1) + '</td>'
			+ '<td style="padding:10px;text-align:center;border:1px solid #eee;white-space:nowrap;">' + escHtml(c.groupName) + '</td>'
			+ '<td style="padding:10px;text-align:center;border:1px solid #eee;white-space:nowrap;">' + escHtml(c.conName) + '</td>'
			+ '<td style="padding:10px;border:1px solid #eee;">' + escHtml(c.conLocation) + '</td>'
			+ '<td style="padding:10px;text-align:center;border:1px solid #eee;white-space:nowrap;">' + escHtml(c.conManager) + '</td>'
			+ '<td style="padding:10px;text-align:center;border:1px solid #eee;white-space:nowrap;">' + escHtml(c.conContact) + '</td>'
			/* + '<td style="padding:10px;text-align:center;border:1px solid #eee;white-space:nowrap;">' + editBtn + delBtn + '</td>' */
			+ '</tr>';

		cardHtml += '<div style="background:#fff;border:1px solid #ddd;border-radius:6px;padding:14px 16px;margin-bottom:10px;">'
			+ '<div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:8px;">'
			+ '<span style="font-weight:bold;font-size:15px;color:#333;">' + escHtml(c.groupName) + ' (' + escHtml(c.conName) + ')</span>'
			+ '<span>' + /* editBtn + delBtn + */ '</span>'
			+ '</div>'
			+ '<table style="width:100%;font-size:13px;border-collapse:collapse;">'
			+ '<tr><td style="color:#888;padding:3px 8px 3px 0;width:80px;">현장주소</td><td style="padding:3px 0;">' + escHtml(c.conLocation) + '</td></tr>'
			+ '<tr><td style="color:#888;padding:3px 8px 3px 0;">관리자</td><td style="padding:3px 0;">' + escHtml(c.conManager) + '</td></tr>'
			+ '<tr><td style="color:#888;padding:3px 8px 3px 0;">연락처</td><td style="padding:3px 0;">' + escHtml(c.conContact) + '</td></tr>'
			+ '</table></div>';
	});

	tbody.html(rows);
	cards.html(cardHtml);
	renderPagination(filtered.length);
}

function renderPagination(totalItems) {
	var totalPages = Math.ceil(totalItems / PAGE_SIZE);
	var wrap = $('#customerPagination');
	if (totalPages <= 1) { wrap.html(''); return; }

	var blockSize = 10; 
	var currentBlock = Math.ceil(currentPage / blockSize); 
	var totalBlocks = Math.ceil(totalPages / blockSize); 

	var startPage = (currentBlock - 1) * blockSize + 1;
	var endPage = Math.min(currentBlock * blockSize, totalPages); 

	var html = '';
	if (currentBlock > 1) {
		html += '<button class="pageBtn" onclick="goPage(' + (startPage - 1) + ')">이전</button>';
	}
	for (var p = startPage; p <= endPage; p++) {
		html += '<button class="pageBtn' + (p === currentPage ? ' active' : '') + '" onclick="goPage(' + p + ')">' + p + '</button>';
	}
	if (currentBlock < totalBlocks) {
		html += '<button class="pageBtn" onclick="goPage(' + (endPage + 1) + ')">다음</button>';
	}

	wrap.html(html);
}

function goPage(p) {
	if (p < 1 || p === currentPage) return;
	currentPage = p;
	renderList();
}

/* function showUpdateDialog(id, groupName, conName, conLocation, conManager, conContact) {
	$('.popUp02').show();
	$('.popLayer').show();
	$('body').css('overflow', 'hidden');
	
	if (id === '0' || id === '' || id === 'undefined') {
		$("#updateForm input").attr("readonly", true);
	} else {
		$("#updateForm input").attr("readonly", false);
	}
	
	$('#up_id').val(id);
	$('#up_groupName').val(groupName === 'null' || groupName === 'undefined' ? '' : groupName);
	$('#up_conName').val(conName === 'null' || conName === 'undefined' ? '' : conName);
	$('#up_conLocation').val(conLocation === 'null' || conLocation === 'undefined' ? '' : conLocation);
	$('#up_conManager').val(conManager === 'null' || conManager === 'undefined' ? '' : conManager);
	$('#up_conContact').val(conContact === 'null' || conContact === 'undefined' ? '' : conContact);
}

function deleteCustomer(url, id) {
	if (!id || id == '0' || id === 'undefined') {
		alert('삭제할 수 없습니다.');
		return;
	}

	if (confirm("삭제하시겠습니까?")) {
		jQuery.ajax({
			type: "GET",
			url: url,
			dataType: "JSON",
			success: function(res) {
				getGroupList();
			},
			error: function(xhr, status, error) {
				getGroupList();
			}
		});
	}
}

function updateFormCheck() {
	if ($('#up_conManager').val() == '') {
		alert('관리자를 입력하세요.');
		return false;
	} else if ($('#up_conContact').val() == '') {
		alert('전화번호를 입력하세요.');
		return false;
	}
	
	var customerId = $('#up_id').val();
	if (!customerId || customerId == '0' || customerId === 'undefined') {
		alert('수정할 수 없는 데이터입니다. (ID 누락)');
		return false;
	}
	
	var myObject = {
		id: Number(customerId),
		groupName: $('#up_groupName').val(),
		conName: $('#up_conName').val(),
		conLocation: $('#up_conLocation').val(),
		conManager: $('#up_conManager').val(),
		conContact: $('#up_conContact').val()
	};
	
	console.log("전송 데이터:", myObject); // F12 콘솔에서 확인 가능

	jQuery.ajax({
		type: "POST",
		url: ctx + "/customer/update",
		contentType: "application/json",
		data: JSON.stringify(myObject),
		success: function(data) {
			if (data || data === 1 || data === "1" || (data && data.success)) {
				$('.popUp').hide();
				$('.popLayer').hide();
				$('body').css('overflow', 'auto');
				getGroupList();
				$('#updateForm')[0].reset();
			} else {
				alert('수정 실패');
			}
		},
		error: function(xhr, status, error) {
			alert('서버 통신 오류가 발생했습니다.');
			$('.popUp').hide();
			$('.popLayer').hide();
			$('body').css('overflow', 'auto');
		}
	});
	return false;
} */

function formCheck() {
	if ($("#regForm input[name='conManager']").val() == '') {
		alert('관리자를 입력하세요.');
		return false;
	} else if ($("#regForm input[name='conContact']").val() == '') {
		alert('전화번호를 입력하세요.');
		return false;
	}
	
	var myObject = {
		id: 0,
		groupName: $("#regForm input[name='groupName']").val(),
		conName: $("#regForm input[name='conName']").val(),
		conLocation: $("#regForm input[name='conLocation']").val(),
		conManager: $("#regForm input[name='conManager']").val(),
		conContact: $("#regForm input[name='conContact']").val()
	};
	
	jQuery.ajax({
		type: "POST",
		url: ctx + "/customer/regist",
		contentType: "application/json",
		data: JSON.stringify(myObject),
		success: function(data) {
			if (data || data === 1 || data === "1" || (data && data.success)) {
				$('.popUp').hide();
				$('.popLayer').hide();
				$('body').css('overflow', 'auto');
				getGroupList();
				$("#regForm")[0].reset();
			} else {
				alert('등록 실패');
			}
		},
		error: function(xhr, status, error) {
			alert('서버 통신 오류가 발생했습니다.');
			$('.popUp').hide();
			$('.popLayer').hide();
			$('body').css('overflow', 'auto');
		}
	});
	return false;
}

function escHtml(s) {
	return String(s || '').replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');
}

function escQuote(s) {
	return String(s || '').replace(/'/g, "\\'").replace(/"/g, '&quot;');
}

$(document).ready(function() {
	$('.popUp01').hide();
	$('.popUp02').hide();
	$('.popLayer').hide();

	getGroupList();

	$('#searchKeyword').on('keypress', function(e) {
		if (e.which === 13) searchCustomer();
	});

	$('.popBtn01').on('click', function(e) {
		$('.popUp01').show();
		$('.popLayer').show();
		$('body').css('overflow', 'hidden');
	});

	$('.popClose').on('click', function(e) {
		$('.popUp').hide();
		$('.popLayer').hide();
		$('body').css('overflow', 'auto');
	});

	$(".navBtn").click(function() {
		$(".left-menu").animate({ "left": "0%" }, 500);
	});
	$(".m-closeBtn").click(function() {
		$(".left-menu").animate({ "left": "-150%" }, 500);
	});
});

$('.mlist a').on('click', function(e){
	var tg = $(this).next('.sub-menu');
	if(tg.length > 0){
		if($(this).hasClass('isOpen')){
			tg.slideUp('fast');
			$(this).removeClass('isOpen');
		} else {
			if($('.mlist a.isOpen').length > 0){
				$('.mlist a.isOpen').next().slideUp('fast');
				$('.mlist a.isOpen').removeClass('isOpen');
			}
			tg.slideDown('fast');
			$(this).addClass('isOpen');
		}
		e.preventDefault();
	}
});
</script>
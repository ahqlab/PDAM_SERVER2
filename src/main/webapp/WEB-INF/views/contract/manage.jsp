<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/tagLib.jsp" %>
<div class="section-right">
	<%@ include file="/WEB-INF/views/common/welcomeMsg.jsp" %>
	<div class="TopContArea">
		<div class="titArea">
			<p class="h1Tit">계약서 관리</p>
			<c:if test="${sessionInfo.role == 0}">
				<c:set var="hasDraft" value="false"/>
				<c:forEach var="item" items="${contractList}">
					<c:if test="${item.status == 'DRAFT'}"><c:set var="hasDraft" value="true"/></c:if>
				</c:forEach>
				<div id="createBtn" class="popBtn" onclick="showForm(null)" style="cursor:pointer;">
					+ <c:choose><c:when test="${not empty contractList}">변경 계약서 작성</c:when><c:otherwise>계약서 작성</c:otherwise></c:choose>
				</div>
				<c:if test="${hasDraft}">
					<script>document.getElementById('createBtn').style.display='none';</script>
				</c:if>
			</c:if>
		</div>
	</div>

	<div class="mgr-wrap" style="display:flex;height:calc(100vh - 160px);overflow:hidden;">

		<!-- 좌측: 계약서 목록 -->
		<div id="leftPanel" style="width:260px;min-width:260px;border-right:2px solid #337ab7;overflow-y:auto;background:#fafafa;">
			<c:choose>
				<c:when test="${empty contractList}">
					<p id="emptyMsg" style="padding:20px;color:#999;text-align:center;">계약서가 없습니다.</p>
				</c:when>
				<c:otherwise>
					<c:forEach var="item" items="${contractList}">
						<div class="c-item" data-idx="${item.contractIdx}"
						     onclick="loadDetail(${item.contractIdx}, this)"
						     style="padding:14px 16px;border-bottom:1px solid #eee;cursor:pointer;">
							<p style="font-weight:bold;margin-bottom:4px;font-size:13px;">${item.contractNo}</p>
							<p style="font-size:12px;color:#555;margin-bottom:4px;">${item.siteName}</p>
							<p style="font-size:11px;">
								<c:choose><c:when test="${item.contractType=='DAILY'}">일사용료</c:when><c:otherwise>월사용료</c:otherwise></c:choose>
								&nbsp;|&nbsp;
								<c:choose>
									<c:when test="${item.status=='SIGNED'}"><span style="color:#28a745;font-weight:bold;">&#10003; 서명완료</span></c:when>
									<c:otherwise><span style="color:#856404;">서명대기</span></c:otherwise>
								</c:choose>
							</p>
							<p style="font-size:11px;color:#999;margin-top:4px;">${item.createdAt}</p>
						</div>
					</c:forEach>
				</c:otherwise>
			</c:choose>
		</div>

		<!-- 우측: 상세 / 입력 -->
		<div id="rightPanel" style="flex:1;overflow-y:auto;padding:24px;">
			<div style="height:100%;display:flex;align-items:center;justify-content:center;color:#bbb;font-size:15px;">
				좌측에서 계약서를 선택하거나 [+ 계약서 작성]을 클릭하세요.
			</div>
		</div>
	</div>
</div>

<script src="https://cdn.jsdelivr.net/npm/signature_pad@4.1.7/dist/signature_pad.umd.min.js"></script>
<script>
var ctx = '${pageContext.request.contextPath}';
var constructionIdx = ${constructionIdx};
var role = ${sessionInfo.role};
var pad = null;
var currentContract = null;
var currentClauses = [];
var constructionName = '${construction.name}';
var constructionLocation = '${construction.location}';
var constructionManager = '${construction.conManager}';

/* ───── 좌측 목록 ───── */
function refreshLeft() {
	$.getJSON(ctx + '/contract/ajax/list', {constructionIdx: constructionIdx}, function(list) {
		var html = '';
		if (!list || list.length === 0) {
			html = '<p style="padding:20px;color:#999;text-align:center;">계약서가 없습니다.</p>';
		} else {
			$.each(list, function(i, item) {
				var typeStr  = item.contractType === 'DAILY' ? '일사용료' : '월사용료';
				var sigStr   = item.status === 'SIGNED'
					? '<span style="color:#28a745;font-weight:bold;">&#10003; 서명완료</span>'
					: '<span style="color:#856404;">서명대기</span>';
				html += '<div class="c-item" data-idx="' + item.contractIdx + '" onclick="loadDetail(' + item.contractIdx + ',this)" '
					+ 'style="padding:14px 16px;border-bottom:1px solid #eee;cursor:pointer;">'
					+ '<p style="font-weight:bold;margin-bottom:4px;font-size:13px;">' + escHtml(item.contractNo||'') + '</p>'
					+ '<p style="font-size:12px;color:#555;margin-bottom:4px;">' + escHtml(item.siteName||'') + '</p>'
					+ '<p style="font-size:11px;">' + typeStr + ' &nbsp;|&nbsp; ' + sigStr + '</p>'
					+ '<p style="font-size:11px;color:#999;margin-top:4px;">' + (item.createdAt||'') + '</p>'
					+ '</div>';
			});
		}
		$('#leftPanel').html(html);
		var btn = document.getElementById('createBtn');
		if (btn) {
			var hasDraft = list && list.some(function(item) { return item.status === 'DRAFT'; });
			btn.style.display = hasDraft ? 'none' : '';
			btn.innerHTML = '+ ' + (!list || list.length === 0 ? '계약서 작성' : '변경 계약서 작성');
		}
	});
}

function highlightItem(contractIdx) {
	$('.c-item').css('background','');
	$('.c-item[data-idx="' + contractIdx + '"]').css('background','#e8f0fe');
}

/* ───── 상세보기 ───── */
function loadDetail(contractIdx, el) {
	highlightItem(contractIdx);
	$('#rightPanel').html('<div style="padding:40px;text-align:center;color:#999;">로딩 중...</div>');
	$.getJSON(ctx + '/contract/ajax/detail', {contractIdx: contractIdx}, function(data) {
		currentContract = data.contract;
		currentClauses  = data.clauses;
		renderDetail(data.contract, data.clauses);
	});
}

function renderDetail(c, clauses) {
	var statusHtml = c.status === 'SIGNED'
		? '<strong style="color:#28a745;">서명완료</strong>'
		: '<strong style="color:#856404;">서명대기(DRAFT)</strong>';
	var typeHtml = c.contractType === 'DAILY' ? '일사용료' : '월사용료';

	var clauseHtml = '';
	$.each(clauses||[], function(i, cl) {
		clauseHtml += '<p style="font-size:13px;margin-bottom:10px;"><strong>제' + cl.clauseNo + '조</strong>&nbsp;&nbsp;' + boldHtml(cl.clauseContent||'') + '</p>';
	});

	var sigHtml = '';
	if (c.status === 'SIGNED') {
		sigHtml = '<p style="color:#28a745;font-weight:bold;">&#10003; 서명완료<br/>' + (c.signedAt||'') + '</p>';
	} else if (role === 1) {
		sigHtml = '<canvas id="sigCanvas" width="210" height="90" style="border:1px solid #aaa;touch-action:none;display:block;"></canvas>'
			+ '<div style="margin-top:8px;display:flex;gap:8px;justify-content:center;">'
			+ '<div onclick="clearSig()" style="cursor:pointer;padding:5px 12px;background:#999;color:#fff;border-radius:3px;font-size:13px;">지우기</div>'
			+ '<div onclick="submitSig(' + c.contractIdx + ')" style="cursor:pointer;padding:5px 12px;background:#337ab7;color:#fff;border-radius:3px;font-size:13px;">서명 제출</div>'
			+ '</div>';
	} else {
		sigHtml = '<span style="color:#aaa;">미서명</span>';
	}

	var adminBtns = '';
	if (role === 0) {
		if (c.status !== 'SIGNED') {
			adminBtns += '<div onclick="showForm(currentContract)" style="cursor:pointer;padding:5px 14px;background:#337ab7;color:#fff;border-radius:3px;font-size:13px;display:inline-block;margin-right:6px;">수정</div>';
			adminBtns += '<div onclick="deleteContract(' + c.contractIdx + ')" style="cursor:pointer;padding:5px 14px;background:#dc3545;color:#fff;border-radius:3px;font-size:13px;display:inline-block;">삭제</div>';
		} else {
			adminBtns += '<div onclick="resetToDraft(' + c.contractIdx + ')" style="cursor:pointer;padding:5px 14px;background:#6c757d;color:#fff;border-radius:3px;font-size:13px;display:inline-block;">서명 되돌리기</div>';
		}
	}

	var pdfBtn = c.status === 'SIGNED'
		? '<a href="' + ctx + '/contract/pdf?contractIdx=' + c.contractIdx + '" download="contract_' + c.contractIdx + '.pdf" style="cursor:pointer;padding:5px 14px;background:#28a745;color:#fff;border-radius:3px;font-size:13px;text-decoration:none;display:inline-block;">&#11015; 계약서 다운로드 (PDF)</a>'
		: '<span style="padding:5px 14px;background:#ccc;color:#fff;border-radius:3px;font-size:13px;display:inline-block;">PDF 없음 (서명 후 생성)</span>';

	var html = '<div class="mgr-detail-wrap" style="max-width:740px;">'
		+ '<div class="mgr-btn-row" style="display:flex;justify-content:flex-end;gap:8px;margin-bottom:20px;flex-wrap:wrap;">' + adminBtns + pdfBtn
		+ '</div>'
		+ '<div style="text-align:center;margin-bottom:20px;">'
		+ '<h2 style="font-size:18px;">PDAM 시스템 공급 계약서</h2>'
		+ '<p style="color:#666;margin-top:4px;">계약번호: ' + escHtml(c.contractNo||'') + '</p>'
		+ '</div>'
		+ tbl2([['계약 유형',typeHtml,'상태',statusHtml,false,true],['현장명',c.siteName,'회사명',c.companyName],['모델명',c.modelName,'공급기간',c.supplyDeadline],['사용료',c.dailyFee,'','',true]])
		+ (c.contractType !== 'DAILY'
			? '<p style="font-weight:bold;font-size:14px;margin:16px 0 8px;">※ 계약 조건 - PDAM시스템 1개월 이상 사용조건</p>'
			: '<p style="font-weight:bold;font-size:14px;margin:16px 0 8px;">※ 계약 조건 - PDAM시스템 1개월 미만 사용 조건</p>')
		+ '<h3 style="margin:0 0 8px;font-size:16px;">계약 조항</h3>'
		+ (clauseHtml || '<p style="color:#999;">선택된 조항이 없습니다.</p>')
		+ '<div style="margin-top:16px;font-size:12px;color:#333;line-height:1.8;border-top:1px solid #ddd;padding-top:12px;">'
		+ (c.contractType !== 'DAILY' ? '<p>※ 동일사업장 PDAM시스템 SET 추가시 계약서 및 계약조건은 위 내용과 동일하다.</p>' : '<p>※ PDAM 시스템 SET 추가 시, 계약서 및 계약 조건은 위 내용과 동일합니다.</p>')
		+ '<p style="margin-top:6px;">※ 협조 및 유의 사항</p>'
		+ '<p style="padding-left:12px;">약정된 결제 기간(30일) 이내에 대금이 납부되지 않을 경우, 현장 기기 사용은 가능하나 서버 접속 및 데이터 연동이 제한될 수 있습니다.</p>'
		+ '<p style="padding-left:12px;">원활한 서비스 이용을 위해 기한 내 납부를 부탁드립니다.</p>'
		+ '</div>'
		+ '<div style="margin-top:36px;padding-top:20px;border-top:2px solid #333;">'
		+ '<p style="font-size:14px;font-weight:bold;text-align:center;margin-bottom:2px;">본 계약문서에 의하여 계약을 체결하고 신의에 따라 성실히 계약상의 의무를 이행할 것을 확약하며,</p>'
		+ '<p style="font-size:14px;font-weight:bold;text-align:center;margin-bottom:8px;">이 계약의 증거로서 계약서를 작성하여 당사자가 기명, 날인한 후 각각 1통 씩 보관한다.</p>'
		+ '<p style="font-size:14px;font-weight:bold;text-align:center;margin-bottom:16px;">' + escHtml((c.signedAt||c.createdAt)||'') + '</p>'
		+ '<div class="party-section">'

		+ '<div class="party-card">'
		+ '<div class="party-card-hdr">수 요 자 (을)</div>'
		+ '<table class="party-card-tbl">'
		+ '<tr><th>상&nbsp;&nbsp;호</th><td>' + escHtml(c.reqTradeName||'') + '</td></tr>'
		+ '<tr><th>사업자번호</th><td>' + escHtml(c.reqBusinessNo||'') + '</td></tr>'
		+ '<tr><th>주&nbsp;&nbsp;소</th><td>' + escHtml(c.reqAddress||'') + '</td></tr>'
		+ '<tr><th>T E L</th><td>' + escHtml(c.reqTel||'') + '</td></tr>'
		+ '<tr><th>대&nbsp;&nbsp;표</th><td>' + escHtml(c.reqRepresentative||'') + '</td></tr>'
		+ '<tr><th>대리인</th><td>'
		+ (c.status !== 'SIGNED' && role === 1
		     ? '<input id="siteManagerInput" type="text" value="' + escAttr(c.siteManager||'') + '" placeholder="대리인 이름" style="width:100%;padding:4px 8px;border:1px solid #ccc;border-radius:3px;font-size:13px;box-sizing:border-box;" />'
		     : escHtml(c.siteManager||''))
		+ '</td></tr>'
		+ '<tr><th>서&nbsp;&nbsp;명</th><td style="padding:10px;text-align:center;">' + sigHtml + '</td></tr>'
		+ '</table>'
		+ '</div>'

		+ '<div class="party-card">'
		+ '<div class="party-card-hdr">공 급 자 (갑)</div>'
		+ '<table class="party-card-tbl">'
		+ '<tr><th>상&nbsp;&nbsp;호</th><td>우리기술 주식회사</td></tr>'
		+ '<tr><th>사업자번호</th><td>787-88-01517</td></tr>'
		+ '<tr><th>주&nbsp;&nbsp;소</th><td>대전광역시 대덕구 신탄동로 105 304호(신일동,벤처타운)</td></tr>'
		+ '<tr><th>T E L</th><td>(070) 4334-8000</td></tr>'
		+ '<tr><th>대&nbsp;&nbsp;표</th><td>조상훈</td></tr>'
		+ '<tr><th>직&nbsp;&nbsp;인</th><td style="text-align:center;padding:10px;"><img src="' + ctx + '/new/img/woori_dojang.png" style="max-height:80px;max-width:100%;" /></td></tr>'
		+ '</table>'
		+ '</div>'

		+ '</div>'
		+ '</div></div>';

	$('#rightPanel').html(html);
	if (c.status !== 'SIGNED' && role === 1 && document.getElementById('sigCanvas')) {
		pad = new SignaturePad(document.getElementById('sigCanvas'));
	}
}

/* ───── 등록/수정 폼 ───── */
function showForm(contract) {
	var isNew = !contract;
	var typeVal  = isNew ? 'MONTHLY' : contract.contractType;

	$('#rightPanel').html('<div style="padding:40px;text-align:center;color:#999;">로딩 중...</div>');

	$.getJSON(ctx + '/contractClause/get/list', {contractType: typeVal}, function(allClauses) {
		var selectedIdxs = [];
		if (isNew) {
			$.each(allClauses, function(i, cl) { selectedIdxs.push(cl.clauseIdx); });
		} else if (currentClauses) {
			$.each(currentClauses, function(i, cl) { selectedIdxs.push(cl.clauseIdx); });
		}
		if (isNew) {
			$.get(ctx + '/contract/ajax/nextContractNo', {constructionIdx: constructionIdx}, function(nextNo) {
				renderForm(contract, allClauses, selectedIdxs, nextNo);
			});
		} else {
			renderForm(contract, allClauses, selectedIdxs, null);
		}
	});
}

function renderForm(contract, allClauses, selectedIdxs, nextContractNo) {
	var isNew = !contract;
	var v = function(f) {
		if (isNew) {
			if (f === 'contractNo')  return escAttr(nextContractNo || '');
			if (f === 'siteName')    return escAttr(constructionLocation);
			if (f === 'companyName') return escAttr(constructionName);
			if (f === 'siteManager') return escAttr(constructionManager);
			return '';
		}
		return escAttr(contract[f]||'');
	};
	var typeDaily   = !isNew && contract.contractType === 'DAILY'   ? 'selected' : '';
	var typeMonthly = !isNew && contract.contractType === 'MONTHLY' ? 'selected' : (isNew ? 'selected' : '');

	var clauseHtml = buildClauseCheckboxes(allClauses, selectedIdxs);

	var html = '<div style="max-width:700px;">'
		+ '<div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:20px;">'
		+ '<h3 style="font-size:16px;">' + (isNew ? '계약서 작성' : '계약서 수정') + '</h3>'
		+ '<div style="display:flex;gap:8px;">'
		+ '<div onclick="saveForm(' + (isNew ? 'true' : 'false') + ',' + (isNew ? 0 : contract.contractIdx) + ')" style="cursor:pointer;padding:6px 18px;background:#337ab7;color:#fff;border-radius:3px;font-size:13px;">저장</div>'
		+ '<div onclick="cancelForm()" style="cursor:pointer;padding:6px 18px;background:#999;color:#fff;border-radius:3px;font-size:13px;">취소</div>'
		+ '</div></div>'

		+ section('기본 정보')
		+ row('계약 유형', '<select id="f_contractType" class="Input02" style="width:200px;" onchange="onTypeChange()">'
			+ '<option value="DAILY" ' + typeDaily + '>일사용료</option>'
			+ '<option value="MONTHLY" ' + typeMonthly + '>월사용료</option>'
			+ '</select>')
		+ row('계약번호',  '<input id="f_contractNo"       class="Input02" value="' + v('contractNo') + '" />')
		+ row('현장명',    '<input id="f_siteName"         class="Input02" value="' + v('siteName') + '" />')
		+ row('회사명',    '<input id="f_companyName"      class="Input02" value="' + v('companyName') + '" />')
		+ row('모델명',    '<input id="f_modelName" type="hidden" value="파일항타 관입량 자동측정 시스템(PDAM)" />'
			+ '<span>파일항타 관입량 자동측정 시스템(PDAM)</span>')
		+ row('공급기간',  '<input id="f_supplyDeadline"   class="Input02" value="' + v('supplyDeadline') + '" placeholder="예) 2025.01.01 ~ 2025.12.31" />')
		+ row('사용료',    '<select id="f_dailyFeeSelect" class="Input02" style="width:100%;" onchange="onFeeChange()">'
			+ '<option value="일금 일십육만원정 (₩160,000) VAT별도 / 출장비 별도 1회 ₩250,000">일금 일십육만원정 (₩160,000) VAT별도 / 출장비 별도 1회 ₩250,000</option>'
			+ '<option value="일금 삼백만원정 (₩ 3,000,000) VAT별도">일금 삼백만원정 (₩ 3,000,000) VAT별도</option>'
			+ '<option value="CUSTOM">직접입력</option>'
			+ '</select>'
			+ '<input id="f_dailyFeeCustom" style="display:none;margin-top:8px;width:100%;box-sizing:border-box;" class="Input02" placeholder="사용료를 직접 입력하세요" oninput="onFeeCustomInput()" />'
			+ '<input type="hidden" id="f_dailyFee" value="' + v('dailyFee') + '" />')

		+ '<div class="inputArea02 mb-20" style="position:relative;">'
		+   '<p class="inputTxt02">사업자정보 불러오기</p>'
		+   '<input id="f_companySearch" class="Input02" placeholder="회사명 검색..." oninput="filterCompany()" autocomplete="new-password" />'
		+   '<div id="f_companyDropdown" style="display:none;position:absolute;z-index:200;background:#fff;border:1px solid #ccc;border-radius:4px;max-height:200px;overflow-y:auto;width:100%;box-shadow:0 2px 8px rgba(0,0,0,0.15);top:100%;left:0;"></div>'
		+ '</div>'
		+ section('을(협력사) 정보')
		+ row('상호명',    '<input id="f_reqTradeName"    autocomplete="off" class="Input02" value="' + v('reqTradeName') + '" />')
		+ row('주소',      '<input id="f_reqAddress" autocomplete="off" class="Input02" value="' + v('reqAddress') + '" />')
		+ row('사업자번호','<input id="f_reqBusinessNo"   autocomplete="off" class="Input02" value="' + v('reqBusinessNo') + '" placeholder="000-00-00000" />')
		+ row('전화번호',  '<input id="f_reqTel"          autocomplete="off"  class="Input02" value="' + v('reqTel') + '" />')
		+ '<div class="inputArea02 mb-20 mgr-rep-row" style="display:flex;gap:16px;">'
		+   '<div style="flex:1;"><p class="inputTxt02">대표자</p><input id="f_reqRepresentative" class="Input02" style="width:100%;" value="' + v('reqRepresentative') + '" /></div>'
		+   '<div style="flex:1;"><p class="inputTxt02">대리인</p><input id="f_siteManager" class="Input02" style="width:100%;" value="' + v('siteManager') + '" placeholder="대리인 이름" /></div>'
		+ '</div>'
		+ section('계약 조항 선택')
		+ '<div id="clauseArea" style="max-height:200px;overflow-y:auto;border:1px solid #ddd;padding:10px 14px 10px 10px;background:#fff;border-radius:3px;margin-bottom:16px;box-sizing:border-box;width:100%;">'
		+ clauseHtml + '</div>'
		+ '</div>';

	$('#rightPanel').html(html);
	$('#rightPanel').find('input:not(#f_companySearch)').attr('autocomplete', 'off');
	loadCompanyList();

	var feeVal = $('#f_dailyFee').val();
	if (!feeVal) {
		feeVal = ($('#f_contractType').val() === 'MONTHLY') ? FEE_MONTHLY : FEE_DAILY;
		$('#f_dailyFee').val(feeVal);
	}
	if (feeVal === FEE_DAILY || feeVal === FEE_MONTHLY) {
		$('#f_dailyFeeSelect').val(feeVal);
	} else {
		$('#f_dailyFeeSelect').val('CUSTOM');
		$('#f_dailyFeeCustom').show().val(feeVal);
	}
}

function buildClauseCheckboxes(clauses, selectedIdxs) {
	if (!clauses || clauses.length === 0) return '<p style="color:#999;">등록된 조항이 없습니다.</p>';
	var html = '';
	$.each(clauses, function(i, cl) {
		var checked = selectedIdxs.indexOf(cl.clauseIdx) >= 0 ? 'checked' : '';
		html += '<label style="display:block;margin-bottom:8px;cursor:pointer;">'
			+ '<input type="checkbox" name="clauseIdxList" value="' + cl.clauseIdx + '" ' + checked + ' /> '
			+ '제' + cl.clauseNo + '조</label>';
	});
	return html;
}

/* ── 사업자정보 검색 ── */
var companyList = [];

function loadCompanyList() {
	if (companyList.length > 0) return;
	$.getJSON(ctx + '/company/ajax/list', function(data) {
		companyList = data || [];
	});
}

function filterCompany() {
	var q = ($('#f_companySearch').val() || '').trim().toLowerCase();
	var dd = $('#f_companyDropdown');
	if (!q) { dd.hide(); return; }

	var filtered = companyList.filter(function(c) {
		return c.name.toLowerCase().indexOf(q) >= 0;
	});

	if (filtered.length === 0) {
		dd.html('<div style="padding:10px 12px;color:#999;font-size:13px;">검색 결과 없음</div>').show();
		return;
	}
	var html = '';
	filtered.forEach(function(c) {
		html += '<div onmousedown="selectCompany(' + c.id + ')"'
			+ ' style="padding:9px 12px;cursor:pointer;border-bottom:1px solid #f0f0f0;font-size:13px;"'
			+ ' onmouseover="this.style.background=\'#f0f4ff\'" onmouseout="this.style.background=\'\'">'
			+ escHtml(c.name)
			+ ' <span style="color:#999;font-size:12px;">(' + escHtml(c.businessNo) + ')</span>'
			+ '</div>';
	});
	dd.html(html).show();
}

function selectCompany(id) {
	var c = companyList.find(function(x) { return x.id === id; });
	if (!c) return;
	$('#f_reqTradeName').val(c.name);
	$('#f_reqAddress').val(c.address);
	$('#f_reqBusinessNo').val(c.businessNo);
	$('#f_reqTel').val(c.tel);
	$('#f_reqRepresentative').val(c.representative);
	$('#f_companySearch').val(c.name);
	$('#f_companyDropdown').hide();
}

$(document).on('click', function(e) {
	if (!$(e.target).closest('#f_companySearch, #f_companyDropdown').length) {
		$('#f_companyDropdown').hide();
	}
});

var FEE_DAILY   = '일금 일십육만원정 (₩160,000) VAT별도 / 출장비 별도 1회 ₩250,000';
var FEE_MONTHLY = '일금 삼백만원정 (₩ 3,000,000) VAT별도';

function onFeeChange() {
	var sel = $('#f_dailyFeeSelect').val();
	if (sel === 'CUSTOM') {
		$('#f_dailyFeeCustom').show();
		$('#f_dailyFee').val($('#f_dailyFeeCustom').val());
	} else {
		$('#f_dailyFeeCustom').hide();
		$('#f_dailyFee').val(sel);
	}
}

function onFeeCustomInput() {
	$('#f_dailyFee').val($('#f_dailyFeeCustom').val());
}

function onTypeChange() {
	var type = $('#f_contractType').val();
	$.getJSON(ctx + '/contractClause/get/list', {contractType: type}, function(clauses) {
		var idxs = [];
		$.each(clauses, function(i, cl) { idxs.push(cl.clauseIdx); });
		$('#clauseArea').html(buildClauseCheckboxes(clauses, idxs));
	});
	$('#f_dailyFeeSelect').val(type === 'MONTHLY' ? FEE_MONTHLY : FEE_DAILY);
	onFeeChange();
}

function saveForm(isNew, contractIdx) {
	var clauseIdxList = [];
	$('[name=clauseIdxList]:checked').each(function() { clauseIdxList.push($(this).val()); });

	var data = {
		constructionIdx:  constructionIdx,
		contractType:     $('#f_contractType').val(),
		contractNo:       $('#f_contractNo').val(),
		siteName:         $('#f_siteName').val(),
		companyName:      $('#f_companyName').val(),
		modelName:        $('#f_modelName').val(),
		supplyDeadline:   $('#f_supplyDeadline').val(),
		dailyFee:         $('#f_dailyFee').val(),
		reqTradeName:     $('#f_reqTradeName').val(),
		reqAddress:       $('#f_reqAddress').val(),
		reqBusinessNo:    $('#f_reqBusinessNo').val(),
		reqTel:           $('#f_reqTel').val(),
		reqRepresentative:$('#f_reqRepresentative').val(),
		siteManager:      $('#f_siteManager').val(),
		clauseIdxList:    clauseIdxList
	};
	if (!isNew) data.contractIdx = contractIdx;

	var url = isNew ? ctx + '/contract/ajax/regist' : ctx + '/contract/ajax/update';

	$.ajax({
		type: 'POST', url: url, data: data, traditional: true,
		success: function(result) {
			if (isNew) {
				if (!result.success) {
					alert(result.message || '저장에 실패했습니다.');
					return;
				}
				alert('저장되었습니다.');
				refreshLeft();
				loadDetailById(result.contractIdx);
			} else {
				if (result === false) {
					alert('저장에 실패했습니다. (서명완료된 계약서는 수정할 수 없습니다.)');
					return;
				}
				alert('저장되었습니다.');
				refreshLeft();
				loadDetailById(contractIdx);
			}
		},
		error: function() { alert('저장에 실패했습니다.'); }
	});
}

function loadDetailById(contractIdx) {
	setTimeout(function() {
		highlightItem(contractIdx);
		$.getJSON(ctx + '/contract/ajax/detail', {contractIdx: contractIdx}, function(data) {
			currentContract = data.contract;
			currentClauses  = data.clauses;
			renderDetail(data.contract, data.clauses);
		});
	}, 300);
}

function cancelForm() {
	if (currentContract) {
		renderDetail(currentContract, currentClauses);
		highlightItem(currentContract.contractIdx);
	} else {
		$('#rightPanel').html('<div style="height:100%;display:flex;align-items:center;justify-content:center;color:#bbb;font-size:15px;">좌측에서 계약서를 선택하거나 [+ 계약서 작성]을 클릭하세요.</div>');
	}
}

function resetToDraft(contractIdx) {
	if (!confirm('서명을 되돌리면 서명 이미지와 계약서 PDF가 삭제됩니다.\n계속하시겠습니까?')) return;
	$.post(ctx + '/contract/ajax/resetToDraft', {contractIdx: contractIdx}, function(ok) {
		if (ok) {
			alert('서명이 초기화되었습니다.');
			refreshLeft();
			loadDetailById(contractIdx);
		} else {
			alert('처리에 실패했습니다.');
		}
	});
}

function deleteContract(contractIdx) {
	if (!confirm('삭제하시겠습니까?')) return;
	$.get(ctx + '/contract/delete?contractIdx=' + contractIdx, function() {
		currentContract = null;
		currentClauses  = [];
		refreshLeft();
		$('#rightPanel').html('<div style="height:100%;display:flex;align-items:center;justify-content:center;color:#bbb;font-size:15px;">좌측에서 계약서를 선택하거나 [+ 계약서 작성]을 클릭하세요.</div>');
	});
}

/* ───── 서명 ───── */
function clearSig() { if (pad) pad.clear(); }
function submitSig(contractIdx) {
	if (!pad || pad.isEmpty()) { alert('서명을 입력해주세요.'); return; }
	var siteManager = document.getElementById('siteManagerInput') ? document.getElementById('siteManagerInput').value : '';
	$.post(ctx + '/contract/sign', {contractIdx: contractIdx, signatureData: pad.toDataURL('image/png'), siteManager: siteManager}, function(ok) {
		if (ok) {
			alert('서명이 완료되었습니다.');
			if (role === 1) {
				window.location.href = ctx + '/device/list?constructionIdx=' + constructionIdx;
			} else {
				refreshLeft();
				loadDetailById(contractIdx);
			}
		} else {
			alert('오류가 발생했습니다.');
		}
	});
}

/* ───── 유틸 ───── */
function section(title) {
	return '<div style="font-weight:bold;font-size:14px;border-bottom:2px solid #337ab7;padding-bottom:6px;margin:20px 0 12px;">' + title + '</div>';
}
function row(label, input) {
	return '<div class="inputArea02 mb-20"><p class="inputTxt02">' + label + '</p>' + input + '</div>';
}
function tbl2(rows) {
	var html = '<table class="c-info-tbl" style="width:100%;border-collapse:collapse;table-layout:fixed;margin-bottom:12px;">';
	$.each(rows, function(i, r) {
		var raw = r[5] === true;
		var val = function(v) { return raw ? (v||'') : escHtml(v||''); };
		html += '<tr>';
		if (r[4]) {
			html += '<th style="' + TH + '">' + r[0] + '</th><td style="' + TD + '" colspan="3">' + val(r[1]) + '</td>';
		} else {
			html += '<th style="' + TH + '">' + r[0] + '</th><td style="' + TD + '">' + val(r[1]) + '</td>'
				 + '<th style="' + TH + '">' + r[2] + '</th><td style="' + TD + '">' + val(r[3]) + '</td>';
		}
		html += '</tr>';
	});
	return html + '</table>';
}
var TH  = 'border:1px solid #ccc;padding:8px 12px;background:#f5f5f5;width:15%;font-size:13px;';
var TD  = 'border:1px solid #ccc;padding:8px 12px;font-size:13px;width:35%;';
var PTH = 'border:1px solid #ccc;padding:8px 12px;background:#f5f5f5;width:15%;font-size:13px;';
var PTD = 'border:1px solid #ccc;padding:8px 12px;font-size:13px;width:35%;';
function escHtml(s) { return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;'); }
function escAttr(s) { return String(s).replace(/"/g,'&quot;').replace(/'/g,'&#39;'); }
function boldHtml(s) { return escHtml(s).replace(/\*\*(.+?)\*\*/g, '<b>$1</b>'); }
</script>

<style>
.c-item:hover { background:#f0f4ff; }

/* 당사자 카드 공통 */
.party-section { display: flex; gap: 16px; align-items: stretch; }
.party-card { flex: 1; min-width: 0; display: flex; flex-direction: column; }
.party-card-hdr { background: #f0f0f0; font-weight: bold; font-size: 13px; padding: 6px 10px; border: 1px solid #ccc; border-bottom: none; }
.party-card-tbl { width: 100%; border-collapse: collapse; flex: 1; height: 100%; }
.party-card-tbl th { border: 1px solid #ccc; padding: 7px 10px; background: #f5f5f5; font-size: 12px; white-space: nowrap; width: 30%; vertical-align: middle; }
.party-card-tbl td { border: 1px solid #ccc; padding: 7px 10px; font-size: 12px; word-break: break-all; vertical-align: middle; }

/* 모바일 반응형 */
@media (max-width: 768px) {
	.mgr-wrap {
		flex-direction: column !important;
		height: auto !important;
		overflow: visible !important;
	}
	#leftPanel {
		width: 100% !important;
		min-width: unset !important;
		max-height: 200px;
		border-right: none !important;
		border-bottom: 2px solid #337ab7;
	}
	#rightPanel {
		padding: 12px !important;
	}
	.mgr-detail-wrap {
		max-width: 100% !important;
	}
	.mgr-btn-row {
		justify-content: flex-start !important;
	}
	/* 정보 테이블: 4열 → 2열 스택 */
	.c-info-tbl, .c-info-tbl tbody, .c-info-tbl tr { display: flex; flex-wrap: wrap; width: 100%; }
	.c-info-tbl th { width: 35% !important; box-sizing: border-box; font-size: 12px !important; }
	.c-info-tbl td { width: 65% !important; box-sizing: border-box; font-size: 12px !important; }
	.c-info-tbl td[colspan] { width: 65% !important; }
	/* 당사자 카드: 세로 스택 */
	.party-section { flex-direction: column; }
	.party-card { width: 100%; }
	/* 폼 */
	.Input02 { width: 100% !important; box-sizing: border-box; }
	.mgr-rep-row { flex-direction: column !important; }
	.mgr-rep-row > div { flex: unset !important; width: 100% !important; }
}

@media print {
	.TopContArea, #leftPanel, .left-menu, .logo_top, .mTop { display:none!important; }
	#rightPanel { overflow:visible!important; padding:0!important; }
}
</style>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/tagLib.jsp" %>
<div class="section-right">
	<%@ include file="/WEB-INF/views/common/welcomeMsg.jsp" %>
	<div class="TopContArea">
		<div class="titArea">
			<p class="h1Tit">계약서 작성</p>
		</div>
	</div>

	<div class="table01_content" style="padding:20px;">
		<form method="post" action="${pageContext.request.contextPath}/contract/regist">
			<input type="hidden" name="constructionIdx" value="${constructionIdx}" />

			<div class="sub_title" style="margin-bottom:16px;">기본 정보</div>
			<div class="inputArea02 mb-20">
				<p class="inputTxt02">계약 유형</p>
				<select name="contractType" id="contractType" class="Input02" onchange="loadClauses();autoSelectFee()">
					<option value="DAILY">일사용료 (1개월 미만)</option>
					<option value="MONTHLY">월사용료 (1개월 이상)</option>
				</select>
			</div>
			<div class="inputArea02 mb-20">
				<p class="inputTxt02">계약번호</p>
				<input type="text" name="contractNo" class="Input02" placeholder="예) 2025-001" />
			</div>
			<div class="inputArea02 mb-20">
				<p class="inputTxt02">현장명</p>
				<input type="text" name="siteName" class="Input02" />
			</div>
			<div class="inputArea02 mb-20">
				<p class="inputTxt02">회사명</p>
				<input type="text" name="companyName" class="Input02" />
			</div>
			<div class="inputArea02 mb-20">
				<p class="inputTxt02">모델명</p>
				<input type="text" name="modelName" class="Input02" />
			</div>
			<div class="inputArea02 mb-20">
				<p class="inputTxt02">공급기간</p>
				<input type="text" name="supplyDeadline" class="Input02" placeholder="예) 2025.01.01 ~ 2025.12.31" />
			</div>
			<div class="inputArea02 mb-20">
				<p class="inputTxt02">사용료</p>
				<select id="dailyFeeSelect" class="Input02" onchange="onFeeSelectChange()" style="width:100%;">
					<option value="일금 일십육만원정 (₩160,000) VAT별도 / 출장비 별도 1회 ₩250,000">일금 일십육만원정 (₩160,000) VAT별도 / 출장비 별도 1회 ₩250,000</option>
					<option value="일금 삼백만원정 (₩ 3,000,000) VAT별도">일금 삼백만원정 (₩ 3,000,000) VAT별도</option>
					<option value="CUSTOM">직접입력</option>
				</select>
				<input type="text" id="dailyFeeCustomInput" style="display:none;margin-top:8px;" class="Input02" placeholder="사용료를 직접 입력하세요" oninput="document.getElementById('dailyFeeHidden').value=this.value;" />
				<input type="hidden" name="dailyFee" id="dailyFeeHidden" value="일금 일십육만원정 (₩160,000) VAT별도 / 출장비 별도 1회 ₩250,000" />
			</div>

			<div class="sub_title" style="margin:24px 0 16px;">을(협력사) 정보</div>
			<div class="inputArea02 mb-20">
				<p class="inputTxt02">상호명</p>
				<input type="text" name="reqTradeName" class="Input02" />
			</div>
			<div class="inputArea02 mb-20">
				<p class="inputTxt02">주소</p>
				<input type="text" name="reqAddress" class="Input02" />
			</div>
			<div class="inputArea02 mb-20">
				<p class="inputTxt02">사업자번호</p>
				<input type="text" name="reqBusinessNo" class="Input02" placeholder="000-00-00000" />
			</div>
			<div class="inputArea02 mb-20">
				<p class="inputTxt02">전화번호</p>
				<input type="text" name="reqTel" class="Input02" />
			</div>
			<div class="inputArea02 mb-20">
				<p class="inputTxt02">대표자</p>
				<input type="text" name="reqRepresentative" class="Input02" />
			</div>
			<div class="inputArea02 mb-20">
				<p class="inputTxt02">대리인</p>
				<input type="text" name="siteManager" class="Input02" value="${construction.conManager}" placeholder="대리인 이름" />
			</div>

			<div class="sub_title" style="margin:24px 0 16px;">계약 조항 선택</div>
			<div class="inputArea02 mb-20">
				<div id="clauseList" style="max-height:200px;overflow-y:auto;border:1px solid #ddd;padding:10px;background:#fff;">
					<c:forEach var="clause" items="${dailyClauses}">
						<label style="display:block;margin-bottom:8px;cursor:pointer;">
							<input type="checkbox" name="clauseIdxList" value="${clause.clauseIdx}" />
							제${clause.clauseNo}조
							<c:if test="${not empty clause.clauseTitle}"> ${clause.clauseTitle}</c:if>
						</label>
					</c:forEach>
				</div>
			</div>

<div style="display:flex;gap:10px;margin-top:24px;">
				<div class="popAdd" onclick="this.closest('form').submit();" style="cursor:pointer;">저장</div>
				<a href="${pageContext.request.contextPath}/contract/list" class="popAdd" style="background:#999;text-decoration:none;">취소</a>
			</div>
		</form>
	</div>
</div>

<script>
var FEE_DAILY   = '일금 일십육만원정 (₩160,000) VAT별도 / 출장비 별도 1회 ₩250,000';
var FEE_MONTHLY = '일금 삼백만원정 (₩ 3,000,000) VAT별도';

function onFeeSelectChange() {
	var sel = document.getElementById('dailyFeeSelect');
	var txt = document.getElementById('dailyFeeCustomInput');
	var hid = document.getElementById('dailyFeeHidden');
	if (sel.value === 'CUSTOM') {
		txt.style.display = 'block';
		hid.value = txt.value;
	} else {
		txt.style.display = 'none';
		hid.value = sel.value;
	}
}

function autoSelectFee() {
	var type = document.getElementById('contractType').value;
	var sel  = document.getElementById('dailyFeeSelect');
	if (!sel) return;
	sel.value = (type === 'MONTHLY') ? FEE_MONTHLY : FEE_DAILY;
	onFeeSelectChange();
}

var dailyClauses = [
	<c:forEach var="c" items="${dailyClauses}" varStatus="s">
		{idx: ${c.clauseIdx}, no: ${c.clauseNo}, title: '${c.clauseTitle}'}${!s.last ? ',' : ''}
	</c:forEach>
];
var monthlyClauses = [
	<c:forEach var="c" items="${monthlyClauses}" varStatus="s">
		{idx: ${c.clauseIdx}, no: ${c.clauseNo}, title: '${c.clauseTitle}'}${!s.last ? ',' : ''}
	</c:forEach>
];

function loadClauses() {
	var type = document.getElementById('contractType').value;
	var clauses = (type === 'DAILY') ? dailyClauses : monthlyClauses;
	var html = '';
	clauses.forEach(function(c) {
		html += '<label style="display:block;margin-bottom:8px;cursor:pointer;">'
			+ '<input type="checkbox" name="clauseIdxList" value="' + c.idx + '" /> '
			+ '제' + c.no + '조 ' + c.title
			+ '</label>';
	});
	document.getElementById('clauseList').innerHTML = html || '<p>등록된 조항이 없습니다.</p>';
}
</script>

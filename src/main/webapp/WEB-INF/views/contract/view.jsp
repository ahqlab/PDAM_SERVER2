<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/tagLib.jsp" %>
<div class="section-right">
	<%@ include file="/WEB-INF/views/common/welcomeMsg.jsp" %>
	<div class="TopContArea">
		<div class="titArea">
			<p class="h1Tit">계약서 상세</p>
			<div style="display:flex;gap:8px;">
				<c:if test="${sessionInfo.role == 0}">
					<a href="${pageContext.request.contextPath}/contract/update?contractIdx=${domain.contractIdx}" class="popBtn" style="text-decoration:none;">수정</a>
				</c:if>
				<div class="popBtn" onclick="window.print()" style="cursor:pointer;">인쇄/PDF저장</div>
			</div>
		</div>
	</div>

	<div class="table01_content" style="padding:20px;">
		<div id="contractDoc" class="contract-doc">
			<div class="contract-title">
				<h1>PDAM 시스템 공급 계약서</h1>
				<p>계약번호: ${domain.contractNo}</p>
			</div>

			<table class="contract-info-table">
				<tr>
					<th>계약 유형</th>
					<td><c:choose><c:when test="${domain.contractType == 'DAILY'}">일사용료</c:when><c:otherwise>월사용료</c:otherwise></c:choose></td>
					<th>상태</th>
					<td>
						<c:choose>
							<c:when test="${domain.status == 'SIGNED'}"><strong style="color:#28a745;">서명완료</strong></c:when>
							<c:otherwise><strong style="color:#856404;">서명대기(DRAFT)</strong></c:otherwise>
						</c:choose>
					</td>
				</tr>
				<tr>
					<th>현장명</th>
					<td>${domain.siteName}</td>
					<th>회사명</th>
					<td>${domain.companyName}</td>
				</tr>
				<tr>
					<th>모델명</th>
					<td>${domain.modelName}</td>
					<th>공급기간</th>
					<td>${not empty domain.supplyDeadline ? domain.supplyDeadline : '서명 시 자동 기재'}</td>
				</tr>
				<tr>
					<th>사용료</th>
					<td colspan="3">${domain.dailyFee}</td>
				</tr>
			</table>

			<h3 style="margin:20px 0 8px;">을(협력사) 정보</h3>
			<table class="contract-info-table">
				<tr>
					<th>상호명</th><td>${domain.reqTradeName}</td>
					<th>대표자</th><td>${domain.reqRepresentative}</td>
				</tr>
				<tr>
					<th>주소</th><td colspan="3">${domain.reqAddress}</td>
				</tr>
				<tr>
					<th>사업자번호</th><td>${domain.reqBusinessNo}</td>
					<th>전화번호</th><td>${domain.reqTel}</td>
				</tr>
			</table>

			<h3 style="margin:20px 0 8px;">계약 조항</h3>
			<div class="contract-clauses">
				<c:forEach var="clause" items="${clauses}">
					<div class="clause">
						<h4>제${clause.clauseNo}조</h4>
						<p style="white-space:pre-wrap;">${clause.clauseContent}</p>
					</div>
				</c:forEach>
			</div>

<!-- 서명란 -->
			<div class="signature-section">
				<div class="signature-box">
					<p><strong>공급자</strong></p>
					<p>우리기술(주)</p>
					<div class="sig-area"><span class="sig-placeholder">직인</span></div>
				</div>
				<div class="signature-box">
					<p><strong>협력사</strong></p>
					<p>${domain.reqTradeName}</p>
					<div class="sig-area">
						<c:choose>
							<c:when test="${domain.status == 'SIGNED'}">
								<p style="color:#28a745;font-weight:bold;">&#10003; 서명완료<br/>${domain.signedAt}</p>
							</c:when>
							<c:otherwise>
								<c:if test="${sessionInfo.role == 1}">
									<canvas id="signatureCanvas" width="280" height="110" style="border:1px solid #aaa;touch-action:none;"></canvas>
									<div style="margin-top:8px;display:flex;gap:8px;justify-content:center;">
										<div class="popAdd" onclick="clearSig()" style="cursor:pointer;background:#999;">지우기</div>
										<div class="popAdd" onclick="submitSig()" style="cursor:pointer;">서명 제출</div>
									</div>
								</c:if>
								<c:if test="${sessionInfo.role == 0}">
									<span style="color:#aaa;">미서명</span>
								</c:if>
							</c:otherwise>
						</c:choose>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<c:if test="${sessionInfo.role == 1 and domain.status != 'SIGNED'}">
<script src="https://cdn.jsdelivr.net/npm/signature_pad@4.1.7/dist/signature_pad.umd.min.js"></script>
<script>
var pad = new SignaturePad(document.getElementById('signatureCanvas'));
function clearSig() { pad.clear(); }
function submitSig() {
	if (pad.isEmpty()) { alert('서명을 입력해주세요.'); return; }
	jQuery.ajax({
		type: 'POST',
		url: '${pageContext.request.contextPath}/contract/sign',
		data: { contractIdx: ${domain.contractIdx}, signatureData: pad.toDataURL('image/png') },
		success: function(ok) {
			if (ok) { alert('서명이 완료되었습니다.'); location.reload(); }
			else { alert('오류가 발생했습니다.'); }
		}
	});
}
</script>
</c:if>

<style>
@media print { .TopContArea, canvas, .popBtn, .popAdd { display:none!important; } }
.contract-doc { max-width:800px; margin:0 auto; padding:24px; background:#fff; border:1px solid #ddd; }
.contract-title { text-align:center; margin-bottom:24px; }
.contract-title h1 { font-size:20px; }
.contract-info-table { width:100%; border-collapse:collapse; margin-bottom:12px; }
.contract-info-table th, .contract-info-table td { border:1px solid #ccc; padding:8px 12px; }
.contract-info-table th { background:#f5f5f5; width:100px; }
.contract-clauses .clause { margin-bottom:16px; }
.contract-clauses .clause h4 { font-size:14px; border-bottom:1px solid #eee; padding-bottom:4px; margin-bottom:6px; }
.contract-attach { margin:12px 0; padding:8px 12px; background:#f9f9f9; border-radius:4px; }
.signature-section { display:flex; gap:40px; margin-top:40px; padding-top:20px; border-top:2px solid #333; }
.signature-box { flex:1; text-align:center; }
.sig-area { min-height:120px; border:1px solid #ccc; display:flex; flex-direction:column; align-items:center; justify-content:center; margin-top:8px; padding:8px; }
</style>

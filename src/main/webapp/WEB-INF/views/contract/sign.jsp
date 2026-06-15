<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/tagLib.jsp" %>
<c:set var="TH"  value="border:1px solid #ccc;padding:8px 12px;background:#f5f5f5;width:15%;font-size:13px;" />
<c:set var="TD"  value="border:1px solid #ccc;padding:8px 12px;font-size:13px;width:35%;" />
<c:set var="PTH" value="border:1px solid #ccc;padding:8px 12px;background:#f5f5f5;width:15%;font-size:13px;" />
<c:set var="PTD" value="border:1px solid #ccc;padding:8px 12px;font-size:13px;width:35%;" />
<div class="section-right">
	<%@ include file="/WEB-INF/views/common/welcomeMsg.jsp" %>
	<div class="TopContArea">
		<div class="titArea">
			<p class="h1Tit">계약서 서명</p>
			<c:choose>
				<c:when test="${contract.status == 'SIGNED'}">
					<a href="${pageContext.request.contextPath}/contract/pdf?contractIdx=${contract.contractIdx}" download="contract_${contract.contractIdx}.pdf" class="popBtn" style="cursor:pointer;text-decoration:none;">&#11015; 계약서 다운로드 (PDF)</a>
				</c:when>
				<c:otherwise>
					<span class="popBtn" style="background:#ccc;cursor:default;">PDF 없음</span>
				</c:otherwise>
			</c:choose>
		</div>
	</div>

	<div class="sign-container">

		<!-- 제목 -->
		<div style="text-align:center;margin-bottom:24px;">
			<h2 style="font-size:20px;font-weight:bold;">PDAM 시스템 공급 계약서</h2>
			<p style="color:#666;margin-top:6px;">계약번호: ${contract.contractNo}</p>
		</div>

		<!-- 기본 정보 -->
		<table class="c-info-tbl" style="width:100%;border-collapse:collapse;table-layout:fixed;margin-bottom:12px;">
			<tr>
				<th style="${TH}">계약 유형</th>
				<td style="${TD}">
					<c:choose><c:when test="${contract.contractType=='DAILY'}">일사용료</c:when><c:otherwise>월사용료</c:otherwise></c:choose>
				</td>
				<th style="${TH}">상태</th>
				<td style="${TD}">
					<c:choose>
						<c:when test="${contract.status=='SIGNED'}"><strong style="color:#28a745;">서명완료</strong></c:when>
						<c:otherwise><strong style="color:#856404;">서명대기</strong></c:otherwise>
					</c:choose>
				</td>
			</tr>
			<tr>
				<th style="${TH}">현장명</th><td style="${TD}">${contract.siteName}</td>
				<th style="${TH}">회사명</th><td style="${TD}">${contract.companyName}</td>
			</tr>
			<tr>
				<th style="${TH}">모델명</th><td style="${TD}">${contract.modelName}</td>
				<th style="${TH}">공급기간</th><td style="${TD}">${contract.supplyDeadline}</td>
			</tr>
			<tr>
				<th style="${TH}">사용료</th><td style="${TD}" colspan="3">${contract.dailyFee}</td>
			</tr>
		</table>

		<!-- 계약 조항 -->
		<c:choose>
			<c:when test="${contract.contractType != 'DAILY'}">
				<p style="font-weight:bold;font-size:14px;margin:20px 0 8px;">※ 계약 조건 - PDAM시스템 1개월 이상 사용조건</p>
			</c:when>
			<c:otherwise>
				<p style="font-weight:bold;font-size:14px;margin:20px 0 8px;">※ 계약 조건 - PDAM시스템 1개월 미만 사용 조건</p>
			</c:otherwise>
		</c:choose>
		<h3 style="margin:0 0 10px;font-size:16px;font-weight:bold;">계약 조항</h3>
		<c:choose>
			<c:when test="${empty clauses}">
				<p style="color:#999;">선택된 조항이 없습니다.</p>
			</c:when>
			<c:otherwise>
				<c:if test="${contract.status != 'SIGNED'}">
					<div style="margin-bottom:12px;padding:10px;background:#f0f4ff;border-radius:4px;border:1px solid #c3d4f5;">
						<label style="cursor:pointer;font-size:13px;font-weight:bold;display:flex;align-items:center;">
							<input type="checkbox" id="allAgree" style="width:16px;height:16px;margin-right:8px;" />
							전체 조항에 동의합니다
						</label>
					</div>
				</c:if>
				<c:forEach var="cl" items="${clauses}">
					<c:choose>
						<c:when test="${contract.status != 'SIGNED'}">
							<label style="display:flex;align-items:flex-start;margin-bottom:10px;cursor:pointer;">
								<span class="clauseContent" style="font-size:13px;flex:1;"><strong>제${cl.clauseNo}조</strong>&nbsp;&nbsp;<c:out value="${cl.clauseContent}" /></span>
								<input type="checkbox" class="clauseChk" style="margin-left:12px;margin-top:3px;width:15px;height:15px;flex-shrink:0;" />
							</label>
						</c:when>
						<c:otherwise>
							<p style="font-size:13px;margin-bottom:10px;"><strong>제${cl.clauseNo}조</strong>&nbsp;&nbsp;<span class="clauseContent"><c:out value="${cl.clauseContent}" /></span>&nbsp;<span style="color:#28a745;font-weight:bold;">&#10003;</span></p>
						</c:otherwise>
					</c:choose>
				</c:forEach>
			</c:otherwise>
		</c:choose>
		<div style="margin-top:16px;font-size:12px;color:#333;line-height:1.8;border-top:1px solid #ddd;padding-top:12px;">
			<c:choose>
				<c:when test="${contract.contractType != 'DAILY'}">
					<p>※ 동일사업장 PDAM시스템 SET 추가시 계약서 및 계약조건은 위 내용과 동일하다.</p>
				</c:when>
				<c:otherwise>
					<p>※ PDAM 시스템 SET 추가 시, 계약서 및 계약 조건은 위 내용과 동일합니다.</p>
				</c:otherwise>
			</c:choose>
			<p style="margin-top:6px;">※ 협조 및 유의 사항</p>
			<p style="padding-left:12px;">약정된 결제 기간(30일) 이내에 대금이 납부되지 않을 경우, 현장 기기 사용은 가능하나 서버 접속 및 데이터 연동이 제한될 수 있습니다.</p>
			<p style="padding-left:12px;">원활한 서비스 이용을 위해 기한 내 납부를 부탁드립니다.</p>
		</div>

		<!-- 수요자 / 공급자 -->
		<div style="margin-top:36px;padding-top:20px;border-top:2px solid #333;">
			<p style="font-size:14px;font-weight:bold;text-align:center;margin-bottom:2px;">본 계약문서에 의하여 계약을 체결하고 신의에 따라 성실히 계약상의 의무를 이행할 것을 확약하며,</p>
			<p style="font-size:14px;font-weight:bold;text-align:center;margin-bottom:8px;">이 계약의 증거로서 계약서를 작성하여 당사자가 기명, 날인한 후 각각 1통 씩 보관한다.</p>
			<p style="font-size:14px;font-weight:bold;text-align:center;margin-bottom:16px;">${not empty contract.signedAt ? contract.signedAt : contract.createdAt}</p>

			<div class="party-section">
				<!-- 수요자 (을) -->
				<div class="party-card">
					<div class="party-card-hdr">수 요 자 (을)</div>
					<table class="party-card-tbl">
						<tr><th>상&nbsp;&nbsp;호</th><td>${contract.reqTradeName}</td></tr>
						<tr><th>사업자번호</th><td>${contract.reqBusinessNo}</td></tr>
						<tr><th>주&nbsp;&nbsp;소</th><td>${contract.reqAddress}</td></tr>
						<tr><th>T E L</th><td>${contract.reqTel}</td></tr>
						<tr><th>대&nbsp;&nbsp;표</th><td>${contract.reqRepresentative}</td></tr>
						<tr><th>대리인</th><td>
							<c:choose>
								<c:when test="${contract.status == 'SIGNED'}">${contract.siteManager}</c:when>
								<c:otherwise>
									<input type="text" id="siteManagerInput" value="${contract.siteManager}" placeholder="대리인 이름"
										style="width:100%;padding:4px 8px;border:1px solid #ccc;border-radius:3px;font-size:13px;box-sizing:border-box;" />
								</c:otherwise>
							</c:choose>
						</td></tr>
						<tr><th>서&nbsp;&nbsp;명</th><td style="padding:12px;text-align:center;">
							<c:choose>
								<c:when test="${contract.status == 'SIGNED'}">
									<p style="color:#28a745;font-weight:bold;">&#10003; 서명완료 (${contract.signedAt})</p>
								</c:when>
								<c:otherwise>
									<div id="sigPreviewBox" onclick="openSigModal()" style="min-height:70px;border:1px dashed #bbb;border-radius:4px;text-align:center;line-height:70px;cursor:pointer;color:#aaa;font-size:13px;background:#fafafa;">
										클릭하여 서명하기
									</div>
									<div style="margin-top:8px;">
										<div id="submitBtn" onclick="submitSig()" style="cursor:pointer;padding:5px 14px;background:#337ab7;color:#fff;border-radius:3px;font-size:13px;opacity:0.4;pointer-events:none;display:inline-block;">서명 제출</div>
									</div>
								</c:otherwise>
							</c:choose>
						</td></tr>
					</table>
				</div>
				<!-- 공급자 (갑) -->
				<div class="party-card">
					<div class="party-card-hdr">공 급 자 (갑)</div>
					<table class="party-card-tbl">
						<tr><th>상&nbsp;&nbsp;호</th><td>우리기술 주식회사</td></tr>
						<tr><th>사업자번호</th><td>787-88-01517</td></tr>
						<tr><th>주&nbsp;&nbsp;소</th><td>대전광역시 대덕구 신탄동로 105 304호(신일동,벤처타운)</td></tr>
						<tr><th>T E L</th><td>(070) 4334-8000</td></tr>
						<tr><th>대&nbsp;&nbsp;표</th><td>조상훈</td></tr>
						<tr><th>직&nbsp;&nbsp;인</th><td style="text-align:center;padding:10px;">
							<img src="${pageContext.request.contextPath}/new/img/woori_dojang.png" style="max-height:80px;max-width:100%;" />
						</td></tr>
					</table>
				</div>
			</div><%-- /party-section --%>
		</div>

	</div>
</div>

<script>
document.querySelectorAll('.clauseContent').forEach(function(el) {
	el.innerHTML = el.innerHTML.replace(/\*\*(.+?)\*\*/g, '<b>$1</b>');
});
</script>

<c:if test="${contract.status != 'SIGNED'}">
<!-- 서명 팝업 모달 -->
<div id="sigModal" style="display:none;position:fixed;top:0;left:0;width:100%;height:100%;background:rgba(0,0,0,0.55);z-index:9999;align-items:center;justify-content:center;">
	<div class="sig-modal-inner" style="background:#fff;border-radius:8px;padding:24px;width:580px;max-width:96vw;box-shadow:0 6px 28px rgba(0,0,0,0.25);">
		<p style="font-size:16px;font-weight:bold;margin:0 0 8px;">서명</p>
		<p style="font-size:12px;color:#555;margin:0 0 12px;padding:8px 12px;background:#fff8e1;border-left:3px solid #ffc107;border-radius:3px;">서명란에는 반드시 본인의 성명을 정자(정확한 글씨)로 서명하여 주시기 바랍니다.</p>
		<canvas id="sigModalCanvas" style="border:1px solid #bbb;touch-action:none;display:block;border-radius:4px;cursor:crosshair;background:#fff;"></canvas>
		<div style="margin-top:14px;display:flex;gap:8px;justify-content:flex-end;">
			<div onclick="clearModalSig()" class="sig-btn" style="cursor:pointer;padding:6px 20px;background:#999;color:#fff;border-radius:4px;font-size:13px;">지우기</div>
			<div onclick="closeSigModal()" class="sig-btn" style="cursor:pointer;padding:6px 20px;background:#6c757d;color:#fff;border-radius:4px;font-size:13px;">취소</div>
			<div onclick="confirmSig()" class="sig-btn" style="cursor:pointer;padding:6px 20px;background:#337ab7;color:#fff;border-radius:4px;font-size:13px;">확인</div>
		</div>
	</div>
</div>

<script src="https://cdn.jsdelivr.net/npm/signature_pad@4.1.7/dist/signature_pad.umd.min.js"></script>
<script>
var ctx = '${pageContext.request.contextPath}';
var contractIdx = ${contract.contractIdx};
var constructionIdx = ${contract.constructionIdx};
var signatureDataUrl = null;
var modalPad = null;
var sigCleared = false;

function openSigModal() {
	var modal = document.getElementById('sigModal');
	modal.style.display = 'flex';
	var isMobile = window.innerWidth <= 640;
	var inner = modal.querySelector('.sig-modal-inner');
	var canvas = document.getElementById('sigModalCanvas');
	canvas.width  = inner.clientWidth - (isMobile ? 32 : 48);
	canvas.height = isMobile ? Math.floor(window.innerHeight * 0.5) : 240;
	sigCleared = false;
	if (modalPad) modalPad.off();
	modalPad = new SignaturePad(canvas);
	if (signatureDataUrl) {
		var img = new Image();
		img.onload = function() {
			canvas.getContext('2d').drawImage(img, 0, 0, canvas.width, canvas.height);
		};
		img.src = signatureDataUrl;
	}
}

function clearModalSig() {
	if (modalPad) modalPad.clear();
	sigCleared = true;
}

function closeSigModal() {
	document.getElementById('sigModal').style.display = 'none';
}

function resetSigPreviewBox() {
	var box = document.getElementById('sigPreviewBox');
	box.style.lineHeight = '70px';
	box.style.padding = '';
	box.innerHTML = '클릭하여 서명하기';
}

function confirmSig() {
	if (!modalPad || modalPad.isEmpty()) {
		if (sigCleared) {
			signatureDataUrl = null;
			resetSigPreviewBox();
			closeSigModal();
			updateSubmitBtn();
			return;
		}
		if (!signatureDataUrl) { alert('서명을 입력해주세요.'); return; }
		closeSigModal();
		return;
	}
	signatureDataUrl = modalPad.toDataURL('image/png');
	var box = document.getElementById('sigPreviewBox');
	box.style.lineHeight = 'normal';
	box.style.padding = '8px';
	box.innerHTML = '<img src="' + signatureDataUrl + '" style="max-height:60px;max-width:100%;display:block;margin:auto;cursor:pointer;" onclick="openSigModal()" />';
	closeSigModal();
	updateSubmitBtn();
}

/* ── 체크박스 ── */
function updateSubmitBtn() {
	var all     = document.querySelectorAll('.clauseChk');
	var checked = document.querySelectorAll('.clauseChk:checked');
	var btn = document.getElementById('submitBtn');
	var allOk = (all.length > 0 && all.length === checked.length);
	btn.style.opacity       = allOk ? '1' : '0.4';
	btn.style.pointerEvents = allOk ? 'auto' : 'none';
}

document.getElementById('allAgree').addEventListener('change', function() {
	document.querySelectorAll('.clauseChk').forEach(function(c) { c.checked = this.checked; }.bind(this));
	updateSubmitBtn();
});

document.querySelectorAll('.clauseChk').forEach(function(chk) {
	chk.addEventListener('change', function() {
		var all     = document.querySelectorAll('.clauseChk');
		var checked = document.querySelectorAll('.clauseChk:checked');
		document.getElementById('allAgree').checked = (all.length === checked.length);
		updateSubmitBtn();
	});
});

updateSubmitBtn();

/* ── 서명 제출 ── */
function submitSig() {
	if (!signatureDataUrl) { alert('서명을 입력해주세요.'); return; }
	var siteManager = document.getElementById('siteManagerInput') ? document.getElementById('siteManagerInput').value : '';
	$.post(ctx + '/contract/sign', {
		contractIdx: contractIdx,
		signatureData: signatureDataUrl,
		siteManager: siteManager
	}, function(ok) {
		if (ok) {
			alert('서명이 완료되었습니다. PDF가 다운로드됩니다.');
			var a = document.createElement('a');
			a.href = ctx + '/contract/pdf?contractIdx=' + contractIdx;
			a.download = 'contract_' + contractIdx + '.pdf';
			document.body.appendChild(a);
			a.click();
			document.body.removeChild(a);
			setTimeout(function() {
				window.location.href = ctx + '/device/list?constructionIdx=' + constructionIdx;
			}, 1500);
		} else {
			alert('오류가 발생했습니다.');
		}
	});
}
</script>
</c:if>

<style>
/* ── 컨테이너 ── */
.sign-container { max-width: 780px; padding: 24px; }

/* ── 당사자 카드 ── */
.party-section { display: flex; gap: 16px; align-items: stretch; }
.party-card { flex: 1; min-width: 0; display: flex; flex-direction: column; }
.party-card-hdr { background: #f0f0f0; font-weight: bold; font-size: 13px; padding: 6px 10px; border: 1px solid #ccc; border-bottom: none; }
.party-card-tbl { width: 100%; border-collapse: collapse; flex: 1; height: 100%; }
.party-card-tbl th { border: 1px solid #ccc; padding: 7px 10px; background: #f5f5f5; font-size: 12px; white-space: nowrap; width: 30%; vertical-align: middle; }
.party-card-tbl td { border: 1px solid #ccc; padding: 7px 10px; font-size: 12px; word-break: break-all; vertical-align: middle; }

/* ── 모바일 반응형 (640px 이하) ── */
@media (max-width: 640px) {
	.sign-container { padding: 10px; }
	.sign-container h2 { font-size: 16px !important; }

	/* 기본 정보 테이블 → flex 스택 */
	.c-info-tbl,
	.c-info-tbl tbody,
	.c-info-tbl tr { display: flex; flex-wrap: wrap; width: 100%; }
	.c-info-tbl th { width: 35% !important; box-sizing: border-box; font-size: 12px !important; padding: 5px 7px !important; }
	.c-info-tbl td { width: 65% !important; box-sizing: border-box; font-size: 12px !important; padding: 5px 7px !important; }
	.c-info-tbl td[colspan] { width: 65% !important; }

	/* 당사자 카드 → 세로 스택 */
	.party-section { flex-direction: column; }
	.party-card { width: 100%; }

	/* 계약 조항 체크박스 터치 크기 */
	.clauseChk { width: 18px !important; height: 18px !important; }

	/* 서명 제출 버튼 */
	#submitBtn { width: 100%; text-align: center; padding: 10px !important; font-size: 14px !important; box-sizing: border-box; }

	/* ── 서명 팝업 모달 (모바일 전체화면) ── */
	#sigModal > .sig-modal-inner {
		width: 100% !important;
		max-width: 100% !important;
		height: 100% !important;
		border-radius: 0 !important;
		padding: 16px !important;
		display: flex;
		flex-direction: column;
		box-shadow: none !important;
	}
	#sigModalCanvas { width: 100% !important; }
	.sig-btn { padding: 10px 20px !important; font-size: 14px !important; flex: 1; text-align: center; }
}

/* ── 인쇄 ── */
@media print {
	.TopContArea, .left-menu, .logo_top, .mTop { display: none !important; }
}
</style>

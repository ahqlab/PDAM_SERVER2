<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/tagLib.jsp" %>
<!--왼쪽메뉴-->
<div class="logo_top m_hide">
	<c:choose>
		<c:when test="${sessionInfo.role == 0}">
			<img class="logo" src="${pageContext.request.contextPath}/new/img/logo.png" 
				onclick="location.href='${pageContext.request.contextPath}/group/list';" />
		</c:when>
		<c:when test="${sessionInfo.role == 2}">
			<img class="logo" src="${pageContext.request.contextPath}/new/img/logo.png" 
				onclick="location.href='${pageContext.request.contextPath}/construction/list?groupIdx=${sessionInfo.groupIdx}';" />
		</c:when>
		<c:otherwise>
			<img class="logo" src="${pageContext.request.contextPath}/new/img/logo.png" 
				onclick="location.href='${pageContext.request.contextPath}/device/list?constructionIdx=${sessionInfo.constructionIdx}';" />
		</c:otherwise>
	</c:choose>
	<p class="com_name">Pile Driving Automatic Measurement system</p>
</div>

<div class="mTop pc_hide">
	<img src="${pageContext.request.contextPath}/new/img/nav.png" class="navBtn"/>
	<div class="logo">
		<c:choose>
			<c:when test="${sessionInfo.role == 0}">
				<img class="logo" src="${pageContext.request.contextPath}/new/img/logo.png" 
					onclick="location.href='${pageContext.request.contextPath}/group/list';" />
			</c:when>
			<c:when test="${sessionInfo.role == 2}">
				<img class="logo" src="${pageContext.request.contextPath}/new/img/logo.png" 
					onclick="location.href='${pageContext.request.contextPath}/construction/list?groupIdx=${sessionInfo.groupIdx}';" />
			</c:when>
			<c:otherwise>
				<img class="logo" src="${pageContext.request.contextPath}/new/img/logo.png" 
					onclick="location.href='${pageContext.request.contextPath}/device/list?constructionIdx=${sessionInfo.constructionIdx}';" />
			</c:otherwise>
		</c:choose>	
		<p class="com_name">Pile Driving Automatic Measurement system</p>
	</div>
</div>

<div class="left-menu">

	<img class="m-closeBtn pc_hide" src="${pageContext.request.contextPath}/new/img/close.png" />

	<div class="pc-menu">
		<c:choose>
			<c:when test="${sessionInfo.role == 0}">
				
				<div class="mlist">
					<a href="${pageContext.request.contextPath}/group/list" class="menuActive"><img src="${pageContext.request.contextPath}/new/img/menuIcon01.png" />시공사</a>
				</div>	
				<div class="mlist">
					<a href="${pageContext.request.contextPath}/franchise/list">
						<img src="${pageContext.request.contextPath}/new/img/menuIcon02.png"/>가맹점 & 협약업체
					</a>
				</div>
				<div class="mlist">
					<a href="${pageContext.request.contextPath}/construction/list">
						<img src="${pageContext.request.contextPath}/new/img/menuIcon03.png"/>전체 협력사
					</a>
				</div>
				<div class="mlist">
					<a href="${pageContext.request.contextPath}/treport/list">
						<img src="${pageContext.request.contextPath}/new/img/menuIcon02.png"/>시험성적표관리
					</a>
				</div>
				<!-- 만족도조사 결과보기 -->
				<div class="mlist">
					<a href="${pageContext.request.contextPath}/survey/result">
						<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-bar-chart" viewBox="0 0 16 16" style="margin-right: 10px;">
						  <path d="M4 11H2v3h2zm5-4H7v7h2zm5-5v12h-2V2zm-2-1a1 1 0 0 0-1 1v12a1 1 0 0 0 1 1h2a1 1 0 0 0 1-1V2a1 1 0 0 0-1-1zM6 7a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v7a1 1 0 0 1-1 1H7a1 1 0 0 1-1-1zm-5 4a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v3a1 1 0 0 1-1 1H2a1 1 0 0 1-1-1z"/>
						</svg>만족도조사 결과보기
					</a>
				</div>
				
				<!-- 고객관리 -->
				<div class="mlist">
					<a href="${pageContext.request.contextPath}/customer/list">
						<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-file-earmark-person-fill" viewBox="0 0 16 16" style="margin-right: 10px;">
						  <path d="M9.293 0H4a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h8a2 2 0 0 0 2-2V4.707A1 1 0 0 0 13.707 4L10 .293A1 1 0 0 0 9.293 0M9.5 3.5v-2l3 3h-2a1 1 0 0 1-1-1M11 8a3 3 0 1 1-6 0 3 3 0 0 1 6 0m2 5.755V14a1 1 0 0 1-1 1H4a1 1 0 0 1-1-1v-.245S4 12 8 12s5 1.755 5 1.755"/>
						</svg>고객관리
					</a>
				</div>
				<div class="mlist">
					<a href="${pageContext.request.contextPath}/qr/list">
						<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor"
							class="bi bi-qr-code-scan" viewBox="0 0 16 16" style="margin-right: 10px;">
							<path d="M0 0v6h6V0H0zm5 5H1V1h4v4zM10 0v6h6V0h-6zm5 5h-4V1h4v4zM0 10v6h6v-6H0zm5 5H1v-4h4v4zM11 10h1v1h-1v-1zm-1 1h-1v1h1v-1zm1 1h1v1h-1v-1zm2-1h1v1h-1v-1zm-2 2h1v1h-1v-1zm2 0h1v1h-1v-1zm1-2h1v1h-1v-1zm-3-1h1v1h-1v-1z"/>
							<path d="M8 8h1v1H8V8zm2 0h1v1h-1V8zm1 1h1v1h-1V9zm1 1h1v1h-1v-1zm-4 1h1v1H8v-1zm1 1h1v1H9v-1zm1 1h1v1h-1v-1zm1 1h1v1h-1v-1z"/>
						</svg>QR코드관리
					</a>
				</div>

			<div class="mlist">
				<a href="${pageContext.request.contextPath}/company/list">
					<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-building" viewBox="0 0 16 16" style="margin-right: 10px;">
						<path d="M4 2.5a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5zm3 0a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5zm3.5-.5a.5.5 0 0 0-.5.5v1a.5.5 0 0 0 .5.5h1a.5.5 0 0 0 .5-.5v-1a.5.5 0 0 0-.5-.5zM4 5.5a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5zM7.5 5a.5.5 0 0 0-.5.5v1a.5.5 0 0 0 .5.5h1a.5.5 0 0 0 .5-.5v-1a.5.5 0 0 0-.5-.5zm2.5.5a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5zM4.5 8a.5.5 0 0 0-.5.5v1a.5.5 0 0 0 .5.5h1a.5.5 0 0 0 .5-.5v-1a.5.5 0 0 0-.5-.5zm2.5.5a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5zm3.5-.5a.5.5 0 0 0-.5.5v1a.5.5 0 0 0 .5.5h1a.5.5 0 0 0 .5-.5v-1a.5.5 0 0 0-.5-.5z"/>
						<path d="M2 1a1 1 0 0 1 1-1h10a1 1 0 0 1 1 1v14a1 1 0 0 1-1 1H3a1 1 0 0 1-1-1zm11 0H3v14h3v-2.5a.5.5 0 0 1 .5-.5h3a.5.5 0 0 1 .5.5V15h3z"/>
					</svg>사업자정보 관리
				</a>
			</div>
<%--				<!-- 계약서 관리 -->
				<div class="mlist" style="padding:0;display:block;">
					<a href="javascript:void(0);" onclick="toggleContractNav(this)" style="display:flex;justify-content:space-between;align-items:center;">
						<span style="display:flex;align-items:center;">
							<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-file-earmark-text" viewBox="0 0 16 16" style="margin-right:10px;flex-shrink:0;"><path d="M5.5 7a.5.5 0 0 0 0 1h5a.5.5 0 0 0 0-1zM5 9.5a.5.5 0 0 1 .5-.5h5a.5.5 0 0 1 0 1h-5a.5.5 0 0 1-.5-.5m0 2a.5.5 0 0 1 .5-.5h2a.5.5 0 0 1 0 1h-2a.5.5 0 0 1-.5-.5"/><path d="M9.5 0H4a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h8a2 2 0 0 0 2-2V4.5zm0 1v2A1.5 1.5 0 0 0 11 4.5h2V14a1 1 0 0 1-1 1H4a1 1 0 0 1-1-1V2a1 1 0 0 0 1-1z"/></svg>계약서 관리
						</span>
						<span class="cNavArrow" style="margin-right:10px;font-size:10px;transition:transform 0.2s;display:inline-block;">▼</span>
					</a>
					<div class="cNavSub" style="display:none;border-left:3px solid #337ab7;margin:2px 0 2px 36px;padding:2px 0;">
						<a href="${pageContext.request.contextPath}/contractClause/list" style="display:block;padding:6px 10px 6px 10px;font-size:14px;color:#444;text-decoration:none;">계약조항관리</a>
						<a href="${pageContext.request.contextPath}/contract/list" style="display:block;padding:6px 10px 6px 10px;font-size:14px;color:#444;text-decoration:none;">계약서관리</a>
					</div>
				</div>--%>
				<!-- 고객관리 -->
				<!-- <div class="mlist">
					<a href="${pageContext.request.contextPath}/workingdaily/list">
						<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-clipboard" viewBox="0 0 16 16" style="margin-right: 10px;">
						  <path d="M4 1.5H3a2 2 0 0 0-2 2V14a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V3.5a2 2 0 0 0-2-2h-1v1h1a1 1 0 0 1 1 1V14a1 1 0 0 1-1 1H3a1 1 0 0 1-1-1V3.5a1 1 0 0 1 1-1h1z"/>
						  <path d="M9.5 1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-3a.5.5 0 0 1-.5-.5v-1a.5.5 0 0 1 .5-.5zm-3-1A1.5 1.5 0 0 0 5 1.5v1A1.5 1.5 0 0 0 6.5 4h3A1.5 1.5 0 0 0 11 2.5v-1A1.5 1.5 0 0 0 9.5 0z"/>
						</svg>작업일보
					</a>
				</div> -->
				
			</c:when>
			<c:when test="${sessionInfo.role == 1}">
				<div class="mlist">
					<a href="${pageContext.request.contextPath}/device/list?constructionIdx=${sessionInfo.constructionIdx}" class="menuActive">
						<img src="${pageContext.request.contextPath}/images/menu_icon06.png">기기관리
					</a>
				</div>
			</c:when>
			<c:when test="${sessionInfo.role == 2}">
				<div class="mlist">
					<a href="${pageContext.request.contextPath}/construction/list?groupIdx=${sessionInfo.groupIdx}" class="menuActive">
						<img src="${pageContext.request.contextPath}/images/menu_icon03.png" >협력사
					</a>
				</div>
			</c:when>
		</c:choose>
	</div>
	<div class="logout">
		<a href="${pageContext.request.contextPath}/logout">로그아웃</a>
	</div>
</div>
<script>
(function(){
	var p = window.location.pathname;
	if (p.indexOf('/contract') > -1) {
		var sub = document.querySelector('.cNavSub');
		var arr = document.querySelector('.cNavArrow');
		if (sub) sub.style.display = 'block';
		if (arr) arr.style.transform = 'rotate(180deg)';
	}
})();
if (typeof window.toggleContractNav !== 'function') {
	window.toggleContractNav = function(btn) {
		var sub = btn.parentElement.querySelector('.cNavSub');
		var arr = btn.querySelector('.cNavArrow');
		if (!sub) return;
		var open = sub.style.display !== 'none';
		sub.style.display = open ? 'none' : 'block';
		if (arr) arr.style.transform = open ? '' : 'rotate(180deg)';
	};
}
</script>
<!--//왼쪽메뉴-->

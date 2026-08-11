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
<style>
.left-menu .mlist img {
    width: 20px;
    height: 20px;  
    object-fit: contain;
    margin-right: 10px;
}

.left-menu .mlist svg {
    width: 20px;
    height: 20px;
    margin-right: 10px;
}
</style>
<div class="left-menu">

	<img class="m-closeBtn pc_hide" src="${pageContext.request.contextPath}/new/img/close.png" />

	<div class="pc-menu">
		<c:choose>
			<c:when test="${sessionInfo.role == 0}">

				<div class="mlist">
					<a href="${pageContext.request.contextPath}/group/list">
						<img src="${pageContext.request.contextPath}/images/menu_icon04.png" />시공사
					</a>
				</div>
				<div class="mlist">
					<a href="${pageContext.request.contextPath}/franchise/list">
						<img src="${pageContext.request.contextPath}/images/menu_icon05.png" />가맹점 & 협약업체
					</a>
				</div>
				<div class="mlist">
					<a href="${pageContext.request.contextPath}/construction/list">
						<img src="${pageContext.request.contextPath}/images/menu_icon07.png" />전체 협력사
					</a>
				</div>
				<div class="mlist">
					<a href="${pageContext.request.contextPath}/treport/list">
						<img src="${pageContext.request.contextPath}/images/menu_icon06.png" />시험성적표관리
					</a>
				</div>
				<!-- 만족도조사 결과보기 -->
				<div class="mlist">
					<a href="${pageContext.request.contextPath}/survey/result">
						<img src="${pageContext.request.contextPath}/images/menu_icon11.png" />만족도조사 결과보기
					</a>
				</div>
				<!-- 고객관리 -->
				<div class="mlist">
					<a href="${pageContext.request.contextPath}/customer/list">
						<img src="${pageContext.request.contextPath}/images/menu_icon12.png" />고객관리
					</a>
				</div>
				<div class="mlist">
					<a href="${pageContext.request.contextPath}/qr/list">
						<img src="${pageContext.request.contextPath}/images/menu_icon13.png" />QR코드관리
					</a>
				</div>
	
				<div class="mlist">
					<a href="${pageContext.request.contextPath}/company/list">
						<img src="${pageContext.request.contextPath}/images/menu_icon14.png" />사업자정보 관리
					</a>
				</div>

<%--				<!-- 계약서 관리 -->
				<div class="mlist" style="padding:0;display:block;">
					<a class="menuActive"  href="javascript:void(0);" onclick="toggleContractNav(this)" style="display:flex;justify-content:space-between;align-items:center;">
						<span style="display:flex;align-items:center;">
							<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-file-earmark-text" viewBox="0 0 16 16" style="margin-right:10px;flex-shrink:0;"><path d="M5.5 7a.5.5 0 0 0 0 1h5a.5.5 0 0 0 0-1zM5 9.5a.5.5 0 0 1 .5-.5h5a.5.5 0 0 1 0 1h-5a.5.5 0 0 1-.5-.5m0 2a.5.5 0 0 1 .5-.5h2a.5.5 0 0 1 0 1h-2a.5.5 0 0 1-.5-.5"/><path d="M9.5 0H4a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h8a2 2 0 0 0 2-2V4.5zm0 1v2A1.5 1.5 0 0 0 11 4.5h2V14a1 1 0 0 1-1 1H4a1 1 0 0 1-1-1V2a1 1 0 0 0 1-1z"/></svg>계약서 관리
						</span>
						<span class="cNavArrow" style="margin-right:10px;font-size:10px;transition:transform 0.2s;display:inline-block;transform:rotate(180deg);">▼</span>
					</a>
					<div class="cNavSub" style="display:block;border-left:3px solid #337ab7;margin:2px 0 2px 36px;padding:2px 0;">
						<a href="${pageContext.request.contextPath}/contractClause/list" style="display:block;padding:6px 10px 6px 10px;font-size:14px;color:#444;text-decoration:none;">계약조항관리</a>
						<a href="${pageContext.request.contextPath}/contract/list" style="display:block;padding:6px 10px 6px 10px;font-size:14px;color:#444;text-decoration:none;font-weight:bold;color:#337ab7;">계약서관리</a>
					</div>
				</div>--%>

			</c:when>
			<c:when test="${sessionInfo.role == 1}">
				<div class="mlist">
					<a class="menuActive">
						<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-pen" viewBox="0 0 16 16" style="margin-right:10px;">
							<path d="m13.498.795.149-.149a1.207 1.207 0 1 1 1.707 1.708l-.149.148a1.5 1.5 0 0 1-.059 2.059L4.854 14.854a.5.5 0 0 1-.233.131l-4 1a.5.5 0 0 1-.606-.606l1-4a.5.5 0 0 1 .131-.232l9.642-9.642a.5.5 0 0 0-.642.056L6.854 4.854a.5.5 0 1 1-.708-.708L9.44.854A1.5 1.5 0 0 1 11.5.796a1.5 1.5 0 0 1 1.998-.001zm-.644.766a.5.5 0 0 0-.707 0L1.95 11.756l-.764 3.057 3.057-.764L14.44 3.854a.5.5 0 0 0 0-.708l-1.585-1.585z"/>
						</svg>계약서 서명
					</a>
				</div>
			</c:when>
			<c:when test="${sessionInfo.role == 2}">
				<div class="mlist">
					<a href="${pageContext.request.contextPath}/construction/list?groupIdx=${sessionInfo.groupIdx}" class="menuActive">
						<img src="${pageContext.request.contextPath}/images/menu_icon07.png" >협력사
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

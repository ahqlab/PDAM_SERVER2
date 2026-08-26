<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/tagLib.jsp" %>
<tiles:importAttribute name="navActive" ignore="true" />
<c:set var="currentPath" value="${pageContext.request.requestURI}" />

<div class="logo_top m_hide">
	<c:choose>
		<c:when test="${sessionInfo.role == 0}"><c:set var="homeUrl" value="${pageContext.request.contextPath}/group/list" /></c:when>
		<c:when test="${sessionInfo.role == 2}"><c:set var="homeUrl" value="${pageContext.request.contextPath}/construction/list?groupIdx=${sessionInfo.groupIdx}" /></c:when>
		<c:when test="${sessionInfo.role == 3}"><c:set var="homeUrl" value="${pageContext.request.contextPath}/construction/list?fcIdx=${sessionInfo.fcIdx}" /></c:when>
		<c:otherwise><c:set var="homeUrl" value="${pageContext.request.contextPath}/device/list?constructionIdx=${sessionInfo.constructionIdx}" /></c:otherwise>
	</c:choose>
	<img class="logo" src="${pageContext.request.contextPath}/new/img/logo.png" onclick="location.href='${homeUrl}';" />
	<p class="com_name">Pile Driving Automatic Measurement system</p>
</div>
<div class="mTop pc_hide"><img src="${pageContext.request.contextPath}/new/img/nav.png" class="navBtn"/><div class="logo"><img class="logo" src="${pageContext.request.contextPath}/new/img/logo.png" onclick="location.href='${homeUrl}';" /><p class="com_name">Pile Driving Automatic Measurement system</p></div></div>

<style>
.left-menu .mlist img,.left-menu .mlist svg{width:20px;height:20px;object-fit:contain;margin-right:10px}
.left-menu .mlist > a.menuActive{background:#ebf7fa !important;color:#191919 !important}
</style>
<div class="left-menu">
	<img class="m-closeBtn pc_hide" src="${pageContext.request.contextPath}/new/img/close.png" />
	<div class="pc-menu">
		<c:choose>
			<c:when test="${sessionInfo.role == 0}">
				<div class="mlist"><a href="${pageContext.request.contextPath}/group/list" class="${fn:contains(currentPath, '/group/') ? 'menuActive' : ''}"><img src="${pageContext.request.contextPath}/images/menu_icon04.png" />시공사</a></div>
				<div class="mlist"><a href="${pageContext.request.contextPath}/franchise/list" class="${fn:contains(currentPath, '/franchise/') ? 'menuActive' : ''}"><img src="${pageContext.request.contextPath}/images/menu_icon05.png" />가맹점 &amp; 협약업체</a></div>
				<div class="mlist"><a href="${pageContext.request.contextPath}/construction/list" class="${fn:contains(currentPath, '/construction/') ? 'menuActive' : ''}"><img src="${pageContext.request.contextPath}/images/menu_icon07.png" />전체 협력사</a></div>
				<div class="mlist"><a href="${pageContext.request.contextPath}/vimmng/list" class="${fn:contains(currentPath, '/vimmng/') ? 'menuActive' : ''}"><img src="${pageContext.request.contextPath}/images/menu_icon05.png" />빔파트너스 협력사</a></div>
				<c:if test="${not empty param.constructionIdx}">
					<div class="mlist"><a href="${pageContext.request.contextPath}/device/list?constructionIdx=${param.constructionIdx}" class="${(fn:contains(currentPath, '/device/') or fn:contains(currentPath, '/simple/report/') or fn:contains(currentPath, '/report/')) ? 'menuActive' : ''}"><img src="${pageContext.request.contextPath}/images/menu_icon10.png" />기기관리</a></div>
					<div class="mlist"><a href="${pageContext.request.contextPath}/fileinventory/list?constructionIdx=${param.constructionIdx}" class="${fn:contains(currentPath, '/fileinventory/') ? 'menuActive' : ''}"><img src="${pageContext.request.contextPath}/images/menu_icon08.png" />파일반입 및 수정</a></div>
					<div class="mlist"><a href="${pageContext.request.contextPath}/gpsfile/list?constructionIdx=${param.constructionIdx}" class="${fn:contains(currentPath, '/gpsfile/') ? 'menuActive' : ''}"><img src="${pageContext.request.contextPath}/images/menu_icon09.png" />GPS파일관리</a></div>
				</c:if>
				<div class="mlist"><a href="${pageContext.request.contextPath}/treport/list" class="${fn:contains(currentPath, '/treport/') ? 'menuActive' : ''}"><img src="${pageContext.request.contextPath}/images/menu_icon06.png" />시험성적표관리</a></div>
				<div class="mlist"><a href="${pageContext.request.contextPath}/survey/result" class="${fn:contains(currentPath, '/survey/') ? 'menuActive' : ''}"><img src="${pageContext.request.contextPath}/images/menu_icon11.png" />만족도조사 결과보기</a></div>
				<div class="mlist"><a href="${pageContext.request.contextPath}/customer/list" class="${fn:contains(currentPath, '/customer/') ? 'menuActive' : ''}"><img src="${pageContext.request.contextPath}/images/menu_icon12.png" />고객관리</a></div>
				<div class="mlist"><a href="${pageContext.request.contextPath}/qr/list" class="${fn:contains(currentPath, '/qr/') ? 'menuActive' : ''}"><img src="${pageContext.request.contextPath}/images/menu_icon13.png" />QR코드관리</a></div>
				<div class="mlist"><a href="${pageContext.request.contextPath}/company/list" class="${fn:contains(currentPath, '/company/') ? 'menuActive' : ''}"><img src="${pageContext.request.contextPath}/images/menu_icon14.png" />사업자정보 관리</a></div>
				<c:if test="${sessionScope.isSystemAdmin}"><div class="mlist"><a href="${pageContext.request.contextPath}/admin/board/list" class="${fn:contains(currentPath, '/admin/board/') ? 'menuActive' : ''}"><img src="${pageContext.request.contextPath}/images/menu_icon15.png" />관리자 전용 게시판</a></div></c:if>
			</c:when>
			<c:when test="${sessionInfo.role == 1}">
				<div class="mlist"><a href="${pageContext.request.contextPath}/device/list?constructionIdx=${sessionInfo.constructionIdx}" class="${(fn:contains(currentPath, '/device/') or fn:contains(currentPath, '/simple/report/') or fn:contains(currentPath, '/report/')) ? 'menuActive' : ''}"><img src="${pageContext.request.contextPath}/images/menu_icon10.png" />기기관리</a></div>
				<c:if test="${(sessionScope.settingRequired and (sessionScope.isHiddenManager ? sessionScope.constructionSetting.useAdminFileMenu : sessionScope.constructionSetting.useGuestFileMenu)) or (not sessionScope.settingRequired and not ((sessionInfo.constructionIdx == 1003 and sessionInfo.hiddenManager == false) or (sessionInfo.constructionIdx == 988 and sessionInfo.hiddenManager == false)))}"><div class="mlist"><a href="${pageContext.request.contextPath}/fileinventory/list?constructionIdx=${sessionInfo.constructionIdx}" class="${fn:contains(currentPath, '/fileinventory/') ? 'menuActive' : ''}"><img src="${pageContext.request.contextPath}/images/menu_icon08.png" />파일반입 및 수정</a></div></c:if>
				<c:if test="${sessionScope.isHiddenManager and sessionScope.settingRequired}"><div class="mlist"><a href="${pageContext.request.contextPath}/construction/settings?constructionIdx=${sessionInfo.constructionIdx}" class="${fn:contains(currentPath, '/construction/settings') ? 'menuActive' : ''}"><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-gear" viewBox="0 0 16 16" style="margin-right:10px;"><path d="M8 4.754a3.246 3.246 0 1 0 0 6.492 3.246 3.246 0 0 0 0-6.492zM5.754 8a2.246 2.246 0 1 1 4.492 0 2.246 2.246 0 0 1-4.492 0z"/><path d="M9.796 1.343c-.527-1.79-3.065-1.79-3.592 0l-.094.319a.873.873 0 0 1-1.255.52l-.292-.16c-1.64-.892-3.433.902-2.54 2.541l.159.292a.873.873 0 0 1-.52 1.255l-.319.094c-1.79.527-1.79 3.065 0 3.592l.319.094a.873.873 0 0 1 .52 1.255l-.16.292c-.892 1.64.901 3.434 2.541 2.54l.292-.159a.873.873 0 0 1 1.255.52l.094.319c.527 1.79 3.065 1.79 3.592 0l.094-.319a.873.873 0 0 1 1.255-.52l.292.16c1.64.893 3.434-.902 2.54-2.541l-.159-.292a.873.873 0 0 1 .52-1.255l.319-.094c1.79-.527 1.79-3.065 0-3.592l-.319-.094a.873.873 0 0 1-.52-1.255l.16-.292c.893-1.64-.902-3.433-2.541-2.54l-.292.159a.873.873 0 0 1-1.255-.52l-.094-.319zm-2.633.283c.246-.835 1.428-.835 1.674 0l.094.319a1.873 1.873 0 0 0 2.693 1.115l.291-.16c.764-.415 1.6.42 1.184 1.185l-.159.292a1.873 1.873 0 0 0 1.116 2.692l.318.094c.835.246.835 1.428 0 1.674l-.319.094a1.873.873 0 0 0-1.115 2.693l.16.291c.415.764-.42 1.6-1.185 1.184l-.291-.159a1.873.873 0 0 0-2.693 1.116l-.094.318c-.246.835-1.428.835-1.674 0l-.094-.319a1.873.873 0 0 0-2.692-1.115l-.292.16c-.764.415-1.6-.42-1.184-1.185l.159-.291A1.873.873 0 0 0 1.945 8.93l-.319-.094c-.835-.246-.835-1.428 0-1.674l.319-.094A1.873.873 0 0 0 3.06 4.474l-.16-.292c-.415-.764.42-1.6 1.185-1.184l.292.159a1.873.873 0 0 0 2.692-1.115l.094-.319z"/></svg>설정</a></div></c:if>
			</c:when>
			<c:when test="${sessionInfo.role == 2}">
				<div class="mlist"><a href="${pageContext.request.contextPath}/construction/list?groupIdx=${sessionInfo.groupIdx}" class="${fn:contains(currentPath, '/construction/') ? 'menuActive' : ''}"><img src="${pageContext.request.contextPath}/images/menu_icon07.png" />협력사</a></div>
				<c:if test="${not empty param.constructionIdx}">
					<div class="mlist"><a href="${pageContext.request.contextPath}/device/list?constructionIdx=${param.constructionIdx}" class="${(navActive eq 'device' or fn:contains(currentPath, '/device/') or fn:contains(currentPath, '/simple/report/') or fn:contains(currentPath, '/report/')) ? 'menuActive' : ''}"><img src="${pageContext.request.contextPath}/images/menu_icon10.png" />기기관리</a></div>
					<div class="mlist"><a href="${pageContext.request.contextPath}/fileinventory/list?constructionIdx=${param.constructionIdx}" class="${navActive eq 'fileinventory' ? 'menuActive' : ''}"><img src="${pageContext.request.contextPath}/images/menu_icon08.png" />파일반입 및 수정</a></div>
				</c:if>
			</c:when>
			<c:when test="${sessionInfo.role == 3}">
				<div class="mlist"><a href="${pageContext.request.contextPath}/construction/list?fcIdx=${sessionInfo.fcIdx}" class="${fn:contains(currentPath, '/construction/') ? 'menuActive' : ''}"><img src="${pageContext.request.contextPath}/images/menu_icon07.png" />협력사</a></div>
				<c:if test="${not empty param.constructionIdx}">
					<div class="mlist"><a href="${pageContext.request.contextPath}/device/list?constructionIdx=${param.constructionIdx}" class="${(navActive eq 'device' or fn:contains(currentPath, '/device/') or fn:contains(currentPath, '/simple/report/') or fn:contains(currentPath, '/report/')) ? 'menuActive' : ''}"><img src="${pageContext.request.contextPath}/images/menu_icon10.png" />기기관리</a></div>
					<div class="mlist"><a href="${pageContext.request.contextPath}/fileinventory/list?constructionIdx=${param.constructionIdx}" class="${navActive eq 'fileinventory' ? 'menuActive' : ''}"><img src="${pageContext.request.contextPath}/images/menu_icon08.png" />파일반입 및 수정</a></div>
				</c:if>
			</c:when>
			<c:otherwise>
				<div class="mlist"><a href="${pageContext.request.contextPath}/construction/list" class="${fn:contains(currentPath, '/construction/') ? 'menuActive' : ''}"><img src="${pageContext.request.contextPath}/images/menu_icon07.png" />협력사</a></div>
				<c:if test="${not empty param.constructionIdx}"><div class="mlist"><a href="${pageContext.request.contextPath}/device/list?constructionIdx=${param.constructionIdx}" class="${(fn:contains(currentPath, '/device/') or fn:contains(currentPath, '/simple/report/') or fn:contains(currentPath, '/report/')) ? 'menuActive' : ''}"><img src="${pageContext.request.contextPath}/images/menu_icon10.png" />기기관리</a></div><div class="mlist"><a href="${pageContext.request.contextPath}/gpsfile/list?constructionIdx=${param.constructionIdx}" class="${fn:contains(currentPath, '/gpsfile/') ? 'menuActive' : ''}"><img src="${pageContext.request.contextPath}/images/menu_icon09.png" />GPS파일관리</a></div><div class="mlist"><a href="${pageContext.request.contextPath}/pqpm/list?constructionIdx=${param.constructionIdx}" class="${fn:contains(currentPath, '/pqpm/') ? 'menuActive' : ''}"><img src="${pageContext.request.contextPath}/images/menu_icon08.png" />파일수량 관리계획</a></div></c:if>
			</c:otherwise>
		</c:choose>

		<c:forEach var="board" items="${globalBoardList}">
			<c:if test="${board.useYn eq 'Y'}">
				
				<c:set var="isSysAdmin" value="${sessionScope.isSystemAdmin}" />
				<c:set var="userRoleStr" value="${sessionInfo.role}" />
				<c:set var="hasAccess" value="false" />
				
				<c:choose>
					<c:when test="${fn:contains(board.auth, 'ALL')}">
						<c:set var="hasAccess" value="true" />
					</c:when>
					<c:when test="${isSysAdmin and (fn:contains(board.auth, 'SYS_ADMIN') or fn:contains(board.auth, '0'))}">
						<c:set var="hasAccess" value="true" />
					</c:when>
					<c:when test="${not isSysAdmin and userRoleStr eq '0' and fn:contains(board.auth, '0')}">
						<c:set var="hasAccess" value="true" />
					</c:when>
					<c:when test="${userRoleStr ne '0' and not empty userRoleStr and fn:contains(board.auth, userRoleStr)}">
						<c:set var="hasAccess" value="true" />
					</c:when>
				</c:choose>
				
				<c:if test="${hasAccess}">
					<div class="mlist">
						<a href="${pageContext.request.contextPath}/board/list?boardId=${board.id}" class="${(fn:contains(currentPath, '/board/list') and param.boardId eq board.id) ? 'menuActive' : ''}">
							<img src="${pageContext.request.contextPath}/images/menu_icon15.png" />${board.boardName}
						</a>
					</div>
				</c:if>
				
			</c:if>
		</c:forEach>

	</div>
	<div class="logout"><a href="${pageContext.request.contextPath}/logout">로그아웃</a></div>
</div>

<script>
document.addEventListener("DOMContentLoaded", function () {
	var currentPath = window.location.pathname;
	var currentSearch = window.location.search;
	
	var menuLinks = document.querySelectorAll('.left-menu .mlist > a');
	
	function getQueryParam(queryString, paramName) {
		var match = queryString.match(new RegExp('[?&]' + paramName + '=([^&]+)'));
		return match ? match[1] : null;
	}

	for (var i = 0; i < menuLinks.length; i++) {
		var linkPath = menuLinks[i].pathname;
		var linkSearch = menuLinks[i].search;
		
		if (linkPath && linkPath.indexOf('/board/list') !== -1 && linkPath.indexOf('/admin/board') === -1) {
			var currentBoardId = getQueryParam(currentSearch, 'boardId');
			var linkBoardId = getQueryParam(linkSearch, 'boardId');
			
			if (currentPath === linkPath && currentBoardId !== null && currentBoardId === linkBoardId) {
				menuLinks[i].classList.add('menuActive');
			} else {
				menuLinks[i].classList.remove('menuActive');
			}
			continue;
		}

		if (linkPath && (currentPath === linkPath || ((currentPath.indexOf('/simple/report/') !== -1 || currentPath.indexOf('/report/') !== -1) && linkPath.indexOf('/device/list') !== -1))) {
			menuLinks[i].classList.add('menuActive');
		}
	}
});
</script>
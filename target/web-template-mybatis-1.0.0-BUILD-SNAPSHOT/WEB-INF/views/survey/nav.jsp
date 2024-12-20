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
					<a href="${pageContext.request.contextPath}/group/list"><img src="${pageContext.request.contextPath}/new/img/menuIcon01.png" />시공사</a>
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
					<a href="${pageContext.request.contextPath}/survey/result"  class="menuActive">
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
<!--//왼쪽메뉴-->
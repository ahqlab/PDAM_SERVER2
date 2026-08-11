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
					<a href="${pageContext.request.contextPath}/group/list" >
					<img src="${pageContext.request.contextPath}/images/menu_icon04.png" />시공사</a>
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
					<a href="${pageContext.request.contextPath}/treport/list" >
						<img src="${pageContext.request.contextPath}/images/menu_icon06.png"  class="menuActive" />시험성적표관리
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
				
				<!-- 고객관리 -->
				<div class="mlist">
					<a href="${pageContext.request.contextPath}/workingdaily/list" class="menuActive">
						<img src="${pageContext.request.contextPath}/images/menu_icon12.png" />작업일보
					</a>
				</div>
				
				
			</c:when>
			<c:when test="${sessionInfo.role == 1}">
				
			</c:when>
			<c:when test="${sessionInfo.role == 2}">
				
			</c:when>
		</c:choose>
	</div>
	<div class="logout">
		<a href="${pageContext.request.contextPath}/logout">로그아웃</a>
	</div>
</div>
<!--//왼쪽메뉴-->
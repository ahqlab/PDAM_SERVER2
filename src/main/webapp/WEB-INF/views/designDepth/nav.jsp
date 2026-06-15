<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/tagLib.jsp" %>
<div class="left_menu">
	<div class="menu_logo">
		<c:choose>
			<c:when test="${sessionInfo.role == 0}">
				<a href="${pageContext.request.contextPath}/group/list"><img src="${pageContext.request.contextPath}/images/logo.png" class="로고"></a>
			</c:when>
			<c:when test="${sessionInfo.role == 1}">
				<a href="${pageContext.request.contextPath}/device/list?constructionIdx=${sessionInfo.constructionIdx}"><img src="${pageContext.request.contextPath}/images/logo.png" class="로고"></a>
			</c:when>
			<c:when test="${sessionInfo.role == 2}">
				<a href="${pageContext.request.contextPath}/device/list?constructionIdx=${param.constructionIdx}"><img src="${pageContext.request.contextPath}/images/logo.png" class="로고"></a>
			</c:when>
			<%-- <c:otherwise>
				<a href="${pageContext.request.contextPath}/device/list?constructionIdx=${sessionInfo.constructionIdx}"><img src="${pageContext.request.contextPath}/images/logo.png" class="로고"></a>
			</c:otherwise> --%>
		</c:choose>
	</div>
	<ul id="gnb">
		<c:choose>
			<c:when test="${sessionInfo.role == 0}">
			<li class='sub-menu'>
				<a href="${pageContext.request.contextPath}/group/list">
					<img src="${pageContext.request.contextPath}/images/menu_icon01.png" class="menu_icon">시공사
				</a>
				<a href="${pageContext.request.contextPath}/construction/list">
					<img src="${pageContext.request.contextPath}/images/menu_icon01.png" class="menu_icon">전체 협력사
				</a>
				<a href="#" >
					<img src="${pageContext.request.contextPath}/images/menu_icon02.png" class="menu_icon">기기관리
				</a>	
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
			</li>
			</c:when>
			<c:when test="${sessionInfo.role == 1}">
				<li class='sub-menu'>
					<a href="${pageContext.request.contextPath}/device/list?constructionIdx=${sessionInfo.constructionIdx}">
						<img src="${pageContext.request.contextPath}/images/menu_icon02.png" class="menu_icon">기기관리
					</a>
					<a href="${pageContext.request.contextPath}/fileinventory/list?constructionIdx=${sessionInfo.constructionIdx}">
						<img src="${pageContext.request.contextPath}/images/menu_icon01.png" class="menu_icon">파일반입 및 수정
					</a>
					<%-- <a href="${pageContext.request.contextPath}/erpAdmin/list?constructionIdx=${sessionInfo.constructionIdx}">
						<img src="${pageContext.request.contextPath}/images/menu_icon01.png" class="menu_icon">관리자현황
					</a> --%>
					<%-- <a href="#">
						<img src="${pageContext.request.contextPath}/images/menu_icon01.png" class="menu_icon">투입인력
					</a>
					<a href="#">
						<img src="${pageContext.request.contextPath}/images/menu_icon01.png" class="menu_icon">주유현황
					</a> --%>
				</li>
			</c:when>
			<c:when test="${sessionInfo.role == 2}">
				<li class='sub-menu'>
					<a href="${pageContext.request.contextPath}/construction/list?groupIdx=${sessionInfo.groupIdx}">
						<img src="${pageContext.request.contextPath}/images/menu_icon02.png" class="menu_icon">협력사
					</a>
					<a href="#" ><!-- 문제있음 -->
						<img src="${pageContext.request.contextPath}/images/menu_icon02.png" class="menu_icon">기기관리
					</a>
					<%-- <a href=""> --%><!-- 문제있음 -->
					<a href="${pageContext.request.contextPath}/fileinventory/list?constructionIdx=${param.constructionIdx}">
						<img src="${pageContext.request.contextPath}/images/menu_icon01.png" class="menu_icon">파일반입 및 수정
					</a>
					<%-- <a href="${pageContext.request.contextPath}/erpAdmin/list?constructionIdx=${sessionInfo.constructionIdx}"><!-- 문제있음 -->
						<img src="${pageContext.request.contextPath}/images/menu_icon01.png" class="menu_icon">관리자현황
					</a> --%>
					<%-- <a href="#">
						<img src="${pageContext.request.contextPath}/images/menu_icon01.png" class="menu_icon">투입인력
					</a>
					<a href="#">
						<img src="${pageContext.request.contextPath}/images/menu_icon01.png" class="menu_icon">주유현황
					</a>
					<a href="${pageContext.request.contextPath}/designDepth/list?deviceIdx=${param.deviceIdx}" class="on">
						<img src="${pageContext.request.contextPath}/images/menu_icon02.png" class="menu_icon">설계심도
					</a> --%>
				</li>
			</c:when>
		</c:choose>
	</ul>
</div>
<script>
$('.sub-menu ul').hide();
$(".sub-menu a").click(function () {
  $(this).parent(".sub-menu").children("ul").slideToggle("100");
  $(this).find(".right").toggleClass("fa-caret-up fa-caret-down");
});
</script>
<script type="text/javascript">
    $(document).ready(function() {
        $(".menu2").click(function() {
            $("#m_nav2").animate({
                "left": "0%"
            }, 500);
        });
        $(".close").click(function() {
            $("#m_nav2").animate({
                "left": "-150%"
            }, 500);
        });
    });
</script>
<div class="top">
	<!--모바일 메뉴 -->
	<div class="menu2">
		  <%-- <img src="${pageContext.request.contextPath}/images/gnb.png" class="home_gnb"> --%>
	</div>
	<div id="m_nav2" style="right: -150%;">
	<div class="m_nav_logo">
	       <img src="${pageContext.request.contextPath}/images/close2.png" alt="" class="close" style="width:15px;margin-right:20px;opacity:1;">
	</div>
	    <!-- <div class="sp10"></div>
	    <div class="sp10"></div>
	    <div class="sp10"></div>
	    <ul class="m_nav2_ul">
	        <li><a href="./list01_white.php" class="scroll">시공사등록</a></li>
	        <li><a href="./list01.php" class="scroll">시공사리스트</a></li>
	        <li><a href="./list02_white.php" class="scroll">기기등록</a></li>
	        <li><a href="./list02.php" class="scroll">기기등록리스트</a></li>
	        <li><a href="./list03.php" class="scroll">기록표리스트</a></li>
	    </ul> -->
	</div>				
	<!--紐⑤컮�씪 �꽕鍮� end-->
	<p class="logout">
		<a href="${pageContext.request.contextPath}/logout">로그아웃</a>
	</p>
</div>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/tagLib.jsp" %>
<!--왼쪽메뉴-->
		<div class="logo_top m_hide">
			
			
			<c:choose>
			<c:when test="${sessionInfo.role == 0}">
				<img class="logo" src="${pageContext.request.contextPath}/new/img/logo.png" onclick="location.href='${pageContext.request.contextPath}/group/list';" />
			</c:when>
			<c:when test="${sessionInfo.role == 1}">
				<img class="logo" src="${pageContext.request.contextPath}/new/img/logo.png" onclick="location.href='${pageContext.request.contextPath}/device/list?constructionIdx=${sessionInfo.constructionIdx}';" />
			</c:when>
			<c:when test="${sessionInfo.role == 2}">
				<img class="logo" src="${pageContext.request.contextPath}/new/img/logo.png" onclick="location.href='${pageContext.request.contextPath}/device/list?constructionIdx=${param.constructionIdx}';" />
			</c:when>
			<c:when test="${sessionInfo.role == 3}">
				<img class="logo" src="${pageContext.request.contextPath}/new/img/logo.png" onclick="location.href='${pageContext.request.contextPath}/construction/list?fcIdx=${sessionInfo.fcIdx}';" />
			</c:when>
			<c:otherwise>
				<img class="logo" src="${pageContext.request.contextPath}/new/img/logo.png" onclick="location.href='${pageContext.request.contextPath}/device/list?constructionIdx=${sessionInfo.constructionIdx}';" />
			</c:otherwise>
			</c:choose>
			
			
			
			<p class="com_name">Pile Driving Automatic Measurement system</p>
		</div>

		<div class="mTop pc_hide">
			<img src="${pageContext.request.contextPath}/new/img/nav.png" class="navBtn"/>
			<div class="logo">
				<c:choose>
				<c:when test="${sessionInfo.role == 0}">
					<img class="logo" src="${pageContext.request.contextPath}/new/img/logo.png" onclick="location.href='${pageContext.request.contextPath}/group/list';" />
				</c:when>
				<c:when test="${sessionInfo.role == 1}">
					<img class="logo" src="${pageContext.request.contextPath}/new/img/logo.png" onclick="location.href='${pageContext.request.contextPath}/device/list?constructionIdx=${sessionInfo.constructionIdx}';" />
				</c:when>
				<c:when test="${sessionInfo.role == 2}">
					<img class="logo" src="${pageContext.request.contextPath}/new/img/logo.png" onclick="location.href='${pageContext.request.contextPath}/device/list?constructionIdx=${param.constructionIdx}';" />
				</c:when>
				<c:when test="${sessionInfo.role == 3}">
					<img class="logo" src="${pageContext.request.contextPath}/new/img/logo.png" onclick="location.href='${pageContext.request.contextPath}/construction/list?fcIdx=${sessionInfo.fcIdx}';" />
				</c:when>
				<c:otherwise>
					<img class="logo" src="${pageContext.request.contextPath}/new/img/logo.png" onclick="location.href='${pageContext.request.contextPath}/device/list?constructionIdx=${sessionInfo.constructionIdx}';" />
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

			<img class="m-closeBtn pc_hide" src="${pageContext.request.contextPath}/new/img/close.png">
			<!--  -->
			<c:choose>
				<c:when test="${sessionInfo.role == 0}">
				<div class="pc-menu">
					<div class="mlist">
						<a href="${pageContext.request.contextPath}/group/list">
							<img src="${pageContext.request.contextPath}/images/menu_icon04.png">시공사
						</a>
					</div>
					<div class="mlist">
						<a href="${pageContext.request.contextPath}/franchise/list">
							<img src="${pageContext.request.contextPath}/images/menu_icon05.png">가맹점 & 협약업체
						</a>
					</div>
					<div class="mlist">
						<a href="${pageContext.request.contextPath}/construction/list">
							<img src="${pageContext.request.contextPath}/images/menu_icon07.png">전체 협력사
						</a>
					</div>
					<div class="mlist">
						<a href="${pageContext.request.contextPath}/device/list?constructionIdx=${param.constructionIdx}">
							<img src="${pageContext.request.contextPath}/images/menu_icon10.png">기기관리
						</a>
					</div>
					<div class="mlist">	
						<a href="${pageContext.request.contextPath}/fileinventory/list?constructionIdx=${param.constructionIdx}"  class="menuActive">
							<img src="${pageContext.request.contextPath}/images/menu_icon08.png">파일반입 및 수정
						</a>
					</div>
					<div class="mlist">
						<a href="${pageContext.request.contextPath}/gpsfile/list?constructionIdx=${param.constructionIdx}">
							<img src="${pageContext.request.contextPath}/images/menu_icon09.png">GPS파일관리
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
<%--					<!-- 계약서 관리 -->
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
				</div>
				</c:when>
				<c:when test="${sessionInfo.role == 1}">
					<div class="pc-menu">
						<div class="mlist">
						<a href="${pageContext.request.contextPath}/device/list?constructionIdx=${sessionInfo.constructionIdx}" >
							<img src="${pageContext.request.contextPath}/images/menu_icon10.png">기기관리
						</a>
						</div>
						<c:choose>	
							<c:when test="${(sessionInfo.constructionIdx == 1003 and sessionInfo.hiddenManager == false) or (sessionInfo.constructionIdx == 988 and sessionInfo.hiddenManager == false)}">
								
							</c:when>
							<c:otherwise>
								<c:if test="${not sessionScope.settingRequired or (sessionScope.isHiddenManager ? sessionScope.constructionSetting.useAdminFileMenu : sessionScope.constructionSetting.useGuestFileMenu)}">
								<div class="mlist">
									<a href="${pageContext.request.contextPath}/fileinventory/list?constructionIdx=${sessionInfo.constructionIdx}"  class="menuActive">
										<img src="${pageContext.request.contextPath}/images/menu_icon08.png">파일반입 및 수정
									</a>
								</div>
								</c:if>
								<c:if test="${sessionScope.isHiddenManager and sessionScope.settingRequired}">
								<div class="mlist">
									<a href="${pageContext.request.contextPath}/construction/settings?constructionIdx=${sessionInfo.constructionIdx}">
										<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-gear" viewBox="0 0 16 16" style="margin-right:10px;"><path d="M8 4.754a3.246 3.246 0 1 0 0 6.492 3.246 3.246 0 0 0 0-6.492zM5.754 8a2.246 2.246 0 1 1 4.492 0 2.246 2.246 0 0 1-4.492 0z"/><path d="M9.796 1.343c-.527-1.79-3.065-1.79-3.592 0l-.094.319a.873.873 0 0 1-1.255.52l-.292-.16c-1.64-.892-3.433.902-2.54 2.541l.159.292a.873.873 0 0 1-.52 1.255l-.319.094c-1.79.527-1.79 3.065 0 3.592l.319.094a.873.873 0 0 1 .52 1.255l-.16.292c-.892 1.64.901 3.434 2.541 2.54l.292-.159a.873.873 0 0 1 1.255.52l.094.319c.527 1.79 3.065 1.79 3.592 0l.094-.319a.873.873 0 0 1 1.255-.52l.292.16c1.64.893 3.434-.902 2.54-2.541l-.159-.292a.873.873 0 0 1 .52-1.255l.319-.094c1.79-.527 1.79-3.065 0-3.592l-.319-.094a.873.873 0 0 1-.52-1.255l.16-.292c.893-1.64-.902-3.433-2.541-2.54l-.292.159a.873.873 0 0 1-1.255-.52l-.094-.319zm-2.633.283c.246-.835 1.428-.835 1.674 0l.094.319a1.873 1.873 0 0 0 2.693 1.115l.291-.16c.764-.415 1.6.42 1.184 1.185l-.159.292a1.873 1.873 0 0 0 1.116 2.692l.318.094c.835.246.835 1.428 0 1.674l-.319.094a1.873 1.873 0 0 0-1.115 2.693l.16.291c.415.764-.42 1.6-1.185 1.184l-.291-.159a1.873 1.873 0 0 0-2.693 1.116l-.094.318c-.246.835-1.428.835-1.674 0l-.094-.319a1.873 1.873 0 0 0-2.692-1.115l-.292.16c-.764.415-1.6-.42-1.184-1.185l.159-.291A1.873 1.873 0 0 0 1.945 8.93l-.319-.094c-.835-.246-.835-1.428 0-1.674l.319-.094A1.873 1.873 0 0 0 3.06 4.474l-.16-.292c-.415-.764.42-1.6 1.185-1.184l.292.159a1.873 1.873 0 0 0 2.692-1.115l.094-.319z"/></svg>설정
									</a>
								</div>
								</c:if>
							</c:otherwise>
						</c:choose>
						
						
					
					</div>
				</c:when>
				<c:when test="${sessionInfo.role == 2}">
					<div class="pc-menu">
						<div class="mlist">
						<a href="${pageContext.request.contextPath}/construction/list?groupIdx=${sessionInfo.groupIdx}">
							<img src="${pageContext.request.contextPath}/images/menu_icon07.png">협력사
						</a>
						</div>
						<div class="mlist">
						<a href="${pageContext.request.contextPath}/device/list?constructionIdx=${param.constructionIdx}">
							<img src="${pageContext.request.contextPath}/images/menu_icon10.png">기기관리
						</a>
						</div>
						<div class="mlist">
					 	<a href="${pageContext.request.contextPath}/fileinventory/list?constructionIdx=${param.constructionIdx}"  class="menuActive">
					 		<img src="${pageContext.request.contextPath}/images/menu_icon08.png">파일반입 및 수정
					 	</a>
					 	</div>
					</div>	
				</c:when>
				<c:when test="${sessionInfo.role == 3}">
					<div class="pc-menu">
						<div class="mlist">
						<a href="${pageContext.request.contextPath}/construction/list?fcIdx=${sessionInfo.fcIdx}">
							<img src="${pageContext.request.contextPath}/images/menu_icon07.png">협력사
						</a>
						</div>
						<div class="mlist">
						<a href="${pageContext.request.contextPath}/device/list?constructionIdx=${param.constructionIdx}">
							<img src="${pageContext.request.contextPath}/images/menu_icon10.png">기기관리
						</a>
						</div>
						<div class="mlist" >
					 	<a href="${pageContext.request.contextPath}/fileinventory/list?constructionIdx=${param.constructionIdx}"  class="menuActive">
					 		<img src="${pageContext.request.contextPath}/images/menu_icon08.png">파일반입 및 수정
					 	</a>
					 	</div>
					</div>	
				</c:when>
			</c:choose>
			<!--  -->
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

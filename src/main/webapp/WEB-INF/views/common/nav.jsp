<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/tagLib.jsp" %>
<!--왼쪽메뉴-->
<div class="logo_top m_hide">
	<img class="logo" src="${pageContext.request.contextPath}/new/img/logo.png" onclick="location.href='';" />
	<p class="com_name">Pile Driving Automatic Measurement system</p>
</div>

<div class="mTop pc_hide">
	<img src="${pageContext.request.contextPath}/new/img/nav.png" class="navBtn"/>
	<div class="logo">
		<img src="${pageContext.request.contextPath}/new/img/logo.png" onclick="location.href='';" />
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
		<div class="mlist">
			<a href="../sub/builder.html" class="menuActive"><img src="${pageContext.request.contextPath}/images/menu_icon04.png" />시공사</a>
		</div>
		<div class="mlist">
			<a href="../sub/franchise.html"><img src="${pageContext.request.contextPath}/images/menu_icon05.png" />가맹점</a>
		</div>
		<div class="mlist">
			<a href="../sub/company.html"><img src="${pageContext.request.contextPath}/images/menu_icon07.png" />전체 협력사</a>
		</div>
		<div class="mlist">
			<a href="../sub/notice.html"><img src="${pageContext.request.contextPath}/new/img/menuIcon04.png" />공지사항</a>
		</div>
	</div>
	<div class="logout">
		<a href="../login.html">로그아웃</a>
	</div>
</div>
<!--//왼쪽메뉴-->
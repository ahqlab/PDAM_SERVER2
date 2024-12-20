<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<div class="pagingArea">
    <!-- <ul> -->
	<c:if test="${page.priorPageGroup > 0}">
		<!-- <li class="prevBtn"><a href="javascript:movePage(1)">처음</a></li> -->
		<a href="javascript:movePage(1)" class="prevBtn">
			<img class="prev" src="${pageContext.request.contextPath}/new/img/arrow-prev.png" />prev
		</a>
		
	</c:if>
	<!-- 페이징 -->
	<c:forEach var="i" begin="${page.startPage}" end="${page.endPage}" step="1">
		<c:if test="${page.currentPage != i }">
			<%--  <li><a href="javascript:movePage(${i})">${i}</a></li> --%>
			 <a href="javascript:movePage(${i})" class="pageNm">${i}</a>
		</c:if>
		<c:if test="${page.currentPage == i }">
		 	<%-- <li class="on"><a href="#">${i}</a></li> --%>
		 	<a href="#" class="pageNm on">${i}</a>
		</c:if>
	</c:forEach>

	<c:if test="${page.nextPageGroup > 0}">
	<%-- 	<li><a href="javascript:movePage(${page.nextPageGroup})">맨끝</a></li> --%>
		<a href="javascript:movePage(${page.nextPageGroup})" class="nextBtn">
			next<img class="next" src="${pageContext.request.contextPath}/new/img/arrow-next.png" />
		</a>
	</c:if>
 	<!-- </ul> -->
 </div>
 

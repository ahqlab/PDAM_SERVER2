<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<div style="text-align: right; margin: 10px;">
	 <%-- <font color="blue">${sessionInfo.userName}</font> 계정으로 로그인하셨습니다. --%>
	 <c:choose>
        <%-- role == 0 : 슈퍼관리자 --%>
        <c:when test="${sessionInfo.role eq 0}">
            <font color="blue">슈퍼관리자</font> 계정으로 로그인하셨습니다.
        </c:when>
        
        <%-- role == 1 & hiddenManager == false : 일반계정 --%>
        <c:when test="${sessionInfo.role eq 1 and sessionInfo.hiddenManager eq false}">
            <font color="blue">일반</font> 계정으로 로그인하셨습니다.
        </c:when>
        
        <%-- role == 1 & hiddenManager == true : 관리자 --%>
        <c:when test="${sessionInfo.role eq 1 and sessionInfo.hiddenManager eq true}">
            <font color="blue">관리자</font> 계정으로 로그인하셨습니다.
        </c:when>
        
        <%-- 그 외 (role == 2, 3 등) : 기존 로직 유지 --%>
        <c:otherwise>
            <font color="blue">${sessionInfo.userName}</font> 계정으로 로그인하셨습니다.
        </c:otherwise>
    </c:choose>
</div>
 

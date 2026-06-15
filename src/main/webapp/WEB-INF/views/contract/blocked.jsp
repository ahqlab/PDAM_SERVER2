<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/tagLib.jsp" %>
<div class="section-right">
    <%@ include file="/WEB-INF/views/common/welcomeMsg.jsp" %>
    <div style="display:flex;align-items:center;justify-content:center;min-height:60vh;">
        <div style="background:#fff;border-radius:8px;box-shadow:0 2px 12px rgba(0,0,0,0.1);padding:48px 40px;text-align:center;max-width:460px;width:100%;">
            <div style="font-size:48px;margin-bottom:20px;">&#128274;</div>
            <h2 style="font-size:20px;color:#333;margin-bottom:12px;">이용요금 미납으로 접속이 제한되었습니다</h2>
            <p style="font-size:14px;color:#666;line-height:1.7;margin-bottom:6px;">이용요금 미납으로 인해 서버 접속 및 데이터 연동이 제한되었습니다.</p>
            <p style="font-size:14px;color:#666;line-height:1.7;">정상 이용을 위해 미납금을 납부하여 주시기 바랍니다.</p>
            <hr style="border:none;border-top:1px solid #eee;margin:24px 0;" />
            <a href="${pageContext.request.contextPath}/login"
               style="display:inline-block;padding:10px 32px;background:#337ab7;color:#fff;border-radius:4px;font-size:14px;text-decoration:none;">
                로그아웃
            </a>
        </div>
    </div>
</div>

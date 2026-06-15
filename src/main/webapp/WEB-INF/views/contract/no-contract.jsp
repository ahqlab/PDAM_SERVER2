<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/tagLib.jsp" %>
<div class="section-right">
	<%@ include file="/WEB-INF/views/common/welcomeMsg.jsp" %>
	<div style="display:flex;align-items:center;justify-content:center;min-height:60vh;">
		<div style="background:#fff;border-radius:8px;box-shadow:0 2px 12px rgba(0,0,0,0.1);padding:48px 40px;text-align:center;max-width:460px;width:100%;">
			<div style="font-size:48px;margin-bottom:20px;">&#128274;</div>
			<h2 style="font-size:20px;color:#333;margin-bottom:12px;">계약서가 등록되어 있지 않습니다</h2>
			<p style="font-size:14px;color:#666;line-height:1.7;margin-bottom:6px;">시스템 접속을 위해 계약서 등록이 필요합니다.</p>
			<p style="font-size:14px;color:#666;line-height:1.7;">담당자에게 문의하여 계약서를 등록해 주세요.</p>
			<hr style="border:none;border-top:1px solid #eee;margin:24px 0;" />
			<a href="${pageContext.request.contextPath}/login"
			   style="display:inline-block;padding:10px 32px;background:#337ab7;color:#fff;border-radius:4px;font-size:14px;text-decoration:none;">
				로그아웃
			</a>
		</div>
	</div>
</div>

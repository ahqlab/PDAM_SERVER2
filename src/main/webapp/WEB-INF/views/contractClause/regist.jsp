<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/tagLib.jsp" %>
<div class="section-right">
	<%@ include file="/WEB-INF/views/common/welcomeMsg.jsp" %>
	<div class="TopContArea">
		<div class="titArea">
			<p class="h1Tit">계약 조항 등록</p>
		</div>
	</div>

	<div class="table01_content" style="padding:20px;">
		<form method="post" action="${pageContext.request.contextPath}/contractClause/regist">
			<div class="inputArea02 mb-20">
				<p class="inputTxt02">계약 유형</p>
				<select name="contractType" class="Input02">
					<option value="DAILY">일사용료</option>
					<option value="MONTHLY">월사용료</option>
				</select>
			</div>
			<div class="inputArea02 mb-20">
				<p class="inputTxt02">조 번호</p>
				<input type="number" name="clauseNo" class="Input02" required />
			</div>
<div class="inputArea02 mb-20">
				<p class="inputTxt02">내용</p>
				<textarea name="clauseContent" class="Input02" rows="10" required style="height:auto;resize:vertical;"></textarea>
			</div>
			<div class="inputArea02 mb-20">
				<p class="inputTxt02">정렬 순서</p>
				<input type="number" name="sortOrder" value="0" class="Input02" />
			</div>

			<div style="display:flex;gap:10px;margin-top:24px;">
				<div class="popAdd" onclick="this.closest('form').submit();" style="cursor:pointer;">저장</div>
				<a href="${pageContext.request.contextPath}/contractClause/list" class="popAdd" style="background:#999;text-decoration:none;">취소</a>
			</div>
		</form>
	</div>
</div>

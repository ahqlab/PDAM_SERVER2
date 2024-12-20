<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/tagLib.jsp" %>
<script type="text/javascript">
	function formCheck(){
		
		var passwordRegex = /^[A-Za-z0-9]{6,12}$/;
		
		if($('#fcName').val() == ''){
			alert('가맹점명을 입력하세요.');
			return false;
		}else if($('#password').val() == ''){
			alert('비밀번호를 입력하세요.');
			return false;
		}else if(!passwordRegex.test($('#password').val())){
			alert('숫자와 문자 포함  6~12자리 비밀번호를 입력하세요.');
			return false;
		}else if($('#confirmPassword').val() == ''){
			alert('확인 비밀번호를 입력하세요.');
			return false;
		}else if(!passwordRegex.test($('#confirmPassword').val())){
			alert('숫자와 문자 포함  6~12자리 비밀번호를 입력하세요.');
			return false;
		}else if($('#password').val() != $('#confirmPassword').val()){
			alert('비밀번호가 맞지 않습니다. 비밀번호를 확인하세요.');
			return false;
		}
		
		return true;
	}
</script>
<div class="right_content">
	<div class="tab_menu">
		<ul>
			<li>
				<a href="${pageContext.request.contextPath}/franchise/list">
					<img src="${pageContext.request.contextPath}/images/icon03_off.png" class="icon03">
					가맹점리스트
				</a>
			</li>
			<li class="on">
				<a href="#">
					<img src="${pageContext.request.contextPath}/images/icon03_on.png" class="icon03">
					가맹점등록
				</a>
			</li>
		</ul>
	</div>
	<!--table01_content-->
	<div class="table01_content">
		<div class="sub_title">
			가맹점 등록
		</div>
		<!-- sub_title end-->
		<!--table_white-->
		<form:form method="POST" commandName="domain" >
		<div class="table_white_form">
			<table class="table_white">
				<tr>
					<td>가맹점명</td>
					<td><form:input path="fcName" class="input01"/></td>
				</tr>
				<tr>
					<td>아이디</td>
					<td><form:input path="userId" class="input01"/></td>
				</tr>
				<tr>
					<td>비밀번호</td>
					<td>
						<form:password path="password" class="input01"/>
					</td>
				</tr>
				<tr>
					<td>비밀번호 확인</td>
					<td>
						<input type="password" name="confirmPassword" id="confirmPassword" class="input01">
						<form:hidden path="role" value="3"/>
					</td>
				</tr>
			</table>
		</div>
		
		<!--table_white-->
		<div class="btn_box">
			<input type="submit" class="button02 button05" value="등록하기" onclick="return formCheck();">
		</div>
		</form:form>
	</div>
	<!--table01_content end-->
</div>

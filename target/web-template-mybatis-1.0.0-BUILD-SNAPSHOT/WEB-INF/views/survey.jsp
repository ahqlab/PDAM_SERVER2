<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>
<script src="${pageContext.request.contextPath}/new/js/jquery-3.6.1.min.js"></script>
</head>
<body>
	<div style="width: 100%; align: center; position: relative;">
		 <div id="divpop0" style="margin: 0 auto; margin-top: 100px;">
			<form id="surveyForm" method="POST" action="${pageContext.request.contextPath}/survey">
			
				<table border="0" cellspacing="0" cellpadding="0" background="#330099" align="center" style="">
					<tr style="">
						<td style="text-align: center; width: 100px; padding: 15px;"  colspan="7">
							<font size="6" style="font-weight: bold;">우리기술(주) PDAM시스템(파일 관입량 자동 측정) 사용 만족도 조사</font>
						</td>
					</tr>
					<tr style="">
						<td style=" text-align: left; width: 100px; padding: 15px;" colspan="7">
							우리기술(주)에서는 보다 더 나은 PDAM시스템을 제공하기 위하여 이용자의 고견을 듣고자 하오니, 본 설문에 성실히 응답해 주시면 앞으로 귀하의 의견을 적극 반영하도록 노력하겠습니다. 감사합니다.
						</td>
					</tr>
					<tr style="">
						<td style="  text-align: left; width: 100px; padding: 15px;" colspan="7">
							다음은 PDAM시스템에 대한 질문입니다.(해당하는 점수에 체크 해주세요)
						</td>
					</tr>
					<tr style="border: solid #999999 1px;">
						<td style="border: solid #999999 1px;  text-align: center; width: 100px; padding: 15px;" colspan="2">
							문항
						</td>
						<td style="border: solid #999999 1px; width: 50px; text-align: center;">
							매우<br>
							아니다
						</td>
						<td style="border: solid #999999 1px; width: 50px; text-align: center;">
							아니다
						</td >
						<td style="border: solid #999999 1px; width: 50px; text-align: center;">
							보통
						</td>
						<td style="border: solid #999999 1px; width: 50px; text-align: center;">
							그렇다
						</td >
						<td style="border: solid #999999 1px; width: 50px; text-align: center;">
							매우<br>
							그렇다
						</td >
					</tr>
					<tr style="border: solid #999999 1px;">
						<td style="border: solid #999999 1px;  text-align: center; width: 100px; padding: 15px;" rowspan="6">
							만족도
						</td>
						<td style="border: solid #999999 1px; width: 450px; padding: 15px;">
							1) PDAM 시스템 사용 방법은 간단합니까?
						</td>
						<td style="border: solid #999999 1px; width: 50px; text-align: center;">
							<input type="checkbox" name="checkbox1" value="1" onchange="checkboxGroup(this, this.name)" >
						</td >
						<td style="border: solid #999999 1px; width: 50px; text-align: center;">
							<input type="checkbox" name="checkbox1" value="2" onchange="checkboxGroup(this, this.name)">
						</td >
						<td style="border: solid #999999 1px; width: 50px; text-align: center;">
							<input type="checkbox" name="checkbox1" value="3" onchange="checkboxGroup(this, this.name)">
						</td>
						<td style="border: solid #999999 1px; width: 50px; text-align: center;">
							<input type="checkbox" name="checkbox1" value="4" onchange="checkboxGroup(this, this.name)">
						</td >
						<td style="border: solid #999999 1px; width: 50px; text-align: center;">
							<input type="checkbox" name="checkbox1" value="5" onchange="checkboxGroup(this, this.name)">
						</td >
					</tr>
					<tr style="border: solid #999999 1px;">
						<td style="border: solid #999999 1px; width: 450px; padding: 15px;">
							2) PDAM 시스템 적용으로 업무에 도움이 되었습니까?
						</td>
						<td style="border: solid #999999 1px; width: 50px; text-align: center;">
							<input type="checkbox" name="checkbox2" value="1" onchange="checkboxGroup(this, this.name)">
						</td >
						<td style="border: solid #999999 1px; width: 50px; text-align: center;">
							<input type="checkbox" name="checkbox2" value="2" onchange="checkboxGroup(this, this.name)">
						</td >
						<td style="border: solid #999999 1px; width: 50px; text-align: center;">
							<input type="checkbox" name="checkbox2" value="3" onchange="checkboxGroup(this, this.name)">
						</td>
						<td style="border: solid #999999 1px; width: 50px; text-align: center;">
							<input type="checkbox" name="checkbox2" value="4" onchange="checkboxGroup(this, this.name)">
						</td >
						<td style="border: solid #999999 1px; width: 50px; text-align: center;">
							<input type="checkbox" name="checkbox2" value="5" onchange="checkboxGroup(this, this.name)">
						</td >
					</tr>
					<tr style="border: solid #999999 1px;">
						<td style="border: solid #999999 1px; width: 450px; padding: 15px;">
							3) PDAM 도입으로 안전사고예방에 도움이 되었습니까?
						</td>
						<td style="border: solid #999999 1px; width: 50px; text-align: center;">
							<input type="checkbox" name="checkbox3" value="1"  onchange="checkboxGroup(this, this.name)">
						</td >
						<td style="border: solid #999999 1px; width: 50px; text-align: center;">
							<input type="checkbox" name="checkbox3" value="2"  onchange="checkboxGroup(this, this.name)">
						</td >
						<td style="border: solid #999999 1px; width: 50px; text-align: center;">
							<input type="checkbox" name="checkbox3" value="3"  onchange="checkboxGroup(this, this.name)">
						</td>
						<td style="border: solid #999999 1px; width: 50px; text-align: center;">
							<input type="checkbox" name="checkbox3" value="4"  onchange="checkboxGroup(this, this.name)">
						</td >
						<td style="border: solid #999999 1px; width: 50px; text-align: center;">
							<input type="checkbox" name="checkbox3" value="5"  onchange="checkboxGroup(this, this.name)">
						</td >
					</tr>
					<tr style="border: solid #999999 1px;">
						<td style="border: solid #999999 1px; width: 450px; padding: 15px;">
							4) PDAM 도입으로 시공 시 신뢰성이 확보 되었습니까?
						</td>
						<td style="border: solid #999999 1px; width: 50px; text-align: center;">
							<input type="checkbox" name="checkbox4" value="1" onchange="checkboxGroup(this, this.name)">
						</td >
						<td style="border: solid #999999 1px; width: 50px; text-align: center;">
							<input type="checkbox" name="checkbox4" value="2" onchange="checkboxGroup(this, this.name)">
						</td >
						<td style="border: solid #999999 1px; width: 50px; text-align: center;">
							<input type="checkbox" name="checkbox4" value="3" onchange="checkboxGroup(this, this.name)">
						</td>
						<td style="border: solid #999999 1px; width: 50px; text-align: center;">
							<input type="checkbox" name="checkbox4" value="4" onchange="checkboxGroup(this, this.name)">
						</td >
						<td style="border: solid #999999 1px; width: 50px; text-align: center;">
							<input type="checkbox" name="checkbox4" value="5" onchange="checkboxGroup(this, this.name)">
						</td >
					</tr>
					<tr style="border: solid #999999 1px;">
						<td style="border: solid #999999 1px; width: 450px; padding: 15px;">
							5) PDAM 시스템을 다음 현장에도 적용하시겠습니까?
						</td>
						<td style="border: solid #999999 1px; width: 50px; text-align: center;">
							<input type="checkbox" name="checkbox5" value="1" onchange="checkboxGroup(this, this.name)">
						</td >
						<td style="border: solid #999999 1px; width: 50px; text-align: center;">
							<input type="checkbox" name="checkbox5" value="2" onchange="checkboxGroup(this, this.name)">
						</td >
						<td style="border: solid #999999 1px; width: 50px; text-align: center;">
							<input type="checkbox" name="checkbox5" value="3" onchange="checkboxGroup(this, this.name)">
						</td>
						<td style="border: solid #999999 1px; width: 50px; text-align: center;">
							<input type="checkbox" name="checkbox5" value="4" onchange="checkboxGroup(this, this.name)">
						</td >
						<td style="border: solid #999999 1px; width: 50px; text-align: center;">
							<input type="checkbox" name="checkbox5" value="5" onchange="checkboxGroup(this, this.name)">
						</td >
					</tr>
					<tr style="border: solid #999999 1px;">
						<td style="border: solid #999999 1px; width: 450px; padding: 15px;">
							6) 우리기술 직원들의 대응 및 서비스에 대해 만족하십니까?
						</td>
						<td style="border: solid #999999 1px; width: 50px; text-align: center;">
							<input type="checkbox" name="checkbox6" value="1" onchange="checkboxGroup(this, this.name)">
						</td >
						<td style="border: solid #999999 1px; width: 50px; text-align: center;">
							<input type="checkbox" name="checkbox6" value="2" onchange="checkboxGroup(this, this.name)">
						</td >
						<td style="border: solid #999999 1px; width: 50px; text-align: center;">
							<input type="checkbox" name="checkbox6" value="3" onchange="checkboxGroup(this, this.name)">
						</td>
						<td style="border: solid #999999 1px; width: 50px; text-align: center;">
							<input type="checkbox" name="checkbox6" value="4" onchange="checkboxGroup(this, this.name)">
						</td >
						<td style="border: solid #999999 1px; width: 50px; text-align: center;">
							<input type="checkbox" name="checkbox6" value="5" onchange="checkboxGroup(this, this.name)">
						</td >
					</tr>
					<!-- <tr style="border: solid #999999 1px;">
						<td style="border: solid #999999 1px;  text-align: center; width: 100px; padding: 15px;">
							만족도
						</td>
						<td style="border: solid #999999 1px;" colspan="6">
							<font style="padding: 15px;">
								7) 우리기술이나 PDAM 시스템에 대한 개선 사항 및 의견을 자유롭게 작성해 주세요.
							<font>
							<br>
							<textarea id="guitar" name="guitar" rows="5" cols="20" style="width: 95%; margin-top: 10px;  margin-bottom: 10px; margin-left: 10px;  margin-right: 10px;"></textarea>
							
						</td>
					</tr> -->
					<tr style="border: solid #999999 1px;">
						<td colspan="7" style="text-align: center;">
							<input type="hidden" name="guitar" value="">
							<input type="hidden" name="constructionIdx" value="${constructionIdx}">
							<input type="hidden" name="userId" value="${userId}">
							<input type="hidden" name="conManager" value="${conManager}">
							<input type="hidden" name="password" value="${password}">
						
							<input type="submit" onclick="return formCheck();" value="제출하기" style="margin-top: 10px;  margin-bottom: 10px; margin-left: 10px;  margin-right: 10px;"> 
						</td>
					</tr>
					<tr>
						<td align="right" bgcolor="#333333" width="100%" height="30" colspan="7" style="padding:10px;">
							<font color="#ffffff" style="font-size:16px;"> 
								<b onClick="javascript:goodBye();" style="cursor:pointer; font-size:16px;">[ 나중에 하기 ]</b>
							</font>
						</td>
					</tr>
				</table> 
			</form>
		</div> 
	</div>
	
	<script>
	
	function formCheck(){
		
		const checkbox1s = document.getElementsByName('checkbox1');
		let checkbox1sCnt = 0;
		for (let i = 0; i < checkbox1s.length; i++) {
			 if (checkbox1s[i].checked) {
				 checkbox1sCnt++;
			 }
		}
		
		if (checkbox1sCnt == 0) {
			alert('1번 문항에 답해주시기 바랍니다.');
			return false;
		}
		
		const checkbox2s = document.getElementsByName('checkbox2');
		let checkbox2sCnt = 0;
		for (let i = 0; i < checkbox2s.length; i++) {
			 if (checkbox2s[i].checked) {
				 checkbox2sCnt++;
			 }
		}
		
		if (checkbox2sCnt == 0) {
			alert('2번 문항에 답해주시기 바랍니다.');
			return false;
		}
		
		
		const checkbox3s = document.getElementsByName('checkbox3');
		let checkbox3sCnt = 0;
		for (let i = 0; i < checkbox3s.length; i++) {
			 if (checkbox3s[i].checked) {
				 checkbox3sCnt++;
			 }
		}
		
		if (checkbox3sCnt == 0) {
			alert('3번 문항에 답해주시기 바랍니다.');
			return false;
		}
		
		
		const checkbox4s = document.getElementsByName('checkbox4');
		let checkbox4sCnt = 0;
		for (let i = 0; i < checkbox4s.length; i++) {
			 if (checkbox4s[i].checked) {
				 checkbox4sCnt++;
			 }
		}
		
		if (checkbox4sCnt == 0) {
			alert('4번 문항에 답해주시기 바랍니다.');
			return false;
		}
		
		const checkbox5s = document.getElementsByName('checkbox5');
		let checkbox5sCnt = 0;
		for (let i = 0; i < checkbox5s.length; i++) {
			 if (checkbox5s[i].checked) {
				 checkbox5sCnt++;
			 }
		}
		
		if (checkbox5sCnt == 0) {
			alert('5번 문항에 답해주시기 바랍니다.');
			return false;
		}
		
		const checkbox6s = document.getElementsByName('checkbox6');
		let checkbox6sCnt = 0;
		for (let i = 0; i < checkbox6s.length; i++) {
			 if (checkbox6s[i].checked) {
				 checkbox6sCnt++;
			 }
		}
		
		if (checkbox6sCnt == 0) {
			alert('6번 문항에 답해주시기 바랍니다.');
			return false;
		}
		
		//if($("#guitar").val() == ''){
		//	alert('7번 문항에 답해주시기 바랍니다.');
		//	return false;
		//}
		
		return true;
	}
	
	
	function goodBye(){
		$('#surveyForm').submit();
	}

	function checkboxGroup(currentCheckbox, name) {
		
		const checkboxes = document.getElementsByName(name);
		let checkedCount = 0;

		for (let i = 0; i < checkboxes.length; i++) {
			if (checkboxes[i].checked) {
				checkedCount++;
				if (checkboxes[i] !== currentCheckbox) {
					checkboxes[i].checked = false;
				}
			}
		}

		if (checkedCount === 0) {
			currentCheckbox.checked = true;
		}
	}
</script>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/tagLib.jsp" %>
<script type="text/javascript">



function getTenYears(year){
	
	var preYear = year - 10;
	for(var i = year; i >= preYear; i--){
		$("#dinYear").append("<option value='"+i+"'>"+i+"</option>")
	}
	
}
function getTenMonth(month){
	for(var i = 1; i <= 12; i++){
		if(i == month){
			$("#dinMonth").append("<option selected value='"+i+"'>"+i+"</option>")
		}else{
			$("#dinMonth").append("<option value='"+i+"'>"+i+"</option>")
		}
	}
}
function getCurrentDay(year, month, day){

	var last = new Date( year, month ); 
    last = new Date( last - 1 ); 
    var lastD = last.getDate();
    
    //alert('lastD : ' + lastD);
	for(var i = 1; i <= lastD; i++){
		if(i == day){
			$("#dinDay").append("<option selected value='"+i+"'>"+i+"</option>")
		}else{
			$("#dinDay").append("<option value='"+i+"'>"+i+"</option>")
		}
		
	}
}

function formCheck(){
	return true;
}

$(function(){
	
	$("#dinYear").change(function(){
		setOperDate();
	});

	$("#dinMonth").change(function(){
		setOperDate();
	});
		
	$("#dinDay").change(function(){
		setOperDate();
	});
});


$( document ).ready( function() {
	var now = new Date();	
	var year = now.getFullYear();	// 연도
	var month = now.getMonth() + 1; //월
	var day     = now.getDate(); //일

	getTenYears(year);
	getTenMonth(month);
	getCurrentDay(year, month, day);
	setOperDate();
 });
 
 function setOperDate(){
	 var year =  $("#dinYear option:selected").val();
	 var month =  $("#dinMonth option:selected").val();
	 var day =  $("#dinDay option:selected").val();
	 var operDate = year + "" + month + "" + day;
	 $("#operDate").val(operDate);

 };
</script>
<div class="right_content">
	<div class="tab_menu">
		<ul>
			<li>
				<a href="${pageContext.request.contextPath}/report/list?id=${param.deviceIdx}&constructionIdx=${param.constructionIdx}&type=date&mode=simple">
					시공현황
				</a>
			</li>
			<li>
				<a class="on"  href="${pageContext.request.contextPath}/ips/list?deviceIdx=${param.deviceIdx}&constructionIdx=${param.constructionIdx}">
					투입인원현황
				</a>
			</li>
			<li>
				<a href="${pageContext.request.contextPath}/eus/list?deviceIdx=${param.id}&constructionIdx=${param.constructionIdx}&erpDiv=1">
					장비사용현황
				</a>
			</li>
			<li>
				<a href="${pageContext.request.contextPath}/oiluse/list?deviceIdx=${param.id}&constructionIdx=${param.constructionIdx}&erpDiv=2">
					유류사용현황
				</a>
			</li>
			<li>
				<a href="${pageContext.request.contextPath}/mis/list?deviceIdx=${param.id}&constructionIdx=${param.constructionIdx}&erpDiv=3">
					자재투입현황
				</a>
			</li>
		</ul>
	</div>
	<!--table01_content-->
	<div class="table01_content">
		<!--sub_title-->
		<div class="sub_title">
			관리자등록
		</div>
		<!--sub_title end-->
		<!--table_white-->
		<form:form method="POST" id="ipsForm" commandName="domain" >
		<div class="table_white_form">		
			<table class="table_white">
				<tr>
					<td>날짜</td>
					<td>
						<select class="select01" id="dinYear" name="dinYear" style="width: 100px; height: 40px;">
					
						</select>
						<select class="select01" id="dinMonth" name="dinMonth" style="width: 100px; height: 40px;">
						
						</select>
						<select class="select01" id="dinDay" name="dinDay" style="width: 100px; height: 40px;">
						
						</select>
					</td>
				</tr>
				<tr>
					<td>구분</td>
					<td><form:input path="type" class="input01"/></td>
				</tr>
				<tr>
					<td>이름</td>
					<td><form:input path="name" class="input01"/></td>
				</tr>
				<tr>
					<td>전일</td>
					<td><form:input path="preDay" class="input01"/></td>
				</tr>
				<tr>
					<td>당일</td>
					<td><form:input path="today" class="input01"/></td>
				</tr>
				<tr>
					<td>비고</td>
					<td>
						<form:input path="bigo" class="input01"/>
						<form:hidden path="constructionIdx" value="${param.constructionIdx}"/>
						<form:hidden path="deviceIdx" value="${param.constructionIdx}"/>
						<form:hidden path="operDate"/>
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

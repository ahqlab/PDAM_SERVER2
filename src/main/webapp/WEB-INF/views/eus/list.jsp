<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/tagLib.jsp"%>
<%
	response.setHeader("Cache-Control", "no-store");
	response.setHeader("Pragma", "no-cache");
	response.setDateHeader("Expires", 0);
	if (request.getProtocol().equals("HTTP/1.1"))
		response.setHeader("Cache-Control", "no-cache");
%>
<script type="text/javascript">



function getTenYears(year){
	
 	var sYear = "";
	var operDate = '${param.operDate}';
	if(operDate != ''){
		sYear = operDate.substr(0 , 4);
	}else{
		sYear = year;
    }
    
	var preYear = year - 10;
	for(var i = year; i >= preYear; i--){
		if(sYear == i){
			$("#dinYear").append("<option selected value='"+i+"'>"+i+"</option>")
		}else{
			$("#dinYear").append("<option value='"+i+"'>"+i+"</option>")
		}
		
	}
	
}
function getTenMonth(month){
	
    var sMonth;
    var operDate = '${param.operDate}';
    if(operDate != ''){
    	sMonth = operDate.substr(4 , 2);
    }else{
    	sMonth = month;
    }
    
	for(var i = 1; i <= 12; i++){
		if(i == sMonth){
			$("#dinMonth").append("<option selected value='"+i+"'>"+i+"</option>")
		}else{
			$("#dinMonth").append("<option value='"+i+"'>"+i+"</option>")
		}
	}
}
function getCurrentDay(year, month, day){
	
	var sYear = "";
	var sMonth;
	var sDay = "";
	var operDate = '${param.operDate}';
    if(operDate != ''){
    	sYear = operDate.substr(0 , 4);
    	sMonth = operDate.substr(4 , 2);
    	sDay = operDate.substr(6 , 2);
    }else{
    	sYear = year;
    	sMonth = month;
    	sDay = day;
    }

	var last = new Date( sYear, sMonth ); 
    last = new Date( last - 1 ); 
    var lastD = last.getDate();
	for(var i = 1; i <= lastD; i++){
		if(i == sDay){
			$("#dinDay").append("<option selected value='"+i+"'>"+i+"</option>")
		}else{
			$("#dinDay").append("<option value='"+i+"'>"+i+"</option>")
		}
		
	}
}

function onSearch(){
	//var year = $("#dinYear option:selected").val();
	//var month = $("#dinMonth option:selected").val();
	//var day = $("#dinDay option:selected").val();
	var constructionIdx = '${param.constructionIdx}';
	var deviceIdx = '${param.deviceIdx}';
	//alert("year : " + year + ", month : " + month  + " , day : " + day + ", constructionIdx : " + constructionIdx + ", deviceIdx : " + deviceIdx);
	 var year =  $("#dinYear option:selected").val();
	 var month =  $("#dinMonth option:selected").val();
	 var day =  $("#dinDay option:selected").val();
	 var operDate = numFormat(year) + "" + numFormat(month) + "" + numFormat(day);
	 $("#operDate").val(operDate);
   	 $('#searchForm').submit();	
}

$( document ).ready( function() {
	var now = new Date();	
	var year = now.getFullYear();	// 연도
	var month = now.getMonth() + 1; //월
	var day     = now.getDate(); //일

	getTenYears(year);
	getTenMonth(month);
	getCurrentDay(year, month, day);
 });
 
 
$(function(){
	
	$("#dinMonth").change(function(){
 		var year =  $("#dinYear option:selected").val();
	 	var month =  $("#dinMonth option:selected").val();
	 	$('#dinDay').children().remove().end()
	 	
	 	var last = new Date( year, month ); 
	    last = new Date( last - 1 ); 
	    var lastD = last.getDate();
		for(var i = 1; i <= lastD; i++){
			$("#dinDay").append("<option value='"+i+"'>"+i+"</option>");
		}
	});

});

function numFormat(variable) {
 	var variable = Number(variable).toString();
 	if (Number(variable) < 10 && variable.length == 1)
 		variable = "0" + variable;
 	return variable;
 }
 
 function goUpdatePage(url){
	// alert('url : ' + url);
	 document.location.href = url; 
 }
 function goRegistPage(){
	 
	var root = '${pageContext.request.contextPath}';
	var deviceIdx = '${param.deviceIdx}';
	var constructionIdx = '${param.constructionIdx}';
	
	var year =  $("#dinYear option:selected").val();
 	var month =  $("#dinMonth option:selected").val();
 	var day =  $("#dinDay option:selected").val();
 	var operDate = numFormat(year) + "" + numFormat(month) + "" + numFormat(day);
	 document.location.href =  root + "/eus/regist?deviceIdx=" + deviceIdx + "&constructionIdx=" + constructionIdx + "&erpDiv=${param.erpDiv}&operDate=" + operDate; 
 }

 
 function numFormat(variable) {
	var variable = Number(variable).toString();
	if (Number(variable) < 10 && variable.length == 1)
		variable = "0" + variable;
	return variable;
}
 
 
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
				<a href="${pageContext.request.contextPath}/ips/list?deviceIdx=${param.deviceIdx}&constructionIdx=${param.constructionIdx}">
					투입인원현황
				</a>
			</li>
			<li>
				<a class="on" href="${pageContext.request.contextPath}/eus/list?deviceIdx=${param.deviceIdx}&constructionIdx=${param.constructionIdx}&erpDiv=1">
					장비사용현황
				</a>
			</li>
			<li>
				<a href="${pageContext.request.contextPath}/oiluse/list?deviceIdx=${param.deviceIdx}&constructionIdx=${param.constructionIdx}&erpDiv=2">
					유류사용현황
				</a>
			</li>
			<li>
				<a href="${pageContext.request.contextPath}/mis/list?deviceIdx=${param.deviceIdx}&constructionIdx=${param.constructionIdx}&erpDiv=3">
					자재투입현황
				</a>
			</li>
		</ul>
	</div>
	<!--table01_content-->
	<div class="table01_content">
		<div class="search_div">
			<form:form id="searchForm" commandName="domainParam" method="POST">
				<form:hidden path="currentPage"/>
				<div class="search_form02">
					<select class="select01" id="dinYear" name="dinYear">
					
					</select>
					<select class="select01" id="dinMonth" name="dinMonth">
					
					</select>
					<select class="select01" id="dinDay" name="dinDay">
					
					</select>
					<img id="submitBtn" src="${pageContext.request.contextPath}/images/search.png" class="search_icon" onclick="javascript:onSearch();">
					<form:hidden path="operDate"/>
					<form:hidden path="erpDiv" value="${param.erpDiv}"/>
					<form:hidden path="deviceIdx" value="${param.deviceIdx}"/>
					<form:hidden path="constructionIdx" value="${param.constructionIdx}"/>
				</div>
			<!--제목 검색폼 end-->
			</form:form>
		</div>
		<!--search_div end-->
		<!--table 리스트-->
		<div class="table_list">
			<table class="table01">
				<tr>
					<th style="width: 10%;">구분</th>
					<th style="width: 10%;">전일</th>
					<th style="width: 10%;">금일</th>
					<th style="width: 10%;">합계</th>
					<th style="width: 10%;">비고</th>
				</tr>
				<c:forEach var="domain" items="${domainList}" varStatus="status">
					<tr onclick="javascript:goUpdatePage('${pageContext.request.contextPath}/eus/update?id=${domain.id}&deviceIdx=${domain.deviceIdx}&constructionIdx=${domain.constructionIdx}&erpDiv=${param.erpDiv}');">
						<td >${domain.dmiCol}</td>
						<td>${domain.preDay}</td>
						<td>${domain.today}</td>
						<td>${domain.preDay + domain.today}</td>
						<td>${domain.bigo}</td>
					</tr>
				</c:forEach>
			</table>
		</div>
		<!--table 리스트 end-->
		<br>
		<div class="white_btn">
			<a href="javascript:goRegistPage();">등록</a>
		</div>
		<%@ include file="/WEB-INF/views/common/pagination.jsp"%>
		<!--페이지 넘버end-->
	</div>
</div>
	<!--table01_content end-->
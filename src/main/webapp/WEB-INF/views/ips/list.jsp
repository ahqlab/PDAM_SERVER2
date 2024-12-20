<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/tagLib.jsp"%>
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

function onSearch(){
	var year = $("#dinYear option:selected").val();
	var month = $("#dinMonth option:selected").val();
	var day = $("#dinDay option:selected").val();
	var constructionIdx = '${param.constructionIdx}';
	var deviceIdx = '${param.deviceIdx}';
	alert("year : " + year + ", month : " + month  + " , day : " + day + ", constructionIdx : " + constructionIdx + ", deviceIdx : " + deviceIdx);
	
	jQuery.ajax({
		type : "POST",
		url : "${pageContext.request.contextPath}/device/duplicate/tabletNo/confirm",
		data: { tabletNo: $('#tabletNo').val() }, 
		dataType : "JSON", // 옵션이므로 JSON으로 받을게 아니면 안써도 됨
		success : function(data) {
			if(data.length > 0){
				alert("이미 등록된 태블릿PC 번호입니다.");
			}else{
				$('#isDuplicate').val("true");
				alert("사용가능한 태블릿PC 번호입니다.");
			}
		},
		complete : function(data) {
		},
		error : function(xhr, status, error) {
		}
	});
	
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
				<a href="${pageContext.request.contextPath}/eus/list?deviceIdx=${param.deviceIdx}&constructionIdx=${param.constructionIdx}&erpDiv=1">
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
		<!--search_div-->
	
		
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
				</div>
			<!--제목 검색폼 end-->
			</form:form>
		</div>
		
		<!--search_div end-->
		<!--table 리스트-->
		<div style="text-align: right;">
			<input type="button" value="-" style="font-size : 15px; font-weight :bold; width : 50px; margin-right: 4px; margin-bottom: 4px;">
			<input type="button" value="+" style="font-size : 15px; font-weight :bold; width : 50px; margin-bottom: 4px;">
		</div>
		<div class="table_list">
			<table class="table01">
				<tr>
					<th style="width: 10%;">구분</th>
					<th style="width: 10%;">이름</th>
					<th style="width: 10%;">전일</th>
					<th style="width: 10%;">금일</th>
					<th style="width: 10%;">합계</th>
					<th style="width: 10%;">비고</th>
				</tr>
				<c:forEach var="domain" items="${domainList}" varStatus="status">
					<tr onclick="">
						<td>${domain.type}</td>
						<td>${domain.name}</td>
						<td>${domain.preDay}</td>
						<td>${domain.today}</td>
						<td>${domain.preDay + domain.today}</td>
						<td>${domain.bigo}</td>
					</tr>
				</c:forEach>
				<%-- <c:choose>
					<c:when test="${fn:length(domainList) == 0}">
						<tr>
							<c:choose>
								<c:when test="${sessionInfo.role == 0}">
									<td colspan="4">등록된 데이터가 없습니다.</td>
								</c:when>
								<c:otherwise>
									<td colspan="3">등록된 데이터가 없습니다.</td>
								</c:otherwise>
							</c:choose>

						</tr>
					</c:when>
				</c:choose> --%>
			</table>
		</div>
		<!--table 리스트 end-->
		</br>
		<div class="white_btn">
			<a href="${pageContext.request.contextPath}/ips/regist?deviceIdx=${param.deviceIdx}&constructionIdx=${param.constructionIdx}">등록</a>
		</div>
		<%@ include file="/WEB-INF/views/common/pagination.jsp"%>

		<!--페이지 넘버end-->
	</div>
</div>
	<!--table01_content end-->
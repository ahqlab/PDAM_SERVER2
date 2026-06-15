<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/tagLib.jsp" %>
<script type="text/javascript">
$( document ).ready( function() 
{	
	    $('#submitBtn').click( function() {
	    	$('#searchForm').submit();	    	
	    });
	     
	    getConstructionName();

	    calcSum();
	    
	    //getSpareDeviceCount();
	    //getTestReportSet();
	    //document.getElementById("remoteViewSet").style.display = "block";
	    
});

function calcSum(){
	
	var totalSum = 0;
	var todaySum = 0;
	var yesterdaySum = 0;
	var conIdx = ${param.constructionIdx}	
	$('#deviceListTable tr').each( function( idx, obj ) {
		if(idx > 0 && idx != $('#deviceListTable tr').length){
			var tr = $(this);
			var td = tr.children();
			
			var total;
			var today;
			var yesterday;
			
			if(conIdx == 588 || conIdx == 613 || conIdx == 627){
				total = td.eq(3).text();
				today = td.eq(4).text();
				yesterday = td.eq(5).text();
			}else{
				total = td.eq(2).text();
				today = td.eq(3).text();
				yesterday = td.eq(4).text();
			}
			
			totalSum += Number(total.replace('공', ''));
			todaySum += Number(today.replace('공', ''));
			yesterdaySum += Number(yesterday.replace('공', ''));
		}
	});
	$('#totalSum').text(totalSum + "공");
	$('#todaySum').text(todaySum + "공");
	$('#yesterdaySum').text(yesterdaySum + "공");
}


function getConstructionName(){
	var idx = ${param.constructionIdx};
	jQuery.ajax({
		type : "POST",
		contentType: "application/x-www-form-urlencoded; charset=UTF-8",
		url : "${pageContext.request.contextPath}/construction/get/name",
		data: {
			id : idx
		}, 
		success : function(data) {
			$('.h1Tit').text(data);
		},
		complete : function(data) {
		},
		error : function(xhr, status, error) {
		}
	}); 
}


function getDeviceNameList(){
	
	var conIdx = ${param.constructionIdx};
	jQuery.ajax({
		type : "POST",
		url  : "${pageContext.request.contextPath}/device/get/list",
		data : {
			constructionIdx : conIdx
		}, 
		dataType : "JSON",
		success : function(data) {
			$.each(data, function (i, item) {
				$("#select2").append("<option class='text-success text-center' value='"+item.lavelNo+"'>"+item.machineNumber+"( " + item.lavelNo + " )</option>");
			});
		},
		complete : function(data) {
		},
		error : function(xhr, status, error) {
		}
	});
}

function onClickChkAll(){
	if($("#chkAll").is(":checked")){
		$("input[name=selectOne]").prop("checked", true);
		for (var i = 0; i < $('#deviceListTable tr').length; i++) {
			doOpen(i);
		}
	} else {
		$("input[name=selectOne]").prop("checked", false);
		for (var i = 0; i < $('#deviceListTable tr').length; i++) {
			doClose(i);
		}
	}
}

function doOpenCheck(chk, rowindex) {
	index = rowindex - 1;
	if($("input[name=selectOne]").eq(index).is(':checked')){
		$('#deviceListTable tr').eq(rowindex).css("background-color", "#8dc5fc");
		$("input[name=deviceName]").eq(index).attr("disabled", false);
	}else{
		$('#deviceListTable tr').eq(rowindex).css("background-color", "white");
		$("input[name=deviceName]").eq(index).attr("disabled", true);	
	}
}
function doClose(rowindex){
	if(rowindex > 0 && rowindex < $('#deviceListTable tr').length - 1){
		$('#deviceListTable tr').eq(rowindex).css("background-color", "white");
		$("input[name=deviceName]").eq(rowindex - 1).attr("disabled", true);	
	}
}

function allClose(){
	for (var i = 0; i < $('#deviceListTable tr').length; i++) {
		doClose(i);
	}
}

function doOpen(rowindex){
	if(rowindex > 0 && rowindex < $('#deviceListTable tr').length - 1){
		$('#deviceListTable tr').eq(rowindex).css("background-color", "#8dc5fc");
		$("input[name=deviceName]").eq(rowindex - 1).attr("disabled", false);
	}
}


function onClickGpsUpdate(){
	
	var deviceNames = [];
	var constructionIdx = ${param.constructionIdx};
	
	for (var i = 0; i < $('#deviceListTable tr').length; i++) {
		//check box 선택여부
		if (!$("input[name=selectOne]").eq(i).is(':checked')) {
			continue;
		}
		var data = {
			deviceIdx : $("input[name=deviceIdx]").eq(i).val(), 
			deviceName : $("input[name=deviceName]").eq(i).val()
		}
		deviceNames.push(data);
		
	}
	
	if(deviceNames.length == 0){
		alert('선택된 항목이 없습니다.');
		reports = [];
		return;
	}
	
	var result = confirm("저장 하시겠습니까?");
	if(result){
		jQuery.ajax({
			type : "POST",
			url : "${pageContext.request.contextPath}/device/name/update/multi",
			data: JSON.stringify(deviceNames), 
			dataType : "JSON", // 옵션이므로 JSON으로 받을게 아니면 안써도 됨
			contentType : "application/json",
			success : function(data) {
				if(data == true){
					pageReload();
				}
			},
			complete : function(data) {
				
			},
			error : function(xhr, status, error) {
				
			}
		});
		return; 
	}else{
		return;
	}
	return;
}

function pageReload(){
	document.location.replace("");
}

</script>

		<!--컨텐츠-->
<div class="section-right">
	<%@ include file="/WEB-INF/views/common/welcomeMsg.jsp" %>
	<div class="TopContArea">
		<div class="titArea mb-40">
			<p class="h1Tit"></p>
			<div class="titBtnArea" style="">	
				<div class="printBtn" onclick="javascript:downloadAllReport(${sessionInfo.constructionIdx});">기록지 전체 출력</div>
				<form:form id="searchForm" commandName="domainParam" method="POST">
					<form:hidden path="currentPage"/>
				</form:form>
			</div>
		</div>
	</div>
	
	
	
	<div class="min531">
		
		<div class="tableArea">
			
			<div class="viewTable viewTable01">
				<div class="tableScroll">
					<table id="deviceListTable">
						<tr class="viewTh">
							<th style="width: 7%; padding: 15px 0px 15px 0px;">
								<input type="checkbox" id="chkAll" name="chkAll" onclick="javascript:onClickChkAll();">
							</th>
							<th style="width: 7%; font-size: 15px;">호기</th>
							<th style="width: 7%; font-size: 15px;">총작업</th>
							<th style="width: 7%; font-size: 15px;">금일작업</th>
							<th style="width: 7%; font-size: 15px;">전일작업</th>
							<th style="width: 7%; font-size: 15px;">태블릿 ID</th>
							<th style="width: 7%; font-size: 15px;">장비명</th>
							<th style="width: 7%; font-size: 15px;">블루투스 No</th>
							<th style="width: 7%; font-size: 15px;">측정기 S/N</th>
							<th style="width: 7%; font-size: 15px;">We매니저</th>
							<th style="width: 7%; font-size: 15px;">연락처</th>
							<th style="width: 7%; font-size: 15px;">시작일</th>
							<th style="width: 7%; font-size: 15px;">종료일</th>
						</tr>
						<c:forEach var="domain" items="${domainList}" varStatus="status">
							<tr>
								<td>
									<input type="checkbox" id="selectOne" name="selectOne" onclick="doOpenCheck(this, this.parentNode.parentNode.rowIndex);" style="margin: 0; padding: 0;">
								</td>
								<td><a class="viewGo" href='${pageContext.request.contextPath}/simple/report/list?id=${domain.id}&constructionIdx=${param.constructionIdx}&type=date&mode=simple'>${domain.machineNumber}</a></td>
								<td>${domain.totalCnt}공</td>
								<td>${domain.todayCnt}공</td>
								<td>${domain.yesterdayCnt}공</td>
								<td>${domain.tabletNo}</td>
								<td>
									<input type="text" class="tdInput" id="deviceName" name="deviceName" value="${domain.deviceName}" disabled="disabled"  >
									<input type="hidden" id="deviceIdx" name="deviceIdx" value="${domain.id}">
								</td>
								<td>${domain.bluetoothNo}</td>
								<td><a class="viewGo"  href="javascript:TestReportFileDownload('${pageContext.request.contextPath}' , '${pageContext.request.contextPath}/treport/download/test/report?sn=${domain.lavelNo}', '${domain.lavelNo}');">${domain.lavelNo}</a></td>
								<td>${domain.tabletManager}</td>
								<td>${domain.weContact}</td>
								<td>${domain.startDate}</td>
								<td>${domain.endDate}</td>
								<%-- <td><a href="javascript:doDelete('${domain.id}')">[삭제]</a></td> --%>
							</tr>
						</c:forEach>
						<!--//데이터가 없을 경우-->
						
						<c:choose>
						<c:when test="${fn:length(domainList) == 0}">
							<tr>
								<c:choose>
									<c:when test="${sessionInfo.role == 0}">
										<td colspan="13">등록된 데이터가 없습니다.</td>
									</c:when>
									<c:otherwise>
										<td colspan="11">등록된 데이터가 없습니다.</td>
									</c:otherwise>
								</c:choose>
							</tr>
						</c:when>
						<c:otherwise>
							<tr style="background-color: #e6e6e6; height: 49px;">
								<td>합계</td>
								<td></td>
								<td id="totalSum"></td>
								<td id="todaySum"></td>
								<td id="yesterdaySum"></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
							</tr>
						</c:otherwise>
					</c:choose>
					</table>
				</div>
			</div>
		</div>
		
		<div style="float: right; margin-top: 10px;">
			<input type="button" onclick="javascript:onClickGpsUpdate();" value="저장" style="width: 95px; height: 30px; background: #077b9c; border: solid #077b9c 1px; border-radius: 5px; text-align: center; color: white;">
		</div>		
	<!--페이징-->			
	<%@ include file="/WEB-INF/views/common/pagination.jsp" %>
	<!--//페이징-->
	
	</div>
	
	
	
</div>
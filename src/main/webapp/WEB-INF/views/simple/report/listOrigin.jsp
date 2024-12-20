<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/tagLib.jsp" %>
<script type="text/javascript">
$(document).ready( function() {
    $('#submitBtn').click( function() {
    	$('#searchForm').submit();
    });
	
    $("#aa").scroll(function () {
        $("#bb").scrollTop($("#bb").scrollTop());
        $("#bb").scrollLeft($("#bb").scrollLeft());
    });
    $("#bb").scroll(function () {
        $("#aa").scrollTop($("#aa").scrollTop());
        $("#aa").scrollLeft($("#aa").scrollLeft());
    });
    
    /* $("table tbody tr td").on("click", function() {
        $(this).closest("table").find("tr").css({
           backgroundColor: "white"
        });
        $(this).css({
           backgroundColor: "blue"
        });
     }); */
});
function goUrl(url){
	//alert('url : ' + url);
	document.location.href=url;
	
}
function doRestore(){
	var index = getCheckdCheckboxIndex();
	if(index != null){
		var isDel = document.getElementsByName("isDel");
		var selectIsDel = Number(isDel[index].value);
		
		if(selectIsDel == 1){
			var id = document.getElementsByName("id");
			var idx = Number(id[index].value);
			var result = confirm("삭제된 항목을 복구하시겠습니까?");
			if(result){
				if(result){
					jQuery.ajax({
						type : "POST",
						url : "${pageContext.request.contextPath}/report/doRestore",
						data: {
							id : idx
						}, 
						dataType : "JSON", // 옵션이므로 JSON으로 받을게 아니면 안써도 됨
						success : function(data) {
							if(data == true){
								alert('복구되었습니다.');
								history.go(0);
							}
						},
						complete : function(data) {
						},
						error : function(xhr, status, error) {
						}
					}); 
				}
			}
		}else{
			alert("삭제되지 않은 항목입니다.");
		}
	}else{
		alert('선택된 항목이 없습니다.');
	}
}

function doDelete(){
	var index = getCheckdCheckboxIndex();
	if(index != null){
		var id = document.getElementsByName("id");
		var idx = Number(id[index].value);
		
		var result = confirm("정말 삭제하시겠습니까? 삭제 시 기록은 저장되지 않으며 복구할 수 없습니다.");
		if(result){
			jQuery.ajax({
				type : "POST",
				url : "${pageContext.request.contextPath}/report/doDelete",
				data: {
					id : idx
				}, 
				dataType : "JSON", // 옵션이므로 JSON으로 받을게 아니면 안써도 됨
				success : function(data) {
					if(data == true){
						alert('삭제되었습니다.');
						history.go(0);
					}
				},
				complete : function(data) {
				},
				error : function(xhr, status, error) {
				}
			}); 
		}
	}else{
		alert('선택된 항목이 없습니다.');
	}
}

function onClickReportUpdate(){
	
	var role = ${sessionInfo.role};
	var index = getCheckdCheckboxIndex();
	
	if(index != null){
		var isDel = document.getElementsByName("isDel");
		var selectIsDel = Number(isDel[index].value);
		if(selectIsDel == 1){
			alert('삭제된 항목은 수정할 수 없습니다.');
			var obj = document.getElementsByName("selectOne");
			obj[index].checked = false;
			return;
		}
	}else{
		alert('선택된 항목이 없습니다.');
		return;
	}
	
	
	
	var id = document.getElementsByName("id");
	var pileType = document.getElementsByName("pileType");
	var method = document.getElementsByName("method");
	var location = document.getElementsByName("location");
	var pileNo = document.getElementsByName("pileNo");
	var pileStandard = document.getElementsByName("pileStandard");
	
	var drillingDepth = document.getElementsByName("drillingDepth");
	var intrusionDepth = document.getElementsByName("intrusionDepth");
	var hammaT = document.getElementsByName("hammaT");
	var fallMeter = document.getElementsByName("fallMeter");
	var managedStandard = document.getElementsByName("managedStandard");
	var totalPenetrationValue = document.getElementsByName("totalPenetrationValue");
	var avgPenetrationValue = document.getElementsByName("avgPenetrationValue");
	var crossSection = document.getElementsByName("crossSection");
	var hammaEfficiency = document.getElementsByName("hammaEfficiency");
	var modulusElasticity = document.getElementsByName("modulusElasticity");
	var bigo = document.getElementsByName("bigo");
	
	var piece = document.getElementsByName("piece[" + index + "]");
	var pieceId = document.getElementsByName("pieceId[" + index + "]");
	var pieceName = document.getElementsByName("pieceName[" + index + "]");
	
	if(role == 0){
		var penetrations = document.getElementsByName("penetrations[" + index + "]");
		var penetrationsId = document.getElementsByName("penetrationsId[" + index + "]");
		var penetrationsName = document.getElementsByName("penetrationsName[" + index + "]");
	}

	

	if(index != null){
		var pieces = [];
		
		for(var i=0; i<piece.length; i++){
			var onePiece = {
					name: pieceName[i].value != "" ? pieceName[i].value : "null",
					value : piece[i].value != "" ? 	piece[i].value : "0",
					id : Number(pieceId[i].value) != Number(0) ? Number(pieceId[i].value) : Number(0),
					reportIdx :Number(id[index].value)
			};
			pieces.push(onePiece);	
		}
		if(role == 0){
			var penetrationss = [];
			for(var i=0; i<penetrations.length; i++){
				if(penetrations[i].value != ""){
					var onePenetrations = {
							name: penetrationsName[i].value != "" ? penetrationsName[i].value : "null",
							value : penetrations[i].value != "" ? 	penetrations[i].value : "0",
							id : Number(penetrationsId[i].value) != Number(0) ? Number(penetrationsId[i].value) : Number(0),
							reportIdx :Number(id[index].value)
					};
					penetrationss.push(onePenetrations);
				}
			}
		}
		
		
		if(role == 0){
			var data = {
					id: Number(id[index].value), 
					pileType: pileType[index].value != "" ? pileType[index].value : "null", 
					method: method[index].value != "" ? method[index].value : "null", 
					location: location[index].value != "" ? location[index].value : "null", 
					pileNo: pileNo[index].value != "" ? pileNo[index].value : "null", 
					pileStandard: pileStandard[index].value != "" ? pileStandard[index].value : "null", 
					piece: pieces, 
					penetrations : penetrationss, 
					drillingDepth: drillingDepth[index].value != "" ? drillingDepth[index].value  : "0", 
					intrusionDepth: intrusionDepth[index].value != "" ? intrusionDepth[index].value  : "0", 
					hammaT: hammaT[index].value != "" ? hammaT[index].value  : "0",
					fallMeter: fallMeter[index].value != "" ? fallMeter[index].value  : "0",
					managedStandard: managedStandard[index].value != "" ? managedStandard[index].value  : "0"
					, totalPenetrationValue : totalPenetrationValue[index].value != "" ? totalPenetrationValue[index].value  : "0"
					, avgPenetrationValue : avgPenetrationValue[index].value != "" ? avgPenetrationValue[index].value  : "0"
					, crossSection : crossSection[index].value != "" ? crossSection[index].value  : "0"
					, bigo : bigo[index].value != "" ? bigo[index].value  : "null"
					, hammaEfficiency : hammaEfficiency[index].value != "" ? hammaEfficiency[index].value  : "0"
					, modulusElasticity : modulusElasticity[index].value != "" ? modulusElasticity[index].value  : "0"
				//,	ultimateBearingCapacity : ultimateBearingCapacity[index].value
	        };
		}else{
			var data = {
					id: Number(id[index].value), 
					pileType: pileType[index].value != "" ? pileType[index].value : "null", 
					method: method[index].value != "" ? method[index].value : "null", 
					location: location[index].value != "" ? location[index].value : "null", 
					pileNo: pileNo[index].value != "" ? pileNo[index].value : "null", 
					pileStandard: pileStandard[index].value != "" ? pileStandard[index].value : "null", 
					piece: pieces, 
					drillingDepth: drillingDepth[index].value != "" ? drillingDepth[index].value  : "0", 
					intrusionDepth: intrusionDepth[index].value != "" ? intrusionDepth[index].value  : "0", 
					hammaT: hammaT[index].value != "" ? hammaT[index].value  : "0",
					fallMeter: fallMeter[index].value != "" ? fallMeter[index].value  : "0",
					managedStandard: managedStandard[index].value != "" ? managedStandard[index].value  : "0"
					, totalPenetrationValue : totalPenetrationValue[index].value != "" ? totalPenetrationValue[index].value  : "0"
					, avgPenetrationValue : avgPenetrationValue[index].value != "" ? avgPenetrationValue[index].value  : "0"
					, crossSection : crossSection[index].value != "" ? crossSection[index].value  : "0"
					, bigo : bigo[index].value != "" ? bigo[index].value  : "null"
					, hammaEfficiency : hammaEfficiency[index].value != "" ? hammaEfficiency[index].value  : "0"
					, modulusElasticity : modulusElasticity[index].value != "" ? modulusElasticity[index].value  : "0"
				//,	ultimateBearingCapacity : ultimateBearingCapacity[index].value
	        };
		}
		
		
		//alert(JSON.stringify(data));
		
		var result = confirm("수정하시겠습니까?");
		if(result){
			jQuery.ajax({
				type : "POST",
				url : "${pageContext.request.contextPath}/report/update/report",
				data: JSON.stringify(data), 
				dataType : "JSON", // 옵션이므로 JSON으로 받을게 아니면 안써도 됨
				contentType : "application/json",
				success : function(data) {
					if(data == true){
						//history.go(0);
						//alert(document.location.href);
						//document.location.href= document.location.href;
						//window.location.reload()

						$('#searchForm').submit();
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
	}
	alert('선택된 항목이 없습니다.');
	return;
}


	function doOpenCheck(chk, rowindex) {
				
		var role = ${sessionInfo.role};
		var obj = document.getElementsByName("selectOne");
		var index = rowindex;
		
		for (var i = 0; i < $('#reportTable tr').length; i++) {
			if (i == rowindex) {
				if (obj[rowindex].checked) {
					var isDel = document.getElementsByName("isDel");
					var selectIsDel = Number(isDel[i].value);
					if(selectIsDel == 1){
						$('#reportTable tr:eq(' + i + ')').css("background-color", "#ff0000");
					}else{
						$('#reportTable tr:eq(' + i + ')').css("background-color", "#8dc5fc");
					}
				} else {
					var isDel = document.getElementsByName("isDel");
					var selectIsDel = Number(isDel[i].value);
					if(selectIsDel == 1){
						$('#reportTable tr:eq(' + i + ')').css("background-color", "#ff0000");
					}else{
						$('#reportTable tr:eq(' + i + ')').css("background-color", "white");
					}
					
				}
			} else {
				//선택하지 않은것
				var isDel = document.getElementsByName("isDel");
				var selectIsDel = Number(isDel[i].value);
				if(selectIsDel == 1){
					$('#reportTable tr:eq(' + i + ')').css("background-color", "#ff0000");
				}else{
					$('#reportTable tr:eq(' + i + ')').css("background-color","white");
				}
			}
		}

		var id = document.getElementsByName("id");
		var pileType = document.getElementsByName("pileType");
		var method = document.getElementsByName("method");
		var location = document.getElementsByName("location");
		var pileNo = document.getElementsByName("pileNo");
		var pileStandard = document.getElementsByName("pileStandard");

		var drillingDepth = document.getElementsByName("drillingDepth");
		var intrusionDepth = document.getElementsByName("intrusionDepth");
		var hammaT = document.getElementsByName("hammaT");
		var fallMeter = document.getElementsByName("fallMeter");
		var managedStandard = document.getElementsByName("managedStandard");
		
		//var ultimateBearingCapacity = document.getElementsByName("ultimateBearingCapacity");
		var crossSection = document.getElementsByName("crossSection");
		var hammaEfficiency = document.getElementsByName("hammaEfficiency");
		var modulusElasticity = document.getElementsByName("modulusElasticity");
		var bigo = document.getElementsByName("bigo");
		
		var pieceId = document.getElementsByName("pieceId[" + index + "]");
		var pieceName = document.getElementsByName("pieceName[" + index + "]");

		for (var j = 0; j < obj.length; j++) {

			var pie = document.getElementsByName("piece[" + j + "]");
			for (var k = 0; k < pie.length; k++) {
				pie[k].disabled = true;
			}
			
			if(role == 0){
				var pntrs = document.getElementsByName("penetrations[" + j + "]");
				for (var l = 0; l < pntrs.length; l++) {
					pntrs[l].disabled = true;
				}
			}
			
			pileType[j].disabled = true;
			method[j].disabled = true;
			location[j].disabled = true;
			pileNo[j].disabled = true;
			pileStandard[j].disabled = true;

			drillingDepth[j].disabled = true;
			intrusionDepth[j].disabled = true;
			hammaT[j].disabled = true;
			fallMeter[j].disabled = true;
			managedStandard[j].disabled = true;
			
			crossSection[j].disabled = true;
			hammaEfficiency[j].disabled = true;
			modulusElasticity[j].disabled = true;
			bigo[j].disabled = true;
			
			//ultimateBearingCapacity[j].disabled = true;
		}


		var piece = document.getElementsByName("piece[" + index + "]");
		
		if(role == 0){
			var pntrs = document.getElementsByName("penetrations[" + index + "]");	
		}
		
		
		if (obj[index].checked) {
			var isDel = document.getElementsByName("isDel");
			var selectIsDel = Number(isDel[index].value);
			
			if(selectIsDel == 0){
				for (var y = 0; y < piece.length; y++) {
					piece[y].disabled = false;
				}
				if(role == 0){
					for (var l = 0; l < pntrs.length; l++) {
						pntrs[l].disabled = false;
					}
				}
				pileType[index].disabled = false;
				method[index].disabled = false;
				location[index].disabled = false;
				pileNo[index].disabled = false;
				pileStandard[index].disabled = false;

				drillingDepth[index].disabled = false;
				intrusionDepth[index].disabled = false;
				hammaT[index].disabled = false;
				fallMeter[index].disabled = false;
				managedStandard[index].disabled = false;
				
				crossSection[index].disabled = false;
				hammaEfficiency[index].disabled = false;
				modulusElasticity[index].disabled = false;
				bigo[index].disabled = false;
			} 
			//ultimateBearingCapacity[index].disabled = false;
		}else{
			for (var y = 0; y < piece.length; y++) {
				piece[y].disabled = true;
			}
			if(role == 0){
				for (var y = 0; y < pntrs.length; y++) {
					pntrs[y].disabled = true;
				}
			}
			
			
			pileType[index].disabled = true;
			method[index].disabled = true;
			location[index].disabled = true;
			pileNo[index].disabled = true;
			pileStandard[index].disabled = true;

			drillingDepth[index].disabled = true;
			intrusionDepth[index].disabled = true;
			hammaT[index].disabled = true;
			fallMeter[index].disabled = true;
			managedStandard[index].disabled = true;
			
			crossSection[index].disabled = true;
			hammaEfficiency[index].disabled = true;
			modulusElasticity[index].disabled = true;
			bigo[index].disabled = true;
			//ultimateBearingCapacity[index].disabled = true;
		}
		

		//pileType, method, location, pileNo, pileStandard, drillingDepth , intrusionDepth , hammaT , fallMeter, managedStandard
		for (var l = 0; l < obj.length; l++) {
			if (obj[l] != chk) {
				obj[l].checked = false;

			}
		}
	}

	function getCheckdCheckboxIndex() {
		var obj = document.getElementsByName("selectOne");
		for (var i = 0; i < obj.length; i++) {
			if (obj[i].checked) {
				return i;
			}
		}
		return null;
	}

	function chg(rowid) {
		chgTableColor(rowid, 'yellow');
	}
	function chgTableColor(rowid, chgcolor) {
		$('#reportTable tr').css("background-color", "");
		for (var i = 0; i < $('#reportTable tr').length; i++) {
			if (i == rowid) {
				$('#reportTable tr:rowindex:eq(' + i + ')').css("background-color", "#8dc5fc");
			}
		}
	}
	function clearTableColor() {
		$('#reportTable tr').css("background-color", "");
	}

	function searchDate(id, constructionIdx) {
		var role = ${sessionInfo.role};
		var jb = $('#startDate').val();
		var endDate = $('#endDate').val();
		var paramId = ${param.id};
		if (jb == '') {
			alert('날짜를 입력하세요.');
		}else{
			$('#id').val(id);
			$('#constructionIdx').val(constructionIdx);
			
			alert('id : ' + $('#id').val());
			alert('constructionIdx : ' + $('#constructionIdx').val());
			
			//$('#searchForm').submit();
		} 
		//else {
		//	if(role == 1){
		//		location.href = '${pageContext.request.contextPath}/report/list?id='+ id + '&startDate=' + jb + '&endDate=' + endDate + '&constructionIdx=${sessionInfo.constructionIdx}';
		//	}else{
		//		location.href = '${pageContext.request.contextPath}/report/list?id='+ id + '&startDate=' + jb + '&endDate=' + endDate + '&constructionIdx=${param.constructionIdx}';
		//	}
		//	
		//}
	}

	function downloadExcel() {
		//$("#searchForm").attr("action","${pageContext.request.contextPath}/report/download/excel").submit();

		
		var para = document.location.href.split("?");
		location.href = '${pageContext.request.contextPath}/report/download/excel?' + para[1];
		
	}

	function doChecked(rowindex) {

	}
	
	function goAllReport(context, id, type, constructionIdx){
		alert('id : ' + id);
		$('#id').val(id);
		$('#type').val('all');
		$('#constructionIdx').val(constructionIdx);
		$('#searchForm').submit();
		
	}
	
	
	function goTodayAllReport(context, id, date, constructionIdx){
		$('#id').val(id);
		$('#date').val('today');
		$('#constructionIdx').val(constructionIdx);
		$('#searchForm').submit();
	}
</script>
<div class="right_content">
	<div class="tab_menu">
		<ul>
			<li class="on">
				${device.machineNumber} 시공현황 
			</li>
			<li>
				<%-- <a href="${pageContext.request.contextPath}/ips/list?deviceIdx=${param.id}&constructionIdx=${param.constructionIdx}">
					투입인원현황
				</a> --%>
				<a href="#">
					투입인원현황
				</a>
			</li>
			<li>
				<%-- <a href="${pageContext.request.contextPath}/eus/list?deviceIdx=${param.id}&constructionIdx=${param.constructionIdx}&erpDiv=1">
					장비사용현황
				</a> --%>
				<a href="#">
					장비사용현황
				</a>
			</li>
			<li>
				<%-- <a href="${pageContext.request.contextPath}/oiluse/list?deviceIdx=${param.id}&constructionIdx=${param.constructionIdx}&erpDiv=2">
					유류사용현황
				</a> --%>
				<a href="#">
					유류사용현황
				</a>
			</li>
			<li>
				<%-- <a href="${pageContext.request.contextPath}/mis/list?deviceIdx=${param.id}&constructionIdx=${param.constructionIdx}&erpDiv=3">
					
				</a> --%>
				<a href="#">
					항타자재현황
				</a>
			</li>
		</ul>
	</div>
	<!--table01_content-->
	<div class="table01_content">
		<!--search_div-->
		<div class="search_div">
			<div style="width: 100%;  height: auto; overflow: hidden;">
				<form:form id="searchForm" commandName="domainParam" method="POST" action="${pageContext.request.contextPath}/report/list">
				<form:hidden path="currentPage"/>
				<form:hidden path="type"/>
				<form:hidden path="mode"/>
				<form:hidden path="date"/>
				<form:hidden path="constructionIdx"/>
				<div  style="float: left; height: 100%; margin-top:20px;" class="input01">
					<font color="white" size="6">총시공량 ${totalConstruction} 공</font> 
				</div>
				<div class="search_form01" style="float: right; ">
					<c:choose>
						<c:when test="${sessionInfo.role == 1}">
							<!--  <input type="button" class="input01" value="총작업내역" onclick="goUrl('${pageContext.request.contextPath}/report/list?id=${param.id}&type=all&constructionIdx=${sessionInfo.constructionIdx}');">
							<input type="button" class="input01" value="금일작업내역" onclick="goUrl('${pageContext.request.contextPath}/report/list?id=${param.id}&date=today&constructionIdx=${sessionInfo.constructionIdx}');">-->
							
							<input type="button" class="input01" value="총작업내역1" onclick="goAllReport('${pageContext.request.contextPath}', '${param.id}','all','${sessionInfo.constructionIdx}');">
							<input type="button" class="input01" value="금일작업내역" onclick="goTodayAllReport('${pageContext.request.contextPath}', '${param.id}','all','${sessionInfo.constructionIdx}');">
						</c:when>
						<c:otherwise>
							<input type="button" class="input01" value="총작업내역2" onclick="goAllReport('${pageContext.request.contextPath}','${param.id}','all','${param.constructionIdx}');">
							<input type="button" class="input01" value="금일작업내역" onclick="goTodayAllReport('${pageContext.request.contextPath}','${param.id}','today','${param.constructionIdx}');">
						</c:otherwise>
					</c:choose>
					<input type="text" class="input01" id="startDate" name="startDate" value=""><span>~</span><input type="text" class="input01" id="endDate" name="endDate" value="">
					<c:choose>
						<c:when test="${sessionInfo.role == 1}">
							<input type="button" class="input01" value="일자별검색1" onclick="javascript:searchDate('${param.id}', '${sessionInfo.constructionIdx}');">
						</c:when>
						<c:otherwise>
							<input type="button" class="input01" value="일자별검색2" onclick="javascript:searchDate('${param.id}','${param.constructionIdx}');">
						</c:otherwise>
					</c:choose>
						
					
					
					
				</div>
				
			</div>
			</form:form>
		</div>
		<!--search_div end-->
		<!--table 리스트-->
		
		<div id="aa" class="table_list" style="overflow-y: hidden; overflow-x: hidden; overflow-y:scroll;">
			<table  class="table01">
				<tr>
					<th style="width: 20%;">시공일</th>
					<th style="width: 20%;">금일시공량</th>
					<th style="width: 20%;">&nbsp;</th>
					<!-- <th style="width: 20%;">금일누적시공량</th> -->
					<th style="width: 20%;">&nbsp;</th>
					<th style="width: 20%;">&nbsp;</th>
				</tr>
			</table>
		</div>
			
		
		<!-- <div class="table_list"  > -->
		<div id="bb" class="table_list" style="overflow-y:scroll;" onScroll="javascript:document.all.aa.scrollLeft = document.all.bb.scrollLeft">
			<table class="table01" id="reportTable"  name="reportTable" >
				<c:forEach var="domain" items="${domainList}"  varStatus="status">
					<tr style="background: white;">
								<td  style="width: 20%;">
									<c:choose>
										<c:when test="${sessionInfo.role == 0}">
											${domain.currentDateTime} <input type="button" value="기록지확인"  onclick="location.href='${pageContext.request.contextPath}/report/list?id=${param.id}&date=${domain.currentDateTime}&constructionIdx=${param.constructionIdx}'"/>
										</c:when>
										<c:when test="${sessionInfo.role == 1}">
											${domain.currentDateTime} <input type="button" value="기록지확인"  onclick="location.href='${pageContext.request.contextPath}/report/list?id=${param.id}&date=${domain.currentDateTime}&constructionIdx=${sessionInfo.constructionIdx}'"/>
										</c:when>
										<c:when test="${sessionInfo.role == 2}">
											${domain.currentDateTime} <input type="button" value="기록지확인"  onclick="location.href='${pageContext.request.contextPath}/report/list?id=${param.id}&date=${domain.currentDateTime}&constructionIdx=${param.constructionIdx}'"/>
										</c:when>
										<c:when test="${sessionInfo.role == 3}">
											${domain.currentDateTime} <input type="button" value="기록지확인"  onclick="location.href='${pageContext.request.contextPath}/report/list?id=${param.id}&date=${domain.currentDateTime}&constructionIdx=${param.constructionIdx}'"/>
										</c:when>
									</c:choose>		
								</td>
								<td  style="width: 20%;">
									${domain.todayConstruction} 공
								</td>
								<td  style="width: 20%;">
									&nbsp;
								</td>
								<td  style="width: 20%;">
									&nbsp;
								</td>
								<td  style="width: 20%;">
									&nbsp;
								</td>
							</tr>
							<c:choose>
								<c:when test="${fn:length(domainList) == 0}">
									<tr>
										<c:choose>
											<c:when test="${sessionInfo.role == 0}">
												<td colspan="5">등록된 데이터가 없습니다.</td>
											</c:when>
											<c:otherwise>
												<td colspan="5">등록된 데이터가 없습니다.</td>
											</c:otherwise>
										</c:choose>
										
									</tr>
								</c:when>
							</c:choose>
					</c:forEach>
					<c:choose>
						<c:when test="${fn:length(domainList) == 0}">
							<tr>
							<c:choose>
								<c:when test="${sessionInfo.role == 0}">
									<td style="background: white;" colspan="28">등록된 데이터가 없습니다.</td>
								</c:when>
								<c:otherwise>
									<td style="background: white;" colspan="28">등록된 데이터가 없습니다.</td>
								</c:otherwise>
							</c:choose>
							</tr>
						</c:when>
					</c:choose>
				</table>
			</div>
		<%@ include file="/WEB-INF/views/common/pagination.jsp" %>
		<!--페이지 넘버end-->
	</div>
	<!--table01_content end-->
</div>
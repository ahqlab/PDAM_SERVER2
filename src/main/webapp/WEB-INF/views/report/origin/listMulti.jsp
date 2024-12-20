<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/tagLib.jsp" %>
<script>
$(document).ready( function() {
    $('#submitBtn').click( function() {
    	searchForm();
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
     
     //setChart();
});

	function goUrl(url){
		document.location.href=url;
	}

	function doRestoreMulti(){
		
		var deleteCd = 0;
		
		var reports = [];
		
	
		for (var i = 0; i < $('#reportTable tr').length; i++) {
			//삭제되지 않은 경우 넘긴다.
			if($('#reportTable tr').eq(i).find('#isDel').val() == deleteCd){
				continue;
			}
			//check box 선택여부
			if (!$('#reportTable tr').eq(i).find('#selectOne').is(':checked')) {
				continue;
			}
	
			var data = {
					id: Number($('#reportTable tr').eq(i).find('#id').val())
	        };
	
			reports.push(data);
		}
		
		if(reports.length == 0){
			alert('선택된 항목이 없습니다.');
			reports = [];
			return;
		}
		
		var result = confirm("삭제된 항목을 복구하시겠습니까?");
		if(result){
			jQuery.ajax({
				type : "POST",
				url : "${pageContext.request.contextPath}/report/doRestoreMulti",
				data: JSON.stringify(reports), 
				dataType : "JSON", // 옵션이므로 JSON으로 받을게 아니면 안써도 됨
				contentType : "application/json",
				success : function(data) {
					if(data == true){
						alert('복구되었습니다.');
						//history.go(0);
						//searchForm();
						pageReload();
					}
				},
				complete : function(data) {
				},
				error : function(xhr, status, error) {
					searchForm();
				}
			});
		} 
	}

	function doDeleteMulti(){
		
		var deleteCd = 1;
		var reports = [];
		
		for (var i = 0; i < $('#reportTable tr').length; i++) {
			//삭제되지 않은 경우 넘긴다.
			if($('#reportTable tr').eq(i).find('#isDel').val() == deleteCd){
				continue;
			}
			//check box 선택여부
			if (!$('#reportTable tr').eq(i).find('#selectOne').is(':checked')) {
				continue;
			}
	
			var data = {
					id: Number($('#reportTable tr').eq(i).find('#id').val()),
					isDuple: Number($('#reportTable tr').eq(i).find('#isDuple').val()) 
	        };
	
			reports.push(data);
		}
		
		if(reports.length == 0){
			alert('선택된 항목이 없습니다.');
			reports = [];
			return;
		}
		
		var result = confirm("정말 삭제하시겠습니까? 삭제 시 기록은 저장되지 않으며 복구할 수 없습니다.");
		if(result){
			jQuery.ajax({
				type : "POST",
				url : "${pageContext.request.contextPath}/report/doDeleteMulti",
				data: JSON.stringify(reports), 
				dataType : "JSON", // 옵션이므로 JSON으로 받을게 아니면 안써도 됨
				contentType : "application/json",
				success : function(data) {
					if(data == true){
						alert('삭제되었습니다.');
						//searchForm();
						pageReload();
					}
				},
				complete : function(data) {
				},
				error : function(xhr, status, error) {
				}
			});
		} 
	}

	function onClickReportUpdate(){
		
		var deleteCd = 1;
		
		var reports = [];
		var role = ${sessionInfo.role};
		
		for (var i = 0; i < $('#reportTable tr').length; i++) {
			//삭제여부
			if($('#reportTable tr').eq(i).find('#isDel').val() == deleteCd){
				continue;
			}
			//check box 선택여부
			if (!$('#reportTable tr').eq(i).find('#selectOne').is(':checked')) {
				continue;
			}
			
			var piece = document.getElementsByName("piece[" + i + "]");
			var pieceId = document.getElementsByName("pieceId[" + i + "]");
			var pieceName = document.getElementsByName("pieceName[" + i + "]");
			
			if(role == 0){
				var penetrations = document.getElementsByName("penetrations[" + i + "]");
				var penetrationsId = document.getElementsByName("penetrationsId[" + i + "]");
				var penetrationsName = document.getElementsByName("penetrationsName[" + i + "]");
			}
			
			var pieces = [];
			
			for(var j=0; j<piece.length; j++){
				var onePiece = {
						name: pieceName[j].value != "" ? pieceName[j].value : "null",
						value : piece[j].value != "" ? 	piece[j].value : "0",
						id : Number(pieceId[j].value) != Number(0) ? Number(pieceId[j].value) : Number(0),
						reportIdx :Number(id[i].value)
				};
				pieces.push(onePiece);	
			}
			if(role == 0){
				var penetrationss = [];
				for(var k=0; k<penetrations.length; k++){
					if(penetrations[k].value != ""){
						var onePenetrations = {
								name: penetrationsName[k].value != "" ? penetrationsName[k].value : "null",
								value : penetrations[k].value != "" ? 	penetrations[k].value : "0",
								id : Number(penetrationsId[k].value) != Number(0) ? Number(penetrationsId[k].value) : Number(0),
								reportIdx :Number(id[i].value)
						};
						penetrationss.push(onePenetrations);
					}
				}
			}
			
			 if(role == 0){
				var data = {
						id: Number($('#reportTable tr').eq(i).find('#id').val()), 
						deviceIdx: Number($('#reportTable tr').eq(i).find('#deviceIdx').val()), 
						pileType: $('#reportTable tr').eq(i).find('#pileType').val() != "" ? $('#reportTable tr').eq(i).find('#pileType').val() : "null", 
						method: $('#reportTable tr').eq(i).find('#method').val() != "" ? $('#reportTable tr').eq(i).find('#method').val() : "null", 
						location: $('#reportTable tr').eq(i).find('#location').val() != "" ? $('#reportTable tr').eq(i).find('#location').val() : "null", 
						pileNo: $('#reportTable tr').eq(i).find('#pileNo').val() != "" ? $('#reportTable tr').eq(i).find('#pileNo').val() : "null", 
						pileStandard: $('#reportTable tr').eq(i).find('#pileStandard').val() != "" ? $('#reportTable tr').eq(i).find('#pileStandard').val() : "null", 
						piece: pieces, 
						penetrations : penetrationss, 
						drillingDepth: $('#reportTable tr').eq(i).find('#drillingDepth').val() != "" ? $('#reportTable tr').eq(i).find('#drillingDepth').val()  : "0", 
						intrusionDepth: $('#reportTable tr').eq(i).find('#intrusionDepth').val() != "" ? $('#reportTable tr').eq(i).find('#intrusionDepth').val()  : "0", 
						hammaT: $('#reportTable tr').eq(i).find('#hammaT').val() != "" ? $('#reportTable tr').eq(i).find('#hammaT').val()  : "0",
						fallMeter: $('#reportTable tr').eq(i).find('#fallMeter').val() != "" ? $('#reportTable tr').eq(i).find('#fallMeter').val() : "0",
						managedStandard: $('#reportTable tr').eq(i).find('#managedStandard').val() != "" ? $('#reportTable tr').eq(i).find('#managedStandard').val()  : "0"
						, totalPenetrationValue : $('#reportTable tr').eq(i).find('#totalPenetrationValue').val() != "" ? $('#reportTable tr').eq(i).find('#totalPenetrationValue').val()  : "0"
						, avgPenetrationValue : $('#reportTable tr').eq(i).find('#avgPenetrationValue').val() != "" ? $('#reportTable tr').eq(i).find('#avgPenetrationValue').val()  : "0"
						, crossSection : $('#reportTable tr').eq(i).find('#crossSection').val() != "" ? $('#reportTable tr').eq(i).find('#crossSection').val()  : "0"
						, bigo : $('#reportTable tr').eq(i).find('#bigo').val() != "" ? $('#reportTable tr').eq(i).find('#bigo').val()  : "null"
						, sprCol1 : $('#reportTable tr').eq(i).find('#sprCol1').val() != "" ? $('#reportTable tr').eq(i).find('#sprCol1').val()  : "null"
						, hammaEfficiency : $('#reportTable tr').eq(i).find('#hammaEfficiency').val() != "" ? $('#reportTable tr').eq(i).find('#hammaEfficiency').val()  : "0"
						, modulusElasticity : $('#reportTable tr').eq(i).find('#modulusElasticity').val() != "" ? $('#reportTable tr').eq(i).find('#modulusElasticity').val()  : "0"
					//,	ultimateBearingCapacity : ultimateBearingCapacity[index].value
		        };
			}else{
				var data = {
						id: Number($('#reportTable tr').eq(i).find('#id').val()), 
						deviceIdx: Number($('#reportTable tr').eq(i).find('#deviceIdx').val()), 
						pileType: $('#reportTable tr').eq(i).find('#pileType').val() != "" ? $('#reportTable tr').eq(i).find('#pileType').val() : "null", 
						method: $('#reportTable tr').eq(i).find('#method').val() != "" ? $('#reportTable tr').eq(i).find('#method').val() : "null", 
						location: $('#reportTable tr').eq(i).find('#location').val() != "" ? $('#reportTable tr').eq(i).find('#location').val() : "null", 
						pileNo: $('#reportTable tr').eq(i).find('#pileNo').val() != "" ? $('#reportTable tr').eq(i).find('#pileNo').val() : "null", 
						pileStandard: $('#reportTable tr').eq(i).find('#pileStandard').val() != "" ? $('#reportTable tr').eq(i).find('#pileStandard').val() : "null", 
						piece: pieces, 
						drillingDepth: $('#reportTable tr').eq(i).find('#drillingDepth').val() != "" ? $('#reportTable tr').eq(i).find('#drillingDepth').val()  : "0", 
						intrusionDepth: $('#reportTable tr').eq(i).find('#intrusionDepth').val() != "" ? $('#reportTable tr').eq(i).find('#intrusionDepth').val()  : "0", 
						hammaT: $('#reportTable tr').eq(i).find('#hammaT').val() != "" ? $('#reportTable tr').eq(i).find('#hammaT').val()  : "0",
						fallMeter: $('#reportTable tr').eq(i).find('#fallMeter').val() != "" ? $('#reportTable tr').eq(i).find('#fallMeter').val() : "0",
						managedStandard: $('#reportTable tr').eq(i).find('#managedStandard').val() != "" ? $('#reportTable tr').eq(i).find('#managedStandard').val()  : "0"
						, totalPenetrationValue : $('#reportTable tr').eq(i).find('#totalPenetrationValue').val() != "" ? $('#reportTable tr').eq(i).find('#totalPenetrationValue').val()  : "0"
						, avgPenetrationValue : $('#reportTable tr').eq(i).find('#avgPenetrationValue').val() != "" ? $('#reportTable tr').eq(i).find('#avgPenetrationValue').val()  : "0"
						, crossSection : $('#reportTable tr').eq(i).find('#crossSection').val() != "" ? $('#reportTable tr').eq(i).find('#crossSection').val()  : "0"
						, bigo : $('#reportTable tr').eq(i).find('#bigo').val() != "" ? $('#reportTable tr').eq(i).find('#bigo').val()  : "null"
						, sprCol1 : $('#reportTable tr').eq(i).find('#sprCol1').val() != "" ? $('#reportTable tr').eq(i).find('#sprCol1').val()  : "null"
						, hammaEfficiency : $('#reportTable tr').eq(i).find('#hammaEfficiency').val() != "" ? $('#reportTable tr').eq(i).find('#hammaEfficiency').val()  : "0"
						, modulusElasticity : $('#reportTable tr').eq(i).find('#modulusElasticity').val() != "" ? $('#reportTable tr').eq(i).find('#modulusElasticity').val()  : "0"
					//,	ultimateBearingCapacity : ultimateBearingCapacity[index].value
		        };
			} 
			reports.push(data);
		}
	
		if(reports.length == 0){
			alert('선택된 항목이 없습니다.');
			reports = [];
			return;
		}
		
		var result = confirm("수정하시겠습니까?");
		if(result){
			jQuery.ajax({
				type : "POST",
				url : "${pageContext.request.contextPath}/report/update/reportMulti",
				data: JSON.stringify(reports), 
				dataType : "JSON", // 옵션이므로 JSON으로 받을게 아니면 안써도 됨
				contentType : "application/json",
				success : function(data) {
					if(data == true){
						//searchForm();
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

	function doClose(rowindex){
		
			
		var role = ${sessionInfo.role};
		var obj = document.getElementsByName("selectOne");
		var index = rowindex;
		
		
		var id = $('#reportTable').find("#id");
		var pileType = document.getElementsByName("pileType");
		var method = document.getElementsByName("method");
		var location = $('#reportTable').find("#location");
		var pileNo = $('#reportTable').find("#pileNo");
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
		var sprCol1 = document.getElementsByName("sprCol1");
		
	
		$('#reportTable tr:eq(' + index + ')').css("background-color", "white");
		
		var piece = document.getElementsByName("piece[" + index + "]");
		
		if(role == 0){
			var pntrs = document.getElementsByName("penetrations[" + index + "]");	
		}
		
		for (var y = 0; y < piece.length; y++) {
			piece[y].disabled = true;
		}
		if(role == 0){
			for (var l = 0; l < pntrs.length; l++) {
				pntrs[l].disabled = true;
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
		sprCol1[index].disabled = true;
			
		
		
	}
	function doOpen(rowindex){


		var deleteCd = 1;		
		var role = ${sessionInfo.role};
		var obj = document.getElementsByName("selectOne");
		var index = rowindex;
		
		
		var id = $('#reportTable').find("#id");
		var pileType = document.getElementsByName("pileType");
		var method = document.getElementsByName("method");
		var location = $('#reportTable').find("#location");
		var pileNo = $('#reportTable').find("#pileNo");
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
		var sprCol1 = document.getElementsByName("sprCol1");
		
	
		$('#reportTable tr:eq(' + index + ')').css("background-color", "#8dc5fc");
		
		var piece = document.getElementsByName("piece[" + index + "]");
		
		if(role == 0){
			var pntrs = document.getElementsByName("penetrations[" + index + "]");	
		}
		
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
		sprCol1[index].disabled = false;
		
	}

	function doOpenCheck(chk, rowindex) {
		var index = getCheckdCheckboxIndex();
		
		var total = $("input[name=selectOne]").length;
		var checked = $("input[name=selectOne]:checked").length;
		
		if(total != checked){
			$("#chkAll").prop("checked", false);
		}else{
			$("#chkAll").prop("checked", true); 
		}
		
		
		var deleteCd = 1;		
		var role = ${sessionInfo.role};
		var obj = document.getElementsByName("selectOne");
		var index = rowindex;
		
		
		var id = $('#reportTable').find("#id");
		var pileType = document.getElementsByName("pileType");
		var method = document.getElementsByName("method");
		var location = $('#reportTable').find("#location");
		var pileNo = $('#reportTable').find("#pileNo");
		var isDel = $('#reportTable').find("#isDel");
		var pileStandard = document.getElementsByName("pileStandard");

		var drillingDepth = document.getElementsByName("drillingDepth");
		var intrusionDepth = document.getElementsByName("intrusionDepth");
		var hammaT = document.getElementsByName("hammaT");
		var fallMeter = document.getElementsByName("fallMeter");
		var managedStandard = document.getElementsByName("managedStandard");
		
		var crossSection = document.getElementsByName("crossSection");
		var hammaEfficiency = document.getElementsByName("hammaEfficiency");
		var modulusElasticity = document.getElementsByName("modulusElasticity");
		var bigo = document.getElementsByName("bigo");
		var sprCol1 = document.getElementsByName("sprCol1");
		
		var selectIsDel = Number($("input[name=isDel]").eq(index).val());
		if(selectIsDel == deleteCd){
			return;
		}
		
		if(obj[index].checked){
			
			$('#reportTable tr:eq(' + index + ')').css("background-color", "#8dc5fc");
			
			var piece = document.getElementsByName("piece[" + index + "]");
			
			if(role == 0){
				var pntrs = document.getElementsByName("penetrations[" + index + "]");	
			}
			
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
			sprCol1[index].disabled = false;
			
		}else{
			
			
			$('#reportTable tr:eq(' + index + ')').css("background-color", "white");
			
			var piece = document.getElementsByName("piece[" + index + "]");
			
			if(role == 0){
				var pntrs = document.getElementsByName("penetrations[" + index + "]");	
			}
			
			for (var y = 0; y < piece.length; y++) {
				piece[y].disabled = true;
			}
			if(role == 0){
				for (var l = 0; l < pntrs.length; l++) {
					pntrs[l].disabled = true;
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
			sprCol1[index].disabled = true;
			
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

	function searchDate() {
		var role = ${sessionInfo.role};
		var jb = $('#startDate').val();
		var endDate = $('#endDate').val();
		var id = ${param.id};
		if (jb == '') {
			alert('날짜를 입력하세요.');
		} else {
			searchForm();
		}
	}

	function downloadExcel() {
		
		var type = '${param.type}';
		if(type != 'all'){
			var para = document.location.href.split("?");
			location.href = '${pageContext.request.contextPath}/report/origin/download/excel?' + para[1];
		}else{
			$("#searchForm").attr("action", "${pageContext.request.contextPath}/report/origin/download/excel");
			$("#searchForm").submit();
			$("#searchForm").attr("action", "");
		}
	}
	
	function searchForm(){
		$('#currentPage').val(1);
		$("#searchForm").attr("action", "");
		$("#searchForm").submit();
	}
	
	
	function pageReload(){
		document.location.replace("");
	}

	function doChecked(rowindex) {

	}
	
	function onClickChkAll(){
		if($("#chkAll").is(":checked")){
			$("input[name=selectOne]").prop("checked", true);
			for (var i = 0; i < $('#reportTable tr').length; i++) {
				doOpen(i);
			}
		} else {
			$("input[name=selectOne]").prop("checked", false);
			for (var i = 0; i < $('#reportTable tr').length; i++) {
				doClose(i);
			}
		}
	}

</script>
<!--컨텐츠-->
<div class="section-right">

	<div class="TopContArea">
		<div class="titArea mb-40">
			<p class="h1Tit">${device.machineNumber} 시공현황</p>
			<div class="titBtnArea">
				<c:choose>
					<c:when test="${sessionInfo.role == 1}">
						<div class="printBtn02" onclick="goUrl('${pageContext.request.contextPath}/report/origin/list?id=${param.id}&type=all&constructionIdx=${sessionInfo.constructionIdx}');">총 작업내역</div>
						<div class="printBtn" onclick="goUrl('${pageContext.request.contextPath}/report/origin/list?id=${param.id}&date=today&constructionIdx=${sessionInfo.constructionIdx}');">금일작업내역</div>
						
					</c:when>
					<c:otherwise>
						<div class="printBtn02" onclick="goUrl('${pageContext.request.contextPath}/report/origin/list?id=${param.id}&type=all&constructionIdx=${param.constructionIdx}');">총 작업내역</div>
						<div class="printBtn" onclick="goUrl('${pageContext.request.contextPath}/report/origin/list?id=${param.id}&date=today&constructionIdx=${param.constructionIdx}');">금일작업내역</div>
					</c:otherwise>
				</c:choose>
			</div>
		</div>

		<!--검색-->
		<form:form id="searchForm" commandName="domainParam" method="POST">
			<form:hidden path="currentPage"/>
			<div class="searchArea">
				<!--필요한 페이지에만 노출 시공/파일번호 검색 부분-->
				 <div class="searchArea01 type01">
					<form:input path="location" class="searchin" placeholder="시공 위치를 입력하세요."/>
					<form:input path="pileNo" class="searchin" placeholder="파일 번호를 입력하세요."/>
					<form:hidden path="mode" class="all"/>
					<c:choose>
						<c:when test="${sessionInfo.role == 1}">
							<input type="hidden" name="id" value="${param.id}"/>
							<input type="hidden" name="constructionIdx" value="${sessionInfo.constructionIdx}"/>
						</c:when>
						<c:otherwise>
							<input type="hidden" name="id" value="${param.id}"/>
							<input type="hidden" name="constructionIdx" value="${param.constructionIdx}"/>
						</c:otherwise>
					</c:choose>
					<div class="searchBtn">
						<img src="${pageContext.request.contextPath}/new/img/search.png" style="cursor:pointer;" onclick="javascript:searchForm();">
					</div>
				</div>
				<!--//필요한 페이지에만 노출-->
	
				<div class="searchArea02">
					<form:input path="startDate" class="inputDate datepicker" />
					<span>~</span>
					<form:input path="endDate" class="inputDate datepicker" />
				</div>
			</div>
		</form:form>
		<!--//검색-->
	</div>
	
	<div class="tableCArea">
		<c:choose>												 
			<c:when test="${sessionInfo.role == 0 || sessionInfo.hiddenManager == true || sessionInfo.role == 3}">
				<div class="btnType01" onclick="javascript:onClickReportUpdate();" style="visibility: hidden;">기록지 수정</div>
				<div class="btnType02 bg02" onclick="javascript:downloadExcel();">엑셀 출력</div>
			</c:when>
			<c:otherwise>
				<div class="btnType01" onclick="javascript:onClickReportUpdate();" style="visibility: hidden;">기록지 수정</div>
				<div class="btnType02 bg02" onclick="javascript:downloadExcel();">엑셀 출력</div>
			</c:otherwise>
		</c:choose>
		
	</div>
	
	<div class="min485">
		<div class="tableArea">
			
			<div class="viewTable viewTable05">
				<table class="viewTh">
					<tr>
						<td rowspan="2">순번</td>
						<td rowspan="2">시공일</td>
						<td rowspan="2">파일종류</td>
						<td rowspan="2">시공공법</td>
						<td rowspan="2">시공위치</td>
						<td rowspan="2">파일번호</td>
						<td rowspan="2">파일규격</td>
						<td colspan="6">파일구분</td>
						
						<td rowspan="2">이음(개소)</td>
						
						
						<c:choose>
							<c:when test="${sessionInfo.constructionIdx == 944 or param.constructionIdx == 944}">
								<td rowspan="2">경타길이(M)</td>
								<td rowspan="2">천공깊이(M)</td>
							</c:when>
							<c:otherwise>
								<td rowspan="2">천공깊이(M)</td>
								<td rowspan="2">관입깊이(M)</td>
							</c:otherwise>
						</c:choose>
						
						
						<td rowspan="2">파일잔량(M)</td>
						<td rowspan="2">공삭공(M)</td>
						<td rowspan="2">드롭헤머(Ton)</td>
						<td rowspan="2">낙하높이(m)</td>
						<td rowspan="2">관리기준(mm)</td>
						<td rowspan="2">1회측정(mm)</td>
						<td rowspan="2">2회측정(mm)</td>
						<td rowspan="2">3회측정(mm)</td>
						<td rowspan="2">4회측정(mm)</td>
						<td rowspan="2">5회측정(mm)</td>
						
						<c:choose>
							<c:when test="${isBig == true}">
								<td rowspan="2">6회측정(mm)</td>
								<td rowspan="2">7회측정(mm)</td>
								<td rowspan="2">8회측정(mm)</td>
								<td rowspan="2">9회측정(mm)</td>
								<td rowspan="2">10회측정(mm)</td>
							</c:when>
						</c:choose>
						<td rowspan="2">평균관입(mm)</td>
						<td rowspan="2">최종관입(mm)</td>
						
						<c:choose>
							<c:when test="${sessionInfo.role == 0}">
								<td rowspan="2">극한지지력<br>(kN)</td>
							</c:when>
						</c:choose>
						
						<c:choose>
						<c:when test="${sessionInfo.role > 0}">
							<td rowspan="2">헤머효율(%)</td>
							<td rowspan="2">탄성계수(t/cm2)</td>
							<td rowspan="2">파일단면적(cm2)</td>
							<td rowspan="2">비고</td>
							<c:choose>
								<c:when test="${param.constructionIdx == 492}">
									<td rowspan="2">메모</td>
								</c:when>
							</c:choose>
						</c:when>
						</c:choose>
						<c:choose>
							<c:when test="${sessionInfo.role == 0}">
								<td rowspan="2">헤머효율(%)</td>
								<td rowspan="2">탄성계수(t/cm2)</td>
								<td rowspan="2">파일단면적(cm2)</td>
								<td rowspan="2">비고</td>
								<td rowspan="2">메모</td>
							</c:when>
						</c:choose>
					</tr>	
					<tr>
						<td>단본(M)</td>
						<td>하단(M)</td>
						<td>중단(M)</td>
						<td>중단(M)</td>
						<td>상단(M)</td>
						<td>합계(M)</td>
					</tr>
				</table>
				
				<div class="tableScroll">
					<table id="reportTable" name="reportTable">
						<c:forEach var="domain" items="${domainList}"  varStatus="status">
						<!--  리스트에서 해당 줄 옆에 램프 키기 : tr에 클래스 lampOn(빨간색) 또는 lampOn-b(파란색)  추가 -->
							<c:choose>
								<c:when test="${domain.isDel == 1}">
									<tr class="lampOn" >
									<!-- onclick="doRowClick(this.rowIndex);" -->
								</c:when>
								<c:otherwise>
									<c:choose>
										<c:when test="${domain.duplicated > 1}">
											<tr class="lampOn-b">
											<!-- onclick="doRowClick(this.rowIndex);" -->
										</c:when>
										<c:otherwise>
											<tr>
										</c:otherwise>
									</c:choose>
								</c:otherwise>
							</c:choose>
							<td>${domain.rownum}</td>
							<c:choose>
								<c:when test="${((sessionInfo.hiddenManager == true or sessionInfo.role == 0) and 
											(domain.deviceIdx eq 345 or 
											domain.deviceIdx eq 346 or 
											domain.deviceIdx eq 343 or 
											domain.deviceIdx eq 344 or 
											domain.deviceIdx eq 351)) or (domain.longCalYn == 1 and sessionInfo.hiddenManager == true) or sessionInfo.role == 0}">
									<td>
										
										<c:set var = "dateTime" value = "${domain.createDate}"/>
									    <c:set var = "length" value = "${fn:length(dateTime)}"/>
									    <c:set var = "newDateTime" value = "${fn:substring(dateTime, 0, length -2)}" />
										${newDateTime}
										<input type="hidden" id="id" name="id" value="${domain.id}" >
										<input type="hidden" id="isDel" name="isDel" value="${domain.isDel}" >
										<input type="hidden" id="isDuple" name="isDuple" value="${domain.isDuple}" >
										<input type="hidden" id="deviceIdx" name="deviceIdx" value="${domain.deviceIdx}" >
										
									</td>
								</c:when>
								<c:otherwise>
									<td>
										${domain.currentDateTime}
										<input type="hidden" id="id" name="id" value="${domain.id}" >
										<input type="hidden" id="isDel" name="isDel" value="${domain.isDel}" >
										<input type="hidden" id="isDuple" name="isDuple" value="${domain.isDuple}" >
										<input type="hidden" id="deviceIdx" name="deviceIdx" value="${domain.deviceIdx}" >
									</td>
								</c:otherwise>				
							</c:choose>
							<td>
						 		<input type="text" id="pileType" name="pileType" disabled="disabled" class="tdInput" value="${domain.pileType}">
						 	</td>
							<td>
								<input type="text" id="method" name="method" disabled="disabled" class="tdInput" value="${domain.method}">
							</td>
							<td>
								<input type="text" id="location" name="location" disabled="disabled" class="tdInput" value="${domain.location}">
							</td>
							<td>
								<input type="text" id="pileNo" name="pileNo" disabled="disabled"  class="tdInput" value="${domain.pileNo}">
							</td>
							<td>
								<input type="text" id="pileStandard" name="pileStandard" disabled="disabled" class="tdInput" value="${domain.pileStandard}">
							</td>
							<c:choose>
								<c:when test="${fn:length(domain.piece) == 3}">
									<td>
										<input type="text" id="piece[${status.index}]" name="piece[${status.index}]"  disabled="disabled" class="tdInput"  value="${domain.piece[0].value}">
										<input type="hidden" id="pieceId[${status.index}]" name="pieceId[${status.index}]" value="${domain.piece[0].id}">
										<input type="hidden" id="pieceName[${status.index}]" name="pieceName[${status.index}]" value="${domain.piece[0].name}">
									</td>
									<td>
										<input type="text" id="piece[${status.index}]" name="piece[${status.index}]" disabled="disabled" class="tdInput" value="${domain.piece[1].value}">
										<input type="hidden" id="pieceId[${status.index}]" name="pieceId[${status.index}]" value="${domain.piece[1].id}">
										<input type="hidden" id="pieceName[${status.index}]" name="pieceName[${status.index}]" value="${domain.piece[1].name}">
									</td>
									<td>
										<input type="text" id="piece[${status.index}]" name="piece[${status.index}]" disabled="disabled" class="tdInput" value="">
										<input type="hidden" id="pieceId[${status.index}]" name="pieceId[${status.index}]" value="">
										<input type="hidden" id="pieceName[${status.index}]" name="pieceName[${status.index}]" value="">
									</td>
									<td>
										<input type="text" id="piece[${status.index}]" name="piece[${status.index}]" disabled="disabled" class="tdInput" value="">
										<input type="hidden" id="pieceId[${status.index}]" name="pieceId[${status.index}]" value="">
										<input type="hidden" id="pieceName[${status.index}]" name="pieceName[${status.index}]" value="">
									</td>
									<td>
										<input type="text" id="piece[${status.index}]" name="piece[${status.index}]" disabled="disabled" class="tdInput" value="${domain.piece[2].value}">
										<input type="hidden" id="pieceId[${status.index}]" name="pieceId[${status.index}]" value="${domain.piece[2].id}">
										<input type="hidden" id="pieceName[${status.index}]" name="pieceName[${status.index}]" value="${domain.piece[2].name}">
									</td>
								</c:when>
							</c:choose>
							<c:choose>
								<c:when test="${fn:length(domain.piece) == 4}">
									<td>
										<input type="text" id="piece[${status.index}]" name="piece[${status.index}]" disabled="disabled" class="tdInput" value="${domain.piece[0].value}">
										<input type="hidden" id="pieceId[${status.index}]" name="pieceId[${status.index}]" value="${domain.piece[0].id}">
										<input type="hidden" id="pieceName[${status.index}]" name="pieceName[${status.index}]" value="${domain.piece[0].name}">
									</td>
									<td>
										<input type="text" id="piece[${status.index}]" name="piece[${status.index}]" disabled="disabled" class="tdInput" value="${domain.piece[1].value}">
										<input type="hidden" id="pieceId[${status.index}]" name="pieceId[${status.index}]" value="${domain.piece[1].id}">
										<input type="hidden" id="pieceName[${status.index}]" name="pieceName[${status.index}]" value="${domain.piece[1].name}">
									</td>
									<td>
										<input type="text" id="piece[${status.index}]" name="piece[${status.index}]" disabled="disabled"  class="tdInput" value="${domain.piece[2].value}">
										<input type="hidden" id="pieceId[${status.index}]" name="pieceId[${status.index}]" value="${domain.piece[2].id}">
										<input type="hidden" id="pieceName[${status.index}]" name="pieceName[${status.index}]" value="${domain.piece[2].name}">
									</td>
									<td>
										<input type="text" id="piece[${status.index}]" name="piece[${status.index}]" disabled="disabled" class="tdInput" value="">
										<input type="hidden" id="pieceId[${status.index}]" name="pieceId[${status.index}]" value="">
										<input type="hidden" id="pieceName[${status.index}]" name="pieceName[${status.index}]" value="">
									</td>
									<td>
										<input type="text" id="piece[${status.index}]" name="piece[${status.index}]" disabled="disabled" class="tdInput" value="${domain.piece[3].value}">
										<input type="hidden" id="pieceId[${status.index}]" name="pieceId[${status.index}]" value="${domain.piece[3].id}">
										<input type="hidden" id="pieceName[${status.index}]" name="pieceName[${status.index}]" value="${domain.piece[3].name}">
									</td>
								</c:when>
							</c:choose>
							<c:choose>
								<c:when test="${fn:length(domain.piece) >= 5}">
									<td >
										<input type="text" id="piece[${status.index}]" name="piece[${status.index}]" disabled="disabled"  class="tdInput" value="${domain.piece[0].value}">
										<input type="hidden" id="pieceId[${status.index}]" name="pieceId[${status.index}]" value="${domain.piece[0].id}">
										<input type="hidden" id="pieceName[${status.index}]" name="pieceName[${status.index}]" value="${domain.piece[0].name}">
									</td>
									<td >
										<input type="text" id="piece[${status.index}]" name="piece[${status.index}]" disabled="disabled" class="tdInput" value="${domain.piece[1].value}">
										<input type="hidden" id="pieceId[${status.index}]" name="pieceId[${status.index}]" value="${domain.piece[1].id}">
										<input type="hidden" id="pieceName[${status.index}]" name="pieceName[${status.index}]" value="${domain.piece[1].name}">
									</td>
									<td>
										<input type="text" id="piece[${status.index}]" name="piece[${status.index}]" disabled="disabled" class="tdInput" value="${domain.piece[2].value}">
										<input type="hidden" id="pieceId[${status.index}]" name="pieceId[${status.index}]" value="${domain.piece[2].id}">
										<input type="hidden" id="pieceName[${status.index}]" name="pieceName[${status.index}]" value="${domain.piece[2].name}">
									</td>
									<td>
										<input type="text" id="piece[${status.index}]" name="piece[${status.index}]" disabled="disabled"  class="tdInput" value="${domain.piece[3].value}">
										<input type="hidden" id="pieceId[${status.index}]" name="pieceId[${status.index}]" value="${domain.piece[3].id}">
										<input type="hidden" id="pieceName[${status.index}]" name="pieceName[${status.index}]" value="${domain.piece[3].name}">
									</td>
									<td>
										<input type="text" id="piece[${status.index}]" name="piece[${status.index}]" disabled="disabled"  class="tdInput" value="${domain.piece[4].value}">
										<input type="hidden" id="pieceId[${status.index}]" name="pieceId[${status.index}]" value="${domain.piece[4].id}">
										<input type="hidden" id="pieceName[${status.index}]" name="pieceName[${status.index}]" value="${domain.piece[4].name}">
									</td>
								</c:when>
							</c:choose>
							<td>${domain.totalConnectWidth}</td>
							<td>
								${domain.connectLength}
							</td>
							<td><input type="text" id="drillingDepth" name="drillingDepth" disabled="disabled"  class="tdInput" value="${domain.drillingDepth}"/></td>
							<td><input type="text" id="intrusionDepth" name="intrusionDepth" disabled="disabled" class="tdInput"  value="${domain.intrusionDepth}"/></td>
							<td>${domain.balance}</td>
							<td>
								${domain.gongSac}
							</td>
							<td><input type="text" id="hammaT" name="hammaT"  disabled="disabled" class="tdInput" value="${domain.hammaT}"/></td>
							<td><input type="text" id="fallMeter" name="fallMeter"  disabled="disabled"  class="tdInput" value="${domain.fallMeter}"/></td>
							<td><input type="text" id="managedStandard" name="managedStandard"  disabled="disabled" class="tdInput" value="${domain.managedStandard}"/></td>
							
							<c:forEach var="i" begin="0" end="${isBig == true ? 9 : 4}">
								<c:choose>
									<c:when test="${sessionInfo.role == 0}">
										<td>
											<input type="text" id="penetrations[${status.index}]" name="penetrations[${status.index}]" 
												disabled="disabled"  class="tdInput"
												value="${domain.penetrations[i].value eq '0' ? '' : domain.penetrations[i].value}">
											<input type="hidden" id="penetrationsId[${status.index}]" name="penetrationsId[${status.index}]" value="${domain.penetrations[i].id}">
											<c:choose>
												<c:when test="${domain.penetrations[i].name != null}">
													<input type="hidden" id="penetrationsName[${status.index}]" name="penetrationsName[${status.index}]" value="${domain.penetrations[i].name}">	
												</c:when>
												<c:otherwise>
													<c:choose>
														<c:when test="${isBig == true}">
															<!-- 10회 -->
																<c:choose>
																	<c:when test="${i == 0}">
																		<input type="hidden" id="penetrationsName[${status.index}]" name="penetrationsName[${status.index}]" value="1회">	
																	</c:when>
																	<c:when test="${i == 1}">
																		<input type="hidden" id="penetrationsName[${status.index}]" name="penetrationsName[${status.index}]" value="2회">	
																	</c:when>
																	<c:when test="${i == 2}">
																		<input type="hidden" id="penetrationsName[${status.index}]" name="penetrationsName[${status.index}]" value="3회">	
																	</c:when>
																	<c:when test="${i == 3}">
																		<input type="hidden" id="penetrationsName[${status.index}]" name="penetrationsName[${status.index}]" value="4회">	
																	</c:when>
																	<c:when test="${i == 4}">
																		<input type="hidden" id="penetrationsName[${status.index}]" name="penetrationsName[${status.index}]" value="5회">				
																	</c:when>
																	<c:when test="${i == 5}">
																		<input type="hidden" id="penetrationsName[${status.index}]" name="penetrationsName[${status.index}]" value="6회">	
																	</c:when>
																	<c:when test="${i == 6}">
																		<input type="hidden" id="penetrationsName[${status.index}]" name="penetrationsName[${status.index}]" value="7회">	
																	</c:when>
																	<c:when test="${i == 7}">
																		<input type="hidden" id="penetrationsName[${status.index}]" name="penetrationsName[${status.index}]" value="8회">	
																	</c:when>
																	<c:when test="${i == 8}">
																		<input type="hidden" id="penetrationsName[${status.index}]" name="penetrationsName[${status.index}]" value="9회">	
																	</c:when>
																	<c:when test="${i == 9}">
																		<input type="hidden" id="penetrationsName[${status.index}]" name="penetrationsName[${status.index}]" value="10회">	
																	</c:when>
																</c:choose>
														
														</c:when>
														<c:otherwise>
															<!-- 5회 -->
																<c:choose>
																	<c:when test="${i == 0}">
																		<input type="hidden" id="penetrationsName[${status.index}]" name="penetrationsName[${status.index}]" value="1회">	
																	</c:when>
																	<c:when test="${i == 1}">
																		<input type="hidden" id="penetrationsName[${status.index}]" name="penetrationsName[${status.index}]" value="2회">	
																	</c:when>
																	<c:when test="${i == 2}">
																		<input type="hidden" id="penetrationsName[${status.index}]" name="penetrationsName[${status.index}]" value="3회">	
																	</c:when>
																	<c:when test="${i == 3}">
																		<input type="hidden" id="penetrationsName[${status.index}]" name="penetrationsName[${status.index}]" value="4회">	
																	</c:when>
																	<c:when test="${i == 4}">
																		<input type="hidden" id="penetrationsName[${status.index}]" name="penetrationsName[${status.index}]" value="5회">				
																	</c:when>
																</c:choose>
														</c:otherwise>
													</c:choose>
												</c:otherwise>
											</c:choose>
										</td>
									</c:when>
									<c:otherwise>
										<td>${domain.penetrations[i].value}</td> 
									</c:otherwise>
								</c:choose>											
							</c:forEach>
							<c:choose>
								<c:when test="${domain.managedStandard + 0 < domain.avgPenetrationValue + 0}">
									<td style="background-color: red; color: white;">
										${domain.avgPenetrationValue}
										<input type="hidden" id="avgPenetrationValue" name="avgPenetrationValue" value="${domain.avgPenetrationValue}" >
									</td>
								</c:when>
								<c:otherwise>
									<td>
										${domain.avgPenetrationValue}
										<input type="hidden" id="avgPenetrationValue" name="avgPenetrationValue" value="${domain.avgPenetrationValue}">
									</td>
								</c:otherwise>
							</c:choose>
							<td >
								${domain.totalPenetrationValue}
								<input type="hidden" id="totalPenetrationValue" name="totalPenetrationValue" value="${domain.totalPenetrationValue}" >
							</td>
							
							
							<c:choose>
								<c:when test="${sessionInfo.role == 0}">
									<td>
										${domain.ultimateBearingCapacity}
									</td>
								</c:when>
							</c:choose>
							
							
							<c:choose>
								<c:when test="${sessionInfo.role > 0}">
									<c:choose>
										<c:when test="${sessionInfo.hiddenManager == true  || sessionInfo.role == 3}">
											<td>
												<input type="text" class="tdInput" id="hammaEfficiency" name="hammaEfficiency"  disabled="disabled"  maxlength="10"  value="${domain.hammaEfficiency}"/>
											</td> 
											<td>
												<input type="text" class="tdInput" id="modulusElasticity" name="modulusElasticity"  disabled="disabled"  maxlength="10"  value="${domain.modulusElasticity}"/>
											</td> 
											<td>
												<input type="text" class="tdInput" id="crossSection" name="crossSection"  disabled="disabled" maxlength="10" value="${domain.crossSection}"/>
											</td> 
											<td>
												<input type="text" class="tdInput" id="bigo" name="bigo"  disabled="disabled"  maxlength="50" value="${domain.bigo}"/>
											</td>
											<c:choose>
												<c:when test="${param.constructionIdx == 492}">
														<td>
															<input type="text" class="tdInput" id="sprCol1" name="sprCol1"  disabled="disabled"  maxlength="50" value="${domain.sprCol1}"/>
														</td>
												</c:when>
												<c:otherwise>
														<input type="hidden" class="tdInput" id="sprCol1" name="sprCol1"  disabled="disabled"  maxlength="50" value="${domain.sprCol1}"/>
												</c:otherwise>
											</c:choose>
										</c:when>
										<c:otherwise>
											<td>
												<input type="text" id="hammaEfficiency" name="hammaEfficiency"   class="tdInput" disabled="disabled" maxlength="10" value="${domain.hammaEfficiency}"/>
											</td> 
											<td>
												<input type="text" id="modulusElasticity" name="modulusElasticity"   class="tdInput" disabled="disabled"  maxlength="10" value="${domain.modulusElasticity}"/>
											</td> 
											<td>
												<input type="text" id="crossSection" name="crossSection"   class="tdInput" disabled="disabled"  maxlength="10" value="${domain.crossSection}"/>
											</td> 
											<td>
												${domain.bigo}
												<input type="hidden" id="bigo" name="bigo"  disabled="disabled"   class="tdInput" maxlength="50" value="${domain.bigo}"/>
											</td>
											<c:choose>
												<c:when test="${param.constructionIdx == 492}">
														<td>
															${domain.sprCol1}
															<input type="hidden" id="sprCol1" name="sprCol1"   class="tdInput" disabled="disabled"  maxlength="50" value="${domain.sprCol1}"/>
														</td>
												</c:when>
											</c:choose>
										</c:otherwise>
									</c:choose>
								</c:when>
							</c:choose>
							
							<c:choose>
								<c:when test="${sessionInfo.role == 0}">
									<td>
										<input type="text" id="hammaEfficiency" name="hammaEfficiency"  disabled="disabled"  class="tdInput" value="${domain.hammaEfficiency}"/>
									</td> 
									<td>
										<input type="text" id="modulusElasticity" name="modulusElasticity"  disabled="disabled"  class="tdInput" value="${domain.modulusElasticity}"/>
									</td> 
									<td>
										<input type="text" id="crossSection" name="crossSection"  disabled="disabled" class="tdInput"  value="${domain.crossSection}"/>
									</td> 
									<td>
										<input type="text" id="bigo" name="bigo"  disabled="disabled" class="tdInput" value="${domain.bigo}"/>
									</td>
									<td>
										<input type="text" id="sprCol1" name="sprCol1"  disabled="disabled" class="tdInput" maxlength="50" value="${domain.sprCol1}"/>
									</td>
								</c:when>
								<c:otherwise>
									<%-- <input type="hidden" id="hammaEfficiency" name="hammaEfficiency"  disabled="disabled" value="${domain.hammaEfficiency}"/>
									<input type="hidden" id="modulusElasticity" name="modulusElasticity"  disabled="disabled"  value="${domain.modulusElasticity}"/>
									<input type="hidden" id="crossSection" name="crossSection"  disabled="disabled"  value="${domain.crossSection}"/> --%>
								</c:otherwise>
							</c:choose> 
						</tr>

						</c:forEach>
						<c:choose>
							<c:when test="${fn:length(domainList) == 0}">
								<tr>
								<c:choose>
									<c:when test="${sessionInfo.role == 0}">
										<td colspan="34">등록된 데이터가 없습니다.</td>
									</c:when>
									<c:otherwise>
										<td colspan="34">등록된 데이터가 없습니다.</td>
									</c:otherwise>
								</c:choose>
								</tr>
							</c:when>
						</c:choose>
					</table>
				</div>
			</div>
		</div>
	</div>

	<!--페이징-->			
	<%@ include file="/WEB-INF/views/common/pagination.jsp" %>
	<!--//페이징-->
	
	<!-- <div class="chartArea">
		<canvas id="barChart"></canvas>
	</div>

	<div class="chartArea">
		<canvas id="lineChart"></canvas>
	</div> -->
	
</div>
<!--//컨텐츠-->


<!-- 팝업 -->
<script>
$('.popUp').hide();
$('.popLayer').hide();

$('.popBtn, .tableChange').on('click', function(e){
	$('.popUp').show();
	$('.popLayer').show();
	$('body').css('overflow', 'hidden');
});

$('.popClose').on('click', function(e){
	$('.popUp').hide();
	$('.popLayer').hide();
	$('body').css('overflow', 'auto');
});
</script>
<!-- //팝업 -->




<script>
  $( function() {
    $(".datepicker").datepicker();
  } );
  </script>

<script>
$(document).ready(function() {
	$(".navBtn").click(function() {
		$(".left-menu").animate({
			"left": "0%"
		}, 500);
	});
	$(".m-closeBtn").click(function() {
		$(".left-menu").animate({
			"left": "-150%"
		}, 500);
	});
});

$('.mlist a').on('click', function(e){
	var tg = $(this).next('.sub-menu');
	if(tg.length>0){
	if($(this).hasClass('isOpen')){
		tg.slideUp('fast');
	$(this).removeClass('isOpen');
	} else{
		if($('.mlist a.isOpen').length>0){
		$('.mlist a.isOpen').next().slideUp('fast');
		$('.mlist a.isOpen').removeClass('isOpen');
	}
		tg.slideDown('fast');
		$(this).addClass('isOpen');
	}
		e.preventDefault();
	}
});
</script>

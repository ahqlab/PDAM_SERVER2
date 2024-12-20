<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/tagLib.jsp" %>
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script type="text/javascript">

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

function doRestore(){
	var index = getCheckdCheckboxIndex();
	if(index != null){
		var isDel = document.getElementsByName("isDel");
		var selectIsDel = Number(isDel[index].value);
		
		if(selectIsDel == 1){
			var id = $('#reportTable').find("#id");			
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
								//history.go(0);
								searchForm();
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

function doRestoreMulti(){
	
	var deleteCd = 0;
	
	var reports = [];
	
	var id = $('#reportTable').find("#id");
	
	var isDel = $('#reportTable').find("#isDel");
	var selectOne = $('#reportTable').find("#selectOne");

	for (var i = 0; i < $('#reportTable tr').length; i++) {
		//삭제되지 않은 경우 넘긴다.
		if(Number(isDel[i].value) == deleteCd){
			continue;
		}
		//check box 선택여부
		if (!selectOne[i].checked) {
			continue;
		}

		var data = {
				id: Number(id[i].value)
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
	
	var id = $('#reportTable').find("#id");
	
	var isDel = $('#reportTable').find("#isDel");
	var isDuple = $('#reportTable').find("#isDuple");
	var selectOne = $('#reportTable').find("#selectOne");

	for (var i = 0; i < $('#reportTable tr').length; i++) {
		//삭제되지 않은 경우 넘긴다.
		if(Number(isDel[i].value) == deleteCd){
			continue;
		}
		//check box 선택여부
		if (!selectOne[i].checked) {
			continue;
		}

		var data = {
				id: Number(id[i].value),
				isDuple: Number(isDuple[i].value) 
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

function doDelete(){

	var index = getCheckdCheckboxIndex();
	if(index != null){
		var id = $('#reportTable').find("#id");			
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
						searchForm();
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
	
	var deleteCd = 1;
	
	var reports = [];
	
	var role = ${sessionInfo.role};
	var index = getCheckdCheckboxIndex();
	
	var id = $('#reportTable').find("#id");
	var pileType = $('#reportTable').find("#pileType");
	var method = $('#reportTable').find("#method");
	var location = $('#reportTable').find("#location");
	var pileNo = $('#reportTable').find("#pileNo");
	var pileStandard = $('#reportTable').find("#pileStandard");
	
	var drillingDepth = $('#reportTable').find("#drillingDepth");
	var intrusionDepth = $('#reportTable').find("#intrusionDepth");
	var hammaT = $('#reportTable').find("#hammaT");
	var fallMeter = $('#reportTable').find("#fallMeter");
	var managedStandard = $('#reportTable').find("#managedStandard");
	var totalPenetrationValue = $('#reportTable').find("#totalPenetrationValue");
	var avgPenetrationValue = $('#reportTable').find("#avgPenetrationValue");
	var crossSection = $('#reportTable').find("#crossSection");
	var hammaEfficiency = $('#reportTable').find("#hammaEfficiency");
	var modulusElasticity = $('#reportTable').find("#modulusElasticity");
	var bigo = $('#reportTable').find("#bigo");
	
	var isDel = $('#reportTable').find("#isDel");
	
	var deviceIdx = $('#reportTable').find("#deviceIdx");
	
	var selectOne = $('#reportTable').find("#selectOne");

	for (var i = 0; i < $('#reportTable tr').length; i++) {
		//삭제여부
		if(Number(isDel[i].value) == deleteCd){
			continue;
		}
		//check box 선택여부
		if (!selectOne[i].checked) {
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
					id: Number(id[i].value), 
					deviceIdx: Number(deviceIdx[i].value), 
					pileType: pileType[i].value != "" ? pileType[i].value : "null", 
					method: method[i].value != "" ? method[i].value : "null", 
					location: location[i].value != "" ? location[i].value : "null", 
					pileNo: pileNo[i].value != "" ? pileNo[i].value : "null", 
					pileStandard: pileStandard[i].value != "" ? pileStandard[i].value : "null", 
					piece: pieces, 
					penetrations : penetrationss, 
					drillingDepth: drillingDepth[i].value != "" ? drillingDepth[i].value  : "0", 
					intrusionDepth: intrusionDepth[i].value != "" ? intrusionDepth[i].value  : "0", 
					hammaT: hammaT[i].value != "" ? hammaT[i].value  : "0",
					fallMeter: fallMeter[i].value != "" ? fallMeter[i].value  : "0",
					managedStandard: managedStandard[i].value != "" ? managedStandard[i].value  : "0"
					, totalPenetrationValue : totalPenetrationValue[i].value != "" ? totalPenetrationValue[i].value  : "0"
					, avgPenetrationValue : avgPenetrationValue[i].value != "" ? avgPenetrationValue[i].value  : "0"
					, crossSection : crossSection[i].value != "" ? crossSection[i].value  : "0"
					, bigo : bigo[i].value != "" ? bigo[i].value  : "null"
					, hammaEfficiency : hammaEfficiency[i].value != "" ? hammaEfficiency[i].value  : "0"
					, modulusElasticity : modulusElasticity[i].value != "" ? modulusElasticity[i].value  : "0"
				//,	ultimateBearingCapacity : ultimateBearingCapacity[index].value
	        };
		}else{
			var data = {
					id: Number(id[i].value), 
					deviceIdx: Number(deviceIdx[i].value), 
					pileType: pileType[i].value != "" ? pileType[i].value : "null", 
					method: method[i].value != "" ? method[i].value : "null", 
					location: location[i].value != "" ? location[i].value : "null", 
					pileNo: pileNo[i].value != "" ? pileNo[i].value : "null", 
					pileStandard: pileStandard[i].value != "" ? pileStandard[i].value : "null", 
					piece: pieces, 
					drillingDepth: drillingDepth[i].value != "" ? drillingDepth[i].value  : "0", 
					intrusionDepth: intrusionDepth[i].value != "" ? intrusionDepth[i].value  : "0", 
					hammaT: hammaT[i].value != "" ? hammaT[i].value  : "0",
					fallMeter: fallMeter[i].value != "" ? fallMeter[i].value  : "0",
					managedStandard: managedStandard[i].value != "" ? managedStandard[i].value  : "0"
					, totalPenetrationValue : totalPenetrationValue[i].value != "" ? totalPenetrationValue[i].value  : "0"
					, avgPenetrationValue : avgPenetrationValue[i].value != "" ? avgPenetrationValue[i].value  : "0"
					, crossSection : crossSection[i].value != "" ? crossSection[i].value  : "0"
					, bigo : bigo[i].value != "" ? bigo[i].value  : "null"
					, hammaEfficiency : hammaEfficiency[i].value != "" ? hammaEfficiency[i].value  : "0"
					, modulusElasticity : modulusElasticity[i].value != "" ? modulusElasticity[i].value  : "0"
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
	
	//alert('선택된 항목이 없습니다.');
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
		//check box 선택 취소	
		
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
		
		//var ultimateBearingCapacity = document.getElementsByName("ultimateBearingCapacity");
		var crossSection = document.getElementsByName("crossSection");
		var hammaEfficiency = document.getElementsByName("hammaEfficiency");
		var modulusElasticity = document.getElementsByName("modulusElasticity");
		var bigo = document.getElementsByName("bigo");
		
		var selectIsDel = Number(isDel[index].value);
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
		//check box 선택 취소	
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
			location.href = '${pageContext.request.contextPath}/report/download/excel?' + para[1];
		}else{
			$("#searchForm").attr("action", "${pageContext.request.contextPath}/report/download/excel");
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
	
	function doRowClick(i){
		var penetrations = document.getElementsByName("penetrations[" + i + "]");
	
		var data = new google.visualization.DataTable();
		data.addColumn('number', '');
		data.addColumn('number', '');
		
		var isBig = ${isBig};
		var isBig = ${isBig};
		if(isBig){
			data.addRows([
				[1, Number(penetrations[0].value != "" ? penetrations[0].value : 0)],
				[2, Number(penetrations[1].value != "" ? penetrations[1].value : 0)],
				[3, Number(penetrations[2].value != "" ? penetrations[2].value : 0)],
				[4, Number(penetrations[3].value != "" ? penetrations[3].value : 0)],
				[5, Number(penetrations[4].value != "" ? penetrations[4].value : 0)],
				[6, Number(penetrations[5].value != "" ? penetrations[4].value : 0)],
				[7, Number(penetrations[6].value != "" ? penetrations[4].value : 0)],
				[8, Number(penetrations[7].value != "" ? penetrations[4].value : 0)],
				[9, Number(penetrations[8].value != "" ? penetrations[4].value : 0)],
				[10, Number(penetrations[9].value != "" ? penetrations[4].value : 0)]
				
			]);
		}else{
			
			data.addRows([
				[1, Number(penetrations[0].value != "" ? penetrations[0].value : 0)],
				[2, Number(penetrations[1].value != "" ? penetrations[1].value : 0)],
				[3, Number(penetrations[2].value != "" ? penetrations[2].value : 0)],
				[4, Number(penetrations[3].value != "" ? penetrations[3].value : 0)],
				[5, Number(penetrations[4].value != "" ? penetrations[4].value : 0)]
			]);
		}
		
		var options = {
			legend : 'none',
			'tooltip' : {
				trigger : 'none'
			}
		};

		var chart = new google.visualization.SteppedAreaChart(document.getElementById('chart_div'));
		chart.draw(data, options);
	}

</script>
<script type="text/javascript">
      google.charts.load('current', {'packages':['corechart']});
      google.charts.setOnLoadCallback(drawChart);

  
	function drawChart() {
		var i = 0;
		var penetrations = document.getElementsByName("penetrations[" + i + "]");
	
		var data = new google.visualization.DataTable();
		data.addColumn('number', '');
		data.addColumn('number', '');

		var isBig = ${isBig};
		if(isBig){
			data.addRows([
				[1, Number(penetrations[0].value != "" ? penetrations[0].value : 0)],
				[2, Number(penetrations[1].value != "" ? penetrations[1].value : 0)],
				[3, Number(penetrations[2].value != "" ? penetrations[2].value : 0)],
				[4, Number(penetrations[3].value != "" ? penetrations[3].value : 0)],
				[5, Number(penetrations[4].value != "" ? penetrations[4].value : 0)],
				[6, Number(penetrations[5].value != "" ? penetrations[4].value : 0)],
				[7, Number(penetrations[6].value != "" ? penetrations[4].value : 0)],
				[8, Number(penetrations[7].value != "" ? penetrations[4].value : 0)],
				[9, Number(penetrations[8].value != "" ? penetrations[4].value : 0)],
				[10, Number(penetrations[9].value != "" ? penetrations[4].value : 0)]
				
			]);
		}else{
			
			data.addRows([
				[1, Number(penetrations[0].value != "" ? penetrations[0].value : 0)],
				[2, Number(penetrations[1].value != "" ? penetrations[1].value : 0)],
				[3, Number(penetrations[2].value != "" ? penetrations[2].value : 0)],
				[4, Number(penetrations[3].value != "" ? penetrations[3].value : 0)],
				[5, Number(penetrations[4].value != "" ? penetrations[4].value : 0)]
			]);
		}
		
		
	
		
		var options = {
			legend : 'none',
			'tooltip' : {
				trigger : 'none'
			}
		};

		var chart = new google.visualization.SteppedAreaChart(document.getElementById('chart_div'));
		chart.draw(data, options);
	}
</script>
<div class="right_content">
	<div class="tab_menu">
		<ul>
			<li class="on">${device.machineNumber} 시공현황</li>
			<li><a href="#">투입인원현황</a></li>
			<li><a href="#">장비사용현황</a></li>
			<li><a href="#">유류사용현황</a></li>
			<li><a href="#">항타자재현황</a></li>
		</ul>
	</div>
	<!--table01_content-->
	<div class="table01_content">
		<!--search_div-->
		<div class="search_div" ${param.type == 'all' ? 'style="height: 160px;"' : ''}>
		<!-- <div class="search_div" style="height: 160px;" > -->
		
		
			<div style="width: 100%;  height: auto; overflow: hidden;">
				<form:form id="searchForm" commandName="domainParam" method="POST">
				<form:hidden path="currentPage"/>
				<c:choose>
					<c:when test="${param.mode != 'simple'}">				     
						<c:choose>												 
							<c:when test="${sessionInfo.role == 0 || sessionInfo.hiddenManager == true || sessionInfo.role == 3}">
								<div class="search_form01" style="float: left; width: 35%;" >
									<input type="button" class="input01" value="기록지 수정" style="float: left;" onclick="javascript:onClickReportUpdate();">
								</div>
							</c:when>
						</c:choose>
					</c:when>
				</c:choose>
				<c:choose>
					<c:when test="${param.mode == 'simple'}">
						<div  style="float: left; height: 100%; margin-top:20px;" class="input01">
							<font color="white" size="6">총시공량 ${totalConstruction} 공</font> 
						</div>
					</c:when>
				</c:choose>
				<div class="search_form01" style="float: right; ">
					<c:choose>
						<c:when test="${sessionInfo.role == 1}">
							<input type="button" class="input01" value="총작업내역" onclick="goUrl('${pageContext.request.contextPath}/report/list?id=${param.id}&type=all&constructionIdx=${sessionInfo.constructionIdx}');">
							<input type="button" class="input01" value="금일작업내역" onclick="goUrl('${pageContext.request.contextPath}/report/list?id=${param.id}&date=today&constructionIdx=${sessionInfo.constructionIdx}');">
							
						</c:when>
						<c:otherwise>
							<input type="button" class="input01" value="총작업내역" onclick="goUrl('${pageContext.request.contextPath}/report/list?id=${param.id}&type=all&constructionIdx=${param.constructionIdx}');">
							<input type="button" class="input01" value="금일작업내역" onclick="goUrl('${pageContext.request.contextPath}/report/list?id=${param.id}&date=today&constructionIdx=${param.constructionIdx}');">
						</c:otherwise>
					</c:choose>
					<form:input class="input01" path="startDate"/><span>~</span><form:input class="input01" path="endDate"/>
					<input type="button" class="input01" value="일자별검색" onclick="javascript:searchDate();">
					<c:choose>
						<c:when test="${param.mode != 'simple'}">
							<input type="button" class="input01"  value="엑셀출력" onclick="javascript:downloadExcel();">
						</c:when>
					</c:choose>
				</div>
			 	<c:choose>
					<c:when test="${param.type == 'all'}"> 
						<div style="float: left; width: 100%;   vertical-align: center;">
							<div class="search_form01" style="float: right;  vertical-align: center;">
								<font color="white">시공위치</font>	
								<form:input path="location" class="input01"/>
								<font color="white">파일번호</font>		
								<form:input path="pileNo" class="input01"/>
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
								<input type="submit" class="input01"  value="검색" onclick="javascript:searchForm();">
							</div>
						</div>
				 	</c:when>
				</c:choose> 
			</div>
			</form:form>
		</div>
		
		<!--search_div end-->
		<!--table 리스트-->
		<c:choose>
			<c:when test="${param.mode eq 'simple'}">
				<div id="aa" class="table_list" style="overflow-y: hidden; overflow-x: hidden; overflow-y:scroll;">
					<table  class="table01">
						<tr>
							<th style="width: 20%;">시공일</th>
							<th style="width: 20%;">금일시공량</th>
							<th style="width: 20%;">&nbsp;</th>
							<th style="width: 20%;">&nbsp;</th>
							<th style="width: 20%;">&nbsp;</th>
						</tr>
					</table>
				</div>
			</c:when>
			<c:otherwise>
				<div id="aa" class="table_list2" style="overflow-y: hidden; overflow-x: hidden; overflow-y:scroll;    ">
				<table  class="table03" ${isBig == true ? '' : 'style="width: 3100px;'}">
					<tr>
						<c:choose>
							<c:when test="${sessionInfo.role == 0  || sessionInfo.hiddenManager == true  || sessionInfo.role == 3}">
								<th style="width: 50px;" rowspan="2">
									<input type="checkbox" id="chkAll" name="chkAll" onclick="javascript:onClickChkAll();">
								</th>
							</c:when>
						</c:choose>
						<th style="width: 50px;" rowspan="2">순번</th>
						<th style="width: 100px;" rowspan="2">시공일</th>
						<th style="width: 100px;" rowspan="2">파일종류</th>
						<th style="width: 100px;" rowspan="2">시공공법</th>
						<th style="width: 100px;" rowspan="2">시공위치</th>
						<th style="width: 100px;" rowspan="2">파일번호</th>
						<th style="width: 100px;" rowspan="2">파일규격</th>
						<th colspan="6">파일구분</th>
						
						<th style="width: 80px;" rowspan="2">이음<br>(개소)</th>
						<th style="width: 100px;" rowspan="2">천공깊이(M)</th>
						<th style="width: 100px;" rowspan="2">관입깊이(M)</th>
						<th style="width: 100px;" rowspan="2">파일잔량(M)</th>
						<th style="width: 100px;" rowspan="2">공삭공(M)</th>
						<th style="width: 100px;" rowspan="2">드롭헤머(Ton)</th>
						<th style="width: 100px;" rowspan="2">낙하높이(m)</th>
						<th style="width: 100px;" rowspan="2">관리기준(mm)</th>
						
						<th style="width: 80px;" rowspan="2">1회측정(mm)</th>
						<th style="width: 80px;" rowspan="2">2회측정(mm)</th>
						<th style="width: 80px;" rowspan="2">3회측정(mm)</th>
						<th style="width: 80px;" rowspan="2">4회측정(mm)</th>
						<th style="width: 80px;" rowspan="2">5회측정(mm)</th>
						
						
						<c:choose>
							<c:when test="${isBig == true}">
								<th style="width: 80px;" rowspan="2">6회측정(mm)</th>
								<th style="width: 80px;" rowspan="2">7회측정(mm)</th>
								<th style="width: 80px;" rowspan="2">8회측정(mm)</th>
								<th style="width: 80px;" rowspan="2">9회측정(mm)</th>
								<th style="width: 80px;" rowspan="2">10회측정(mm)</th>
							</c:when>
						</c:choose>
						
						<th style="width: 100px;" rowspan="2">평균관입(mm)</th>
						<th style="width: 100px;" rowspan="2">최종관입(mm)</th>
						<!-- <th style="width: 100px;" rowspan="2">극한지지력<br>(kN)</th> -->
						<c:choose>
							<c:when test="${sessionInfo.role > 0}">
								<th style="width: 100px;" rowspan="2">비고</th>
							</c:when>
						</c:choose>
						<c:choose>
							<c:when test="${sessionInfo.role == 0}">
								<th style="width: 100px;" rowspan="2">헤머효율(%)</th>
								<th style="width: 100px;" rowspan="2">탄성계수(t/cm2)</th>
								<th style="width: 100px;" rowspan="2">파일단면적(cm2)</th>
								<th style="" rowspan="2">비고<br>&nbsp;</th>
							</c:when>
						</c:choose>
					</tr>	
					<tr>
						<th  style="width: 80px;">단본(M)</th>
						<th  style="width: 80px;">하단(M)</th>
						<th  style="width: 80px;">중단(M)</th>
						<th  style="width: 80px;">중단(M)</th>
						<th  style="width: 80px;">상단(M) </th>
						<th  style="width: 80px;">합계(M)</th>
					</tr>
				</table>
			</div>
			</c:otherwise>
		</c:choose>
		<!-- <div class="table_list"  > -->
		
	<c:choose>
		<c:when test="${param.mode eq 'simple'}">
			<div id="bb" class="table_list" style="overflow-y:scroll;" onScroll="javascript:document.all.aa.scrollLeft = document.all.bb.scrollLeft">
				<table class="table01" id="reportTable"  name="reportTable" >
		</c:when>
		<c:otherwise>
			<div id="bb"  class="table_list2" style="overflow-y:scroll;" onScroll="javascript:document.all.aa.scrollLeft = document.all.bb.scrollLeft">
				<table class="table03" id="reportTable" name="reportTable" ${isBig == true ? '' : 'style="width: 3100px;"'}>
		</c:otherwise>
	</c:choose>	
	
	<c:forEach var="domain" items="${domainList}"  varStatus="status">
		<c:choose>
			<c:when test="${param.mode eq 'simple'}">
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
			</c:when>
			<c:otherwise>
				<c:choose>
					<c:when test="${domain.isDel == 1}">
						<tr style="background-color: #ff0000;" >
						<!-- onclick="doRowClick(this.rowIndex);" -->
					</c:when>
					<c:otherwise>
						<c:choose>
							<c:when test="${domain.duplicated > 1}">
								<tr style="background-color: #96d2ea;">
								<!-- onclick="doRowClick(this.rowIndex);" -->
							</c:when>
							<c:otherwise>
								<tr>
								<!-- onclick="doRowClick(this.rowIndex);" -->
							</c:otherwise>
						</c:choose>
					
						
					</c:otherwise>
				</c:choose>
					<c:choose>
						<c:when test="${sessionInfo.role == 0  || sessionInfo.hiddenManager == true  || sessionInfo.role == 3}">
							<td style="width: 50px;">
								<c:choose>
									<c:when test="${domain.isDel == 1}">
										<!-- 삭제된것에 클릭 -->
										<input type="checkbox" id="selectOne" name="selectOne" onclick="doOpenCheck(this, this.parentNode.parentNode.rowIndex);">
									</c:when>
									<c:otherwise>
										<input type="checkbox" id="selectOne" name="selectOne" onclick="doOpenCheck(this, this.parentNode.parentNode.rowIndex);">
									</c:otherwise>
								</c:choose>
							</td>
						</c:when>
					</c:choose>
					<td style="width: 50px;">
						${domain.rownum}
					</td>
					<c:choose>
						<c:when test="${((sessionInfo.hiddenManager == true or sessionInfo.role == 0) and 
									(domain.deviceIdx eq 345 or 
									domain.deviceIdx eq 346 or 
									domain.deviceIdx eq 343 or 
									domain.deviceIdx eq 344 or 
									domain.deviceIdx eq 351)) or (domain.longCalYn == 1 and sessionInfo.hiddenManager == true) or sessionInfo.role == 0}">
							<td style="width: 100px; line-height: 14px; margin: 0; padding-bottom: 10px;" >
								<a>	
									<font style="font-size: 12px; margin: 0; padding: 0;">
										<c:set var = "dateTime" value = "${domain.createDate}"/>
									    <c:set var = "length" value = "${fn:length(dateTime)}"/>
									    <c:set var = "newDateTime" value = "${fn:substring(dateTime, 0, length -2)}" />
										${newDateTime}
									</font>			
									<input type="hidden" id="id" name="id" value="${domain.id}" >
									<input type="hidden" id="isDel" name="isDel" value="${domain.isDel}" >
									<input type="hidden" id="isDuple" name="isDuple" value="${domain.isDuple}" >
									<input type="hidden" id="deviceIdx" name="deviceIdx" value="${domain.deviceIdx}" >
								</a>
							</td>
						</c:when>
						<c:otherwise>
							<td style="width: 100px;" >
								<a>
									<font style="font-size: 14px;">${domain.currentDateTime}</font>
									<input type="hidden" id="id" name="id" value="${domain.id}" >
									<input type="hidden" id="isDel" name="isDel" value="${domain.isDel}" >
									<input type="hidden" id="isDuple" name="isDuple" value="${domain.isDuple}" >
									<input type="hidden" id="deviceIdx" name="deviceIdx" value="${domain.deviceIdx}" >
								</a>
							</td>
						</c:otherwise>				
					</c:choose>
				 	<td style="width: 100px;">
				 		<input type="text" id="pileType" name="pileType" disabled="disabled" style="width: 90px;" value="${domain.pileType}">
				 	</td>
					<td style="width: 100px;">
						<input type="text" id="method" name="method" disabled="disabled" style="width: 90px;" value="${domain.method}">
					</td>
					<td style="width: 100px;">
						<input type="text" id="location" name="location" disabled="disabled" style="width: 90px;" value="${domain.location}">
					</td>
					<td style="width: 100px;">
						<input type="text" id="pileNo" name="pileNo" disabled="disabled" style="width: 90px;" value="${domain.pileNo}">
					</td>
					<td style="width: 100px;">
						<input type="text" id="pileStandard" name="pileStandard" disabled="disabled" style="width: 90px;" value="${domain.pileStandard}">
					</td>
					<c:choose>
						<c:when test="${fn:length(domain.piece) == 3}">
							<td style="width: 80px;">
								<input type="text" id="piece[${status.index}]" name="piece[${status.index}]"  disabled="disabled" style="width: 70px;" value="${domain.piece[0].value}">
								<input type="hidden" id="pieceId[${status.index}]" name="pieceId[${status.index}]" value="${domain.piece[0].id}">
								<input type="hidden" id="pieceName[${status.index}]" name="pieceName[${status.index}]" value="${domain.piece[0].name}">
							</td>
							<td style="width: 80px;">
								<input type="text" id="piece[${status.index}]" name="piece[${status.index}]" disabled="disabled" style="width: 70px;" value="${domain.piece[1].value}">
								<input type="hidden" id="pieceId[${status.index}]" name="pieceId[${status.index}]" value="${domain.piece[1].id}">
								<input type="hidden" id="pieceName[${status.index}]" name="pieceName[${status.index}]" value="${domain.piece[1].name}">
							</td>
							<td style="width: 80px;">
								<input type="text" id="piece[${status.index}]" name="piece[${status.index}]" disabled="disabled" style="width: 70px;" value="">
								<input type="hidden" id="pieceId[${status.index}]" name="pieceId[${status.index}]" value="">
								<input type="hidden" id="pieceName[${status.index}]" name="pieceName[${status.index}]" value="">
							</td>
							<td style="width: 80px;">
								<input type="text" id="piece[${status.index}]" name="piece[${status.index}]" disabled="disabled" style="width: 70px;" value="">
								<input type="hidden" id="pieceId[${status.index}]" name="pieceId[${status.index}]" value="">
								<input type="hidden" id="pieceName[${status.index}]" name="pieceName[${status.index}]" value="">
							</td>
							<td style="width: 80px;">
								<input type="text" id="piece[${status.index}]" name="piece[${status.index}]" disabled="disabled" style="width: 70px;" value="${domain.piece[2].value}">
								<input type="hidden" id="pieceId[${status.index}]" name="pieceId[${status.index}]" value="${domain.piece[2].id}">
								<input type="hidden" id="pieceName[${status.index}]" name="pieceName[${status.index}]" value="${domain.piece[2].name}">
							</td>
						</c:when>
					</c:choose>
					<c:choose>
						<c:when test="${fn:length(domain.piece) == 4}">
							<td style="width: 80px;">
								<input type="text" id="piece[${status.index}]" name="piece[${status.index}]" disabled="disabled" style="width: 70px;" value="${domain.piece[0].value}">
								<input type="hidden" id="pieceId[${status.index}]" name="pieceId[${status.index}]" value="${domain.piece[0].id}">
								<input type="hidden" id="pieceName[${status.index}]" name="pieceName[${status.index}]" value="${domain.piece[0].name}">
							</td>
							<td style="width: 80px;">
								<input type="text" id="piece[${status.index}]" name="piece[${status.index}]" disabled="disabled" style="width: 70px;" value="${domain.piece[1].value}">
								<input type="hidden" id="pieceId[${status.index}]" name="pieceId[${status.index}]" value="${domain.piece[1].id}">
								<input type="hidden" id="pieceName[${status.index}]" name="pieceName[${status.index}]" value="${domain.piece[1].name}">
							</td>
							<td style="width: 80px;">
								<input type="text" id="piece[${status.index}]" name="piece[${status.index}]" disabled="disabled" style="width: 70px;" value="${domain.piece[2].value}">
								<input type="hidden" id="pieceId[${status.index}]" name="pieceId[${status.index}]" value="${domain.piece[2].id}">
								<input type="hidden" id="pieceName[${status.index}]" name="pieceName[${status.index}]" value="${domain.piece[2].name}">
							</td>
							<td style="width: 80px;">
								<input type="text" id="piece[${status.index}]" name="piece[${status.index}]" disabled="disabled" style="width: 70px;" value="">
								<input type="hidden" id="pieceId[${status.index}]" name="pieceId[${status.index}]" value="">
								<input type="hidden" id="pieceName[${status.index}]" name="pieceName[${status.index}]" value="">
							</td>
							<td style="width: 80px;">
								<input type="text" id="piece[${status.index}]" name="piece[${status.index}]" disabled="disabled" style="width: 70px;" value="${domain.piece[3].value}">
								<input type="hidden" id="pieceId[${status.index}]" name="pieceId[${status.index}]" value="${domain.piece[3].id}">
								<input type="hidden" id="pieceName[${status.index}]" name="pieceName[${status.index}]" value="${domain.piece[3].name}">
							</td>
						</c:when>
					</c:choose>
					<c:choose>
						<c:when test="${fn:length(domain.piece) >= 5}">
							<td style="width: 80px;">
								<input type="text" id="piece[${status.index}]" name="piece[${status.index}]" disabled="disabled" style="width: 70px;" value="${domain.piece[0].value}">
								<input type="hidden" id="pieceId[${status.index}]" name="pieceId[${status.index}]" value="${domain.piece[0].id}">
								<input type="hidden" id="pieceName[${status.index}]" name="pieceName[${status.index}]" value="${domain.piece[0].name}">
							</td>
							<td style="width: 80px;">
								<input type="text" id="piece[${status.index}]" name="piece[${status.index}]" disabled="disabled" style="width: 70px;" value="${domain.piece[1].value}">
								<input type="hidden" id="pieceId[${status.index}]" name="pieceId[${status.index}]" value="${domain.piece[1].id}">
								<input type="hidden" id="pieceName[${status.index}]" name="pieceName[${status.index}]" value="${domain.piece[1].name}">
							</td>
							<td style="width: 80px;">
								<input type="text" id="piece[${status.index}]" name="piece[${status.index}]" disabled="disabled" style="width: 70px;" value="${domain.piece[2].value}">
								<input type="hidden" id="pieceId[${status.index}]" name="pieceId[${status.index}]" value="${domain.piece[2].id}">
								<input type="hidden" id="pieceName[${status.index}]" name="pieceName[${status.index}]" value="${domain.piece[2].name}">
							</td>
							<td style="width: 80px;">
								<input type="text" id="piece[${status.index}]" name="piece[${status.index}]" disabled="disabled" style="width: 70px;" value="${domain.piece[3].value}">
								<input type="hidden" id="pieceId[${status.index}]" name="pieceId[${status.index}]" value="${domain.piece[3].id}">
								<input type="hidden" id="pieceName[${status.index}]" name="pieceName[${status.index}]" value="${domain.piece[3].name}">
							</td>
							<td style="width: 80px;">
								<input type="text" id="piece[${status.index}]" name="piece[${status.index}]" disabled="disabled" style="width: 70px;" value="${domain.piece[4].value}">
								<input type="hidden" id="pieceId[${status.index}]" name="pieceId[${status.index}]" value="${domain.piece[4].id}">
								<input type="hidden" id="pieceName[${status.index}]" name="pieceName[${status.index}]" value="${domain.piece[4].name}">
							</td>
						</c:when>
					</c:choose>
					<td style="width: 80px;">${domain.totalConnectWidth}</td>
					<td style="width: 80px;">
						${domain.connectLength}
					</td>
					<td style="width: 100px;"><input type="text" id="drillingDepth" name="drillingDepth" disabled="disabled" style="width: 90px;" value="${domain.drillingDepth}"/></td>
					<td style="width: 100px;" ><input type="text" id="intrusionDepth" name="intrusionDepth" disabled="disabled" style="width: 90px;" value="${domain.intrusionDepth}"/></td>
					<td style="width: 100px;" >${domain.balance}</td>
					<td style="width: 100px;" >
						${domain.gongSac}
					</td>
					<td style="width: 100px;" ><input type="text" id="hammaT" name="hammaT"  disabled="disabled" style="width: 90px;"  value="${domain.hammaT}"/></td>
					<td style="width: 100px;" ><input type="text" id="fallMeter" name="fallMeter"  disabled="disabled" style="width: 90px;"  value="${domain.fallMeter}"/></td>
					<td style="width: 100px;" ><input type="text" id="managedStandard" name="managedStandard"  disabled="disabled" style="width: 90px;"  value="${domain.managedStandard}"/></td>
					
					<c:forEach var="i" begin="0" end="${isBig == true ? 9 : 4}">
						<c:choose>
							<c:when test="${sessionInfo.role == 0}">
								<td style="width: 80px;">
									<input type="text" id="penetrations[${status.index}]" name="penetrations[${status.index}]" 
										disabled="disabled" 
										style="width: 70px;" 
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
								<td style="width: 80px;">${domain.penetrations[i].value}</td> 
							</c:otherwise>
						</c:choose>											
					</c:forEach>
					<c:choose>
						<c:when test="${domain.managedStandard + 0 < domain.avgPenetrationValue + 0}">
							<td style="background-color: red; color: white; width: 100px;">
								${domain.avgPenetrationValue}
								<input type="hidden" id="avgPenetrationValue" name="avgPenetrationValue" value="${domain.avgPenetrationValue}" >
							</td>
						</c:when>
						<c:otherwise>
							<td style="width: 100px;">
								${domain.avgPenetrationValue}
								<input type="hidden" id="avgPenetrationValue" name="avgPenetrationValue" value="${domain.avgPenetrationValue}">
							</td>
						</c:otherwise>
					</c:choose>
					<td style="width: 100px;">
						${domain.totalPenetrationValue}
						<input type="hidden" id="totalPenetrationValue" name="totalPenetrationValue" value="${domain.totalPenetrationValue}" >
					</td>
					<%-- <td style="width: 100px;">
						${domain.ultimateBearingCapacity}
					</td> --%>
					<c:choose>
						<c:when test="${sessionInfo.role > 0}">
							<c:choose>
								<c:when test="${sessionInfo.hiddenManager == true  || sessionInfo.role == 3}">
									<td style="width: 100px;">
										<input type="text" id="bigo" name="bigo"  disabled="disabled" style="width: 90px;"  value="${domain.bigo}"/>
									</td>
								</c:when>
								<c:otherwise>
									<td style="width: 100px;">
										${domain.bigo}
										<input type="hidden" id="bigo" name="bigo"  disabled="disabled" style="width: 90px;"  value="${domain.bigo}"/>
									</td>
								</c:otherwise>
							</c:choose>
						</c:when>
					</c:choose>
					
					<c:choose>
						<c:when test="${sessionInfo.role == 0}">
							<td style="width: 100px;">
								<input type="text" id="hammaEfficiency" name="hammaEfficiency"  disabled="disabled" style="width: 90px;"  value="${domain.hammaEfficiency}"/>
							</td> 
							<td style="width: 100px;">
								<input type="text" id="modulusElasticity" name="modulusElasticity"  disabled="disabled" style="width: 90px;"  value="${domain.modulusElasticity}"/>
							</td> 
							<td style="width: 100px;">
								<input type="text" id="crossSection" name="crossSection"  disabled="disabled" style="width: 90px;"  value="${domain.crossSection}"/>
							</td> 
							<td style="">
								<input type="text" id="bigo" name="bigo"  disabled="disabled" style=""  value="${domain.bigo}"/>
							</td>
						</c:when>
						<c:otherwise>
							<input type="hidden" id="hammaEfficiency" name="hammaEfficiency"  disabled="disabled" style="width: 50px;"  value="${domain.hammaEfficiency}"/>
							<input type="hidden" id="modulusElasticity" name="modulusElasticity"  disabled="disabled" style="width: 50px;"  value="${domain.modulusElasticity}"/>
							<input type="hidden" id="crossSection" name="crossSection"  disabled="disabled" style="width: 70px;"  value="${domain.crossSection}"/>
							<%-- <input type="hidden" id="bigo" name="bigo"  disabled="disabled" style="width: 70px;"  value="${domain.bigo}"/> --%>
						</c:otherwise>
					</c:choose> 
				</tr>
			</c:otherwise>
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
			<c:choose>
				<c:when test="${param.mode != 'simple'}">
					 <c:choose>
						<c:when test="${sessionInfo.role == 0}"> 
							<div class="white_btn">
								<a style="color: white;" href="javascript:doDeleteMulti()">삭제</a>
							</div>
							<div class="white_btn2">
								<a style="color: white;" href="javascript:doRestoreMulti()">복구</a>
							</div>
						 </c:when>
						 <c:when test="${sessionInfo.hiddenManager == true  || sessionInfo.role == 3}">
					 		<div class="white_btn">
								<a style="color: white;" href="javascript:doDeleteMulti()">삭제</a>
							</div>
						 </c:when>
					</c:choose>
				</c:when>
			</c:choose>
		<!--페이지 넘버end-->
	</div>
	
	<!--  <div id="chart_div"></div> -->
	<!--table01_content end-->
</div>
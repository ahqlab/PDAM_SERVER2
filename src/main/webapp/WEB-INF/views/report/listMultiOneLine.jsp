<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/tagLib.jsp" %>
<style>
	.tableScroll {
	  width: 100%;
	}
	
	.reportTable {
	  width: auto;
	  border-collapse: collapse;
	  table-layout: fixed;
	}
	.viewTh tr td,
	.reportTable tr td, 
	.reportTable thead tr th {
	  width: 70px;  /* 전체 너비의 5% */
	  padding: 2px;
	  overflow: hidden;
	  white-space: normal;      /* 한 줄에 강제하지 않고 줄바꿈 허용 */
	  word-wrap: break-word;    /* 단어 단위 줄바꿈 허용 (구버전 호환) */
	  overflow-wrap: break-word; /* 긴 단어도 줄바꿈 */
	  text-overflow: clip;      /* 말줄임표 제거 */
	  overflow: visible;        /* 내용이 넘쳐도 숨기지 않음 */
	}
	
	.reportTable tr td input {
	  width: 100%;
	  box-sizing: border-box;
	  padding: 2px 4px;
	  margin: 0;
	}
	
	.popUp04 {
	    display: none;
	    position: fixed !important;
	    top: 50%;
	    left: 50%;
	    transform: translate(-50%, -50%);
	    width: 95%;
	    max-width: 1000px; 
	    max-height: 90vh;
	    overflow-y: auto;  
	    z-index: 9999;
	    background: #fff;
	    flex-direction: column;
	}
	
	.popUp04.is-visible {
	    display: flex;
	}
	
	.popUp04 .signTable {
	    width: 100% !important;
	    border-collapse: collapse;
	    table-layout: fixed;
	    border: 1px solid #ccc;
	    margin-top: 10px;
	    margin-bottom: 10px;
	}
	
	.popUp04 .signTable td, 
	.popUp04 .signTable th {
	    border: 1px solid #ccc;
	    padding: 6px !important;
	    text-align: center;
	    overflow: hidden;
	    word-break: break-all;
	}
	
	.popUp04 .viewTh { 
	    background: #eee; 
	    font-weight: bold; 
	}
	
	.popUp04 .tdInput {
	    width: 100% !important;
	    border: none !important;
	    text-align: center;
	    box-sizing: border-box;
	    background: transparent;
	    font-size: 14px;
	    padding: 5px;
	}
	
	.popUp04 .mid-group {
	    display: none; 
	}
	
	@media screen and (max-width: 767px) {
	    .popUp04 {
	        width: 98%;
	        padding: 5px;
	    }
	    
	    .popUp04 .tdInput {
	        font-size: 13px; 
	    }
	    
	    .popCont {
	        overflow-x: auto;
	    }
	    
	    .popUp04 .signTable {
	        min-width: 600px;
	    }
	}
	
	.popUp05 {
	    display: none;
	    position: fixed !important;
	    top: 50%;
	    left: 50%;
	    transform: translate(-50%, -50%);
	    width: 90%;
	    max-width: 500px;
	    z-index: 9999;
	    background: #fff;
	    flex-direction: column;
	    box-shadow: 0 4px 15px rgba(0,0,0,0.2);
	}
	@media screen and (max-width: 767px) {
		.popUp05 {
			width: 95%; 
			max-height: 90vh;
			overflow-y: auto;
			border-radius: 8px; 
		}
		.popUp05 #popDate_newDate {
			font-size: 16px !important; 
			height: 48px !important;
		}
	}
	.popUp06 {
		display: none;
		position: fixed !important;
		top: 50%;
		left: 50%;
		transform: translate(-50%, -50%);
		width: 95%;
		max-width: 950px;
		z-index: 9999;
		background: #fff;
		flex-direction: column;
		box-shadow: 0 4px 20px rgba(0,0,0,0.3);
		border-radius: 8px;
	}
	.popUp06 .table-scroll-area {
		max-height: 55vh;
		overflow-y: auto;
		margin-top: 10px;
		border: 1px solid #ccc;
	}
	.popUp06 .row-date-input, .popUp06 .row-device-select {
		border: 1px solid #ccc !important;
		border-radius: 4px;
		width: 100% !important;
		height: 38px;
		font-weight: bold;
		font-size: 14px;
		text-align: center;
		background: #fff;
		box-sizing: border-box;
	}
	.popUp06 .signTable th, .popUp06 .signTable td {
		text-align: center !important;
		vertical-align: middle !important;
	}
	@media screen and (max-width: 767px) {
		.popUp06 { width: 95%; max-height: 90vh; }
		.popUp06 .row-date-input, .popUp06 .row-device-select { font-size: 13px; height: 34px; }
	}
	
</style>

<script>

	var initIndex = 0;
	
	$(document).ready( function() {
		
		
	    $('#submitBtn').click( function() {
	    	searchForm();
	    	getConstructionName();
	    });
		
	    $("#aa").scroll(function () {
	        $("#bb").scrollTop($("#bb").scrollTop());  
	        $("#bb").scrollLeft($("#bb").scrollLeft());
	    });
	    $("#bb").scroll(function () {
	        $("#aa").scrollTop($("#aa").scrollTop());
	        $("#aa").scrollLeft($("#aa").scrollLeft());
	    });
	    getConstructionName();
	    onRowClick(0);
	    getPdfSignInfo();
	    getExcelSignInfo();
	    calcIntrusionFromSprCol1();
	});

	function calcIntrusionFromSprCol1() {
		if ('${param.constructionIdx}' != '1823' && '${sessionInfo.constructionIdx}' != '1823') return;

		// 구간 끝 카운트 경계값 (표 기준 고정)
		var SEG_ENDS = [100, 200, 300, 400, 500, 600, 737, 800, 900];

		$('#reportTable tr').each(function() {
			if ($(this).find('#deviceIdx').val() != 3142) return;
			var sprVal = $(this).find('#sprCol1').val();
			if (!sprVal || sprVal === 'null') return;
			var parts = sprVal.split(',');
			if (parts.length !== 3) return;
			var p0 = parts[0].trim(), p1 = parts[1].trim(), p2 = parts[2].trim();
			if (p0 === '' || p1 === '' || p2 === '') return;
			if (isNaN(parseFloat(p0)) || isNaN(parseFloat(p1)) || isNaN(parseFloat(p2))) return;

			var baseTaco = parseFloat(p1);
			var totalCount = parseInt(p2);
			var depth = 0;
			var prevEnd = 0;

			for (var s = 0; s < SEG_ENDS.length; s++) {
				if (prevEnd >= totalCount) break;
				var segEnd = SEG_ENDS[s];
				var countInSeg = Math.min(segEnd, totalCount) - prevEnd;
				var segTaco = parseFloat((baseTaco - s * 0.001).toFixed(3));
				depth += segTaco * countInSeg / 100;
				prevEnd = segEnd;
			}

			$(this).find('#drillingDepth').val(depth.toFixed(2));
		});
	}


	function getConstructionName(){
		var role = ${sessionInfo.role};
		var idx = ${param.constructionIdx};
		jQuery.ajax({
			type : "POST",
			contentType: "application/x-www-form-urlencoded; charset=UTF-8",
			url : "${pageContext.request.contextPath}/construction/get/name",
			data: {
				id : idx,
				role : role
			}, 
			success : function(data) {
				$('#constructionName').val(data.constructionName + ' ' + data.constructionLocation);
			},
			complete : function(data) {
			},
			error : function(xhr, status, error) {
			}
		}); 
	}
	
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
	//row 클릭 시 border 색상을 변경한다.
	function setTrActiviEffect(index){
		
		var length = ${fn:length(domainList)};
		if(length == 0){
			return;
		}
		
		for (var i = 0; i < $('#reportTable tr').length; i++) {
			for (var j = 0; j < $('#reportTable tr').eq(i).find('td').length; j++) {
				if(index == i){
					if(j == 0){
						$('#reportTable tr').eq(i).find('td:eq(' + j + ')').css('border-left', '2px solid #ff9f82');
						$('#reportTable tr').eq(i).find('td:eq(' + j + ')').css('border-top', '2px solid #ff9f82');
						$('#reportTable tr').eq(i).find('td:eq(' + j + ')').css('border-bottom', '2px solid #ff9f82');
					}else if(j == $('#reportTable tr').eq(i).find('td').length){
						$('#reportTable tr').eq(i).find('td:eq(' + j + ')').css('border-right', '2px solid #ff9f82');
						$('#reportTable tr').eq(i).find('td:eq(' + j + ')').css('border-top', '2px solid #ff9f82');
						$('#reportTable tr').eq(i).find('td:eq(' + j + ')').css('border-bottom', '2px solid #ff9f82');
					}else{
						$('#reportTable tr').eq(i).find('td:eq(' + j + ')').css('border-top', '2px solid #ff9f82');
						$('#reportTable tr').eq(i).find('td:eq(' + j + ')').css('border-bottom', '2px solid #ff9f82');
					}
				}else{
					$('#reportTable tr').eq(i).find('td:eq(' + j + ')').css('border', '1px solid #e4e4e4');
				}
			}
		}
	}
	
	function onRowClick(index){
		
		initIndex = index;
		
		var role = ${sessionInfo.role};
		var hiddenManager = ${sessionInfo.hiddenManager};
		var constructionIdx = ${sessionInfo.constructionIdx};
		var conIdx = ${param.constructionIdx};
		var isBig = ${isBig};
		var extensivePileUsage = ${extensivePileUsage}
		
		var currentNo;
		var currentDate;
		var currentPileType;
		var currentMethod;
		var currentLocation;
		var currentPileNo;
		var currentPileStandard;
		var currentPileSum;
	
		var currentDrillingDepth;
		var currentSdDrillingDepth;
		var currentStDrillingDepth;
		
		var currentIntrusionDepth;
		var currentBalance;
		var currentGongSac;
		var currentHammaT;
		var currentFallMeter;
		var currentManagedStandard;
		var currentAvgPenetrationValue;
		var currentTotalPenetrationValue;
		
		
		if(role == 0 || role == 3 || hiddenManager == true){
			
			currentNo = $('#reportTable tr').eq(index).find('td:eq(1)').text().trim();
			currentDate = $('#reportTable tr').eq(index).find('td:eq(2)').text().trim();
			currentPileType = $('#reportTable tr').eq(index).find('#pileType').val();
			currentMethod = $('#reportTable tr').eq(index).find('#method').val();
			currentLocation = $('#reportTable tr').eq(index).find('#location').val();
			currentPileNo = $('#reportTable tr').eq(index).find('#pileNo').val();
			currentPileStandard = $('#reportTable tr').eq(index).find('#pileStandard').val().trim();
			
			
			currentPileSum = $('#reportTable tr').eq(index).find(extensivePileUsage > 0 ? 'td:eq(15)' : 'td:eq(13)').text().trim();
		
			currentDrillingDepth = $('#reportTable tr').eq(index).find('#drillingDepth').val();
			currentIntrusionDepth = $('#reportTable tr').eq(index).find('#intrusionDepth').val();
			
			if(constructionIdx == 1082 || conIdx == 1082){
				
				var currentSdDrillingDepth = $('#reportTable tr').eq(index).find('#sdDrillingDepth').val();
				var currentStDrillingDepth = $('#reportTable tr').eq(index).find('#stDrillingDepth').val();
				
				currentBalance = $('#reportTable tr').eq(index).find(extensivePileUsage > 0 ? 'td:eq(21)' : 'td:eq(19)').text().trim();
				currentGongSac = $('#reportTable tr').eq(index).find(extensivePileUsage > 0 ? 'td:eq(22)' : 'td:eq(20)').text().trim();
				currentHammaT =  $('#reportTable tr').eq(index).find('#hammaT').val();
				currentFallMeter =  $('#reportTable tr').eq(index).find('#fallMeter').val();
				currentManagedStandard =  $('#reportTable tr').eq(index).find('#managedStandard').val();
				if(isBig > 0){
					currentAvgPenetrationValue = $('#reportTable tr').eq(index).find(extensivePileUsage > 0 ? 'td:eq(36)' : 'td:eq(34)').text().trim();
					currentTotalPenetrationValue = $('#reportTable tr').eq(index).find(extensivePileUsage > 0 ? 'td:eq(37)' : 'td:eq(35)').text().trim();
				}else{
					currentAvgPenetrationValue = $('#reportTable tr').eq(index).find(extensivePileUsage > 0 ? 'td:eq(31)' : 'td:eq(29)').text().trim();
					currentTotalPenetrationValue = $('#reportTable tr').eq(index).find(extensivePileUsage > 0 ? 'td:eq(32)' : 'td:eq(30)').text().trim();
				}
				
			}else{
				
				if(constructionIdx == 1269 || conIdx == 1269){
					currentBalance = $('#reportTable tr').eq(index).find(extensivePileUsage > 0 ? 'td:eq(20)' : 'td:eq(18)').text().trim();
					currentGongSac = $('#reportTable tr').eq(index).find(extensivePileUsage > 0 ? 'td:eq(21)' : 'td:eq(19)').text().trim();
					currentHammaT =  $('#reportTable tr').eq(index).find('#hammaT').val();
					currentFallMeter =  $('#reportTable tr').eq(index).find('#fallMeter').val();
					currentManagedStandard =  $('#reportTable tr').eq(index).find('#managedStandard').val();
					if(isBig > 0){
						currentAvgPenetrationValue = $('#reportTable tr').eq(index).find(extensivePileUsage > 0 ? 'td:eq(35)' : 'td:eq(33)').text().trim();
						currentTotalPenetrationValue = $('#reportTable tr').eq(index).find(extensivePileUsage > 0 ? 'td:eq(36)' : 'td:eq(34)').text().trim();
					}else{
						currentAvgPenetrationValue = $('#reportTable tr').eq(index).find(extensivePileUsage > 0 ? 'td:eq(30)' : 'td:eq(28)').text().trim();
						currentTotalPenetrationValue = $('#reportTable tr').eq(index).find(extensivePileUsage > 0 ? 'td:eq(31)' : 'td:eq(29)').text().trim();
					}
					
				}else{
					currentBalance = $('#reportTable tr').eq(index).find(extensivePileUsage > 0 ? 'td:eq(19)' : 'td:eq(17)').text().trim();
					currentGongSac = $('#reportTable tr').eq(index).find(extensivePileUsage > 0 ? 'td:eq(20)' : 'td:eq(18)').text().trim();
					currentHammaT =  $('#reportTable tr').eq(index).find('#hammaT').val();
					currentFallMeter =  $('#reportTable tr').eq(index).find('#fallMeter').val();
					currentManagedStandard =  $('#reportTable tr').eq(index).find('#managedStandard').val();
					if(isBig > 0){
						currentAvgPenetrationValue = $('#reportTable tr').eq(index).find(extensivePileUsage > 0 ? 'td:eq(34)' : 'td:eq(32)').text().trim();
						currentTotalPenetrationValue = $('#reportTable tr').eq(index).find(extensivePileUsage > 0 ? 'td:eq(35)' : 'td:eq(33)').text().trim();
					}else{
						currentAvgPenetrationValue = $('#reportTable tr').eq(index).find(extensivePileUsage > 0 ? 'td:eq(29)' : 'td:eq(27)').text().trim();
						currentTotalPenetrationValue = $('#reportTable tr').eq(index).find(extensivePileUsage > 0 ? 'td:eq(30)' : 'td:eq(28)').text().trim();
					}
				}
			}
			
		}else{
			
			currentNo = $('#reportTable tr').eq(index).find('td:eq(0)').text().trim();
			currentDate = $('#reportTable tr').eq(index).find('td:eq(1)').text().trim();
			currentPileType = $('#reportTable tr').eq(index).find('#pileType').val();
			currentMethod = $('#reportTable tr').eq(index).find('#method').val();
			currentLocation = $('#reportTable tr').eq(index).find('#location').val();
			currentPileNo = $('#reportTable tr').eq(index).find('#pileNo').val();
			currentPileStandard = $('#reportTable tr').eq(index).find('#pileStandard').val().trim();
			currentPileSum = $('#reportTable tr').eq(index).find(extensivePileUsage > 0 ? 'td:eq(14)' : 'td:eq(12)').text().trim();
		
			currentDrillingDepth = $('#reportTable tr').eq(index).find('#drillingDepth').val();
			currentIntrusionDepth = $('#reportTable tr').eq(index).find('#intrusionDepth').val();
			
			
			if(constructionIdx == 1082 || conIdx == 1082){
				
				var currentSdDrillingDepth = $('#reportTable tr').eq(index).find('#sdDrillingDepth').val();
				var currentStDrillingDepth = $('#reportTable tr').eq(index).find('#stDrillingDepth').val();
				
				currentBalance = $('#reportTable tr').eq(index).find(extensivePileUsage > 0 ? 'td:eq(20)' : 'td:eq(18)').text().trim();
				currentGongSac = $('#reportTable tr').eq(index).find(extensivePileUsage > 0 ? 'td:eq(21)' : 'td:eq(19)').text().trim();
				currentHammaT =  $('#reportTable tr').eq(index).find('#hammaT').val();
				currentFallMeter =  $('#reportTable tr').eq(index).find('#fallMeter').val();
				currentManagedStandard =  $('#reportTable tr').eq(index).find('#managedStandard').val();
				
				if(isBig > 0){
					currentAvgPenetrationValue = $('#reportTable tr').eq(index).find(extensivePileUsage > 0 ? 'td:eq(35)' : 'td:eq(33)').text().trim();
					currentTotalPenetrationValue = $('#reportTable tr').eq(index).find(extensivePileUsage > 0 ? 'td:eq(36)' : 'td:eq(34)').text().trim();
				}else{
					currentAvgPenetrationValue = $('#reportTable tr').eq(index).find(extensivePileUsage > 0 ? 'td:eq(30)' : 'td:eq(28)').text().trim();
					currentTotalPenetrationValue = $('#reportTable tr').eq(index).find(extensivePileUsage > 0 ? 'td:eq(31)' : 'td:eq(29)').text().trim();
				}
				
			}else{
				
				if(constructionIdx == 1269 || conIdx == 1269){
					currentBalance = $('#reportTable tr').eq(index).find(extensivePileUsage > 0 ? 'td:eq(19)' : 'td:eq(17)').text().trim();
					currentGongSac = $('#reportTable tr').eq(index).find(extensivePileUsage > 0 ? 'td:eq(20)' : 'td:eq(18)').text().trim();
					currentHammaT =  $('#reportTable tr').eq(index).find('#hammaT').val();
					currentFallMeter =  $('#reportTable tr').eq(index).find('#fallMeter').val();
					currentManagedStandard =  $('#reportTable tr').eq(index).find('#managedStandard').val();
					
					if(isBig > 0){
						currentAvgPenetrationValue = $('#reportTable tr').eq(index).find(extensivePileUsage > 0 ? 'td:eq(34)' : 'td:eq(32)').text().trim();
						currentTotalPenetrationValue = $('#reportTable tr').eq(index).find(extensivePileUsage > 0 ? 'td:eq(35)' : 'td:eq(33)').text().trim();
					}else{
						currentAvgPenetrationValue = $('#reportTable tr').eq(index).find(extensivePileUsage > 0 ? 'td:eq(29)' : 'td:eq(27)').text().trim();
						currentTotalPenetrationValue = $('#reportTable tr').eq(index).find(extensivePileUsage > 0 ? 'td:eq(30)' : 'td:eq(28)').text().trim();
					}
				}else{
					currentBalance = $('#reportTable tr').eq(index).find(extensivePileUsage > 0 ? 'td:eq(18)' : 'td:eq(16)').text().trim();
					currentGongSac = $('#reportTable tr').eq(index).find(extensivePileUsage > 0 ? 'td:eq(19)' : 'td:eq(17)').text().trim();
					currentHammaT =  $('#reportTable tr').eq(index).find('#hammaT').val();
					currentFallMeter =  $('#reportTable tr').eq(index).find('#fallMeter').val();
					currentManagedStandard =  $('#reportTable tr').eq(index).find('#managedStandard').val();
					
					if(isBig > 0){
						currentAvgPenetrationValue = $('#reportTable tr').eq(index).find(extensivePileUsage > 0 ? 'td:eq(33)' : 'td:eq(31)').text().trim();
						currentTotalPenetrationValue = $('#reportTable tr').eq(index).find(extensivePileUsage > 0 ? 'td:eq(34)' : 'td:eq(32)').text().trim();
					}else{
						currentAvgPenetrationValue = $('#reportTable tr').eq(index).find(extensivePileUsage > 0 ? 'td:eq(28)' : 'td:eq(26)').text().trim();
						currentTotalPenetrationValue = $('#reportTable tr').eq(index).find(extensivePileUsage > 0 ? 'td:eq(29)' : 'td:eq(27)').text().trim();
					}
				}
			}
			
		}		
		
		$('#curNo').text(currentNo);
		if(currentDate.length > 10){
			var date1 = currentDate.split(" ");
			$('#curDate').html(date1[0] + '</br>' + date1[1]);
		}else{
			$('#curDate').text(currentDate);
		}
		$('#curPileType').text(currentPileType);
		$('#curMethod').text(currentMethod);
		$('#curLocation').text(currentLocation);
		$('#curPileNo').text(currentPileNo);
		$('#curPileStandard').text(currentPileStandard);
		$('#curPileSum').text(currentPileSum);
		
		if(constructionIdx == 1082 || conIdx == 1082){
			var total = Number(currentDrillingDepth) + Number(currentSdDrillingDepth) + Number(currentStDrillingDepth);
			$('#curDrillingDepth').text(total);
		}else if(constructionIdx == 1269 || conIdx == 1269){
			var directDrillingDepth = $('#reportTable tr').eq(index).find('#directDrillingDepth').val();
			$('#curDrillingDepth').text(currentDrillingDepth + " + " + directDrillingDepth);
		}else{
			$('#curDrillingDepth').text(currentDrillingDepth);
		}
		$('#curIntrusionDepth').text(currentIntrusionDepth);
		$('#curBalance').text(currentBalance);
		$('#curGongSac').text(currentGongSac);
		$('#curHammaT').text(currentHammaT);
		$('#curFallMeter').text(currentFallMeter);
		$('#curManagedStandard').text(currentManagedStandard);
		$('#curAvgPenetrationValue').text(currentAvgPenetrationValue);
		$('#curTotalPenetrationValue').text(currentTotalPenetrationValue);
		
		$('#mCurNo').text(currentNo);
		
		if(currentDate.length > 10){
			var date1 = currentDate.split(" ");
			//$('#mCurDate').html(date1[0] + '</br>' + date1[1]);
			$('#mCurDate').html(date1[0]);
		}else{
			$('#mCurDate').text(currentDate);
		}
		$('#mCurPileType').text(currentPileType);
		$('#mCurMethod').text(currentMethod);
		$('#mCurLocation').text(currentLocation);
		$('#mCurPileNo').text(currentPileNo);
		$('#mCurPileStandard').text(currentPileStandard);
		$('#mCurPileSum').text(currentPileSum);
		
		if(constructionIdx == 1082 || conIdx == 1082){
			var total = Number(currentDrillingDepth) + Number(currentSdDrillingDepth) + Number(currentStDrillingDepth);
			$('#mCurDrillingDepth').text(total);
		}else{
			$('#mCurDrillingDepth').text(currentDrillingDepth);
		}
		
		$('#mCurIntrusionDepth').text(currentIntrusionDepth);
		$('#mCurBalance').text(currentBalance);
		$('#mCurGongSac').text(currentGongSac);
		$('#mCurHammaT').text(currentHammaT);
		$('#mCurFallMeter').text(currentFallMeter);
		$('#mCurManagedStandard').text(currentManagedStandard);
		$('#mCurAvgPenetrationValue').text(currentAvgPenetrationValue);
		$('#mCurTotalPenetrationValue').text(currentTotalPenetrationValue);
		
		setTrActiviEffect(index);
		
		var penetrations = document.getElementsByName("penetrations[" + index+ "]");
		var penetrationsId = document.getElementsByName("penetrationsId[" + index + "]");
		var penetrationsName = document.getElementsByName("penetrationsName[" + index + "]");
		
		var arrValues = new Array();    //배열 선언
		var arrLabelValues = new Array();    //배열 선언
		var arrGepValues = new Array();    //배열 선언
		const markLineArr = [];
		var sum = 0;
		for(var k=0; k<penetrations.length; k++){
			var value = penetrations[k].value != "" ? Number(penetrations[k].value) : Number(0);
			sum = sum + value;
			arrValues.push(sum.toFixed(1));
			arrLabelValues.push((k + 1) + "회 측정");
		}
		
		for(var i=0; i<arrValues.length; i++){
			if(i == 0){
				arrGepValues.push(0);	
			}else{
				arrGepValues.push((arrValues[i] - arrValues[i - 1]).toFixed(1));	
			}
		}
		
		for(var i=0; i<arrValues.length; i++){
			markLineArr.push([
		     {
		        coord: [i, arrValues[i]],
		        label: {
		          formatter: arrGepValues[i + Number(1)],
		          position: 'insideMiddleTop'
		        }
		      },
		      {
		        coord: [i + Number(1), arrValues[i + Number(1)]]
		      }
		    ]);
		}
		
		var myChart = echarts.init(document.getElementById('main'));
		var temp = -1;
		var temp2 = -1;
		var minValue = 0;
		var maxValue = 0;
	      // Specify the configuration items and data for the chart
	      //labelOption = 
	      
	      option = {
			  title: {
			    text: ''
			  },
			  tooltip: {
			    trigger: 'axis',
			    axisPointer: {
			    	type: 'cross'
			    }
			  //,
			  //  formatter: function(params){
			  //  	 if(params[1].value == 0){
			  //  	return '관입량 : ' + params[0].value;
			  //  	}else{
			  //	    	return '관입량 : ' + params[1].value;
			  //  	}
			  // 	;
    	      //	},
			  },
			 
			  grid: {
			    left: '3%',
			    right: '4%',
			    bottom: '3%',
			    containLabel: true
			  },
			  toolbox: {
			    feature: {
			      //saveAsImage: {}
			    }
			  },
			  xAxis: {
			    type: 'category',
			    data: arrLabelValues
			  },
			  yAxis: {
				  
			  },
			  legend: {
				  icon: 'rect',
				  left : '1%'
			  },
			  series: [
			    {
			      name: '관입량',
			      type: 'line',
			      step: 'end',
			      data: arrValues,
			      itemStyle: {color: '#00adef'},
			      label: {
			    	  formatter: function (d) {
			    		  	//temp++;  
					    	// if(temp == 0){
					    	//	return '{a|' + d.data + '} ( {a|' + d.data + '} )';
					    	//}
					    	//return '{a|' + d.data + '} ( {b|' + arrGepValues[temp] + '} )';
					    	
					    	temp++;  
					    	 if(temp == 0){
					    		return '{a|' + d.data + '}';
					    	}
					    	return '{a|' + d.data + '} {b|( ' + arrGepValues[temp] + ' )}';
		    	      	},
		     		  	show: true,
		  	    	  	data: arrValues,
		  	    	  	position: 'top',
		  	          	color: "black",
		  	          	fontSize: 12,
						fontWeight : 'bold',
						rich:{
		  	        		a:{
		  	        			color: '#00adef'
		  	        	  	},
		  	        	  	b:{
		  	        		  	
		  	        		  	color: '#3fe86c'
		  	        	  	}
		  	          	}
		  	      	}
			    },
			    {
			    	 name: '관입량의 차',
				     type: 'line',
				     step: 'end',
				     //data: arrGepValues,
				     data: [],
				     itemStyle: {color: '#3fe86c'},
				     show : false
				     //, markLine : {
				     //     	lineStyle: {
				     //       	type: 'dashed'
				     //     	},
				     //     	label: {
				     //     		color: '#3fe86c'
				     //       },
				     //     	data: markLineArr
				     //     }
			    }
			   
			  ]
			};
	
	      // Display the chart using the configuration items and data just specified.
	      myChart.setOption(option);
	      //console.log('option : ' + option.yAxis.type);
	      //console.log('minValue : ' + minValue);
	      //console.log('maxValue : ' + maxValue);
	      //console.log(myChart.getOption());
		  showPdf(index, ${sessionInfo.role}, ${sessionInfo.hiddenManager}, ${isBig}, ${extensivePileUsage});
		
	}
	
	function getPieceNameByIndex(index){
		var extensivePileUsage = ${extensivePileUsage};
		if(extensivePileUsage > 0){
			if(index == 0){
				return '단본';
			}else if(index == 1){
				return '하단';
			}else if(index == 2){
				return '중단';
			}else if(index == 3){
				return '중단';
			}else if(index == 4){
				return '중단';
			}else if(index == 5){
				return '중단';
			}else if(index == 6){
				return '상단';
			}
		}else{
			if(index == 0){
				return '단본';
			}else if(index == 1){
				return '하단';
			}else if(index == 2){
				return '중단';
			}else if(index == 3){
				return '중단';
			}else if(index == 4){
				return '상단';
			}
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
			
			var piece     = $('#reportTable tr').eq(i).find('[name="piece[' + i + ']"]');
			var pieceId   = $('#reportTable tr').eq(i).find('[name="pieceId[' + i + ']"]');
			var pieceName = $('#reportTable tr').eq(i).find('[name="pieceName[' + i + ']"]');
			
			//var piece = document.getElementsByName("piece[" + i + "]");
			//var pieceId = document.getElementsByName("pieceId[" + i + "]");
			//var pieceName = document.getElementsByName("pieceName[" + i + "]");
			
			if(role == 0){
				//var penetrations = document.getElementsByName("penetrations[" + i + "]");
				//var penetrationsId = document.getElementsByName("penetrationsId[" + i + "]");
				//var penetrationsName = document.getElementsByName("penetrationsName[" + i + "]");
				
				var penetrations     = $('#reportTable tr').eq(i).find('[name="penetrations[' + i + ']"]');
				var penetrationsId   = $('#reportTable tr').eq(i).find('[name="penetrationsId[' + i + ']"]');
				var penetrationsName = $('#reportTable tr').eq(i).find('[name="penetrationsName[' + i + ']"]');
			}
			
			//alert('piece.length : ' + piece.length);
			
			var pieces = [];
			for(var j=0; j<piece.length; j++){
				var onePiece = {
						name: getPieceNameByIndex(j), //수정
						value : piece[j].value != "" ? 	piece[j].value : "0",
						id : Number(pieceId[j].value) != Number(0) ? Number(pieceId[j].value) : Number(0),
						reportIdx :Number($('#reportTable tr').eq(i).find('#id').val())
				};
				pieces.push(onePiece);	
			}
			
			
			//alert('pieces length : '  + JSON.stringify(pieces));
			
			if(role == 0){
				
				var penetrationss = [];
				
				for(var k=0; k<penetrations.length; k++){
					if(penetrations[k].value != ""){
						var onePenetrations = {
								name: penetrationsName[k].value != "" ? penetrationsName[k].value : "null",
								value : penetrations[k].value != "" ? 	penetrations[k].value : "0",
								id : Number(penetrationsId[k].value) != Number(0) ? Number(penetrationsId[k].value) : Number(0),
								reportIdx :Number($('#reportTable tr').eq(i).find('#id').val())
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
						directDrillingDepth: $('#reportTable tr').eq(i).find('#directDrillingDepth').val() != "" ? $('#reportTable tr').eq(i).find('#directDrillingDepth').val()  : "0", 
						sdDrillingDepth: $('#reportTable tr').eq(i).find('#sdDrillingDepth').val() != "" ? $('#reportTable tr').eq(i).find('#sdDrillingDepth').val()  : "0", 
						stDrillingDepth: $('#reportTable tr').eq(i).find('#stDrillingDepth').val() != "" ? $('#reportTable tr').eq(i).find('#stDrillingDepth').val()  : "0", 
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
						directDrillingDepth: $('#reportTable tr').eq(i).find('#directDrillingDepth').val() != "" ? $('#reportTable tr').eq(i).find('#directDrillingDepth').val()  : "0", 
						sdDrillingDepth: $('#reportTable tr').eq(i).find('#sdDrillingDepth').val() != "" ? $('#reportTable tr').eq(i).find('#sdDrillingDepth').val()  : "0", 
						stDrillingDepth: $('#reportTable tr').eq(i).find('#stDrillingDepth').val() != "" ? $('#reportTable tr').eq(i).find('#stDrillingDepth').val()  : "0", 
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
		
		//console.log(' JSON.stringify(reports) : ' +  JSON.stringify(reports));
		
		var result = confirm("수정하시겠습니까?");
		if(result){
			// 중복 제출 방지: 요청 중 모든 수정 버튼 비활성화
			$('[onclick*="onClickReportUpdate"]').prop('disabled', true).css('pointer-events', 'none').css('opacity', '0.5');
			jQuery.ajax({
				type : "POST",
				url : "${pageContext.request.contextPath}/report/update/reportMulti",
				data: JSON.stringify(reports),
				dataType : "JSON",
				contentType : "application/json",
				success : function(data) {
					if(data == true){
						pageReload(); // 성공 시 페이지 리로드 → 버튼 자연 리셋
					}
				},
				complete : function(data) {
					// 실패/오류 시 버튼 복원 (성공 시엔 pageReload가 먼저 실행됨)
					$('[onclick*="onClickReportUpdate"]').prop('disabled', false).css('pointer-events', '').css('opacity', '');
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
		var constructionIdx = ${sessionInfo.constructionIdx};
		var conIdx = ${param.constructionIdx};
		var obj = document.getElementsByName("selectOne");
		var index = rowindex;
		
		
		var id = $('#reportTable').find("#id");
		var pileType = document.getElementsByName("pileType");
		//var method = document.getElementsByName("method");
		var method = $('#reportTable').find("#method");
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

		
		
		if(constructionIdx == 1012 || constructionIdx == 834 ){
			//drillingDepth[index].disabled = false;
			//intrusionDepth[index].disabled = false;
		}else{
			drillingDepth[index].disabled = true;
			intrusionDepth[index].disabled = true;
		}
		
		
		if(constructionIdx == 1082 || conIdx == 1082 ){
			document.getElementsByName("sdDrillingDepth")[index].disabled = true;
			document.getElementsByName("stDrillingDepth")[index].disabled = true;
		}
		
		if(constructionIdx == 1269 || conIdx == 1269 ){
			document.getElementsByName("directDrillingDepth")[index].disabled = true;
		}
		
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
		var constructionIdx = ${sessionInfo.constructionIdx};
		var conIdx = ${param.constructionIdx};
		var obj = document.getElementsByName("selectOne");
		var index = rowindex;
		
		
		var id = $('#reportTable').find("#id");
		var pileType = document.getElementsByName("pileType");
		//var method = document.getElementsByName("method");
		var method = $('#reportTable').find("#method");
		var location = $('#reportTable').find("#location");
		var pileNo = $('#reportTable').find("#pileNo");
		var pileStandard = document.getElementsByName("pileStandard");

		var drillingDepth = document.getElementsByName("drillingDepth");
		//var directDrillingDepth = document.getElementsByName("directDrillingDepth");
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

		
		
		if(constructionIdx == 1012 || constructionIdx == 834 ){
			//drillingDepth[index].disabled = false;
			//intrusionDepth[index].disabled = false;
		}else{
			drillingDepth[index].disabled = false;
			intrusionDepth[index].disabled = false;
		}
		
		if(constructionIdx == 1082 || conIdx == 1082 ){
			document.getElementsByName("sdDrillingDepth")[index].disabled = false;
			document.getElementsByName("stDrillingDepth")[index].disabled = false;
		}
		
		if(constructionIdx == 1269 || conIdx == 1269 ){
			document.getElementsByName("directDrillingDepth")[index].disabled = false;
		}
		
		
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
		var constructionIdx = ${sessionInfo.constructionIdx};
		var conIdx = ${param.constructionIdx};
		var obj = document.getElementsByName("selectOne");
		var index = rowindex;
		
		
		var id = $('#reportTable').find("#id");
		var pileType = document.getElementsByName("pileType");
		//var method = document.getElementsByName("method");
		var method = $('#reportTable').find("#method");
		var location = $('#reportTable').find("#location");
		var pileNo = $('#reportTable').find("#pileNo");
		var isDel = $('#reportTable').find("#isDel");
		var pileStandard = document.getElementsByName("pileStandard");

		var drillingDepth = document.getElementsByName("drillingDepth");
		//var directDrillingDepth = document.getElementsByName("directDrillingDepth");
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
			
			if(constructionIdx == 1012 || constructionIdx == 834 ){
				//drillingDepth[index].disabled = false;
				//intrusionDepth[index].disabled = false;
			}else{
				//directDrillingDepth[index].disabled = false;
				drillingDepth[index].disabled = false;
				intrusionDepth[index].disabled = false;
			}
			
			
			if(constructionIdx == 1082 || conIdx == 1082 ){
				document.getElementsByName("sdDrillingDepth")[index].disabled = false;
				document.getElementsByName("stDrillingDepth")[index].disabled = false;
			}
			if(constructionIdx == 1269 || conIdx == 1269 ){
				document.getElementsByName("directDrillingDepth")[index].disabled = false;
			}
			
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

			//drillingDepth[index].disabled = true;
			//intrusionDepth[index].disabled = true;
			
			
			if(constructionIdx == 1012 || constructionIdx == 834 ){
				//drillingDepth[index].disabled = false;
				//intrusionDepth[index].disabled = false;
			}else{
				//directDrillingDepth[index].disabled = true;
				drillingDepth[index].disabled = true;
				intrusionDepth[index].disabled = true;
			}
			
			if(constructionIdx == 1082 || conIdx == 1082 ){
				document.getElementsByName("sdDrillingDepth")[index].disabled = true;
				document.getElementsByName("stDrillingDepth")[index].disabled = true;
			}
			
			if(constructionIdx == 1269 || conIdx == 1269 ){
				document.getElementsByName("directDrillingDepth")[index].disabled = true;
			}
			
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
			location.href = '${pageContext.request.contextPath}/report/download/excel?' + para[1];
		}else{
			$("#searchForm").attr("action", "${pageContext.request.contextPath}/report/download/excel");
			$("#searchForm").submit();
			$("#searchForm").attr("action", "");
		}
	}
	
	function searchForm(){
		$('#type').val("all");
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
	
	function highlight(cell){
		cell.style.borderColor = "red";
	}
	
	function originalColor(cell){
		cell.style.borderColor = "black";
	}
	
	
	function onClickReportPrev(){
		if(initIndex > 0){
			onRowClick(initIndex - 1);
		}
		
	}
	
	function onClickReportNext(){
		if($('#reportTable tr').length > (initIndex + 1)){
			onRowClick(initIndex + 1);
		}
	}
	
	
	function getExcelSignInfo(){
		var conIdx = ${param.constructionIdx};
		
		jQuery.ajax({
			type : "POST",
			url : "${pageContext.request.contextPath}/excel/signroom/get/list",
			data: { constructionIdx : conIdx }, 
			dataType : "JSON", // 옵션이므로 JSON으로 받을게 아니면 안써도 됨
			success : function(data) {
				var i = 1;
				$.each(data, function(index, item) {
					
					$('#excel_sigmroom_table tr').eq(i).find('#id').val(item.id);
					$('#excel_sigmroom_table tr').eq(i).find('#seq').val(item.seq);
					$('#excel_sigmroom_table tr').eq(i).find('#approver').val(item.approver);
					$('#excel_approver' + i).val(item.approver);
					i++;
				});
			},
			complete : function(data) {
			},
			error : function(xhr, status, error) {
			}
		});
	}
	
	function getPdfSignInfo(){
		var conIdx = ${param.constructionIdx};
		jQuery.ajax({
			type : "POST",
			url : "${pageContext.request.contextPath}/signroom/get/list",
			data: { constructionIdx : conIdx }, 
			dataType : "JSON", // 옵션이므로 JSON으로 받을게 아니면 안써도 됨
			success : function(data) {
				var i = 1;
				$.each(data, function(index, item) {
					$('#sigmroom_table tr').eq(i).find('#id').val(item.id);
					$('#sigmroom_table tr').eq(i).find('#seq').val(item.seq);
					$('#sigmroom_table tr').eq(i).find('#approver').val(item.approver);
					$('#approver' + i).val(item.approver);
					i++;
				});
			},
			complete : function(data) {
			},
			error : function(xhr, status, error) {
			}
		});
	}
	
	
	function registExcelSignRoomCheck(){
		
		var signRoomArr = [];
		var userId = '${sessionInfo.userId}';
		var conIdx = ${param.constructionIdx};
		
		for (var i = 1; i < $('#excel_sigmroom_table tr').length; i++) {
			
			var data = {
				id : Number($('#excel_sigmroom_table tr').eq(i).find('#id').val() != "" ? $('#excel_sigmroom_table tr').eq(i).find('#id').val() : 0)
				, constructionIdx : Number(conIdx)
				, seq : Number($('#excel_sigmroom_table tr').eq(i).find('#seq').val())
				, approver : $('#excel_sigmroom_table tr').eq(i).find('#approver').val() != "" ? $('#excel_sigmroom_table tr').eq(i).find('#approver').val() : null
				, modifyter : userId
				, creator : userId
			}
			signRoomArr.push(data);
		}
		
		if(signRoomArr.length == 0){
			alert('선택된 항목이 없습니다.');
			reports = [];
			return;
		}
		
		var result = confirm("설정 하시겠습니까?");
		if(result){
			jQuery.ajax({
				type : "POST",
				url : "${pageContext.request.contextPath}/excel/signroom/update/all",
				data: JSON.stringify(signRoomArr), 
				dataType : "JSON", // 옵션이므로 JSON으로 받을게 아니면 안써도 됨
				contentType : "application/json",
				success : function(data) {
					if(data == true){
						getExcelSignInfo();
						//	pageReload();
						$('.popUp').hide();
						$('.popLayer').hide();
						$('body').css('overflow', 'auto');
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
	
	function registSignRoomCheck(){
		
		var signRoomArr = [];
		var userId = '${sessionInfo.userId}';
		var conIdx = ${param.constructionIdx};
		
		for (var i = 1; i < $('#sigmroom_table tr').length; i++) {
			
			var data = {
				id : Number($('#sigmroom_table tr').eq(i).find('#id').val() != "" ? $('#sigmroom_table tr').eq(i).find('#id').val() : 0)
				, constructionIdx : Number(conIdx)
				, seq : Number($('#sigmroom_table tr').eq(i).find('#seq').val())
				, approver : $('#sigmroom_table tr').eq(i).find('#approver').val() != "" ? $('#sigmroom_table tr').eq(i).find('#approver').val() : null
				, modifyter : userId
				, creator : userId
			}
			signRoomArr.push(data);
		}
		
		if(signRoomArr.length == 0){
			alert('선택된 항목이 없습니다.');
			reports = [];
			return;
		}
		
		var result = confirm("설정 하시겠습니까?");
		if(result){
			jQuery.ajax({
				type : "POST",
				url : "${pageContext.request.contextPath}/signroom/update/all",
				data: JSON.stringify(signRoomArr), 
				dataType : "JSON", // 옵션이므로 JSON으로 받을게 아니면 안써도 됨
				contentType : "application/json",
				success : function(data) {
					if(data == true){
						getPdfSignInfo();
						//	pageReload();
						$('.popUp').hide();
						$('.popLayer').hide();
						$('body').css('overflow', 'auto');
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
	
	
	var drivingRecordParams = null;

	function openDrivingRecordPopup() {

	    document.getElementById('drivingRecordOverlay').style.display = 'block';
	    document.getElementById('drivingRecordPopup').style.display = 'block';
	}

	function closeDrivingRecordPopup() {
	    document.getElementById('drivingRecordOverlay').style.display = 'none';
	    document.getElementById('drivingRecordPopup').style.display = 'none';
	}

	function confirmDrivingRecordDownload() {
	    var radios = document.getElementsByName('hitOption');
	    var hitOption = 'N';   // 기본값

	    for (var i = 0; i < radios.length; i++) {
	        if (radios[i].checked) {
	            hitOption = radios[i].value;
	            break;
	        }
	    } 
	    closeDrivingRecordPopup();

	    downloadDrivingOneRecoredBook(hitOption);
	}
	
	function openCopyReportPopup() {
		var $checkedBox = $('input[name="selectOne"]:checked');
		if ($checkedBox.length !== 1) {
			alert('복사할 기록지를 1개만 체크해주세요.');
			return;
		}
		copyAndInsertReport($checkedBox[0]);
	}

	function openDateEditPopupBtn() {
		var $checkedBox = $('input[name="selectOne"]:checked');
		if ($checkedBox.length !== 1) {
			alert('시공일을 수정할 기록지를 1개만 체크해주세요.');
			return;
		}
		var $tr = $checkedBox.closest('tr');
		var tdElement = $tr.find('input#id').closest('td')[0];
		openDateUpdatePopup(tdElement);
	}
	
	function openNewReportPopup() {
	    $('.copy-input').val(""); 
	    $('#copy_rownum').val("신규");
	    
	    $('#saveBtn').attr('onclick', "submitReport('new')");
	    $('#saveBtn').text('신규 데이터 저장');

	    $('.mid-group').hide();
	    $('#mainTitle').attr('colspan', '5');
	    $('#footer_total').attr('colspan', '1');
	    $('#footer_connect').attr('colspan', '2');
	    
	    var isBig = ${isBig};
	    if (isBig > 0) {
	        $('.meas-big-group').show();
	    } else {
	        $('.meas-big-group').hide();
	    }

	    $('.popUp04').find('.popTit p').text('신규 기록지 작성');
	    $('.popUp04').css('display', 'flex');
	    $('.popLayer').show();
	    $('body').css('overflow', 'hidden');
	}
	
	
	function copyAndInsertReport(element) {
	    var $tr = $(element).closest('tr');
	    
	    $('.copy-input').each(function() {
	        var name = $(this).attr('name'); 
	        if (!name || name === "piece") return; 
	        var $target = $tr.find('input[name*="' + name + '"]').not('[name*="Id"]').not('[name*="Name"]');
	        var idx = $(this).attr('data-idx');
	        if ($target.length > 0) {
	            if (idx !== undefined && idx !== false) {
	                $(this).val($target.eq(parseInt(idx)).val() || "");
	            } else {
	                $(this).val($target.first().val() || "");
	            }
	        }
	    });

	    var pieceInputs = $tr.find('input[name*="piece["]'); 
	    var copyInputs = ['copy_piOne', 'copy_piTwo', 'copy_piThree', 'copy_piFour', 'copy_piFive', 'copy_piSix', 'copy_piSeven'];
	    
	    for(var i = 0; i < copyInputs.length; i++) {
	        var val = (i < pieceInputs.length) ? pieceInputs.eq(i).val() : "";
	        $('#' + copyInputs[i]).val(val || "");
	    }

	    var hasExtraMid = ($('#copy_piFive').val().trim() !== "" && $('#copy_piFive').val() !== "0") || 
	                      ($('#copy_piSix').val().trim() !== "" && $('#copy_piSix').val() !== "0");

	    if (hasExtraMid) {
	        $('.mid-group').css('display', 'table-cell');
	        $('#mainTitle').attr('colspan', '7');
	        $('#footer_total').attr('colspan', '2');
	        $('#footer_connect').attr('colspan', '3');
	    } else {
	        $('.mid-group').hide();
	        $('#copy_piFive').val("");
	        $('#copy_piSix').val("");
	        
	        $('#mainTitle').attr('colspan', '5');
	        $('#footer_total').attr('colspan', '1');
	        $('#footer_connect').attr('colspan', '2');
	    }

	    var originalDate = $tr.find('td').eq(2).text().trim();
	    $('#copy_createDate').val(originalDate);
	    $('#copy_currentDateTime').val(originalDate);
	    
	    var $drillTd = $tr.find('input[name="drillingDepth"]').closest('td');
	    if($drillTd.length > 0) {
	        $('#copy_connectLength').val($drillTd.prev().text().trim());          
	        $('#copy_totalConnectWidth').val($drillTd.prev().prev().text().trim()); 
	    }
	            
	    var isBig = ${isBig};
	    if (isBig > 0) {
	        $('.meas-big-group').show();
	    } else {
	        $('.meas-big-group').hide();
	    }
	    
	    var $hammaTd = $tr.find('input[name="hammaT"]').closest('td');
	    if($hammaTd.length > 0) {
	        $('#copy_gongSac').val($hammaTd.prev().text().trim());          
	        $('#copy_balance').val($hammaTd.prev().prev().text().trim());  
	    }

	    var $effTd = $tr.find('input[name="hammaEfficiency"]').closest('td');
	    if($effTd.length > 0) {
	        $('#copy_ultimateBearingCapacity').val($effTd.prev().text().trim()); 
	    }

	    $('#copy_avgPenetrationValue').val($tr.find('#avgPenetrationValue').val());
	    $('#copy_totalPenetrationValue').val($tr.find('#totalPenetrationValue').val());
	    
	    $('.popUp04').css('display', 'flex');
	    $('.popLayer').show();
	    $('body').css('overflow', 'hidden');
	    $('#saveBtn').attr('onclick', "submitReport('copy')");
	    $('#saveBtn').text('수정 데이터 저장 및 복사');
	}


	function submitReport(mode) {
	    var pieces = [];
	    var pieceIds = ['copy_piOne', 'copy_piTwo', 'copy_piThree', 'copy_piFour', 'copy_piFive', 'copy_piSix', 'copy_piSeven'];

	    var validInputs = [];
	    for (var i = 0; i < pieceIds.length; i++) {
	        var $el = $('#' + pieceIds[i]);
	        if ($el.is(':visible') && $el.val().trim() !== "") {
	            validInputs.push($el.val().trim());
	        }
	    }

	    for (var i = 0; i < validInputs.length; i++) {
	        var name;
	        if (i === 0) {
	            name = '단본';
	        } else if (i === 1) {
	            name = '하단';
	        } else if (i === validInputs.length - 1) {
	            name = '상단';
	        } else {
	            name = '중단';
	        }

			pieces.push({ 
				name: name, 
				value: validInputs[i], 
				id: 0, 
				reportIdx: 0 
			});
		}
		var createDateVal = ($('#copy_createDate').val() || "").trim();
		var dateRegex = /^\d{4}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01]) (0\d|1\d|2[0-3]):([0-5]\d):([0-5]\d)$/;

		if (!dateRegex.test(createDateVal)) {
			alert('시공일은 "YYYY-MM-DD HH:mm:ss" 형식으로 입력해야 합니다.\n(예: 2026-07-15 14:30:00)');
			$('#copy_createDate').focus();
			return;
		}
		var currentDateTimeVal = createDateVal ? createDateVal.substring(0, 10) : null;
		
		var penetrationss = [];
		var measIds = ['copy_meas1', 'copy_meas2', 'copy_meas3', 'copy_meas4', 'copy_meas5', 
					   'copy_meas6', 'copy_meas7', 'copy_meas8', 'copy_meas9', 'copy_meas10'];
		
		for (var j = 0; j < measIds.length; j++) {
			var val = $('#' + measIds[j]).val();
			if ('${isBig}' === '0' && j >= 5) break; 
			if (val) {
				penetrationss.push({
					name: (j + 1) + "회",
					value: val,
					id: 0,
					reportIdx: 0
				});
			}
		}

		var data = {
			deviceIdx: Number($('input[name="deviceIdx"]').first().val() || 0), 
			currentDateTime: currentDateTimeVal,
			createDate: createDateVal,
			pileType: $('#copy_pileType').val() || "null",
			method: $('#copy_method').val() || "null",
			location: $('#copy_location').val() || "null",
			pileNo: $('#copy_pileNo').val() || "null",
			pileStandard: $('#copy_pileStandard').val() || "null",
			piece: pieces,
			penetrations: penetrationss,
			drillingDepth: $('#copy_drillingDepth').val() || "0",
			intrusionDepth: $('#copy_intrusionDepth').val() || "0",
			balance: $('#copy_balance').val() || "0",
			gongSac: $('#copy_gongSac').val() || "0",
			hammaT: $('#copy_hammaT').val() || "0",
			fallMeter: $('#copy_fallMeter').val() || "0",
			managedStandard: $('#copy_managedStandard').val() || "0",
			avgPenetrationValue: $('#copy_avgPenetrationValue').val() || "0",
			totalPenetrationValue: $('#copy_totalPenetrationValue').val() || "0",
			ultimateBearingCapacity: $('#copy_ultimateBearingCapacity').val() || "0",
			hammaEfficiency: $('#copy_hammaEfficiency').val() || "0",
			modulusElasticity: $('#copy_modulusElasticity').val() || "0",
			crossSection: $('#copy_crossSection').val() || "0",
			sprCol1: $('#copy_sprCol1').val() || "null", 
			bigo: $('#copy_bigo').val() || "null"        
		};

		var url = (mode === 'new') ? "${pageContext.request.contextPath}/report/insertNew" : "${pageContext.request.contextPath}/report/insertCopied";
		var confirmMsg = (mode === 'new') ? "현재 입력된 내용으로 새로운 기록을 추가하시겠습니까?" : "현재 입력된 내용으로 기록지를 추가하시겠습니까?";
		var successMsg = (mode === 'new') ? "새 기록지가 추가되었습니다." : "새 기록지가 추가되었습니다.";

		console.log("전송 데이터:", data);
		if (!confirm(confirmMsg)) {
			return;
		}

		var $btn = $('#saveBtn');
		$btn.prop('disabled', true).css({'pointer-events': 'none', 'opacity': '0.5'});

		jQuery.ajax({
			type: "POST",
			url: url, 
			data: JSON.stringify(data), 
			dataType: "JSON", 
			contentType: "application/json",
			success: function(result) {
				if (result) {
					alert(successMsg);
					$('.popUp04').hide();
					$('.popLayer').hide();
					location.reload(); 
				} else {
					alert("데이터 추가 중 서버 오류가 발생했습니다.");
					$btn.prop('disabled', false).css({'pointer-events': '', 'opacity': ''});
				}
			},
			error: function(xhr, status, error) {
				alert("서버와 통신 중 문제가 발생했습니다.");
				console.log(error); 
				$btn.prop('disabled', false).css({'pointer-events': '', 'opacity': ''});
			}
		});
	}
	
	function openDateUpdatePopup(td) {
		var $tr = $(td).closest('tr');
		var id = $tr.find('#id').val();
		if (!id) return;

		var rownum = $tr.find('td').eq(1).text().trim(); 
		var currentDate = $(td).text().trim().replace(/\s+/g, ' ');

		$('#popDate_reportId').val(id);
		$('#popDate_rownum').text(rownum);
		$('#popDate_currentDate').text(currentDate);
		$('#popDate_newDate').val(currentDate);

		$('.popUp05').css('display', 'flex');
		$('.popLayer').show();
		$('body').css('overflow', 'hidden');
		
		setTimeout(function() { $('#popDate_newDate').focus(); }, 100);
	}

	function closeDateUpdatePopup() {
		$('.popUp05').hide();
		$('.popLayer').hide();
		$('body').css('overflow', 'auto');
	}

	function submitDateUpdate() {
		var id = $('#popDate_reportId').val();
		var newDate = $('#popDate_newDate').val().trim();

		if (!newDate) {
			$('#popDate_newDate').focus();
			return;
		}

		if (!confirm("시공일을 '" + newDate + "'(으)로 수정하시겠습니까?")) {
			return;
		}

		var dateOnly = newDate.split(" ")[0];
		
		var reports = [{
			id: Number(id),
			createDate: newDate,
			currentDateTime: dateOnly
		}];

		var $btn = $('.popUp05 [onclick*="submitDateUpdate"]');
		$btn.prop('disabled', true).css({'pointer-events': 'none', 'opacity': '0.5'});

		jQuery.ajax({
			type : "POST",
			url : "${pageContext.request.contextPath}/report/update/date", 
			data : JSON.stringify(reports[0]),
			dataType : "JSON",
			contentType : "application/json",
			success : function(data) {
				if(data == true){
					alert('시공일이 성공적으로 수정되었습니다.');
					closeDateUpdatePopup();
					pageReload();
				} else {
					alert('수정에 실패했습니다.');
					$btn.prop('disabled', false).css({'pointer-events': '', 'opacity': ''});
				}
			},
			error : function(xhr, status, error) {
				alert('서버 통신 중 오류가 발생했습니다.');
				console.error(error);
				$btn.prop('disabled', false).css({'pointer-events': '', 'opacity': ''});
			}
		});
	}

	function openDeviceChangePopup() {
		var selectedRows = [];
		var deleteCd = 1;

		$('#reportTable tr').each(function() {
			if ($(this).find('#isDel').val() == deleteCd) return;
			if ($(this).find('#selectOne').is(':checked')) {
				var id = $(this).find('#id').val();
				var deviceIdx = $(this).find('#deviceIdx').val();
				var rownum = $(this).find('td').eq(1).text().trim();
				var dateStr = $(this).find('td').eq(2).text().trim().replace(/\s+/g, ' ');
				
				if (id) {
					selectedRows.push({
						id: id,
						deviceIdx: deviceIdx,
						rownum: rownum,
						origDate: dateStr
					});
				}
			}
		});

		if (selectedRows.length === 0) {
			alert('수정 및 이전할 기록지를 체크박스로 선택해주세요.');
			return;
		}

		loadConstructionDevicesAndRender(selectedRows);

		$('.popUp06').css('display', 'flex');
		$('.popLayer').show();
		$('body').css('overflow', 'hidden');
	}

	function closeDeviceChangePopup() {
		$('.popUp06').hide();
		$('.popLayer').hide();
		$('body').css('overflow', 'auto');
	}

	function loadConstructionDevicesAndRender(selectedRows) {
		var conIdx = '${param.constructionIdx}' !== '' ? '${param.constructionIdx}' : '${sessionInfo.constructionIdx}';
		
		$.ajax({
			type: "POST",
			url: "${pageContext.request.contextPath}/device/get/list",
			data: { constructionIdx: conIdx },
			dataType: "JSON",
			success: function(data) {
				globalDeviceList = data || [];
				var bulkHtml = '<option value="">-- 호기 일괄 선택 --</option>';
				$.each(globalDeviceList, function(i, dev) {
					bulkHtml += '<option value="' + dev.id + '">' + dev.machineNumber + '</option>';
				});
				$('#popDevice_bulkDevice').html(bulkHtml);

				var tbodyHtml = '';
				$.each(selectedRows, function(index, row) {
					var origDeviceName = '알 수 없음';
					var selectOptions = '<option value="">-- 호기 선택 --</option>';
					
					$.each(globalDeviceList, function(i, dev) {
						var isSelected = (Number(dev.id) === Number(row.deviceIdx)) ? 'selected' : '';
						if (isSelected) origDeviceName = dev.machineNumber;
						selectOptions += '<option value="' + dev.id + '" ' + isSelected + '>' + dev.machineNumber + '</option>';
					});

					tbodyHtml += '<tr class="edit-row" data-id="' + row.id + '">';
					tbodyHtml += '  <td style="text-align:center; vertical-align:middle; font-size:15px; color:#333; line-height:1.5; padding:8px;"><b>[' + origDeviceName + ']</b><br>' + row.origDate + '</td>';
					tbodyHtml += '  <td style="text-align:center; vertical-align:middle; padding:6px;"><select class="row-device-select row-dev-val" style="width:95% !important;">' + selectOptions + '</select></td>';
					tbodyHtml += '  <td style="text-align:center; vertical-align:middle; padding:6px;"><input type="text" class="row-date-input row-date-val" value="' + row.origDate + '" placeholder="YYYY-MM-DD HH:mm:ss" style="width:95% !important;" /></td>';
					tbodyHtml += '</tr>';
				});

				$('#popDevice_tbody').html(tbodyHtml);
			},
			error: function() {
				alert("호기 목록을 불러오는 중 오류가 발생했습니다.");
			}
		});
	}

	function applyBulkDevice(val) {
		if (!val) return;
		$('#popDevice_tbody .row-dev-val').val(val);
	}

	function submitDeviceChange() {
		var reports = [];
		var hasError = false;
		var dateRegex = /^\d{4}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01]) (0\d|1\d|2[0-3]):([0-5]\d):([0-5]\d)$/;

		$('#popDevice_tbody .edit-row').each(function() {
			var id = $(this).attr('data-id');
			var newDeviceIdx = $(this).find('.row-dev-val').val();
			var newDate = $(this).find('.row-date-val').val().trim();

			if (!newDeviceIdx) {
				alert('호기가 선택되지 않은 항목이 있습니다.');
				$(this).find('.row-dev-val').focus();
				hasError = true;
				return false;
			}
			if (!newDate) {
				alert('시공일이 입력되지 않은 항목이 있습니다.');
				$(this).find('.row-date-val').focus();
				hasError = true;
				return false;
			}
			if (!dateRegex.test(newDate)) {
				alert('시공일은 "YYYY-MM-DD HH:mm:ss" 형식으로 입력해야 합니다.\n(예: 2026-07-15 14:30:00)');
				$(this).find('.row-date-val').focus();
				hasError = true;
				return false;
			}

			var dateOnly = newDate.split(" ")[0];

			reports.push({
				id: Number(id),
				deviceIdx: Number(newDeviceIdx),
				createDate: newDate,
				currentDateTime: dateOnly
			});
		});

		if (hasError) return;

		if (!confirm("총 " + reports.length + "건의 기록지를 입력된 호기 및 시공일로 수정하시겠습니까?")) {
			return;
		}

		var $btn = $('.popUp06 #saveBtn');
		$btn.prop('disabled', true).css({'pointer-events': 'none', 'opacity': '0.5'});

		$.ajax({
			type: "POST",
			url: "${pageContext.request.contextPath}/report/update/changeDeviceMulti",
			data: JSON.stringify(reports),
			dataType: "JSON",
			contentType: "application/json",
			success: function(res) {
				if (res === true) {
					alert('선택한 기록지들이 성공적으로 수정 및 이전되었습니다.');
					closeDeviceChangePopup();
					pageReload();
				} else {
					alert('기록지 수정 처리에 실패했습니다.');
					$btn.prop('disabled', false).css({'pointer-events': '', 'opacity': ''});
				}
			},
			error: function(xhr, status, error) {
				alert('서버 통신 중 오류가 발생했습니다.');
				console.error(error);
				$btn.prop('disabled', false).css({'pointer-events': '', 'opacity': ''});
			}
		});
	}
	

</script>
<!--컨텐츠-->
<div class="section-right" >
	<%@ include file="/WEB-INF/views/common/welcomeMsg.jsp" %>
	<div class="TopContArea">
		<div class="titArea mb-40">
			<p class="h1Tit">${device.machineNumber} 시공현황</p>
			<input type="hidden" id="machineNumber" name="machineNumber" value="${device.machineNumber}">
			<input type="hidden" id="constructionName" name="constructionName" value="">
			<input type="hidden" id="root" name="root" value="${pageContext.request.contextPath}">
			<div class="titBtnArea">
				<c:choose>
					<c:when test="${sessionInfo.role == 1}">
						<div class="printBtn02" onclick="goUrl('${pageContext.request.contextPath}/report/list?id=${param.id}&type=all&constructionIdx=${sessionInfo.constructionIdx}');">총 작업내역</div>
						<div class="printBtn" onclick="goUrl('${pageContext.request.contextPath}/report/list?id=${param.id}&date=today&constructionIdx=${sessionInfo.constructionIdx}');">금일작업내역</div>
						
					</c:when>
					<c:otherwise>
						<div class="printBtn02" onclick="goUrl('${pageContext.request.contextPath}/report/list?id=${param.id}&type=all&constructionIdx=${param.constructionIdx}');">총 작업내역</div>
						<div class="printBtn" style="background-color: #FBCA79; border : solid #FBCA79 1px;" onclick="goUrl('${pageContext.request.contextPath}/report/list?id=${param.id}&date=today&constructionIdx=${param.constructionIdx}');">금일작업내역</div>
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
					<form:input path="location" class="searchin" placeholder="시공 위치"/>
					<form:input path="pileNo" class="searchin" placeholder="파일 번호"/>
					<form:input path="method" class="searchin" placeholder="공법"/>
					<form:hidden path="mode" class="all"/>
					<form:hidden path="type" class="all"/>
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
					<form:input path="startDate" class="inputDate datepicker" placeholder="시작일"/>
					<span>~</span>
					<form:input path="endDate" class="inputDate datepicker" placeholder="종료일"/>
					<div class="searchBtn">
						<img src="${pageContext.request.contextPath}/new/img/search_date.png" style="cursor:pointer;" onclick="javascript:searchForm();">
					</div>
				</div>
			</div>
		</form:form>
		<!--//검색-->
	</div>
	
			<table class="reportTypeDashboard">
				<tr>
					<td class="f_td">
						<img src="${pageContext.request.contextPath}/new/img/light-b.png">
					</td>
					<td class="s_td">&nbsp;호기별 중복(시공위치, 파일번호)</td>
					<td class="t_td" rowspan="4" >
						<c:if test="${sessionScope.isSystemAdmin}">
							<div class="tableCArea" style="display: flex; flex-wrap: wrap; gap: 5px; justify-content: flex-end; margin-bottom: 10px;">
								<div class="btnType02 bg02" onclick="javascript:openDeviceChangePopup();" style="width: 120px; background: #F08080; color:#fff; border: 1px solid #F08080; margin: 0;">호기 이전</div>
								<div class="btnType02 bg02" onclick="javascript:openCopyReportPopup();" style="width: 90px; background: #4CAF50; color:#fff; border: 1px solid #4CAF50; margin: 0;">기록지 복사</div>
								<div class="btnType02 bg02" onclick="javascript:openNewReportPopup();" style="width: 90px; background: #2196F3; color:#fff; border: 1px solid #2196F3; margin: 0;">기록지 추가</div>
								<div class="btnType02 bg02" onclick="javascript:openDateEditPopupBtn();" style="width: 90px; background: #9C27B0; color:#fff; border: 1px solid #9C27B0; margin: 0;">시공일 수정</div>
							</div>
						</c:if> 
						<div class="tableCArea">
							<c:choose>												 
								<c:when test="${sessionInfo.role == 0 || sessionInfo.hiddenManager == true || sessionInfo.role == 3}">
									<c:if test="${useExcel}"><div class="btnType02 bg02" onclick="javascript:onClickExcelSignRoom();"   style="width: 210px; margin-bottom : 5px; background: #FFD400; color:#000000; border: 1px solid #258348;">EXCEL 결재방 설정</div></c:if>
								</c:when>
								<c:otherwise>
									<c:if test="${useExcel}"><div class="btnType02 bg02" onclick="javascript:onClickExcelSignRoom();" style="width: 210px; margin-bottom : 5px; background: #FFD400; color:#000000; border: 1px solid #258348;">EXCEL 결재방 설정</div></c:if>
								</c:otherwise>
							</c:choose>
						</div>
						<div class="tableCArea">
							<c:choose>												 
								<c:when test="${sessionInfo.role == 0 || sessionInfo.hiddenManager == true || sessionInfo.role == 3}">
									<c:if test="${useExcel}"><div class="btnType02 bg02" onclick="javascript:downloadExcel();">엑셀 출력</div></c:if>
									<div class="btnType01" onclick="javascript:onClickReportUpdate();">기록지 수정</div>
								</c:when>
								<c:otherwise>
									<c:if test="${useExcel}"><div class="btnType02 bg02" onclick="javascript:downloadExcel();">엑셀 출력</div></c:if>
									<div class="btnType01" onclick="javascript:onClickReportUpdate();" style="display: none;">기록지 수정</div>
								</c:otherwise>
							</c:choose>
						</div>
					</td>
				</tr>
				<tr>
					<td><img src="${pageContext.request.contextPath}/new/img/light-p.png"></td>
					<td>&nbsp;전체 중복(시공위치, 파일번호)</td>
				</tr>
				<tr>
					<td><img src="${pageContext.request.contextPath}/new/img/light-o.png"></td>
					<td>&nbsp;관리기준 초과/또는 NG</td>
				</tr>
				<tr>
					<td><img src="${pageContext.request.contextPath}/new/img/light-l.png"></td>
					<td>&nbsp;미관입/또는 NG</td>
				</tr>
			</table>
			<table class="mobileReportTypeDashboard">
				<tr>
					<td class="f_td"><img src="${pageContext.request.contextPath}/new/img/light-b.png"></td>
					<td class="s_td">&nbsp;호기별 중복(시공위치, 파일번호)</td>
				</tr>
				<tr >
					<td class="f_td"><img src="${pageContext.request.contextPath}/new/img/light-p.png"></td>
					<td class="s_td">&nbsp;전체 중복(시공위치, 파일번호)</td>
				</tr>
				<tr>
					<td class="f_td"><img src="${pageContext.request.contextPath}/new/img/light-o.png"></td>
					<td class="s_td">&nbsp;관리기준 초과/또는 NG</td>
				</tr>
				<tr>
					<td class="f_td"><img src="${pageContext.request.contextPath}/new/img/light-l.png"></td>
					<td class="s_td">&nbsp;미관입/또는 NG</td>
				</tr>
				<tr>
					<td colspan="2">
						<c:if test="${sessionScope.isSystemAdmin}">
							<div class="tableCArea" style="display: flex; flex-wrap: wrap; gap: 5px; justify-content: flex-end; margin-bottom: 8px; width: 100%;">
								<div class="btnType02 bg02" onclick="javascript:openDeviceChangePopup();" style="width: 120px; background: #F08080; color:#fff; border: 1px solid #F08080; margin: 0;">호기 이전</div>
								<div class="btnType02 bg02" onclick="javascript:openCopyReportPopup();" style="width: 90px; background: #4CAF50; color:#fff; border: 1px solid #4CAF50; margin: 0;">기록지 복사</div>
								<div class="btnType02 bg02" onclick="javascript:openNewReportPopup();" style="width: 90px; background: #2196F3; color:#fff; border: 1px solid #2196F3; margin: 0;">기록지 추가</div>
								<div class="btnType02 bg02" onclick="javascript:openDateEditPopupBtn();" style="width: 90px; background: #9C27B0; color:#fff; border: 1px solid #9C27B0; margin: 0;">시공일 수정</div>
							</div>
						</c:if>
						<div class="tableCArea" style="margin-bottom: 0px;">
							<c:choose>												 
								<c:when test="${sessionInfo.role == 0 || sessionInfo.hiddenManager == true || sessionInfo.role == 3}">
									<c:if test="${useExcel}"><div class="btnType02 bg02" id="excelSignRoomSetting" style="float: right; width: 130px; margin-bottom : 5px; background: #FFD400; color:#000000; border: 1px solid #258348;">EXCEL 결재방 설정</div></c:if>
								</c:when>
								<c:otherwise>
									<c:if test="${useExcel}"><div class="btnType02 bg02" id="excelSignRoomSetting" style="float: right; width: 130px; margin-bottom : 5px; background: #FFD400; color:#000000; border: 1px solid #258348;">EXCEL 결재방 설정</div></c:if>
								</c:otherwise>
							</c:choose>
						</div>
						<div class="tableCArea">
							<c:choose>												 
								<c:when test="${sessionInfo.role == 0 || sessionInfo.hiddenManager == true || sessionInfo.role == 3}">
									<c:if test="${useExcel}"><div class="btnType02 bg02" onclick="javascript:downloadExcel();">엑셀 출력</div></c:if>
									<div class="btnType01" onclick="javascript:onClickReportUpdate();">기록지 수정</div>
								</c:when>
								<c:otherwise>
									<c:if test="${useExcel}"><div class="btnType02 bg02" onclick="javascript:downloadExcel();" style="float: right;">엑셀 출력</div></c:if>
									<!-- <div class="btnType01" onclick="javascript:onClickReportUpdate();" style="display: none;">기록지 수정</div> -->
								</c:otherwise>
							</c:choose>
						</div>
					</td>
				</tr>
			</table>
		
	<div class="min485">
		<div class="tableArea">
			
			<!-- <div class="viewTable viewTable05"> -->
			<div class="viewTable" style="width: auto; table-layout: fixed; overflow-x: scroll; overflow-y: hidden;">
				<table class="viewTh" style="table-layout: fixed;">
					<tr>
						<c:choose>
							<c:when test="${sessionInfo.role == 0  || sessionInfo.hiddenManager == true  || sessionInfo.role == 3}">
								<td rowspan="2">
									<input type="checkbox" id="chkAll" name="chkAll" onclick="javascript:onClickChkAll();">
								</td>
							</c:when>
						</c:choose>
						<!-- <td rowspan="2">순번</td> -->
						<c:choose>
							<c:when test="${sessionScope.isSystemAdmin}">
								<td rowspan="2" ondblclick="openNewReportPopup();" style="cursor: pointer; ">순번</td>	
							</c:when>
							<c:otherwise>
								<td rowspan="2">순번</td>
							</c:otherwise>
						</c:choose>
						<td rowspan="2" style="width: 100px;">시공일</td>
						<td rowspan="2">파일종류</td>
						<td rowspan="2">시공공법</td>
						<td rowspan="2">시공위치</td>
						<td rowspan="2">파일번호</td>
						<td rowspan="2">파일규격</td>
						
						<c:choose>
							<c:when test="${extensivePileUsage > 0}">
								<td colspan="8" style="width: 560px;">파일구분</td>
							</c:when>
							<c:otherwise>
								<td colspan="6" style="width: 420px;">파일구분</td>
							</c:otherwise>
						</c:choose>
						<td rowspan="2">이음(개소)</td>
						
						<c:choose>
							<c:when test="${sessionInfo.constructionIdx == 944 or param.constructionIdx == 944  or sessionInfo.constructionIdx == 1136 or param.constructionIdx == 1136}">
								<td rowspan="2">경타길이(M)</td>
								<td rowspan="2">천공깊이(M)</td>
							</c:when>
							<c:otherwise>
								<td rowspan="2">천공깊이(M)</td>
								<c:choose>
									<c:when test="${param.constructionIdx == 1269 or sessionInfo.constructionIdx == 1269}">
										<td rowspan="2">직타깊이(M)</td>
									</c:when>
								</c:choose>
								
								<c:choose>
									<c:when test="${sessionInfo.constructionIdx == 1082 or param.constructionIdx == 1082}">
										<td rowspan="2">토사천공(M)</td>
										<td rowspan="2">전석층천공(M)</td>
									</c:when>
								</c:choose>
								<c:choose>
									<c:when test="${sessionInfo.constructionIdx == 1082 or param.constructionIdx == 1082}">
										<td rowspan="2">경타깊이(M)</td>
									</c:when>
									<c:otherwise>
										
										<td rowspan="2">관입깊이(M)</td>
									</c:otherwise>
								</c:choose>
							</c:otherwise>
						</c:choose>
						
						
						<td rowspan="2">파일잔량(M)</td>
						<td rowspan="2">
							<c:choose>
								<c:when test="${(sessionInfo.constructionIdx == 692 or param.constructionIdx == 692) or (sessionInfo.constructionIdx == 720 or param.constructionIdx == 720)}">
									추가천공(M)
								</c:when>
								<c:otherwise>
									공삭공(M)
								</c:otherwise>
							</c:choose>
						</td>
						<td rowspan="2">해머무게(Ton)</td>
						<td rowspan="2">낙하높이(m)</td>
						<td rowspan="2">관리기준(mm)</td>
						
						
						<c:choose>
							<c:when test="${sessionInfo.constructionIdx == 645}">
								<td style="display:none;" rowspan="2">1회측정(mm)</td>
								<td style="display:none;" rowspan="2">2회측정(mm)</td>
								<td style="display:none;" rowspan="2">3회측정(mm)</td>
								<td style="display:none;" rowspan="2">4회측정(mm)</td>
								<td style="display:none;" rowspan="2">5회측정(mm)</td>
								
								<c:choose>
									<c:when test="${isBig > 0}">
										<td style="display:none;" rowspan="2">6회측정(mm)</td>
										<td style="display:none;" rowspan="2">7회측정(mm)</td>
										<td style="display:none;" rowspan="2">8회측정(mm)</td>
										<td style="display:none;" rowspan="2">9회측정(mm)</td>
										<td style="display:none;" rowspan="2">10회측정(mm)</td>
									</c:when>
								</c:choose>
							</c:when>
							<c:otherwise>
								<td rowspan="2">1회측정(mm)</td>
								<td rowspan="2">2회측정(mm)</td>
								<td rowspan="2">3회측정(mm)</td>
								<td rowspan="2">4회측정(mm)</td>
								<td rowspan="2">5회측정(mm)</td>
								
								<c:choose>
									<c:when test="${isBig > 0}">
										<td rowspan="2">6회측정(mm)</td>
										<td rowspan="2">7회측정(mm)</td>
										<td rowspan="2">8회측정(mm)</td>
										<td rowspan="2">9회측정(mm)</td>
										<td rowspan="2">10회측정(mm)</td>
									</c:when>
								</c:choose>
							</c:otherwise>
						</c:choose>
						
						<td rowspan="2">평균관입(mm)</td>
						<td rowspan="2">최종관입(mm)</td>
						
						<c:choose>
							<c:when test="${sessionInfo.role == 0}">
								<td rowspan="2">극한지지력<br>(kN)</td>
								<td rowspan="2">해머효율(%)</td>
								<td rowspan="2">탄성계수(t/cm2)</td>
								<td rowspan="2">파일단면적(cm2)</td>
								<td rowspan="2">비고</td>
								<td rowspan="2">메모</td>
							</c:when>
							<c:when test="${sessionInfo.role == 1}">
								<!-- 일반 협력사 -->
								<c:choose>
									<c:when test="${(sessionScope.settingRequired and ubcYn == 1) or (not sessionScope.settingRequired and sessionInfo.hiddenManager == true and ubcYn == 1)}">
										<td rowspan="2">극한지지력<br>(kN)</td>
										<td rowspan="2">해머효율(%)</td>
										<td rowspan="2">
											<c:choose>
												<c:when test="${sessionInfo.constructionIdx == '1669'}">
													개량T4
												</c:when>
												<c:otherwise>
													탄성계수(t/cm2)
												</c:otherwise>
											</c:choose>
										</td>
										<td rowspan="2">
											<c:choose>
												<c:when test="${sessionInfo.constructionIdx == '1669'}">
													정T4
												</c:when>
												<c:otherwise>
													파일단면적(cm2)
												</c:otherwise>
											</c:choose>
										</td>
										<td rowspan="2">비고</td>
									</c:when>
									<c:otherwise>
										<td rowspan="2">비고</td>
										<c:choose>
											<c:when test="${param.constructionIdx == 492}">
												<td rowspan="2">메모</td>
											</c:when>
										</c:choose>
									</c:otherwise>
								</c:choose>	
							</c:when>
							<c:when test="${sessionInfo.role == 2}">
								<td rowspan="2">비고</td>
							</c:when>
							<c:when test="${sessionInfo.role == 3}">
								<c:choose>
									<c:when test="${ubcYn == 1}">
										<td rowspan="2">극한지지력<br>(kN)</td>
										<td rowspan="2">해머효율(%)</td>
										<td rowspan="2">탄성계수(t/cm2)</td>
										<td rowspan="2">파일단면적(cm2)</td>
										<td rowspan="2">비고</td>
									</c:when>
									<c:otherwise>
										<td rowspan="2">비고</td>
									</c:otherwise>
								</c:choose>
							</c:when>
						</c:choose>
						
						
						
						<%-- <c:choose>
							<c:when test="${sessionInfo.role == 0}">
								<td rowspan="2">극한지지력<br>(kN)</td>
							</c:when>
						</c:choose>
						<c:choose>
						<c:when test="${sessionInfo.role > 0}">
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
								<td rowspan="2">해머효율(%)</td>
								<td rowspan="2">탄성계수(t/cm2)</td>
								<td rowspan="2">파일단면적(cm2)</td>
								<td rowspan="2">비고</td>
								<td rowspan="2">메모</td>
							</c:when>
						</c:choose> --%>
					</tr>	
					<tr>
						<td>단본(M)</td>
						<td>하단(M)</td>
						<td>중단(M)</td>
						<td>중단(M)</td>
						<c:choose>
							<c:when test="${extensivePileUsage > 0}">
								<td>중단(M)</td>
								<td>중단(M)</td>
							</c:when>
						</c:choose>
						<td>상단(M)</td>
						<td>합계(M)</td>
					</tr>
				</table>
				<!-- 수경기업은 프린트를 직접해서 바로 다 나와야함. -->
				<c:choose>
					<c:when test="${sessionInfo.constructionIdx == '528'}">
						<div class="tableScroll"  style="max-height: 1200px;">
					<table id="reportTable" name="reportTable">
					</c:when>
					<c:otherwise>
						<div class="tableScroll">
					<table id="reportTable" name="reportTable" class="reportTable" >
					</c:otherwise>
				</c:choose>				
					
						<c:forEach var="domain" items="${domainList}"  varStatus="status">
						<!--  리스트에서 해당 줄 옆에 램프 키기 : tr에 클래스 lampOn(빨간색) 또는 lampOn-b(파란색)  추가 -->
							<c:choose>
								<c:when test="${domain.isDel == 1}">
									<tr class="lampOn" onclick="javascript:onRowClick(${status.index});" style="background-color: #f7baba;">
								</c:when>
								<c:otherwise>
									<c:choose>
										<c:when test="${domain.duplicated > 1}">
											<tr class="lampOn-b" onclick="javascript:onRowClick(${status.index});" style="background-color: #b3d8f5;">
										</c:when>
										<c:otherwise>
											<c:choose>
												<c:when test="${domain.totalDuplicated > 1 }">
													<tr class="lampOn-p" onclick="javascript:onRowClick(${status.index});" style="background-color: #D4C0FE;">
												</c:when>
												<c:otherwise>
													<c:choose>
														<c:when test="${domain.managedStandard + 0 < domain.avgPenetrationValue + 0}">
														 	<tr class="lampOn-o" onclick="javascript:onRowClick(${status.index});" style="background-color: #FEB896;">
														 </c:when>
														 <c:otherwise>
														 	<c:choose>
														 		<c:when test="${domain.peLength < 5 }">
														 			<c:choose>
														 				<c:when test="${domain.deviceIdx == 2061}">
														 					<c:choose>
														 						<c:when test="${domain.peLength < 3}">
														 							<tr class="lampOn-l" onclick="javascript:onRowClick(${status.index});" style="background-color: #F0DDA4;">		
														 						</c:when>
														 						<c:otherwise>
														 							<tr onclick="javascript:onRowClick(${status.index});">	
														 						</c:otherwise>
														 					</c:choose>
														 				</c:when>
														 				<c:otherwise>
															 				<c:choose>
															 					<c:when test="${param.constructionIdx == 1619 or sessionInfo.constructionIdx == 1619}">
															 						<tr onclick="javascript:onRowClick(${status.index});">
															 					</c:when>
															 					<c:otherwise>
															 						<tr class="lampOn-l" onclick="javascript:onRowClick(${status.index});" style="background-color: #F0DDA4;">	
															 					</c:otherwise>
															 				</c:choose>
														 				</c:otherwise>
														 			</c:choose>
																</c:when>
																<c:otherwise>
																	<!-- 10회였을때 10회를 다 채우지 않은 경우에 노란색이 안보인다는 말인데... -->
																	<tr onclick="javascript:onRowClick(${status.index});">
																</c:otherwise>	
														 	</c:choose>
														 </c:otherwise> 
													</c:choose>
												</c:otherwise>
											</c:choose>
										</c:otherwise>
									</c:choose>
								</c:otherwise>
							</c:choose>
							<c:choose>
								<c:when test="${sessionInfo.role == 0  || sessionInfo.hiddenManager == true  || sessionInfo.role == 3}">
									<td>
										<input type="checkbox" id="selectOne" name="selectOne" onclick="doOpenCheck(this, this.parentNode.parentNode.rowIndex);">
									</td>
								</c:when>
							</c:choose>
							<%-- <td>${domain.rownum}</td> --%>
						    <c:choose>
						    	<c:when test="${sessionScope.isSystemAdmin}">
						        	<td ondblclick="javascript:copyAndInsertReport(this);"
						            	style="cursor: pointer; color: #000; font-weight: bold;">
						                ${domain.rownum}
						                
						            </td>
						        </c:when>
						            <c:otherwise>
						                <td>${domain.rownum}</td>
						        	</c:otherwise>
							</c:choose>
							<!-- <td  style="width: 100px;"> -->
							<td style="width: 100px;<c:if test="${sessionInfo.role == 0}"> cursor: pointer;</c:if>"
								<c:if test="${sessionScope.isSystemAdmin}">ondblclick="javascript:openDateUpdatePopup(this);"</c:if>>
								<c:choose>
									<c:when test="${sessionInfo.role == 0}">
											<c:set var = "dateTime" value = "${domain.createDate}"/>
										    <c:set var = "length" value = "${fn:length(dateTime)}"/>
										    <c:set var = "newDateTime" value = "${fn:substring(dateTime, 0, length -2)}" />
											${newDateTime}
											<input type="hidden" id="id" name="id" value="${domain.id}" >
											<input type="hidden" id="isDel" name="isDel" value="${domain.isDel}" >
											<input type="hidden" id="isDuple" name="isDuple" value="${domain.isDuple}" >
											<input type="hidden" id="deviceIdx" name="deviceIdx" value="${domain.deviceIdx}" >
									</c:when>
									<c:when test="${sessionInfo.role == 1}">
										<!-- 일반 협력사 -->
										<c:choose>
											<c:when test="${(sessionScope.settingRequired and longCalYn == 1) or (not sessionScope.settingRequired and sessionInfo.hiddenManager == true and domain.longCalYn == 1)}">
												<c:set var = "dateTime" value = "${domain.createDate}"/>
											    <c:set var = "length" value = "${fn:length(dateTime)}"/>
											    <c:set var = "newDateTime" value = "${fn:substring(dateTime, 0, length -2)}" />
												${newDateTime}
												<input type="hidden" id="id" name="id" value="${domain.id}" >
												<input type="hidden" id="isDel" name="isDel" value="${domain.isDel}" >
												<input type="hidden" id="isDuple" name="isDuple" value="${domain.isDuple}" >
												<input type="hidden" id="deviceIdx" name="deviceIdx" value="${domain.deviceIdx}" >
											</c:when>
											<c:otherwise>
												<c:choose>
													<c:when test="${sessionInfo.constructionIdx == 657 or sessionInfo.constructionIdx ==  169 or sessionInfo.constructionIdx ==  170  or sessionInfo.constructionIdx ==  1117  or sessionInfo.constructionIdx == 1363}">
														<c:set var = "dateTime" value = "${domain.createDate}"/>
													    <c:set var = "length" value = "${fn:length(dateTime)}"/>
													    <c:set var = "newDateTime" value = "${fn:substring(dateTime, 0, length -2)}" />
														${newDateTime}
														<input type="hidden" id="id" name="id" value="${domain.id}" >
														<input type="hidden" id="isDel" name="isDel" value="${domain.isDel}" >
														<input type="hidden" id="isDuple" name="isDuple" value="${domain.isDuple}" >
														<input type="hidden" id="deviceIdx" name="deviceIdx" value="${domain.deviceIdx}" >
													</c:when>
													<c:otherwise>
														${domain.currentDateTime}
														<input type="hidden" id="id" name="id" value="${domain.id}" >
														<input type="hidden" id="isDel" name="isDel" value="${domain.isDel}" >
														<input type="hidden" id="isDuple" name="isDuple" value="${domain.isDuple}" >
														<input type="hidden" id="deviceIdx" name="deviceIdx" value="${domain.deviceIdx}" >
													</c:otherwise>
												</c:choose>
											</c:otherwise>
										</c:choose>
									</c:when>
									<c:when test="${sessionInfo.role == 2}">
										<!-- 시공사 -->
										${domain.currentDateTime}
										<input type="hidden" id="id" name="id" value="${domain.id}" >
										<input type="hidden" id="isDel" name="isDel" value="${domain.isDel}" >
										<input type="hidden" id="isDuple" name="isDuple" value="${domain.isDuple}" >
										<input type="hidden" id="deviceIdx" name="deviceIdx" value="${domain.deviceIdx}" >
									</c:when>
									<c:when test="${sessionInfo.role == 3}">
										<!-- 가맹점 -->
										<c:choose>
											<c:when test="${domain.longCalYn == 1}">
												<c:set var = "dateTime" value = "${domain.createDate}"/>
											    <c:set var = "length" value = "${fn:length(dateTime)}"/>
											    <c:set var = "newDateTime" value = "${fn:substring(dateTime, 0, length -2)}" />
												${newDateTime}
												<input type="hidden" id="id" name="id" value="${domain.id}" >
												<input type="hidden" id="isDel" name="isDel" value="${domain.isDel}" >
												<input type="hidden" id="isDuple" name="isDuple" value="${domain.isDuple}" >
												<input type="hidden" id="deviceIdx" name="deviceIdx" value="${domain.deviceIdx}" >
											</c:when>
											<c:otherwise>
												${domain.currentDateTime}
												<input type="hidden" id="id" name="id" value="${domain.id}" >
												<input type="hidden" id="isDel" name="isDel" value="${domain.isDel}" >
												<input type="hidden" id="isDuple" name="isDuple" value="${domain.isDuple}" >
												<input type="hidden" id="deviceIdx" name="deviceIdx" value="${domain.deviceIdx}" >
											</c:otherwise>
										</c:choose>
									</c:when>
									<c:when test="${sessionInfo.role == 4}">
										${domain.currentDateTime}
									</c:when>
							</c:choose>
							</td>	
							<td>
						 		<input type="text" id="pileType" name="pileType" disabled="disabled" class="tdInput" value="${domain.pileType}">
						 	</td>
							<td>
								<input type="text" id="method" name="method" disabled="disabled" class="tdInput" value="${domain.method}">
							</td>
							<td>
								<input type="text" id="location" name="location" disabled="disabled" class="tdInput" value="${domain.location}">
							</td>
							<c:choose>
								<c:when test="${param.constructionIdx == 588 or param.constructionIdx == 613 or param.constructionIdx == 627}">
									<c:choose>
										<c:when test="${domain.zone eq 'ept'}">
											<td style="background-color: yellow;">
												<input type="text" id="pileNo" name="pileNo" disabled="disabled"  class="tdInput" value="${domain.pileNo}">
											</td>
										</c:when>
										<c:otherwise>
											<td>
												<input type="text" id="pileNo" name="pileNo" disabled="disabled"  class="tdInput" value="${domain.pileNo}">
											</td>
										</c:otherwise>
									</c:choose>
								</c:when>
								<c:otherwise>
									<td>
										<input type="text" id="pileNo" name="pileNo" disabled="disabled"  class="tdInput" value="${domain.pileNo}">
									</td>
								</c:otherwise>
							</c:choose>
							<td>
								<input type="text" id="pileStandard" name="pileStandard" disabled="disabled" class="tdInput" value="${domain.pileStandard}">
							</td>
							<td>
								<input type="text" id="piece[${status.index}]" name="piece[${status.index}]" disabled="disabled"  class="tdInput" value="${domain.piOne}">
								<input type="hidden" id="pieceId[${status.index}]" name="pieceId[${status.index}]" value="${domain.pidOne}">
								<input type="hidden" id="pieceName[${status.index}]" name="pieceName[${status.index}]" value="단본">
							</td>
							<td >
								<input type="text" id="piece[${status.index}]" name="piece[${status.index}]" disabled="disabled" class="tdInput" value="${domain.piTwo}">
								<input type="hidden" id="pieceId[${status.index}]" name="pieceId[${status.index}]" value="${domain.pidTwo}">
								<input type="hidden" id="pieceName[${status.index}]" name="pieceName[${status.index}]" value="하단">
							</td>
							<td>
								<input type="text" id="piece[${status.index}]" name="piece[${status.index}]" disabled="disabled" class="tdInput" value="${domain.piThree}">
								<input type="hidden" id="pieceId[${status.index}]" name="pieceId[${status.index}]" value="${domain.pidThree}">
								<input type="hidden" id="pieceName[${status.index}]" name="pieceName[${status.index}]" value="중단">
							</td>
							<td>
								<input type="text" id="piece[${status.index}]" name="piece[${status.index}]" disabled="disabled"  class="tdInput" value="${domain.piFour}">
								<input type="hidden" id="pieceId[${status.index}]" name="pieceId[${status.index}]" value="${domain.pidFour}">
								<input type="hidden" id="pieceName[${status.index}]" name="pieceName[${status.index}]" value="중단">
							</td>
							<td>
								<input type="text" id="piece[${status.index}]" name="piece[${status.index}]" disabled="disabled"  class="tdInput" value="${domain.piFive}">
								<input type="hidden" id="pieceId[${status.index}]" name="pieceId[${status.index}]" value="${domain.pidFive}">
								<input type="hidden" id="pieceName[${status.index}]" name="pieceName[${status.index}]" value="중단">
							</td>
							<c:choose>
								<c:when test="${extensivePileUsage > 0}">
										<td>
											<input type="text" id="piece[${status.index}]" name="piece[${status.index}]" disabled="disabled"  class="tdInput" value="${domain.piSix}">
											<input type="hidden" id="pieceId[${status.index}]" name="pieceId[${status.index}]" value="${domain.pidSix}">
											<input type="hidden" id="pieceName[${status.index}]" name="pieceName[${status.index}]" value="중단">
										</td>
										<td>
											<input type="text" id="piece[${status.index}]" name="piece[${status.index}]" disabled="disabled"  class="tdInput" value="${domain.piSeven}">
											<input type="hidden" id="pieceId[${status.index}]" name="pieceId[${status.index}]" value="${domain.pidSeven}">
											<input type="hidden" id="pieceName[${status.index}]" name="pieceName[${status.index}]" value="상단">
										</td>
								</c:when>
							</c:choose>
							
							
							<td>${domain.totalConnectWidth}</td>
							<td>
								${domain.connectLength}
							</td>
							<td>
								<c:choose>
									<c:when test="${param.constructionIdx == 1004}">
										<c:set var="calDrillingDepth" value="${domain.drillingDepth}"/>
										<input type="text" id="drillingDepth" name="drillingDepth" disabled="disabled"  class="tdInput" value="<fmt:formatNumber value='${calDrillingDepth}' pattern='.0' />" />
									</c:when>
									<c:otherwise>
										<input type="text" id="drillingDepth" name="drillingDepth" disabled="disabled"  class="tdInput" value="${domain.drillingDepth}"/>
									</c:otherwise>
								</c:choose>
							</td>
							<c:choose>
								<c:when test="${param.constructionIdx == 1269 or sessionInfo.constructionIdx == 1269}">
									<td>
										<input type="text" id="directDrillingDepth" name="directDrillingDepth" disabled="disabled"  class="tdInput" value="${domain.directDrillingDepth}"/>
									</td>
								</c:when>
							</c:choose>
							<c:choose>
								<c:when test="${sessionInfo.constructionIdx == 1082 or param.constructionIdx == 1082}">
									<td><input type="text" id="sdDrillingDepth" name="sdDrillingDepth" disabled="disabled"  class="tdInput" value="${domain.sdDrillingDepth}"/></td>
									<td><input type="text" id="stDrillingDepth" name="stDrillingDepth" disabled="disabled"  class="tdInput" value="${domain.stDrillingDepth}"/></td>
								</c:when>
							</c:choose>
							
							<!-- 서희건설 다함기초 평택화양 A3BL 센트럴 -->
							<c:choose>
								<c:when test="${sessionInfo.constructionIdx == 901 or param.constructionIdx == 901}">
									<c:choose>
										<c:when test="${domain.drillingDepth == domain.intrusionDepth}">
											<td style="background-color: red;"><input type="text" id="intrusionDepth" name="intrusionDepth" disabled="disabled" class="tdInput"  value="${domain.intrusionDepth}"/></td>
										</c:when>
										<c:otherwise>
											<td><input type="text" id="intrusionDepth" name="intrusionDepth" disabled="disabled" class="tdInput"  value="${domain.intrusionDepth}"/></td>	
										</c:otherwise>
									</c:choose>
								</c:when>
								<c:otherwise>
									<td><input type="text" id="intrusionDepth" name="intrusionDepth" disabled="disabled" class="tdInput"  value="${domain.intrusionDepth}"/></td>	
								</c:otherwise>
							</c:choose>
							<td>
								<c:choose>
									<c:when test="${sessionInfo.constructionIdx == 1082 or param.constructionIdx == 1082}">
												<c:set var="balance" value="${domain.totalConnectWidth - domain.drillingDepth - domain.sdDrillingDepth - domain.stDrillingDepth - domain.intrusionDepth}" />
												<c:choose>
													<c:when test="${balance < 0}">
														0
													</c:when>
													<c:otherwise>
														<fmt:formatNumber value="${balance}" pattern="0.0"/>
													</c:otherwise>												
												</c:choose>
											</c:when>
									<c:otherwise>
										${domain.balance}
									</c:otherwise>
								</c:choose>
							</td>
							<td>
								<c:choose>
									<c:when test="${sessionInfo.constructionIdx == 783 or param.constructionIdx == 783}">
										<c:choose>
											<c:when test="${domain.balance > 0 and domain.gongSac == 0}">
												${domain.gongSac}
											</c:when>
											<c:otherwise>
												<c:set var="calGongSac" value="${domain.gongSac + -0.3}"/>
												<fmt:formatNumber value="${calGongSac}" pattern=".0"/>
											</c:otherwise>
										</c:choose>
									</c:when>
									<c:otherwise>
										<c:choose>
											<c:when test="${sessionInfo.constructionIdx == 1082 or param.constructionIdx == 1082}">
												<c:set var="balance" value="${domain.totalConnectWidth - domain.drillingDepth - domain.sdDrillingDepth - domain.stDrillingDepth - domain.intrusionDepth}" />
												<c:choose>
													<c:when test="${balance < 0}">
														<fmt:formatNumber value="${balance}" pattern="0.0"/>
													</c:when>
													<c:otherwise>
														0
													</c:otherwise>												
												</c:choose>
											</c:when>
											<c:otherwise>
												${domain.gongSac}
											</c:otherwise>
										</c:choose>
									</c:otherwise>
								</c:choose>
							</td>
							<td><input type="text" id="hammaT" name="hammaT"  disabled="disabled" class="tdInput" value="${domain.hammaT}"/></td>
							<td><input type="text" id="fallMeter" name="fallMeter"  disabled="disabled"  class="tdInput" value="${domain.fallMeter}"/></td>
							<td><input type="text" id="managedStandard" name="managedStandard"  disabled="disabled" class="tdInput" value="${domain.managedStandard}"/></td>
							
							<c:choose>
								<c:when test="${sessionInfo.role == 0}">
									<c:choose>
										<c:when test="${isBig > 0}">
											<c:choose>
												<c:when test="${domain.peOne + 0 >= domain.managedStandard + 0}">
													<td style="background-color: red; color: white;">
												</c:when>
												<c:otherwise>
													<td>
												</c:otherwise>
											</c:choose>
												<input type="text" id="penetrations[${status.index}]" name="penetrations[${status.index}]" disabled="disabled"  class="tdInput" value="${domain.peOne eq '0' ? '' : domain.peOne}">
												<input type="hidden" id="penetrationsName[${status.index}]" name="penetrationsName[${status.index}]" value="1회">
												<input type="hidden" id="penetrationsId[${status.index}]" name="penetrationsId[${status.index}]" value="${domain.peidOne}">
											</td>
											<c:choose>
												<c:when test="${domain.peTwo + 0 >= domain.managedStandard + 0}">
													<td style="background-color: red; color: white;">
												</c:when>
												<c:otherwise>
													<td>
												</c:otherwise>
											</c:choose>
												<input type="text" id="penetrations[${status.index}]" name="penetrations[${status.index}]" disabled="disabled"  class="tdInput" value="${domain.peTwo eq '0' ? '' : domain.peTwo}">
												<input type="hidden" id="penetrationsName[${status.index}]" name="penetrationsName[${status.index}]" value="2회">
												<input type="hidden" id="penetrationsId[${status.index}]" name="penetrationsId[${status.index}]" value="${domain.peidTwo}">
												
											</td>
											<c:choose>
												<c:when test="${domain.peThree + 0 >= domain.managedStandard + 0}">
													<td style="background-color: red; color: white;">
												</c:when>
												<c:otherwise>
													<td>
												</c:otherwise>
											</c:choose>
												<input type="text" id="penetrations[${status.index}]" name="penetrations[${status.index}]" disabled="disabled"  class="tdInput" value="${domain.peThree eq '0' ? '' : domain.peThree}">
												<input type="hidden" id="penetrationsName[${status.index}]" name="penetrationsName[${status.index}]" value="3회">
												<input type="hidden" id="penetrationsId[${status.index}]" name="penetrationsId[${status.index}]" value="${domain.peidThree}">
												
											</td>
											<c:choose>
												<c:when test="${domain.peFour + 0 >= domain.managedStandard + 0}">
													<td style="background-color: red; color: white;">
												</c:when>
												<c:otherwise>
													<td>
												</c:otherwise>
											</c:choose>
												<input type="text" id="penetrations[${status.index}]" name="penetrations[${status.index}]" disabled="disabled"  class="tdInput" value="${domain.peFour eq '0' ? '' : domain.peFour}">
												<input type="hidden" id="penetrationsName[${status.index}]" name="penetrationsName[${status.index}]" value="4회">
												<input type="hidden" id="penetrationsId[${status.index}]" name="penetrationsId[${status.index}]" value="${domain.peidFour}">
												
											</td>
											<c:choose>
												<c:when test="${domain.peFive + 0 >= domain.managedStandard + 0}">
													<td style="background-color: red; color: white;">
												</c:when>
												<c:otherwise>
													<td>
												</c:otherwise>
											</c:choose>
												<input type="text" id="penetrations[${status.index}]" name="penetrations[${status.index}]" disabled="disabled"  class="tdInput" value="${domain.peFive eq '0' ? '' : domain.peFive}">
												<input type="hidden" id="penetrationsName[${status.index}]" name="penetrationsName[${status.index}]" value="5회">
												<input type="hidden" id="penetrationsId[${status.index}]" name="penetrationsId[${status.index}]" value="${domain.peidFive}">
												
											</td>
											<c:choose>
												<c:when test="${domain.peSix + 0 >= domain.managedStandard + 0}">
													<td style="background-color: red; color: white;">
												</c:when>
												<c:otherwise>
													<td>
												</c:otherwise>
											</c:choose>
												<input type="text" id="penetrations[${status.index}]" name="penetrations[${status.index}]" disabled="disabled"  class="tdInput" value="${domain.peSix eq '0' ? '' : domain.peSix}">
												<input type="hidden" id="penetrationsName[${status.index}]" name="penetrationsName[${status.index}]" value="6회">
												<input type="hidden" id="penetrationsId[${status.index}]" name="penetrationsId[${status.index}]" value="${domain.peidSix}">
												
											</td>
											<c:choose>
												<c:when test="${domain.peSeven + 0 >= domain.managedStandard + 0}">
													<td style="background-color: red; color: white;">
												</c:when>
												<c:otherwise>
													<td>
												</c:otherwise>
											</c:choose>
												<input type="text" id="penetrations[${status.index}]" name="penetrations[${status.index}]" disabled="disabled"  class="tdInput" value="${domain.peSeven eq '0' ? '' : domain.peSeven}">
												<input type="hidden" id="penetrationsName[${status.index}]" name="penetrationsName[${status.index}]" value="7회">
												<input type="hidden" id="penetrationsId[${status.index}]" name="penetrationsId[${status.index}]" value="${domain.peidSeven}">
												
											</td>
											<c:choose>
												<c:when test="${domain.peEight + 0 >= domain.managedStandard + 0}">
													<td style="background-color: red; color: white;">
												</c:when>
												<c:otherwise>
													<td>
												</c:otherwise>
											</c:choose>
												<input type="text" id="penetrations[${status.index}]" name="penetrations[${status.index}]" disabled="disabled"  class="tdInput" value="${domain.peEight eq '0' ? '' : domain.peEight}">
												<input type="hidden" id="penetrationsName[${status.index}]" name="penetrationsName[${status.index}]" value="8회">
												<input type="hidden" id="penetrationsId[${status.index}]" name="penetrationsId[${status.index}]" value="${domain.peidEight}">
											</td>
											<c:choose>
												<c:when test="${domain.peNine + 0 >= domain.managedStandard + 0}">
													<td style="background-color: red; color: white;">
												</c:when>
												<c:otherwise>
													<td>
												</c:otherwise>
											</c:choose>
												<input type="text" id="penetrations[${status.index}]" name="penetrations[${status.index}]" disabled="disabled"  class="tdInput" value="${domain.peNine eq '0' ? '' : domain.peNine}">
												<input type="hidden" id="penetrationsName[${status.index}]" name="penetrationsName[${status.index}]" value="9회">
												<input type="hidden" id="penetrationsId[${status.index}]" name="penetrationsId[${status.index}]" value="${domain.peidNine}">
												
											</td>
											<c:choose>
												<c:when test="${domain.peTen + 0 >= domain.managedStandard + 0}">
													<td style="background-color: red; color: white;">
												</c:when>
												<c:otherwise> 
													<td>
												</c:otherwise>
											</c:choose>
												<input type="text" id="penetrations[${status.index}]" name="penetrations[${status.index}]" disabled="disabled"  class="tdInput" value="${domain.peTen eq '0' ? '' : domain.peTen}">
												<input type="hidden" id="penetrationsName[${status.index}]" name="penetrationsName[${status.index}]" value="10회">
												<input type="hidden" id="penetrationsId[${status.index}]" name="penetrationsId[${status.index}]" value="${domain.peidTen}">
											</td>
										</c:when>
										<c:otherwise>
											<c:choose>
												<c:when test="${domain.peOne + 0 >= domain.managedStandard + 0}">
													<td style="background-color: red; color: white;">
												</c:when>
												<c:otherwise>
													<td>
												</c:otherwise>
											</c:choose>
												<input type="text" id="penetrations[${status.index}]" name="penetrations[${status.index}]" disabled="disabled"  class="tdInput" value="${domain.peOne eq '0' ? '' : domain.peOne}">
												<input type="hidden" id="penetrationsName[${status.index}]" name="penetrationsName[${status.index}]" value="1회">
												<input type="hidden" id="penetrationsId[${status.index}]" name="penetrationsId[${status.index}]" value="${domain.peidOne}">
											</td>
											<c:choose>
												<c:when test="${domain.peTwo + 0 >= domain.managedStandard + 0}">
													<td style="background-color: red; color: white;">
												</c:when>
												<c:otherwise>
													<td>
												</c:otherwise>
											</c:choose>
												<input type="text" id="penetrations[${status.index}]" name="penetrations[${status.index}]" disabled="disabled"  class="tdInput" value="${domain.peTwo eq '0' ? '' : domain.peTwo}">
												<input type="hidden" id="penetrationsName[${status.index}]" name="penetrationsName[${status.index}]" value="2회">
												<input type="hidden" id="penetrationsId[${status.index}]" name="penetrationsId[${status.index}]" value="${domain.peidTwo}">
											</td>
											<c:choose>
												<c:when test="${domain.peThree + 0 >= domain.managedStandard + 0}">
													<td style="background-color: red; color: white;">
												</c:when>
												<c:otherwise>
													<td>
												</c:otherwise>
											</c:choose>
												<input type="text" id="penetrations[${status.index}]" name="penetrations[${status.index}]" disabled="disabled"  class="tdInput" value="${domain.peThree eq '0' ? '' : domain.peThree}">
												<input type="hidden" id="penetrationsName[${status.index}]" name="penetrationsName[${status.index}]" value="3회">
												<input type="hidden" id="penetrationsId[${status.index}]" name="penetrationsId[${status.index}]" value="${domain.peidThree}">
											</td>
											<c:choose>
												<c:when test="${domain.peFour + 0 >= domain.managedStandard + 0}">
													<td style="background-color: red; color: white;">
												</c:when>
												<c:otherwise>
													<td>
												</c:otherwise>
											</c:choose>
												<input type="text" id="penetrations[${status.index}]" name="penetrations[${status.index}]" disabled="disabled"  class="tdInput" value="${domain.peFour eq '0' ? '' : domain.peFour}">
												<input type="hidden" id="penetrationsName[${status.index}]" name="penetrationsName[${status.index}]" value="4회">
												<input type="hidden" id="penetrationsId[${status.index}]" name="penetrationsId[${status.index}]" value="${domain.peidFour}">
											</td>
											<c:choose>
												<c:when test="${domain.peFive + 0 >= domain.managedStandard + 0}">
													<td style="background-color: red; color: white;">
												</c:when>
												<c:otherwise>
													<td>
												</c:otherwise>
											</c:choose>
												<input type="text" id="penetrations[${status.index}]" name="penetrations[${status.index}]" disabled="disabled"  class="tdInput" value="${domain.peFive eq '0' ? '' : domain.peFive}">
												<input type="hidden" id="penetrationsName[${status.index}]" name="penetrationsName[${status.index}]" value="5회">
												<input type="hidden" id="penetrationsId[${status.index}]" name="penetrationsId[${status.index}]" value="${domain.peidFive}">
											</td>
										</c:otherwise>
									</c:choose>
								</c:when>
								<c:otherwise>
									<c:choose>
										<c:when test="${sessionInfo.constructionIdx == 645}">
											<c:choose>
												<c:when test="${isBig > 0}">
														<input type="hidden" id="penetrations[${status.index}]" name="penetrations[${status.index}]" disabled="disabled"  class="tdInput" value="${domain.peOne eq '0' ? '' : domain.peOne}">
														<input type="hidden" id="penetrations[${status.index}]" name="penetrations[${status.index}]" disabled="disabled"  class="tdInput" value="${domain.peTwo eq '0' ? '' : domain.peTwo}">
														<input type="hidden" id="penetrations[${status.index}]" name="penetrations[${status.index}]" disabled="disabled"  class="tdInput" value="${domain.peThree eq '0' ? '' : domain.peThree}">
														<input type="hidden" id="penetrations[${status.index}]" name="penetrations[${status.index}]" disabled="disabled"  class="tdInput" value="${domain.peFour eq '0' ? '' : domain.peFour}">
														<input type="hidden" id="penetrations[${status.index}]" name="penetrations[${status.index}]" disabled="disabled"  class="tdInput" value="${domain.peFive eq '0' ? '' : domain.peFive}">
														<input type="hidden" id="penetrations[${status.index}]" name="penetrations[${status.index}]" disabled="disabled"  class="tdInput" value="${domain.peSeven eq '0' ? '' : domain.peSeven}">
														<input type="hidden" id="penetrations[${status.index}]" name="penetrations[${status.index}]" disabled="disabled"  class="tdInput" value="${domain.peEight eq '0' ? '' : domain.peEight}">
														<input type="hidden" id="penetrations[${status.index}]" name="penetrations[${status.index}]" disabled="disabled"  class="tdInput" value="${domain.peNine eq '0' ? '' : domain.peNine}">
														<input type="hidden" id="penetrations[${status.index}]" name="penetrations[${status.index}]" disabled="disabled"  class="tdInput" value="${domain.peTen eq '0' ? '' : domain.peTen}">
												</c:when>
												<c:otherwise>
														<input type="hidden" id="penetrations[${status.index}]" name="penetrations[${status.index}]" disabled="disabled"  class="tdInput" value="${domain.peOne eq '0' ? '' : domain.peOne}">
														<input type="hidden" id="penetrations[${status.index}]" name="penetrations[${status.index}]" disabled="disabled"  class="tdInput" value="${domain.peTwo eq '0' ? '' : domain.peTwo}">
														<input type="hidden" id="penetrations[${status.index}]" name="penetrations[${status.index}]" disabled="disabled"  class="tdInput" value="${domain.peThree eq '0' ? '' : domain.peThree}">
														<input type="hidden" id="penetrations[${status.index}]" name="penetrations[${status.index}]" disabled="disabled"  class="tdInput" value="${domain.peFour eq '0' ? '' : domain.peFour}">
														<input type="hidden" id="penetrations[${status.index}]" name="penetrations[${status.index}]" disabled="disabled"  class="tdInput" value="${domain.peFive eq '0' ? '' : domain.peFive}">
												</c:otherwise>
											</c:choose>
										</c:when>
										<c:otherwise>
											<c:choose>
												<c:when test="${isBig > 0}">
													<td>
														<input type="hidden" id="penetrations[${status.index}]" name="penetrations[${status.index}]" disabled="disabled"  class="tdInput" value="${domain.peOne eq '0' ? '' : domain.peOne}">
														${domain.peOne}
													</td>
													<td>
														<input type="hidden" id="penetrations[${status.index}]" name="penetrations[${status.index}]" disabled="disabled"  class="tdInput" value="${domain.peTwo eq '0' ? '' : domain.peTwo}">
														${domain.peTwo}
														
													</td>
													<td>
														<input type="hidden" id="penetrations[${status.index}]" name="penetrations[${status.index}]" disabled="disabled"  class="tdInput" value="${domain.peThree eq '0' ? '' : domain.peThree}">
														${domain.peThree}
														
													</td>
													<td>
														<input type="hidden" id="penetrations[${status.index}]" name="penetrations[${status.index}]" disabled="disabled"  class="tdInput" value="${domain.peFour eq '0' ? '' : domain.peFour}">
														${domain.peFour}
														
													</td>
													<td>
														<input type="hidden" id="penetrations[${status.index}]" name="penetrations[${status.index}]" disabled="disabled"  class="tdInput" value="${domain.peFive eq '0' ? '' : domain.peFive}">
														${domain.peFive}
														
													</td>
													<td>
														<input type="hidden" id="penetrations[${status.index}]" name="penetrations[${status.index}]" disabled="disabled"  class="tdInput" value="${domain.peSix eq '0' ? '' : domain.peSix}">
														${domain.peSix}
														
													</td>
													<td>
														<input type="hidden" id="penetrations[${status.index}]" name="penetrations[${status.index}]" disabled="disabled"  class="tdInput" value="${domain.peSeven eq '0' ? '' : domain.peSeven}">
														${domain.peSeven}
														
													</td>
													<td>
														<input type="hidden" id="penetrations[${status.index}]" name="penetrations[${status.index}]" disabled="disabled"  class="tdInput" value="${domain.peEight eq '0' ? '' : domain.peEight}">
														${domain.peEight}
														
													</td>
													<td>
														<input type="hidden" id="penetrations[${status.index}]" name="penetrations[${status.index}]" disabled="disabled"  class="tdInput" value="${domain.peNine eq '0' ? '' : domain.peNine}">
														${domain.peNine}
														
													</td>
													<td>
														<input type="hidden" id="penetrations[${status.index}]" name="penetrations[${status.index}]" disabled="disabled"  class="tdInput" value="${domain.peTen eq '0' ? '' : domain.peTen}">
														${domain.peTen}
													</td>
												</c:when>
												<c:otherwise>
													<td>
														<input type="hidden" id="penetrations[${status.index}]" name="penetrations[${status.index}]"  class="tdInput"  value="${domain.peOne eq '0' ? '' : domain.peOne}">
														${domain.peOne}
													</td>
													<td>
														<input type="hidden" id="penetrations[${status.index}]" name="penetrations[${status.index}]"  class="tdInput"  value="${domain.peTwo eq '0' ? '' : domain.peTwo}">
														${domain.peTwo}
													</td>
													<td>
														<input type="hidden" id="penetrations[${status.index}]" name="penetrations[${status.index}]"  class="tdInput"  value="${domain.peThree eq '0' ? '' : domain.peThree}">
														${domain.peThree}
													</td>
													<td>
														<input type="hidden" id="penetrations[${status.index}]" name="penetrations[${status.index}]"  class="tdInput"  value="${domain.peFour eq '0' ? '' : domain.peFour}">
														${domain.peFour}
													</td>
													<td>
														<input type="hidden" id="penetrations[${status.index}]" name="penetrations[${status.index}]"  class="tdInput"  value="${domain.peFive eq '0' ? '' : domain.peFive}">
														${domain.peFive}
													</td>
												</c:otherwise>
											</c:choose>
										</c:otherwise>
									</c:choose>
								
									
								</c:otherwise>
								
							</c:choose>
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
									<td>${domain.ultimateBearingCapacity}</td>
									<td><input type="text" id="hammaEfficiency" name="hammaEfficiency"  disabled="disabled"  class="tdInput" value="${domain.hammaEfficiency}"/></td> 
									<td><input type="text" id="modulusElasticity" name="modulusElasticity"  disabled="disabled"  class="tdInput" value="${domain.modulusElasticity}"/></td> 
									<td><input type="text" id="crossSection" name="crossSection"  disabled="disabled" class="tdInput"  value="${domain.crossSection}"/></td> 
									<td><input type="text" id="bigo" name="bigo"  disabled="disabled" class="tdInput" value="${domain.bigo}"/></td>
									<td><input type="text" id="sprCol1" name="sprCol1"  disabled="disabled" class="tdInput" maxlength="50" value="${domain.sprCol1}"/></td>
								</c:when>
								<c:when test="${sessionInfo.role == 1}">
									<!-- 일반 협력사 -->
									<c:choose>
										<c:when test="${(sessionScope.settingRequired and ubcYn == 1) or (not sessionScope.settingRequired and sessionInfo.hiddenManager == true and ubcYn == 1)}">
											<td>${domain.ultimateBearingCapacity}</td>
											<td><input type="text" id="hammaEfficiency" name="hammaEfficiency"  disabled="disabled"  class="tdInput" value="${domain.hammaEfficiency}"/></td> 
											<td><input type="text" id="modulusElasticity" name="modulusElasticity"  disabled="disabled"  class="tdInput" value="${domain.modulusElasticity}"/></td> 
											<td><input type="text" id="crossSection" name="crossSection"  disabled="disabled" class="tdInput"  value="${domain.crossSection}"/></td> 
											<td><input type="text" id="bigo" name="bigo"  disabled="disabled" class="tdInput" value="${domain.bigo}"/></td>
											<input type="hidden" id="sprCol1" name="sprCol1"   class="tdInput" disabled="disabled"  maxlength="50" value="${domain.sprCol1}"/>
										</c:when>
										<c:otherwise>
										
											<input type="hidden" class="tdInput" id="hammaEfficiency" name="hammaEfficiency"  disabled="disabled"  maxlength="10"  value="${domain.hammaEfficiency}"/>
											<input type="hidden" class="tdInput" id="modulusElasticity" name="modulusElasticity"  disabled="disabled"  maxlength="10"  value="${domain.modulusElasticity}"/>
											<input type="hidden" class="tdInput" id="crossSection" name="crossSection"  disabled="disabled" maxlength="10" value="${domain.crossSection}"/>
											<td><input type="text" id="bigo" name="bigo"  disabled="disabled" class="tdInput" value="${domain.bigo}"/></td>
											<c:choose>
												<c:when test="${param.constructionIdx == 492}">
													<td><input type="text" id="sprCol1" name="sprCol1"  disabled="disabled" class="tdInput" maxlength="50" value="${domain.sprCol1}"/></td>
												</c:when>
											</c:choose>
											<input type="hidden" id="sprCol1" name="sprCol1"   class="tdInput" disabled="disabled"  maxlength="50" value="${domain.sprCol1}"/>
											
										</c:otherwise>
									</c:choose>	
								</c:when>
								<c:when test="${sessionInfo.role == 2}">
									<td><input type="text" id="bigo" name="bigo"  disabled="disabled" class="tdInput" value="${domain.bigo}"/></td>
								</c:when>
								<c:when test="${sessionInfo.role == 3}">
									<c:choose>
										<c:when test="${ubcYn == 1}">
											<td>${domain.ultimateBearingCapacity}</td>
											<td><input type="text" id="hammaEfficiency" name="hammaEfficiency"  disabled="disabled"  class="tdInput" value="${domain.hammaEfficiency}"/></td> 
											<td><input type="text" id="modulusElasticity" name="modulusElasticity"  disabled="disabled"  class="tdInput" value="${domain.modulusElasticity}"/></td> 
											<td><input type="text" id="crossSection" name="crossSection"  disabled="disabled" class="tdInput"  value="${domain.crossSection}"/></td> 
											<td><input type="text" id="bigo" name="bigo"  disabled="disabled" class="tdInput" value="${domain.bigo}"/></td>
											<input type="hidden" id="sprCol1" name="sprCol1"   class="tdInput" disabled="disabled"  maxlength="50" value="${domain.sprCol1}"/>
										</c:when>
										<c:otherwise>
											<input type="hidden" class="tdInput" id="hammaEfficiency" name="hammaEfficiency"  disabled="disabled"  maxlength="10"  value="${domain.hammaEfficiency}"/>
											<input type="hidden" class="tdInput" id="modulusElasticity" name="modulusElasticity"  disabled="disabled"  maxlength="10"  value="${domain.modulusElasticity}"/>
											<input type="hidden" class="tdInput" id="crossSection" name="crossSection"  disabled="disabled" maxlength="10" value="${domain.crossSection}"/>
											<td><input type="text" id="bigo" name="bigo"  disabled="disabled" class="tdInput" value="${domain.bigo}"/></td>
											<input type="hidden" id="sprCol1" name="sprCol1"   class="tdInput" disabled="disabled"  maxlength="50" value="${domain.sprCol1}"/>
										</c:otherwise>
									</c:choose>
								</c:when>
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
	<c:choose>
		<c:when test="${param.mode != 'simple'}">
			 <c:choose>
				<c:when test="${sessionInfo.role == 0}"> 
						<div class="bottomBtn" style="margin-bottom: 10px;">
							<div class="type01" onclick="javascript:doRestoreMulti();">복구</div>
							<div class="type02" onclick="javascript:doDeleteMulti();" style="background: #EF340C; border: solid red 1px;">삭제</div>
						</div>
				 </c:when>
				 <c:when test="${sessionInfo.hiddenManager == true  || sessionInfo.role == 3}">
						<div class="bottomBtn" style="margin-bottom: 10px;">
							<div class="type01" onclick="javascript:doRestoreMulti();" style="visibility: hidden;">복구</div>
							<div class="type02" onclick="javascript:doDeleteMulti();"  style="background: #EF340C; border: solid red 1px;">삭제</div>
						</div>
				 </c:when>
			</c:choose>
		</c:when>
	</c:choose>
			<c:choose>
				<c:when test="${sessionInfo.role == 0}"> <!-- 슈퍼관리자 -->
					<div class="tableCArea">
						<div class="btnType02" onclick="javascript:onClickReportUpdate();" style="visibility: hidden;"></div>
						<c:choose>
							<c:when test="${(sessionInfo.constructionIdx == 1550 or  param.constructionIdx == 1550) and (sessionInfo.hiddenManager == true or sessionInfo.role == 0)}">
								<div class="btnType02" id="pdfBtn" onclick="javascript:openDrivingRecordPopup();" style="width: 200px;  background: #258348; border: 1px solid #258348;">현재 파일 항타기록지 PDF</div>
							</c:when>
							<c:otherwise>
								<div class="btnType02" id="pdfBtn" onclick="javascript:downloadDrivingOneRecoredBook();" style="width: 200px;  background: #258348; border: 1px solid #258348;">현재 파일 항타기록지 PDF</div>
							</c:otherwise>
						</c:choose>
						
						<div class="btnType02" id="pdfSignRoomSetting" style="width: 200px; margin-top:10px; background: #FFD400; color:#000000; border: 1px solid #258348;">PDF 결재방 설정</div>
						<!-- <div class="btnType02" id="pdfSignRoomSetting" style="width: 200px; margin-top:10px; background: #760A2D; border: 1px solid #258348;">PDF 결재방 설정</div> -->
					</div>
				</c:when>
				<c:when test="${sessionInfo.role == 1}">  <!-- 협력사 -->
					<c:choose>
						<c:when test="${ sessionInfo.showPdfYn == true}">
							<div class="tableCArea">
								<div class="btnType02" onclick="javascript:onClickReportUpdate();" style="visibility: hidden;"></div>
								<c:choose>
									<c:when test="${(sessionInfo.constructionIdx == 1550 or  param.constructionIdx == 1550) and (sessionInfo.hiddenManager == true or sessionInfo.role == 0)}">
										<div class="btnType02" id="pdfBtn"  onclick="javascript:openDrivingRecordPopup();" style="width: 200px;  background: #258348; border: 1px solid #258348;">현재 파일 항타기록지 PDF</div>
									</c:when>
									<c:otherwise>
										<div class="btnType02" id="pdfBtn" onclick="javascript:downloadDrivingOneRecoredBook();" style="width: 200px;  background: #258348; border: 1px solid #258348;">현재 파일 항타기록지 PDF</div>
									</c:otherwise>
								</c:choose>
								<div class="btnType02" id="pdfSignRoomSetting" style="width: 200px; margin-top:10px; background: #FFD400; color:#000000; border: 1px solid #258348;">PDF 결재방 설정</div>
								<!-- <div class="btnType02" id="pdfSignRoomSetting" style="width: 200px; margin-top:10px; background: #760A2D; border: 1px solid #258348;">PDF 결재방 설정</div> -->
							</div>
						</c:when>
						<c:otherwise>
							<!-- 안동 호반 태흥특수만 틀별히 열어줌 -->
							<c:choose>
								<c:when test="${sessionInfo.constructionIdx == 738}">
									<div class="tableCArea">
										<div class="btnType02" onclick="javascript:onClickReportUpdate();" style="visibility: hidden;"></div>
										<c:choose>
											<c:when test="${(sessionInfo.constructionIdx == 1550 or  param.constructionIdx == 1550) and (sessionInfo.hiddenManager == true or sessionInfo.role == 0)}">
												<div class="btnType02" id="pdfBtn"  onclick="javascript:openDrivingRecordPopup();" style="width: 200px;  background: #258348; border: 1px solid #258348;">현재 파일 항타기록지 PDF</div>
											</c:when>
											<c:otherwise>
												<div class="btnType02" id="pdfBtn" onclick="javascript:downloadDrivingOneRecoredBook();" style="width: 200px;  background: #258348; border: 1px solid #258348;">현재 파일 항타기록지 PDF</div>
											</c:otherwise>
										</c:choose>
										<div class="btnType02" id="pdfSignRoomSetting" style="width: 200px; margin-top:10px; background: #FFD400; color:#000000; border: 1px solid #258348;">PDF 결재방 설정</div>
										<!-- <div class="btnType02" id="pdfSignRoomSetting" style="width: 200px; margin-top:10px; background: #760A2D; border: 1px solid #258348;">PDF 결재방 설정</div> -->
									</div>
								</c:when>
							</c:choose>
						</c:otherwise>
					</c:choose>
				</c:when>
				<c:when test="${sessionInfo.role == 2}"> <!-- 시공사 -->
					 <c:choose>
						<c:when test="${sessionInfo.userId == 'ji2177'}"> <!-- 제일건설(주) 만 열어줌 -->
							<div class="tableCArea">
								<div class="btnType02" onclick="javascript:onClickReportUpdate();" style="visibility: hidden;"></div>
								<c:choose>
									<c:when test="${(sessionInfo.constructionIdx == 1550 or  param.constructionIdx == 1550) and (sessionInfo.hiddenManager == true or sessionInfo.role == 0)}">
										<div class="btnType02" id="pdfBtn"  onclick="javascript:openDrivingRecordPopup();" style="width: 200px;  background: #258348; border: 1px solid #258348;">현재 파일 항타기록지 PDF</div>
									</c:when>
									<c:otherwise>
										<div class="btnType02" id="pdfBtn" onclick="javascript:downloadDrivingOneRecoredBook();" style="width: 200px;  background: #258348; border: 1px solid #258348;">현재 파일 항타기록지 PDF</div>
									</c:otherwise>
								</c:choose>
								<div class="btnType02" id="pdfSignRoomSetting" style="width: 200px; margin-top:10px; background: #FFD400; color:#000000; border: 1px solid #258348;">PDF 결재방 설정</div>
								<!-- <div class="btnType02" id="pdfSignRoomSetting" style="width: 200px; margin-top:10px; background: #760A2D; border: 1px solid #258348;">PDF 결재방 설정</div> -->
							</div>
						</c:when>
					</c:choose>
				</c:when>
				<c:when test="${sessionInfo.role == 3}"> <!-- 가맹점 -->
					<c:choose>
						<c:when test="${showPdfYn > 0}">
							<div class="tableCArea">
								<div class="btnType02" onclick="javascript:onClickReportUpdate();" style="visibility: hidden;"></div>
								<div class="btnType02" id="pdfBtn"  onclick="javascript:downloadDrivingOneRecoredBook();" style="width: 200px;  background: #258348; border: 1px solid #258348;">현재 파일 항타기록지 PDF</div>
								<div class="btnType02" id="pdfSignRoomSetting" style="width: 200px; margin-top:10px; background: #FFD400; color:#000000; border: 1px solid #258348;">PDF 결재방 설정</div>
								<!-- <div class="btnType02" id="pdfSignRoomSetting" style="width: 200px; margin-top:10px; background: #760A2D; border: 1px solid #258348;">PDF 결재방 설정</div> -->
							</div>
						</c:when>
					</c:choose>
				</c:when>
			</c:choose>
			
			<table id="sumGrpTb" class="sumGrpTb" style="table-layout: fixed">
				<tr>
					<td><img  src="${pageContext.request.contextPath}/new/img/report_up.png" onclick="javascript:onClickReportPrev();"></td>
					<td class="sumGrpTbTh" style="width: 3%;">순번</td>
					<td class="sumGrpTbTh" style="width: 10%;">시공일</td>
					<td class="sumGrpTbTh">파일<br>종류</td>
					<td class="sumGrpTbTh">시공<br>공법</td>
					<td class="sumGrpTbTh">시공<br>위치</td>
					<td class="sumGrpTbTh">파일<br>번호</td>
					<td class="sumGrpTbTh">파일<br>규격</td>
					<td class="sumGrpTbTh">파일<br>합계</td>
						
					<c:choose>
						<c:when test="${sessionInfo.constructionIdx == 944 or param.constructionIdx == 944 or sessionInfo.constructionIdx == 1136 or param.constructionIdx == 1136}">
							<td class="sumGrpTbTh">경타<br>길이</td>
							<td class="sumGrpTbTh">천공<br>깊이</td>
						</c:when>
						<c:otherwise>
							
							
							<c:choose>
								<c:when test="${sessionInfo.constructionIdx == 1269 or param.constructionIdx == 1269}">
									<td class="sumGrpTbTh">천공 +<br>직타</td>
								</c:when>
								<c:otherwise>
									<td class="sumGrpTbTh">천공<br>깊이</td>
								</c:otherwise>
							</c:choose>
							<c:choose>
								<c:when test="${sessionInfo.constructionIdx == 1082 or param.constructionIdx == 1082}">
									<td class="sumGrpTbTh">경타<br>깊이</td>
								</c:when>
								<c:otherwise>
									<td class="sumGrpTbTh">관입<br>깊이</td>
								</c:otherwise>
							</c:choose>
						</c:otherwise>
					</c:choose>
				
					<td class="sumGrpTbTh">파일<br>잔량</td>
					<td class="sumGrpTbTh">
						<c:choose>
							<c:when test="${(sessionInfo.constructionIdx == 692 or param.constructionIdx == 692) or (sessionInfo.constructionIdx == 720 or param.constructionIdx == 720)}">
								추가<br>천공
							</c:when>
							<c:otherwise>
								공삭<br>공
							</c:otherwise>
						</c:choose>
					</td>
					<td class="sumGrpTbTh">해머<br>무게</td>
					<td class="sumGrpTbTh">낙하<br>높이</td>
					<td class="sumGrpTbTh">관리<br>기준</td>
					<td class="sumGrpTbTh">평균<br>관입</td>
					<td class="sumGrpTbTh">최종<br>관입</td>
				</tr>
				<tr>
					<td>
						<img src="${pageContext.request.contextPath}/new/img/report_down.png" onclick="javascript:onClickReportNext();">
					</td>
					<td id="curNo"></td>
					<td id="curDate"></td>
					<td id="curPileType"></td>
					<td id="curMethod"></td>
					<td id="curLocation"></td>
					<td id="curPileNo"></td>
					<td id="curPileStandard"></td>
					<td id="curPileSum"></td>
					
					<td id="curDrillingDepth"></td>
					<td id="curIntrusionDepth"></td>
					<td id="curBalance"></td>
					<td id="curGongSac"></td>
					<td id="curHammaT"></td>
					<td id="curFallMeter"></td>
					<td id="curManagedStandard"></td>
					<td id="curAvgPenetrationValue"></td>
					<td id="curTotalPenetrationValue"></td>
				</tr>
			</table>
			
			
			<table class="sumGrpTbMobile" style="table-layout: fixed">
				<tr>
					<td rowspan="2" class="prev">
						<img  src="${pageContext.request.contextPath}/new/img/report_up.png" onclick="javascript:onClickReportPrev();">
					</td>
					<td class="sumGrpTbTh">순번</td>
					<td class="sumGrpTbTh">시공<br>일자</td>
					<td class="sumGrpTbTh">파일<br>종류</td>
					<td class="sumGrpTbTh">시공<br>공법</td>
					<td class="sumGrpTbTh">시공<br>위치</td>
					<td class="sumGrpTbTh">파일<br>번호</td>
					<td class="sumGrpTbTh">파일<br>규격</td>
					<td class="sumGrpTbTh">파일<br>합계</td>
					<c:choose>
						<c:when test="${sessionInfo.constructionIdx == 944 or param.constructionIdx == 944 or sessionInfo.constructionIdx == 1136 or param.constructionIdx == 1136}">
							<td class="sumGrpTbTh">경타<br>길이</td>
						</c:when>
						<c:otherwise>
							<td class="sumGrpTbTh">천공<br>깊이</td>
						</c:otherwise>
					</c:choose>
				</tr>
				<tr>
					<td id="mCurNo"></td>
					<td id="mCurDate"></td>
					<td id="mCurPileType"></td>
					<td id="mCurMethod"></td>
					<td id="mCurLocation"></td>
					<td id="mCurPileNo"></td>
					<td id="mCurPileStandard"></td>
					<td id="mCurPileSum"></td>
					<td id="mCurDrillingDepth"></td>
				</tr>
				<tr>
					<td rowspan="2" class="next">
						<img  src="${pageContext.request.contextPath}/new/img/report_down.png" onclick="javascript:onClickReportNext();">
					</td>
					<c:choose>
						<c:when test="${sessionInfo.constructionIdx == 944 or param.constructionIdx == 944 or sessionInfo.constructionIdx == 1136 or param.constructionIdx == 1136}">
							<td class="sumGrpTbTh">천공<br>깊이</td>
						</c:when>
						<c:otherwise>
						
							<c:choose>
								<c:when test="${sessionInfo.constructionIdx == 1082 or param.constructionIdx == 1082}">
									<td class="sumGrpTbTh">경타<br>깊이</td>
								</c:when>
								<c:otherwise>
									<td class="sumGrpTbTh">관입<br>깊이</td>
								</c:otherwise>
							</c:choose>
							
						</c:otherwise>
					</c:choose>
					<td class="sumGrpTbTh">파일<br>잔량</td>
					<td class="sumGrpTbTh">공삭<br>공</td>
					<td class="sumGrpTbTh">해머<br>무게</td>
					<td class="sumGrpTbTh">낙하<br>높이</td>
					<td class="sumGrpTbTh">관리<br>기준</td>
					<td class="sumGrpTbTh">평균<br>관입</td>
					<td class="sumGrpTbTh">최종<br>관입</td>
					<td class="sumGrpTbTh"><br></td>
				</tr>
				<tr>
					<td id="mCurIntrusionDepth"></td>
					<td id="mCurBalance"></td>
					<td id="mCurGongSac"></td>
					<td id="mCurHammaT"></td>
					<td id="mCurFallMeter"></td>
					<td id="mCurManagedStandard"></td>
					<td id="mCurAvgPenetrationValue"></td>
					<td id="mCurTotalPenetrationValue"></td>
					<td id="">&nbsp;</td>
				</tr>
			</table>
		
	<div id="main" style="width: 100%;height:300px; padding-top: 20px; padding-bottom:20px; background-color: white;"></div>
    <script src="${pageContext.request.contextPath}/new/js/drbPdfByReportTable.js?123123"></script>
  <%--  	<c:choose>
		<c:when test="${sessionInfo.role == 0}"> <!-- 슈퍼관리자 -->
			<div class="tableCArea" style="margin-bottom: 5px; margin-top: 20px;">
				<div class="btnType02" id="pdfSignRoomSetting" style="width: 200px; margin-top:10px; background: #FFD400; color:#000000; border: 1px solid #258348;">PDF 결재방 설정</div>
			</div>
		</c:when>
		<c:when test="${sessionInfo.role == 1}">  <!-- 협력사 -->
			<c:choose>
				<c:when test="${ sessionInfo.showPdfYn == true}">
					<div class="tableCArea" style="margin-bottom: 5px; margin-top: 20px;">
						<div class="btnType02" id="pdfSignRoomSetting" style="width: 200px; margin-top:10px; background: #FFD400; color:#000000; border: 1px solid #258348;">PDF 결재방 설정</div>
					</div>
				</c:when>
				<c:otherwise>
					<!-- 안동 호반 태흥특수만 틀별히 열어줌 -->
					<c:choose>
						<c:when test="${sessionInfo.constructionIdx == 738}">
							<div class="tableCArea" style="margin-bottom: 5px; margin-top: 20px;">
								<div class="btnType02" id="pdfSignRoomSetting" style="width: 200px; margin-top:10px; background: #FFD400; color:#000000; border: 1px solid #258348;">PDF 결재방 설정</div>
							</div>
						</c:when>
					</c:choose>
				</c:otherwise>
			</c:choose>
		</c:when>
		<c:when test="${sessionInfo.role == 2}"> <!-- 시공사 -->
		</c:when>
		<c:when test="${sessionInfo.role == 3}"> <!-- 가맹점 -->
			<c:choose>
				<c:when test="${showPdfYn > 0}">
					<div class="tableCArea" style="margin-bottom: 5px; margin-top: 20px;">
						<div class="btnType02" id="pdfSignRoomSetting" style="width: 200px; margin-top:10px; background: #FFD400; color:#000000; border: 1px solid #258348;">PDF 결재방 설정</div>
					</div>
				</c:when>
			</c:choose>
		</c:when>
	</c:choose> --%>
   	
    <c:choose>
		<c:when test="${sessionInfo.role == 0}"> <!-- 슈퍼관리자 -->
			<div class="viewTable viewTable01" style="width: 100%;margin-top: 0px;">
				<table>
					<colgroup>
						<col width="5%">
						<col width="15%">
						<col width="5%">
						<col width="15%">
						<col width="5%">
						<col width="15%">
						<col width="5%">
						<col width="15%">
					</colgroup>
					<tr  class="viewTh">
						<th colspan="8" class="pdfTableDNum" style="text-align: left; font-weight: bold; padding: 5px;">EXCEL 결재방 설정 정보</th>
					</tr>
					<tr  class="viewTh">
						<th class="pdfTableDNum">순서</th>
						<th class="pdfTableDNum">결재자</th>
						<th class="pdfTableDNum">순서</th>
						<th class="pdfTableDNum">결재자</th>
						<th class="pdfTableDNum">순서</th>
						<th class="pdfTableDNum">결재자</th>
						<th class="pdfTableDNum">순서</th>
						<th class="pdfTableDNum">결재자</th>
					</tr>
					<tr>
						<td>1</td>
						<td><input type="text" class="tdInput" id="approver1" name="approver1" disabled="disabled" value="" /></td>
						<td>2</td>
						<td><input type="text" class="tdInput" id="approver2" name="approver2"  disabled="disabled" value="" /></td>
						<td>3</td>
						<td><input type="text" class="tdInput" id="approver3" name="approver3"  disabled="disabled" value="" /></td>
						<td>4</td>
						<td><input type="text" class="tdInput" id="approver4" name="approver4"  disabled="disabled" value="" /></td>
					</tr>
				</table>
			</div>
			
			
			<div class="viewTable viewTable01" style="width: 100%;margin-top: 0px;">
				<table>
					<colgroup>
						<col width="5%">
						<col width="15%">
						<col width="5%">
						<col width="15%">
						<col width="5%">
						<col width="15%">
						<col width="5%">
						<col width="15%">
					</colgroup>
					<tr  class="viewTh">
						<th colspan="8" class="pdfTableDNum" style="text-align: left; font-weight: bold; padding: 5px;">PDF 결재방 설정 정보</th>
					</tr>
					<tr  class="viewTh">
						<th class="pdfTableDNum">순서</th>
						<th class="pdfTableDNum">결재자</th>
						<th class="pdfTableDNum">순서</th>
						<th class="pdfTableDNum">결재자</th>
						<th class="pdfTableDNum">순서</th>
						<th class="pdfTableDNum">결재자</th>
						<th class="pdfTableDNum">순서</th>
						<th class="pdfTableDNum">결재자</th>
					</tr>
					<tr>
						<td>1</td>
						<td><input type="text" class="tdInput" id="excel_approver1" name="excel_approver1" disabled="disabled" value="" /></td>
						<td>2</td>
						<td><input type="text" class="tdInput" id="excel_approver2" name="excel_approver2"  disabled="disabled" value="" /></td>
						<td>3</td>
						<td><input type="text" class="tdInput" id="excel_approver3" name="excel_approver3"  disabled="disabled" value="" /></td>
						<td>4</td>
						<td><input type="text" class="tdInput" id="excel_approver4" name="excel_approver4"  disabled="disabled" value="" /></td>
					</tr>
				</table>
			</div>
		</c:when>
	</c:choose>
	
	
	<div class="popUp popUp02">
		<div class="popTit">
			<p>PDF 결재방 설정</p>
			<img class="popClose" src="${pageContext.request.contextPath}/new/img/popclose.png" />
		</div>

		<div class="popCont">
			<div class="inputArea02 mb-20">
				<div class="viewTable viewTable01" style="margin-bottom: 20px; width: 100%;">
					<table id="sigmroom_table" class="signTable">
						<colgroup>
							<col width="20%">
							<col width="80%">
						</colgroup>
						<tr class="viewTh">
							<th style="border: solid #E4E4E4 1px; padding: 5px;" scope="col">순번</th>
							<th style="border: solid #E4E4E4 1px; padding: 5px;" scope="col">결재자</th>
						</tr>
						<tr>
							<td>
								<input type="hidden" id="id" name="id" value=""/>
								<input type="text" class="tdInput" id="seq" name="seq" disabled="disabled" value="1" />
							</td>
							<td style="padding: 3px;">
								<input type="text" class="tdInput" id="approver" name="approver" value="" />
							</td>
						</tr>
						<tr>
							<td>
								<input type="hidden" id="id" name="id" value=""/>
								<input type="text" class="tdInput" id="seq" name="seq" disabled="disabled" value="2" />
							</td>
							<td style="padding: 3px;">
								<input type="text" class="tdInput" id="approver" name="approver"  value="" />
							</td>
						</tr>
						<tr>
							<td>
								<input type="hidden" id="id" name="id" value=""/>
								<input type="text" class="tdInput" id="seq" name="seq" disabled="disabled" value="3" />
							</td>
							<td style="padding: 3px;">
								<input type="text" class="tdInput" id="approver" name="approver"  value="" />
							</td>
						</tr>
						<tr>
							<td>
								<input type="hidden" id="id" name="id" value=""/>
								<input type="text" class="tdInput" id="seq" name="seq" disabled="disabled" value="4" />
							</td>
							<td style="padding: 3px;">
								<input type="text" class="tdInput" id="approver" name="approver"  value="" />
							</td>
						</tr>
					</table>
				</div>
				<div class="popAdd" onclick="javascript:registSignRoomCheck();">등록</div>
			</div>
		</div>
	</div>
	<br>
	<div class="popUp popUp03">
		<div class="popTit">
			<p>EXCEL 결재방 설정</p>
			<img class="popClose" src="${pageContext.request.contextPath}/new/img/popclose.png" />
		</div>

		<div class="popCont">
			<div class="inputArea02 mb-20">
				<div class="viewTable viewTable01" style="margin-bottom: 20px; width: 100%;">
					<table id="excel_sigmroom_table" class="signTable">
						<colgroup>
							<col width="20%">
							<col width="80%">
						</colgroup>
						<tr class="viewTh">
							<th style="border: solid #E4E4E4 1px; padding: 5px;" scope="col">순번</th>
							<th style="border: solid #E4E4E4 1px; padding: 5px;" scope="col">결재자</th>
						</tr>
						<tr>
							<td>
								<input type="hidden" id="id" name="id" value=""/>
								<input type="text" class="tdInput" id="seq" name="seq" disabled="disabled" value="1" />
							</td>
							<td style="padding: 3px;">
								<input type="text" class="tdInput" id="approver" name="approver" value="" />
							</td>
						</tr>
						<tr>
							<td>
								<input type="hidden" id="id" name="id" value=""/>
								<input type="text" class="tdInput" id="seq" name="seq" disabled="disabled" value="2" />
							</td>
							<td style="padding: 3px;">
								<input type="text" class="tdInput" id="approver" name="approver"  value="" />
							</td>
						</tr>
						<tr>
							<td>
								<input type="hidden" id="id" name="id" value=""/>
								<input type="text" class="tdInput" id="seq" name="seq" disabled="disabled" value="3" />
							</td>
							<td style="padding: 3px;">
								<input type="text" class="tdInput" id="approver" name="approver"  value="" />
							</td>
						</tr>
						<tr>
							<td>
								<input type="hidden" id="id" name="id" value=""/>
								<input type="text" class="tdInput" id="seq" name="seq" disabled="disabled" value="4" />
							</td>
							<td style="padding: 3px;">
								<input type="text" class="tdInput" id="approver" name="approver"  value="" />
							</td>
						</tr>
					</table>
				</div>
				<div class="popAdd" onclick="javascript:registExcelSignRoomCheck();">등록</div>
			</div>
		</div>
	</div>
	
	<div class="popUp popUp04">
	    <div class="popTit">
	        <p>기록지 복사 → 추가</p>
	        <img class="popClose" src="${pageContext.request.contextPath}/new/img/popclose.png" />
	    </div>
	
	    <div class="popCont">
	        <table class="signTable" style="padding:10px">
	            <tr><th colspan="7" style="background:#eee; padding:10px;">기본 및 파일 정보</th></tr>
				<tr>
				    <td class="viewTh" colspan="1">순번</td><td colspan="2"><input type="text" class="tdInput copy-input" id="copy_rownum" readonly /></td>
				    <td class="viewTh" colspan="1">시공일</td><td colspan="3"><input type="text" class="tdInput copy-input" id="copy_createDate" name="createDate" /></td>
				</tr>
				<tr>
				    <td class="viewTh" colspan="1">파일종류</td><td colspan="2"><input type="text" class="tdInput copy-input" id="copy_pileType" name="pileType" /></td>
				    <td class="viewTh" colspan="1">시공공법</td><td colspan="3"><input type="text" class="tdInput copy-input" id="copy_method" name="method" /></td>
				</tr>
				<tr>
				    <td class="viewTh" colspan="1">시공위치</td><td colspan="2"><input type="text" class="tdInput copy-input" id="copy_location" name="location" /></td>
				    <td class="viewTh" colspan="1">파일번호</td><td colspan="3"><input type="text" class="tdInput copy-input" id="copy_pileNo" name="pileNo" /></td>
				</tr>
				<tr>
				    <td class="viewTh" colspan="2">파일규격</td><td colspan="5"><input type="text" class="tdInput copy-input" id="copy_pileStandard" name="pileStandard" /></td>
				</tr>
			</table>
				
			<table class="signTable" style="padding-top:10px;">
			    <tr><th id="mainTitle" colspan="7" style="background:#eee; padding:10px;">파일 상세 구분 (단위: M/개소)</th></tr>
			    <tr>
			        <td class="viewTh">단본(M)</td>
			        <td class="viewTh">하단(M)</td>
			        <td class="viewTh">중단1(M)</td>
			        <td class="viewTh">중단2(M)</td>
			        <td class="viewTh mid-group" style="display:none;">중단3(M)</td>
			        <td class="viewTh mid-group" style="display:none;">중단4(M)</td>
			        <td class="viewTh">상단(M)</td>
			    </tr>
			    <tr>
			        <td><input type="text" class="tdInput copy-input" id="copy_piOne" name="piece" /></td>
			        <td><input type="text" class="tdInput copy-input" id="copy_piTwo" name="piece" /></td>
			        <td><input type="text" class="tdInput copy-input" id="copy_piThree" name="piece" /></td>
			        <td><input type="text" class="tdInput copy-input" id="copy_piFour" name="piece" /></td>
			        <td class="mid-group" style="display:none;"><input type="text" class="tdInput copy-input" id="copy_piFive" name="piece" /></td>
			        <td class="mid-group" style="display:none;"><input type="text" class="tdInput copy-input" id="copy_piSix" name="piece" /></td>
			        <td><input type="text" class="tdInput copy-input" id="copy_piSeven" name="piece" /></td>
			    </tr>
			    <tr>
			        <td class="viewTh">합계(M)</td>
			        <td id="footer_total" colspan="2" style="text-align:center;"><label id="copy_totalConnectWidth">자동으로 생성됩니다.</label></td>
			        <td class="viewTh">이음(개소)</td>
			        <td id="footer_connect" colspan="3" style="text-align:center;"><label id="copy_connectLength">자동으로 생성됩니다.</label></td>
			    </tr>
			</table>
			<table class="signTable">
	            <tr><th colspan="7" style="background:#eee; padding:10px;">관입 및 측정 데이터</th></tr>
	            <tr>
	                <td class="viewTh">천공깊이</td><td class="viewTh">관입깊이</td><td class="viewTh">파일잔량</td><td class="viewTh">공삭공</td>
	                <td class="viewTh">해머무게</td><td class="viewTh">낙하높이</td><td class="viewTh">관리기준</td>
	            </tr>
	            <tr>
	                <td><input type="text" class="tdInput copy-input" id="copy_drillingDepth" name="drillingDepth" /></td>
	                <td><input type="text" class="tdInput copy-input" id="copy_intrusionDepth" name="intrusionDepth" /></td>
	                <td><input type="text" class="tdInput copy-input" id="copy_balance" /></td>
	                <td><input type="text" class="tdInput copy-input" id="copy_gongSac" /></td>
	                <td><input type="text" class="tdInput copy-input" id="copy_hammaT" name="hammaT" /></td>
	                <td><input type="text" class="tdInput copy-input" id="copy_fallMeter" name="fallMeter" /></td>
	                <td><input type="text" class="tdInput copy-input" id="copy_managedStandard" name="managedStandard" /></td>
	            </tr>
			</table>
	            
			<table class="signTable">
	            <tr>
				    <td class="viewTh" style="width:20%">1회(mm)</td>
				    <td class="viewTh" style="width:20%">2회(mm)</td>
				    <td class="viewTh" style="width:20%">3회(mm)</td>
				    <td class="viewTh" style="width:20%">4회(mm)</td>
				    <td class="viewTh" style="width:20%">5회(mm)</td>
				</tr>
				<tr>
				    <td><input type="text" class="tdInput copy-input" id="copy_meas1" name="penetrations" data-idx="0" /></td>
				    <td><input type="text" class="tdInput copy-input" id="copy_meas2" name="penetrations" data-idx="1" /></td>
				    <td><input type="text" class="tdInput copy-input" id="copy_meas3" name="penetrations" data-idx="2" /></td>
				    <td><input type="text" class="tdInput copy-input" id="copy_meas4" name="penetrations" data-idx="3" /></td>
				    <td><input type="text" class="tdInput copy-input" id="copy_meas5" name="penetrations" data-idx="4" /></td>
				</tr>
				
				<tr class="meas-big-group" style="display:none;">
				    <td class="viewTh" style="width:20%">6회(mm)</td>
				    <td class="viewTh" style="width:20%">7회(mm)</td>
				    <td class="viewTh" style="width:20%">8회(mm)</td>
				    <td class="viewTh" style="width:20%">9회(mm)</td>
				    <td class="viewTh" style="width:20%">10회(mm)</td>
				</tr>
				<tr class="meas-big-group" style="display:none;">
				    <td><input type="text" class="tdInput copy-input" id="copy_meas6" name="penetrations" data-idx="5" /></td>
				    <td><input type="text" class="tdInput copy-input" id="copy_meas7" name="penetrations" data-idx="6" /></td>
				    <td><input type="text" class="tdInput copy-input" id="copy_meas8" name="penetrations" data-idx="7" /></td>
				    <td><input type="text" class="tdInput copy-input" id="copy_meas9" name="penetrations" data-idx="8" /></td>
				    <td><input type="text" class="tdInput copy-input" id="copy_meas10" name="penetrations" data-idx="9" /></td>
				</tr>
				</table>
				<table class="signTable">
	            <tr>
	                <td class="viewTh" style="width:20%">평균관입</td><td style="width:30%"><label for="copy_avgPenetrationValue">자동으로 생성됩니다.</label></td>
	                <td class="viewTh" style="width:20%">최종관입</td><td style="width:30%"><label for="copy_totalPenetrationValue">자동으로 생성됩니다.</label></td>
	            </tr>
	            <tr>
	                <td class="viewTh" style="width:20%">극한지지력</td><td style="width:30%"><input type="text" class="tdInput copy-input" id="copy_ultimateBearingCapacity" name="ultimateBearingCapacity" /></td>
	                <td class="viewTh" style="width:20%">해머효율</td><td style="width:30%"><input type="text" class="tdInput copy-input" id="copy_hammaEfficiency" name="hammaEfficiency" /></td>
	            </tr>
	            <tr>
	                <td class="viewTh" style="width:20%">탄성계수</td><td style="width:30%"><input type="text" class="tdInput copy-input" id="copy_modulusElasticity" name="modulusElasticity" /></td>
	                <td class="viewTh" style="width:20%">단면적</td><td style="width:30%"><input type="text" class="tdInput copy-input" id="copy_crossSection" name="crossSection" /></td>
	            </tr>
	            <tr>
	                <td class="viewTh">메모</td><td colspan="6"><input type="text" class="tdInput copy-input" id="copy_sprCol1" name="sprCol1" /></td>
	            </tr>
	            <tr>
	                <td class="viewTh">비고</td><td colspan="6"><input type="text" class="tdInput copy-input" id="copy_bigo" name="bigo" /></td>
	            </tr>
	        </table>
	        <!-- <div onclick="javascript:submitReport('copy');" style="margin-top:20px; background:#077b9c; color:#fff; text-align:center; padding:15px; cursor:pointer; font-weight:bold;">수정 데이터 저장 및 복사</div> -->
	        <div id="saveBtn" onclick="javascript:submitReport('copy');" style="margin-top:20px; background:#077b9c; color:#fff; text-align:center; padding:15px; cursor:pointer; font-weight:bold;">저장</div>
	    </div>
	</div>
	
	<div class="popUp popUp05">
		<div class="popTit">
			<p>시공일 수정</p>
			<img class="popClose" src="${pageContext.request.contextPath}/new/img/popclose.png" onclick="closeDateUpdatePopup();" style="cursor:pointer;" />
		</div>
	
		<div class="popCont" >
			<table class="signTable" >
				<colgroup>
					<col width="40%">
					<col width="60%">
				</colgroup>
				<tr>
					<th class="viewTh">현재 시공일</th>
					<td id="popDate_currentDate" style="text-align: center;"></td>
				</tr>
				<tr>
					<th class="viewTh">변경할 시공일</th>
					<td style="padding: 7px !important;">
						<input type="hidden" id="popDate_reportId" value="" />
						<input type="text" id="popDate_newDate" class="tdInput" style="border: 1px solid #ccc !important; border-radius: 4px; width:100% !important; height: 50px; font-weight: bold; font-size:16px; text-align: center; background: #fff; box-sizing: border-box; outline-color: #00adef;" />
					</td>
				</tr>
			</table>
			<div onclick="javascript:submitDateUpdate();" style="margin-top: 30px; background: #077b9c; color: #fff; text-align: center; padding: 12px; cursor: pointer; font-weight: bold;">수정</div>
		</div>
	</div>
	
	<div class="popUp popUp06">
		<div class="popTit">
			<p>기록지 호기 수정/이전</p>
			<img class="popClose" src="${pageContext.request.contextPath}/new/img/popclose.png" onclick="closeDeviceChangePopup();" style="cursor:pointer;" />
		</div>
		<div class="popCont">
			<div style="background: #f8f9fa; padding: 10px 15px; border: 1px solid #e2e8f0; border-radius: 6px; margin-bottom: 10px; display: flex; flex-wrap: wrap; gap: 10px; align-items: center;">
				<div style="display: flex; gap: 6px; margin-left: auto;">
					<select id="popDevice_bulkDevice" class="row-device-select" style="width: 150px !important; height: 32px;" onchange="applyBulkDevice(this.value);">
						<option value="">-- 호기 일괄 선택 --</option>
					</select>
				</div>
			</div>
			<div class="table-scroll-area">
				<table class="signTable" style="margin: 0; width: 100% !important;">
					<colgroup>
						<col width="35%">
						<col width="25%">
						<col width="40%">
					</colgroup>
					<thead>
						<tr class="viewTh" style="position: sticky; top: 0; z-index: 10;">
							<th>기존 호기 / 시공일</th>
							<th>해당 현장 호기 목록</th>
							<th>년-월-일 시간</th>
						</tr>
					</thead>
					<tbody id="popDevice_tbody"></tbody>
				</table>
			</div>
			<div onclick="javascript:submitDeviceChange();" style="margin-top: 20px; background:#077b9c; color:#fff; text-align: center; padding: 14px; cursor: pointer; font-weight: bold; font-size: 16px; border-radius: 6px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">개별 이전 및 수정 저장</div>
		</div>
	</div>
	
	<div id="drivingRecordOverlay" style="display:none;"></div>

		<div id="drivingRecordPopup" style="display:none;">
		    <div class="popup-title">현재 파일항타 기록지 PDF</div>
		
		    <div class="popup-content">
		        <label>
		            <input type="radio" name="hitOption" value="N" checked>
	            		타격횟수 미포함
		        </label>
		        <br>
		        <label>
		            <input type="radio" name="hitOption" value="Y">
		           		 타격횟수 포함
		        </label>
		    </div>
		
		    <div class="popup-footer">
		        <button type="button" onclick="closeDrivingRecordPopup()">닫기</button>
		        <button type="button" onclick="confirmDrivingRecordDownload()">PDF 생성</button>
		    </div>
	</div>
	
	<div class="popLayer"></div>								
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
	
	$('#pdfSignRoomSetting').on('click', function(e){
		$('.popUp02').show();
		$('.popLayer').show();
		$('body').css('overflow', 'hidden');
	});
	
	$('#excelSignRoomSetting').on('click', function(e){
		$('.popUp03').show();
		$('.popLayer').show();
		$('body').css('overflow', 'hidden');
	});
	
	$('.popClose').on('click', function(e){
		$('.popUp').hide();
		$('.popLayer').hide();
		$('body').css('overflow', 'auto');
	});

	function onClickExcelSignRoom(){
		$('.popUp03').show();
		$('.popLayer').show();
		$('body').css('overflow', 'hidden');
	}

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
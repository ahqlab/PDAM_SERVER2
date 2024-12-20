<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/tagLib.jsp" %>

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
});
	
	
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
				$('#constructionName').val(data);
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
		var isBig = ${isBig};
		
		var currentNo;
		var currentDate;
		var currentPileType;
		var currentMethod;
		var currentLocation;
		var currentPileNo;
		var currentPileStandard;
		var currentPileSum;
	
		var currentDrillingDepth;
		var currentIntrusionDepth;
		var currentBalance;
		var currentGongSac;
		var currentHammaT;
		var currentFallMeter;
		var currentManagedStandard;
		var currentAvgPenetrationValue;
		var currentTotalPenetrationValue;
		
		
		if(role == 0 || hiddenManager == true || role == 0 ){
			currentNo = $('#reportTable tr').eq(index).find('td:eq(1)').text().trim();
			currentDate = $('#reportTable tr').eq(index).find('td:eq(2)').text().trim();
			currentPileType = $('#reportTable tr').eq(index).find('#pileType').val();
			currentMethod = $('#reportTable tr').eq(index).find('#method').val();
			currentLocation = $('#reportTable tr').eq(index).find('#location').val();
			currentPileNo = $('#reportTable tr').eq(index).find('#pileNo').val();
			currentPileStandard = $('#reportTable tr').eq(index).find('#pileStandard').val().trim();
			currentPileSum = $('#reportTable tr').eq(index).find('td:eq(13)').text().trim();
		
			currentDrillingDepth = $('#reportTable tr').eq(index).find('#drillingDepth').val();
			currentIntrusionDepth = $('#reportTable tr').eq(index).find('#intrusionDepth').val();
			currentBalance = $('#reportTable tr').eq(index).find('td:eq(17)').text().trim();
			currentGongSac = $('#reportTable tr').eq(index).find('td:eq(18)').text().trim();
			currentHammaT =  $('#reportTable tr').eq(index).find('#hammaT').val();
			currentFallMeter =  $('#reportTable tr').eq(index).find('#fallMeter').val();
			currentManagedStandard =  $('#reportTable tr').eq(index).find('#managedStandard').val();
			if(isBig > 0){
				currentAvgPenetrationValue = $('#reportTable tr').eq(index).find('td:eq(32)').text().trim();
				currentTotalPenetrationValue = $('#reportTable tr').eq(index).find('td:eq(33)').text().trim();
			}else{
				currentAvgPenetrationValue = $('#reportTable tr').eq(index).find('td:eq(27)').text().trim();
				currentTotalPenetrationValue = $('#reportTable tr').eq(index).find('td:eq(28)').text().trim();
			}
			
			
		}else{
			
			currentNo = $('#reportTable tr').eq(index).find('td:eq(0)').text().trim();
			currentDate = $('#reportTable tr').eq(index).find('td:eq(1)').text().trim();
			currentPileType = $('#reportTable tr').eq(index).find('#pileType').val();
			currentMethod = $('#reportTable tr').eq(index).find('#method').val();
			currentLocation = $('#reportTable tr').eq(index).find('#location').val();
			currentPileNo = $('#reportTable tr').eq(index).find('#pileNo').val();
			currentPileStandard = $('#reportTable tr').eq(index).find('#pileStandard').val().trim();
			currentPileSum = $('#reportTable tr').eq(index).find('td:eq(12)').text().trim();
		
			currentDrillingDepth = $('#reportTable tr').eq(index).find('#drillingDepth').val();
			currentIntrusionDepth = $('#reportTable tr').eq(index).find('#intrusionDepth').val();
			currentBalance = $('#reportTable tr').eq(index).find('td:eq(16)').text().trim();
			currentGongSac = $('#reportTable tr').eq(index).find('td:eq(17)').text().trim();
			currentHammaT =  $('#reportTable tr').eq(index).find('#hammaT').val();
			currentFallMeter =  $('#reportTable tr').eq(index).find('#fallMeter').val();
			currentManagedStandard =  $('#reportTable tr').eq(index).find('#managedStandard').val();
			
			if(isBig > 0){
				currentAvgPenetrationValue = $('#reportTable tr').eq(index).find('td:eq(31)').text().trim();
				currentTotalPenetrationValue = $('#reportTable tr').eq(index).find('td:eq(32)').text().trim();
			}else{
				currentAvgPenetrationValue = $('#reportTable tr').eq(index).find('td:eq(26)').text().trim();
				currentTotalPenetrationValue = $('#reportTable tr').eq(index).find('td:eq(27)').text().trim();
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
		
		$('#curDrillingDepth').text(currentDrillingDepth);
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
		
		$('#mCurDrillingDepth').text(currentDrillingDepth);
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
		  showPdf(index, ${sessionInfo.role}, ${sessionInfo.hiddenManager}, ${isBig});
		
	}
	
	function getPieceNameByIndex(index){
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
						name: getPieceNameByIndex(j), //수정
						value : piece[j].value != "" ? 	piece[j].value : "0",
						id : Number(pieceId[j].value) != Number(0) ? Number(pieceId[j].value) : Number(0),
						reportIdx :Number($('#reportTable tr').eq(i).find('#id').val())
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
		var constructionIdx = ${sessionInfo.constructionIdx};
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
				drillingDepth[index].disabled = false;
				intrusionDepth[index].disabled = false;
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
				drillingDepth[index].disabled = true;
				intrusionDepth[index].disabled = true;
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
	
</script>
<!--컨텐츠-->
<div class="section-right" >
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
						<div class="tableCArea">
							<c:choose>												 
								<c:when test="${sessionInfo.role == 0 || sessionInfo.hiddenManager == true || sessionInfo.role == 3}">
									<div class="btnType02 bg02" onclick="javascript:onClickExcelSignRoom();"   style="width: 210px; margin-bottom : 5px; background: #FFD400; color:#000000; border: 1px solid #258348;">EXCEL 결재방 설정</div>
								</c:when>
								<c:otherwise>
									<div class="btnType02 bg02" onclick="javascript:onClickExcelSignRoom();" style="width: 210px; margin-bottom : 5px; background: #FFD400; color:#000000; border: 1px solid #258348;">EXCEL 결재방 설정</div>
								</c:otherwise>
							</c:choose>
						</div>
						<div class="tableCArea">
							<c:choose>												 
								<c:when test="${sessionInfo.role == 0 || sessionInfo.hiddenManager == true || sessionInfo.role == 3}">
									<div class="btnType02 bg02" onclick="javascript:downloadExcel();">엑셀 출력</div>
									<div class="btnType01" onclick="javascript:onClickReportUpdate();">기록지 수정</div>
								</c:when>
								<c:otherwise>
									<div class="btnType02 bg02" onclick="javascript:downloadExcel();">엑셀 출력</div>
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
						<div class="tableCArea" style="margin-bottom: 0px;">
							<c:choose>												 
								<c:when test="${sessionInfo.role == 0 || sessionInfo.hiddenManager == true || sessionInfo.role == 3}">
									<div class="btnType02 bg02" id="excelSignRoomSetting" style="float: right; width: 130px; margin-bottom : 5px; background: #FFD400; color:#000000; border: 1px solid #258348;">EXCEL 결재방 설정</div>
								</c:when>
								<c:otherwise>
									<div class="btnType02 bg02" id="excelSignRoomSetting" style="float: right; width: 130px; margin-bottom : 5px; background: #FFD400; color:#000000; border: 1px solid #258348;">EXCEL 결재방 설정</div>
								</c:otherwise>
							</c:choose>
						</div>
						<div class="tableCArea">
							<c:choose>												 
								<c:when test="${sessionInfo.role == 0 || sessionInfo.hiddenManager == true || sessionInfo.role == 3}">
									<div class="btnType02 bg02" onclick="javascript:downloadExcel();">엑셀 출력</div>
									<div class="btnType01" onclick="javascript:onClickReportUpdate();">기록지 수정</div>
								</c:when>
								<c:otherwise>
									<div class="btnType02 bg02" onclick="javascript:downloadExcel();" style="float: right;">엑셀 출력</div>
									<!-- <div class="btnType01" onclick="javascript:onClickReportUpdate();" style="display: none;">기록지 수정</div> -->
								</c:otherwise>
							</c:choose>
						</div>
					</td>
				</tr>
			</table>
		
	<div class="min485">
		<div class="tableArea">
			
			<div class="viewTable viewTable05">
				<table class="viewTh">
					<tr>
						<c:choose>
							<c:when test="${sessionInfo.role == 0  || sessionInfo.hiddenManager == true  || sessionInfo.role == 3}">
								<td rowspan="2">
									<input type="checkbox" id="chkAll" name="chkAll" onclick="javascript:onClickChkAll();">
								</td>
							</c:when>
						</c:choose>
						<td rowspan="2">순번</td>
						<td rowspan="2" style="width: 100px;">시공일</td>
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
									<c:when test="${sessionInfo.hiddenManager == true and ubcYn == 1}">
										<td rowspan="2">극한지지력<br>(kN)</td>
										<td rowspan="2">해머효율(%)</td>
										<td rowspan="2">탄성계수(t/cm2)</td>
										<td rowspan="2">파일단면적(cm2)</td>
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
					<table id="reportTable" name="reportTable">
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
																	<tr class="lampOn-l" onclick="javascript:onRowClick(${status.index});" style="background-color: #F0DDA4;">
																</c:when>
																<c:otherwise>
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
							<td>${domain.rownum}</td>
							<td  style="width: 100px;">
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
											<c:when test="${sessionInfo.hiddenManager == true and domain.longCalYn == 1}">
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
													<c:when test="${sessionInfo.constructionIdx == 657 or sessionInfo.constructionIdx ==  169 or sessionInfo.constructionIdx ==  170}">
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
								<input type="hidden" id="pieceName[${status.index}]" name="pieceName[${status.index}]" value="상단">
							</td>
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
							
							<td>${domain.balance}</td>
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
										${domain.gongSac}
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
												<c:when test="${domain.peOne >= domain.managedStandard}">
													<td style="background-color: red;">
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
												<c:when test="${domain.peTwo >= domain.managedStandard}">
													<td style="background-color: red;">
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
												<c:when test="${domain.peThree >= domain.managedStandard}">
													<td style="background-color: red;">
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
												<c:when test="${domain.peFour >= domain.managedStandard}">
													<td style="background-color: red;">
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
												<c:when test="${domain.peFive >= domain.managedStandard}">
													<td style="background-color: red;">
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
												<c:when test="${domain.peSix >= domain.managedStandard}">
													<td style="background-color: red;">
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
												<c:when test="${domain.peSeven >= domain.managedStandard}">
													<td style="background-color: red;">
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
												<c:when test="${domain.peEight >= domain.managedStandard}">
													<td style="background-color: red;">
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
												<c:when test="${domain.peNine >= domain.managedStandard}">
													<td style="background-color: red;">
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
												<c:when test="${domain.peTen >= domain.managedStandard}">
													<td style="background-color: red;">
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
												<c:when test="${domain.peOne >= domain.managedStandard}">
													<td style="background-color: red;">
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
												<c:when test="${domain.peTwo >= domain.managedStandard}">
													<td style="background-color: red;">
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
												<c:when test="${domain.peThree >= domain.managedStandard}">
													<td style="background-color: red;">
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
												<c:when test="${domain.peFour >= domain.managedStandard}">
													<td style="background-color: red;">
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
												<c:when test="${domain.peFive >= domain.managedStandard}">
													<td style="background-color: red;">
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
							
							<!-- <c:forEach var="i" begin="0" end="${isBig > 0 ? 9 : 4}">
								<c:choose>
									<c:when test="${sessionInfo.role == 0}">
										<td>
											<input type="text" id="penetrations[${status.index}]" name="penetrations[${status.index}]" disabled="disabled"  class="tdInput" value="${domain.penetrations[i].value eq '0' ? '' : domain.penetrations[i].value}">
											<input type="hidden" id="penetrationsId[${status.index}]" name="penetrationsId[${status.index}]" value="${domain.penetrations[i].id}">
											<c:choose>
												<c:when test="${domain.penetrations[i].name != null}">
													<input type="hidden" id="penetrationsName[${status.index}]" name="penetrationsName[${status.index}]" value="${domain.penetrations[i].name}">	
												</c:when>
												<c:otherwise>
													<c:choose>
														<c:when test="${isBig > 0}">
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
										<c:choose>
											<c:when test="${sessionInfo.constructionIdx == 645}">
												<td  style="display:none;">
													${domain.penetrations[i].value}
												</td> 
											</c:when>
											<c:otherwise>
												<td>
													${domain.penetrations[i].value}
												</td> 
											</c:otherwise>
										</c:choose>
										<input type="hidden" id="penetrations[${status.index}]" name="penetrations[${status.index}]" disabled="disabled"  class="tdInput" value="${domain.penetrations[i].value eq '0' ? '' : domain.penetrations[i].value}">
									</c:otherwise>
								</c:choose>											
							</c:forEach> -->
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
										<c:when test="${sessionInfo.hiddenManager == true and ubcYn == 1}">
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
						<div class="btnType02" id="pdfBtn" style="width: 200px;  background: #258348; border: 1px solid #258348;">현재 파일 항타기록지 PDF</div>
						<div class="btnType02" id="pdfSignRoomSetting" style="width: 200px; margin-top:10px; background: #FFD400; color:#000000; border: 1px solid #258348;">PDF 결재방 설정</div>
						<!-- <div class="btnType02" id="pdfSignRoomSetting" style="width: 200px; margin-top:10px; background: #760A2D; border: 1px solid #258348;">PDF 결재방 설정</div> -->
					</div>
				</c:when>
				<c:when test="${sessionInfo.role == 1}">  <!-- 협력사 -->
					<c:choose>
						<c:when test="${ sessionInfo.showPdfYn == true}">
							<div class="tableCArea">
								<div class="btnType02" onclick="javascript:onClickReportUpdate();" style="visibility: hidden;"></div>
								<div class="btnType02" id="pdfBtn" style="width: 200px;  background: #258348; border: 1px solid #258348;">현재 파일 항타기록지 PDF</div>
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
										<div class="btnType02" id="pdfBtn" style="width: 200px;  background: #258348; border: 1px solid #258348;">현재 파일 항타기록지 PDF</div>
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
								<div class="btnType02" id="pdfBtn" style="width: 200px;  background: #258348; border: 1px solid #258348;">현재 파일 항타기록지 PDF</div>
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
								<div class="btnType02" id="pdfBtn" style="width: 200px;  background: #258348; border: 1px solid #258348;">현재 파일 항타기록지 PDF</div>
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
						<c:when test="${sessionInfo.constructionIdx == 944 or param.constructionIdx == 944}">
							<td class="sumGrpTbTh">경타<br>길이</td>
							<td class="sumGrpTbTh">천공<br>깊이</td>
						</c:when>
						<c:otherwise>
							<td class="sumGrpTbTh">천공<br>깊이</td>
							<td class="sumGrpTbTh">관입<br>깊이</td>
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
						<c:when test="${sessionInfo.constructionIdx == 944 or param.constructionIdx == 944}">
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
						<c:when test="${sessionInfo.constructionIdx == 944 or param.constructionIdx == 944}">
							<td class="sumGrpTbTh">천공<br>깊이</td>
						</c:when>
						<c:otherwise>
							<td class="sumGrpTbTh">관입<br>깊이</td>
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

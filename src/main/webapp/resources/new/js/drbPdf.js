

function drawLegend(doc){
	var pageWidth = doc.internal.pageSize.width || doc.internal.pageSize.getWidth();
	var lectLeftPadding = 15;
	doc.setFontSize(8);
	doc.setFillColor(0,173,239);
	doc.rect(15, 92.8 + 5, 10, 4, 'FD'); //Fill and Border
    doc.text('관입량', 27 , 95.5 + 5, {align: 'left'});
    
    //doc.setFillColor(63,232,108);
    doc.setFillColor(0,153,0);
	doc.rect(41.5, 92.8 + 5, 10, 4, 'FD'); //Fill and Border
    doc.text('관입량의 차', 53.5 , 95.5 + 5, {align: 'left'});
    
    doc.text('( 단위 / mm )', pageWidth - lectLeftPadding , 96 + 5, {align: 'right'});
}

function writeValue(penetrations , pointArr, doc, index){
	var penetrationsSum = 0;
	for(var i=0; i<pointArr.length; i++){
		var x = Number(pointArr[i][0]);
		var y = Number(pointArr[i][1]) - 2.5;
		var value = penetrations[i] != "" ? Number(penetrations[i]) : Number(0);
		penetrationsSum = penetrationsSum + value;
		
		if(i > 0){
			//doc.setTextColor(63,232,108);
			doc.setTextColor(0,153,0);
			doc.text(x, y, ' ' +   value.toFixed(1) + '', {align: 'left'});
			doc.setTextColor(0,0,0);
			doc.text(x, y,  ' , ', {align: 'center'});
			doc.setTextColor(0,173,239);
			doc.text(x, y,  penetrationsSum.toFixed(1) + ' ', {align: 'right'});
		}else{
			doc.setTextColor(0,173,239);
			doc.text(x, y,  value.toFixed(1), {align: 'center'});
		}
	}
	doc.setTextColor(null);
}


function yAxisLevel(currentAvgPenetrationValue){
	//alert();
	if(currentAvgPenetrationValue == 0){
		return 0.2;
	}else if(currentAvgPenetrationValue == 0.1){
		return 0.1;
	}else if(currentAvgPenetrationValue == 0.2){
		return 0.2;
	}else if(currentAvgPenetrationValue == 0.3){
		return 0.3;
	}else if(currentAvgPenetrationValue >= 0.4 && currentAvgPenetrationValue <= 0.7){
		return 0.5;
	}else{
		return 1;
	}
}


//그래프를 그린다.
function drawChart(root, index, item, pageWidth, pageHeight, doc, currentAvgPenetrationValue , currentTotalPenetrationValue, constructionIdx){
	
	//var mode = 'center';
	var mode = 'bottom';
	
	var lectLeftPadding = 15;
	var lectBottomPadding = 40;
	var lectStartY = 0;
	var lectTopY = 100 + 4; //테이블 한줄 추가로 +5처리
	var lectHarfSize = 80;
	if(mode == 'center'){
		lectStartY = 95;
	}else if(mode == 'bottom'){
		lectStartY = pageHeight - lectBottomPadding;
	}
	var lectEndHeight = pageHeight - lectBottomPadding;
	var lectCenterHeight = lectStartY + ((lectEndHeight - lectStartY) / 2);
	var lectRightX = pageWidth - lectLeftPadding;
	var upLevel = 0;
	var upCount = 0;
	var j = 0;
	var k = 0;
	
	
	//새로 추가
	doc.setDrawColor(0,0,0);
	//그래프 영역 가로라인
	doc.line(lectLeftPadding, lectTopY, pageWidth - lectLeftPadding, lectTopY); // 선그리기(시작x, 시작y, 종료x, 종료y)
	doc.line(lectLeftPadding, pageHeight - lectBottomPadding, pageWidth - lectLeftPadding, pageHeight - lectBottomPadding); // 선그리기(시작x, 시작y, 종료x, 종료y)
	//그래프 영역 세로라인
	doc.line(lectLeftPadding, lectTopY, lectLeftPadding, pageHeight - lectBottomPadding); // 선그리기(시작x, 시작y, 종료x, 종료y)
	doc.line(pageWidth - lectLeftPadding, lectTopY, pageWidth - lectLeftPadding, pageHeight - lectBottomPadding); // 선그리기(시작x, 시작y, 종료x, 종료y)
	
	//0점 잡는다.
	doc.setFontSize(10);
	doc.text('0', lectLeftPadding - 2, lectCenterHeight + 1, {align: 'right'});
	//새로 추가
	doc.setDrawColor(null);
	
	if(Number(currentAvgPenetrationValue) < 1){
		//소수점
		j = yAxisLevel(currentAvgPenetrationValue);
		k = Number(j);
	}else if(Number(currentAvgPenetrationValue) > 1000){
		//10자리 
		j = Math.round(Number(currentAvgPenetrationValue) / 1000) * 1000;
		k = Number(j);
	}else if(Number(currentAvgPenetrationValue) > 100){
		//10자리 
		j = Math.round(Number(currentAvgPenetrationValue) / 100) * 100;
		k = Number(j);
	}else if(Number(currentAvgPenetrationValue) > 10){
		//10자리 
		j = Math.round(Number(currentAvgPenetrationValue) / 10) * 10;
		k = Number(j);
	}else{
		//1자리
		j = Math.round(Number(currentAvgPenetrationValue)).toFixed();
		k = Number(j);
	}
	upCount = k;
	//줄간격을 계산한다.
	if((k * 3) > currentTotalPenetrationValue){
		upLevel = 20;
	}else if((k * 5) > currentTotalPenetrationValue){
		upLevel = 20;
	}else if((k * 7) > currentTotalPenetrationValue){
		upLevel = 15;
	}else {
		upLevel = 10;
	}
	//가로라인 그린다.
	for(var i = upLevel; i < (mode == 'center' ? lectHarfSize : lectHarfSize * 2); i = i + upLevel){
		doc.line(lectLeftPadding, lectCenterHeight - i, lectRightX, lectCenterHeight - i);
		doc.text(k.toString(), lectLeftPadding - 2, (lectCenterHeight - i) + 1, {align: 'right'});
		var ss = Number(k) +  Number(j);
		if(Number(currentAvgPenetrationValue) < 1){
			k = ss.toFixed(1);
		}else{
			k = ss.toFixed();
		}
	}
	
	var numberOne = upLevel / upCount;
		
    var penetrations = new Array();    //배열 선언
    penetrations.push(item.peOne);
    penetrations.push(item.peTwo); 
    penetrations.push(item.peThree); 
    penetrations.push(item.peFour); 
    penetrations.push(item.peFive);
    
    console.log('item.peSix : ' + item.peSix + 'item.peSeven : ' + item.peSeven + 'item.peEight : ' + item.peEight + 'item.peNine : ' + item.peNine + 'item.peTen : ' + item.peTen);
    
    if(item.peSix != null && item.peSeven != null && item.peEight != null && item.peNine != null && item.peTen != null){
    	penetrations.push(item.peSix);
    	penetrations.push(item.peSeven);
	    penetrations.push(item.peEight);
    	penetrations.push(item.peNine);
	    penetrations.push(item.peTen);
    }
		
	var arrValues = new Array();    //배열 선언
	var sum = 0;
	var verticalGap = (pageWidth - 30) / Number(penetrations.length + 1);
	var pointArr = [];
	for(var i=0; i<penetrations.length; i++){
		
		var value = penetrations[i] != "" ? Number(penetrations[i]) : Number(0);
		sum = sum + value;
		var Rvalue = numberOne * sum;
		var Hvalue = lectCenterHeight.toFixed();
		var cal = (Hvalue - Rvalue);
	
	
		//점찍기
		if(i < penetrations.length){
			//좌표 2단 배열
			var pointInArr = [];
			
			var x = 15 + (verticalGap * (i + 1)) ;
			var y = cal;
			pointInArr.push(x);
			pointInArr.push(y);
			
			doc.setLineWidth(null);
			doc.setFillColor(0,173,239);
			doc.circle(x, y, 1, 'F');	
			//좌표점을 배열로 저장한다.
			pointArr.push(pointInArr);

		}
		
		
		doc.setLineWidth(null); 
		//세로 라인
		doc.line(lectLeftPadding + (verticalGap * (i + 1)), lectTopY, lectLeftPadding + (verticalGap * (i + 1)), lectStartY);
		//하단 측정 횟수 
		console.log( penetrations.length );
		if( penetrations.length > 5){
			doc.setFontSize(8);
		}else{
			doc.setFontSize(9);
		}
		
		doc.text(Number(i + 1) + '회 측정', lectLeftPadding + (verticalGap * (i + 1)), lectStartY + 5 , {align: 'center'});
	}
	
	
	if(constructionIdx != 738){
		jQuery.ajax({
			type : "POST",
			url : root + "/signroom/get/order/list",
			data: { 
				constructionIdx : constructionIdx			
			}, 
			dataType : "JSON", // 옵션이므로 JSON으로 받을게 아니면 안써도 됨
			async : false,
			success : function(data) {
				
				var signRoomStartX = 75;
				var signRoomTopY = 12;
				var signRoomBottomY = 22;
				
				if(data.length > 0){
					
					var roomOneWidth = 44;
					
					var endXSum = 0;
					$.each(data, function(index, item) {
						
						if(constructionIdx == 969){
							roomOneWidth = 60;
						}else{
							roomOneWidth = 44;
						}
						
						
						var end = (pageWidth - 15) - (roomOneWidth * (index + 1));
						endXSum = end;
					});
					
					//세로
					doc.line(endXSum, 
							pageHeight - signRoomTopY, 
							endXSum, 
							pageHeight - signRoomBottomY);
					
					$.each(data, function(index, item) {
						
						if(constructionIdx == 969){
							roomOneWidth = 60;
						}else{
							roomOneWidth = 44;
						}
						
						var x = (pageWidth - 15) - (roomOneWidth * index);
						var end = (pageWidth - 15) - (roomOneWidth * (index + 1));
						
						//가로위
						doc.line(x, 
								pageHeight - signRoomTopY, 
								end,
								pageHeight - signRoomTopY);
						//가로아래
						doc.line(x, 
								pageHeight - signRoomBottomY, 
								end,
								pageHeight - signRoomBottomY);
						//세로
						doc.line(x, 
								pageHeight - signRoomTopY, 
								x, 
								pageHeight - signRoomBottomY);
						
						//세로 칸의 중간
						doc.line(x - (roomOneWidth / 2), 
								pageHeight - signRoomTopY, 
								x -  (roomOneWidth / 2), 
								pageHeight - signRoomBottomY);
						
						
						doc.text(item.approver , x - ( (roomOneWidth / 2) + (roomOneWidth/4)), pageHeight - 16, {align: 'center'});
						
						
					});
					
					
				}else{
					//결재방시작
					/**
					var signRoomStartX = 75;
					var signRoomTopY = 12;
					var signRoomBottomY = 22;
					//가로
					doc.line( signRoomStartX , pageHeight - signRoomTopY , pageWidth - 15, pageHeight - signRoomTopY);
					doc.line( signRoomStartX , pageHeight - signRoomBottomY , pageWidth - 15, pageHeight - signRoomBottomY);
					
					//세로
					doc.line( signRoomStartX, pageHeight - signRoomTopY , signRoomStartX, pageHeight - signRoomBottomY);
					for(var i = 1; i <= 4; i++){
						doc.line( signRoomStartX  + (i*30) , pageHeight - signRoomTopY , signRoomStartX   + (i*30), pageHeight - signRoomBottomY);
					}
					
					//doc.line( signRoomStartX  + 60 , pageHeight - signRoomTopY , signRoomStartX   + 60, pageHeight - signRoomBottomY);
					//doc.line( signRoomStartX  + 90 , pageHeight - signRoomTopY , signRoomStartX   + 90, pageHeight - signRoomBottomY);
					//doc.line( signRoomStartX  + 120 , pageHeight - signRoomTopY , signRoomStartX   + 120, pageHeight - signRoomBottomY);
					doc.setFontSize(10);
					doc.text('시공사', signRoomStartX  + 15, pageHeight - 16, {align: 'center'});
					doc.text('감리단', signRoomStartX  + 60 + 15, pageHeight - 16, {align: 'center'});
					**/
	
				}
			},
			complete : function(data) {
			},
			error : function(xhr, status, error) {
			}
		});
		
		
	
	}
	
	//실제 그래프를 그린다.
	doc.setLineWidth(1); 
	for(var i=0; i<pointArr.length; i++){
		
		if(i < pointArr.length - 1){
			doc.setDrawColor(0,173,239);
			doc.line(pointArr[i][0], pointArr[i][1], pointArr[Number(i + 1)][0], pointArr[i][1]);
			doc.line(pointArr[Number(i + 1)][0], pointArr[i][1] , pointArr[Number(i + 1)][0], pointArr[Number(i + 1)][1]);
		}
	}
	
	//값의 숫자를 쓴다.
	writeValue(penetrations, pointArr, doc, index);
	
}

function createFileName(){
	
	var date = new Date; // Date 객체
	return '파일 항타기록지_' + date.getFullYear() + '' + (date.getMonth() + 1) + '' + date.getDate() + '' + date.getHours() + '' + date.getMinutes() + '' + date.getSeconds();
	
}


function getBalance1082(item){
	var totalConnectWidth = Number(item.totalConnectWidth);
	var drillingDepth = Number(item.drillingDepth);
	var sdDrillingDepth = Number(item.sdDrillingDepth);
	var stDrillingDepth = Number(item.stDrillingDepth);
	var intrusionDepth = Number(item.intrusionDepth);
	var total =  totalConnectWidth - drillingDepth - sdDrillingDepth - intrusionDepth;
	return total.toFixed(1);
	
	
}

function balanceFixExp1082(balance) {
	  
  if(balance < 0){
	return 0;
  }else{
	return balance;
  }
}

function gongSacFixExp1082(balance) {
	  
  if(balance < 0){
	return balance;
  }else{
	return 0;
  }
}


function gongSacFixExp(balance, gongSac, constructionIdx){
	if(constructionIdx == 783){
		if(balance > 0 && gongSac == 0){
			return gongSac;
		}else{
			gongSac = Number(gongSac) + Number(-0.3);
			return gongSac;
		}
	}else{
		return gongSac;
	}
}

function downloadDrivingRecoredBook(root, constructionIdx, machineNumber, currentDateTime){
	
	if(confirm("일일 기록지를 출력하시겠습니까?")){
		jQuery.ajax({
			type : "POST",
			url : root + "/report/today/list",
			data: { 
				constructionIdx : constructionIdx,
				machineNumber : machineNumber,
				currentDateTime : currentDateTime
			}, 
			dataType : "JSON", // 옵션이므로 JSON으로 받을게 아니면 안써도 됨
			success : function(data) {
				if(data.length > 0){//
					
					var doc = new jspdf.jsPDF("p", "mm", "a4");  //이렇게 바꾸어 줍니다!!!! 
				   
					$.each(data, function(index, item) {
						var constructionName = item.name;
						if(constructionIdx == '815'){
					    	constructionName = constructionName.replace("두산에너빌리티 선일산업", "").trim();
					    }
						var machineNumber = item.machineNumber
						var currentDate = item.currentDateTime;
						var currentPileType = item.pileType;
						var currentMethod = item.method;
						var currentLocation = item.location;
						var currentPileNo = item.pileNo;
						var currentPileStandard = item.pileStandard;
					
						var currentDrillingDepth = item.drillingDepth;
						var currentSdDrillingDepth = item.sdDrillingDepth;
						var currentStDrillingDepth = item.stDrillingDepth;
						var currentIntrusionDepth = item.intrusionDepth;
						var currentBalance = item.balance;
						if(constructionIdx == '1082'){
							currentBalance = balanceFixExp1082(getBalance1082(item));
						}
						var currentGongSac = gongSacFixExp(item.balance, calGongSac(item.totalConnectWidth, item.intrusionDepth, item.drillingDepth, constructionIdx), constructionIdx);
						if(constructionIdx == '1082'){
							currentGongSac = gongSacFixExp1082(currentBalance);
						}
						var currentHammaT = item.hammaT;
						var currentFallMeter = item.fallMeter;
						var currentManagedStandard = item.managedStandard;
						var currentAvgPenetrationValue = item.avgPenetrationValue;
						var currentTotalPenetrationValue = item.totalPenetrationValue;
						
						
						
						var allPiece = '';
						var allPieceValue = 0;
					    var piece = new Array();    //배열 선언
					    piece.push(item.piOne);
					    piece.push(item.piTwo); 
					    piece.push(item.piThree); 
					    piece.push(item.piFour); 
					    piece.push(item.piFive);
					    console.log(piece.length);
					    for (var y = 0; y < piece.length; y++) {
					    	if(piece[y].value != ''){
					    		if(piece[y] != ''){
					    			allPiece += ' + ';
							    	allPiece += piece[y];
							    	allPieceValue += Number(piece[y]);
					    		}
					    	}
						}
						
						var col = [];   
						var row = [];
							
						row.push({ c1: '시공장비', c2: machineNumber	     , c3: (constructionIdx == 944 ? '경타길이(M)' : '천공깊이(M)'), c4: (constructionIdx == '1082' ? Number(currentDrillingDepth) + Number(currentSdDrillingDepth) + Number(currentStDrillingDepth) : currentDrillingDepth) });        
					    row.push({ c1: '파일종류', c2: currentPileType 	 , c3: (constructionIdx == 944 ? '천공깊이(M)' : (constructionIdx == '1082' ? '경타깊이(M)' : '관입깊이(M)')), c4:currentIntrusionDepth}); 
					    row.push({ c1: '파일규격', c2: currentPileStandard , c3:'잔여길이(M)', c4:currentBalance }); 
					    row.push({ c1: '시공공법', c2: currentMethod       , c3:'공삭공(M)', c4:currentGongSac}); 
					    row.push({ c1: '위     치', c2: currentLocation     , c3:'해머무게(Ton)', c4:currentHammaT }); 
					    row.push({ c1: '파일번호', c2: currentPileNo       , c3:'낙하높이(M)', c4:currentFallMeter }); 
					    row.push({ c1: '파일길이(M)', c2: allPiece.substring(2, allPiece.length).trim()       , c3:'평균관입(mm)', c4:currentAvgPenetrationValue}); 
					    row.push({ c1: '파일합계(M)', c2: allPieceValue       , c3:'최종관입(mm)', c4:currentTotalPenetrationValue}); 
						
					    
				    	var pageHeight = doc.internal.pageSize.height || doc.internal.pageSize.getHeight();
						var pageWidth = doc.internal.pageSize.width || doc.internal.pageSize.getWidth();
				    	
					    doc.addFileToVFS('malgun.ttf', _fonts); 
					    doc.addFont('malgun.ttf','malgun', 'normal');
					    doc.setFont('malgun'); 
					    
					    //doc.text(15, 15, '파일 항타기록지' , 'center'); // 글씨입력(시작x, 시작y, 내용)
					    doc.setFontSize(20);
					    doc.text('파일 항타기록지', pageWidth / 2, 15, {align: 'center'});
					    doc.setFontSize(10);
					    doc.text('시공일 : ' + currentDate.substring(0,10), pageWidth - 15 , 30, 'right');
					    doc.setFontSize(10);
					    doc.text(constructionName, 15, 30, {align: 'left'});
					  //  doc.setFontType('bold');        
					    doc.autoTable(null, row, {
					    	startX: 15, 
				    	    startY: 35,           
					    	theme: 'grid',    
					    	//새로추가
					    	bodyStyles: {
					    		lineColor: [0, 0, 0]
					    	},       
					    	styles: {                
					    		font: 'malgun',                
					    		fontStyle: 'normal',
					    		halign: 'center',
					    		//새로 추가
					    		textColor: [0, 0, 0]          
				    		},            
				    		headerStyles: {                
				    			fontSize: 15,                
				    			font: 'malgun',                
				    			fontStyle: 'normal'      
							 }        
						});         
						doc.setProperties({            
							title: 'PDF타이틀',        
						});
						drawLegend(doc);
						drawChart(root, index, item, pageWidth, pageHeight, doc, currentAvgPenetrationValue , currentTotalPenetrationValue, constructionIdx);
						if(index < data.length - 1){
							doc.addPage();
						}
					});
					doc.save(createFileName() + '.pdf');
				}//
		
			},
			complete : function(data) {
			
			},
			error : function(xhr, status, error) {
				
			}
		});
	}
}


function calGongSac(totalConnectWidth, intrusionDepth, drillingDepth, constructionIdx){
	var value = 0;
	if(constructionIdx == 944){
		value = Number(totalConnectWidth) - Number(intrusionDepth != '' ? intrusionDepth : 0) - Number(drillingDepth != '' ? drillingDepth : 0);
	}else{
		value = Number(totalConnectWidth) - Number(intrusionDepth != '' ? intrusionDepth : 0);
	}
	if(value < 0)
	{
		return value.toFixed(1);
	}
	return 0;
}


function downloadDrivingAllRecoredBook(root, constructionIdx, machineNumber){
	
	if(confirm("전체 기록지를 출력하시겠습니까?")){
		jQuery.ajax({
			type : "POST",
			url : root + "/report/machine/list",
			data: { 
				constructionIdx : constructionIdx,
				machineNumber : machineNumber
			}, 
			dataType : "JSON", // 옵션이므로 JSON으로 받을게 아니면 안써도 됨
			success : function(data) {
				if(data.length > 0){//
					
					var doc = new jspdf.jsPDF("p", "mm", "a4");  //이렇게 바꾸어 줍니다!!!! 
				   
					$.each(data, function(index, item) {
						 var constructionName = item.name;
						var machineNumber = item.machineNumber
						var currentDate = item.currentDateTime;
						var currentPileType = item.pileType;
						var currentMethod = item.method;
						var currentLocation = item.location;
						var currentPileNo = item.pileNo;
						var currentPileStandard = item.pileStandard;
					
						var currentDrillingDepth = item.drillingDepth;
						var currentIntrusionDepth = item.intrusionDepth;
						var currentBalance = item.balance;
						var currentHammaT = item.hammaT;
						var currentFallMeter = item.fallMeter;
						var currentManagedStandard = item.managedStandard;
						var currentAvgPenetrationValue = item.avgPenetrationValue;
						var currentTotalPenetrationValue = item.totalPenetrationValue;
						
						
						
						var allPiece = '';
						var allPieceValue = 0;
					    var piece = new Array();    //배열 선언
					    piece.push(item.piOne);
					    piece.push(item.piTwo); 
					    piece.push(item.piThree); 
					    piece.push(item.piFour); 
					    piece.push(item.piFive);
					    console.log(piece.length);
					    for (var y = 0; y < piece.length; y++) {
					    	if(piece[y].value != ''){
					    		if(piece[y] != ''){
					    			allPiece += ' + ';
							    	allPiece += piece[y];
							    	allPieceValue += Number(piece[y]);
					    		}
					    	}
						}
						
						var col = [];   
						var row = [];
						
						row.push({ c1: '시공장비', c2: machineNumber	     , c3:(constructionIdx == 944 ? '경타길이(M)' : '천공깊이(M)'), c4: currentDrillingDepth });        
					    row.push({ c1: '파일종류', c2: currentPileType 	 , c3:(constructionIdx == 944 ? '천공깊이(M)' : '관입깊이(M)'), c4:currentIntrusionDepth}); 
					    row.push({ c1: '파일규격', c2: currentPileStandard , c3:'잔여길이(M)', c4:currentBalance }); 
					    row.push({ c1: '시공공법', c2: currentMethod       , c3:'공삭공(M)', c4:currentGongSac}); 
					    row.push({ c1: '위     치', c2: currentLocation     , c3:'해머무게(Ton)', c4:currentHammaT }); 
					    row.push({ c1: '파일번호', c2: currentPileNo       , c3:'낙하높이(M)', c4:currentFallMeter }); 
					    row.push({ c1: '파일길이(M)', c2: allPiece.substring(2, allPiece.length).trim()      , c3:'평균관입(mm)', c4:currentAvgPenetrationValue}); 
					    row.push({ c1: '파일합계(M)', c2: allPieceValue       , c3:'최종관입(mm)', c4:currentTotalPenetrationValue}); 
						
					    
				    	var pageHeight = doc.internal.pageSize.height || doc.internal.pageSize.getHeight();
						var pageWidth = doc.internal.pageSize.width || doc.internal.pageSize.getWidth();
				    	
					    doc.addFileToVFS('malgun.ttf', _fonts); 
					    doc.addFont('malgun.ttf','malgun', 'normal');
					    doc.setFont('malgun'); 
					    
					    //doc.text(15, 15, '파일 항타기록지' , 'center'); // 글씨입력(시작x, 시작y, 내용)
					    doc.setFontSize(20);
					    doc.text('파일 항타기록지', pageWidth / 2, 15, {align: 'center'});
					    doc.setFontSize(10);
					    doc.text('시공일 : ' + currentDate.substring(0,10), pageWidth - 15 , 30, 'right');
					    doc.setFontSize(10);
					    doc.text(constructionName, 15, 30, {align: 'left'});
					  //  doc.setFontType('bold');        
					    doc.autoTable(null, row, {
					    	startX: 15, 
				    	    startY: 35,           
					    	theme: 'grid',    
					    	//새로추가
					    	bodyStyles: {
					    		lineColor: [0, 0, 0]
					    	},       
					    	styles: {                
					    		font: 'malgun',                
					    		fontStyle: 'normal',
					    		halign: 'center',
					    		//새로 추가
					    		textColor: [0, 0, 0]          
				    		},            
				    		headerStyles: {                
				    			fontSize: 15,                
				    			font: 'malgun',                
				    			fontStyle: 'normal'      
							 }        
						});         
						doc.setProperties({            
							title: 'PDF타이틀',        
						});
						drawLegend(doc);
						drawChart(root, index, item, pageWidth, pageHeight, doc, currentAvgPenetrationValue , currentTotalPenetrationValue, constructionIdx);
						if(index < data.length - 1){
							doc.addPage();
						}
					});
					doc.save(createFileName() + '.pdf');
				}//
		
			},
			complete : function(data) {
			
			},
			error : function(xhr, status, error) {
				
			}
		});
	}
	
}


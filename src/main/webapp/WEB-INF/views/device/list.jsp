<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/tagLib.jsp" %>
<%-- 파일현황 출력/기록지 전체 출력(엑셀) 노출 권한: nav 메뉴와 동일하게 세션 constructionSetting을 따른다.
     settingRequired 현장만 권한 적용(관리자=보안코드 useAdmin*, 게스트=일반 useGuest*), 그 외 현장은 기존대로 노출. --%>
<c:set var="useFileMenu" value="${not sessionScope.settingRequired or (sessionScope.isHiddenManager ? sessionScope.constructionSetting.useAdminFileMenu : sessionScope.constructionSetting.useGuestFileMenu)}" />
<c:set var="useExcel" value="${not sessionScope.settingRequired or (sessionScope.isHiddenManager ? sessionScope.constructionSetting.useAdminExcel : sessionScope.constructionSetting.useGuestExcel)}" />
<style>
	.popup-bg {
	  position: fixed;
	  top: 0; left: 0;
	  width: 100%; height: 100%;
	  background: rgba(0, 0, 0, 0.5);
	  display: flex;
	  justify-content: center;
	  align-items: center;
	  z-index: 9999;
	}
	
	.popup-box {
	  background: #fff;
	  padding: 20px 30px;
	  border-radius: 10px;
	  width: 400px;
	  max-height: 80vh;
	  overflow-y: auto;
	  box-shadow: 0 3px 10px rgba(0, 0, 0, 0.3);
	  color: #000; /* ✅ 전체 폰트 색상 검은색 */
	  font-family: "맑은 고딕", "Apple SD Gothic Neo", sans-serif;
	}
	
	.pile-list label {
	  display: block;
	  margin: 6px 0;
	  font-size: 15px;
	  color: #000; /* ✅ 라벨 폰트도 검은색 명시 */
	}
	
	.popup-actions {
	  text-align: right;
	  margin-top: 15px;
	}
	
	.popup-actions button {
	  background: #f0f0f0;
	  color: #000; /* ✅ 버튼 글자도 검은색 */
	  border: 1px solid #ccc;
	  border-radius: 5px;
	  padding: 5px 10px;
	  cursor: pointer;
	}
	
	.popup-actions button:hover {
	  background: #ddd;
	}

	/* 반응형 */
	@media (max-width: 768px) {
		/* titBtnArea: 버튼/셀렉트 세로 줄바꿈 */
		.titBtnArea {
			display: flex;
			flex-wrap: wrap;
			gap: 6px;
			margin-left: 0;
			margin-top: 10px;
			width: 100%;
		}
		.titBtnArea select,
		.titBtnArea .printBtn,
		.titBtnArea .printBtn02,
		.titBtnArea .printPdfBtn {
			margin-left: 0 !important;
			margin-right: 0 !important;
			width: calc(50% - 3px) !important;
			box-sizing: border-box;
		}
		/* titArea: 모바일에서 세로 배치 */
		.titArea {
			flex-direction: column;
			align-items: flex-start;
		}
		/* 팝업 박스: 모바일 폭에 맞춤 */
		.popup-box {
			width: 90vw;
			padding: 16px;
		}
		/* 상단 공사명 텍스트 */
		#constructionName { font-size: 1.3rem !important; }
		#groupName        { font-size: 1rem !important; }
		#constructionAddress { font-size: 0.85rem !important; }
	}
</style>
<script type="text/javascript">
$( document ).ready( function() 
{	
	    $('#submitBtn').click( function() {
	    	$('#searchForm').submit();	    	
	    });
	    
	    $('input[type="checkbox"][name="targetDeivceCk"]').click(function(){
    		if($(this).prop('checked')){
	    	$('input[type="checkbox"][name="targetDeivceCk"]').prop('checked',false);
	    	$(this).prop('checked',true);
	    	}
	    });
	    
	    getConstructionName();
	    getPileTypeList();
	    calcSum();
	    getSpareDeviceCount();
	    getTestReportSet();
	    
	    //document.getElementById("remoteViewSet").style.display = "block";
});

function getTestReportSet(){
		
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

function fileChangeSelect2(value){
	var root = '${pageContext.request.contextPath}';
	TestReportFileDownload(root , root + '/treport/download/test/report?sn=' + value, value);
	
}

function getSpareDeviceCount(){
	
	var idx = ${param.constructionIdx};
	jQuery.ajax({
		type : "POST",
		url : "${pageContext.request.contextPath}/spare/device/use/quantity",
		async : false,  // 요청 시 동기화 여부. 기본은 비동기(asynchronous) 요청 (default: true)
		data: {
			constructionIdx : idx
		}, 
		dataType : "JSON", // 옵션이므로 JSON으로 받을게 아니면 안써도 됨
		success : function(data) {	
			$('#spareDeviceUseQuantity').text(data.spareDeviceCount);
			$('#triUseQuantity').text(data.tripodCount);
			$('#chgDvcQuantity').text(data.changeDeviceCount);
		},
		complete : function(data) {
		},
		error : function(xhr, status, error) {
			$('#spareDeviceUseQuantity').text("0");
			$('#triUseQuantity').text("0");
			$('#chgDvcQuantity').text("0");
		}
	}); 
}

function calcSum(){
	
	var totalSum = 0;
	var todaySum = 0;
	var yesterdaySum = 0;
	var conIdx = ${param.constructionIdx}	
	$('#userListTable tr').each( function( idx, obj ) {
		if(idx > 0 && idx != $('#userListTable tr').length){
			var tr = $(this);
			var td = tr.children();
			
			var total;
			var today;
			var yesterday;
			
			if(conIdx == 588 || conIdx == 613 || conIdx == 627){
				total = td.eq(2).text();
				today = td.eq(3).text();
				yesterday = td.eq(4).text();
			}else{
				total = td.eq(1).text();
				today = td.eq(2).text();
				yesterday = td.eq(3).text();
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

function doDelete(idx){
	var result = confirm("삭제하시겠습니까?");
	if(result){
		jQuery.ajax({
			type : "POST",
			url : "${pageContext.request.contextPath}/device/doDelete",
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
		return;
	}
	return;
}

function onClickChangeInfo(id){
	var tManager = null;
	var tWeContact = null;
	jQuery.ajax({
		type : "POST",
		url : "${pageContext.request.contextPath}/device/get/info",
		async : false,  // 요청 시 동기화 여부. 기본은 비동기(asynchronous) 요청 (default: true)
		dataType : "JSON", // 옵션이므로 JSON으로 받을게 아니면 안써도 됨
		data:  {
			id : id
		},
		success : function(data) {	
			
			tManager = data.tabletManager;
			tWeContact = data.weContact;
			
			$("#regForm input[name='name']").val(data.name);
			$("#regForm input[name='constructionIdx']").val(data.constructionIdx);
			$("#regForm input[name='id']").val(data.id);
			$("#regForm input[name='lavelNo']").val(data.lavelNo);
			$("#regForm input[name='bluetoothNo']").val(data.bluetoothNo);
			$("#regForm input[name='usimNo']").val(data.usimNo);
			$("#regForm input[name='machineNumber']").val(data.machineNumber);
			$("#regForm input[name='tabletManager']").val(data.tabletManager);
			$("#regForm input[name='weContact']").val(data.weContact);
			$("#regForm input[name='tabletNo']").val(data.tabletNo);
			$("#regForm input[name='startDate']").val(data.startDate);
			$("#regForm input[name='endDate']").val(data.endDate);
		},
		complete : function(data) {
			closePop();
		},
		error : function(xhr, status, error) {
			closePop();
		}
	}); 
	
	//location.href='${pageContext.request.contextPath}/device/update?id=' + id
	//예비용장비 목록을 가져온다.
	getPopInSpareDeviceList(id);
	
	//위 메니저 목록을 가져온다.
	jQuery.ajax({
		type : "GET",
		url : "${pageContext.request.contextPath}/wemanager/get/list",
		dataType : "JSON", // 옵션이므로 JSON으로 받을게 아니면 안써도 됨
		success : function(data) {
			
			$("#regForm input[name='tabletManager']").attr("disabled", true);  
			$("#regForm input[name='weContact']").attr("disabled", true);  
			
			$("#regForm select[name='weManager'] option").remove();  
			if(data.length > 0){
				$("#regForm select[name='weManager']").append("<option value=\"\">선택</option>");
				$.each(data, function(index, item) {
					if(tManager == item.name + " " + item.position){
						$("#regForm select[name='weManager']").append("<option selected=\"selected\" value='" + item.phone + '|' + item.name + " " + item.position + "'>"+ item.name + " " + item.position + "</option>");
					}else{
						$("#regForm select[name='weManager']").append("<option value='" + item.phone + '|' + item.name + " " + item.position + "'>"+ item.name + " " + item.position + "</option>");
					}
					
				});
				$("#regForm select[name='weManager']").append("<option value='직접입력'>직접입력</option>");
			}
		},
		complete : function(data) {
		},
		error : function(xhr, status, error) {
			alert("에러발생");
		}
	});
}


function weManagerSel(value)
{
	$("#regForm input[name='tabletManager']").val("");  
	$("#regForm input[name='weContact']").val("");  
	if(value == '직접입력'){
		$("#regForm input[name='tabletManager']").attr("disabled", false);  
		$("#regForm input[name='weContact']").attr("disabled", false);  
		$("#regForm input[name='tabletManager']").focus();
	}else{
		var info = value.split("|"); 
		$("#regForm input[name='tabletManager']").val(info[1]);  
		$("#regForm input[name='weContact']").val(info[0]);  
		$("#regForm input[name='tabletManager']").attr("disabled", true);  
		$("#regForm input[name='weContact']").attr("disabled", true); 
	}
}

function getConstructionName(){
	var role = ${sessionInfo.role}
	var idx = ${param.constructionIdx};
	jQuery.ajax({
		type : "POST",
		contentType: "application/x-www-form-urlencoded; charset=UTF-8",
		dataType: "json",  // ← 이걸 추가!
		url : "${pageContext.request.contextPath}/construction/get/name",
		data: {
			id : idx,
			role : role
		}, 
		success : function(data) {
			if(role == 0){
				$('.h1Tit').text(data.groupName + ' ' + data.constructionName + ' ' + data.constructionLocation);
				//$('#constructionAddress').text(data.constructionAddress);
			}else{
				$('#groupName').text(data.groupName);
				$('#constructionName').text('[ ' + data.constructionName + ' ] ' + data.constructionLocation);
				$('#constructionAddress').text(data.constructionAddress);
			}
			//$('.h1Tit').text(data);
			//$('#groupName').text(data.groupName);
			//$('.h1Tit').text('[ ' + data.constructionName + ' ] ' + data.constructionLocation);
			//$('#constructionAddress').text(data.constructionAddress);
		},
		complete : function(data) {
		},
		error : function(xhr, status, error) {
			console.error("AJAX 오류 상태:", status);             // ex: "parsererror", "error", "timeout"
			console.error("AJAX 오류 메시지:", error);             // ex: "SyntaxError: Unexpected token ..."
			console.error("서버 응답:", xhr.responseText);         // ← 이게 진짜 중요
		}
	}); 
}
function getPileTypeList(){
	
	var idx = ${param.constructionIdx};
	jQuery.ajax({
		type : "POST",
		contentType: "application/x-www-form-urlencoded; charset=UTF-8",
		url : "${pageContext.request.contextPath}/fileinventory/get/pile/type/list",
		data: {
			constructionIdx : idx
		}, 
		success : function(data) {				
			 $.each(data, function (i, item) {
				 if(item.pileType == "PHC" || item.pileType == "UHC" || item.pileType == "UPHC"){
					 var option = item.pileType + " " + item.pileStandard;
				 }else{
					 var option = item.pileType + " " + item.fileWeight + " " + item.pileStandard;
				 }
                 $("#select1").append("<option class='text-success text-center' value='"+option+"'>"+option+"</option>")
			 });
		},
		complete : function(data) {
		},
		error : function(xhr, status, error) {
		}
	}); 
}
function fileChange(value){
	var constructionIdx = ${param.constructionIdx};
	location.href = '${pageContext.request.contextPath}/file/using/chart/download/excel?constructionIdx=' + constructionIdx + '&pile=' + value + '&dateTime=' + value;
	$('#select1 option:eq(0)').prop('selected', true);
}




function conductSel(idx, selectVal){
	
	var alertMsg = "";
	if(selectVal == '0'){
		alertMsg = "본사";
	}else if(selectVal == '1'){
		alertMsg = "종료";
	}else if(selectVal == '2'){
		alertMsg = "가맹";
	}

	var result = confirm(alertMsg +  ' 상태로 변경하시겠습니까?');
	if(result){
		jQuery.ajax({
			type : "POST",
			url : "${pageContext.request.contextPath}/device/update/conduct",
			data: {
				id : idx
				, conduct : selectVal
			}, 
			dataType : "JSON", // 옵션이므로 JSON으로 받을게 아니면 안써도 됨
			success : function(data) {
				if(data){
					alert('변경이 완료되었습니다.');
				}
			},
			complete : function(data) {
			},
			error : function(xhr, status, error) {
			}
		}); 	
	}
}

function setQuantity(){
	var cIdx = ${param.constructionIdx};
	var value = $('#quantity').val();
	jQuery.ajax({
		type : "POST",
		url : "${pageContext.request.contextPath}/quantity/set",
		async : false,  // 요청 시 동기화 여부. 기본은 비동기(asynchronous) 요청 (default: true)
		data: {
			constructionIdx : cIdx
			, quantity : value
		}, 
		success : function(data) {				
			 if(data > 0){
				// alert(data);
				 $('#searchForm').submit();	
				 alert('저장되었습니다.');
			 }else{
				 alert('저장에 실패했습니다. 관리자에게 문의하세요.');
			 }
		},
		complete : function(data) {
		},
		error : function(xhr, status, error) {
		}
	}); 
}

function getQuantity(){
	var cIdx = ${param.constructionIdx};
	jQuery.ajax({
		type : "POST",
		url : "${pageContext.request.contextPath}/quantity/get",
		async : false,  // 요청 시 동기화 여부. 기본은 비동기(asynchronous) 요청 (default: true)
		data: {
			constructionIdx : cIdx
		}, 
		success : function(data) {				
			 if(data.constructionIdx = 'undefined'){
				 $('#workSummary').html('공정률 0%&nbsp;&nbsp;&nbsp;남은수량 0 본 &nbsp;&nbsp;&nbsp;총 작업수량 <input type="text" class="input01" style="width: 100px;">&nbsp;본&nbsp;<input type="button" value="저장" onclick="javascript:setQuantity();">');
			 }
		},
		complete : function(data) {
			
		},
		error : function(xhr, status, error) {
			
		}
	}); 
}


function setTripodCount(){
	
	var cIdx = ${param.constructionIdx};
	var tripodCount  = $('#tripodCount').val();
	
	jQuery.ajax({
		type : "POST",
		url : "${pageContext.request.contextPath}/spare/device/set/tripodcount",
		async : false,  // 요청 시 동기화 여부. 기본은 비동기(asynchronous) 요청 (default: true)
		data: {
			constructionIdx : cIdx
			, quantity : tripodCount
		}, 
		success : function(data) {				
			alert((data > 0 ? '저장되었습니다.' : '저장에 실패했습니다.'));
		},
		complete : function(data) {
			
		},
		error : function(xhr, status, error) {
			
		}
	}); 
}

function setTripodChangeCount(){
	
	var cIdx = ${param.constructionIdx};
	var tripodChangeCount  = $('#tripodChangeCount').val();
	
	jQuery.ajax({
		type : "POST",
		url : "${pageContext.request.contextPath}/spare/device/set/change/tripodcount",
		async : false,  // 요청 시 동기화 여부. 기본은 비동기(asynchronous) 요청 (default: true)
		data: {
			constructionIdx : cIdx
			, quantity : tripodChangeCount
		}, 
		success : function(data) {				
			alert((data > 0 ? '저장되었습니다.' : '저장에 실패했습니다.'));
		},
		complete : function(data) {
			
		},
		error : function(xhr, status, error) {
			
		}
	}); 
}

function getQuantityResult(){
	var cIdx = ${param.constructionIdx};
	
	jQuery.ajax({
		type : "POST",
		url : "${pageContext.request.contextPath}/quantity/get",
		async : false,  // 요청 시 동기화 여부. 기본은 비동기(asynchronous) 요청 (default: true)
		data: {
			constructionIdx : cIdx
		}, 
		success : function(data) {	
			//alert(data);
			 if(data.constructionIdx = 'undefined'){
				 return false;
			 }else{
				 return true;
			 }
		},
		complete : function(data) {
			
		},
		error : function(xhr, status, error) {
			
		}
	}); 
	return false;
}



// 기록지 전체 출력: Excel / PDF 선택 모달
var _exportConId = 0;
function downloadAllReport(conId){
	if(conId <= 0){
		alert('에러가 발생했습니다.');
		return;
	}
	_exportConId = conId;
	$('#exportChoiceOverlay').css('display', 'flex');
}
function closeExportChoice(){
	$('#exportChoiceOverlay').css('display', 'none');
}
// Excel: 기존 서버 다운로드 로직
function exportAllExcel(){
	var conId = _exportConId;
	closeExportChoice();
	location.href = '${pageContext.request.contextPath}/report/download/all/excel?constructionIdx=' + conId;
}
// PDF: 전체 출력 로직(머신 무관) 연결
function exportAllPdf(){
	var conId = _exportConId;
	closeExportChoice();
	if(!confirm("전체 기록지를 PDF로 출력하시겠습니까?\n건수가 많으면 시간이 걸릴 수 있습니다.")) return;
	showPdfLoading();
	// 동기(블로킹) 생성이라 setTimeout으로 한 박자 양보 → 로딩 화면을 먼저 그린 뒤 작업 시작
	setTimeout(function(){
		try {
			downloadDrivingAllRecoredBook('${pageContext.request.contextPath}', conId, '');
		} catch(e) {
			alert('PDF 생성 중 오류가 발생했습니다.');
		} finally {
			hidePdfLoading();
		}
	}, 60);
}
function showPdfLoading(){ $('#pdfLoadingOverlay').css('display', 'flex'); }
function hidePdfLoading(){ $('#pdfLoadingOverlay').css('display', 'none'); }

function formCheck(){
	//숫자와 문자 포함 형태의 6~12자리 이내의 암호 정규식
	var passwordRegex = /^[A-Za-z0-9]{6,12}$/;
	if($("#regForm input[name='constructionIdx']").val() == 0){
		alert('시공사를 선택하세요.');
		return;
	}else if($("#regForm input[name='bluetoothNo']").val() == ''){
		alert('블루투스 번호를 입력하세요.');
		return;
	}else if($("#regForm input[name='lavelNo']").val() == ''){
		alert('자동특정기 번호를 입력하세요.');
		return;
	}else if($("#regForm input[name='machineNumber']").val() == ''){
		alert('호기번호를 입력하세요.');
		return;
	}else if($("#regForm input[name='tabletManager']").val() == ''){
		alert('WE매니저 이름을 입력하세요.');
		return;
	}else if($("#regForm input[name='weContact']").val() == ''){
		alert('매니저 연락처를 입력하세요.');
		return;
	}else if($("#regForm input[name='startDate']").val() == ''){
		alert('시작일을 입력하세요.');
		return;
	}else if($("#regForm input[name='endDate']").val() == ''){
		alert('종료일을 입력하세요.');
		return;
	}else if($("#regForm input[name='startDate']").val() > $("#regForm input[name='endDate']").val() || $("#regForm input[name='startDate']").val() == $("#regForm input[name='endDate']").val()){
		alert('종료일자가 잘못되었습니다.');
		$("#regForm input[name='endDate']").val("");
		return;
	}
	 if($("#regForm input[name='password']").val() != '' && $("#regForm input[name='confirmPassword']").val() != '' ){
			//비밀번호가 입력되었다면
			if(!passwordRegex.test($("#regForm input[name='password']").val())){
				alert('숫자와 문자 포함  6~12자리 비밀번호를 입력하세요.');
				return ;
			}else if(!passwordRegex.test($("#regForm input[name='confirmPassword']").val())){
				alert('숫자와 문자 포함  6~12자리 비밀번호를 입력하세요.');
				$('#confirmPassword').focus();
				return;
			}else if($("#regForm input[name='password']").val() != $("#regForm input[name='confirmPassword']").val()){
				alert('비밀번호를 다름니다. 비밀번호를 확인하세요.');
				$("#regForm input[name='confirmPassword']").focus();
				return;
			}
		}else{
			if($("#regForm input[name='password']").val() != ''){
				alert('확인 비밀번호를 입력하세요.');
				$("#regForm input[name='confirmPassword']").focus();
				return;
			}else if($("#regForm input[name='confirmPassword']").val() != ''){
				alert('비밀번호를 입력하세요.');
				$("#regForm input[name='password']").focus();
				return;
			}
		}
		
	 	var myObject = new Object(); 
	 	myObject.id = new Number($("#regForm input[name='id']").val());
		myObject.constructionIdx = new Number($("#regForm input[name='constructionIdx']").val());
		myObject.lavelNo = $("#regForm input[name='lavelNo']").val();
		myObject.bluetoothNo = $("#regForm input[name='bluetoothNo']").val();
		myObject.tabletNo = $("#regForm input[name='tabletNo']").val();
		myObject.usimNo = $("#regForm input[name='usimNo']").val();
		myObject.password = $("#regForm input[name='password']").val();
		myObject.tabletManager = $("#regForm input[name='tabletManager']").val();
		myObject.weContact = $("#regForm input[name='weContact']").val();
		myObject.startDate = $("#regForm input[name='startDate']").val();
		myObject.endDate = $("#regForm input[name='endDate']").val();
		myObject.machineNumber = $("#regForm input[name='machineNumber']").val();
		myObject.name = '';
		myObject.conduct = new Number(0);
		myObject.totalCnt = new Number(0);
		myObject.todayCnt = new Number(0);
		myObject.yesterdayCnt = new Number(0);
		
		var myString = JSON.stringify(myObject); 
		jQuery.ajax({
			type : "POST",
			url : "${pageContext.request.contextPath}/device/updateOfAjax",
		    contentType : "application/json",
			async : false,  // 요청 시 동기화 여부. 기본은 비동기(asynchronous) 요청 (default: true)
			data:  JSON.stringify(myObject),
			success : function(data) {	
				result = data;
			},
			complete : function(data) {
				if(result == 1){
					$('.popUp').hide();
					$('.popLayer').hide();
					$('body').css('overflow', 'auto');
					$('#searchForm').submit();
				}
			},
			error : function(xhr, status, error) {
				alert('error');
				$('.popUp').hide();
				$('.popLayer').hide();
				$('body').css('overflow', 'auto');
			}
		}); 
		return;
}


function spareDeviceTypeOnChange(value){
	if(value == 1){
		$('#tripodArea').show();
		$('#spareArea').hide();
	}else{
		$('#tripodArea').hide();
		$('#spareArea').show();
	}
}


function getPopInSpareDeviceList(deviceIdx){
	
	var conIdx = ${param.constructionIdx};
	jQuery.ajax({
		type : "POST",
		contentType: "application/x-www-form-urlencoded; charset=UTF-8",
		url : "${pageContext.request.contextPath}/spare/device/not/change/list",
		data: {
			constructionIdx : conIdx,
			type : 0
		}, 
		success : function(data) {
			//alert(data.length);
			if(data.length == 0){
				$("#reFormInSprDvcTb tr").remove();
				$("#reFormInSprDvcTb").append(
						 '<thead>'
					     +   '<tr>'
					     +     '<th>등록된 예비용 장비가 없습니다.</th>'
					     +   '</tr>'
					     +'</thead>');
			}else{
				$("#reFormInSprDvcTb tr").remove();
				$("#reFormInSprDvcTb").append(	
				 '<thead>'
			     +   '<tr>'
			     +     '<th>블루투스No</th>'
			     +     '<th>측정기S/N</th>'
			     +     '<th>교체</th>'
			     +   '</tr>'
			     +'</thead>');
				$.each(data, function (i, item) {
					
					$("#reFormInSprDvcTb").append(
						 '<tr>'
						+	'<td style="text-align: center;">' + item.bluetoothNo + '</td>'
						+   '<td style="text-align: center;">' + item.lavelNo + '</td>'
						+   '<td style="text-align: center;"><div class="compareBtn" onClick="javascript:changeSpareDevice(' + deviceIdx + ',' + item.id + ',' + item.constructionIdx  + ');">정보변경</div></td>'
						+'</tr>');
				});
			}
		},
		complete : function(data) {
		},
		error : function(xhr, status, error) {
		}
	}); 
}

function changeSpareDevice(targetId, changeId, constructionIdx){
	var result = confirm('기기를 교체하시겠습니까?');
	if(result){
		jQuery.ajax({
			type : "POST",
			url : "${pageContext.request.contextPath}/spare/device/change",
			async : false,  // 요청 시 동기화 여부. 기본은 비동기(asynchronous) 요청 (default: true)
			data: {
				constructionIdx : constructionIdx,
				targetId : targetId, 
				changeId : changeId
			}, 
			success : function(data) {
				getSpareDeviceCount();
				getPopInSpareDeviceList(targetId);
				closePop();
				location.reload();
				
			},
			complete : function(data) {
			},
			error : function(xhr, status, error) {
			}
		}); 
	}
}

</script>

		<!--컨텐츠-->
<div class="section-right">
	<%@ include file="/WEB-INF/views/common/welcomeMsg.jsp" %>
	<div class="TopContArea">
		<div class="titArea mb-0">
			<c:choose>
				<c:when test="${sessionInfo.role == 0}">
					<p class="h1Tit" style="margin-bottom: 20px;"></p>
				</c:when>
				<c:otherwise>
					<div style="margin-bottom : 10px;">
					<p style="font-size: 1.2rem; color: #ffffff; opacity: 0.7; margin: 0 0 4px 0; font-weight: 500; letter-spacing: -0.02em;" id="groupName"></p> <!-- 시공사명 -->
					<p style="font-size: 1.6rem; font-weight: 700; color: #ffffff; margin: 0 0 6px 0; letter-spacing: -0.03em;" id="constructionName"></p>
					<p style="font-size: 1rem; color: #c5e1f1; opacity: 0.8; margin: 0; font-weight: 400;" id="constructionAddress"></p>     <!-- 현장주소 -->
				</div>
				</c:otherwise>
			</c:choose>
			
			<div class="titBtnArea" style="">
				<c:choose>
					<c:when test="${sessionInfo.role < 4}">
							<select id="select2" name="select2" onchange="javascript:fileChangeSelect2(this.value);" style="background-color: #0a4b76;">
								<option value="">시험성적표 출력 ▼</option>
							</select>	
							
							<c:choose>
							  <c:when test="${sessionInfo.constructionIdx == 1308}">
							    <!-- 단일 선택 + 팝업 -->
							    <c:if test="${useFileMenu}">
							    <select id="select1" name="select1" onchange="openPilePopup()">
							      <option selected disabled value="">파일현황 출력 ▼</option>
							      <option value="open">선택하기</option>
							    </select>
							    </c:if>
							
							    <!-- 팝업 구조 (초기에는 hidden) -->
							    <div id="pilePopup" class="popup-bg" style="display:none;">
								  <div class="popup-box">
								    <h3>파일 종류 선택</h3>
								    <div id="pileList" class="pile-list"></div>
								
								    <div class="popup-actions">
								      <button type="button" onclick="submitPileSelection()">다운로드</button>
								      <button type="button" onclick="closePilePopup()">닫기</button>
								    </div>
								  </div>
								</div>
							
							    <script>
							    function openPilePopup() {
							    	  // 팝업 오픈
							    	  $("#pilePopup").show();

							    	  // 목록 로딩
							    	  getPileTypeList2();
							    	}

							    	function closePilePopup() {
							    	  $("#pilePopup").hide();
							    	}

							    	// 기존 함수 재활용
							    	function getPileTypeList() {
							    	  var idx = ${param.constructionIdx};

							    	  $("#pileList").html("<div>로딩 중...</div>");

							    	  jQuery.ajax({
							    	    type : "POST",
							    	    contentType: "application/x-www-form-urlencoded; charset=UTF-8",
							    	    url : "${pageContext.request.contextPath}/fileinventory/get/pile/type/list",
							    	    data: { constructionIdx : idx },
							    	    success : function(data) {				
							    	      var html = "";
							    	      $.each(data, function (i, item) {
							    	        var option;
							    	        if(item.pileType == "PHC" || item.pileType == "UHC" || item.pileType == "UPHC"){
							    	          option = item.pileType + " " + item.pileStandard;
							    	        } else {
							    	          option = item.pileType + " " + item.fileWeight + " " + item.pileStandard;
							    	        }
							    	        html += "<label><input type='checkbox' name='pile' value='"+option+"'> "+option+"</label>";
							    	      });
							    	      $("#pileList").html(html);
							    	    },
							    	    error : function() {
							    	      $("#pileList").html("<div class='text-danger'>목록을 불러오지 못했습니다.</div>");
							    	    }
							    	  });
							    	}

							    	function submitPileSelection() {
							    	  var constructionIdx = ${param.constructionIdx};
							    	  var selectedValues = [];

							    	  $('input[name="pile"]:checked').each(function() {
							    	    selectedValues.push($(this).val());
							    	  });

							    	  if (selectedValues.length === 0) {
							    	    alert("파일 종류를 하나 이상 선택하세요.");
							    	    return;
							    	  }

							    	  var pileParam = selectedValues.join(',');

							    	  // 전송
							    	  location.href = '${pageContext.request.contextPath}/file/using/chart/download/multi/excel'
							    	    + '?constructionIdx=' + constructionIdx
							    	    + '&pile=' + encodeURIComponent(pileParam);

							    	  // 팝업 닫기 + select 초기화
							    	  closePilePopup();
							    	  $('#select1 option:eq(0)').prop('selected', true);
							    	}
							    </script>
							
							  </c:when>
							  <c:otherwise>
							    <!-- 다중 선택 일반 select -->
							    <c:if test="${useFileMenu}">
							    <select id="select1" name="select1" onchange="javascript:fileChange(this.value);">
									<option selected disabled value="">파일현황 출력 ▼</option>
								</select>
								</c:if>
							  </c:otherwise>
						  </c:choose>
					</c:when>
				</c:choose>
				<c:choose>
					<c:when test="${sessionInfo.role == 0}">
						<c:if test="${useExcel}"><div class="printBtn" onclick="javascript:downloadAllReport(${param.constructionIdx});">기록지 전체 출력</div></c:if>
					</c:when>
					<c:when test="${sessionInfo.role == 2 or sessionInfo.role == 3 or sessionInfo.role == 4}">
						<c:if test="${useExcel}"><div class="printBtn" onclick="javascript:downloadAllReport(${param.constructionIdx});">기록지 전체 출력</div></c:if>
					</c:when>
					<c:otherwise>
						<c:if test="${useExcel}"><div class="printBtn" onclick="javascript:downloadAllReport(${sessionInfo.constructionIdx});">기록지 전체 출력</div></c:if>
						<%-- <c:if test="${sessionInfo.role == 1}"> --%>
						<c:if test="${sessionScope.isHiddenManager}">
							<div id="contractDownloadBtn" class="printBtn" onclick="openContractDownload()" style="background-color:#28a745;margin-left:10px;display:none;">계약서 다운로드</div>
						</c:if>
					</c:otherwise>
				</c:choose>

				<!-- 계약서 선택 팝업 (다중 계약서 대비) -->
				<div id="contractDownloadPopup" class="popup-bg" style="display:none;">
					<div class="popup-box">
						<h3 style="margin-bottom:14px;font-size:15px;">계약서 선택</h3>
						<div id="contractDownloadList"></div>
						<div class="popup-actions">
							<button type="button" onclick="document.getElementById('contractDownloadPopup').style.display='none';">닫기</button>
						</div>
					</div>
				</div>

				<script>
				$(function() {
					var _ctx  = '${pageContext.request.contextPath}';
					var _cIdx = ${sessionInfo.constructionIdx};
					if (_cIdx) {
						$.getJSON(_ctx + '/contract/ajax/list', {constructionIdx: _cIdx}, function(list) {
							var hasSigned = list && list.some(function(c) { return c.status === 'SIGNED'; });
							if (hasSigned) $('#contractDownloadBtn').show();
						});
					}
				});

				function openContractDownload() {
					var constructionIdx = ${sessionInfo.constructionIdx};
					var ctx = '${pageContext.request.contextPath}';
					$.getJSON(ctx + '/contract/ajax/list', {constructionIdx: constructionIdx}, function(list) {
						var signed = list ? list.filter(function(c) { return c.status === 'SIGNED'; }) : [];
						if (signed.length === 0) {
							alert('다운로드 가능한 계약서가 없습니다.');
							return;
						}
						if (signed.length === 1) {
							location.href = ctx + '/contract/pdf?contractIdx=' + signed[0].contractIdx;
							return;
						}
						var html = '';
						$.each(signed, function(i, c) {
							html += '<div style="margin-bottom:10px;">'
								+ '<a href="' + ctx + '/contract/pdf?contractIdx=' + c.contractIdx + '" '
								+ 'style="display:block;padding:8px 12px;background:#f5f5f5;border:1px solid #ddd;border-radius:4px;color:#333;text-decoration:none;font-size:13px;">'
								+ escHtmlDvc(c.contractNo || ('계약서 #' + c.contractIdx))
								+ '<span style="float:right;color:#28a745;font-size:12px;">' + (c.signedAt || '') + '</span>'
								+ '</a></div>';
						});
						$('#contractDownloadList').html(html);
						$('#contractDownloadPopup').show();
					});
				}
				function escHtmlDvc(s) { return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;'); }
				</script>
				
				<form:form id="searchForm" commandName="domainParam" method="POST">
					<form:hidden path="currentPage"/>
				</form:form>
				
			</div>
		</div>
		
		<c:choose>
			<c:when test="${sessionInfo.role < 4}">
				<div class="listinputArea" style="margin-bottom: 10px;">
					<div class="innerInputArea">
						
						
						<c:choose>
							<c:when test="${param.constructionIdx == 751 or sessionInfo.constructionIdx == 751}">
								<!-- HJ중공업 성우이앤씨 보령신복합1호기건설공사 -->
								<p><span>남은수량</span>&nbsp;&nbsp;${totalWorkQuantity.quantityLeft - 71}&nbsp;&nbsp;공</p>
								<p><span>시공수량</span>&nbsp;&nbsp;${totalWorkQuantity.executedQuantity + 71}&nbsp;&nbsp;공</p>
							</c:when>
							<c:otherwise>
								<p id="processRate"><span>공정률</span>&nbsp;&nbsp;${totalWorkQuantity.processRate}&nbsp;&nbsp;%</p>
								<p id="quantityLeft"><span>남은수량</span>&nbsp;&nbsp;${totalWorkQuantity.quantityLeft}&nbsp;&nbsp;공</p>
								<p id="executedQuantity"><span>시공수량</span>&nbsp;&nbsp;${totalWorkQuantity.executedQuantity}&nbsp;&nbsp;공</p>
							</c:otherwise>
						</c:choose>
						<c:choose>
							<c:when test="${sessionInfo.role == 0}">
								<p><span>NG</span>&nbsp;&nbsp;${totalWorkQuantity.ngQuantity}&nbsp;&nbsp;공</p>
							</c:when>
							<c:otherwise>
								<c:choose>
									<c:when test="${sessionInfo.constructionIdx == 696 or sessionInfo.constructionIdx == 650 or sessionInfo.constructionIdx == 644 or sessionInfo.constructionIdx == 599}">
										<p><span>NG</span>&nbsp;&nbsp;${totalWorkQuantity.ngQuantity}&nbsp;&nbsp;공</p>
									</c:when>
								</c:choose>
							</c:otherwise>
						</c:choose>
						<c:choose>
							<c:when test="${sessionInfo.role == 0 || sessionInfo.hiddenManager == true || sessionInfo.role == 3}">
								<!-- 수저가능자 슈퍼관리자, 히든매니저, 부경 -->
								<p><span>총 작업수량</span><input type="text" name="" id="quantity" value="${totalWorkQuantity.quantity}" class="input03" />공</p>
							</c:when>
							<c:otherwise>
								<%-- <p><span>총 작업수량</span><input type="text" name="" id="quantity" value="${totalWorkQuantity.quantity}" class="input03" />공</p> --%>
								<p><span>총 작업수량</span>&nbsp;&nbsp;<font>${totalWorkQuantity.quantity}</font>&nbsp;&nbsp;공</p>
							</c:otherwise>
						</c:choose>
					</div>
					<c:choose>
						<c:when test="${sessionInfo.role == 0 || sessionInfo.hiddenManager == true || sessionInfo.role == 3}">
							<input type="button" name="" value="저장" class="saveBtn" onclick="javascript:setQuantity();"/>
						</c:when>
					</c:choose>
				</div>
			</c:when>
		</c:choose>
		
		<c:choose>
			<c:when test="${sessionInfo.role < 4}">
			
				<c:choose>
					<c:when test="${sessionInfo.role == 0 || sessionInfo.role == 3}">
						<div class="listinputArea"  style="margin-bottom: 10px;">
					</c:when>
					
					<c:otherwise>
						<div class="listinputArea" >
					</c:otherwise>
				</c:choose>
				
					<div class="innerInputArea">
						<p><span>예비용</span>&nbsp;&nbsp;<font id="spareDeviceUseQuantity">0</font>&nbsp;&nbsp;대</p>
						<p><span>교체</span>&nbsp;&nbsp;<font id="chgDvcQuantity">0</font>&nbsp;&nbsp;대</p>
						<p><span>삼각대 반</span>
							<c:choose>
								<c:when test="${sessionInfo.role == 0 || sessionInfo.role == 3}">
									<input type="text" name="tripodCount" id="tripodCount" value="${tripodCount}" class="input03" />&nbsp;대
									<input type="button" value="저장" class="saveBtn" onclick="javascript:setTripodCount();"/>
								</c:when>
								<c:otherwise>
									&nbsp;&nbsp;${tripodChangeCount}
									<input type="hidden" name="tripodCount" id="tripodCount" value="${tripodCount}" class="input03" disabled="disabled"/>&nbsp;대
								</c:otherwise>
							</c:choose>
						</p>
						<p><span>삼각대 교</span>
							<c:choose>
								<c:when test="${sessionInfo.role == 0 || sessionInfo.role == 3}">
									<input type="text" name="tripodChangeCount" id="tripodChangeCount" value="${tripodChangeCount}" class="input03" />&nbsp;대
									<input type="button" value="저장" class="saveBtn" onclick="javascript:setTripodChangeCount();"/>
								</c:when>
								<c:otherwise>
									&nbsp;&nbsp;${tripodChangeCount}
									<input type="hidden" name="tripodChangeCount" id="tripodChangeCount" value="${tripodChangeCount}" class="input03" disabled="disabled" />&nbsp;대
								</c:otherwise>
							</c:choose>
							
						</p>
					</div>
					<c:choose>
						<c:when test="${sessionInfo.role == 0}">
							<input type="button" name="" value="예비용 기기관리" class="saveBtn" style="width: 140px;" onclick="javascript:openSparePop();" />
							<!-- <input type="button" name="" value="측정기 기기교체" class="saveBtn" style="width: 140px;" onclick="javascript:openChgDvcPopup();" /> -->
						</c:when>
					</c:choose>
				</div>
			</c:when>
		</c:choose>
		<c:choose>
			<c:when test="${sessionInfo.role == 0 || sessionInfo.role == 3}">
				<div class="listinputArea">
					<div class="innerInputArea">
						<p><span>가맹점&nbsp;&nbsp;&nbsp;&nbsp;: </span>&nbsp;&nbsp;${conOptionCondition.fcName}&nbsp;</p>
						<p><span>보안코드 : </span>&nbsp;&nbsp;${conOptionCondition.secretCode}&nbsp;</p>
						<p><span>시간출력 : </span>&nbsp;&nbsp;${conOptionCondition.longCalYn}&nbsp;</p>
						<p><span>극한출력 : </span>&nbsp;&nbsp;${conOptionCondition.ubcYn}&nbsp;</p>
						<p><span>원데이터 : </span>&nbsp;&nbsp;${conOptionCondition.originDataYn}&nbsp;</p>
						<p><span>PDF출력 : </span>&nbsp;&nbsp;${conOptionCondition.showPdfYn}&nbsp;</p>
					</div>
				</div>
			</c:when>
		</c:choose>
	<!-- <form:form id="allSearchForm" action="${pageContext.request.contextPath}/report/all/list?&constructionIdx=${param.constructionIdx}" commandName="domainParam" method="POST">
			<form:hidden path="currentPage"/>
			<div class="searchArea"  style="margin-top: 20px;">
				 <div class="searchArea01 type01">
					<form:input path="location" class="searchin" placeholder="시공 위치"/>
					<form:input path="pileNo" class="searchin" placeholder="파일 번호"/>
					<form:input path="method" class="searchin" placeholder="공법"/>
					<c:choose>
						<c:when test="${sessionInfo.role == 1}">
							<%-- <input type="hidden" name="id" value="${param.id}"/> --%>
							<input type="hidden" name="constructionIdx" value="${sessionInfo.constructionIdx}"/>
						</c:when>
						<c:otherwise>
							<%-- <input type="hidden" name="id" value="${param.id}"/> --%>
							<input type="hidden" name="constructionIdx" value="${param.constructionIdx}"/>
						</c:otherwise>
					</c:choose>
					<div class="searchBtn">
						<img src="${pageContext.request.contextPath}/new/img/search.png" style="cursor:pointer;" onclick="javascript:searchForm();">
					</div>
				</div>
				
				<div class="searchArea02">
					<form:input path="startDate" class="inputDate datepicker" placeholder="시작일"/>
					<span>~</span>
					<form:input path="endDate" class="inputDate datepicker" placeholder="종료일"/>
					<div class="searchBtn">
						<img src="${pageContext.request.contextPath}/new/img/search_date.png" style="cursor:pointer;" onclick="javascript:searchForm();">
					</div>
				</div>
			</div>
		</form:form>-->
	</div> 
	
	
	<div class="min531">
		<div class="tableArea">
			<div class="viewTable viewTable01">
				<div class="tableScroll">
					<table id="userListTable">
						<tr class="viewTh">
							<c:choose>
								<c:when test="${param.constructionIdx == 588 or param.constructionIdx == 613 or param.constructionIdx == 627}">
									<th style="width: 8%;">Zone</th>
								</c:when>
							</c:choose>
							<th style="width: 3%; font-size: 15px; padding: 15px 0px 15px 0px;">호기</th>
							<th style="width: 3%; font-size: 15px;">총작업</th>
							<th style="width: 4%; font-size: 15px;">금일작업</th>
							<th style="width: 4%; font-size: 15px;">전일작업</th>
							<th style="width: 8%; font-size: 15px;">태블릿 ID</th>
							<th style="width: 8%; font-size: 15px;">블루투스 No</th>
							<th style="width: 8%; font-size: 15px;">측정기 S/N</th>
							<c:choose>
								<c:when test="${sessionInfo.role == 0}">
									<th style="width: 8%; font-size: 15px;">유심 No</th>
								</c:when>
							</c:choose>
							<th style="width: 8%; font-size: 15px;">We매니저</th>
							<th style="width: 12%; font-size: 15px;">연락처</th>
							<th style="width: 9%; font-size: 15px;">시작일</th>
							<th style="width: 10%; font-size: 15px;">종료일</th>
							<c:choose>
								<c:when test="${sessionInfo.role == 0}">
									<th style="width: 5%; font-size: 15px;">정보변경</th>
									<th style="width: 5%; font-size: 15px;">상태</th>
								</c:when>
							</c:choose>
						</tr>
						<c:forEach var="domain" items="${domainList}" varStatus="status">
							<c:choose>
								<c:when test="${sessionInfo.role == 0}">
									<tr>
										<c:choose>
											<c:when test="${param.constructionIdx == 588 or param.constructionIdx == 613 or param.constructionIdx == 627}">
												<td  class="c1">
												<c:choose>
													<c:when test="${domain.zone eq 'ept'}">
														타워 및 존외<br>
													</c:when>
													<c:otherwise>
														${domain.zone}<br>
													</c:otherwise>
												</c:choose>
												<c:choose>
													<c:when test="${domain.zone != ''}">
														( ${domain.totalCountByZone} 공 ) 
													</c:when>
												</c:choose> 
											</td>
											</c:when>
										</c:choose>
										<td><a class="viewGo" href='${pageContext.request.contextPath}/simple/report/list?id=${domain.id}&constructionIdx=${domain.constructionIdx}&type=date&mode=simple'>${domain.machineNumber}</a></td>
										<c:choose>
											<c:when test="${param.constructionIdx == 588 or param.constructionIdx == 613 or param.constructionIdx == 627}">
												<td>${domain.countByZone}공</td>
											</c:when>
											<c:otherwise>
												<td>${domain.totalCnt}공</td>
											</c:otherwise>
										</c:choose>
										<td>${domain.todayCnt}공</td>
										<td>${domain.yesterdayCnt}공</td>
										<td>${domain.tabletNo}</td>
										<td>${domain.bluetoothNo}</td>
										<td><a class="viewGo"  href="javascript:TestReportFileDownload('${pageContext.request.contextPath}' , '${pageContext.request.contextPath}/treport/download/test/report?sn=${domain.lavelNo}', '${domain.lavelNo}');">${domain.lavelNo}</a></td>
										<td>${domain.usimNo}</td>
										<td>${domain.tabletManager}</td>
										<td>${domain.weContact}</td>
										<td>${domain.startDate}</td>
										<td>${domain.endDate}</td>
										<td><div class="tableChange" onclick="javascript:onClickChangeInfo('${domain.id}');">정보변경</div></td>
										<td>
											<select id="conductSel" class="state" onchange="conductSel('${domain.id}', this.value)">
												<option value="0" ${domain.conduct == 0 ? 'selected="selected"' : '' }>본사</option>
												<option value="2" ${domain.conduct == 2 ? 'selected="selected"' : '' }>가맹</option>
												<option value="1" ${domain.conduct == 1 ? 'selected="selected"' : '' }>종료</option>
											</select>
										</td>
										<%-- <td><a href="javascript:doDelete('${domain.id}')">[삭제]</a></td> --%>
									</tr>
								</c:when>
								<c:when test="${sessionInfo.role == 2 or sessionInfo.role == 3 or sessionInfo.role == 4}">
									<tr>
										<c:choose>
											<c:when test="${param.constructionIdx == 588 or param.constructionIdx == 613 or param.constructionIdx == 627}">
												<td  class="c1">
													<c:choose>
														<c:when test="${domain.zone eq 'ept'}">
															타워 및 존외<br>
														</c:when>
														<c:otherwise>
															${domain.zone}<br>
														</c:otherwise>
													</c:choose>
													<c:choose>
														<c:when test="${domain.zone != ''}">
															( ${domain.totalCountByZone} 공 ) 
														</c:when>
													</c:choose>
												</td>
											</c:when>
										</c:choose>
										<td><a class="viewGo" href='${pageContext.request.contextPath}/simple/report/list?id=${domain.id}&constructionIdx=${param.constructionIdx}&type=date&mode=simple'>${domain.machineNumber}</a></td>
										<c:choose>
											<c:when test="${param.constructionIdx == 588 or param.constructionIdx == 613 or param.constructionIdx == 627}">
												<td>${domain.countByZone}공</td>
											</c:when>
											<c:otherwise>
												<td>${domain.totalCnt}공</td>
											</c:otherwise>
										</c:choose>
										<td>${domain.todayCnt}공</td>
										<td>${domain.yesterdayCnt}공</td>
										<td>${domain.tabletNo}</td>
										<td>${domain.bluetoothNo}</td>
										<td><a class="viewGo"  href="javascript:TestReportFileDownload('${pageContext.request.contextPath}' , '${pageContext.request.contextPath}/treport/download/test/report?sn=${domain.lavelNo}', '${domain.lavelNo}');">${domain.lavelNo}</a></td>
										<td>${domain.tabletManager}</td>
										<td>${domain.weContact}</td>
										<td>${domain.startDate}</td>
										<td>${domain.endDate}</td>
										<%-- <td><a href="javascript:doDelete('${domain.id}')">[삭제]</a></td> --%>
									</tr>
								</c:when>
								<c:otherwise>
									<tr>
										<c:choose>
											<c:when test="${param.constructionIdx == 588 or param.constructionIdx == 613 or param.constructionIdx == 627}">
												<td  class="c1"><c:choose>
													<c:when test="${domain.zone eq 'ept'}">
														타워 및 존외<br>
													</c:when>
													<c:otherwise>
														${domain.zone}<br>
													</c:otherwise>
												</c:choose>
												<c:choose>
													<c:when test="${domain.zone != ''}">
														( ${domain.totalCountByZone} 공 ) 
													</c:when>
												</c:choose> 
											</td>
											</c:when>
										</c:choose>
										<td><a class="viewGo" href='${pageContext.request.contextPath}/simple/report/list?id=${domain.id}&type=date&mode=simple'>${domain.machineNumber}</a></td>
										<c:choose>
											<c:when test="${param.constructionIdx == 588 or param.constructionIdx == 613 or param.constructionIdx == 627}">
												<td>${domain.countByZone}공</td>
											</c:when>
											<c:otherwise>
												<td>${domain.totalCnt}공</td>
											</c:otherwise>
										</c:choose>
										<td>${domain.todayCnt}공</td>
										<td>${domain.yesterdayCnt}공</td>
										<td>${domain.tabletNo}</td>
										<td>${domain.bluetoothNo}</td>
										<td><a class="viewGo"  href="javascript:TestReportFileDownload('${pageContext.request.contextPath}' , '${pageContext.request.contextPath}/treport/download/test/report?sn=${domain.lavelNo}', '${domain.lavelNo}');">${domain.lavelNo}</a></td>
										<td>${domain.tabletManager}</td>
										<td>${domain.weContact}</td>
										<td>${domain.startDate}</td>
										<td>${domain.endDate}</td>
									</tr>
								</c:otherwise>
							</c:choose>
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
							<c:choose>
									<c:when test="${sessionInfo.role == 0}">
										<tr style="background-color: #e6e6e6; height: 49px;" >
											<%-- <td><a class="viewGo" href='${pageContext.request.contextPath}/report/all/list?&constructionIdx=${param.constructionIdx}'>합계</a></td> --%>
											 <td>합계</td>
											<c:choose>
												<c:when test="${param.constructionIdx == 588 or param.constructionIdx == 613 or param.constructionIdx == 627}">
													<td></td>
												</c:when>
											</c:choose>
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
											<td></td>
											<td></td>
										</tr>
									</c:when>
									<c:otherwise>
										<c:choose>
											<c:when test="${sessionInfo.role == 1}">
												<tr style="background-color: #e6e6e6; height: 49px;">
													<%-- <td><a class="viewGo" href='${pageContext.request.contextPath}/report/all/list?&constructionIdx=${param.constructionIdx}'>합계</a></td> --%>
													<td>합계</td>
													<c:choose>
														<c:when test="${param.constructionIdx == 588 or param.constructionIdx == 613 or param.constructionIdx == 627}">
															<td></td>
														</c:when>
													</c:choose>
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
												</tr>
											</c:when>
											<c:otherwise>
												<tr style="background-color: #e6e6e6; height: 49px;">
													<%-- <td><a class="viewGo" href='${pageContext.request.contextPath}/report/all/list?&constructionIdx=${param.constructionIdx}'>합계</a></td> --%>
													<td>합계</td>
													<c:choose>
														<c:when test="${param.constructionIdx == 588 or param.constructionIdx == 613 or param.constructionIdx == 627}">
															<td></td>
														</c:when>
													</c:choose>
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
												</tr>
											</c:otherwise>
										</c:choose>
								</c:otherwise>
							</c:choose>
						</c:otherwise>
					</c:choose>
					</table>
				</div>
			</div>
		</div>
	</div>
	
	<!--페이징-->			
	<%@ include file="/WEB-INF/views/common/pagination.jsp" %>
	<!--//페이징-->
	
</div>
<!--//컨텐츠-->

<!--정보 변경 팝업-->
	<form id="regForm" name="regForm" method="POST" >
	<div class="popUp">
		<div class="popTit">
			<p>정보변경</p>
			<img class="popClose" src="${pageContext.request.contextPath}/new/img/popclose.png" />
		</div>
		<div class="popCont">
			<div class="inputArea02 mb-20">
				예비용 장비 등록 현황
				<table id="reFormInSprDvcTb" class="reFormInSprDvcTb" style="width: 100%; margin-top: 10px; margin-bottom: 10px;" border="1">
				</table>
			</div>
			<div class="inputArea02 mb-20">
				<p class="inputTxt02">협력사</p>
				<input type="text" disabled="disabled" class="Input02" id="name" name="name">
				<input type="hidden" id="constructionIdx" name="constructionIdx">
				<input type="hidden" id="id" name="id">
			</div>
			<div class="inputArea02 mb-20">
				<p class="inputTxt02">PDAM 테블릿 번호</p>
				<input type="text" autocomplete="off"  class="Input02" name="tabletNo" id="tabletNo" disabled="true" onkeypress="javascript:pressContact();" placeholder="PDAM 테블릿 번호를 입력하세요.">
			</div>
			<div class="inputArea02 mb-20">
				<p class="inputTxt02">호기번호</p>
				<input type="text" autocomplete="off" class="Input02" name="machineNumber" id="machineNumber" placeholder="호기번호를 입력하세요.">
			</div>
			<div class="inputArea02 mb-20">
				<p class="inputTxt02">블루투스 No</p>
				<input type="text" autocomplete="off"  class="Input02" name="bluetoothNo" id="bluetoothNo" placeholder="블루투스 No를 입력하세요.">
			</div>
			<div class="inputArea02 mb-20">
				<p class="inputTxt02">측정기 S/N</p>
				<input type="text" autocomplete="off"  class="Input02" name="lavelNo" id="lavelNo" placeholder="측정기 S/N를 입력하세요.">
			</div>
			<div class="inputArea02 mb-20">
				<p class="inputTxt02">유심 No</p>
				<input type="text" autocomplete="off"  class="Input02" name="usimNo" id="usimNo" placeholder="유심 No를 입력하세요.">
			</div>
			<div class="inputArea02 mb-20">
				<p class="inputTxt02">WE매니저</p>
				<select id="weManager" name="weManager" class="Input02" onchange="weManagerSel(this.value)">
				</select>
				<input type="text" style="margin-top: 10px;" disabled="disabled" autocomplete="off" class="Input02" id="tabletManager" name="tabletManager" placeholder="WE매니저를 입력하세요.">
			</div>
			<div class="inputArea02 mb-20">
				<p class="inputTxt02">매니저 연락처</p>
				<input type="text" autocomplete="off"  disabled="disabled" class="Input02" name="weContact" id="weContact"  placeholder="매니저 연락처를 입력하세요.">
			</div>
			<div class="inputArea02 mb-20">
				<p class="inputTxt02">비밀번호</p>
				<input type="password" autocomplete="new-password"  class="Input02" name="password" id="password"  placeholder="비밀번호를 입력하세요.">
			</div>
			<div class="inputArea02 mb-20">
				<p class="inputTxt02">비밀번호 확인</p>
				<input type="password" autocomplete="new-password" class="Input02" name="confirmPassword" id="confirmPassword"  placeholder="확인 비밀번호를 입력하세요.">
			</div>
			<div class="inputArea02 mb-20">
				<p class="inputTxt02">시작일</p>
				<input type="text" autocomplete="off"  class="inputDate datepicker Input02" name="startDate" id="startDate" placeholder="시작일을 입력하세요.">
			</div>
			<div class="inputArea02 mb-20">
				<p class="inputTxt02">종료일</p>
				<input type="text" autocomplete="off" class="inputDate datepicker Input02" name="endDate" id="endDate" placeholder="종료일을 입력하세요." >
			</div>
			
			<div class="popAdd" onclick="return formCheck();">변경</div>
		</div>
	</div>
	</form>
	<div class="popLayer" style=""></div>
	
	
	<!-- 예비용 기기관리 팝업 -->
	<div class="popup_layer" id="popup_layer" style="display: none;" style="border :solid blue 1px;">
		<div class="popup_box">
		    <div class="popup_cont">
				<div class="popup_head">
					<div class="popup_text">
						<font>등록현황</font>
						<select id="spareDeviceSearchType" onchange="getSpareDeviceList();">
							<option value="0">예비용장비</option>
				  			<!-- <option value="1">삼각대</option> -->
				  			<option value="2">교체장비</option>
						</select>
					</div>
					<div class="popup_close">
						<a href="javascript:closeSparePop();">닫기</a>
					</div>
			  	</div>
			  	<div class="input_area" id="spareDeviceControllBtnArea">
			  		<div style="width: 100%; text-align: right;">
			  			<input class="plus" type="button" value="추가" style="cursor: pointer;" onclick="spareListTableAddRow();">
			  			<!-- <input class="minus" type="button" value="-"  style="cursor: pointer;" onclick="spareListTableDeleteRow();"> -->
			  		</div>
			  	</div>
			    <div class="table_list">
				  	<table class="display" id="spareListTable" border="1" style="width: 100%;"></table>
			    </div>
		    	<div class="input_area" id="spareDeviceControllSaveArea" style="text-align: center;">
		  			<input class="save" type="button" value="저장"  style="cursor: pointer;" onclick="doSaveSpareDevice();">
		  		</div>
		    </div>
		</div>
	</div>
	
	<!-- 예비용 기기관리 팝업  끝 -->
	<div class="popup_layer" id="chg_dvc_popup_layer" style="display: none;">
		<div class="popup_box">
		    <div class="popup_cont" style="height : 100%;">
				<div class="popup_head" style="margin-bottom: 10px;">
					<div class="popup_text">
						<font>측정기 기기교체</font>
					</div>
					<div class="popup_close">
						<a href="javascript:closeChgDvcPopup();">닫기</a>
					</div>
			  	</div>
			  	<div class="input_area">
			  		<div style="width: 45%; height:100%;">
			  			<div>
			  				<div>
			  					<h2>등록기기</h2>
			  				</div>
			  				<div>
			  					<table class="display" id="deviceListTable" border="1" style="width: 100%;">
				  				</table>
			  				</div>
			  			</div>
			  		</div>
			  		<div class="cross">
			  			<img alt="" onclick="javasciprt:onDoRepare();" src="${pageContext.request.contextPath}/new/img/repare2.png" style="">
			  		</div>
			  		<div style="width: 45%; float: right;">
			  			<div>
			  				<div>
			  					<h2>예비용기기</h2>
			  				</div>
			  				<div>
			  					<table class="display" id="repareDeviceListTable" border="1" style="width: 100%; float: right;">
				  				</table>
			  				</div>
			  			</div>
			  		</div>
			  	</div>
		    </div>
		</div>
	</div>
	
	
	<!-- <div class="popup_layer" id="remoteViewSet" style="display: block;">
		<div class="popup_box" style="width: 700px;">
			<div class="popup_cont" style="height : 100%;">
				<div class="popup_head" style="margin-bottom: 10px;">
					<div class="popup_text">
						<font>원격모니터링 정보</font>
					</div>
					<div class="popup_close">
						<a href="javascript:closeChgDvcPopup();">닫기</a>
					</div>
			  	</div>
			  	<div class="input_area">
			  		<div style="width: 100%; height:100%;">
			  			<div style="display: flex; justify-content: flex-start;">
		  					<div style="height: 40px; display : flex; justify-content : center; align-items : center;">
		  						웹아이디 :
		  					</div>
		  					<div style="height: 40px; display : flex; justify-content : center; align-items : center;">
		  						<input type="text" class="tdInput" value="silverlight2017" />
		  					</div>
			  			</div>
			  			<div style="display: flex; justify-content: flex-start;">
		  					<div style="height: 40px; display : flex; justify-content : center; align-items : center;">
		  						웹비밀번호 :
		  					</div>
		  					<div style="height: 40px; display : flex; justify-content : center; align-items : center;">
		  						<input type="text" class="tdInput" value="silverlight2017" />
		  					</div>
		  					<div style="height: 40px; width : 100px; display : flex; justify-content : center; align-items : center;">
		  						<input type="button" class="tdInput" value="저장" />
		  					</div>
			  			</div>
			  			<div style="display: flex; justify-content: flex-start; " >
		  					<div style="height: 40px; display : flex; justify-content : center; align-items : center;">
		  						■ 1호기 디바이스 아이디 :
		  					</div>
		  					<div style="height: 40px; display : flex; justify-content : center; align-items : center;">
		  						<input type="text" class="tdInput" value="wetb001" />
		  					</div>
		  					<div style="height: 40px; display : flex; justify-content : center; align-items : center;">
		  						 비빌먼호 :
		  					</div>
		  					<div style="height: 40px; display : flex; justify-content : center; align-items : center;">
		  						<input type="text" class="tdInput" value="we8104" />
		  					</div>
		  					<div style="height: 40px; width : 100px; display : flex; justify-content : center; align-items : center;">
		  						<input type="button" class="tdInput" value="저장" />
		  					</div>
			  			</div>
			  			<div style="display: flex; justify-content: flex-start; " >
		  					<div style="height: 40px; display : flex; justify-content : center; align-items : center;">
		  						■ 2호기 디바이스 아이디 :
		  					</div>
		  					<div style="height: 40px; display : flex; justify-content : center; align-items : center;">
		  						<input type="text" class="tdInput" value="wetb002" />
		  					</div>
		  					<div style="height: 40px; display : flex; justify-content : center; align-items : center;">
		  						 비빌먼호 :
		  					</div>
		  					<div style="height: 40px; display : flex; justify-content : center; align-items : center;">
		  						<input type="text" class="tdInput" value="we8104" />
		  					</div>
		  					<div style="height: 40px; width : 100px; display : flex; justify-content : center; align-items : center;">
		  						<input type="button" class="tdInput" value="저장" />
		  					</div>
			  			</div>
			  		</div>
			  	</div>
		  	</div>
		</div>
	</div> -->
	
	<%-- <form id="mtrRegForm" name="mtrRegForm" method="POST">
		<div class="popUp" id="remoteViewSet" style="display: block;">
			<div class="popTit">
				<p>원격모니터링 정보</p>
				<img class="popClose" src="${pageContext.request.contextPath}/new/img/popclose.png" />
			</div>
			<div class="popCont">
				<div class="inputArea02 mb-20">
					<p class="inputTxt02">웹 아이디</p>
					<input type="text" autocomplete="off" class="Input02" name="webId" id="webId" placeholder="웹 아이디">
				</div>
				<div class="inputArea02 mb-20">
					<p class="inputTxt02">웹 비밀번호</p>
					<input type="text" autocomplete="off" class="Input02" name="webPassword" id="webPassword" placeholder="웹 비밀번호">
				</div>
				<div class="inputArea02 mb-20">
					<p class="inputTxt02">1호기 디바이스 아이디</p>
					<input type="text" autocomplete="off" class="Input02" name="firstDeviceId" id="firstDeviceId" placeholder="1호기 디바이스 아이디">
				</div>
				<div class="inputArea02 mb-20">
					<p class="inputTxt02">2호기 디바이스 아이디</p>
					<input type="text" autocomplete="off" class="Input02" name="secondDeviceId" id="secondDeviceId" placeholder="2호기 디바이스 아이디">
				</div>
				<div class="inputArea02 mb-20">
					<p class="inputTxt02">3호기 디바이스 아이디</p>
					<input type="text" autocomplete="off" class="Input02" name="thirdDeviceId" id="thirdDeviceId" placeholder="3호기 디바이스 아이디">
				</div>
				<div class="popAdd" onclick="return mtrformCheck();">저장</div>
			</div>
		</div>
	</form> --%>

<script>

function searchForm(){
	$("#allSearchForm").submit();
}


function mtrformCheck(){
	
	if($("#mtrRegForm input[name='webId']").val() == ""){
		alert('웹 아이디를 입력하세요');
		return;
	}else if($("#mtrRegForm input[name='webPassword']").val() == ""){
		alert('웹 비밀번호를 입력하세요');
		return;
	}else if($("#mtrRegForm input[name='firstDeviceId']").val() == ""){
		alert('1호기 디바이스 아이디를 입력하세요.');
		return;
	}else if($("#mtrRegForm input[name='secondDeviceId']").val() == ""){
		alert('2호기 디바이스 아이디를 입력하세요.');
		return;
	}else if($("#mtrRegForm input[name='thirdDeviceId']").val() == ""){
		alert('3호기 디바이스 아이디를 입력하세요.');
		return;
	}
	
	
	var myObject = new Object(); 
 	myObject.webId = new Number($("#mtrRegForm input[name='webId']").val());
	myObject.webPassword = new Number($("#mtrRegForm input[name='webPassword']").val());
	myObject.firstDeviceId = $("#mtrRegForm input[name='firstDeviceId']").val();
	myObject.secondDeviceId = $("#mtrRegForm input[name='secondDeviceId']").val();
	myObject.thirdDeviceId = $("#mtrRegForm input[name='thirdDeviceId']").val();
	
	var myString = JSON.stringify(myObject); 
	jQuery.ajax({
		type : "POST",
		url : "${pageContext.request.contextPath}/device/updateOfAjax",
	    contentType : "application/json",
		async : false,  // 요청 시 동기화 여부. 기본은 비동기(asynchronous) 요청 (default: true)
		data:  JSON.stringify(myObject),
		success : function(data) {	
			result = data;
		},
		complete : function(data) {
			if(result == 1){
				$('.popUp').hide();
				$('.popLayer').hide();
				$('body').css('overflow', 'auto');
				$('#searchForm').submit();
			}
		},
		error : function(xhr, status, error) {
			alert('error');
			$('.popUp').hide();
			$('.popLayer').hide();
			$('body').css('overflow', 'auto');
		}
	}); 
	return;
}

function onDoRepare(){
	var conIdx = ${param.constructionIdx};
	var targetCheckedCount = $('input:checkbox[name=targetDeivceCk]:checked').length;
	var changeCheckedCount = $('input:checkbox[name=changeDeivceCk]:checked').length;
	if(targetCheckedCount == 0){
		alert('교체할 기기를 선택하세요.');
		return;
	}else if(changeCheckedCount == 0){
		alert('교체할 예비용 기기를 선택하세요.');
		return;
	}else{
		var targetId = $('input:checkbox[name=targetDeivceCk]:checked').eq(0).val();
		var changeId = $('input:checkbox[name=changeDeivceCk]:checked').eq(0).val();
		
		var result = confirm('기기를 교체하시겠습니까?');
		if(result){
			jQuery.ajax({
				type : "POST",
				url : "${pageContext.request.contextPath}/spare/device/change",
				async : false,  // 요청 시 동기화 여부. 기본은 비동기(asynchronous) 요청 (default: true)
				data: {
					constructionIdx : conIdx,
					targetId : targetId, 
					changeId : changeId
				}, 
				success : function(data) {
					getDeviceList();
					getSpareDeviceCount();
					closeChgDvcPopup();
				},
				complete : function(data) {
				},
				error : function(xhr, status, error) {
				}
			}); 
		}
	}
}

//기기교체 팝업 시작
function openChgDvcPopup() {
   document.getElementById("chg_dvc_popup_layer").style.display = "block";
   getDeviceList();

  // getRepareDeviceList();
}
//팝업 닫기
function closeChgDvcPopup() {
   document.getElementById("chg_dvc_popup_layer").style.display = "none";
}

function getDeviceList(){
	
	var conIdx = ${param.constructionIdx};
	jQuery.ajax({
		type : "POST",
		url  : "${pageContext.request.contextPath}/device/get/list",
		data : {
			constructionIdx : conIdx
		}, 
		dataType : "JSON", // 옵션이므로 JSON으로 받을게 아니면 안써도 됨
		//contentType : "application/json",
		success : function(data) {
			$("#deviceListTable tr").remove();
			$("#deviceListTable").append(	
			 '<thead>'
		     +   '<tr>'
		     +     '<th>선택</th>'
		     +     '<th>호기</th>'
		     +     '<th>블루투스No</th>'
		     +     '<th>측정기S/N</th>'
		     +   '</tr>'
		     +'</thead>');
			$.each(data, function (i, item) {
				
				 $("#deviceListTable").append(
					 '<tr>'
					+	'<td>'
		 			+		'<input type="checkbox" id="targetDeivceCk" name="targetDeivceCk" value="' + item.id + '"/>'
		 			+		'<input type="hidden" id="constructionIdx" name="constructionIdx" value="' + item.constructionIdx + '"/>'
		 			+	'</td>'
		 			+	'<td>' + item.machineNumber + '</td>'
					+	'<td>' + item.bluetoothNo + '</td>'
					+   '<td>' + item.lavelNo + '</td>'
					+'</tr>');
			});
		},
		complete : function(data) {
			//alert('>><<' + data);
		},
		error : function(xhr, status, error) {
			//alert('>><<111' + error);
		}
	});
	
	jQuery.ajax({
		type : "POST",
		contentType: "application/x-www-form-urlencoded; charset=UTF-8",
		url : "${pageContext.request.contextPath}/spare/device/not/change/list",
		data: {
			constructionIdx : conIdx,
			type : 0
		}, 
		success : function(data) {
			$("#repareDeviceListTable tr").remove();
			$("#repareDeviceListTable").append(	
			 '<thead>'
		     +   '<tr>'
		     +     '<th>선택</th>'
		     +     '<th>블루투스No</th>'
		     +     '<th>측정기S/N</th>'
		     +     '<th>상태</th>'
		     +   '</tr>'
		     +'</thead>');
			$.each(data, function (i, item) {
				
				$("#repareDeviceListTable").append(
					 '<tr>'
					+	'<td>'
		 			+		'<input type="checkbox"  id="changeDeivceCk" name="changeDeivceCk" value="' + item.id + '"/>'
		 			+		'<input type="hidden" id="constructionIdx" name="constructionIdx" value="' + item.constructionIdx + '"/>'
		 			+	'</td>'
					+	'<td>' + item.bluetoothNo + '</td>'
					+   '<td>' + item.lavelNo + '</td>'
					+   '<td>' + spareStatusToLang(item.status) + '</td>'
					+'</tr>');

			});
		},
		complete : function(data) {
		},
		error : function(xhr, status, error) {
		}
	}); 
}

function spareStatusToLang(status){
	if(status == 0){
		return "예비용";
	}else if(status == 1){
		return "교체";
	}
}

function doSaveSpareDevice(){
	
	if($('#spareListTable tr').length <= 1){
		return;
	}
	
	for (var i = 1; i < $('#spareListTable tr').length; i++) {
		if($("#spareDeviceSearchType option:selected").val() == '0'){
			if($('#spareListTable tr').eq(i).find('#bluetoothNo').val() == ''){
				alert(i + '번째 줄 블루투스 번호를 입력하세요.');
				$('#spareListTable tr').eq(i).find('#bluetoothNo').focus();
				return;
			}else if($('#spareListTable tr').eq(i).find('#lavelNo').val() == ''){
				alert(i + '번째 줄 측정기S/N를 입력하세요.');
				$('#spareListTable tr').eq(i).find('#tabletNo').focus();
				return;
			}
		}else{
			if($('#spareListTable tr').eq(i).find('#quantity').val() == ''){
				alert(i + '번째 줄 수량을 입력하세요.');
				$('#spareListTable tr').eq(i).find('#quantity').focus();
				return;
			}
		}
	}
	
	var reports = [];
	for (var i = 1; i < $('#spareListTable tr').length; i++) {
		var data;
		if($("#spareDeviceSearchType option:selected").val() == '0'){
			data = {
					type : Number(($('#spareListTable tr').eq(i).find('td').eq(1).text() == '예비용기기' ? 0 : 1)), 
					constructionIdx : $('#spareListTable tr').eq(i).find('#constructionIdx').val(),
					bluetoothNo: $('#spareListTable tr').eq(i).find('#bluetoothNo').val(), 
					lavelNo: $('#spareListTable tr').eq(i).find('#lavelNo').val(), 
					status: Number($('#spareListTable tr').eq(i).find('#status').find(":selected").val()), 
					bigo: $('#spareListTable tr').eq(i).find('#bigo').val()
			}
		}else{
			data = {
					type : Number(($('#spareListTable tr').eq(i).find('td').eq(1).text() == '예비용기기' ? 0 : 1)), 
					constructionIdx : $('#spareListTable tr').eq(i).find('#constructionIdx').val(),
					quantity: $('#spareListTable tr').eq(i).find('#quantity').val(), 
					status: 0,
					bigo: $('#spareListTable tr').eq(i).find('#bigo').val()
			}
			
		}
		reports.push(data); 
	}
	
	var paramConstructionIdx = ${param.constructionIdx};	
	var paramType = new Number($("#spareDeviceSearchType option:selected").val());
	var paramStatus = new Number((paramType == '2' ? '1' : '0'));
	
	var result = confirm("저장하시겠습니까?");
	if(result){
		jQuery.ajax({
			type : "POST",
			url : "${pageContext.request.contextPath}/spare/device/update/multi?constructionIdx=" + paramConstructionIdx + "&type=" + paramType  + "&status=" + paramStatus,
			data: JSON.stringify(reports), 
			dataType : "JSON", // 옵션이므로 JSON으로 받을게 아니면 안써도 됨
			contentType : "application/json",
			success : function(data) {
				if(data){
					getSpareDeviceList();
				}else{
					alert('ERROR가 발생했습니다. 관리자에게 문의하시기 바랍니다.');
				}
			},
			complete : function(data) {
			},
			error : function(xhr, status, error) {
			}
		});
		closeSparePop();
		return; 
	}else{
		return;
	}
}

function doOpenCheck(chk, rowindex) {
	
	if($(chk).is(":checked")){
		
		 if($("#spareDeviceSearchType option:selected").val() == '0'){
				$('#spareListTable tr').eq(rowindex).find('#bluetoothNo').attr('disabled', false);
				$('#spareListTable tr').eq(rowindex).find('#lavelNo').attr('disabled', false);
				$('#spareListTable tr').eq(rowindex).find('#status').attr('disabled', false);
				$('#spareListTable tr').eq(rowindex).find('#bigo').attr('disabled', false);
		 }else{
				$('#spareListTable tr').eq(rowindex).find('#quantity').attr('disabled', false);
				$('#spareListTable tr').eq(rowindex).find('#bigo').attr('disabled', false);
		 }
		 
	}else{
		
		 if($("#spareDeviceSearchType option:selected").val() == '0'){
				$('#spareListTable tr').eq(rowindex).find('#bluetoothNo').attr('disabled', true);
				$('#spareListTable tr').eq(rowindex).find('#lavelNo').attr('disabled', true);
				$('#spareListTable tr').eq(rowindex).find('#status').attr('disabled', true);
				$('#spareListTable tr').eq(rowindex).find('#bigo').attr('disabled', true);
		 }else{
				$('#spareListTable tr').eq(rowindex).find('#quantity').attr('disabled', true);
				$('#spareListTable tr').eq(rowindex).find('#bigo').attr('disabled', true);
		 }
	}
}



function openSparePop() {
   document.getElementById("popup_layer").style.display = "block";
   getSpareDeviceList();
}

//팝업 닫기
function closeSparePop() {
   document.getElementById("popup_layer").style.display = "none";

}

function deleteSpareOneByIndex(index){
	$('#spareListTable tr').eq(index).remove();
}	

function deleteSpareOneById(id){
	
	var result = confirm("삭제하시겠습니까?");
	if(result){
		jQuery.ajax({
			type : "POST",
			url : "${pageContext.request.contextPath}/spare/device/delete",
			data: {
				id : id
			}, 
			dataType : "JSON", // 옵션이므로 JSON으로 받을게 아니면 안써도 됨
			success : function(data) {
				if(data == true){
					getSpareDeviceList();
				}
			},
			complete : function(data) {
			},
			error : function(xhr, status, error) {
			}
		}); 
		return;
	}
	return;
}

function spareListTableDeleteRow(){
	var total = $("input[name=selectOne]").length;
	var checked = $("input[name=selectOne]:checked").length;
	
	if(checked < 1){
		alert('선택된 항목이 없습니다.');
		return;
	}
	for (var i = 0; i < $('#spareListTable tr').length; i++) {
		if ($('#spareListTable tr').eq(i).find('#selectOne').is(':checked')) {
			$('#spareListTable tr').eq(i).remove();
		}
	}
}
function spareListTableAddRow(){
	 var conIdx = ${param.constructionIdx};
	 if($("#spareDeviceSearchType option:selected").val() == '0' || $("#spareDeviceSearchType option:selected").val() == '2'){
		 $("#spareListTable").append('<tr>'
									+	'<td>'
						 			+		'<input type="checkbox" id="selectOne" name="selectOne" onclick="doOpenCheck(this, this.parentNode.parentNode.rowIndex);"/>'
						 			+		'<input type="hidden" id="constructionIdx" name="constructionIdx" value="' + conIdx + '"/>'
						 			+	'</td>'
		 							+	'<td>예비용기기</td>'
		 							+	'<td><input type="text" id="bluetoothNo" name="bluetoothNo" class="tdInput" value=""/></td>'
		 							+   '<td><input type="text" id="lavelNo" name="lavelNo" class="tdInput"  value=""/></td>'
		 							+	'<td>'
		 							+   '   <select disabled id="status" name="status" class="tdInput">'
		 							+   '	    <option value="0" selected>예비용</option>'
		 							+   '	    <option value="1">교체</option>'
		 							+   '   </select>'
		 							+   '</td>'
		 							+	'<td><input type="text" id="bigo" name="bigo" class="tdInput"  value=""/></td>'
		 							+   '<td><div class="deleteRow" onclick="deleteSpareOneByIndex(this.parentNode.parentNode.rowIndex);">삭제</div></td>'
	 								+'</tr>');
	 }else{
		 $("#spareListTable").append('<tr>'
									+	'<td>'
						 			+		'<input type="checkbox" id="selectOne" name="selectOne" onclick="doOpenCheck(this, this.parentNode.parentNode.rowIndex);"/>'
						 			+		'<input type="hidden" id="constructionIdx" name="constructionIdx" value="' + conIdx + '"/>'
						 			+		'<input type="hidden" id="status" name="status" value="0"/>'
						 			+	'</td>'
									+	'<td>삼각대</td>'
									+	'<td><input type="text" id="quantity" name="quantity" class="tdInput"  value=""/></td>'
									+	'<td><input type="text" id="bigo" name="bigo" class="tdInput" value=""/></td>'
									+   '<td><div class="deleteRow" onclick="deleteSpareOneByIndex(this.parentNode.parentNode.rowIndex);">삭제</div></td>'
									+'</tr>');
	 }
}

function getSpareDeviceList(){
	
	
	var conIdx = ${param.constructionIdx};
	var type = $("#spareDeviceSearchType option:selected").val();
	if(type == '2'){
		$('#spareDeviceControllBtnArea').css('display', 'none');
		$('#spareDeviceControllSaveArea').css('display', 'none');
	}else{
		$('#spareDeviceControllBtnArea').css('display', 'block');
		$('#spareDeviceControllSaveArea').css('display', 'block');
	}
	
	jQuery.ajax({
		type : "POST",
		contentType: "application/x-www-form-urlencoded; charset=UTF-8",
		url : "${pageContext.request.contextPath}/spare/device/get/list",
		data: {
			constructionIdx : conIdx,
			type : type
		}, 
		success : function(data) {
			$("#spareListTable tr").remove();
			if($("#spareDeviceSearchType option:selected").val() == '0' || $("#spareDeviceSearchType option:selected").val() == '2'){
				$("#spareListTable").append('<thead>'
											+ 	'<tr>'
											+ 		'<th style="width: 8%;">선택</th>'
											+ 		'<th style="width: 15%;">종류</th>'
											+ 		'<th style="width: 15%;">블루투스No</th>'
											+ 		'<th style="width: 15%;">측정기S/N</th>'
											+ 		'<th style="width: 12%;">상태</th>'
											+ 		'<th style="width: *%;";>비고</th>'
											+ 		'<th style="width: 15%;";>삭제</th>'
											+ 	'</tr>'
											+ '</thead>');
			 }else{
				 $("#spareListTable").append('<thead>'
				 							+	'<tr>'
				 							+ 		'<th style="width: 10%;">선택</th>'
				 							+		'<th style="width: 30%;">종류</th>'
				 							+		'<th style="width: 30%;">수량</th>'
				 							+		'<th style="width: *%;">비고</th>'
				 							+ 		'<th style="width: 15%;";>삭제</th>'
			 								+	'</tr>'
		 									+'</thead>');
			 }
			 $.each(data, function (i, item) {
				 if($("#spareDeviceSearchType option:selected").val() == '0' || $("#spareDeviceSearchType option:selected").val() == '2'){
					 $("#spareListTable").append('<tr>'
							 					+	'<td>'
							 					+		'<input type="checkbox" id="selectOne" name="selectOne" onclick="doOpenCheck(this, this.parentNode.parentNode.rowIndex);"/>'
					 							+		'<input type="hidden" id="constructionIdx" name="constructionIdx" value="' + conIdx + '"/>'
					 							+	'</td>'
					 							+	'<td>' + (item.type == 0 ? (item.status == 0 ? '예비용기기' : '교체장비') : '삼각대') + '</td>'
					 							+	'<td><input type="text" id="bluetoothNo" name="bluetoothNo" class="tdInput" disabled value="' + item.bluetoothNo + '"/></td>'
					 							+   '<td><input type="text" id="lavelNo" name="lavelNo" class="tdInput" disabled value="' + item.lavelNo + '"/></td>'
					 							+   '<td>'
					 							+   '    <select disabled id="status" name="status" class="tdInput">'
					 							+   '	    <option value="0"  '+  (item.status == 0 ? 'selected' : '') +'>예비용</option>'
					 							+   '	    <option value="1"  '+  (item.status == 1 ? 'selected' : '') +'>교체</option>'
					 							+   '   </select>'
					 							+   '</td>'
					 							+	'<td><input type="text" id="bigo" name="bigo" class="tdInput" disabled value="' + item.bigo + '"/></td>'
					 							+   '<td><div class="deleteRow" onclick="deleteSpareOneById(' + item.id + ');">삭제</div></td>'
				 								+'</tr>');
				 }else{
					 $("#spareListTable").append('<tr>'
											 	+	'<td>'
							 					+		'<input type="checkbox" id="selectOne" name="selectOne" onclick="doOpenCheck(this, this.parentNode.parentNode.rowIndex);"/>'
					 							+		'<input type="hidden" id="constructionIdx" name="constructionIdx" value="' + conIdx + '"/>'
					 							+		'<input type="hidden" id="status" name="status" value="0"/>'
					 							+	'</td>'
					 							+	'<td>' + (item.type == 0 ? '예비용기기' : '삼각대') + '</td>'
					 							+	'<td><input type="text" id="quantity" name="quantity" class="tdInput" disabled value="' +  + item.quantity + '"/></td>'
					 							+	'<td><input type="text" id="bigo" name="bigo" class="tdInput" disabled value="' + item.bigo + '"/></td>'
					 							+   '<td><div class="deleteRow" onclick="deleteSpareOneById(' + item.id + ');">삭제</div></td>'
				 								+'</tr>');
				 }
       		});
		},
		complete : function(data) {
			getSpareDeviceCount();
		},
		error : function(xhr, status, error) {
		}
	}); 
}


$('.popUp').hide();
$('.popLayer').hide();

$('.tableChange').on('click', function(e){
	openPop();
});

$('.popClose').on('click', function(e){
	closePop();
});


function openPop(){
	$('.popUp').show();
	$('.popLayer').show();
	$('body').css('overflow', 'hidden');
}

function closePop(){
	$('.popUp').hide();
	$('.popLayer').hide();
	$('body').css('overflow', 'auto');
}

$( function() {
   $(".datepicker").datepicker();
});

$(document).ready(function() {
	
	//alert('1111');
	//var totalWorkQuantity = $("#quantity").val();
	//alert('totalWorkQuantity : ' + totalWorkQuantity);
	//<p id="processRate"><span>공정률</span>&nbsp;&nbsp;${totalWorkQuantity.processRate}&nbsp;&nbsp;%</p>
	//<p id="quantityLeft"><span>남은수량</span>&nbsp;&nbsp;${totalWorkQuantity.quantityLeft}&nbsp;&nbsp;공</p>
	//<p id="executedQuantity"><span>시공수량</span>&nbsp;&nbsp;${totalWorkQuantity.executedQuantity}&nbsp;&nbsp;공</p>
	
	
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
	
	$(".c1").each(function(){
		var tempString = $(this).text();
		var c1_rows = $(".c1").filter(function(){
			return $(this).text() == tempString;
		});
		if(c1_rows.length > 1){
			c1_rows.eq(0).attr("rowspan", c1_rows.length);
			c1_rows.not(":eq(0)").remove();
		}
	});
	
	$(".c2").each(function(){
		var tempString = $(this).text();
		var c2_rows = $(".c2").filter(function(){
			return $(this).text() == tempString;
		});
		if(c2_rows.length > 1){
			c2_rows.eq(0).attr("rowspan", c2_rows.length);
			c2_rows.not(":eq(0)").remove();
		}
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
  	
$(document).on('click', "input[type='checkbox'][name='targetDeivceCk']", function(){
    if(this.checked) {
        const checkboxes = $("input[type='checkbox'][name='targetDeivceCk']");
        for(let ind = 0; ind < checkboxes.length; ind++){
            checkboxes[ind].checked = false;
        }
        this.checked = true;
    } else {
        this.checked = false;
    }
});
$(document).on('click', "input[type='checkbox'][name='changeDeivceCk']", function(){
    if(this.checked) {
        const checkboxes = $("input[type='checkbox'][name='changeDeivceCk']");
        for(let ind = 0; ind < checkboxes.length; ind++){
            checkboxes[ind].checked = false;
        }
        this.checked = true;
    } else {
        this.checked = false;
    }
}); 	
  	
  	


  	

</script>
<!-- 기록지 전체 출력: Excel / PDF 선택 모달 -->
<style>
.exportChoice-overlay { position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 99999; align-items: center; justify-content: center; }
.exportChoice-box { background: #fff; border-radius: 10px; padding: 24px 20px; width: 90%; max-width: 360px; box-shadow: 0 8px 24px rgba(0,0,0,0.25); box-sizing: border-box; text-align: center; }
.exportChoice-title { font-size: 16px; font-weight: bold; margin-bottom: 6px; color: #222; }
.exportChoice-desc { font-size: 13px; color: #666; margin-bottom: 18px; }
.exportChoice-btns { display: flex; gap: 10px; }
.exportChoice-btns button { flex: 1; height: 48px; border: none; border-radius: 6px; font-size: 15px; font-weight: bold; cursor: pointer; color: #fff; }
.exportChoice-excel { background: #258348; }
.exportChoice-pdf { background: #004058; }
.exportChoice-cancel { margin-top: 12px; background: none; border: none; color: #888; font-size: 13px; cursor: pointer; }
</style>
<div id="exportChoiceOverlay" class="exportChoice-overlay" style="display:none;">
	<div class="exportChoice-box">
		<div class="exportChoice-title">기록지 전체 출력</div>
		<div class="exportChoice-desc">출력 형식을 선택하세요.</div>
		<div class="exportChoice-btns">
			<button type="button" class="exportChoice-excel" onclick="exportAllExcel();">Excel</button>
			<button type="button" class="exportChoice-pdf" onclick="exportAllPdf();">PDF</button>
		</div>
		<button type="button" class="exportChoice-cancel" onclick="closeExportChoice();">취소</button>
	</div>
</div>

<!-- 기록지 PDF 생성 중 로딩 표시 -->
<style>
.pdfLoading-overlay { position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.55); z-index: 100000; align-items: center; justify-content: center; }
.pdfLoading-box { background: #fff; border-radius: 12px; padding: 30px 34px; text-align: center; box-shadow: 0 8px 24px rgba(0,0,0,0.3); }
.pdfLoading-spinner { width: 46px; height: 46px; margin: 0 auto 16px; border: 5px solid #e0e0e0; border-top-color: #004058; border-radius: 50%; animation: pdfSpin 0.9s linear infinite; }
@keyframes pdfSpin { to { transform: rotate(360deg); } }
.pdfLoading-title { font-size: 16px; font-weight: bold; color: #222; margin-bottom: 6px; }
.pdfLoading-desc { font-size: 13px; color: #777; }
</style>
<div id="pdfLoadingOverlay" class="pdfLoading-overlay" style="display:none;">
	<div class="pdfLoading-box">
		<div class="pdfLoading-spinner"></div>
		<div class="pdfLoading-title">기록지 PDF를 생성하고 있습니다</div>
		<div class="pdfLoading-desc">건수가 많으면 다소 시간이 걸릴 수 있습니다.<br/>창을 닫지 말고 잠시만 기다려 주세요.</div>
	</div>
</div>

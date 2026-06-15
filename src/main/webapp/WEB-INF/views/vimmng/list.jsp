<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/tagLib.jsp" %>
<script type="text/javascript">
$(function(){
	var menuIndex = ${menuIndex};
	var full_url = $(location).attr('href');
	var urls = full_url.split("?");
	var last_url = urls[1];
	//alert('last_url : ' + last_url + " , urls.length : " + urls.length);
	if(urls.length == 1){
		//alert('전체 협력사를 타고 들어온경우');
	}
	if(urls.length == 2){
		if (last_url.match("fcIdx")) {
			//가맹점 타고 들어온 경우
			//alert('가맹점 타고 들어온 경우');
			setGamengName();
		}else if(last_url.match("groupIdx")){
			//시공사를 타고 들어온 경우
			//alert('시공사를 타고 들어온 경우');
			setGroupName();
		}
	}
});

function setGamengName(){
	<c:choose>
	    <c:when test="${not empty param.fcIdx}">
	    var fcIdx = ${param.fcIdx};
	    </c:when>
	    <c:otherwise>
	    var	fcIdx = 0;
	    </c:otherwise>
	</c:choose>
	
	jQuery.ajax({
		type : "POST",
		contentType: "application/x-www-form-urlencoded; charset=UTF-8",
		url : "${pageContext.request.contextPath}/franchise/get/name",
		data: {
			fcIdx : fcIdx
		}, 
		success : function(data) {
			$('#listTitle').text(data + " 협력사 리스트");
		},
		complete : function(data) {
		},
		error : function(xhr, status, error) {
		}
	}); 
}

function setGroupName(){
	
	<c:choose>
	    <c:when test="${not empty param.groupIdx}">
	    var	groupIdx = ${param.groupIdx};
	    </c:when>
	    <c:otherwise>
	    var	groupIdx = 0;
	    </c:otherwise>
	</c:choose>
	
	jQuery.ajax({
		type : "POST",
		contentType: "application/x-www-form-urlencoded; charset=UTF-8",
		url : "${pageContext.request.contextPath}/group/get/name",
		data: {
			groupIdx : groupIdx
		}, 
		success : function(data) {
			$('#listTitle').text(data + " 협력사 리스트");
		},
		complete : function(data) {
		},
		error : function(xhr, status, error) {
		}
	}); 
}
</script>

		<!--컨텐츠-->
		<div class="section-right">
			<%@ include file="/WEB-INF/views/common/welcomeMsg.jsp" %>
			<div class="TopContArea">
				<div class="titArea">
					<p id="listTitle" class="h1Tit">빔파트너스(관리) 협력사 리스트</p>
				</div>
				<!--검색-->
				<form:form id="searchForm" commandName="domainParam" method="POST">
				<div class="searchArea">
					<div class="searchArea01">
						<form:select path="searchField">
		                	<form:option value="name">협력사</form:option>
		                	<form:option value="location">현장명</form:option>
		                    <form:option value="manager">현장담당자</form:option>
						</form:select>
						<form:input path="searchWord" class="searchin"  placeholder="검색어를 입력하세요."/>
						<form:hidden path="currentPage"/>
						<div class="searchBtn">
							<img id="submitBtn" src="${pageContext.request.contextPath}/new/img/search.png" style="cursor:pointer;" onclick="javascript:submitFun();">
						</div>
					</div>
					<div class="searchArea02">
						<form:input type="text" class="inputDate datepicker" path="startDate" placeholder="시작일"/>
						<span>~</span>
						<form:input type="text" class="inputDate datepicker" path="endDate" placeholder="종료일"/>
						<div class="searchBtn">
							<img src="${pageContext.request.contextPath}/new/img/search_date.png" style="cursor:pointer;" onclick="javascript:submitFun();">
						</div>
					</div>
				</div>
				</form:form>
			
			</div>
			
			<!--검색된 리스트 5개씩 노출-->
			<div class="listArea">
				<p class="listCount">노출된 <span>${fn:length(domainList)}</span>개의 리스트</p>
				
				<ul class="listUl two">
					<c:forEach var="domain" items="${domainList}"  varStatus="status">
					<li>
						<div class="listLeft">
							<p class="date">${domain.createDate}</p>
							<p class="name" 
								style="text-decoration: none;" onclick="location.href='${pageContext.request.contextPath}/device/list?constructionIdx=${domain.id}'">
								[${domain.name}] ${domain.location}
							</p>
							<p class="addr">${domain.address}</p>
							
							
						</div>
						<div class="listRight">
							<div class="info">
								<p class="manager">담당자 : ${domain.manager} (${domain.userId})</p>
								<p class="phoneNm">
									<img src="${pageContext.request.contextPath}/new/img/call.png" />
									${domain.contact}
								</p>
							</div>
							<c:choose>
							<c:when test="${sessionInfo.role == 0}">
								<div class="BtnArea">
									<a class="addBtn popBtn02" href="javascript:registDeviceInfo('${domain.id}')">
										<img src="${pageContext.request.contextPath}/new/img/filedown.png" />
										GPS파일 관리
									</a>
									 <a class="changeBtn popBtn03" href="javascript:getConstructionInfo('${domain.id}','${domain.fcIdx}');">
										<img src="${pageContext.request.contextPath}/new/img/user.png" />
										정보 변경하기
									</a>
								</div>
								
								<%-- <div class="BtnArea">
									 <a class="changeBtn popBtn03" href="" style="padding-top: 10px; padding-bottom: 10px;">
										<img src="${pageContext.request.contextPath}/new/img/filedown.png" />
										GPS파일 관리
									</a>
								</div> --%>
								
								<div class="selectArea">
									<select id="conductSel" class="state"  disabled="disabled" onchange="conductSel('${domain.id}', this.value)">
										<option value="0" ${domain.conduct == 0 ? 'selected="selected"' : '' }>시행</option>
										<option value="1" ${domain.conduct == 1 ? 'selected="selected"' : '' }>종료</option>
										<!-- <option value="2" ${domain.conduct == 2 ? 'selected="selected"' : '' }>가맹</option>-->
									</select>
								</div>
							</c:when>
							</c:choose>
							
						</div>
					</li>
					</c:forEach>
				</ul>
			</div>
			<!--//검색된 리스트 5개씩 노출-->

			<!--페이징-->			
			<%@ include file="/WEB-INF/views/common/pagination.jsp" %>
			<!--//페이징-->
			
<!-- 팝업 -->
<script>

var mode = null;

$('.popUp').hide();
$('.popLayer').hide();

$('.popBtn01').on('click', function(e){
	$('.popUp01').show();
	$('.popLayer').show();
	$('body').css('overflow', 'hidden');
});
$('.popBtn02').on('click', function(e){
	$('.popUp02').show();
	$('.popLayer').show();
	$('body').css('overflow', 'hidden');
});
$('.popClose').on('click', function(e){
	$('.popUp').hide();
	$('.popLayer').hide();
	$('body').css('overflow', 'auto');
});

$( function() {
   $(".datepicker").datepicker();
});
  
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
	
	 $('input[type="checkbox"][name="conduct"]').click(function(){          
		 
         if ($(this).prop('checked')) {
             $('input[type="checkbox"][name="conduct"]').prop('checked', false);
             $(this).prop('checked', true);
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

function deviceRegistFormCheck(){
	//숫자와 문자 포함 형태의 6~12자리 이내의 암호 정규식
	if($("#deviceRegistForm input[name='constructionIdx']").val() == 0){
		alert('시공사를 선택하세요.');
		return;
	}else if($("#deviceRegistForm input[name='tabletNo']").val() == ''){
		alert('PDAM테블릿 번호를 입력하세요.');
		return;
	}else if($("#deviceRegistForm input[name='machineNumber']").val() == ''){
		alert('호기번호를 입력하세요.');
		return;
	}else if($("#deviceRegistForm input[name='bluetoothNo']").val() == ''){
		alert('블루투스 번호를 입력하세요.');
		return;
	}else if($("#deviceRegistForm input[name='lavelNo']").val() == ''){
		alert('자동특정기 번호를 입력하세요.');
		return;
	}else if($("#deviceRegistForm input[name='tabletManager']").val() == ''){
		alert('WE매니저 이름을 입력하세요.');
		return;
	}else if($("#deviceRegistForm input[name='weContact']").val() == ''){
		alert('매니저 연락처를 입력하세요.');
		return;
	}else if($("#deviceRegistForm input[name='password']").val() == ''){
		alert('비밀번호를 입력하세요.');
		return;
	}else if($("#deviceRegistForm input[name='confirmPassword']").val() == ''){
		alert('확인 비밀번호를 입력하세요.');
		return;
	}else if($("#deviceRegistForm input[name='password']").val().length < 4){
		alert('4자리 이상의 비밀번호를 입력하세요.');
		$("#deviceRegistForm input[name='password']").focus();
		return false;
	}else if($("#deviceRegistForm input[name='confirmPassword']").val().length < 4){
		alert('4자리 이상의 비밀번호를 입력하세요.');
		$("#deviceRegistForm input[name='confirmPassword']").focus();
		return false;
	}else if($("#deviceRegistForm input[name='password']").val() != $("#deviceRegistForm input[name='confirmPassword']").val()){
		alert('비밀번호가 맞지 않습니다. 비밀번호를 확인하세요.');
		return;
	}else if($("#deviceRegistForm input[name='startDateI']").val() == ''){
		alert('시작일을 입력하세요.');
		return;
	}else if($("#deviceRegistForm input[name='endDateI']").val() == ''){
		alert('종료일을 입력하세요.');
		return;
	}else if($("#deviceRegistForm input[name='isDuplicate']").val() == 'false'){
		alert('PDAM테블릿 번호 중복확인을 체크하시기 바랍니다.');
		return;
	}
	$("#deviceRegistForm select[name='constructionIdx'] option").not(":selected").attr("disabled", "");
	$("#deviceRegistForm select[name='constructionIdx']").attr("disabled", "false"); //1.
	$("#deviceRegistForm select[name='constructionIdx']").removeAttr("disabled");  //2.
	
	var myObject = new Object(); 
	myObject.id = new Number(0);
	
	myObject.constructionIdx = new Number($("#deviceRegistForm select[name='constructionIdx'] option:selected").val());//시공사
	myObject.lavelNo = $("#deviceRegistForm input[name='lavelNo']").val();//자동측정기번호    
	myObject.bluetoothNo = $("#deviceRegistForm input[name='bluetoothNo']").val();//블루투스번호
	myObject.tabletNo = $("#deviceRegistForm input[name='tabletNo']").val();//PDAM 테블릿 번호
	myObject.password = $("#deviceRegistForm input[name='password']").val();//비밀번호
	myObject.tabletManager = $("#deviceRegistForm input[name='tabletManager']").val();//우리시스템 매니저
	myObject.weContact= $("#deviceRegistForm input[name='weContact']").val();//우리시스템 매니저 연락처
	myObject.startDate= $("#deviceRegistForm input[name='startDateI']").val();//시작일 
	myObject.endDate= $("#deviceRegistForm input[name='endDateI']").val();//종료일
	myObject.machineNumber= $("#deviceRegistForm input[name='machineNumber']").val();//호기
	myObject.name= '';
	myObject.conduct = new Number(0);//사업시행여부
	myObject.totalCnt = new Number(0);//총 시공수량
	myObject.todayCnt = new Number(0);//금일 시공수량
	myObject.yesterdayCnt = new Number(0);//하루전 시공수량
	
	var myString = JSON.stringify(myObject); 
	jQuery.ajax({
		type : "POST",
		url : "${pageContext.request.contextPath}/device/registAjax",
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

function pressContact(){
	$("#deviceRegistForm input[name='isDuplicate']").val("false");
}

function duplicateDevideContactCheck(){
	
	if($("#deviceRegistForm input[name='tabletNo']").val() == ''){
		alert('PDAM테블릿 번호를 입력하세요.');
		$("#deviceRegistForm input[name='tabletNo']").focus();
	} else {
		//연락처가 입력되었음.
		jQuery.ajax({
			type : "POST",
			url : "${pageContext.request.contextPath}/device/duplicate/tabletNo/confirm",
			data: { tabletNo: $("#deviceRegistForm input[name='tabletNo']").val() }, 
			dataType : "JSON", // 옵션이므로 JSON으로 받을게 아니면 안써도 됨
			success : function(data) {
				if(data.length > 0){
					alert("이미 등록된 PDAM테블릿 번호입니다.");
				}else{
					$("#deviceRegistForm input[name='isDuplicate']").val("true");
					alert("사용가능한 PDAM테블릿 번호입니다.");
				}
			},
			complete : function(data) {
			},
			error : function(xhr, status, error) {
			}
		});
	}
}

function openRegDevicePop(){
	$('.popUp02').show();
	$('.popLayer').show();
	$('body').css('overflow', 'hidden')
}

function registDeviceInfo(constructionIdx){
	openRegDevicePop();
	jQuery.ajax({
		type : "GET",
		url : "${pageContext.request.contextPath}/construction/get/list",
		dataType : "JSON", // 옵션이므로 JSON으로 받을게 아니면 안써도 됨
		success : function(data) {
			// 통신이 성공적으로 이루어졌을 때 이 함수를 타게 된다.
			// TODO
			if(data.length > 0){
				var role = ${sessionInfo.role};
				if(role > 0){
					$.each(data, function(index, item) {
						$("#deviceRegistForm input[name='constructionName']").val(item.name);
						$("#deviceRegistForm input[name='constructionIdx']").val(item.id);
					});
				}else{
					$("#deviceRegistForm select[name='constructionIdx']").append("<option value=\"0\">선택</option>");
					//$('#constructionIdx').append("<option value=\"0\">선택</option>");
					$.each(data, function(index, item) {
						/* $('#constructionIdx').append("<option value='" + item.id + "'>"+ item.name + "</option>"); */
						var idx = constructionIdx;
						if(item.id == idx){
							$("#deviceRegistForm select[name='constructionIdx']").append("<option selected=\"selected\" value='" + item.id + "'>"+ item.name + "</option>");
						}else{
							$("#deviceRegistForm select[name='constructionIdx']").append("<option value='" + item.id + "'>"+ item.name + "</option>");
						}
					});
				}
				
			}
			
		},
		complete : function(data) {
			// 통신이 실패했어도 완료가 되었을 때 이 함수를 타게 된다.
			//$('#ctmIdx').append("<option value=\"0\">선택</option>");
			//alert("서버와 통신에 실패했습니다. 계속 실패할 경우 관리자에게 문의하세요.");
		},
		error : function(xhr, status, error) {
			$("#deviceRegistForm select[name='constructionIdx']").append("<option value=\"0\">선택</option>");
			alert("에러발생");
		}
	});
}
function devieGetDevice(constructionIdx){
	
	
}
//협력사등록
function conRegistFormCheck(){

	if($("#regForm input[name='groupIdx']").val() == ''){
		alert('시공사를 선택하세요.');
		return;
	}else if($("#regForm input[name='name']").val() == ''){
		alert('협력사명을 입력하세요.');
		return;
	}else if($("#regForm input[name='location']").val() == ''){
		alert('현장명을 입력하세요.');
		return;
	}else if($("#regForm input[name='address']").val() == ''){
		alert('현장주소를 입력하세요.');
		return;
	}else if($("#regForm input[name='manager']").val() == ''){
		alert('현장담당자를 입력하세요.');
		return;
	}else if($("#regForm input[name='contact']").val() == ''){
		alert('연락처를 입력하세요.');
		return;
	}else if($("#regForm input[name='userId']").val() == ''){
		alert('아이디를 입력하세요.');
		return;
	}else if($("#regForm input[name='password']").val() == ''){
		alert('비밀번호를 입력하세요.');
		return;
	}else if($("#regForm input[name='isDuplicate']").val() == 'false'){
		alert('아이디 중복확인을 체크하시기 바랍니다.');
		return;
	}
	
	if($("#regForm input[name='password']").val() != '' && $("#regForm input[name='confirmPassword']").val() != '' ){
		//비밀번호가 입력되었다면
		if($("#regForm input[name='password']").val().length < 4){
			alert('4자리 이상의 비밀번호를 입력하세요.');
			return;
		}else if($("#regForm input[name='confirmPassword']").val().length < 4){
			alert('4자리 이상의 비밀번호를 입력하세요.');
			$('#confirmPassword').focus();
			return;
		}else if($("#regForm input[name='password']").val() != $("#regForm input[name='confirmPassword']").val()){
			alert('비밀번호를 다름니다. 비밀번호를 확인하세요.');
			$('#confirmPassword').focus();
			return;
		}
	}else{
		if($("#regForm input[name='password']").val() != ''){
			alert('확인 비밀번호를 입력하세요.');
			$('#confirmPassword').focus();
			return;
		}else if($("#regForm input[name='confirmPassword']").val() != ''){
			alert('비밀번호를 입력하세요.');
			$('#password').focus();
			return;
		}
	}
	registConstruction();
}

function registConstruction(){
	//var fcIdx = ${domainParam.fcIdx};
	var myObject = new Object(); 
	myObject.id = new Number(0);
	myObject.role = new Number(0);
	myObject.name = $("#regForm input[name='name']").val();
	myObject.location = $("#regForm input[name='location']").val();
	myObject.address = $("#regForm input[name='address']").val();
	myObject.manager = $("#regForm input[name='manager']").val();
	myObject.contact = $("#regForm input[name='contact']").val();
	myObject.userId = $("#regForm input[name='userId']").val();
	myObject.password = $("#regForm input[name='password']").val();
	myObject.secretCode = $("#regForm input[name='secretCode']").val();
	myObject.groupIdx = new Number($("#regForm input[name='groupIdx']").val());
	myObject.createDate = '';
	myObject.isDel = new Number(0);
	myObject.conduct = new Number(0);
	<c:choose>
	    <c:when test="${not empty param.fcIdx}">
	    var fcIdx = ${param.fcIdx};
	    myObject.fcIdx = new Number(fcIdx);
	    </c:when>
	    <c:otherwise>
	    myObject.fcIdx = new Number(0);
	    </c:otherwise>
	</c:choose>
	myObject.longCalYn = new Number($("#regForm select[name='longCalYn'] option:selected").val());
	myObject.ubcYn = new Number($("#regForm select[name='ubcYn'] option:selected").val());
	myObject.originDataYn = new Number($("#regForm select[name='originDataYn'] option:selected").val());
	myObject.showPdfYn = new Number($("#regForm select[name='showPdfYn'] option:selected").val());
	myObject.vimManaged = new Number($("#regForm select[name='vimManaged'] option:selected").val());
	
	var result = 0;
	jQuery.ajax({
		type : "POST",
		url : "${pageContext.request.contextPath}/construction/registAjax",
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
}


function hideChangeInfoPop(){
	$('.popUp').hide();
	$('.popLayer').hide();
	$('body').css('overflow', 'auto');
}
function showChangeInfoPop(){
	$('.popUp03').show();
	$('.popLayer').show();
	$('body').css('overflow', 'hidden');
}
function selectFcIdx(fcIdx){
	jQuery.ajax({
		type : "GET",
		url : "${pageContext.request.contextPath}/franchise/get/list",
		dataType : "JSON", // 옵션이므로 JSON으로 받을게 아니면 안써도 됨
		success : function(data) {
			$("#updateForm select[name='fcIdx'] option").remove();    
			if(data.length > 0){
				if(fcIdx == 0){
					$("#updateForm select[name='fcIdx']").append("<option value=\"0\" selected>없음</option>");
				}else{
					$("#updateForm select[name='fcIdx']").append("<option value=\"0\">없음</option>");
				}
				$.each(data, function(index, item) {
					//var fcIdx = '${domain.fcIdx}';
					if(fcIdx == item.idx){
						$("#updateForm select[name='fcIdx']").append("<option selected value='" + item.idx + "'>"+ item.fcName + "</option>");
					}else{
						$("#updateForm select[name='fcIdx']").append("<option value='" + item.idx + "'>"+ item.fcName + "</option>");
					}
				});
			}
		},
		complete : function(data) {
			// 통신이 실패했어도 완료가 되었을 때 이 함수를 타게 된다.
			//$('#ctmIdx').append("<option value=\"0\">선택</option>");
			//alert("서버와 통신에 실패했습니다. 계속 실패할 경우 관리자에게 문의하세요.");
		},
		error : function(xhr, status, error) {
			$("#updateForm select[name='fcIdx']").append("<option value=\"0\">선택</option>");
			alert("에러발생");
		}
	});
	//$("#updateForm select[name='fcIdx']").attr("disabled","disabled");
}


function selectFcIdxForConReg(fcIdx){
	jQuery.ajax({
		type : "GET",
		url : "${pageContext.request.contextPath}/franchise/get/list",
		dataType : "JSON", // 옵션이므로 JSON으로 받을게 아니면 안써도 됨
		success : function(data) {
			if(data.length > 0){
				if(fcIdx == 0){
					$("#regForm select[name='fcIdx']").append("<option value=\"0\" selected>없음</option>");
				}else{
					$("#regForm select[name='fcIdx']").append("<option value=\"0\">없음</option>");
				}
				$.each(data, function(index, item) {
					//var fcIdx = '${domain.fcIdx}';
					if(fcIdx == item.idx){
						$("#regForm select[name='fcIdx']").append("<option selected value='" + item.idx + "'>"+ item.fcName + "</option>");
					}else{
						$("#regForm select[name='fcIdx']").append("<option value='" + item.idx + "'>"+ item.fcName + "</option>");
					}
				});
			}
		},
		complete : function(data) {
			// 통신이 실패했어도 완료가 되었을 때 이 함수를 타게 된다.
			//$('#ctmIdx').append("<option value=\"0\">선택</option>");
			//alert("서버와 통신에 실패했습니다. 계속 실패할 경우 관리자에게 문의하세요.");
		},
		error : function(xhr, status, error) {
			$("#regForm select[name='fcIdx']").append("<option value=\"0\">선택</option>");
			alert("에러발생");
		}
	});
	
	$("#regForm select[name='fcIdx']").attr("disabled","disabled");
}
function getConstructionInfo(constructionIdx, fcIdx){
	
	showChangeInfoPop();
	selectFcIdx(fcIdx);
	var result;
	jQuery.ajax({
		type : "POST",
		url : "${pageContext.request.contextPath}/construction/get/infoOfAjax",
		async : false,  // 요청 시 동기화 여부. 기본은 비동기(asynchronous) 요청 (default: true)
		dataType : "JSON", // 옵션이므로 JSON으로 받을게 아니면 안써도 됨
		data:  {
			id : constructionIdx
		},
		success : function(data) {
			$("#updateForm input[name='groupIdx']").val(data.groupIdx);
			$("#updateForm input[name='groupName']").val(data.groupName);
			$("#updateForm input[name='id']").val(data.id);
			$("#updateForm input[name='name']").val(data.name);
			$("#updateForm input[name='location']").val(data.location);
			$("#updateForm input[name='address']").val(data.address);
			$("#updateForm input[name='manager']").val(data.manager);
			$("#updateForm input[name='contact']").val(data.contact);
			$("#updateForm input[name='userId']").val(data.userId);
			//$("#updateForm input[name='password']").val(data.password);
			//$("#updateForm input[name='confirmPassword']").val(data.password);
			$("#updateForm input[name='name']").val(data.name);
			$("#updateForm input[name='secretCode']").val(data.secretCode);
			$("#updateForm select[name='longCalYn']").val(data.longCalYn).prop("selected",true);
			$("#updateForm select[name='ubcYn']").val(data.ubcYn).prop("selected",true);
			$("#updateForm select[name='originDataYn']").val(data.originDataYn).prop("selected",true);
			$("#updateForm select[name='showPdfYn']").val(data.showPdfYn).prop("selected",true);
			$("#updateForm select[name='vimManaged']").val(data.vimManaged).prop("selected",true);
			
		},
		complete : function(data) {
			
		},
		error : function(xhr, status, error) {
			alert('error');
			$('.popUp').hide();
			$('.popLayer').hide();
			$('body').css('overflow', 'auto');
		}
	}); 
	
}

function updateConstruction(){	
	var name = $("#updateForm input[name='name']").val();
	var location = $("#updateForm input[name='location']").val();
	var address = $("#updateForm input[name='address']").val();
	var manager = $("#updateForm input[name='manager']").val();
	var password = $("#updateForm input[name='password']").val(); 
	var confirmPassword = $("#updateForm input[name='confirmPassword']").val(); 
	var contact = $("#updateForm input[name='contact']").val();
	var groupIdx = $("#updateForm input[name='groupIdx']").val();
	var groupName = $("#updateForm input[name='groupName']").val();
	var secretCode = $("#updateForm input[name='secretCode']").val();
	var fcIdx = $("#updateForm select[name='fcIdx'] option:selected").val();	
	var longCalYn = $("#updateForm select[name='longCalYn'] option:selected").val();	
	var ubcYn = $("#updateForm select[name='ubcYn'] option:selected").val();	
	var originDataYn = $("#updateForm select[name='originDataYn'] option:selected").val();	
	var showPdfYn = $("#updateForm select[name='showPdfYn'] option:selected").val();	
	var vimManaged = $("#updateForm select[name='vimManaged'] option:selected").val();	
	
	var id = $("#updateForm input[name='id']").val();
	var fcIdx = $("#updateForm select[name='fcIdx'] option:selected").val().trim();	
	
	if(groupIdx == '' || groupName == ''){
		alert('시공사를 선택하세요.');
		return;
	}else if(name == ''){
		alert('협력사명를 입력하세요.');
		$("#updateForm input[name='name']").focus();
		return;
	}else if(location == ''){
		alert('현장명을 입력하세요.');
		$("#updateForm input[name='location']").focus();
		return;
	}else if(address == ''){
		alert('현장주소를 입력하세요.');
		$("#updateForm input[name='address']").focus();
		return;
	}else if(manager == ''){
		alert('현장담당자를 입력하세요.');
		$("#updateForm input[name='manager']").focus();
		return;
	}else if(contact == ''){
		alert('연락처를 입력하세요.');
		$("#updateForm input[name='contact']").focus();
		return;
	}
	
	 if($("#updateForm input[name='password']").val() != '' && $("#updateForm input[name='confirmPassword']").val() != '' ){
		//비밀번호가 입력되었다면
		if($("#updateForm input[name='password']").val().length < 4){
			alert('4자리 이상의 비밀번호를 입력하세요.');
			$("#updateForm input[name='password']").focus();
			return;
		}else if($("#updateForm input[name='confirmPassword']").val().length < 4){
			alert('4자리 이상의 확인 비밀번호를 입력하세요.');
			$("#updateForm input[name='confirmPassword']").focus();
			return;
		}else if($("#updateForm input[name='password']").val() != $("#updateForm input[name='confirmPassword']").val()){
			alert('비밀번호를 다름니다. 비밀번호를 확인하세요.');
			$("#updateForm input[name='confirmPassword']").focus();
			return;
		}
	}else{
		if($("#updateForm input[name='password']").val() != ''){
			alert('비밀번호를 입력하세요.');
			$("#updateForm input[name='confirmPassword']").focus();
			return;
		}else if($("#updateForm input[name='confirmPassword']").val() != ''){
			alert('확인 비밀번호를 입력하세요.');
			$("#updateForm input[name='password']").focus();
			return;
		}
	}
	 
	var myObject = new Object(); 
	myObject.id = new Number(id);
	myObject.role =  new Number(0);
	myObject.name = name;
	myObject.location = location;
	myObject.address = address;
	myObject.manager = manager;
	myObject.contact = contact;
	myObject.userId = '';
	myObject.password = password; 
	myObject.secretCode = secretCode;
	myObject.groupIdx = new Number(groupIdx);	
	myObject.createDate = '';
	myObject.isDel =  new Number(0);
	myObject.conduct =  new Number(0);
	myObject.fcIdx = new Number(fcIdx);
	myObject.longCalYn = new Number(longCalYn);	
	myObject.ubcYn = new Number(ubcYn);
	myObject.originDataYn = new Number(originDataYn);
	myObject.showPdfYn = new Number(showPdfYn);
	myObject.vimManaged = new Number(vimManaged);
	//업데이트 
	var myString = JSON.stringify(myObject); 
	jQuery.ajax({
		type : "POST",
		url : "${pageContext.request.contextPath}/construction/updateForAjax",
	    contentType : "application/json",
		async : false,  // 요청 시 동기화 여부. 기본은 비동기(asynchronous) 요청 (default: true)
		data:  JSON.stringify(myObject),
		success : function(data) {
			hideChangeInfoPop();
			submitFun();
		},
		complete : function(data) {
			hideChangeInfoPop();
		},
		error : function(xhr, status, error) {
			hideChangeInfoPop();
		}
	});
	return;

}

$(document).ready(function() {
	
	getGroupList();
	
	var paramGroupIdx = ${domainParam.groupIdx};
	
	
    jQuery.ajax({
		type : "GET",
		url : "${pageContext.request.contextPath}/group/get/list",
		dataType : "JSON", // 옵션이므로 JSON으로 받을게 아니면 안써도 됨
		success : function(data) {
			if(data.length > 0){
				//$("#regForm select[name='groupIdx']").append("<option value=\"0\">선택</option>");
				$.each(data, function(index, item) {
					if(paramGroupIdx == item.idx){
						 $("#regForm input[name='groupIdx']").val(item.idx);
					     $("#regForm input[name='groupName']").val(item.groupName);
					     $("#regForm input[name='groupName']").attr("disabled", true);
					}
				});
				
				$("#updateForm select[name='groupIdx']").append("<option value=\"0\">선택</option>");
				$.each(data, function(index, item) {
					if(paramGroupIdx == item.idx){
						$("#updateForm select[name='groupIdx']").append("<option value='" + item.idx + "' selected>"+ item.groupName + "</option>");
					}else{
						$("#updateForm select[name='groupIdx']").append("<option value='" + item.idx + "'>"+ item.groupName + "</option>");
					}	
					
				});
			}
		},
		complete : function(data) {
			// 통신이 실패했어도 완료가 되었을 때 이 함수를 타게 된다.
			//$('#ctmIdx').append("<option value=\"0\">선택</option>");
			//alert("서버와 통신에 실패했습니다. 계속 실패할 경우 관리자에게 문의하세요.");
		},
		error : function(xhr, status, error) {
			$('#groupIdx').append("<option value=\"0\">선택</option>");
		}
	}); 
    
    <c:choose>
	    <c:when test="${not empty param.fcIdx}">
		    var fcIdx = ${param.fcIdx};
		    selectFcIdxForConReg(fcIdx);
	    </c:when>
	</c:choose>
   
});

function submitFun(){
	$('#searchForm').submit();
}

function duplicateContactCheck(){
	
	if($('#userId').val() == ''){
		alert('연락처를 입력하세요.');
		$('#userId').focus();
	} else {
		//연락처가 입력되었음.
		jQuery.ajax({
			type : "POST",
			url : "${pageContext.request.contextPath}/construction/duplicate/contact/confirm",
			data: { userId: $('#userId').val() }, 
			dataType : "JSON", // 옵션이므로 JSON으로 받을게 아니면 안써도 됨
			success : function(data) {
				if(data.length > 0){
					alert("이미 등록된 아아디입니다.");
				}else{
					$('#isDuplicate').val("true");
					alert("사용가능한 아이디입니다.");
				}
			},
			complete : function(data) {
			},
			error : function(xhr, status, error) {
			}
		});
	}
}
	
function conductSel(idx, selectVal){
	
	var statusMsg = "";
	if(selectVal == '0'){
		statusMsg = "시행";
	}else if(selectVal == '1'){
		statusMsg = "종료";
	}else{
		statusMsg = "가맹";
	} 

	var result = confirm(statusMsg +  ' 상태로 변경하시겠습니까?');
	if(result){
		
		jQuery.ajax({
			type : "POST",
			url : "${pageContext.request.contextPath}/construction/update/conduct",
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
	

function getGroupList(){
	jQuery.ajax({
		type : "GET",
		url : "${pageContext.request.contextPath}/group/get/list",
		dataType : "JSON", // 옵션이므로 JSON으로 받을게 아니면 안써도 됨
		async : false,
		success : function(data) {
			$("#ajaxGroupTable").dataTable({
				 autoWidth : false,
			 	 data : data,
			 	 columns: [
			 		{ data : "",  width : '65px' ,
			    		render: function(data,type,row){
			    			return "<input type=\"button\" style=\"width:60px;\" id=\"btn_info\" value=\"선택\" onclick=\"javascript:setGroupInfo('"+row.idx+"','"+row.groupName+"')\"/>";
			    			
			    		}
			    	}, 
			  		{ data: 'groupName'  }
			  		
			  	],
			  	
			    "language": {
			        "decimal" : "",
			        "emptyTable" : "데이터가 없습니다.",
			        "info" : "_START_ - _END_ (총 _TOTAL_ 명)",
			        "infoEmpty" : "0명",
			        "infoFiltered" : "(전체 _MAX_ 명 중 검색결과)",
			        "infoPostFix" : "",
			        "thousands" : ",",
			        "lengthMenu" : "_MENU_ 개씩 보기",
			        "loadingRecords" : "로딩중...",
			        "processing" : "처리중...",
			        "search" : "검색 : ",
			        "zeroRecords" : "검색된 데이터가 없습니다.",
			        "paginate" : {
			            "first" : "첫 페이지",
			            "last" : "마지막 페이지",
			            "next" : "다음",
			            "previous" : "이전"
			        },
			        "aria" : {
			            "sortAscending" : " :  오름차순 정렬",
			            "sortDescending" : " :  내림차순 정렬"
			        }
			    }
			});
			
			//$('#ajaxGroupTable tbody').on('dblclick', 'tr', function () {
	    	//});
		},
		complete : function(data) {
		},
		error : function(xhr, status, error) {
		}
	});
}

function setGroupInfo(idx, groupName){
	 var table = $('#ajaxGroupTable').DataTable();
	 var data = table.row( this ).data();
	 //팝업의 숨김여부에 따라서 groupIdx, groupName 값 부여 form  이 달라진다.
	 var popUp01 = $('.popUp01').is(':visible');
	 var popUp03 = $('.popUp03').is(':visible');
	 if(popUp01){
		 $("#regForm input[name='groupIdx']").val(idx);
	     $("#regForm input[name='groupName']").val(groupName);
	 }else{
		 $("#updateForm input[name='groupIdx']").val(idx);
	     $("#updateForm input[name='groupName']").val(groupName);
	 }
     closePop();
}

function openPop() {
    document.getElementById("popup_layer").style.display = "block";
}

//팝업 닫기
function closePop() {
    document.getElementById("popup_layer").style.display = "none";

}
</script>

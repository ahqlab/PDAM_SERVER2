<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/tagLib.jsp" %>
<script type="text/javascript">
$( document ).ready( function() {
	getGroupList();
    $('#submitBtn').click( function() {
    	$('#searchForm').submit();
    	
    });
});
function onSMfrChange(){
	$('#searchForm').submit();	   
}

function onClickDeleteBtn(idx){
	var result = confirm('삭제하시겠습니까?');
	if(result){
		location.href='${pageContext.request.contextPath}/treport/delete?id=' + idx;
	}
}


function getGroupList(){
	
	jQuery.ajax({
		type : "GET",
		url : "${pageContext.request.contextPath}/customer/get/list",
		dataType : "JSON", // 옵션이므로 JSON으로 받을게 아니면 안써도 됨
		async : false,
		success : function(data) {
			 var table =  $("#ajaxGroupTable").dataTable({
				 autoWidth : false,
				 table: null,
			 	 data : data,
			 	 columns: [
			  		{ 
			  			width: "15%",
		 				data: 'groupName'
		 			},
		 			{ 
		 				width: "15%",
		 				data: 'conName' 
		 			},
		 			{
		 				width: "15%",
		 				data: 'conLocation'
		 			},
		 			{
		 				width: "15%",
		 				data: 'conManager'
		 			},
		 			{
		 				width: "15%",
		 				data: 'conContact'
		 			},
		 			{
		 				data:  null,
		 				render : function(data, type, row, meta) {
		 					//var data = table.fnGetData( this );
		 					var deleteUrl = '${pageContext.request.contextPath}/customer/delete?id=' + row.id;
					    	return "<a href=\"javascript:showUpdateDialog('" + row.id + "','"  + row.groupName + "','"  + row.conName + "','"  + row.conLocation + "','"  + row.conManager + "','"  + row.conContact + "')\">[수정]</a>";
		 				}
		 			},
		 			{
		 				data:  null,
		 				render : function(data, type, row, meta) {
		 					var deleteUrl = '${pageContext.request.contextPath}/customer/delete?id=' + row.id;
					    	return "<a href=\"javascript:deleteCustomer('" + deleteUrl + "','"  + row.id + "')\">[삭제]</a>";
		 				}
		 			}
			  		
			  	],
			  	order: {
			        name: 'id',
			        dir: 'desc'
			    },
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
			
			table.on('click','tbody tr',function() {
				
				/* $('.popUp02').show();
				$('.popLayer').show();
				$('body').css('overflow', 'hidden');
				
				var data = table.fnGetData( this );
				
				if(data.id == 0){
					$("#updateForm input[name='groupName']").attr("readonly",true); 
					$("#updateForm input[name='conName']").attr("readonly",true); 
					$("#updateForm input[name='conLocation']").attr("readonly",true); 
					$("#updateForm input[name='conManager']").attr("readonly",true); 
					$("#updateForm input[name='conContact']").attr("readonly",true); 
				}
				
				$("#updateForm input[name='id']").val(data.id);
				$("#updateForm input[name='groupName']").val(data.groupName);
				$("#updateForm input[name='conName']").val(data.conName);
				$("#updateForm input[name='conLocation']").val(data.conLocation);
				$("#updateForm input[name='conManager']").val(data.conManager);
				$("#updateForm input[name='conContact']").val(data.conContact); */
				
				
		    });
		},
		complete : function(data) {
		},
		error : function(xhr, status, error) {
		}
	});
}


function showUpdateDialog(id , groupName, conName , conLocation , conManager, conContact ){
	
	$('.popUp02').show();
	$('.popLayer').show();
	$('body').css('overflow', 'hidden');
	
	if(id == '0'){
		$("#updateForm input[name='groupName']").attr("readonly",true); 
		$("#updateForm input[name='conName']").attr("readonly",true); 
		$("#updateForm input[name='conLocation']").attr("readonly",true); 
		$("#updateForm input[name='conManager']").attr("readonly",true); 
		$("#updateForm input[name='conContact']").attr("readonly",true); 
	}else{
		$("#updateForm input[name='groupName']").attr("readonly",false); 
		$("#updateForm input[name='conName']").attr("readonly",false); 
		$("#updateForm input[name='conLocation']").attr("readonly",false); 
		$("#updateForm input[name='conManager']").attr("readonly",false); 
		$("#updateForm input[name='conContact']").attr("readonly",false); 
	}
	
	$("#updateForm input[name='id']").val(id);
	$("#updateForm input[name='groupName']").val(groupName);
	$("#updateForm input[name='conName']").val(conName);
	$("#updateForm input[name='conLocation']").val(conLocation);
	$("#updateForm input[name='conManager']").val(conManager);
	$("#updateForm input[name='conContact']").val(conContact); 
}

function deleteCustomer(url, id){
	
	if(id == 0){
		alert('삭제할 수 없습니다.');
		return;
	}

	if(confirm("삭제하시겠습니까?")){
		jQuery.ajax({
			type : "GET",
			url : url,
			dataType : "JSON", // 옵션이므로 JSON으로 받을게 아니면 안써도 됨
			success : function(data) {
				if(data > 0){
					$('#ajaxGroupTable').DataTable().destroy();
				     getGroupList();
				}
			},
			complete : function(data) {
				
			},
			error : function(xhr, status, error) {
				
			}
		});
	}
}


function updateFormCheck(){
	if($("#updateForm input[name='conManager']").val() == ''){
		alert('관리자를 입력하세요.');
		return;
	}else if($("#updateForm input[name='conContact']").val() == ''){
		alert('전화번호를 입력하세요.');
		return;
	}
	
	if($("#updateForm input[name='id']").val() == '0'){
		alert('수정할 수 없습니다.');
		return;
	}
	
	var myObject = new Object(); 
 	myObject.id = new Number($("#updateForm input[name='id']").val());
	myObject.groupName = $("#updateForm input[name='groupName']").val();
	myObject.conName = $("#updateForm input[name='conName']").val();
	myObject.conLocation = $("#updateForm input[name='conLocation']").val();
	myObject.conManager = $("#updateForm input[name='conManager']").val();
	myObject.conContact = $("#updateForm input[name='conContact']").val();
	
	var myString = JSON.stringify(myObject); 
	
	
	jQuery.ajax({
		type : "POST",
		url : "${pageContext.request.contextPath}/customer/update",
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
				 $('#ajaxGroupTable').DataTable().destroy();
			     getGroupList();
			     $("#updateForm")[0].reset();
				
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


function formCheck(){
	//숫자와 문자 포함 형태의 6~12자리 이내의 암호 정규식
	if($("#regForm input[name='conManager']").val() == ''){
		alert('관리자를 입력하세요.');
		return;
	}else if($("#regForm input[name='conContact']").val() == ''){
		alert('전화번호를 입력하세요.');
		return;
	}
	
 	var myObject = new Object(); 
 	myObject.id = new Number(0);
	myObject.groupName = $("#regForm input[name='groupName']").val();
	myObject.conName = $("#regForm input[name='conName']").val();
	myObject.conLocation = $("#regForm input[name='conLocation']").val();
	myObject.conManager = $("#regForm input[name='conManager']").val();
	myObject.conContact = $("#regForm input[name='conContact']").val();
	
	var myString = JSON.stringify(myObject); 
	alert('myString : ' + myString);
	
	jQuery.ajax({
		type : "POST",
		url : "${pageContext.request.contextPath}/customer/regist",
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
				 $('#ajaxGroupTable').DataTable().destroy();
			     getGroupList();
			     $("#regForm")[0].reset();
				
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


</script>
<!--컨텐츠-->
		<div class="section-right">
			<%@ include file="/WEB-INF/views/common/welcomeMsg.jsp" %>
			<div class="TopContArea">
				<div class="titArea mb-40">
					<p class="h1Tit">고객관리</p>
					<%-- <div class="popBtn" onclick="location.href='${pageContext.request.contextPath}/fileinventory/regist2?constructionIdx=${param.constructionIdx}&pileType=PHC'">파일 등록</div> --%>
				</div>
				
				<!--검색-->
				<%-- <form:form id="searchForm" commandName="domainParam" method="POST">
					<form:hidden path="currentPage"/>
						<div class="searchArea">
							<div class="searchArea01" style="width: 100%;">
								<form:input path="searchWord" class="searchin"  style="width:30%;" placeholder="검색어를 입력하세요."/>
								<div class="searchBtn">
									<img id="submitBtn" src="${pageContext.request.contextPath}/new/img/search.png" style="cursor:pointer;">
								</div>
							</div>
						</div>
				</form:form> --%>
			</div>

			<!--공지리스트-->
			<div class="min531">
				<div class="tableArea">
					<div class="viewTable viewTable01">
						<div class="tableScroll">
							<div class="viewTable">
								<table id="ajaxGroupTable">
									<thead>
										<tr class="viewTh">
											<th scope="col" style="text-align: center; width: 15%;">시공사</th>
											<th scope="col" style="text-align: center; width: 15%;">협력사</th>
											<th scope="col" style="text-align: center; width: 15%;">현장주소</th>
											<th scope="col" style="text-align: center; width: 15%;">관리자</th>
											<th scope="col" style="text-align: center; width: 15%;">연락처</th>
											<th scope="col" style="text-align: center;">수정</th>
											<th scope="col" style="text-align: center;">삭제</th>
										</tr> 
									</thead>
									<tbody>
									
									</tbody>
								</table>
							</div>
						</div>
					</div>
				</div>
			</div>
			<!--//공지리스트-->
			
			<%-- <a class="goWrite popBtn01" href="${pageContext.request.contextPath}/customer/regist">등록</a> --%>
			<a class="goWrite popBtn popBtn01">등록</a>
		</div>
		
		<div class="popUp popUp01">
			<form id="regForm" name="regForm" method="POST" >
			<div class="popTit">
				<p>고객등록</p>
				<img class="popClose" src="${pageContext.request.contextPath}/new/img/popclose.png" />
			</div>
			<div class="popCont">
				<div class="inputArea02 mb-20">
					<p class="inputTxt02">시공사</p>
					<input type="text" autocomplete="off"  class="Input02" name="groupName" id="groupName" placeholder="시공사명을 입력하세요.">
				</div>
				<div class="inputArea02 mb-20">
					<p class="inputTxt02">협력사</p>
					<input type="text" autocomplete="off"  class="Input02" name="conName" id="conName" placeholder="협력사명을 입력하세요.">
				</div>
				<div class="inputArea02 mb-20">
					<p class="inputTxt02">현장주소</p>
					<input type="text" autocomplete="off"  class="Input02" name="conLocation" id="conLocation" placeholder="현장주소를 입력하세요.">
				</div>
				<div class="inputArea02 mb-20">
					<p class="inputTxt02">관리자</p>
					<input type="text" autocomplete="off"  class="Input02" name="conManager" id="conManager" placeholder="관리자 이름을 입력하세요.">
				</div>
				<div class="inputArea02 mb-20">
					<p class="inputTxt02">연락처</p>
					<input type="text" autocomplete="off"  class="Input02" name="conContact" id="conContact" placeholder="관리자 연락처를 입력하세요.">
				</div>
				<div class="popAdd" onclick="return formCheck();">등록</div>
			</div>
			</form>
		</div>
		<div class="popLayer" style=""></div>
		
		<div class="popUp popUp02">
			<form id="updateForm" name="updateForm" method="POST" >
			<div class="popTit">
				<p>고객수정</p>
				<img class="popClose" src="${pageContext.request.contextPath}/new/img/popclose.png" />
			</div>
			<div class="popCont">
				<div class="inputArea02 mb-20">
					<p class="inputTxt02">시공사</p>
					<input type="hidden" name="id">
					<input type="text" autocomplete="off"  class="Input02" name="groupName" id="groupName" placeholder="시공사명을 입력하세요.">
				</div>
				<div class="inputArea02 mb-20">
					<p class="inputTxt02">협력사</p>
					<input type="text" autocomplete="off"  class="Input02" name="conName" id="conName" placeholder="협력사명을 입력하세요.">
				</div>
				<div class="inputArea02 mb-20">
					<p class="inputTxt02">현장주소</p>
					<input type="text" autocomplete="off"  class="Input02" name="conLocation" id="conLocation" placeholder="현장주소를 입력하세요.">
				</div>
				<div class="inputArea02 mb-20">
					<p class="inputTxt02">관리자</p>
					<input type="text" autocomplete="off"  class="Input02" name="conManager" id="conManager" placeholder="관리자 이름을 입력하세요.">
				</div>
				<div class="inputArea02 mb-20">
					<p class="inputTxt02">연락처</p>
					<input type="text" autocomplete="off"  class="Input02" name="conContact" id="conContact" placeholder="관리자 연락처를 입력하세요.">
				</div>
				<div class="popAdd" onclick="return updateFormCheck();">수정</div>
			</div>
			</form>
		</div>
		
		
		<!--//컨텐츠-->
<!-- 팝업 -->
<script>
$('.popUp01').hide();
$('.popUp02').hide();
$('.popLayer').hide();

$('.popBtn01').on('click', function(e){
	$('.popUp01').show();
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
	
	
	//$("#ajaxGroupTable  tr").click(function(){
	//	  alert($("#ajaxGroupTable").row(this).data());
	//});


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
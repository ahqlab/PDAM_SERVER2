<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/tagLib.jsp" %>
<script type="text/javascript">
$( document ).ready( function() {
	
	var mgs = '${msg}';
	if(mgs != ''){
		alert(mgs);
	}
	
    $('#submitBtn').click( function() {
    	$('#searchForm').submit();
    	
    });
    
    $('#printBtn').click( function() {
    	var url = '${pageContext.request.contextPath}/pqpm/download?constructionIdx=${param.constructionIdx}';
    	document.location.href = url;
    });
    
    $('#file').on('change', function() {
		var files = $(this)[0].files[0];
		var fake = $('.upload-name');
		
		fake.val('');
		if ( files != 'undefined' ) {
			fake.val(files.name);
		}
	});
});


function onClickGpsUpdate(){
	
	var pqpms = [];
	var constructionIdx = ${param.constructionIdx};
	
	for (var i = 0; i < $('#pqpmTable tr').length; i++) {
		//check box 선택여부
		if (!$('#pqpmTable tr').eq(i).find('#selectOne').is(':checked')) {
			continue;
		}
		var data = {
			id: Number($('#pqpmTable tr').eq(i).find('#id').val()), 
			constructionIdx : Number(constructionIdx), 
			localName : $('#pqpmTable tr').eq(i).find('#localName').val() != "" ? $('#pqpmTable tr').eq(i).find('#localName').val() : "null", 
			planCount : $('#pqpmTable tr').eq(i).find('#planCount').val() != "" ? $('#pqpmTable tr').eq(i).find('#planCount').val() : "null", 
			localReport : $('#pqpmTable tr').eq(i).find('#localReport').val() != "" ? $('#pqpmTable tr').eq(i).find('#localReport').val() : "null", 
		}
		pqpms.push(data);
		
	}
	
	if(pqpms.length == 0){
		alert('선택된 항목이 없습니다.');
		reports = [];
		return;
	}
	
	var result = confirm("수정하시겠습니까?");
	if(result){
		jQuery.ajax({
			type : "POST",
			url : "${pageContext.request.contextPath}/pqpm/update/fileMulti",
			data: JSON.stringify(pqpms), 
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

function doOpenCheck(chk, rowindex) {
	
	
	var index = getCheckdCheckboxIndex();
	
	var total = $("input[name=selectOne]").length;
	var checked = $("input[name=selectOne]:checked").length;
	
	if(total != checked){
		$("#chkAll").prop("checked", false);
	}else{
		$("#chkAll").prop("checked", true); 
	}
	
	
	var obj = document.getElementsByName("selectOne");
	var index = rowindex - 1;
	
	var id = document.getElementsByName("id");
	var localName = document.getElementsByName("localName");
	var planCount = document.getElementsByName("planCount");
	var localReport = document.getElementsByName("localReport");
	
	if(obj[index].checked){
		
		localName[index].disabled = false;
		planCount[index].disabled = false;
		localReport[index].disabled = false;
		
	}else{
		
		localName[index].disabled = true;
		planCount[index].disabled = true;
		localReport[index].disabled = true;
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


function onClickChkAll(){
	if($("#chkAll").is(":checked")){
		$("input[name=selectOne]").prop("checked", true);
		for (var i = 0; i < $('#pqpmTable tr').length; i++) {
			doOpen(i);
		}
	} else {
		$("input[name=selectOne]").prop("checked", false);
		for (var i = 0; i < $('#pqpmTable tr').length; i++) {
			doClose(i);
		}
	}
}


function doOpen(rowindex){
	
	var localName = document.getElementsByName("localName");
	var planCount = document.getElementsByName("planCount");
	var localReport = document.getElementsByName("localReport");

	
	localName[rowindex].disabled = false;
	planCount[rowindex].disabled = false;
	localReport[rowindex].disabled = false;

	
}


function doClose(rowindex){
	
	var localName = document.getElementsByName("localName");
	var planCount = document.getElementsByName("planCount");
	var localReport = document.getElementsByName("localReport");

	
	localName[rowindex].disabled = true;
	planCount[rowindex].disabled = true;
	localReport[rowindex].disabled = true;
	
	
}


function onClickFileDelete(idx){
	var result = confirm("삭제하시겠습니까?");
	if(result){
		jQuery.ajax({
			type : "POST",
			url : "${pageContext.request.contextPath}/pqpm/doDelete",
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

</script>
<!--컨텐츠-->
		<div class="section-right">
			<div class="TopContArea">
				<div class="titArea mb-40">
					<p class="h1Tit">파일수량 관리계획</p>
						<div id="printBtn" class="printBtn">CSV다운로드</div>
				</div>
				
				<!--검색-->
				<form:form id="searchForm" commandName="domainParam" method="POST">
					<form:hidden path="currentPage"/>
						<div class="searchArea">
							<div class="searchArea01" style="width: 100%;">
								<form:select class="select01" path="searchField" onchange="">
				                	<form:option value="localName">위치정보</form:option>
				                	<form:option value="planCount">계획수량</form:option>
				                	<form:option value="localReport">동별참고사항</form:option>
								</form:select>
								<form:input path="searchWord" class="searchin"  style="width:30%;" placeholder="검색어를 입력하세요."/>
								<div class="searchBtn">
									<img id="submitBtn" src="${pageContext.request.contextPath}/new/img/search.png" style="cursor:localNameer;">
								</div>
							</div>
						</div>
				</form:form>
			</div>
			
			<!--공지리스트-->
			<div class="viewTable viewTable01">
				<div>
					<table class="pqpmTable" id="pqpmTable">
						<colgroup>
							<col width="10%;">
							<col width="20%;">
							<col width="20%;">
							<col width="40%;">
							<col width="10%;">
							<!-- <col width="*%;"> -->
						</colgroup>
						<tr class="viewTh">
							<th scope="col"><input type="checkbox" id="chkAll"
								name="chkAll" onclick="javascript:onClickChkAll();"></th>
							<th scope="col" style="padding: 15px 0px 15px 0px;">위치정보</th>
							<th scope="col">계획수량</th>
							<th scope="col">동별참고사항</th>
							<th scope="col">삭제</th>
						</tr>
						<!--리스트 한페이지에 최대10개-->
						<c:forEach var="domain" items="${domainList}" varStatus="status">
							<tr>
								<td><input type="checkbox" id="selectOne" name="selectOne"
									onclick="doOpenCheck(this, this.parentNode.parentNode.rowIndex);"
									style="margin: 0; padding: 0;"> <input type="hidden"
									id="id" name="id" disabled="disabled" class="tdInput"
									value="${domain.id}"></td>
								<td><input type="text" id="localName" name="localName"
									disabled="disabled" class="tdInput" value="${domain.localName}"></td>
								<td><input type="text" id="planCount" name="planCount"
									disabled="disabled" class="tdInput" value="${domain.planCount}"></td>
								<td><input type="text" id="localReport" name="localReport"
									disabled="disabled" class="tdInput" value="${domain.localReport}"></td>
								<td><a href="javascript:onClickFileDelete('${domain.id}');">X</a></td>	
							</tr>
						</c:forEach>
						<c:choose>
							<c:when test="${fn:length(domainList) == 0}">
								<tr>
									<td colspan="8">등록된 데이터가 없습니다.</td>
								</tr>
							</c:when>
						</c:choose>
		
					</table>
				</div>
			</div>
		
			<div style="float: right; margin-top: 10px;">
				<input type="button" onclick="location.href='${pageContext.request.contextPath}/pqpm/regist?constructionIdx=${param.constructionIdx}';" value="등록" style="width: 95px; height: 30px; background: #077b9c; border: solid #077b9c 1px; border-radius: 5px; text-align: center; color: white;">
				<input type="button" onclick="javascript:onClickGpsUpdate();" value="수정" style="width: 95px; height: 30px; background: #760a2d; border: solid #760a2d 1px; border-radius: 5px; text-align: center; color: white;">
			</div>		
			<br>
			<%@ include file="/WEB-INF/views/common/pagination.jsp"%>			
			
		</div>
		<!--//컨텐츠-->
<!-- 팝업 -->
<script>
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
$('.popBtn03').on('click', function(e){
	$('.popUp03').show();
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
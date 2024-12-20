<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/tagLib.jsp" %>
<script type="text/javascript">
$( document ).ready( function() {
    $('#submitBtn').click( function() {
    	$('#searchForm').submit();
    });
    
    
    getPileTypeList();
  });
  
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
					 //var valueOption = item.pileType + "|" + item.pileStandard;
				 }else{
					 var option = item.pileType + " " + item.fileWeight + " " + item.pileStandard;
					// var valueOption = item.pileType + "|" + item.fileWeight + "|" + item.pileStandard;
				 }
                 $("#select1").append("<option class='text-success text-center' value='"+option+"'>"+option+"</option>");
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


function deleteConfirm(url){
	var result = confirm("삭제하시겠습니까?");
	if(result){
		document.location.href=url;
	}
}

function getConstructionName(){
	
	var idx = ${param.constructionIdx};
	jQuery.ajax({
		type : "POST",
		contentType: "application/x-www-form-urlencoded; charset=UTF-8",
		url : "${pageContext.request.contextPath}/construction/get/name",
		data: {
			id : idx
		}, 
		success : function(data) {
			$('#constructionSetName').text(data);
		},
		complete : function(data) {
		},
		error : function(xhr, status, error) {
		}
	}); 
}

function onPileTypeChange(value){
	
	// || value =="SPHC"
	if(value =="PHC" || value == "UHC"  || value == "UPHC"){
		$("#dnrpDiv").hide();
		$("#dnrpDiv").attr("disabled", "false");
		
		
		$("#phcPileStandardSelect").show();
		$("#phcPileStandardSelect").attr("disabled", false);
		
		$("#steelPileStandardSelect").hide();
		$("#steelPileStandardSelect").attr("disabled", true);
		
		$("#meterof16Tr").hide();
		$("#meterof16Tr").attr("disabled", "false");
		$("#meterof17Tr").hide();
		$("#meterof17Tr").attr("disabled", "false");
		$("#meterof18Tr").hide();
		$("#meterof18Tr").attr("disabled", "false");
		
 		$("#meterof161Tr").hide();
		$("#meterof161Tr").attr("disabled", "false");
		$("#meterof171Tr").hide();
		$("#meterof171Tr").attr("disabled", "false");
		$("#meterof181Tr").hide();
		$("#meterof181Tr").attr("disabled", "false");
		
		$("#meterof162Tr").hide();
		$("#meterof162Tr").attr("disabled", "false");
		$("#meterof172Tr").hide();
		$("#meterof172Tr").attr("disabled", "false");
		$("#meterof182Tr").hide();
		$("#meterof182Tr").attr("disabled", "false");
		
		$("#meterof163Tr").hide();
		$("#meterof163Tr").attr("disabled", "false");
		$("#meterof173Tr").hide();
		$("#meterof173Tr").attr("disabled", "false");
		$("#meterof183Tr").hide();
		$("#meterof183Tr").attr("disabled", "false");
		
		$("#meterof164Tr").hide();
		$("#meterof164Tr").attr("disabled", "false");
		$("#meterof174Tr").hide();
		$("#meterof174Tr").attr("disabled", "false");
		$("#meterof184Tr").hide();
		$("#meterof184Tr").attr("disabled", "false");
		
		
		
	}else{
		$("#dnrpDiv").show();
		$("#dnrpDiv").attr("disabled", "true");
		
		$("#phcPileStandardSelect").hide();
		$("#phcPileStandardSelect").attr("disabled", true);
		
		
		$("#steelPileStandardSelect").show();
		$("#steelPileStandardSelect").attr("disabled", false);
		$("#steelPileStandardSelect option:eq(0)").prop("selected", true);
		
		
		$("#meterof16Tr").show();
		$("#meterof16Tr").attr("disabled", "true");
		$("#meterof17Tr").show();
		$("#meterof17Tr").attr("disabled", "true");
		$("#meterof18Tr").show();
		$("#meterof18Tr").attr("disabled", "true");
		
		$("#meterof161Tr").show();
		$("#meterof161Tr").attr("disabled", "true");
		$("#meterof171Tr").show();
		$("#meterof171Tr").attr("disabled", "true");
		$("#meterof181Tr").show();
		$("#meterof181Tr").attr("disabled", "true");
		
		$("#meterof162Tr").show();
		$("#meterof162Tr").attr("disabled", "true");
		$("#meterof172Tr").show();
		$("#meterof172Tr").attr("disabled", "true");
		$("#meterof182Tr").show();
		$("#meterof182Tr").attr("disabled", "true");
		
		$("#meterof163Tr").show();
		$("#meterof163Tr").attr("disabled", "true");
		$("#meterof173Tr").show();
		$("#meterof173Tr").attr("disabled", "true");
		$("#meterof183Tr").show();
		$("#meterof183Tr").attr("disabled", "true");

		$("#meterof164Tr").show();
		$("#meterof164Tr").attr("disabled", "true");
		$("#meterof174Tr").show();
		$("#meterof174Tr").attr("disabled", "true");
		$("#meterof184Tr").show();
		$("#meterof184Tr").attr("disabled", "true");
		
	}
	 // display 속성을 none 으로 바꾼다. 
}

function crearForm(){
	
	$('#regForm').each(function() {
		  this.reset();
	});
}

function getFileInfo(fiIdx){
	//버튼이름 변경
	$('#regBtn').text('수정');
	$("#regForm").attr("action", '${pageContext.request.contextPath}/fileinventory/update');
	jQuery.ajax({
		type : "POST",
		contentType: "application/x-www-form-urlencoded; charset=UTF-8",
		url : "${pageContext.request.contextPath}/fileinventory/get/info",
		data: {
			fiIdx : fiIdx
		}, 
		success : function(data) {
			if(data.pileType == 'PHC' || data.pileType == 'UHC' || data.pileType == 'UPHC'){
				$('#regForm select[name="pileType"]').val(data.pileType).prop("selected", true);
				onPileTypeChange(data.pileType);
				
			}else{
				$('#regForm select[name="pileType"]').val(data.pileType).prop("selected", true);
				onPileTypeChange(data.pileType);
			}
			
			$('#regForm select[name="separateSinglePileType"]').val(data.separateSinglePileType).prop("selected", true);
			$('#regForm select[name="separateBottomPileType"]').val(data.separateBottomPileType).prop("selected", true);
			
			$("#regForm input[name='fiIdx']").val(data.fiIdx);
			$("#regForm input[name='registDate']").val(data.registDate);
			$('#regForm select[name="pileStandard"]').val(data.pileStandard).prop("selected", true);
			$("#regForm input[name='constructionIdx']").val(data.constructionIdx);
			$("#regForm input[name='fileWeight']").val(data.fileWeight);
			$("#regForm input[name='meterof51']").val(data.meterof51);
			$("#regForm input[name='meterof52']").val(data.meterof52);
			$("#regForm input[name='meterof53']").val(data.meterof53);
			$("#regForm input[name='meterof54']").val(data.meterof54);
			$("#regForm input[name='meterof61']").val(data.meterof61);
			$("#regForm input[name='meterof62']").val(data.meterof62);
			$("#regForm input[name='meterof63']").val(data.meterof63);
			$("#regForm input[name='meterof64']").val(data.meterof64);
			$("#regForm input[name='meterof71']").val(data.meterof71);
			$("#regForm input[name='meterof72']").val(data.meterof72);
			$("#regForm input[name='meterof73']").val(data.meterof73);
			$("#regForm input[name='meterof74']").val(data.meterof74);
			$("#regForm input[name='meterof81']").val(data.meterof81);
			$("#regForm input[name='meterof82']").val(data.meterof82);
			$("#regForm input[name='meterof83']").val(data.meterof83);
			$("#regForm input[name='meterof84']").val(data.meterof84);
			$("#regForm input[name='meterof91']").val(data.meterof91);
			$("#regForm input[name='meterof92']").val(data.meterof92);
			$("#regForm input[name='meterof93']").val(data.meterof93);
			$("#regForm input[name='meterof94']").val(data.meterof94);
			$("#regForm input[name='meterof101']").val(data.meterof101);
			$("#regForm input[name='meterof102']").val(data.meterof102);
			$("#regForm input[name='meterof103']").val(data.meterof103);
			$("#regForm input[name='meterof104']").val(data.meterof104);
			$("#regForm input[name='meterof111']").val(data.meterof111);
			$("#regForm input[name='meterof112']").val(data.meterof112);
			$("#regForm input[name='meterof113']").val(data.meterof113);
			$("#regForm input[name='meterof114']").val(data.meterof114);
			$("#regForm input[name='meterof121']").val(data.meterof121);
			$("#regForm input[name='meterof122']").val(data.meterof122);
			$("#regForm input[name='meterof123']").val(data.meterof123);
			$("#regForm input[name='meterof124']").val(data.meterof124);
			$("#regForm input[name='meterof131']").val(data.meterof131);
			$("#regForm input[name='meterof132']").val(data.meterof132);
			$("#regForm input[name='meterof133']").val(data.meterof133);
			$("#regForm input[name='meterof134']").val(data.meterof134);
			$("#regForm input[name='meterof141']").val(data.meterof141);
			$("#regForm input[name='meterof142']").val(data.meterof142);
			$("#regForm input[name='meterof143']").val(data.meterof143);
			$("#regForm input[name='meterof144']").val(data.meterof144);
			$("#regForm input[name='meterof151']").val(data.meterof151);
			$("#regForm input[name='meterof152']").val(data.meterof152);
			$("#regForm input[name='meterof153']").val(data.meterof153);
			$("#regForm input[name='meterof154']").val(data.meterof154);
			$("#regForm input[name='meterof161']").val(data.meterof161);
			$("#regForm input[name='meterof162']").val(data.meterof162);
			$("#regForm input[name='meterof163']").val(data.meterof163);
			$("#regForm input[name='meterof164']").val(data.meterof164);
			$("#regForm input[name='meterof171']").val(data.meterof171);
			$("#regForm input[name='meterof172']").val(data.meterof172);
			$("#regForm input[name='meterof173']").val(data.meterof173);
			$("#regForm input[name='meterof174']").val(data.meterof174);
			$("#regForm input[name='meterof181']").val(data.meterof181);
			$("#regForm input[name='meterof182']").val(data.meterof182);
			$("#regForm input[name='meterof183']").val(data.meterof183);
			$("#regForm input[name='meterof184']").val(data.meterof184);
			$("#regForm input[name='maker']").val(data.maker);
			$("#regForm textarea[name='bigo']").text(data.bigo);
			
		},
		complete : function(data) {
		},
		error : function(xhr, status, error) {
			var err = eval("(" + xhr.responseText + ")");
			  alert(err.Message);
		}
	});  
	return false;
}

function checkValidation(){
	
	if($('#regBtn').text() == '수정'){
		if($('#registDate').val() == ''){
			alert('날짜를 입력하세요.');
		}else{
			$("#regForm").attr('action', '${pageContext.request.contextPath}/fileinventory/update').submit();
		}
		
	}else{
		var registDate = $('#registDate').val();
		var pileType = $('#pileType').val();
		var constructionIdx = ${param.constructionIdx};
		var fileWeight = $('#fileWeight').val();
		var pileStandard  = $('select[name="pileStandard"]').val();
		var maker  = $('#maker').val();
		
		if($('#registDate').val() == ''){
			alert('날짜를 입력하세요.');
			return;
		}
		
		jQuery.ajax({
			type : "POST",
			contentType: "application/x-www-form-urlencoded; charset=UTF-8",
			url : "${pageContext.request.contextPath}/fileinventory/check/duplicate",
			data: {
				registDate : registDate
				, pileType : pileType
				, constructionIdx : constructionIdx
				, pileStandard : pileStandard
				, fileWeight : fileWeight
				, maker : maker
			}, 
			success : function(data) {
				if(data){
					//저장할 수 있음.
					$('#regForm').submit();
				}else{
					//이미 등록된 것
					if(fileWeight != ""){
						alert( registDate + "일 " + maker + " " + pileType + " " + pileStandard + " " + fileWeight +  " 의 반입량이 이미 입력되있습니다. ");	  
					}else{
						alert( registDate + "일 " + maker + " " + pileType + " " + pileStandard + " 의 반입량이 이미 입력되있습니다. ");	  
					}
				};
			},
			complete : function(data) {
			},
			error : function(xhr, status, error) {
				var err = eval("(" + xhr.responseText + ")");
				  alert(err.Message);
			}
		});  
		return false;
	}
}
</script>
<!--컨텐츠-->
		<div class="section-right">

			<div class="TopContArea">
				<div class="titArea mb-40">
					<p class="h1Tit">파일반입 및 수정</p>
					<div class="titBtnArea">
						<%-- <div class="printBtn" onclick="location.href='${pageContext.request.contextPath}/fileinventory/regist2?constructionIdx=${param.constructionIdx}&pileType=PHC'">파일 등록</div> --%>
						<select id="select1" name="select1" onchange="javascript:fileChange(this.value);">
							<option selected disabled value="">파일현황 출력 ▼</option>
						</select>
						<c:choose>
							<c:when test="${sessionInfo.constructionIdx == 988}">
								<c:choose>
									<c:when test="${sessionInfo.hiddenManager == true}">
										<div class="printBtn">파일 등록</div>
									</c:when>
								</c:choose>
							</c:when>
							<c:otherwise>
								<div class="printBtn">파일 등록</div>							
							</c:otherwise>
						</c:choose>
						
					</div>
				</div>
				
				<!--검색-->
				<form:form id="searchForm" commandName="domainParam" method="POST">
					<form:hidden path="currentPage"/>
						<div class="searchArea">
							<div class="searchArea01">
								<form:select id="searchForm"  path="searchField">
									<form:option value="">선택</form:option>
				                	<form:option value="pileType">종류</form:option>
				                    <form:option value="pileStandard">규격</form:option>
				                    <form:option value="fileWeight">두께</form:option>
								</form:select>
								<!-- <input type="text" name="" value="" class="searchin" placeholder="검색어를 입력하세요."> -->
								<form:input path="searchWord" class="searchin" placeholder="검색어를 입력하세요."/>
								<div class="searchBtn">
									<img id="submitBtn" src="${pageContext.request.contextPath}/new/img/search.png" style="cursor:pointer;">
								</div>
							</div>
							<div class="searchArea02">
								<form:input path="startDate" class="inputDate datepicker" placeholder="시작일"/>
								<span>~</span>
								<form:input path="endDate" class="inputDate datepicker" placeholder="종료일"/> 
								<div class="searchBtn">
									<img src="${pageContext.request.contextPath}/new/img/search_date.png" style="cursor:pointer;" onclick="javascript:searchForm2();">
								</div>
							</div>
						</div>
				</form:form>
				<!--//검색-->

				<!--검색 키워드 / 키워드와 일치하는 단어일 경우 색상 color: #0e60ff-->
				<%-- <div class="keywordArea">
					<div class="keyword">
						<span class="keywardTxt">홍길동</span>
						<img src="${pageContext.request.contextPath}/new/img/delete.png" />
					</div>
					<div class="keyword">
						<span class="keywardTxt">부산</span>
						<img src="${pageContext.request.contextPath}/new/img/delete.png" />
					</div>
					<div class="keyword">
						<span class="keywardTxt">PDAM 건설</span>
						<img src="${pageContext.request.contextPath}/new/img/delete.png" />
					</div>
				</div> --%>
				<!--//검색 키워드-->
			</div>
			
			<div class="min435">
				<div class="tableArea">
					
					<div class="viewTable viewTable02">
						<ul class="viewTh">
							
							
							<c:choose>
								<c:when test="${sessionInfo.constructionIdx == 988}">
									<c:choose>
										<c:when test="${sessionInfo.hiddenManager == true}">
											<li style="width: calc(100% / 8);">등록일</li>
											<li style="width: calc(100% / 8);">제조사</li>
											<li style="width: calc(100% / 8);">종류</li>
											<li style="width: calc(100% / 8);">규격</li>
											<li style="width: calc(100% / 8);">두께</li>
											<li style="width: calc(100% / 8);">반입수량</li>
											<li style="width: calc(100% / 8);">수정</li>
											<li style="width: calc(100% / 8);">삭제</li>
										</c:when>
										<c:otherwise>
											<li style="width: calc(100% / 6);">등록일</li>
											<li style="width: calc(100% / 6);">제조사</li>
											<li style="width: calc(100% / 6);">종류</li>
											<li style="width: calc(100% / 6);">규격</li>
											<li style="width: calc(100% / 6);">두께</li>
											<li style="width: calc(100% / 6);">반입수량</li>
										</c:otherwise>
									</c:choose>
								</c:when>
								<c:otherwise>
									<li style="width: calc(100% / 8);">등록일</li>
									<li style="width: calc(100% / 8);">제조사</li>
									<li style="width: calc(100% / 8);">종류</li>
									<li style="width: calc(100% / 8);">규격</li>
									<li style="width: calc(100% / 8);">두께</li>
									<li style="width: calc(100% / 8);">반입수량</li>
									<li style="width: calc(100% / 8);">수정</li>
									<li style="width: calc(100% / 8);">삭제</li>						
								</c:otherwise>
							</c:choose>
							
							
						</ul>
						
						<div class="tableScroll">
							<table>
								<c:choose>
									<c:when test="${fn:length(domainList) < 1}">
										<!--데이터가 없을 경우-->
										<tr>
											<td colspan="8">등록된 데이터가 없습니다.</td>
										</tr>
								<!--//데이터가 없을 경우-->
									</c:when>
									<c:otherwise>
										<c:forEach var="domain" items="${domainList}" varStatus="status">
										<tr>
											<td>${domain.registDate}</td>
											<td>${domain.maker}</td>
											<td>${domain.pileType}</td>
											<td>${domain.pileStandard}</td>
											<td>${domain.fileWeight}</td>
											<td>${domain.meterof51} EA</td>
											<c:choose>
												<c:when test="${sessionInfo.constructionIdx == 988}">
													<c:choose>
														<c:when test="${sessionInfo.hiddenManager == true}">
															<td>
																<a href="javascript:getFileInfo('${domain.fiIdx}');">
																	<div class="tableChange">수정</div>
																</a>
															</td>
															<td>
																<a href="javascript:deleteConfirm('${pageContext.request.contextPath}/fileinventory/delete?id=${domain.fiIdx}')">
																	<div class="tableDelate" style="background: #EF340C; border: solid red 1px;">삭제</div>
																</a>
															</td>
														</c:when>
													</c:choose>
												</c:when>
												<c:otherwise>
													<td>
														<a href="javascript:getFileInfo('${domain.fiIdx}');">
															<div class="tableChange">수정</div>
														</a>
													</td>
													<td>
														<a href="javascript:deleteConfirm('${pageContext.request.contextPath}/fileinventory/delete?id=${domain.fiIdx}')">
															<div class="tableDelate" style="background: #EF340C; border: solid red 1px;">삭제</div>
														</a>
													</td>					
												</c:otherwise>
											</c:choose>
										</tr>
										</c:forEach>
									</c:otherwise>
								</c:choose>
							</table>
						</div>
					</div>
				</div>
			</div>
			
			<!--페이징-->
			<%@ include file="/WEB-INF/views/common/pagination.jsp"%>
			<!--//페이징-->

		</div>
		<!--//컨텐츠-->

		<!--정보 변경 팝업-->
		<form:form commandName="domain"  action="${pageContext.request.contextPath}/fileinventory/regist" method="POST" id="regForm">
		
			<div class="popUp w70">
				<div class="popTit">
					<p id="constructionSetName"></p>
					<img class="popClose" src="${pageContext.request.contextPath}/new/img/popclose.png" />
				</div>
				<div class="popCont">
					<div class="popInput02">
						<div class="inputArea02 mr-2">
							<p class="inputTxt02">날짜</p>
							<!-- <input type="text" class="inputDate datepicker Input02" name="" value="" > -->
							<form:input path="registDate" class="inputDate datepicker Input02" />
							<form:hidden path="constructionIdx" value="${param.constructionIdx}"/>
							<form:hidden path="fiIdx" value=""/>
						</div>
						<div class="inputArea02 mr-2">
							<p class="inputTxt02">규격</p>
							<form:select path="pileStandard" class="Input02" id="phcPileStandardSelect">
								<form:option value="400">400</form:option>
								<form:option value="450">450</form:option>
								<form:option value="500">500</form:option>
								<form:option value="550">550</form:option>
								<form:option value="600">600</form:option>
								<form:option value="650">650</form:option>
								<form:option value="700">700</form:option>
								<form:option value="750">750</form:option>
								<form:option value="800">800</form:option>
								<form:option value="850">850</form:option>
								<form:option value="900">900</form:option>
								<form:option value="950">950</form:option>
								<form:option value="1000">1000</form:option>
							</form:select>
							<form:select path="pileStandard"  class="Input02" id="steelPileStandardSelect" style="display: none;">
								<form:option value="406.4">406.4</form:option>
								<form:option value="508">508</form:option>
								<form:option value="609.6">609.6</form:option>
								<form:option value="711.2">711.2</form:option>
								<form:option value="812.8">812.8</form:option>
								<form:option value="914.4">914.4</form:option>
								<form:option value="1016">1016</form:option>
								<form:option value="1117.6">1117.6</form:option>
								<form:option value="1219.2">1219.2</form:option>
							</form:select>
						</div>
						<div class="inputArea02 mr-2" id="dnrpDiv" style="display: none;">
							<p class="inputTxt02">두께</p>
							<form:select path="fileWeight"  class="Input02">
								<form:option value="8T">8T</form:option>
								<form:option value="9T">9T</form:option>
								<form:option value="10T">10T</form:option>
								<form:option value="12T">12T</form:option>
								<form:option value="14T">14T</form:option>
								<form:option value="15T">15T</form:option>
								<form:option value="16T">16T</form:option>
								<form:option value="18T">18T</form:option>	
							</form:select>
						</div>
						<div class="inputArea02">
							<p class="inputTxt02">제조사</p>
							 <form:input path="maker" class="Input02" />
						</div>
					</div>

					<div class="tableArea type02 mb-20">
						<div class="viewTable viewTable03">
							<div class="tableScroll">
								<table>
									<thead class="viewTh">
										<tr>
											<th style="padding: 10px 0px 10px 0px;">
											종류
											<form:select path="pileType" class="thInput" onchange="javascript:onPileTypeChange(this.value);">
												<form:option value="PHC">PHC</form:option>
												<form:option value="STEEL">STEEL</form:option>
												<form:option value="UHC">UHC</form:option>
											</form:select>
											</th>
											<th>5m</th>
											<th>6m</th>
											<th>7m</th>
											<th>8m</th>
											<th>9m</th>
											<th>10m</th>
											<th>11m</th>
											<th>12m</th>
											<th>13m</th>
											<th>14m</th>
											<th>15m</th>
											<th id="meterof16Tr" style="display: none;">16m</th>
											<th id="meterof17Tr" style="display: none;">17m</th>
											<th id="meterof18Tr" style="display: none;">18m</th>
										</tr>
									</thead>
									<tr>
										<td>
											단본<br>
											<form:select path="separateSinglePileType" class="thInput">
												<form:option value=""></form:option>
												<form:option value="EXT">EXT</form:option>
											</form:select>
										
										</td>
										<td><form:input type="number" path="meterof51" class="tdInput"/></td>
										<td><form:input type="number" path="meterof61" class="tdInput"/></td>
										<td><form:input type="number" path="meterof71" class="tdInput"/></td>
										<td><form:input type="number" path="meterof81" class="tdInput"/></td>
										<td><form:input type="number" path="meterof91" class="tdInput"/></td>
										<td><form:input type="number" path="meterof101" class="tdInput"/></td>
										<td><form:input type="number" path="meterof111" class="tdInput"/></td>
										<td><form:input type="number" path="meterof121" class="tdInput"/></td>
										<td><form:input type="number" path="meterof131" class="tdInput"/></td>
										<td><form:input type="number" path="meterof141" class="tdInput"/></td>
										<td><form:input type="number" path="meterof151" class="tdInput"/></td>
										<td id="meterof161Tr" style="display: none;"><form:input type="number" path="meterof161" class="tdInput"/></td>
										<td id="meterof171Tr" style="display: none;"><form:input type="number" path="meterof171" class="tdInput"/></td>
										<td id="meterof181Tr" style="display: none;"><form:input path="meterof181" class="tdInput"/></td>
									</tr>
									<tr>
										<td>하단<br>
											<form:select path="separateBottomPileType" class="thInput">
												<form:option value=""></form:option>
												<form:option value="EXT">EXT</form:option>
											</form:select>
										</td>
										<td><form:input type="number"  path="meterof52" class="tdInput"/></td>
										<td><form:input type="number" path="meterof62" class="tdInput"/></td>
										<td><form:input type="number" path="meterof72" class="tdInput"/></td>
										<td><form:input type="number" path="meterof82" class="tdInput"/></td>
										<td><form:input type="number" path="meterof92" class="tdInput"/></td>
										<td><form:input type="number" path="meterof102" class="tdInput"/></td>
										<td><form:input type="number" path="meterof112" class="tdInput"/></td>
										<td><form:input type="number" path="meterof122" class="tdInput"/></td>
										<td><form:input type="number" path="meterof132" class="tdInput"/></td>
										<td><form:input type="number" path="meterof142" class="tdInput"/></td>
										<td><form:input type="number" path="meterof152" class="tdInput"/></td>
										<td id="meterof162Tr" style="display: none;"><form:input type="number" path="meterof162" class="tdInput"/></td>
										<td id="meterof172Tr" style="display: none;"><form:input type="number" path="meterof172" class="tdInput"/></td>
										<td id="meterof182Tr" style="display: none;"><form:input type="number" path="meterof182" class="tdInput"/></td>
									</tr>
									<tr>
										<td>중단</td>
										<td><form:input type="number" path="meterof53" class="tdInput"/></td>
										<td><form:input type="number" path="meterof63" class="tdInput"/></td>
										<td><form:input type="number" path="meterof73" class="tdInput"/></td>
										<td><form:input type="number" path="meterof83" class="tdInput"/></td>
										<td><form:input type="number" path="meterof93" class="tdInput"/></td>
										<td><form:input type="number" path="meterof103" class="tdInput"/></td>
										<td><form:input type="number" path="meterof113" class="tdInput"/></td>
										<td><form:input type="number" path="meterof123" class="tdInput"/></td>
										<td><form:input type="number" path="meterof133" class="tdInput"/></td>
										<td><form:input type="number" path="meterof143" class="tdInput"/></td>
										<td><form:input type="number" path="meterof153" class="tdInput"/></td>
										<td id="meterof163Tr" style="display: none;"><form:input type="number" path="meterof163" class="tdInput"/></td>
										<td id="meterof173Tr" style="display: none;"><form:input type="number" path="meterof173" class="tdInput"/></td>
										<td id="meterof183Tr" style="display: none;"><form:input type="number" path="meterof183" class="tdInput"/></td>
									</tr>
									<tr>
										<td>상단</td>
										<td><form:input type="number" path="meterof54" class="tdInput"/></td>
										<td><form:input type="number" path="meterof64" class="tdInput"/></td>
										<td><form:input type="number" path="meterof74" class="tdInput"/></td>
										<td><form:input type="number" path="meterof84" class="tdInput"/></td>
										<td><form:input type="number" path="meterof94" class="tdInput"/></td>
										<td><form:input type="number" path="meterof104" class="tdInput"/></td>
										<td><form:input type="number" path="meterof114" class="tdInput"/></td>
										<td><form:input type="number" path="meterof124" class="tdInput"/></td>
										<td><form:input type="number" path="meterof134" class="tdInput"/></td>
										<td><form:input type="number" path="meterof144" class="tdInput"/></td>
										<td><form:input type="number" path="meterof154" class="tdInput"/></td>
										<td id="meterof164Tr" style="display: none;"><form:input type="number" path="meterof164" class="tdInput"/></td>
										<td id="meterof174Tr" style="display: none;"><form:input type="number" path="meterof174" class="tdInput"/></td>
										<td id="meterof184Tr" style="display: none;"><form:input type="number" path="meterof184" class="tdInput"/></td>
									</tr>
									
								</table>
								
								<table>
									<tr>
									
										<td>
											<textarea id="bigo" name="bigo" rows="5" cols="" style="width: 98%; border:1px #c2c2c2 solid; margin-left: 10px; margin-right: 10px; padding: 5px;" placeholder="비고를 입력하세요"></textarea>
										</td>
									</tr>
								</table>
								
							</div>
						</div>
					</div>
					<div class="popAdd" id="regBtn" >등록</div>
				</div>
			</div>
			</form:form>
			<div class="popLayer" style=""></div>
			<!--//정보 변경 팝업-->
<!-- 팝업 -->
<script>
$('.popUp').hide();
$('.popLayer').hide();

$('.printBtn, .tableChange').on('click', function(e){
	$('.popUp').show();
	$('.popLayer').show();
	$('body').css('overflow', 'hidden');
	
	
	$("#dnrpDiv").hide();
	$("#dnrpDiv").attr("disabled", "false");
	
	$("#phcPileStandardSelect").show();
	$("#phcPileStandardSelect").attr("disabled", false);
	
	$("#steelPileStandardSelect").hide();
	$("#steelPileStandardSelect").attr("disabled", true);
	
	
	$("#meterof16Tr").hide();
	$("#meterof16Tr").attr("disabled", "false");
	$("#meterof17Tr").hide();
	$("#meterof17Tr").attr("disabled", "false");
	$("#meterof18Tr").hide();
	$("#meterof18Tr").attr("disabled", "false");
	
	$("#meterof161Tr").hide();
	$("#meterof161Tr").attr("disabled", "false");
	$("#meterof171Tr").hide();
	$("#meterof171Tr").attr("disabled", "false");
	$("#meterof181Tr").hide();
	$("#meterof181Tr").attr("disabled", "false");
	
	$("#meterof162Tr").hide();
	$("#meterof162Tr").attr("disabled", "false");
	$("#meterof172Tr").hide();
	$("#meterof172Tr").attr("disabled", "false");
	$("#meterof182Tr").hide();
	$("#meterof182Tr").attr("disabled", "false");
	
	$("#meterof163Tr").hide();
	$("#meterof163Tr").attr("disabled", "false");
	$("#meterof173Tr").hide();
	$("#meterof173Tr").attr("disabled", "false");
	$("#meterof183Tr").hide();
	$("#meterof183Tr").attr("disabled", "false");
	
	$("#meterof164Tr").hide();
	$("#meterof164Tr").attr("disabled", "false");
	$("#meterof174Tr").hide();
	$("#meterof174Tr").attr("disabled", "false");
	$("#meterof184Tr").hide();
	$("#meterof184Tr").attr("disabled", "false");
	
	getConstructionName();
	crearForm();
	$('#regBtn').text('등록');
});



$('.popClose').on('click', function(e){
	$('.popUp').hide();
	$('.popLayer').hide();
	$('body').css('overflow', 'auto');
});

$('.popAdd').on('click', function(e){
	checkValidation();
	//$('#regForm').submit();
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

function searchForm2(){
	$('#searchForm').submit();
}  
</script>
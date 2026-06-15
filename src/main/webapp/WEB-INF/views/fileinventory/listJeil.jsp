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
				 }else{
					 var option = item.pileType + " " + item.fileWeight + " " + item.pileStandard;
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

function checkBrokenValidation(){
	
	if($("#brokenRegForm").find('#brokenRegBtn').text() == '파손파일 수정'){
		
		if($("#brokenRegForm").find('#registDate').val() == ''){
			
		}else{
			$("#brokenRegForm").attr('action', '${pageContext.request.contextPath}/fileinventory/broken/update').submit();
		}
	}else{
		var registDate =  $('#brokenRegForm input[name="registDate"]').val();
		var pileType =  $('#brokenRegForm input[name="pileType"]').val();
		var constructionIdx = ${param.constructionIdx};
		var fileWeight =  $('#brokenRegForm input[name="fileWeight"]').val();
		var pileStandard  = $('#brokenRegForm input[name="pileStandard"]').val();
		var maker  = $('#brokenRegForm input[name="maker"]').val();
		
		if(registDate  == ''){
			alert('날짜를 입력하세요.');
			return;
		}
		
		jQuery.ajax({
			type : "POST",
			contentType: "application/x-www-form-urlencoded; charset=UTF-8",
			url : "${pageContext.request.contextPath}/fileinventory/check/broken/duplicate",
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
					$("#brokenRegForm").submit();
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

function checkValidation(){
	
	if($("#regForm").find('#regBtn').text() == '수정'){
		if($("#regForm").find('#registDate').val() == ''){
			alert('날짜를 입력하세요.');
		}else{
			$("#regForm").attr('action', '${pageContext.request.contextPath}/fileinventory/update').submit();
		}
		
	}else{
		var registDate =  $('#regForm input[name="registDate"]').val();
		var pileType = $('#regForm select[name="pileType"]').val();
		var constructionIdx = ${param.constructionIdx};
		var fileWeight = $('#regForm select[name="fileWeight"]').val();
		var pileStandard  = $('#regForm select[name="pileStandard"]').val();
		var maker  =  $('#regForm input[name="maker"]').val();
		
		if(registDate == ''){
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
			<%@ include file="/WEB-INF/views/common/welcomeMsg.jsp" %>
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
										<!-- <div class="printBtn03" style="margin-left: 10px;">파손 파일 등록</div> -->
									</c:when>
								</c:choose>
							</c:when>
							<c:otherwise>
								<div class="printBtn">파일 등록</div>							
								<!-- <div class="printBtn03" style="margin-left: 10px;">파손 파일 등록</div>	 -->						
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
							<li style="width: calc(100% / 9);">등록일</li>
							<li style="width: calc(100% / 9);">제조사</li>
							<li style="width: calc(100% / 9);">종류</li>
							<li style="width: calc(100% / 9);">규격</li>
							<li style="width: calc(100% / 9);">두께</li>
							<li style="width: calc(100% / 9);">반입수량</li>
							<li style="width: calc(100% / 9);">수정</li>
							<li style="width: calc(100% / 9);">파손파일</li>
							<li style="width: calc(100% / 9);">삭제</li>	
						</ul>					
						<div class="tableScroll">
							<table>
								<c:choose>
									<c:when test="${fn:length(domainList) < 1}">
										<!--데이터가 없을 경우-->
										<tr>
											<td colspan="9">등록된 데이터가 없습니다.</td>
										</tr>
										<!--//데이터가 없을 경우-->
									</c:when>
									<c:otherwise>
										<c:forEach var="domain" items="${domainList}" varStatus="status">
											<tr>
												<td style="width: calc(100% / 9);">${domain.registDate}</td>
												<td style="width: calc(100% / 9);">${domain.maker}</td>
												<td style="width: calc(100% / 9);">${domain.pileType}</td>
												<td style="width: calc(100% / 9);">${domain.pileStandard}</td>
												<td style="width: calc(100% / 9);">${domain.fileWeight}</td>
												<td style="width: calc(100% / 9);">${domain.meterof51} EA</td>
												<td style="width: calc(100% / 9);">
													<a href="javascript:getFileInfo('${domain.fiIdx}');">
														<div class="tableChange">수정</div>
													</a>
												</td>
												<td style="width: calc(100% / 9);">
													<a href="javascript:getBrokenFileInfo('${domain.brokenFiIdx}', '${domain.registDate}' , '${domain.pileType}', '${domain.pileStandard}', '${domain.fileWeight}', '${domain.maker}');">
														<div class="state">수정</div>
													</a>
												</td>
												<td style="width: calc(100% / 9);">
													<a href="javascript:deleteConfirm('${pageContext.request.contextPath}/fileinventory/delete?id=${domain.fiIdx}')">
														<div class="tableDelate" style="background: #EF340C; border: solid red 1px;">삭제</div>
													</a>
												</td>
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
		
		<!-- 파손 파일 시작 -->
		<form:form commandName="domain"  action="${pageContext.request.contextPath}/fileinventory/broken/regist" method="POST" id="brokenRegForm">
			<div class="popUp w70" id="broken_popup">
				<div class="popTit">
					<p id="constructionSetName"></p>
					<img class="popClose" src="${pageContext.request.contextPath}/new/img/popclose.png" />
				</div>
				<div class="popCont">
					<div class="popInput02">
						<div class="inputArea02 mr-2">
							<p class="inputTxt02">날짜</p>
							<form:input path="registDate" autocomplete="off" class="inputDate datepicker Input02" />
							<form:hidden path="constructionIdx" value="${param.constructionIdx}"/>
							<form:hidden path="fiIdx" value=""/>
						</div>
						<div class="inputArea02 mr-2">
							<p class="inputTxt02">규격</p>
							<form:input path="pileStandard" class="Input02" />
						</div>
						<div class="inputArea02 mr-2" id="dnrpDiv" style="display: none;">
							<p class="inputTxt02">두께</p>
							<form:input path="fileWeight"  class="Input02" />
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
											<form:input path="pileType" class="thInput" />
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
											단본
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
										<td>
											하단
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
					<div class="popAdd" id="brokenRegBtn" >파손파일 등록</div>
				</div>
			</div>
		</form:form>
		<!-- 파손 파일 끝 -->
		<!--정보 변경 팝업-->
		<form:form commandName="domain"  action="${pageContext.request.contextPath}/fileinventory/regist2" method="POST" id="regForm">
			<div class="popUp w70">
				<div class="popTit">
					<p id="constructionSetName"></p>
					<img class="popClose" src="${pageContext.request.contextPath}/new/img/popclose.png" />
				</div>
				<div class="popCont">
					<div class="popInput02">
						<div class="inputArea02 mr-2">
							<p class="inputTxt02">날짜</p>
							<form:input path="registDate" id="" autocomplete="off" class="inputDate datepicker Input02" />
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
$('.printBtn03, .state').on('click', function(e){
	
	$("#brokenRegForm").find('.popUp').show();
	$('.popLayer').show();
	$('body').css('overflow', 'hidden');
	
	
	$("#brokenRegForm").find("#dnrpDiv").hide();
	$("#brokenRegForm").find("#dnrpDiv").attr("disabled", "false");
	
	$("#brokenRegForm").find("#phcPileStandardSelect").show();
	$("#brokenRegForm").find("#phcPileStandardSelect").attr("disabled", false);
	
	$("#brokenRegForm").find("#steelPileStandardSelect").hide();
	$("#brokenRegForm").find("#steelPileStandardSelect").attr("disabled", true);
	
	
	$("#brokenRegForm").find("#meterof16Tr").hide();
	$("#brokenRegForm").find("#meterof16Tr").attr("disabled", "false");
	$("#brokenRegForm").find("#meterof17Tr").hide();
	$("#brokenRegForm").find("#meterof17Tr").attr("disabled", "false");
	$("#brokenRegForm").find("#meterof18Tr").hide();
	$("#brokenRegForm").find("#meterof18Tr").attr("disabled", "false");
	
	$("#brokenRegForm").find("#meterof161Tr").hide();
	$("#brokenRegForm").find("#meterof161Tr").attr("disabled", "false");
	$("#brokenRegForm").find("#meterof171Tr").hide();
	$("#brokenRegForm").find("#meterof171Tr").attr("disabled", "false");
	$("#brokenRegForm").find("#meterof181Tr").hide();
	$("#brokenRegForm").find("#meterof181Tr").attr("disabled", "false");
	
	$("#brokenRegForm").find("#meterof162Tr").hide();
	$("#brokenRegForm").find("#meterof162Tr").attr("disabled", "false");
	$("#brokenRegForm").find("#meterof172Tr").hide();
	$("#brokenRegForm").find("#meterof172Tr").attr("disabled", "false");
	$("#brokenRegForm").find("#meterof182Tr").hide();
	$("#brokenRegForm").find("#meterof182Tr").attr("disabled", "false");
	
	$("#brokenRegForm").find("#meterof163Tr").hide();
	$("#brokenRegForm").find("#meterof163Tr").attr("disabled", "false");
	$("#brokenRegForm").find("#meterof173Tr").hide();
	$("#brokenRegForm").find("#meterof173Tr").attr("disabled", "false");
	$("#brokenRegForm").find("#meterof183Tr").hide();
	$("#brokenRegForm").find("#meterof183Tr").attr("disabled", "false");
	
	$("#brokenRegForm").find("#meterof164Tr").hide();
	$("#brokenRegForm").find("#meterof164Tr").attr("disabled", "false");
	$("#brokenRegForm").find("#meterof174Tr").hide();
	$("#brokenRegForm").find("#meterof174Tr").attr("disabled", "false");
	$("#brokenRegForm").find("#meterof184Tr").hide();
	$("#brokenRegForm").find("#meterof184Tr").attr("disabled", "false");
	
	getConstructionName();
	crearForm();
	$("#brokenRegForm").find('#brokenRegBtn').text('파손파일 등록');
});

$('.printBtn, .tableChange').on('click', function(e){
	
	$("#regForm").find('.popUp').show();
	$('.popLayer').show();
	$('body').css('overflow', 'hidden');
	
	
	$("#regForm").find("#dnrpDiv").hide();
	$("#regForm").find("#dnrpDiv").attr("disabled", "false");
	
	$("#regForm").find("#phcPileStandardSelect").show();
	$("#regForm").find("#phcPileStandardSelect").attr("disabled", false);
	
	$("#regForm").find("#steelPileStandardSelect").hide();
	$("#regForm").find("#steelPileStandardSelect").attr("disabled", true);
	
	
	$("#regForm").find("#meterof16Tr").hide();
	$("#regForm").find("#meterof16Tr").attr("disabled", "false");
	$("#regForm").find("#meterof17Tr").hide();
	$("#regForm").find("#meterof17Tr").attr("disabled", "false");
	$("#regForm").find("#meterof18Tr").hide();
	$("#regForm").find("#meterof18Tr").attr("disabled", "false");
	
	$("#regForm").find("#meterof161Tr").hide();
	$("#regForm").find("#meterof161Tr").attr("disabled", "false");
	$("#regForm").find("#meterof171Tr").hide();
	$("#regForm").find("#meterof171Tr").attr("disabled", "false");
	$("#regForm").find("#meterof181Tr").hide();
	$("#regForm").find("#meterof181Tr").attr("disabled", "false");
	
	$("#regForm").find("#meterof162Tr").hide();
	$("#regForm").find("#meterof162Tr").attr("disabled", "false");
	$("#regForm").find("#meterof172Tr").hide();
	$("#regForm").find("#meterof172Tr").attr("disabled", "false");
	$("#regForm").find("#meterof182Tr").hide();
	$("#regForm").find("#meterof182Tr").attr("disabled", "false");
	
	$("#regForm").find("#meterof163Tr").hide();
	$("#regForm").find("#meterof163Tr").attr("disabled", "false");
	$("#regForm").find("#meterof173Tr").hide();
	$("#regForm").find("#meterof173Tr").attr("disabled", "false");
	$("#regForm").find("#meterof183Tr").hide();
	$("#regForm").find("#meterof183Tr").attr("disabled", "false");
	
	$("#regForm").find("#meterof164Tr").hide();
	$("#regForm").find("#meterof164Tr").attr("disabled", "false");
	$("#regForm").find("#meterof174Tr").hide();
	$("#regForm").find("#meterof174Tr").attr("disabled", "false");
	$("#regForm").find("#meterof184Tr").hide();
	$("#regForm").find("#meterof184Tr").attr("disabled", "false");
	
	getConstructionName();
	crearForm();
	$("#regForm").find('#regBtn').text('등록');
});


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
			$("#brokenRegForm").find("#constructionSetName").text(data);
			$("#regForm").find("#constructionSetName").text(data);
		},
		complete : function(data) {
		},
		error : function(xhr, status, error) {
		}
	}); 
}


function crearForm(){
	
	$('#regForm').each(function() {
		  this.reset();
	});
	
	$('#brokenRegForm').each(function() {
		  this.reset();
	});
}
function getBrokenFileInfo(fiIdx, registDate, pileType, pileStandard, fileWeight, maker){
	
	//버튼이름 변경
	$("#brokenRegForm").find("#brokenRegBtn").text('파손파일 수정');
	$("#brokenRegForm").attr("action", '${pageContext.request.contextPath}/fileinventory/broken/update');
	jQuery.ajax({
		type : "POST",
		contentType: "application/x-www-form-urlencoded; charset=UTF-8",
		url : "${pageContext.request.contextPath}/fileinventory/get/broken/info",
		data: {
			fiIdx : fiIdx
		}, 
		success : function(data) {
			if(data == ''){
				$("#brokenRegForm input[name='registDate']").val(registDate);
				if(pileType == 'PHC' ||pileType == 'UHC' || pileType == 'UPHC'){
					$('#brokenRegForm input[name="pileType"]').val(pileType);
					onBrokenPileTypeChange(pileType);
					
				}else{
					$('#brokenRegForm input[name="pileType"]').val(pileType);
					$("#brokenRegForm input[name='fileWeight']").val(fileWeight);
					onBrokenPileTypeChange(pileType);
				}
				
				$("#brokenRegForm input[name='maker']").val(maker);
				$('#brokenRegForm input[name="pileStandard"]').val(pileStandard);
				
				$("#brokenRegForm input[name='registDate']").prop("readonly", true);
				//$("#brokenRegForm input[name='registDate']").datepicker("option", "disabled", true);
				$('#brokenRegForm input[name="pileStandard"]').prop("readonly", true);
				$('#brokenRegForm input[name="pileType"]').prop("readonly", true);
				$("#brokenRegForm input[name='fileWeight']").prop("readonly", true);
				$("#brokenRegForm input[name='maker']").prop("readonly", true);
				
				return
			}
			
			
			if(data.pileType == 'PHC' || data.pileType == 'UHC' || data.pileType == 'UPHC'){
				$('#brokenRegForm input[name="pileType"]').val(data.pileType);
				onBrokenPileTypeChange(data.pileType);
				
			}else{
				$('#brokenRegForm input[name="pileType"]').val(data.pileType);
				onBrokenPileTypeChange(data.pileType);
			}
			
			$("#brokenRegForm input[name='fiIdx']").val(data.fiIdx);
			$("#brokenRegForm input[name='registDate']").val(data.registDate);
			$('#brokenRegForm input[name="pileStandard"]').val(data.pileStandard);
			$("#brokenRegForm input[name='constructionIdx']").val(data.constructionIdx);
			$("#brokenRegForm input[name='fileWeight']").val(data.fileWeight);
			$("#brokenRegForm input[name='meterof51']").val(data.meterof51);
			$("#brokenRegForm input[name='meterof52']").val(data.meterof52);
			$("#brokenRegForm input[name='meterof53']").val(data.meterof53);
			$("#brokenRegForm input[name='meterof54']").val(data.meterof54);
			$("#brokenRegForm input[name='meterof61']").val(data.meterof61);
			$("#brokenRegForm input[name='meterof62']").val(data.meterof62);
			$("#brokenRegForm input[name='meterof63']").val(data.meterof63);
			$("#brokenRegForm input[name='meterof64']").val(data.meterof64);
			$("#brokenRegForm input[name='meterof71']").val(data.meterof71);
			$("#brokenRegForm input[name='meterof72']").val(data.meterof72);
			$("#brokenRegForm input[name='meterof73']").val(data.meterof73);
			$("#brokenRegForm input[name='meterof74']").val(data.meterof74);
			$("#brokenRegForm input[name='meterof81']").val(data.meterof81);
			$("#brokenRegForm input[name='meterof82']").val(data.meterof82);
			$("#brokenRegForm input[name='meterof83']").val(data.meterof83);
			$("#brokenRegForm input[name='meterof84']").val(data.meterof84);
			$("#brokenRegForm input[name='meterof91']").val(data.meterof91);
			$("#brokenRegForm input[name='meterof92']").val(data.meterof92);
			$("#brokenRegForm input[name='meterof93']").val(data.meterof93);
			$("#brokenRegForm input[name='meterof94']").val(data.meterof94);
			$("#brokenRegForm input[name='meterof101']").val(data.meterof101);
			$("#brokenRegForm input[name='meterof102']").val(data.meterof102);
			$("#brokenRegForm input[name='meterof103']").val(data.meterof103);
			$("#brokenRegForm input[name='meterof104']").val(data.meterof104);
			$("#brokenRegForm input[name='meterof111']").val(data.meterof111);
			$("#brokenRegForm input[name='meterof112']").val(data.meterof112);
			$("#brokenRegForm input[name='meterof113']").val(data.meterof113);
			$("#brokenRegForm input[name='meterof114']").val(data.meterof114);
			$("#brokenRegForm input[name='meterof121']").val(data.meterof121);
			$("#brokenRegForm input[name='meterof122']").val(data.meterof122);
			$("#brokenRegForm input[name='meterof123']").val(data.meterof123);
			$("#brokenRegForm input[name='meterof124']").val(data.meterof124);
			$("#brokenRegForm input[name='meterof131']").val(data.meterof131);
			$("#brokenRegForm input[name='meterof132']").val(data.meterof132);
			$("#brokenRegForm input[name='meterof133']").val(data.meterof133);
			$("#brokenRegForm input[name='meterof134']").val(data.meterof134);
			$("#brokenRegForm input[name='meterof141']").val(data.meterof141);
			$("#brokenRegForm input[name='meterof142']").val(data.meterof142);
			$("#brokenRegForm input[name='meterof143']").val(data.meterof143);
			$("#brokenRegForm input[name='meterof144']").val(data.meterof144);
			$("#brokenRegForm input[name='meterof151']").val(data.meterof151);
			$("#brokenRegForm input[name='meterof152']").val(data.meterof152);
			$("#brokenRegForm input[name='meterof153']").val(data.meterof153);
			$("#brokenRegForm input[name='meterof154']").val(data.meterof154);
			$("#brokenRegForm input[name='meterof161']").val(data.meterof161);
			$("#brokenRegForm input[name='meterof162']").val(data.meterof162);
			$("#brokenRegForm input[name='meterof163']").val(data.meterof163);
			$("#brokenRegForm input[name='meterof164']").val(data.meterof164);
			$("#brokenRegForm input[name='meterof171']").val(data.meterof171);
			$("#brokenRegForm input[name='meterof172']").val(data.meterof172);
			$("#brokenRegForm input[name='meterof173']").val(data.meterof173);
			$("#brokenRegForm input[name='meterof174']").val(data.meterof174);
			$("#brokenRegForm input[name='meterof181']").val(data.meterof181);
			$("#brokenRegForm input[name='meterof182']").val(data.meterof182);
			$("#brokenRegForm input[name='meterof183']").val(data.meterof183);
			$("#brokenRegForm input[name='meterof184']").val(data.meterof184);
			$("#brokenRegForm input[name='maker']").val(data.maker);
			$("#brokenRegForm textarea[name='bigo']").text(data.bigo);
			
			
			$("#brokenRegForm input[name='registDate']").prop("readonly", true);
			//$("#brokenRegForm input[name='registDate']").datepicker("option", "disabled", true);
			$('#brokenRegForm input[name="pileStandard"]').prop("readonly", true);
			$('#brokenRegForm input[name="pileType"]').prop("readonly", true);
			$("#brokenRegForm input[name='fileWeight']").prop("readonly", true);
			$("#brokenRegForm input[name='maker']").prop("readonly", true);
			
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




function onBrokenPileTypeChange(value){
	
	// || value =="SPHC"
	if(value =="PHC" || value == "UHC"  || value == "UPHC"){
		$("#brokenRegForm").find("#dnrpDiv").hide();
		$("#brokenRegForm").find("#dnrpDiv").attr("disabled", "false");
		
		
		$("#brokenRegForm").find("#phcPileStandardSelect").show();
		$("#brokenRegForm").find("#phcPileStandardSelect").attr("disabled", false);
		
		$("#brokenRegForm").find("#steelPileStandardSelect").hide();
		$("#brokenRegForm").find("#steelPileStandardSelect").attr("disabled", true);
		
		$("#brokenRegForm").find("#meterof16Tr").hide();
		$("#brokenRegForm").find("#meterof16Tr").attr("disabled", "false");
		$("#brokenRegForm").find("#meterof17Tr").hide();
		$("#brokenRegForm").find("#meterof17Tr").attr("disabled", "false");
		$("#brokenRegForm").find("#meterof18Tr").hide();
		$("#brokenRegForm").find("#meterof18Tr").attr("disabled", "false");
		
		$("#brokenRegForm").find("#meterof161Tr").hide();
		$("#brokenRegForm").find("#meterof161Tr").attr("disabled", "false");
		$("#brokenRegForm").find("#meterof171Tr").hide();
		$("#brokenRegForm").find("#meterof171Tr").attr("disabled", "false");
		$("#brokenRegForm").find("#meterof181Tr").hide();
		$("#brokenRegForm").find("#meterof181Tr").attr("disabled", "false");
		
		$("#brokenRegForm").find("#meterof162Tr").hide();
		$("#brokenRegForm").find("#meterof162Tr").attr("disabled", "false");
		$("#brokenRegForm").find("#meterof172Tr").hide();
		$("#brokenRegForm").find("#meterof172Tr").attr("disabled", "false");
		$("#brokenRegForm").find("#meterof182Tr").hide();
		$("#brokenRegForm").find("#meterof182Tr").attr("disabled", "false");
		
		$("#brokenRegForm").find("#meterof163Tr").hide();
		$("#brokenRegForm").find("#meterof163Tr").attr("disabled", "false");
		$("#brokenRegForm").find("#meterof173Tr").hide();
		$("#brokenRegForm").find("#meterof173Tr").attr("disabled", "false");
		$("#brokenRegForm").find("#meterof183Tr").hide();
		$("#brokenRegForm").find("#meterof183Tr").attr("disabled", "false");
		
		$("#brokenRegForm").find("#meterof164Tr").hide();
		$("#brokenRegForm").find("#meterof164Tr").attr("disabled", "false");
		$("#brokenRegForm").find("#meterof174Tr").hide();
		$("#brokenRegForm").find("#meterof174Tr").attr("disabled", "false");
		$("#brokenRegForm").find("#meterof184Tr").hide();
		$("#brokenRegForm").find("#meterof184Tr").attr("disabled", "false");
		
		
		
	}else{
		$("#brokenRegForm").find("#dnrpDiv").show();
		$("#brokenRegForm").find("#dnrpDiv").attr("disabled", "true");
		
		$("#brokenRegForm").find("#phcPileStandardSelect").hide();
		$("#brokenRegForm").find("#phcPileStandardSelect").attr("disabled", true);
		
		
		$("#brokenRegForm").find("#steelPileStandardSelect").show();
		$("#brokenRegForm").find("#steelPileStandardSelect").attr("disabled", false);
		$("#brokenRegForm").find("#steelPileStandardSelect option:eq(0)").prop("selected", true);
		
		
		$("#brokenRegForm").find("#meterof16Tr").show();
		$("#brokenRegForm").find("#meterof16Tr").attr("disabled", "true");
		$("#brokenRegForm").find("#meterof17Tr").show();
		$("#brokenRegForm").find("#meterof17Tr").attr("disabled", "true");
		$("#brokenRegForm").find("#meterof18Tr").show();
		$("#brokenRegForm").find("#meterof18Tr").attr("disabled", "true");
		
		$("#brokenRegForm").find("#meterof161Tr").show();
		$("#brokenRegForm").find("#meterof161Tr").attr("disabled", "true");
		$("#brokenRegForm").find("#meterof171Tr").show();
		$("#brokenRegForm").find("#meterof171Tr").attr("disabled", "true");
		$("#brokenRegForm").find("#meterof181Tr").show();
		$("#brokenRegForm").find("#meterof181Tr").attr("disabled", "true");
		
		$("#brokenRegForm").find("#meterof162Tr").show();
		$("#brokenRegForm").find("#meterof162Tr").attr("disabled", "true");
		$("#brokenRegForm").find("#meterof172Tr").show();
		$("#brokenRegForm").find("#meterof172Tr").attr("disabled", "true");
		$("#brokenRegForm").find("#meterof182Tr").show();
		$("#brokenRegForm").find("#meterof182Tr").attr("disabled", "true");
		
		$("#brokenRegForm").find("#meterof163Tr").show();
		$("#brokenRegForm").find("#meterof163Tr").attr("disabled", "true");
		$("#brokenRegForm").find("#meterof173Tr").show();
		$("#brokenRegForm").find("#meterof173Tr").attr("disabled", "true");
		$("#brokenRegForm").find("#meterof183Tr").show();
		$("#brokenRegForm").find("#meterof183Tr").attr("disabled", "true");

		$("#brokenRegForm").find("#meterof164Tr").show();
		$("#brokenRegForm").find("#meterof164Tr").attr("disabled", "true");
		$("#brokenRegForm").find("#meterof174Tr").show();
		$("#brokenRegForm").find("#meterof174Tr").attr("disabled", "true");
		$("#brokenRegForm").find("#meterof184Tr").show();
		$("#brokenRegForm").find("#meterof184Tr").attr("disabled", "true");
		
	}
	 // display 속성을 none 으로 바꾼다. 
}


function onPileTypeChange(value){
	
	// || value =="SPHC"
	if(value =="PHC" || value == "UHC"  || value == "UPHC"){
		$("#regForm").find("#dnrpDiv").hide();
		$("#regForm").find("#dnrpDiv").attr("disabled", "false");
		
		
		$("#regForm").find("#phcPileStandardSelect").show();
		$("#regForm").find("#phcPileStandardSelect").attr("disabled", false);
		
		$("#regForm").find("#steelPileStandardSelect").hide();
		$("#regForm").find("#steelPileStandardSelect").attr("disabled", true);
		
		$("#regForm").find("#meterof16Tr").hide();
		$("#regForm").find("#meterof16Tr").attr("disabled", "false");
		$("#regForm").find("#meterof17Tr").hide();
		$("#regForm").find("#meterof17Tr").attr("disabled", "false");
		$("#regForm").find("#meterof18Tr").hide();
		$("#regForm").find("#meterof18Tr").attr("disabled", "false");
		
		$("#regForm").find("#meterof161Tr").hide();
		$("#regForm").find("#meterof161Tr").attr("disabled", "false");
		$("#regForm").find("#meterof171Tr").hide();
		$("#regForm").find("#meterof171Tr").attr("disabled", "false");
		$("#regForm").find("#meterof181Tr").hide();
		$("#regForm").find("#meterof181Tr").attr("disabled", "false");
		
		$("#regForm").find("#meterof162Tr").hide();
		$("#regForm").find("#meterof162Tr").attr("disabled", "false");
		$("#regForm").find("#meterof172Tr").hide();
		$("#regForm").find("#meterof172Tr").attr("disabled", "false");
		$("#regForm").find("#meterof182Tr").hide();
		$("#regForm").find("#meterof182Tr").attr("disabled", "false");
		
		$("#regForm").find("#meterof163Tr").hide();
		$("#regForm").find("#meterof163Tr").attr("disabled", "false");
		$("#regForm").find("#meterof173Tr").hide();
		$("#regForm").find("#meterof173Tr").attr("disabled", "false");
		$("#regForm").find("#meterof183Tr").hide();
		$("#regForm").find("#meterof183Tr").attr("disabled", "false");
		
		$("#regForm").find("#meterof164Tr").hide();
		$("#regForm").find("#meterof164Tr").attr("disabled", "false");
		$("#regForm").find("#meterof174Tr").hide();
		$("#regForm").find("#meterof174Tr").attr("disabled", "false");
		$("#regForm").find("#meterof184Tr").hide();
		$("#regForm").find("#meterof184Tr").attr("disabled", "false");
		
		
		
	}else{
		$("#regForm").find("#dnrpDiv").show();
		$("#regForm").find("#dnrpDiv").attr("disabled", "true");
		
		$("#regForm").find("#phcPileStandardSelect").hide();
		$("#regForm").find("#phcPileStandardSelect").attr("disabled", true);
		
		
		$("#regForm").find("#steelPileStandardSelect").show();
		$("#regForm").find("#steelPileStandardSelect").attr("disabled", false);
		$("#regForm").find("#steelPileStandardSelect option:eq(0)").prop("selected", true);
		
		
		$("#regForm").find("#meterof16Tr").show();
		$("#regForm").find("#meterof16Tr").attr("disabled", "true");
		$("#regForm").find("#meterof17Tr").show();
		$("#regForm").find("#meterof17Tr").attr("disabled", "true");
		$("#regForm").find("#meterof18Tr").show();
		$("#regForm").find("#meterof18Tr").attr("disabled", "true");
		
		$("#regForm").find("#meterof161Tr").show();
		$("#regForm").find("#meterof161Tr").attr("disabled", "true");
		$("#regForm").find("#meterof171Tr").show();
		$("#regForm").find("#meterof171Tr").attr("disabled", "true");
		$("#regForm").find("#meterof181Tr").show();
		$("#regForm").find("#meterof181Tr").attr("disabled", "true");
		
		$("#regForm").find("#meterof162Tr").show();
		$("#regForm").find("#meterof162Tr").attr("disabled", "true");
		$("#regForm").find("#meterof172Tr").show();
		$("#regForm").find("#meterof172Tr").attr("disabled", "true");
		$("#regForm").find("#meterof182Tr").show();
		$("#regForm").find("#meterof182Tr").attr("disabled", "true");
		
		$("#regForm").find("#meterof163Tr").show();
		$("#regForm").find("#meterof163Tr").attr("disabled", "true");
		$("#regForm").find("#meterof173Tr").show();
		$("#regForm").find("#meterof173Tr").attr("disabled", "true");
		$("#regForm").find("#meterof183Tr").show();
		$("#regForm").find("#meterof183Tr").attr("disabled", "true");

		$("#regForm").find("#meterof164Tr").show();
		$("#regForm").find("#meterof164Tr").attr("disabled", "true");
		$("#regForm").find("#meterof174Tr").show();
		$("#regForm").find("#meterof174Tr").attr("disabled", "true");
		$("#regForm").find("#meterof184Tr").show();
		$("#regForm").find("#meterof184Tr").attr("disabled", "true");
		
	}
	 // display 속성을 none 으로 바꾼다. 
}





$('.popClose').on('click', function(e){
	$('.popUp').hide();
	$('.popLayer').hide();
	$('body').css('overflow', 'auto');
});

$('#regBtn').on('click', function(e){
	checkValidation();
	//$('#regForm').submit();
});

$('#brokenRegBtn').on('click', function(e){
	checkBrokenValidation();
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
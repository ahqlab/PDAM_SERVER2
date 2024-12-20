<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/tagLib.jsp" %>
<script type="text/javascript">
$( document ).ready( function() {
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
</script>
<!--컨텐츠-->
		<div class="section-right">
			<div class="TopContArea">
				<div class="titArea mb-40">
					<p class="h1Tit">시험성적표관리</p>
					<%-- <div class="popBtn" onclick="location.href='${pageContext.request.contextPath}/fileinventory/regist2?constructionIdx=${param.constructionIdx}&pileType=PHC'">파일 등록</div> --%>
				</div>
				
				<!--검색-->
				<form:form id="searchForm" commandName="domainParam" method="POST">
					<form:hidden path="currentPage"/>
						<div class="searchArea">
							<div class="searchArea01" style="width: 100%;">
								<form:select class="select01" path="searchMfr" onchange="javascript:onSMfrChange();">
				                	<form:option value="SOKKIA">SOKKIA</form:option>
				                	<form:option value="TOPCON">TOPCON</form:option>
								</form:select>
								<form:select id="searchForm"  path="searchField">
				                    <form:option value="sn">측정기S/N</form:option>
								</form:select>
								<form:input path="searchWord" class="searchin"  style="width:30%;" placeholder="검색어를 입력하세요."/>
								<div class="searchBtn">
									<img id="submitBtn" src="${pageContext.request.contextPath}/new/img/search.png" style="cursor:pointer;">
								</div>
							</div>
						</div>
				</form:form>
			</div>

			<!--공지리스트-->
			<div class="min640">
				<table class="table_board_for type_a">
					<colgroup>
						<col width="10%">
						<col width="10%;">
						<col width="10%;">
						<col width="10%;">
						<col width="20%;">
						<col width="*%;">
						<col width="10%;">
						<col width="10%;">
					</colgroup>
					<tr>
						<th scope="col">NO</th>
						<th scope="col">제조사</th>
						<th scope="col">측정기종류</th>
						<th scope="col">측정기S/N</th>
						<th scope="col">파일명</th>
						<th scope="col">비고</th>
						<th scope="col">정보변경</th>
						<th scope="col">삭제</th>
					</tr>
					<!--리스트 한페이지에 최대10개-->
					<c:forEach var="domain" items="${domainList}" varStatus="status">
					<tr class="">
						<%-- <td class="text_left">
							<a href="./notice-view.html">[테스트글] 테스트페이지 현재 코딩작업 중</a>
						</td>
						<td>
							<img src="${pageContext.request.contextPath}/new/img/file-download.png" class="file-img" alt="파일첨부"><!--파일첨부시-->
						</td>
						<td>관리자</td>
						<td>2023.02.06</td> --%>
						<td>${domain.no}</td>
						<td>${domain.mfr}</td>
						<td>${domain.type}</td>
						<td>${domain.sn}</td>
						<td><a href="javascript:TestReportFileDownload('${pageContext.request.contextPath}','${pageContext.request.contextPath}/treport/download/test/report?sn=${domain.sn}', '${domain.sn}');">${domain.fileName}</a></td>
						<td>${domain.bigo}</td>	
						<td><a href="${pageContext.request.contextPath}/treport/update?id=${domain.idx}">[정보변경]</a></td>	
						<td><a href="javascript:onClickDeleteBtn(${domain.idx});"  style="cursor:pointer;">[삭제]</a></td>		
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
					
					
				<!--//공지리스트-->

			<a class="goWrite" href="${pageContext.request.contextPath}/treport/regist">등록</a>
			
			</div>
			

			<!--페이징-->
			<%@ include file="/WEB-INF/views/common/pagination.jsp"%>
			<!--//페이징-->

			
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
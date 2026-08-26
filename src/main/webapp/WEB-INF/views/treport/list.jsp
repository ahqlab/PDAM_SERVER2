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
			<%@ include file="/WEB-INF/views/common/welcomeMsg.jsp" %>
			<div class="TopContArea">
				<div class="titArea">
					<p class="h1Tit">시험성적표관리</p>
					<%-- <div class="popBtn" onclick="location.href='${pageContext.request.contextPath}/fileinventory/regist2?constructionIdx=${param.constructionIdx}&pileType=PHC'">파일 등록</div> --%>
					<a class="popBtn popBtnRegist" href="${pageContext.request.contextPath}/treport/regist">시험성적표 등록</a>
				</div>
				
				<!--검색-->
				<form:form id="searchForm" commandName="domainParam" method="POST">
					<form:hidden path="currentPage"/>
						<div class="searchArea">
							<div class="searchArea01">
								<form:select class="select01" path="searchMfr" onchange="javascript:onSMfrChange();">
				                	<form:option value="SOKKIA">SOKKIA</form:option>
				                	<form:option value="TOPCON">TOPCON</form:option>
								</form:select>
								<form:select path="searchField">
				                    <form:option value="sn">측정기S/N</form:option>
								</form:select>
								<form:input path="searchWord" class="searchin" placeholder="검색어를 입력하세요."/>
								<div class="searchBtn">
									<img id="submitBtn" src="${pageContext.request.contextPath}/new/img/search.png" style="cursor:pointer;">
								</div>
							</div>
						</div>
				</form:form>
			</div>

			<!--공지리스트-->
			<div class="listArea" style="padding:20px;">
				<!-- PC 테이블 뷰 -->
				<div class="pc-table-wrap" style="overflow-x:auto;">
					<table style="width:100%; min-width:700px; border-collapse:collapse;">
						<thead>
							<tr style="background:#f5f5f5; border-bottom:2px solid #ddd;">
								<th style="padding:10px; text-align:center; width:60px; white-space:nowrap;">NO</th>
								<th style="padding:10px; text-align:center; min-width:100px; white-space:nowrap;">제조사</th>
								<th style="padding:10px; text-align:center; min-width:110px; white-space:nowrap;">측정기종류</th>
								<th style="padding:10px; text-align:center; min-width:130px; white-space:nowrap;">측정기S/N</th>
								<th style="padding:10px; text-align:center;">파일명</th>
								<th style="padding:10px; text-align:center; min-width:120px;">비고</th>
								<th style="padding:10px; text-align:center; width:80px; white-space:nowrap;">정보변경</th>
								<th style="padding:10px; text-align:center; width:70px; white-space:nowrap;">삭제</th>
							</tr>
						</thead>
						<tbody id="reportTbody">
							<!--리스트 한페이지에 최대10개-->
							<c:forEach var="domain" items="${domainList}" varStatus="status">
							<tr style="border-bottom:1px solid #eee;">
								<td style="padding:10px; text-align:center; border:1px solid #eee; white-space:nowrap;">${domain.no}</td>
								<td style="padding:10px; text-align:center; border:1px solid #eee; white-space:nowrap;">${domain.mfr}</td>
								<td style="padding:10px; text-align:center; border:1px solid #eee; white-space:nowrap;">${domain.type}</td>
								<td style="padding:10px; text-align:center; border:1px solid #eee; white-space:nowrap;">${domain.sn}</td>
								<td style="padding:10px; border:1px solid #eee;">
									<a href="javascript:TestReportFileDownload('${pageContext.request.contextPath}','${pageContext.request.contextPath}/treport/download/test/report?sn=${domain.sn}', '${domain.sn}');" style="color:#077b9c; text-decoration:underline;">${domain.fileName}</a>
								</td>
								<td style="padding:10px; border:1px solid #eee;">${domain.bigo}</td>	
								<td style="padding:10px; text-align:center; border:1px solid #eee; white-space:nowrap;">
									<a href="${pageContext.request.contextPath}/treport/update?id=${domain.idx}" style="padding:4px 10px; background:#337ab7; color:#fff; border-radius:3px; font-size:12px; text-decoration:none; display:inline-block;">변경</a>
								</td>	
								<td style="padding:10px; text-align:center; border:1px solid #eee; white-space:nowrap;">
									<a href="javascript:onClickDeleteBtn(${domain.idx});" style="padding:4px 10px; background:#d9534f; color:#fff; border-radius:3px; font-size:12px; text-decoration:none; display:inline-block; cursor:pointer;">삭제</a>
								</td>		
							</tr>
							</c:forEach>
							<c:choose>
								<c:when test="${fn:length(domainList) == 0}">
									<tr>
										<td colspan="8" style="text-align:center; padding:24px; color:#999;">등록된 데이터가 없습니다.</td>
									</tr>
								</c:when>
							</c:choose>
						</tbody>
					</table>
				</div>

				<!-- 모바일 카드형 뷰 (반응형 대응) -->
				<div id="reportCards" style="display:none; margin-top:10px;">
					<c:forEach var="domain" items="${domainList}" varStatus="status">
						<div style="background:#fff; border:1px solid #ddd; border-radius:6px; padding:14px 16px; margin-bottom:10px;">
							<div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:8px;">
								<span style="font-weight:bold; font-size:15px; color:#333;">[${domain.mfr}] ${domain.sn}</span>
								<div>
									<a href="${pageContext.request.contextPath}/treport/update?id=${domain.idx}" style="padding:3px 8px; background:#337ab7; color:#fff; border-radius:3px; font-size:11px; text-decoration:none; margin-right:4px;">변경</a>
									<a href="javascript:onClickDeleteBtn(${domain.idx});" style="padding:3px 8px; background:#d9534f; color:#fff; border-radius:3px; font-size:11px; text-decoration:none;">삭제</a>
								</div>
							</div>
							<table style="width:100%; font-size:13px; border-collapse:collapse;">
								<tr><td style="color:#888; padding:3px 8px 3px 0; width:80px;">측정기종류</td><td style="padding:3px 0;">${domain.type}</td></tr>
								<tr><td style="color:#888; padding:3px 8px 3px 0;">파일명</td><td style="padding:3px 0;"><a href="javascript:TestReportFileDownload('${pageContext.request.contextPath}','${pageContext.request.contextPath}/treport/download/test/report?sn=${domain.sn}', '${domain.sn}');" style="color:#077b9c; text-decoration:underline;">${domain.fileName}</a></td></tr>
								<tr><td style="color:#888; padding:3px 8px 3px 0;">비고</td><td style="padding:3px 0;">${domain.bigo}</td></tr>
							</table>
						</div>
					</c:forEach>
					<c:if test="${fn:length(domainList) == 0}">
						<p style="text-align:center; padding:24px; color:#999;">등록된 데이터가 없습니다.</p>
					</c:if>
				</div>
			</div>
			<!--//공지리스트-->
			

			<!--페이징-->
			<%@ include file="/WEB-INF/views/common/pagination.jsp"%>
			<!--//페이징-->

			
		</div>
		<!--//컨텐츠-->

<style>
@media (max-width: 600px) {
	.pc-table-wrap { display: none !important; }
	#reportCards { display: block !important; }
}
#reportTbody tr:hover {
	background-color: #f9f9f9;
}
.listArea {
    background: #fff;
    border-radius: 8px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.05);
    padding: 20px;
}

@media (max-width: 1023px) {
	.searchArea01 .topArea,
	.searchArea01 .titleBox,
	.searchArea01 > p:first-child {
		display: flex;
		flex-direction: column;
		align-items: flex-start;
		justify-content: flex-start;
		width: 100%;
		height: auto;
		float: none;
		gap: 8px;
		margin-bottom: 12px;
	}

	.searchArea01 h2,
	.searchArea01 .title,
	.searchArea01 > p:first-child > span:first-child {
		display: block;
		width: 100%;
		font-size: 18px;
		line-height: 1.3;
		white-space: nowrap;
		word-break: keep-all;
		float: none;
	}

	.searchArea01 a,
	.searchArea01 button,
	.searchArea01 .btn,
	.searchArea01 .btnArea {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		position: static;
		float: none;
		width: auto;
		height: 36px;
		padding: 0 12px;
		margin: 0;
		white-space: nowrap;
		word-break: keep-all;
	}

	.searchArea01,
	.searchArea01 form,
	.searchArea01 .searchBox {
		display: flex;
		flex-wrap: wrap;
		width: 100%;
		box-sizing: border-box;
		gap: 6px;
	}

	.searchArea01 select,
	.searchArea01 input[type="text"] {
		flex: 1 1 calc(50% - 6px); 
		min-width: 120px;
		box-sizing: border-box;
	}

	.searchArea01 .btnSearch,
	.searchArea01 button[type="submit"] {
		flex: 0 0 auto;
	}
}
</style>

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
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/tagLib.jsp" %>
<script type="text/javascript">

$(document).ready( function() {
    $('#submitBtn').click( function() {
    	searchForm();
    });
});

function goUrl(url){
	document.location.href=url;
}

function searchForm(){
	$('#currentPage').val(1);
	$("#searchForm").attr("action", "");
	$("#searchForm").submit();
}

</script>

<!--컨텐츠-->
<div class="section-right">
	<div class="TopContArea">
		<div class="titArea mb-40">
			<p class="h1Tit">${device.machineNumber} 시공현황</p>
			<div class="titBtnArea">
				<c:choose>
					<c:when test="${sessionInfo.role == 1}">
						<div class="printBtn02" onclick="goUrl('${pageContext.request.contextPath}/report/list?id=${param.id}&type=all&constructionIdx=${sessionInfo.constructionIdx}');">총 작업내역</div>
						<div class="printBtn" onclick="goUrl('${pageContext.request.contextPath}/report/list?id=${param.id}&date=today&constructionIdx=${sessionInfo.constructionIdx}');">금일작업내역</div>
						
					</c:when>
					<c:otherwise>
						<div class="printBtn02" onclick="goUrl('${pageContext.request.contextPath}/report/list?id=${param.id}&type=all&constructionIdx=${param.constructionIdx}');">총 작업내역</div>
						<div class="printBtn" onclick="goUrl('${pageContext.request.contextPath}/report/list?id=${param.id}&date=today&constructionIdx=${param.constructionIdx}');">금일작업내역</div>
					</c:otherwise>
				</c:choose>
			</div>
		</div>
		
		<!--검색-->
		<form:form id="searchForm" commandName="domainParam" method="POST">
			<form:hidden path="currentPage"/>
			<div class="searchArea">
				<div class="searchArea02">
					<form:input path="startDate" class="inputDate datepicker" placeholder="시작일"/>
					<span>~</span>
					<form:input path="endDate" class="inputDate datepicker" placeholder="종료일"/>
					<div class="searchBtn">
						<img src="${pageContext.request.contextPath}/new/img/search.png" style="cursor:pointer;" onclick="javascript:searchForm();">
					</div>
				</div>
			</div>
		
		</form:form>
	</div>
				
	<p class="listCount mb-15">총 시공량 <span>${totalConstruction}</span>공</p>
	
	<div class="min485">
		<div class="tableArea">
			
			<div class="viewTable viewTable04">
				<ul class="viewTh">
				
				<c:choose>
					<c:when test="${originDataYn > 0}">
						<li  style="width: calc(100% / 3);">시공일</li>
						<li  style="width: calc(100% / 3);">금일시공량</li>
						<c:choose>
							<c:when test="${originDataYn > 0}">
								<li  style="width: calc(100% / 3);">원본데이터</li>
							</c:when>
						</c:choose>
					</c:when>
					<c:otherwise>
						<li  style="width: calc(100% / 2);">시공일</li>
						<li  style="width: calc(100% / 2);">금일시공량</li>
					</c:otherwise>
				</c:choose>
				</ul>
				
				<div class="tableScroll">
					<table>
						<c:forEach var="domain" items="${domainList}"  varStatus="status">
							<c:choose>
								<c:when test="${originDataYn > 0}">
									<tr>
										<td style="width: calc(100% / 3);">${domain.currentDateTime} 
											<c:choose>
												<c:when test="${sessionInfo.role == 0}">
													<a href="${pageContext.request.contextPath}/report/list?id=${param.id}&date=${domain.currentDateTime}&constructionIdx=${param.constructionIdx}" class="tableCheck">기록지확인</a>
												</c:when>
												<c:when test="${sessionInfo.role == 1}">
													<a href="${pageContext.request.contextPath}/report/list?id=${param.id}&date=${domain.currentDateTime}&constructionIdx=${sessionInfo.constructionIdx}" class="tableCheck">기록지확인</a>
												</c:when>
												<c:when test="${sessionInfo.role == 2}">
													<a href="${pageContext.request.contextPath}/report/list?id=${param.id}&date=${domain.currentDateTime}&constructionIdx=${param.constructionIdx}" class="tableCheck">기록지확인</a>
												</c:when>
												<c:when test="${sessionInfo.role == 3}">
													<a href="${pageContext.request.contextPath}/report/list?id=${param.id}&date=${domain.currentDateTime}&constructionIdx=${param.constructionIdx}" class="tableCheck">기록지확인</a>
												</c:when>
											</c:choose>
										</td>
										<td  style="width: calc(100% / 3);">${domain.todayConstruction}공</td>
										<c:choose>
											<c:when test="${originDataYn > 0}">
													<td  style="width: calc(100% / 3);">${domain.currentDateTime}
														<c:choose>
															<c:when test="${sessionInfo.role == 0}">
																<a href="${pageContext.request.contextPath}/report/origin/list?id=${param.id}&date=${domain.currentDateTime}&constructionIdx=${param.constructionIdx}" class="tableCheck">원본기록지확인</a>
															</c:when>
															<c:when test="${sessionInfo.role == 1}">
																<a href="${pageContext.request.contextPath}/report/origin/list?id=${param.id}&date=${domain.currentDateTime}&constructionIdx=${sessionInfo.constructionIdx}"  class="tableCheck">원본기록지확인</a>
															</c:when>
															<c:when test="${sessionInfo.role == 2}">
																<a href="${pageContext.request.contextPath}/report/origin/list?id=${param.id}&date=${domain.currentDateTime}&constructionIdx=${param.constructionIdx}"  class="tableCheck">원본기록지확인</a>
															</c:when>
															<c:when test="${sessionInfo.role == 3}">
																<a href="${pageContext.request.contextPath}/report/origin/list?id=${param.id}&date=${domain.currentDateTime}&constructionIdx=${param.constructionIdx}"  class="tableCheck">원본기록지확인</a>
															</c:when>
														</c:choose>
													</td>
											</c:when>
										</c:choose>
									</tr>
								</c:when>
								<c:otherwise>
									<tr>
										<td>${domain.currentDateTime} 
											<c:choose>
												<c:when test="${sessionInfo.role == 0}">
													<a href="${pageContext.request.contextPath}/report/list?id=${param.id}&date=${domain.currentDateTime}&constructionIdx=${param.constructionIdx}" class="tableCheck">기록지확인</a>
												</c:when>
												<c:when test="${sessionInfo.role == 1}">
													<a href="${pageContext.request.contextPath}/report/list?id=${param.id}&date=${domain.currentDateTime}&constructionIdx=${sessionInfo.constructionIdx}" class="tableCheck">기록지확인</a>
												</c:when>
												<c:when test="${sessionInfo.role == 2}">
													<a href="${pageContext.request.contextPath}/report/list?id=${param.id}&date=${domain.currentDateTime}&constructionIdx=${param.constructionIdx}" class="tableCheck">기록지확인</a>
												</c:when>
												<c:when test="${sessionInfo.role == 3}">
													<a href="${pageContext.request.contextPath}/report/list?id=${param.id}&date=${domain.currentDateTime}&constructionIdx=${param.constructionIdx}" class="tableCheck">기록지확인</a>
												</c:when>
											</c:choose>
										</td>
										<td>${domain.todayConstruction}공</td>
										
									</tr>
								</c:otherwise>
							</c:choose>
						
							
						</c:forEach>
						<c:choose>
							<c:when test="${fn:length(domainList) == 0}">
								<tr>	
									<c:choose>
										<c:when test="${originDataYn > 0}">
											<td colspan="3">등록된 데이터가 없습니다.</td>
										</c:when>
										<c:otherwise>
											<td colspan="2">등록된 데이터가 없습니다.</td>
										</c:otherwise>
									</c:choose>
									
								</tr>
							</c:when>
						</c:choose>
			

						<!--데이터가 없을 경우-->
						<!--  -->
						<!--//데이터가 없을 경우-->
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


<!-- 팝업 -->
<script>
$('.popUp').hide();
$('.popLayer').hide();

$('.popBtn, .tableChange').on('click', function(e){
	$('.popUp').show();
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
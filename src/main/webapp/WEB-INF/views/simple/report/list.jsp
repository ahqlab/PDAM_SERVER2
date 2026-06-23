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


	var drivingRecordParams = null;

	function openDrivingRecordPopup(contextPath, constructionIdx, machineNumber, currentDateTime) {
	    drivingRecordParams = {
	        contextPath: contextPath,
	        constructionIdx: constructionIdx,
	        machineNumber: machineNumber,
	        currentDateTime: currentDateTime
	    };

	    document.getElementById('drivingRecordOverlay').style.display = 'block';
	    document.getElementById('drivingRecordPopup').style.display = 'block';
	}

	function closeDrivingRecordPopup() {
	    document.getElementById('drivingRecordOverlay').style.display = 'none';
	    document.getElementById('drivingRecordPopup').style.display = 'none';
	}

	function confirmDrivingRecordDownload() {
	    var radios = document.getElementsByName('hitOption');
	    var hitOption = 'N';   // 기본값

	    for (var i = 0; i < radios.length; i++) {
	        if (radios[i].checked) {
	            hitOption = radios[i].value;
	            break;
	        }
	    }
	    closeDrivingRecordPopup();

	    downloadDrivingRecoredBook(
	        drivingRecordParams.contextPath,
	        drivingRecordParams.constructionIdx,
	        drivingRecordParams.machineNumber,
	        drivingRecordParams.currentDateTime,
	        hitOption
	    );
	}

</script>

<!--컨텐츠-->
<div class="section-right">
	<%@ include file="/WEB-INF/views/common/welcomeMsg.jsp" %>
	<div class="TopContArea">
		<div class="titArea mb-40">
			<p class="h1Tit">${domain.machineNumber} 시공현황</p>
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

			<%-- 컬럼 표시 여부: 원본데이터/휴지통은 권한(settingRequired 현장) 기반, PDF는 기존 로직 유지 --%>
			<c:set var="showOriginData" value="${originDataYn > 0}" />
			<c:set var="showTrash" value="${not sessionScope.settingRequired or (sessionScope.isHiddenManager ? sessionScope.constructionSetting.useAdminTrash : sessionScope.constructionSetting.useGuestTrash)}" />
			<c:set var="showPdf" value="${sessionInfo.role == 0 or sessionInfo.showPdfYn or showPdfYn > 0 or sessionInfo.userId == 'ji2177' or sessionInfo.constructionIdx == 738}" />
			<c:set var="conIdx" value="${sessionInfo.role == 1 ? sessionInfo.constructionIdx : param.constructionIdx}" />
			<c:set var="colCount" value="2" />
			<c:if test="${showOriginData}"><c:set var="colCount" value="${colCount + 1}" /></c:if>
			<c:if test="${showTrash}"><c:set var="colCount" value="${colCount + 1}" /></c:if>
			<c:set var="colWidth" value="${100 / colCount}%" />

			<div class="viewTable viewTable04">
				<ul class="viewTh">
					<li style="width: ${colWidth};">시공일</li>
					<li style="width: ${colWidth};">금일시공량</li>
					<c:if test="${showOriginData}"><li style="width: ${colWidth};">원본데이터</li></c:if>
					<c:if test="${showTrash}"><li style="width: ${colWidth};">휴지통</li></c:if>
				</ul>

				<div class="tableScroll">
					<table>
						<c:forEach var="domain" items="${domainList}" varStatus="status">
							<tr>
								<td style="width: ${colWidth};">
									${domain.currentDateTime}
									<a href="${pageContext.request.contextPath}/report/list?id=${param.id}&date=${domain.currentDateTime}&constructionIdx=${conIdx}" class="tableCheck">기록지확인</a>
									<c:if test="${showPdf}">
										<c:choose>
											<c:when test="${(sessionInfo.constructionIdx == 1550 or param.constructionIdx == 1550) and (sessionInfo.hiddenManager == true or sessionInfo.role == 0)}">
												<a href="javascript:openDrivingRecordPopup('${pageContext.request.contextPath}', '${conIdx}', '${domain.machineNumber}', '${domain.currentDateTime}');" class="tableCheckGreen">일일 기록지 PDF</a>
											</c:when>
											<c:otherwise>
												<a href="javascript:downloadDrivingRecoredBook('${pageContext.request.contextPath}', '${conIdx}', '${domain.machineNumber}', '${domain.currentDateTime}' , 'N');" class="tableCheckGreen">일일 기록지 PDF</a>
											</c:otherwise>
										</c:choose>
									</c:if>
								</td>
								<td style="width: ${colWidth};">${domain.todayConstruction}공</td>
								<c:if test="${showOriginData}">
									<td style="width: ${colWidth};">
										<a href="${pageContext.request.contextPath}/report/origin/list?id=${param.id}&date=${domain.currentDateTime}&constructionIdx=${conIdx}" class="tableCheck">원본기록지확인</a>
									</td>
								</c:if>
								<c:if test="${showTrash}">
									<td style="width: ${colWidth};">
										<a href="${pageContext.request.contextPath}/trashbin/list?id=${param.id}&date=${domain.currentDateTime}&constructionIdx=${conIdx}" class="tableCheck">휴지통</a>
									</td>
								</c:if>
							</tr>
						</c:forEach>
						<c:if test="${fn:length(domainList) == 0}">
							<tr><td colspan="${colCount}">등록된 데이터가 없습니다.</td></tr>
						</c:if>
					</table>
				</div>
			</div>
		</div>
	</div>


	<div id="drivingRecordOverlay" style="display:none;"></div>

		<div id="drivingRecordPopup" style="display:none;">
		    <div class="popup-title">일일 기록지 PDF</div>

		    <div class="popup-content">
		        <label>
		            <input type="radio" name="hitOption" value="N" checked>
	            		타격횟수 미포함
		        </label>
		        <br>
		        <label>
		            <input type="radio" name="hitOption" value="Y">
		           		 타격횟수 포함
		        </label>
		    </div>

		    <div class="popup-footer">
		        <button type="button" onclick="closeDrivingRecordPopup()">닫기</button>
		        <button type="button" onclick="confirmDrivingRecordDownload()">PDF 생성</button>
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

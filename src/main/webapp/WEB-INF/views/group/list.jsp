<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/tagLib.jsp" %>
<script>
$( document ).ready( function() {
    $('#submitBtn').click( function() {
    	$('#searchForm').submit();
    });
  });
  
function checkDuplicateGroupName(){
	var groupName = $('#groupName').val();
	var result = 0;
	jQuery.ajax({
		type : "POST",
		url : "${pageContext.request.contextPath}/group/duplicate/check",
		async : false,  // 요청 시 동기화 여부. 기본은 비동기(asynchronous) 요청 (default: true)
		data:  {
			groupName : groupName
		},
		success : function(data) {	
			result = data;
		},
		complete : function(data) {
		},
		error : function(xhr, status, error) {
		}
	}); 
	return result;
 }
  
  function regGroup(){
	
	var result = checkDuplicateGroupName();  
	if(result > 0){
		alert('이미 등록된 같은 이름의 시공사가 존재합니다.');
		return;
	}
	
	if($('#groupName').val() == ''){
		alert('시공사명을 입력하세요.');
		return false;
	}else{
		var myObject = new Object(); 
		myObject.idx = new Number(0);
		myObject.groupName = $('#groupName').val();
		myObject.deviceAmount = '';
		myObject.cprtCompanyAmount = '';
		myObject.franchAmount = '';
		myObject.isDel = new Number(0);
		myObject.createDate = '';
		myObject.lastModifiedDate = '';
		myObject.userId = '';
		myObject.password = '';
		myObject.role = new Number(0);
		var json = JSON.stringify(myObject);
		
		var result = 0;
		jQuery.ajax({
			type : "POST",
			url : "${pageContext.request.contextPath}/group/registAjax",
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
				$('.popUp').hide();
				$('.popLayer').hide();
				$('body').css('overflow', 'auto');
			}
		}); 
	}  
  }
</script>

<!--컨텐츠-->
		<div class="section-right">
			<%@ include file="/WEB-INF/views/common/welcomeMsg.jsp" %>
			<div class="TopContArea">
				<div class="titArea">
					<p class="h1Tit">시공사 리스트</p>
						<div class="popBtn">시공사 등록</div>
				</div>
				
				<!--검색-->
				<form:form id="searchForm" commandName="domainParam" method="POST">
					<div class="searchArea">
						<div class="searchArea01">
							<form:hidden path="currentPage"/>
							<form:select path="searchField">
			                	<form:option value="groupName">시공사</form:option>
							</form:select>
							<form:input path="searchWord" class="searchin" placeholder="검색어를 입력하세요."/>
							<div class="searchBtn">
								<img id="submitBtn" src="${pageContext.request.contextPath}/new/img/search.png" style="cursor:pointer;">
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
			
			<!--검색된 리스트 10개씩 노출-->
			<div class="listArea">
				<div class="flex">
					<p class="listCount">협력사  <span>${constructionCount}</span> / 본사 운영장비 <span>${deviceCount}</span> / 가맹 운영장비 <span>${devicePrenchCount}</span> / 예비용 장비 <span>${spareDeviceCount}</span></p>
					<!-- <div class="buildDown">시행 협력사 정보</div> -->
				</div>
				
				<ul class="listUl cross" >
				
					<c:forEach var="domain" items="${domainList}"  varStatus="status">
					<c:choose>
						<c:when test="${domain.newContent == 0}">
							<li style="background-color: #fff9c7; padding: 15px 15px;" onclick="location.href='${pageContext.request.contextPath}/construction/list?groupIdx=${domain.idx}'">	
						</c:when>
						<c:otherwise>
							<li style="padding: 15px 15px;" onclick="location.href='${pageContext.request.contextPath}/construction/list?groupIdx=${domain.idx}'">
						</c:otherwise>
					</c:choose>
						
						<p class="buildTxt">
							${domain.groupName}
							<c:choose>
								<c:when test="${domain.newContent == 0}">
									<font color="red">new</font>	
								</c:when>
							</c:choose>
						</p>
						<div class="CountArea01">
							<div class="CountBox01">
								<img src="${pageContext.request.contextPath}/new/img/buildIcon01.png" />
								<div>
									<p class="s1">협력사</p>
									<p class="s2">${domain.cprtCompanyAmount} 개</p>
								</div>
							</div>
							<div class="CountBox01">
								<img src="${pageContext.request.contextPath}/new/img/buildIcon02.png" />
								<div>
									<p class="s1">본사 운영장비</p>
									<p class="s2">${domain.deviceAmount} 대</p>
								</div>
							</div>
							<div class="CountBox01">
								<img src="${pageContext.request.contextPath}/new/img/buildIcon03.png" />
								<div>
									<p class="s1">가맹 운영장비</p>
									<p class="s2">${domain.franchAmount} 대</p>
								</div>
							</div>
							<div class="CountBox01">
								<img src="${pageContext.request.contextPath}/new/img/buildIcon04.png" />
								<div>
									<p class="s1">예비용 장비</p>
									<p class="s2">${domain.spareDeviceAmount} 대</p>
								</div>
							</div>
						</div>
					</li>
					</c:forEach>
				</ul>
			</div>
			<!--//검색된 리스트 10개씩 노출-->

			<!--페이징-->			
			<%@ include file="/WEB-INF/views/common/pagination.jsp" %>
			<!--//페이징-->
		</div>
		<!--//컨텐츠-->
		
		<!--시공사 등록 팝업-->
		<div class="popUp">
			<div class="popTit">
				<p>시공사 등록</p>
				<img class="popClose" src="${pageContext.request.contextPath}/new/img/popclose.png" />
			</div>
			<div class="popCont">
				<form id="regForm" name="regForm">
				<div class="inputArea02 mb-20">
					<p class="inputTxt02">시공사명</p>
					<input type="text" class="Input02" id="groupName" name="groupName" value="" placeholder="시공사명을 입력하세요.">
				</div>
				<div class="popAdd" onclick="javascript:regGroup();">등록</div>
				</form>
			</div>
		</div>

		<div class="popLayer"></div>
		<!--//시공사 등록 팝업-->
		
		
		
		
<!-- 팝업 -->
<script>
$('.popUp').hide();
$('.popLayer').hide();

$('.popBtn').on('click', function(e){
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
$(document).ready(function() {
	$(".navBtn").click(function() {
		$(".left-menu").animate({
			"left": "0%"
		}, 500);
	});
	$(".m-closeBtn").click(function(){
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
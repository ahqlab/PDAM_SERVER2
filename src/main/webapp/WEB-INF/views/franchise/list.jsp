<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/tagLib.jsp" %>
<script>
$( document ).ready( function() {
    $('#submitBtn').click( function() {
    	$('#searchForm').submit();
    });
  });
  	function submitSearchForm(){
  		$('#searchForm').submit();
  	}
	function submitFrom(){
		
		
		var passwordRegex = /^[A-Za-z0-9]{6,12}$/;
		
		if($('#fcName').val() == ''){
			alert('가맹점명을 입력하세요.');
			return false;
		}else if($('#password').val() == ''){
			alert('비밀번호를 입력하세요.');
			return false;
		}else if(!passwordRegex.test($('#password').val())){
			alert('숫자와 문자 포함  6~12자리 비밀번호를 입력하세요.');
			return false;
		}else if($('#confirmPassword').val() == ''){
			alert('확인 비밀번호를 입력하세요.');
			return false;
		}else if(!passwordRegex.test($('#confirmPassword').val())){
			alert('숫자와 문자 포함  6~12자리 비밀번호를 입력하세요.');
			return false;
		}else if($('#password').val() != $('#confirmPassword').val()){
			alert('비밀번호가 맞지 않습니다. 비밀번호를 확인하세요.');
			return false;
		}
		
		
		registFrenchise();		
	}
  
  	function registFrenchise(){
  		var myObject = new Object(); 
  		myObject.idx = new Number(0);
  		myObject.fcName = $('#fcName').val();
  		myObject.userId =  $('#userId').val();
  		myObject.password = $('#password').val();
  		myObject.isDel = new Number(0);
  		myObject.createDate = '';
  		myObject.lastModifiedDate = '';
  		myObject.role = new Number(3);
  		var myString = JSON.stringify(myObject); 
  		jQuery.ajax({
  			type : "POST",
  			url : "${pageContext.request.contextPath}/franchise/registAjax",
  		    contentType : "application/json",
  			async : false,  // 요청 시 동기화 여부. 기본은 비동기(asynchronous) 요청 (default: true)
  			data:  JSON.stringify(myObject),
  			success : function(data) {
  				closePopup();
  				submitSearchForm();
  			},
  			complete : function(data) {
  				closePopup();
  			},
  			error : function(xhr, status, error) {
  				closePopup();
  			}
  		});
  		return;
  	}
  	
 	function closePopup(){
 		$('.popUp').hide();
		$('.popLayer').hide();
		$('body').css('overflow', 'auto');
 	}
	
</script>
<!--컨텐츠-->
<div class="section-right">
	<%@ include file="/WEB-INF/views/common/welcomeMsg.jsp" %>
	<div class="TopContArea">
		<div class="titArea">
			<p class="h1Tit">가맹점 & 협약업체 리스트</p>
			<div class="popBtn">가맹점 & 협약업체 등록</div>
		</div>
		<!--검색-->
		<form:form id="searchForm" commandName="domainParam" method="POST">
			<form:hidden path="currentPage"/>
			<div class="searchArea">
				<div class="searchArea01">
					<form:select path="searchField">
	                	<form:option value="fcName">업체명</form:option>
					</form:select>
					<form:input path="searchWord" class="searchin" placeholder="검색어를 입력하세요."/>
					<div class="searchBtn">
						<img id="submitBtn" src="${pageContext.request.contextPath}/new/img/search.png" style="cursor:pointer;">
					</div>
				</div>
			</div>
		</form:form>
		<!-- 검색끝 -->
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
		<p class="listCount">노출된 <span>${fn:length(domainList)}</span>개의 리스트</p>
		<ul class="listUl cross">
			<c:forEach var="domain" items="${domainList}"  varStatus="status">
				<li onclick="location.href='${pageContext.request.contextPath}/construction/list?fcIdx=${domain.idx}'">
					<div class="franIcon">
						<img src="${pageContext.request.contextPath}/new/img/franchiseIcon.png" /> 
					</div>
					<p class="franTxt">${domain.fcName} 
						<c:choose>
							<c:when test="${domain.role == 3}">
								(가맹점)
							</c:when>
							<c:otherwise>
								(협약업체)
							</c:otherwise>
						</c:choose>
					</p>
				</li>
			</c:forEach>
		</ul>
	</div>
	<!--//검색된 리스트 10개씩 노출-->

	<!--페이징-->
	<%@ include file="/WEB-INF/views/common/pagination.jsp"%>
	<!--//페이징-->

	<!--가맹점 등록 팝업-->
	<div class="popUp">
		<div class="popTit">
			<p>가맹점 & 협약업체 등록</p>
			<img class="popClose" src="${pageContext.request.contextPath}/new/img/popclose.png" />
		</div>
		<div class="popCont">
			<div class="inputArea02 mb-20">
				<p class="inputTxt02">업체명</p>
				<input type="text" class="Input02" name="fcName" id="fcName" placeholder="가맹점명을 입력하세요."/>
			</div>
			<div class="inputArea02 mb-20">
				<p class="inputTxt02">아이디</p>
				<input type="text" class="Input02" name="userId" id="userId" placeholder="아이디를 입력하세요."/>
			</div>
			<div class="inputArea02 mb-20">
				<p class="inputTxt02">비밀번호</p>
				<input type="password" class="Input02" name="password" id="password" placeholder="비밀번호를 입력하세요."/>
			</div>
			<div class="inputArea02 mb-20">
				<p class="inputTxt02">비밀번호 확인</p>
				<input type="password" class="Input02" name="confirmPassword" id="confirmPassword"  placeholder="비밀번호를 다시 입력하세요."/>
			</div>
			<div class="popAdd" onclick="return submitFrom();">등록</div>
		</div>
	</div>

	<div class="popLayer"></div>
	<!--//가맹점 등록 팝업-->
	
</div>
<!--//컨텐츠-->

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
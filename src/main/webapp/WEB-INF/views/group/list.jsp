<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/tagLib.jsp" %>
<script>
$( document ).ready( function() {
    $('#submitBtn').click( function() {
    	searchGroup();
    });
    // 검색어 입력 후 Enter 시에도 폼 재전송(POST) 대신 클라이언트 검색
    $('#searchWord').on('keydown', function(e){
        if(e.keyCode === 13){ e.preventDefault(); searchGroup(); }
    });
    loadGroupList();
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
					loadGroupList();
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
				<form:form id="searchForm" commandName="domainParam" method="POST" onsubmit="return false;">
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
							<button type="button" id="resetBtn" class="btnAll" onclick="resetGroup();">전체</button>
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
				
				<ul id="groupList" class="listUl cross"></ul>
			</div>
			<!--//검색된 리스트 10개씩 노출-->

			<!--페이징(클라이언트 사이드)-->
			<div id="groupPagination" class="pagingArea"></div>
			<!--//페이징-->
		</div>
		<!--//컨텐츠-->
		
		<!--시공사 등록 팝업-->
		<%-- <div class="popUp">
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
		</div> --%>
		<div class="popUp popUp01">
			<div class="popTit">
				<p>시공사 등록</p>
				<img class="popClose" src="${pageContext.request.contextPath}/new/img/popclose.png" style="cursor:pointer;" />
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
		
		<div class="popUp popUp02">
			<div class="popTit">
				<p>시공사명 변경</p>
				<img class="popClose editPopClose" src="${pageContext.request.contextPath}/new/img/popclose.png" style="cursor:pointer;" />
			</div>
			<div class="popCont">
				<form id="editForm" name="editForm" onsubmit="return false;">
				<input type="hidden" id="editGroupIdx" value="" />
				
				<div class="inputArea02 mb-10">
					<p class="inputTxt02">기존 시공사명</p>
					<input type="text" class="Input02" id="oldGroupName" value="" disabled readonly style="background-color:#f5f5f5; color:#666; border-color:#ddd; cursor:not-allowed;">
				</div>
				
				<div class="inputArea02 mb-20">
					<p class="inputTxt02">변경할 시공사명</p>
					<input type="text" class="Input02" id="editGroupName" value="" placeholder="새롭게 변경할 시공사명을 입력하세요.">
				</div>
				
				<div class="popAdd" onclick="javascript:updateGroup();">변경 저장</div>
				</form>
			</div>
		</div>
		
		<div class="popLayer"></div>
		<!--//시공사 등록 팝업-->
		
		
		
		
<!-- 시공사 목록: 클라이언트 사이드 페이징 (POST 재제출 방지) -->
<style>
.groupSpinner{
	display:inline-block;width:18px;height:18px;vertical-align:middle;margin-right:6px;
	border:3px solid #e0e0e0;border-top-color:#077b9c;border-radius:50%;
	animation:groupSpin 0.8s linear infinite;
}
@keyframes groupSpin{ to{ transform:rotate(360deg); } }

/* 검색영역 '전체' 버튼 (검색 아이콘 버튼과 높이/모서리 통일) */
.btnAll{
	height:50px;
	padding:0 22px;
	margin-left:10px;
	border:none;
	border-radius:7px;
	background:#fff;
	color:#077b9c;
	font-size:16px;
	font-weight:600;
	white-space:nowrap;
	cursor:pointer;
	flex-shrink:0;
	transition:background 0.15s;
}
.btnAll:hover{ background:#eaf6f9; }
@media (max-width:1023px){
	.btnAll{ height:35px; padding:0 12px; margin-left:6px; font-size:13px; }
}

/* 시공사 카드 집계 라벨: 글자 단위 줄바꿈 방지 */
.builder .listArea .listUl li .CountBox01 .s1,
.builder .listArea .listUl li .CountBox01 .s2 { white-space:nowrap; }

/* 좁은 데스크탑 폭(사이드바로 콘텐츠가 좁아지는 구간)에서는 카드를 1열로 전환 */
@media (min-width:1024px) and (max-width:1500px){
	.builder .listArea .listUl li{
		width:100%;
		float:none;
		margin-right:0;
		padding:15px 25px;
	}
	/* 검색영역 축소 방지는 전역 style.css로 이관 (.searchArea01:not(.type01)) */
}
</style>
<script>
(function(){
	var ctx = '${pageContext.request.contextPath}';
	var PAGE_SIZE = 20;
	var BLOCK_SIZE = 10;
	var allGroupData = [];
	var currentPage = 1;

	function escGroup(s){
		return String(s == null ? '' : s)
			.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;')
			.replace(/"/g,'&quot;').replace(/'/g,'&#39;');
	}

	function getFilteredData(){
		var keyword = $.trim($('#searchWord').val() || '').toLowerCase();
		if(!keyword) return allGroupData;
		return $.grep(allGroupData, function(g){
			return String(g.groupName || '').toLowerCase().indexOf(keyword) !== -1;
		});
	}

	function countBox(icon, label, value){
		return '<div class="CountBox01">'
			+ '<img src="' + ctx + '/new/img/' + icon + '" />'
			+ '<div><p class="s1">' + label + '</p><p class="s2">' + value + '</p></div>'
			+ '</div>';
	}

	function renderList(){
		var filtered = getFilteredData();
		var $list = $('#groupList');

		if(!filtered || filtered.length === 0){
			$list.html('<li style="padding:24px;text-align:center;color:#999;list-style:none;">'
				+ (allGroupData.length === 0 ? '등록된 시공사가 없습니다.' : '검색 결과가 없습니다.') + '</li>');
			renderPagination(0);
			return;
		}

		var totalPages = Math.ceil(filtered.length / PAGE_SIZE) || 1;
		if(currentPage > totalPages) currentPage = totalPages;
		var startIdx = (currentPage - 1) * PAGE_SIZE;
		var pageData = filtered.slice(startIdx, startIdx + PAGE_SIZE);

		var html = '';
		$.each(pageData, function(i, g){
			var isNew = (g.newContent == 0);
			var liStyle = isNew ? 'background-color:#fff9c7; padding:15px 15px;' : 'padding:15px 15px;';
			var editBtnHtml = '';
			
			if ('${sessionScope.isSystemAdmin}' === 'true') {
				editBtnHtml = '<button type="button" class="btnEditGroup" style="padding:4px 10px; background:#077b9c; color:#fff; font-weight:bold; border:none; border-radius:4px; cursor:pointer;" onclick="event.stopPropagation(); window.openEditGroup(' + g.idx + ');">시공사명 변경</button>';
			}
			html += '<li style="' + liStyle + '" onclick="location.href=\'' + ctx + '/construction/list?groupIdx=' + g.idx + '\'">'
			+   '<div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:10px;">'
			+       '<p class="buildTxt" style="margin:0;">' + escGroup(g.groupName) + (isNew ? ' <font color="red">new</font>' : '') + '</p>'
			+       editBtnHtml
			+   '</div>'
				+   '<div class="CountArea01">'
				+     countBox('buildIcon01.png', '협력사', (g.cprtCompanyAmount || 0) + ' 개')
				+     countBox('buildIcon02.png', '본사 운영장비', (g.deviceAmount || 0) + ' 대')
				+     countBox('buildIcon03.png', '가맹 운영장비', (g.franchAmount || 0) + ' 대')
				+     countBox('buildIcon04.png', '예비용 장비', (g.spareDeviceAmount || 0) + ' 대')
				+   '</div>'
				+ '</li>';
		});
		$list.html(html);
		renderPagination(filtered.length);
	}

	function renderPagination(totalItems){
		var totalPages = Math.ceil(totalItems / PAGE_SIZE);
		var $wrap = $('#groupPagination');
		if(totalPages <= 1){ $wrap.html(''); return; }

		var currentBlock = Math.ceil(currentPage / BLOCK_SIZE);
		var totalBlocks = Math.ceil(totalPages / BLOCK_SIZE);
		var startPage = (currentBlock - 1) * BLOCK_SIZE + 1;
		var endPage = Math.min(currentBlock * BLOCK_SIZE, totalPages);

		var html = '';
		if(currentBlock > 1){
			html += '<a href="javascript:void(0)" class="prevBtn" onclick="groupGoPage(' + (startPage - 1) + ')">'
				+ '&#51060;&#51204;</a>';
		}
		for(var p = startPage; p <= endPage; p++){
			if(p === currentPage){
				html += '<a href="#" class="pageNm on" onclick="return false;">' + p + '</a>';
			}else{
				html += '<a href="javascript:void(0)" class="pageNm" onclick="groupGoPage(' + p + ')">' + p + '</a>';
			}
		}
		if(currentBlock < totalBlocks){
			html += '<a href="javascript:void(0)" class="nextBtn" onclick="groupGoPage(' + (endPage + 1) + ')">'
				+ '&#45796;&#51020;</a>';
		}
		$wrap.html(html);
	}

	// 인라인 onclick 및 상단 검색 핸들러에서 호출하므로 전역으로 노출
	window.groupGoPage = function(p){
		if(p < 1 || p === currentPage) return;
		currentPage = p;
		try { sessionStorage.setItem('groupCurrentPage', p); } catch(e){}
		renderList();
	};

	window.searchGroup = function(){
		currentPage = 1;
		try {
			sessionStorage.setItem('groupCurrentPage', 1);
			sessionStorage.setItem('groupSearchWord', $('#searchWord').val() || '');
		} catch(e){}
		renderList();
	};

	// 전체: 검색어를 지우고 전체 목록을 1페이지부터 표시
	window.resetGroup = function(){
		$('#searchWord').val('');
		currentPage = 1;
		try {
			sessionStorage.setItem('groupCurrentPage', 1);
			sessionStorage.removeItem('groupSearchWord');
		} catch(e){}
		renderList();
	};

	window.loadGroupList = function(){
		// 전체 집계 조회에 시간이 걸리므로 로딩 표시 (CSS 스피너)
		$('#groupList').html('<li style="padding:40px;text-align:center;color:#999;list-style:none;">'
			+ '<span class="groupSpinner"></span> 목록을 불러오는 중입니다...</li>');
		$('#groupPagination').html('');
		$.getJSON(ctx + '/group/ajax/list', function(data){
			allGroupData = data || [];
			// 뒤로가기 등으로 재진입 시 이전 검색어/페이지 복원
			var savedWord = null, savedPage = null;
			try {
				savedWord = sessionStorage.getItem('groupSearchWord');
				savedPage = sessionStorage.getItem('groupCurrentPage');
			} catch(e){}
			if(savedWord !== null) $('#searchWord').val(savedWord);
			currentPage = savedPage ? parseInt(savedPage, 10) : 1;
			if(!currentPage || currentPage < 1) currentPage = 1;
			renderList();
		});
	};
	
	window.openEditGroup = function(idx){
		var target = null;
		$.each(allGroupData, function(i, g){
			if(g.idx === idx){
				target = g;
				return false;
			}
		});
		if(!target) return;

		$('#editGroupIdx').val(target.idx);
		$('#oldGroupName').val(target.groupName);
		$('#editGroupName').val('');
		
		$('.popUp02').show();
		$('.popLayer').show();
		$('body').css('overflow', 'hidden');
		
		setTimeout(function(){ $('#editGroupName').focus(); }, 100);
	};

	window.updateGroup = function(){
		var idx = $('#editGroupIdx').val();
		var oldName = $('#oldGroupName').val();
		var newName = $.trim($('#editGroupName').val());
		
		if(newName === ''){
			alert('새로운 시공사명을 입력하세요.');
			$('#editGroupName').focus();
			return;
		}
		
		if(oldName === newName){
			alert('기존 시공사명과 동일한 이름입니다. 다른 이름을 입력해주세요.');
			$('#editGroupName').focus();
			return;
		}
		
		var isDuplicate = 0;
		$.ajax({
			type : "POST",
			url : ctx + "/group/duplicate/check",
			async : false,
			data: { groupName : newName },
			success : function(data) { isDuplicate = data; }
		});
		
		if(isDuplicate > 0){
			alert('이미 등록된 같은 이름의 시공사가 존재합니다.');
			return;
		}

		var myObject = new Object();
		myObject.idx = new Number(idx);
		myObject.groupName = newName;
		
		$.ajax({
			type : "POST",
			url : ctx + "/group/updateAjax",
			contentType : "application/json",
			data: JSON.stringify(myObject),
			success : function(data) {	
				if(data == 1 || data === "success"){
					alert('시공사명이 변경되었습니다.');
					$('.popUp02').hide();
					$('.popLayer').hide();
					$('body').css('overflow', 'auto');
					loadGroupList();
				} else {
					alert('시공사명 변경에 실패했습니다.');
				}
			},
			error : function(xhr, status, error) {
				alert('서버 통신 중 오류가 발생했습니다.');
				$('.popUp02').hide();
				$('.popLayer').hide();
				$('body').css('overflow', 'auto');
			}
		});
	};
})();
</script>

<!-- 팝업 -->
<script>
$('.popUp').hide();
$('.popLayer').hide();

$('.popBtn').on('click', function(e){
	$('.popUp01').show();
	$('.popLayer').show();
	$('body').css('overflow', 'hidden');
});

$('.popClose').on('click', function(e){
	$('.popUp01').hide();
	$('.popLayer').hide();
	$('body').css('overflow', 'auto');
});
$('.editPopClose').on('click', function(e){
	$('.popUp02').hide();
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

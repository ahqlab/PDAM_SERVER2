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

				<div class="operationSummaryTableWrap" id="operationTrendTrigger" role="button" tabindex="0" aria-haspopup="dialog" aria-controls="operationTrendLayer" title="운영 장비 추이 보기">
					<table class="operationSummaryTable">
						<thead>
							<tr>
								<th>항목</th>
								<th>현재 개수</th>
								<th>최고 개수</th>
								<th>최저 개수</th>
								<th>변동</th>
								<th>변동 %</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td class="operationName">현재 운영 장비</td>
								<td>${currentOperationDeviceCount}</td>
								<td>${maximumOperationDeviceCount}</td>
								<td>${minimumOperationDeviceCount}</td>
								<td class="operationChange ${operationDeviceChangeClass}">${operationDeviceChange}</td>
								<td class="operationChange ${operationDeviceChangeClass}">${operationDeviceChangeRate}</td>
							</tr>
						</tbody>
					</table>
				</div>

				<ul id="groupList" class="listUl cross"></ul>
			</div>
			<!--//검색된 리스트 10개씩 노출-->

			<!--페이징(클라이언트 사이드)-->
			<div id="groupPagination" class="pagingArea"></div>
			<!--//페이징-->
		</div>
		<!--//컨텐츠-->

		<!-- 운영 장비 추이 팝업 -->
		<div id="operationTrendLayer" class="operationTrendLayer" aria-hidden="true">
			<div class="operationTrendModal" role="dialog" aria-modal="true" aria-labelledby="operationTrendTitle">
				<div class="operationTrendHeader">
					<h2 id="operationTrendTitle">운영 장비 추이</h2>
					<div class="operationTrendActions">
						<div class="operationTrendPeriods" role="tablist" aria-label="조회 기간">
							<button type="button" class="operationTrendPeriod is-active" data-period="day" role="tab" aria-selected="true">일</button>
							<button type="button" class="operationTrendPeriod" data-period="month" role="tab" aria-selected="false">월</button>
							<button type="button" class="operationTrendPeriod" data-period="year" role="tab" aria-selected="false">년</button>
						</div>
						<button type="button" class="operationTrendClose" aria-label="팝업 닫기">&times;</button>
					</div>
				</div>
				<div class="operationTrendBody">
					<p class="operationTrendUnit">단위: 대</p>
					<div id="operationTrendChart" class="operationTrendChart"></div>
					<div id="operationTrendEmpty" class="operationTrendEmpty">저장된 운영 장비 현황이 없습니다.</div>
				</div>
			</div>
		</div>
		<!-- //운영 장비 추이 팝업 -->


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
.operationSummaryTableWrap{
	width:100%;
	margin-bottom:15px;
	overflow-x:auto;
	background:#fff;
	border-radius:10px;
	box-shadow:0px 0px 6.79px 0.21px rgb(0 0 0 / 7%);
	cursor:pointer;
}
.operationSummaryTableWrap:hover,
.operationSummaryTableWrap:focus{
	box-shadow:0 5px 16px rgb(0 0 0 / 12%);
	outline:none;
}
.operationSummaryTable{
	width:100%;
	min-width:760px;
	border-collapse:collapse;
	table-layout:fixed;
}
.operationSummaryTable th,
.operationSummaryTable td{
	padding:10px 14px;
	border-bottom:1px solid #e5e8eb;
	font-size:15px;
	text-align:center;
	vertical-align:middle;
}
.operationSummaryTable th{
	color:#333;
	font-weight:700;
}
.operationSummaryTable th:first-child,
.operationSummaryTable td:first-child{
	width:28%;
	text-align:center;
}
.operationSummaryTable .operationName{
	font-weight:400;
	white-space:nowrap;
}
.operationSummaryTable .operationChange.positive{ color:#e53935; }
.operationSummaryTable .operationChange.negative{ color:#0e60ff; }
.operationSummaryTable .operationChange.neutral{ color:#333; }

/* 운영 장비 추이 팝업 */
.operationTrendLayer{
	display:none;
	position:fixed;
	top:0;
	right:0;
	bottom:0;
	left:0;
	z-index:10000;
	padding:32px;
	align-items:center;
	justify-content:center;
	background:rgba(24, 32, 37, 0.43);
}
.operationTrendLayer.is-open{ display:flex; }
.operationTrendModal{
	width:74%;
	max-width:1000px;
	min-width:720px;
	background:#fff;
	border-radius:14px;
	box-shadow:0 18px 50px rgb(0 0 0 / 22%);
	overflow:hidden;
}
.operationTrendHeader{
	height:78px;
	padding:0 28px;
	display:flex;
	align-items:center;
	justify-content:space-between;
	border-bottom:1px solid #e8ecef;
}
.operationTrendHeader h2{
	margin:0;
	color:#171b1d;
	font-size:24px;
	font-weight:600;
	letter-spacing:-0.8px;
}
.operationTrendActions{
	display:flex;
	align-items:center;
	gap:24px;
}
.operationTrendPeriods{
	display:flex;
	align-items:center;
	gap:12px;
}
.operationTrendPeriod{
	width:58px;
	height:40px;
	padding:0;
	border:none;
	outline:none;
	box-shadow:none;
	border-radius:10px;
	background:#f2f4f5;
	color:#555f64;
	font-size:15px;
	font-weight:600;
	cursor:pointer;
}
.operationTrendPeriod:hover{
	background:#e8f4f7;
	color:#087f9e;
}
.operationTrendPeriod.is-active{
	background:#0796b5;
	color:#fff;
}
.operationTrendClose{
	width:36px;
	height:36px;
	padding:0;
	border:none;
	outline:none;
	box-shadow:none;
	background:transparent;
	color:#202629;
	font-size:36px;
	font-weight:300;
	line-height:32px;
	cursor:pointer;
}
.operationTrendBody{
	position:relative;
	height:330px;
	padding:10px 24px 12px;
}
.operationTrendUnit{
	position:absolute;
	top:14px;
	right:32px;
	z-index:1;
	margin:0;
	color:#8c979c;
	font-size:14px;
}
.operationTrendChart{
	width:100%;
	height:100%;
}
.operationTrendEmpty{
	display:none;
	position:absolute;
	top:50%;
	left:50%;
	transform:translate(-50%, -50%);
	color:#899398;
	font-size:15px;
}
@media (max-width:1023px){
	.operationTrendLayer{ padding:16px; }
	.operationTrendModal{ width:100%; min-width:0; }
	.operationTrendHeader{
		position:relative;
		height:auto;
		padding:18px;
		flex-direction:column;
		align-items:flex-start;
		justify-content:flex-start;
		gap:16px;
	}
	.operationTrendHeader h2{
		max-width:calc(100% - 44px);
		font-size:21px;
		line-height:30px;
		white-space:nowrap;
	}
	.operationTrendActions{
		width:100%;
		gap:12px;
		justify-content:flex-start;
	}
	.operationTrendPeriods{ gap:7px; }
	.operationTrendPeriod{ width:45px; height:36px; font-size:14px; white-space:nowrap; }
	.operationTrendClose{
		position:absolute;
		top:17px;
		right:15px;
		width:30px;
		height:30px;
		font-size:30px;
	}
	.operationTrendBody{ height:350px; padding:8px 8px 10px; }
	.operationTrendUnit{ top:12px; right:18px; font-size:12px; }
}
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
			+ '<img src="' + ctx + '/images/' + icon + '" />'
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
				+     countBox('group_icon01.png', '협력사', (g.cprtCompanyAmount || 0) + ' 개')
				+     countBox('group_icon02.png', '본사 운영장비', (g.deviceAmount || 0) + ' 대')
				+     countBox('group_icon03.png', '가맹 운영장비', (g.franchAmount || 0) + ' 대')
				+     countBox('group_icon04.png', '예비용 장비', (g.spareDeviceAmount || 0) + ' 대')
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
				+ '이전</a>';
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
				+ '다음</a>';
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

<!-- 운영 장비 추이 -->
<script>
(function(){
	var ctx = '${pageContext.request.contextPath}';
	var trendChart = null;
	var trendCache = {};
	var currentTrendPeriod = 'day';
	var previousBodyOverflow = '';
	var $trendLayer = $('#operationTrendLayer');
	var $trendEmpty = $('#operationTrendEmpty');

	function valueOf(point, key){
		if(point[key] != null) return point[key];
		if(point[key.toUpperCase()] != null) return point[key.toUpperCase()];
		return point[key.toLowerCase()];
	}

	function normalizeTrend(data){
		return $.map(data || [], function(point){
			var count = Number(valueOf(point, 'deviceCount'));
			if(isNaN(count)) return null;
			return {
				axisLabel: String(valueOf(point, 'axisLabel') || ''),
				tooltipLabel: String(valueOf(point, 'tooltipLabel') || ''),
				deviceCount: count
			};
		});
	}

	function createChart(){
		if(!trendChart && window.echarts){
			trendChart = echarts.init(document.getElementById('operationTrendChart'));
		}
		return trendChart;
	}

	function renderTrend(data){
		var chart = createChart();
		if(!chart) {
			$trendEmpty.text('그래프를 불러올 수 없습니다.').show();
			return;
		}

		chart.hideLoading();
		if(!data.length){
			chart.clear();
			$trendEmpty.text('저장된 운영 장비 현황이 없습니다.').show();
			return;
		}
		$trendEmpty.hide();
		var isMobile = window.innerWidth <= 1023;

		var labels = [];
		var counts = [];
		var seriesData = [];
		$.each(data, function(index, point){
			labels.push(point.axisLabel);
			counts.push(point.deviceCount);
			var item = {
				value: point.deviceCount,
				tooltipLabel: point.tooltipLabel
			};
			if(index === data.length - 1){
				item.symbolSize = 12;
				item.itemStyle = {
					color:'#078faf',
				};
			}
			seriesData.push(item);
		});

		var minimum = Math.min.apply(null, counts);
		var maximum = Math.max.apply(null, counts);
		var rangePadding = Math.max(10, Math.ceil((maximum - minimum) * 0.18));
		var yMinimum = Math.max(0, Math.floor((minimum - rangePadding) / 10) * 10);
		var yMaximum = Math.ceil((maximum + rangePadding) / 10) * 10;
		if(yMinimum === yMaximum) yMaximum = yMinimum + 20;

		var startIndex = Math.max(0, data.length - 7);
		var endIndex = data.length - 1;
		var insideZoom = {
			type:'inside',
			startValue:startIndex,
			endValue:endIndex,
			zoomLock:true,
			zoomOnMouseWheel:false,
			moveOnMouseWheel:true,
			moveOnMouseMove:true
		};
		var sliderZoom = {
			type:'slider',
			show:data.length > 7,
			startValue:startIndex,
			endValue:endIndex,
			zoomLock:true,
			height:9,
			left:52,
			right:20,
			bottom:9,
			showDataShadow:false,
			showDetail:false,
			brushSelect:false,
			borderColor:'transparent',
			backgroundColor:'#edf0f2',
			fillerColor:'#6d939e',
			handleSize:0,
			moveHandleSize:0
		};
		if(data.length > 7){
			insideZoom.minValueSpan = 6;
			insideZoom.maxValueSpan = 6;
			sliderZoom.minValueSpan = 6;
			sliderZoom.maxValueSpan = 6;
		}

		chart.setOption({
			grid:{ left:52, right:20, top:44, bottom:data.length > 7 ? 58 : 42 },
			tooltip:{
				trigger:'axis',
				backgroundColor:'#fff',
				padding:[11,14],
				textStyle:{ color:'#202629', fontSize:14 },
				extraCssText:'box-shadow:0 5px 15px rgba(0,0,0,.14); border-radius:8px;',
				axisPointer:{ type:'line', lineStyle:{ color:'#d6e8ed', width:1 } },
				formatter:function(params){
					var point = params && params[0];
					if(!point) return '';
					return point.data.tooltipLabel + '&nbsp;&nbsp;&nbsp;<b>' + point.value + '대</b>';
				}
			},
			xAxis:{
				type:'category',
				boundaryGap:false,
				data:labels,
				axisLine:{ lineStyle:{ color:'#cfd8dc' } },
				axisTick:{ show:false },
				axisLabel:{
					color:'#374247',
					fontSize:isMobile ? 10 : 13,
					margin:14,
					interval:isMobile ? 1 : 0,
					hideOverlap:isMobile,
					formatter:function(value){
						if(!isMobile) return value;
						if(currentTrendPeriod === 'day') return value.replace(/^0/, '').replace(/\.0/, '.');
						if(currentTrendPeriod === 'month') return value.replace(/^0/, '');
						return value;
					}
				}
			},
			yAxis:{
				type:'value',
				min:yMinimum,
				max:yMaximum,
				splitNumber:5,
				axisLine:{ show:false },
				axisTick:{ show:false },
				axisLabel:{ color:'#4f5a5f', fontSize:13 },
				splitLine:{ lineStyle:{ color:'#e8edef', type:'dashed' } }
			},
			dataZoom:[insideZoom, sliderZoom],
			series:[{
				type:'line',
				data:seriesData,
				symbol:'circle',
				symbolSize:8,
				lineStyle:{ color:'#0796b5', width:2.5 },
				itemStyle:{ color:'#0796b5' },
				label:{
					show:true,
					position:'top',
					distance:9,
					color:'#202629',
					fontSize:13,
					fontWeight:600,
					formatter:'{c}'
				},
				areaStyle:{
					color:new echarts.graphic.LinearGradient(0, 0, 0, 1, [
						{ offset:0, color:'rgba(7, 150, 181, 0.15)' },
						{ offset:1, color:'rgba(7, 150, 181, 0.02)' }
					])
				}
			}]
		}, true);
	}

	function loadTrend(period){
		currentTrendPeriod = period;
		$('.operationTrendPeriod').removeClass('is-active').attr('aria-selected', 'false');
		$('.operationTrendPeriod[data-period="' + period + '"]').addClass('is-active').attr('aria-selected', 'true');

		if(Object.prototype.hasOwnProperty.call(trendCache, period)){
			renderTrend(trendCache[period]);
			return;
		}

		$trendEmpty.hide();
		var chart = createChart();
		if(chart){
			chart.clear();
			chart.showLoading('default', { text:'불러오는 중...', color:'#0796b5', textColor:'#6f7b80', maskColor:'rgba(255,255,255,0.75)' });
		}
		$.getJSON(ctx + '/group/ajax/operation-trend', { period:period })
			.done(function(data){
				trendCache[period] = normalizeTrend(data);
				if(currentTrendPeriod === period) renderTrend(trendCache[period]);
			})
			.fail(function(){
				if(currentTrendPeriod !== period) return;
				if(chart) { chart.hideLoading(); chart.clear(); }
				$trendEmpty.text('운영 장비 추이를 불러오지 못했습니다.').show();
			});
	}

	function openTrend(){
		previousBodyOverflow = $('body').css('overflow');
		trendCache = {};
		$trendLayer.addClass('is-open').attr('aria-hidden', 'false');
		$('body').css('overflow', 'hidden');
		loadTrend('day');
		setTimeout(function(){
			if(trendChart) trendChart.resize();
			$('.operationTrendClose').focus();
		}, 30);
	}

	function closeTrend(){
		$trendLayer.removeClass('is-open').attr('aria-hidden', 'true');
		$('body').css('overflow', previousBodyOverflow || 'auto');
		$('#operationTrendTrigger').focus();
	}

	$('#operationTrendTrigger').on('click', openTrend).on('keydown', function(e){
		if(e.keyCode === 13 || e.keyCode === 32){
			e.preventDefault();
			openTrend();
		}
	});
	$('.operationTrendPeriod').on('click', function(){ loadTrend($(this).data('period')); });
	$('.operationTrendClose').on('click', closeTrend);
	$trendLayer.on('click', function(e){ if(e.target === this) closeTrend(); });
	$(document).on('keydown', function(e){
		if(e.keyCode === 27 && $trendLayer.hasClass('is-open')) closeTrend();
	});
	$(window).on('resize.operationTrend', function(){ if(trendChart) trendChart.resize(); });
})();
</script>
<!-- //운영 장비 추이 -->

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

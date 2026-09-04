<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/tagLib.jsp" %>

<div class="section-right">
	<%@ include file="/WEB-INF/views/common/welcomeMsg.jsp" %>
	<div class="TopContArea">
		<div class="titArea">
			<p class="h1Tit">게시판 관리</p>
			<a class="popBtn popBtnRegist" style="cursor:pointer;" onclick="openRegPopup();">게시판 등록</a>
		</div>

		<form id="searchForm" method="GET" action="${pageContext.request.contextPath}/admin/board/list" onsubmit="return true;">
			<div class="searchArea">
				<div class="searchArea01">
					<select name="searchType" id="searchType" class="select01">
						<option value="boardName" <c:if test="${param.searchType == 'boardName'}">selected</c:if>>게시판 명</option>
						<option value="auth" <c:if test="${param.searchType == 'auth'}">selected</c:if>>권한</option>
					</select>
					<input type="text" name="keyword" id="searchKeyword" class="searchin" value="${param.keyword}" placeholder="검색어를 입력하세요."/>
					<div class="searchBtn">
						<img id="submitBtn" src="${pageContext.request.contextPath}/new/img/search.png" style="cursor:pointer;" onclick="$('#searchForm').submit();">
					</div>
				</div>
			</div>
		</form>
	</div>
	
	<div class="listArea" style="padding:20px;">
		<div class="pc-table-wrap" style="overflow-x:auto;">
			<table style="width:100%;min-width:800px;border-collapse:collapse;">
				<thead>
					<tr style="background:#f5f5f5;border-bottom:2px solid #ddd;">
						<th style="padding:10px;text-align:center;width:60px;white-space:nowrap;">번호</th>
						<th style="padding:10px;text-align:center;min-width:150px;">게시판 명</th>
						<th style="padding:10px;text-align:center;width:100px;white-space:nowrap;">상태</th>
						<th style="padding:10px;text-align:center;width:100px;white-space:nowrap;">권한</th>
						<th style="padding:10px;text-align:center;min-width:250px;">허용 첨부파일</th>
						<th style="padding:10px;text-align:center;width:130px;white-space:nowrap;">등록일</th>
						<th style="padding:10px;text-align:center;width:120px;white-space:nowrap;">관리</th>
					</tr>
				</thead>
				<tbody id="boardTbody">
					<c:choose>
						<c:when test="${empty boardList}">
							<tr>
								<td colspan="7" style="text-align:center;padding:24px;color:#999;">등록된 게시판이 없습니다.</td>
							</tr>
						</c:when>
						<c:otherwise>
							<c:forEach var="item" items="${boardList}">
								<tr style="border-bottom:1px solid #eee;">
									<td style="padding:10px;text-align:center;border:1px solid #eee;white-space:nowrap;">${item.id}</td>
									<td style="padding:10px;border:1px solid #eee;text-align:left;padding-left:15px; font-weight:500;">
										${item.boardName}
									</td>
									<td style="padding:10px;text-align:center;border:1px solid #eee;white-space:nowrap;">
										<span style="color: ${item.useYn == 'Y' ? '#28a745' : '#dc3545'}; font-weight: bold;">
											${item.useYn == 'Y' ? 'ON' : 'OFF'}
										</span>
									</td>
									<td style="padding:10px;text-align:center;border:1px solid #eee;white-space:nowrap;">${item.auth}</td>
									<td style="padding:10px;text-align:left;border:1px solid #eee; font-size: 13px; color: #555; word-break: keep-all;">
										${item.allowedExts}
									</td>
									<td style="padding:10px;text-align:center;border:1px solid #eee;white-space:nowrap;">
										<fmt:formatDate value="${item.regDate}" pattern="yyyy-MM-dd"/>
									</td>
									<td style="padding:10px;text-align:center;border:1px solid #eee;white-space:nowrap;">
										<button type="button" onclick="openUpdatePopupDirect(${item.id})" style="cursor:pointer;padding:5px 10px;background:#337ab7;color:#fff;border:none;border-radius:3px;font-size:12px;margin-right:4px;">설정</button>
										<button type="button" onclick="deleteBoard(${item.id})" style="cursor:pointer;padding:5px 10px;background:#d9534f;color:#fff;border:none;border-radius:3px;font-size:12px;">삭제</button>
									</td>
								</tr>
							</c:forEach>
						</c:otherwise>
					</c:choose>
				</tbody>
			</table>
		</div>
		
		<div id="boardCards" style="display:none;">
			<c:choose>
				<c:when test="${empty boardList}">
					<p style="text-align:center;padding:24px;color:#999;">등록된 게시판이 없습니다.</p>
				</c:when>
				<c:otherwise>
					<c:forEach var="item" items="${boardList}">
						<div style="background:#fff;border:1px solid #ddd;border-radius:6px;padding:14px 16px;margin-bottom:10px;">
							<div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:8px;">
								<span style="font-weight:bold;font-size:15px;color:#333;">${item.boardName}</span>
								<div>
									<button type="button" onclick="openUpdatePopupDirect(${item.id})" style="cursor:pointer;padding:4px 8px;background:#337ab7;color:#fff;border:none;border-radius:3px;font-size:12px;margin-right:2px;">설정</button>
									<button type="button" onclick="deleteBoard(${item.id})" style="cursor:pointer;padding:4px 8px;background:#d9534f;color:#fff;border:none;border-radius:3px;font-size:12px;">삭제</button>
								</div>
							</div>
							<table style="width:100%;font-size:13px;border-collapse:collapse;">
								<tr>
									<td style="color:#888;padding:3px 8px 3px 0;width:70px;">상태</td>
									<td style="padding:3px 0; font-weight:bold; color: ${item.useYn == 'Y' ? '#28a745' : '#dc3545'};">${item.useYn == 'Y' ? 'ON (사용)' : 'OFF (미사용)'}</td>
								</tr>
								<tr>
									<td style="color:#888;padding:3px 8px 3px 0;">권한</td>
									<td style="padding:3px 0;">${item.auth}</td>
								</tr>
								<tr>
									<td style="color:#888;padding:3px 8px 3px 0;">허용 파일</td>
									<td style="padding:3px 0; word-break: break-all;">${item.allowedExts}</td>
								</tr>
							</table>
						</div>
					</c:forEach>
				</c:otherwise>
			</c:choose>
		</div>
	</div>

	<div id="boardPagination" style="display:flex;justify-content:center;gap:4px;margin-top:20px;margin-bottom:30px;">
		<c:if test="${pagination.startPage > 1}">
			<button class="pageBtn" onclick="location.href='${pageContext.request.contextPath}/admin/board/list?page=${pagination.startPage - 1}&size=${pagination.pageSize}&searchType=${param.searchType}&keyword=${param.keyword}'">이전</button>
		</c:if>

		<c:forEach var="i" begin="${pagination.startPage}" end="${pagination.endPage}">
			<c:choose>
				<c:when test="${i == pagination.currentPage}">
					<button class="pageBtn active" onclick="return false;">${i}</button>
				</c:when>
				<c:otherwise>
					<button class="pageBtn" onclick="location.href='${pageContext.request.contextPath}/admin/board/list?page=${i}&size=${pagination.pageSize}&searchType=${param.searchType}&keyword=${param.keyword}'">${i}</button>
				</c:otherwise>
			</c:choose>
		</c:forEach>

		<c:if test="${pagination.endPage < pagination.pageCount}">
			<button class="pageBtn" onclick="location.href='${pageContext.request.contextPath}/admin/board/list?page=${pagination.endPage + 1}&size=${pagination.pageSize}&searchType=${param.searchType}&keyword=${param.keyword}'">다음</button>
		</c:if>
	</div>

<style>
.pageBtn { 
	min-width: 32px; height: 32px; padding: 0 8px; border: 1px solid #ddd; 
	background: #fff; color: #333; border-radius: 3px; cursor: pointer; font-size: 13px; 
}
.pageBtn:hover { border-color: #adadad; background: #e6e6e6; }
.pageBtn.active { background: #337ab7; color: #fff; border-color: #337ab7; }
.pageBtn:disabled { cursor: default; color: #ccc; }

.listArea { background: #fff; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); padding: 20px; }
#boardTbody tr:hover { background-color: #f9f9f9; }

.ext-label {
	display: inline-block;
	margin-right: 15px;
	margin-bottom: 10px;
	font-size: 13px;
	color: #333;
	cursor: pointer;
	padding: 5px 0;
}
.ext-label input[type="checkbox"] {
	margin-right: 6px;
	vertical-align: middle;
	width: 16px; height: 16px; 
}

.popUp {
	width: 90% !important; 
	max-width: 500px !important; 
	left: 50% !important;
	top: 50% !important;
	transform: translate(-50%, -50%) !important; 
	max-height: 90vh; 
	overflow-y: auto; 
}

@media (max-width: 768px) {
	.pc-table-wrap { display: none !important; }
	#boardCards { display: block !important; }
	
	.listArea { padding: 15px 10px; }
	
	.TopContArea .titArea {
		display: flex;
		justify-content: space-between;
		align-items: center;
		margin-bottom: 15px;
	}
	
	.searchArea01 {
		display: flex;
		width: 100%;
		gap: 8px;
	}
	.searchArea01 .select01 { flex: 1; width: auto; }
	.searchArea01 .searchin { flex: 2; width: auto; }
	.searchArea01 .searchBtn { flex: 0 0 auto; }
	
	#boardCards > div { padding: 12px; }
	#boardCards .btn-group button {
		padding: 6px 12px; 
		font-size: 13px;
	}

	#boardPagination { gap: 2px; }
	.pageBtn {
		min-width: 28px;
		height: 28px;
		padding: 0 5px;
		font-size: 12px;
	}
}
</style>
</div>

<div class="popUp popUp01" id="boardRegPop">
	<div class="popTit">
		<p id="popTitleText">새 게시판 생성</p>
		<img class="popClose" src="${pageContext.request.contextPath}/new/img/popclose.png" style="cursor:pointer;" />
	</div>
	<div class="popCont">
		<form id="registForm" name="registForm">
			<input type="hidden" id="boardId" name="id" value="">
			
			<div class="inputArea02 mb-20">
				<p class="inputTxt02">게시판 명</p>
				<input type="text" autocomplete="off" class="Input02" id="boardName" name="boardName" placeholder="예) 공지사항, 자유게시판" required>
			</div>
			
			<div class="inputArea02 mb-20">
				<p class="inputTxt02">상태 (ON/OFF)</p>
				<div style="padding: 10px 0; font-size: 14px;">
					<label style="margin-right: 20px; cursor: pointer;">
						<input type="radio" name="useYn" value="Y" checked> ON (사용함)
					</label>
					<label style="cursor: pointer;">
						<input type="radio" name="useYn" value="N"> OFF (사용안함)
					</label>
				</div>
			</div>
			
			<div class="inputArea02 mb-20">
				<p class="inputTxt02">접근 및 쓰기 권한 <span style="font-size:11px;color:#888;">(다중 선택 가능)</span></p>
				<div style="padding: 12px; background: #f9f9f9; border: 1px solid #ddd; border-radius: 4px;">
					<label class="ext-label" style="font-weight: bold; width: 100%; border-bottom: 1px solid #ddd; padding-bottom: 8px; margin-bottom: 8px;">
						<input type="checkbox" name="auth" value="ALL" id="authAll" checked> 전체 허용
					</label><br/>
					<label class="ext-label"><input type="checkbox" name="auth" value="SYS_ADMIN" class="auth-role"> 시스템 관리자</label>
					<label class="ext-label"><input type="checkbox" name="auth" value="RESEARCH_ADMIN" class="auth-role"> 연구소</label>
					<label class="ext-label"><input type="checkbox" name="auth" value="0" class="auth-role"> 관리자</label>
					<label class="ext-label"><input type="checkbox" name="auth" value="1" class="auth-role"> 협력사</label>
					<label class="ext-label"><input type="checkbox" name="auth" value="2" class="auth-role"> 시공사</label>
					<label class="ext-label"><input type="checkbox" name="auth" value="3" class="auth-role"> 가맹점</label>
				</div>
			</div>

			<div class="inputArea02 mb-20">
				<p class="inputTxt02">허용 첨부파일 종류</p>
				<div style="padding: 12px; background: #f9f9f9; border: 1px solid #ddd; border-radius: 4px;" id="extCheckGroup">
					<label class="ext-label" style="font-weight: bold; width: 100%; border-bottom: 1px solid #ddd; padding-bottom: 8px; margin-bottom: 8px;">
						<input type="checkbox" id="extAll"> 전체 허용 (모든 파일 형식)
					</label><br/>
					<label class="ext-label"><input type="checkbox" name="allowedExts" value=".doc"> .doc</label>
					<label class="ext-label"><input type="checkbox" name="allowedExts" value=".docx"> .docx</label>
					<label class="ext-label"><input type="checkbox" name="allowedExts" value=".xls"> .xls</label>
					<label class="ext-label"><input type="checkbox" name="allowedExts" value=".xlsx"> .xlsx</label>
					<label class="ext-label"><input type="checkbox" name="allowedExts" value=".ppt"> .ppt</label>
					<label class="ext-label"><input type="checkbox" name="allowedExts" value=".pptx"> .pptx</label>
					<label class="ext-label"><input type="checkbox" name="allowedExts" value=".hwp"> .hwp</label>
					<label class="ext-label"><input type="checkbox" name="allowedExts" value=".hwpx"> .hwpx</label>
					<label class="ext-label"><input type="checkbox" name="allowedExts" value=".pdf"> .pdf</label>
					<label class="ext-label"><input type="checkbox" name="allowedExts" value=".zip"> .zip</label>
					<br/>
					<label class="ext-label"><input type="checkbox" name="allowedExts" value=".jpg"> .jpg</label>
					<label class="ext-label"><input type="checkbox" name="allowedExts" value=".png"> .png</label>
					<label class="ext-label"><input type="checkbox" name="allowedExts" value=".m4a"> .m4a</label>
					<label class="ext-label"><input type="checkbox" name="allowedExts" value=".m4p"> .m4p</label>
					<label class="ext-label"><input type="checkbox" name="allowedExts" value=".mp3"> .mp3</label>
					<br/>
					<label class="ext-label"><input type="checkbox" name="allowedExts" value=".exe"> .exe</label>
					<label class="ext-label"><input type="checkbox" name="allowedExts" value=".bat"> .bat</label>
					<label class="ext-label"><input type="checkbox" name="allowedExts" value=".cmd"> .cmd</label>
					<label class="ext-label"><input type="checkbox" name="allowedExts" value=".sh"> .sh</label>
					<label class="ext-label"><input type="checkbox" name="allowedExts" value=".js"> .js</label>
					<label class="ext-label"><input type="checkbox" name="allowedExts" value=".apk"> .apk</label>
				</div>
				<p style="font-size: 11px; color: #888; margin-top: 5px;">* 선택하지 않으면 첨부파일 기능을 사용하지 않습니다.</p>
			</div>

			<div class="popAdd" id="submitActionBtn" onclick="submitBoard();" style="cursor:pointer;">게시판 등록</div>
		</form>
	</div>
</div>

<div class="popLayer"></div>

<script>
	$('.popUp').hide();
	$('.popLayer').hide();

	$('#authAll').on('change', function() {
		if($(this).is(':checked')) { $('.auth-role').prop('checked', false); }
	});
	$('.auth-role').on('change', function() {
		if($(this).is(':checked')) { $('#authAll').prop('checked', false); }
	});

	$('#extAll').on('change', function() {
		var isChecked = $(this).is(':checked');
		$('input:checkbox[name=allowedExts]').prop('checked', isChecked);
	});

	$('input:checkbox[name=allowedExts]').on('change', function() {
		var totalCount = $('input:checkbox[name=allowedExts]').length;
		var checkedCount = $('input:checkbox[name=allowedExts]:checked').length;
		
		if (checkedCount === totalCount) {
			$('#extAll').prop('checked', true);
		} else {
			$('#extAll').prop('checked', false);
		}
	});

	function openRegPopup() {
		$('#popTitleText').text('새 게시판 생성');
		$('#submitActionBtn').text('게시판 등록');
		$('#boardId').val('');
		$('#registForm')[0].reset();

		$('input:radio[name=useYn]:input[value="Y"]').prop("checked", true);
		
		$('input:checkbox[name=auth]').prop('checked', false);
		$('#authAll').prop('checked', true);

		$('input:checkbox[name=allowedExts]').prop('checked', false);
		$('#extAll').prop('checked', false);

		$('#boardRegPop').show();
		$('.popLayer').show();
		$('body').css('overflow', 'hidden');
	}

	function openUpdatePopupDirect(id) {
		$.ajax({
			type: "GET",
			url: "${pageContext.request.contextPath}/admin/board/detail", 
			data: { id: id },
			success: function(response) {
				if (response.success) {
					var board = response.board;
					
					$('#popTitleText').text('게시판 설정 변경');
					$('#submitActionBtn').text('설정 저장');
					$('#boardId').val(board.id);
					$('#boardName').val(board.boardName);
					
					$('input:radio[name=useYn]:input[value="' + board.useYn + '"]').prop("checked", true);

					$('input:checkbox[name=auth]').prop("checked", false);
					if(board.auth) {
						var auths = board.auth.replace(/\s/g, '').split(',');
						auths.forEach(function(a) {
							$('input:checkbox[name=auth][value="' + a + '"]').prop("checked", true);
						});
					}

					$('input:checkbox[name=allowedExts]').prop("checked", false);
					$('#extAll').prop("checked", false);
					if(board.allowedExts) {
						var exts = board.allowedExts.replace(/\s/g, '').split(',');
						exts.forEach(function(ext) {
							$('input:checkbox[name=allowedExts][value="' + ext + '"]').prop("checked", true);
						});

						var totalCount = $('input:checkbox[name=allowedExts]').length;
						var checkedCount = $('input:checkbox[name=allowedExts]:checked').length;
						if (checkedCount === totalCount && totalCount > 0) {
							$('#extAll').prop('checked', true);
						}
					}

					$('#boardRegPop').show();
					$('.popLayer').show();
					$('body').css('overflow', 'hidden');
				} else {
					alert('정보를 불러오지 못했습니다.');
				}
			}
		});
	}

	$('.popClose, .popLayer').on('click', function(e){
		$('.popUp').hide();
		$('.popLayer').hide();
		$('body').css('overflow', 'auto');
		$('#registForm')[0].reset();
	});

	$('#searchKeyword').on('keypress', function(e) {
		if (e.which === 13) {
			$('#searchForm').submit();
		}
	});

	function submitBoard() {
		if (!$('#boardName').val().trim()) {
			alert('게시판 명을 입력하세요.');
			$('#boardName').focus();
			return;
		}
		if ($('input:checkbox[name=auth]:checked').length === 0) { 
			alert('최소 1개 이상의 권한을 선택하세요.'); 
			return; 
		}

		var id = $('#boardId').val();
		var isEdit = id !== "";
		var url = isEdit ? "${pageContext.request.contextPath}/admin/board/update" : "${pageContext.request.contextPath}/admin/board/regist";
		
		var formData = $('#registForm').serialize();

		$.ajax({
			type : "POST",
			url : url,
			data : formData,
			success : function(response) {  
				if(response.success) {
					alert(isEdit ? '게시판 설정이 변경되었습니다.' : '새 게시판이 생성되었습니다.');
					location.reload(); 
				} else {
					alert('처리 실패: ' + response.message);
				}
			},
			error : function(xhr, status, error) {
				alert('서버 통신 중 오류가 발생했습니다.');
			}
		}); 
	}

	function deleteBoard(id) {
		if (!confirm('정말 이 게시판을 삭제하시겠습니까?\n내부에 작성된 글이 있다면 함께 삭제될 수 있습니다.')) {
			return;
		}

		$.ajax({
			type : "POST",
			url : "${pageContext.request.contextPath}/admin/board/delete",
			data : { id : id },
			success : function(response) {
				if (response.success) {
					alert('게시판이 정상적으로 삭제되었습니다.');
					location.reload();
				} else {
					alert('삭제 실패: ' + response.message);
				}
			},
			error : function(xhr, status, error) {
				alert('서버 통신 중 오류가 발생했습니다.');
			}
		});
	}

	$(document).ready(function() {
		$(".navBtn").click(function() {
			$(".left-menu").animate({ "left": "0%" }, 500);
		});
		$(".m-closeBtn").click(function(){
			$(".left-menu").animate({ "left": "-150%" }, 500);
		});
	});

	$('.mlist a').on('click', function(e){
		var tg = $(this).next('.sub-menu');
		if(tg.length>0){
			if($(this).hasClass('isOpen')){
				tg.slideUp('fast');
				$(this).removeClass('isOpen');
			} else {
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
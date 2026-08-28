<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/tagLib.jsp" %>

<c:set var="isSysAdmin" value="${not empty sessionScope.isSystemAdmin and sessionScope.isSystemAdmin}" />
<c:set var="roleNum" value="${not empty sessionScope.role ? sessionScope.role : 99}" />
<c:set var="canWrite" value="false" />
<c:set var="authStr" value=",${boardMaster.auth}," />

<c:choose>
	<c:when test="${fn:contains(authStr, ',ALL,')}">
		<c:set var="canWrite" value="true" />
	</c:when>
	<c:when test="${isSysAdmin}">
		<c:set var="canWrite" value="true" />
	</c:when>
	<c:when test="${not isSysAdmin and roleNum == 0 and fn:contains(authStr, ',0,')}">
		<c:set var="canWrite" value="true" />
	</c:when>
	<c:when test="${roleNum == 1 and fn:contains(authStr, ',1,')}">
		<c:set var="canWrite" value="true" />
	</c:when>
	<c:when test="${roleNum == 2 and fn:contains(authStr, ',2,')}">
		<c:set var="canWrite" value="true" />
	</c:when>
	<c:when test="${roleNum == 3 and fn:contains(authStr, ',3,')}">
		<c:set var="canWrite" value="true" />
	</c:when>
</c:choose>

<div class="section-right">
	<%@ include file="/WEB-INF/views/common/welcomeMsg.jsp" %>
	<div class="TopContArea">
		<div class="titArea">
			<p class="h1Tit">${boardMaster.boardName}</p>
			
			<c:if test="${canWrite}">
				<a class="popBtn popBtnRegist" style="cursor:pointer;" onclick="openRegPopup();">글쓰기</a>
			</c:if>
		</div>

		<form id="searchForm" method="GET" action="${pageContext.request.contextPath}/board/list" onsubmit="return true;">
			<input type="hidden" name="boardId" value="${boardMaster.id}">
			
			<div class="searchArea">
				<div class="searchArea01">
					<select name="searchType" id="searchType" class="select01">
						<option value="title" <c:if test="${param.searchType == 'title'}">selected</c:if>>제목</option>
						<option value="regUser" <c:if test="${param.searchType == 'regUser'}">selected</c:if>>작성자</option>
					</select>
					<input type="text" name="keyword" id="searchKeyword" class="searchin" value="${param.keyword}" placeholder="검색어를 입력하세요."/>
					<div class="searchBtn">
						<img id="submitBtn" src="${pageContext.request.contextPath}/new/img/search.png" style="cursor:pointer;" onclick="$('#searchForm').submit();">
					</div>
				</div>
			</div>
		</form>
	</div>
	
	<div class="listArea">
		<div class="pc-table-wrap" style="overflow-x:auto;">
			<table style="width:100%;min-width:700px;border-collapse:collapse;">
				<thead>
					<tr style="background:#f5f5f5;border-bottom:2px solid #ddd;">
						<th style="padding:10px;text-align:center;width:60px;white-space:nowrap;">번호</th>
						<th style="padding:10px;text-align:center;min-width:200px;">제목</th>
						<th style="padding:10px;text-align:center;min-width:120px;white-space:nowrap;">첨부파일</th>
						<th style="padding:10px;text-align:center;min-width:100px;white-space:nowrap;">작성자</th>
						<th style="padding:10px;text-align:center;min-width:130px;white-space:nowrap;">등록일</th>
					</tr>
				</thead>
				<tbody id="boardTbody">
					<c:choose>
						<c:when test="${empty postList}">
							<tr>
								<td colspan="5" style="text-align:center;padding:24px;color:#999;">등록된 게시글이 없습니다.</td>
							</tr>
						</c:when>
						<c:otherwise>
							<c:forEach var="item" items="${postList}">
								<tr style="border-bottom:1px solid #eee;">
									<td style="padding:10px;text-align:center;border:1px solid #eee;white-space:nowrap;">${item.rowNum}</td>
									<td style="padding:10px;border:1px solid #eee;text-align:left;padding-left:15px;">
										<a href="javascript:void(0);" onclick="openDetailPopup(${item.id});" style="color: #333; text-decoration: none; font-weight:500;">${item.title}</a>
									</td>
									<td style="padding:10px;text-align:center;border:1px solid #eee;white-space:nowrap;">
										<c:set var="fCount" value="0"/>
										<c:if test="${not empty item.fileName1}"><c:set var="fCount" value="${fCount + 1}"/></c:if>
										<c:if test="${not empty item.fileName2}"><c:set var="fCount" value="${fCount + 1}"/></c:if>
										<c:if test="${not empty item.fileName3}"><c:set var="fCount" value="${fCount + 1}"/></c:if>
										
										<c:if test="${fCount > 0}">
											<span style="font-size:16px;">💾</span> <span style="font-size:12px;color:#888;">(${fCount})</span>
										</c:if>
									</td>
									<td style="padding:10px;text-align:center;border:1px solid #eee;white-space:nowrap;">${item.regUser}</td>
									<td style="padding:10px;text-align:center;border:1px solid #eee;white-space:nowrap;"><fmt:formatDate value="${item.regDate}" pattern="yyyy-MM-dd"/></td>
								</tr>
							</c:forEach>
						</c:otherwise>
					</c:choose>
				</tbody>
			</table>
		</div>

		<div id="boardCards" style="display:none;">
			<c:choose>
				<c:when test="${empty postList}">
					<p style="text-align:center;padding:24px;color:#999;">등록된 게시글이 없습니다.</p>
				</c:when>
				<c:otherwise>
					<c:forEach var="item" items="${postList}">
						<div style="background:#fff;border:1px solid #ddd;border-radius:6px;padding:14px 16px;margin-bottom:10px;cursor:pointer;" onclick="openDetailPopup(${item.id});">
							
							<c:set var="fCount" value="0"/>
							<c:if test="${not empty item.fileName1}"><c:set var="fCount" value="${fCount + 1}"/></c:if>
							<c:if test="${not empty item.fileName2}"><c:set var="fCount" value="${fCount + 1}"/></c:if>
							<c:if test="${not empty item.fileName3}"><c:set var="fCount" value="${fCount + 1}"/></c:if>

							<div style="display:flex;justify-content:space-between;align-items:flex-start;margin-bottom:8px;">
								<span style="font-weight:bold;font-size:15px;color:#333;line-height:1.4;word-break:break-all;">
									${item.title}
								</span>
								<c:if test="${fCount > 0}">
									<span style="margin-left:8px;font-size:14px;white-space:nowrap;">💾 <span style="font-size:12px;color:#888;">(${fCount})</span></span>
								</c:if>
							</div>
							
							<div style="display:flex;justify-content:space-between;font-size:13px;color:#777;">
								<span>작성자: ${item.regUser}</span>
								<span><fmt:formatDate value="${item.regDate}" pattern="yyyy-MM-dd"/></span>
							</div>
						</div>
					</c:forEach>
				</c:otherwise>
			</c:choose>
		</div>
	</div>

	<div id="boardPagination" style="display:flex;justify-content:center;gap:4px;margin-top:20px;margin-bottom:30px;">
		<c:if test="${pagination.startPage > 1}">
			<button class="pageBtn" onclick="location.href='${pageContext.request.contextPath}/board/list?boardId=${boardMaster.id}&page=${pagination.startPage - 1}&size=${pagination.pageSize}&searchType=${param.searchType}&keyword=${param.keyword}'">이전</button>
		</c:if>

		<c:forEach var="i" begin="${pagination.startPage}" end="${pagination.endPage}">
			<c:choose>
				<c:when test="${i == pagination.currentPage}">
					<button class="pageBtn active" onclick="return false;">${i}</button>
				</c:when>
				<c:otherwise>
					<button class="pageBtn" onclick="location.href='${pageContext.request.contextPath}/board/list?boardId=${boardMaster.id}&page=${i}&size=${pagination.pageSize}&searchType=${param.searchType}&keyword=${param.keyword}'">${i}</button>
				</c:otherwise>
			</c:choose>
		</c:forEach>

		<c:if test="${pagination.endPage < pagination.pageCount}">
			<button class="pageBtn" onclick="location.href='${pageContext.request.contextPath}/board/list?boardId=${boardMaster.id}&page=${pagination.endPage + 1}&size=${pagination.pageSize}&searchType=${param.searchType}&keyword=${param.keyword}'">다음</button>
		</c:if>
	</div>

<style>
.pageBtn { 
	min-width:32px; height:32px; padding:0 8px; border:1px solid #ddd; 
	background:#fff; color:#333; border-radius:3px; cursor:pointer; font-size:13px; 
}
.pageBtn:hover { border-color:#adadad; background:#e6e6e6; }
.pageBtn.active { background:#337ab7; color:#fff; border-color:#337ab7; }
.pageBtn:disabled { cursor:default; color:#ccc; }

.listArea { background: #fff; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); padding: 20px; }
#boardTbody tr:hover { background-color: #f9f9f9; }

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

	#boardCards > div:active {
		background-color: #f0f0f0;
	}

	#boardPagination { gap: 2px; }
	.pageBtn {
		min-width: 28px; height: 28px; padding: 0 5px; font-size: 12px;
	}
}
</style>
</div>

<div class="popUp popUp01" id="postDetailPop">
	<div class="popTit">
		<p>게시글 상세 보기</p>
		<img class="popClose" src="${pageContext.request.contextPath}/new/img/popclose.png" style="cursor:pointer;" />
	</div>
	<div class="popCont">
		<div class="inputArea02 mb-20">
			<p class="inputTxt02" style="font-weight:bold; color:#555;">작성자</p>
			<div id="detailRegUser" style="padding: 10px; background: #f9f9f9; border-radius: 4px; border: 1px solid #ddd;"></div>
		</div>
		<div class="inputArea02 mb-20">
			<p class="inputTxt02" style="font-weight:bold; color:#555;">제목</p>
			<div id="detailTitle" style="padding: 10px; background: #f9f9f9; border-radius: 4px; border: 1px solid #ddd;"></div>
		</div>
		<div class="inputArea02 mb-20">
			<p class="inputTxt02" style="font-weight:bold; color:#555;">내용</p>
			<div id="detailContent" style="padding: 10px; background: #f9f9f9; border-radius: 4px; border: 1px solid #ddd; min-height: 100px; white-space: pre-wrap;"></div>
		</div>
		<div class="inputArea02 mb-20">
			<p class="inputTxt02" style="font-weight:bold; color:#555;">첨부파일</p>
			<div id="detailFileList" style="padding: 10px; background: #f9f9f9; border-radius: 4px; border: 1px solid #ddd;"></div>
		</div>
		<div style="display: flex; gap: 10px;" id="detailActionBtns">
			<div class="popAdd" id="goEditBtn" style="cursor:pointer; background:#337ab7; text-align:center; flex:1;">수정하기</div>
			<div class="popAdd" id="goDeleteBtn" style="cursor:pointer; background:#d9534f; text-align:center; flex:1;">삭제하기</div>
			<div class="popAdd popClose" style="cursor:pointer; background:#888; text-align:center; flex:1;">닫기</div>
		</div>
	</div>
</div>

<div class="popUp popUp02" id="postRegPop">
	<div class="popTit">
		<p id="popTitleText">새 게시글 작성</p>
		<img class="popClose" src="${pageContext.request.contextPath}/new/img/popclose.png" style="cursor:pointer;" />
	</div>
	<div class="popCont">
		<form id="registForm" name="registForm" enctype="multipart/form-data">
			<input type="hidden" name="boardId" value="${boardMaster.id}">
			<input type="hidden" id="postId" name="id" value="">
			
			<div class="inputArea02 mb-20">
				<p class="inputTxt02">작성자</p>
				<input type="text" autocomplete="off" class="Input02" id="regUser" name="regUser" placeholder="작성자명을 입력하세요." required>
			</div>
			<div class="inputArea02 mb-20">
				<p class="inputTxt02">제목</p>
				<input type="text" autocomplete="off" class="Input02" id="title" name="title" placeholder="제목을 입력하세요." required>
			</div>
			<div class="inputArea02 mb-20">
				<p class="inputTxt02">내용</p>
				<textarea class="Input02" id="content" name="content" placeholder="내용을 입력하세요." style="height: 100px; resize: none;"></textarea>
			</div>
			
			<div class="inputArea02 mb-20" id="fileAttachArea" style="display:none;">
				<p class="inputTxt02">첨부파일 <span style="font-size:11px;color:#888;">(최대 3개 다중 선택 가능)</span></p>
				<div id="existingFilesArea" style="margin-bottom:10px;"></div>
				<input type="file" class="Input02" id="uploadFile" name="files" multiple style="padding: 10px 0;">
				<p style="font-size: 12px; color: #d9534f; margin-top: 5px;">* 허용 확장자: <span id="extText">${boardMaster.allowedExts}</span></p>
			</div>

			<div class="popAdd" id="submitBtn" onclick="submitPost();" style="cursor:pointer;">게시글 등록</div>
		</form>
	</div>
</div>

<div class="popLayer"></div>

<script>
	$('.popUp').hide();
	$('.popLayer').hide();

	var hasWriteAuth = ${canWrite};
	var allowedExtsStr = "${boardMaster.allowedExts}";
	var allowedExts = [];
	if(allowedExtsStr.trim() !== "") {
		allowedExts = allowedExtsStr.replace(/\s/g, '').toLowerCase().split(',');
	}

	function formatBytes(bytes) {
		if (bytes === 0) return '0 Bytes';
		if (!bytes) return '';
		var k = 1024;
		var sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB'];
		var i = Math.floor(Math.log(bytes) / Math.log(k));
		return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
	}

	function openRegPopup() {
		$('#popTitleText').text('새 게시글 작성');
		$('#submitBtn').text('게시글 등록');
		$('#registForm')[0].reset();
		$('#postId').val('');
		$('#regUser').prop('readonly', false);
		$('#existingFilesArea').empty();
		
		if(allowedExts.length === 0) {
			$('#fileAttachArea').hide();
		} else {
			$('#fileAttachArea').show();
			$('#extText').html(allowedExtsStr);
		}

		$('#postRegPop').show();
		$('.popLayer').show();
		$('body').css('overflow', 'hidden');
	}

	function openDetailPopup(id) {
		$.ajax({
			type: "GET",
			url: "${pageContext.request.contextPath}/board/detail",
			data: { id: id },
			success: function(response) {
				if (response.success) {
					var post = response.post;
					
					$('#detailRegUser').text(post.regUser);
					$('#detailTitle').text(post.title);
					$('#detailContent').text(post.content ? post.content : '내용이 없습니다.');
					
					$('#detailFileList').empty();
					var hasFile = false;
					for(var i=1; i<=3; i++) {
						var fName = post['fileName'+i];
						var fSize = post['fileSize'+i];
						
						if(fName) {
							hasFile = true;
							var url = "${pageContext.request.contextPath}/board/download?id=" + post.id + "&slot=" + i;
							
							var sizeStr = fSize ? ' <span style="font-weight:normal;color:#777;font-size:12px;">(' + formatBytes(fSize) + ')</span>' : '';
							
							$('#detailFileList').append('<div style="margin-bottom:6px;"><a href="'+url+'" style="color:#077b9c;font-weight:bold;text-decoration:none;">💾 '+fName + sizeStr + '</a></div>');
						}
					}
					if(!hasFile) $('#detailFileList').text('첨부파일 없음');

					if(hasWriteAuth) {
						$('#goEditBtn').show().off('click').on('click', function() {
							$('#postDetailPop').hide();
							openUpdatePopup(post);
						});
						$('#goDeleteBtn').show().off('click').on('click', function() {
							deletePost(post.id);
						});
					} else {
						$('#goEditBtn').hide();
						$('#goDeleteBtn').hide();
					}

					$('#postDetailPop').show();
					$('.popLayer').show();
					$('body').css('overflow', 'hidden');
				} else {
					alert('게시글 정보를 불러오지 못했습니다: ' + response.message);
				}
			}
		});
	}

	function openUpdatePopup(post) {
		$('#popTitleText').text('게시글 수정');
		$('#submitBtn').text('수정 완료');
		$('#postId').val(post.id);
		
		$('#regUser').val(post.regUser).prop('readonly', true);
		$('#title').val(post.title);
		$('#content').val(post.content);
		$('#uploadFile').val('');
		
		$('#existingFilesArea').empty();
		if(allowedExts.length === 0) {
			$('#fileAttachArea').hide();
		} else {
			$('#fileAttachArea').show();
			for(var i=1; i<=3; i++) {
				var fName = post['fileName'+i];
				var fSize = post['fileSize'+i];
				
				if(fName) {
					var sizeStr = fSize ? ' <span style="color:#888;">(' + formatBytes(fSize) + ')</span>' : '';
					var html = '<div id="fileSlot_'+i+'" style="font-size:13px; margin-bottom:5px; background:#fff; padding:5px; border:1px solid #ccc;">' + 
							   '💾 ' + fName + sizeStr +
							   ' <span style="color:red; cursor:pointer; font-weight:bold; float:right;" onclick="removeFile('+post.id+', '+i+')">[삭제]</span></div>';
					$('#existingFilesArea').append(html);
				}
			}
		}
		$('#postRegPop').show();
	}

	function removeFile(postId, slot) {
		if(confirm('이 파일을 즉시 삭제하시겠습니까?')) {
			$.ajax({
				type : "POST",
				url : "${pageContext.request.contextPath}/board/deleteFile",
				data : { postId: postId, slot: slot },
				success : function(res) {
					if(res.success) {
						$('#fileSlot_' + slot).remove();
					} else {
						alert('파일 삭제에 실패했습니다.');
					}
				}
			});
		}
	}

	$('.popClose, .popLayer').on('click', function(e){
		$('.popUp').hide();
		$('.popLayer').hide();
		$('body').css('overflow', 'auto');
	});

	function submitPost() {
		if (!$('#regUser').val().trim()) { alert('작성자를 입력하세요.'); return; }
		if (!$('#title').val().trim()) { alert('제목을 입력하세요.'); return; }

		var files = $('#uploadFile')[0].files;
		var existingCount = $('#existingFilesArea > div').length; 
		
		if(files.length + existingCount > 3) {
			alert('첨부파일은 최대 3개까지만 유지/업로드 가능합니다.');
			return;
		}

		if (files.length > 0) {
			if (allowedExts.length === 0) {
				alert('이 게시판은 첨부파일 기능을 지원하지 않습니다.');
				return;
			}
			
			for(var i = 0; i < files.length; i++) {
				var ext = "." + files[i].name.split('.').pop().toLowerCase();
				if (allowedExts.indexOf(ext) === -1) {
					alert("다음 파일은 업로드할 수 없습니다: " + files[i].name + "\n업로드 가능 확장자: " + allowedExtsStr);
					return;
				}
			}
		}

		var isEdit = $('#postId').val() !== "";
		var url = isEdit ? "${pageContext.request.contextPath}/board/update" : "${pageContext.request.contextPath}/board/regist";

		var formData = new FormData($('#registForm')[0]);

		$.ajax({
			type : "POST",
			url : url,
			data : formData,
			processData : false,
			contentType : false,
			success : function(response) {  
				if(response.success) {
					alert(isEdit ? '게시글이 성공적으로 수정되었습니다.' : '게시글이 성공적으로 등록되었습니다.');
					location.reload(); 
				} else {
					alert('처리 실패: ' + response.message);
				}
			},
			error : function() {
				alert('서버 통신 중 오류가 발생했습니다.');
			}
		}); 
	}

	function deletePost(id) {
		if (!confirm('정말 이 게시글을 삭제하시겠습니까?\n첨부된 파일도 모두 함께 삭제됩니다.')) return;

		$.ajax({
			type : "POST",
			url : "${pageContext.request.contextPath}/board/delete",
			data : { id : id },
			success : function(response) {
				if (response.success) {
					alert('게시글이 정상적으로 삭제되었습니다.');
					location.reload();
				} else {
					alert('삭제 실패: ' + response.message);
				}
			},
			error: function() {
				alert('서버 통신 중 오류가 발생했습니다.');
			}
		});
	}
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
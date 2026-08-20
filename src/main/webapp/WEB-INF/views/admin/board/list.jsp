<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/tagLib.jsp" %>

<div class="section-right">
	<%@ include file="/WEB-INF/views/common/welcomeMsg.jsp" %>
	<div class="TopContArea">
		<div class="titArea">
			<p class="h1Tit">관리자 전용 게시판</p>
			<a class="popBtn popBtnRegist" style="cursor:pointer;" onclick="openRegPopup();">글쓰기</a>
		</div>

		<form id="searchForm" method="GET" action="${pageContext.request.contextPath}/admin/board/list" onsubmit="return true;">
			<div class="searchArea">
				<div class="searchArea01">
					<select name="searchType" id="searchType" class="select01">
						<option value="title" <c:if test="${param.searchType == 'title'}">selected</c:if>>제목</option>
						<option value="content" <c:if test="${param.searchType == 'content'}">selected</c:if>>내용</option>
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
	
	<div class="listArea" style="padding:20px;">
		<div class="pc-table-wrap" style="overflow-x:auto;">
			<table style="width:100%;min-width:700px;border-collapse:collapse;">
				<thead>
					<tr style="background:#f5f5f5;border-bottom:2px solid #ddd;">
						<th style="padding:10px;text-align:center;width:60px;white-space:nowrap;">번호</th>
						<th style="padding:10px;text-align:center;min-width:200px;">제목</th>
						<th style="padding:10px;text-align:center;min-width:120px;white-space:nowrap;">첨부파일</th>
						<th style="padding:10px;text-align:center;min-width:100px;white-space:nowrap;">작성자</th>
						<th style="padding:10px;text-align:center;min-width:130px;white-space:nowrap;">등록일</th>
						<th style="padding:10px;text-align:center;min-width:110px;white-space:nowrap;">관리</th>
					</tr>
				</thead>
				<tbody id="boardTbody">
					<c:choose>
						<c:when test="${empty boardList}">
							<tr>
								<td colspan="6" style="text-align:center;padding:24px;color:#999;">등록된 게시글이 없습니다.</td>
							</tr>
						</c:when>
						<c:otherwise>
							<c:forEach var="item" items="${boardList}">
								<tr style="border-bottom:1px solid #eee;">
									<td style="padding:10px;text-align:center;border:1px solid #eee;white-space:nowrap;">${item.id}</td>
									<td style="padding:10px;border:1px solid #eee;text-align:left;padding-left:15px;">
										<a href="javascript:void(0);" onclick="openDetailPopup(${item.id});" style="color: #333; text-decoration: none; font-weight:500;">${item.title}</a>
									</td>
									<td style="padding:10px;text-align:center;border:1px solid #eee;white-space:nowrap;">
										<c:if test="${not empty item.fileName}">
											<a href="${pageContext.request.contextPath}/admin/board/download?id=${item.id}" style="color: #077b9c; font-weight: bold; text-decoration:none;">다운로드</a>
										</c:if>
									</td>
									<td style="padding:10px;text-align:center;border:1px solid #eee;white-space:nowrap;">${item.regUser}</td>
									<td style="padding:10px;text-align:center;border:1px solid #eee;white-space:nowrap;"><fmt:formatDate value="${item.regDate}" pattern="yyyy-MM-dd HH:mm"/></td>
									<td style="padding:10px;text-align:center;border:1px solid #eee;white-space:nowrap;">
										<button type="button" onclick="openUpdatePopupDirect(${item.id})" style="cursor:pointer;padding:5px 10px;background:#337ab7;color:#fff;border:none;border-radius:3px;font-size:12px;margin-right:4px;">수정</button>
										<button type="button" onclick="deletePost(${item.id})" style="cursor:pointer;padding:5px 10px;background:#d9534f;color:#fff;border:none;border-radius:3px;font-size:12px;">삭제</button>
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
					<p style="text-align:center;padding:24px;color:#999;">등록된 게시글이 없습니다.</p>
				</c:when>
				<c:otherwise>
					<c:forEach var="item" items="${boardList}">
						<div style="background:#fff;border:1px solid #ddd;border-radius:6px;padding:14px 16px;margin-bottom:10px;">
							<div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:8px;">
								<a href="javascript:void(0);" onclick="openDetailPopup(${item.id});" style="font-weight:bold;font-size:15px;color:#333;text-decoration:none;">${item.title}</a>
								<div>
									<button type="button" onclick="openUpdatePopupDirect(${item.id})" style="cursor:pointer;padding:4px 8px;background:#337ab7;color:#fff;border:none;border-radius:3px;font-size:12px;margin-right:2px;">수정</button>
									<button type="button" onclick="deletePost(${item.id})" style="cursor:pointer;padding:4px 8px;background:#d9534f;color:#fff;border:none;border-radius:3px;font-size:12px;">삭제</button>
								</div>
							</div>
							<table style="width:100%;font-size:13px;border-collapse:collapse;">
								<tr><td style="color:#888;padding:3px 8px 3px 0;width:70px;">작성자</td><td style="padding:3px 0;">${item.regUser}</td></tr>
								<tr><td style="color:#888;padding:3px 8px 3px 0;">등록일</td><td style="padding:3px 0;"><fmt:formatDate value="${item.regDate}" pattern="yyyy-MM-dd HH:mm"/></td></tr>
								<c:if test="${not empty item.fileName}">
									<tr><td style="color:#888;padding:3px 8px 3px 0;">첨부파일</td><td style="padding:3px 0;"><a href="${pageContext.request.contextPath}/admin/board/download?id=${item.id}" style="color: #077b9c; font-weight: bold; text-decoration:none;">다운로드</a></td></tr>
								</c:if>
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
@media (max-width: 600px) {
	.pc-table-wrap { display: none !important; }
	#boardCards { display: block !important; }
}
.pageBtn {
	min-width:32px;
	height:32px;
	padding:0 8px;
	border:1px solid #ddd;
	background:#fff;
	color:#333;
	border-radius:3px;
	cursor:pointer;
	font-size:13px;
}
.pageBtn:hover {
	border-color:#adadad;
	background:#e6e6e6;
}
.pageBtn.active {
	background:#337ab7;
	color:#fff;
	border-color:#337ab7;
}
.pageBtn:disabled {
	cursor:default;
	color:#ccc;
}
.listArea {
	background: #fff;
	border-radius: 8px;
	box-shadow: 0 2px 10px rgba(0,0,0,0.05);
	padding: 20px;
}
#boardTbody tr:hover {
	background-color: #f9f9f9;
}
</style>
</div>

<div class="popUp popUp01" id="boardDetailPop">
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
			<div id="detailFile" style="padding: 5px 0;"></div>
		</div>
		<div style="display: flex; gap: 10px;">
			<div class="popAdd" id="goEditBtn" style="cursor:pointer; background:#337ab7; text-align:center; flex:1;">수정하기</div>
			<div class="popAdd popClose" style="cursor:pointer; background:#888; text-align:center; flex:1;">닫기</div>
		</div>
	</div>
</div>

<div class="popUp popUp02" id="boardRegPop">
	<div class="popTit">
		<p id="popTitleText">새 게시글 작성</p>
		<img class="popClose" src="${pageContext.request.contextPath}/new/img/popclose.png" style="cursor:pointer;" />
	</div>
	<div class="popCont">
		<form id="registForm" name="registForm" enctype="multipart/form-data">
			<input type="hidden" id="boardId" name="id" value="">
			
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
			<div class="inputArea02 mb-20">
				<p class="inputTxt02">첨부파일 <span id="fileReqSpan" style="color: red; font-size:12px;">* 필수</span></p>
				<input type="file" class="Input02" id="uploadFile" name="file" style="padding: 10px 0;" required>
				<p id="currentFileText" style="font-size: 12px; color: #666; margin-top: 5px;"></p>
			</div>
			<div class="popAdd" id="submitBtn" onclick="submitBoard();" style="cursor:pointer;">게시글 등록</div>
		</form>
	</div>
</div>

<div class="popLayer"></div>

<script>
    $('.popUp').hide();
    $('.popLayer').hide();

    function openRegPopup() {
        $('#popTitleText').text('새 게시글 작성');
        $('#submitBtn').text('게시글 등록');
        $('#boardId').val('');
        $('#registForm')[0].reset();
        $('#currentFileText').text('');
        $('#fileReqSpan').show();
        $('#uploadFile').attr('required', true);

        $('#boardRegPop').show();
        $('.popLayer').show();
        $('body').css('overflow', 'hidden');
    }

    function openDetailPopup(id) {
        $.ajax({
            type: "GET",
            url: "${pageContext.request.contextPath}/admin/board/detail",
            data: { id: id },
            success: function(response) {
                if (response.success) {
                    var board = response.board;
                    
                    $('#detailRegUser').text(board.regUser);
                    $('#detailTitle').text(board.title);
                    $('#detailContent').text(board.content ? board.content : '내용이 없습니다.');
                    
                    if (board.fileName) {
                        var downloadUrl = "${pageContext.request.contextPath}/admin/board/download?id=" + board.id;
                        $('#detailFile').html('<a href="' + downloadUrl + '" style="color: #077b9c; font-weight: bold; text-decoration:none;">' + board.fileName + ' 다운로드</a>');
                    } else {
                        $('#detailFile').text('첨부파일 없음');
                    }

                    $('#goEditBtn').off('click').on('click', function() {
                        $('#boardDetailPop').hide();
                        openUpdatePopup(board);
                    });

                    $('#boardDetailPop').show();
                    $('.popLayer').show();
                    $('body').css('overflow', 'hidden');
                } else {
                    alert('정보를 불러오지 못했습니다: ' + response.message);
                }
            },
            error: function() {
                alert('서버 통신 중 오류가 발생했습니다.');
            }
        });
    }

    function openUpdatePopupDirect(id) {
        $.ajax({
            type: "GET",
            url: "${pageContext.request.contextPath}/admin/board/detail",
            data: { id: id },
            success: function(response) {
                if (response.success) {
                    openUpdatePopup(response.board);
                } else {
                    alert('정보를 불러오지 못했습니다.');
                }
            }
        });
    }

    function openUpdatePopup(board) {
        $('#popTitleText').text('게시글 수정');
        $('#submitBtn').text('게시글 수정');
        $('#boardId').val(board.id);
        $('#regUser').val(board.regUser);
        $('#title').val(board.title);
        $('#content').val(board.content);
        
        if (board.fileName) {
            $('#currentFileText').text('기존 첨부파일: ' + board.fileName);
        } else {
            $('#currentFileText').text('첨부파일 없음');
        }
        
        $('#fileReqSpan').hide();
        $('#uploadFile').removeAttr('required');
        $('#uploadFile').val('');

        $('#boardRegPop').show();
        $('.popLayer').show();
        $('body').css('overflow', 'hidden');
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
        var id = $('#boardId').val();
        var isEdit = id !== "";
        var url = isEdit ? "${pageContext.request.contextPath}/admin/board/update" : "${pageContext.request.contextPath}/admin/board/regist";
        
        var formData = new FormData($('#registForm')[0]);
        var fileInput = $('#uploadFile')[0];

        if (!$('#regUser').val().trim()) {
            alert('작성자를 입력하세요.');
            $('#regUser').focus();
            return;
        }

        if (!$('#title').val().trim()) {
            alert('제목을 입력하세요.');
            $('#title').focus();
            return;
        }
        
        if (!isEdit && fileInput.files.length === 0) {
            alert('첨부파일은 필수 조건입니다. 파일을 업로드해주세요.');
            $('#uploadFile').focus();
            return;
        }

        $.ajax({
            type : "POST",
            url : url,
            data : formData,
            processData : false,
            contentType : false,
            success : function(response) {  
                if(response.success) {
                    alert(isEdit ? '성공적으로 수정되었습니다.' : '성공적으로 등록되었습니다.');
                    $('.popUp').hide();
                    $('.popLayer').hide();
                    $('body').css('overflow', 'auto');
                    location.reload(); 
                } else {
                    alert('처리 실패: ' + response.message);
                }
            },
            error : function(xhr, status, error) {
                alert('서버 통신 중 오류가 발생했습니다.');
                $('.popUp').hide();
                $('.popLayer').hide();
                $('body').css('overflow', 'auto');
            }
        }); 
    }

    function deletePost(id) {
        if (!confirm('정말 이 게시글을 삭제하시겠습니까?')) {
            return;
        }

        $.ajax({
            type : "POST",
            url : "${pageContext.request.contextPath}/admin/board/delete",
            data : { id : id },
            success : function(response) {
                if (response.success) {
                    alert('성공적으로 삭제되었습니다.');
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
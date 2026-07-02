<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/tagLib.jsp" %>
<!--컨텐츠-->
	<div class="section-right">
		<%@ include file="/WEB-INF/views/common/welcomeMsg.jsp" %>
		<div class="TopContArea">
			<div class="titArea mb-0">
				<p class="h1Tit">QR CODE 관리</p>
			</div>
		</div>
		
		<form:form id="searchForm" commandName="domainParam" method="POST">
			<form:hidden path="currentPage"/>
		</form:form>
		
		<!-- 여기에 UI를 만들어줘 -->
		<!-- 여기부터 -->
		<div class="qr-page">
		    <!-- 왼쪽 등록 폼 -->
		    <div class="qr-container">
		    	<h2 style="margin-bottom: 15px;">QR코드 등록</h2>
		        <form id="qrForm" enctype="multipart/form-data">
		            <div class="form-row">
		                <label for="title">제목</label>
		                <input type="text" id="title" name="title" placeholder="QR코드 제목을 입력하세요.">
		            </div>
		            <div class="form-row">
		                <label for="text">텍스트 입력</label>
		                <input type="text" id="text" name="text" placeholder="QR에 담을 텍스트를 입력하세요">
		            </div>
		            <div class="form-row">
		                <label for="file">파일 업로드 (PDF 등)</label>
		                <input type="file" id="file" name="file">
		            </div>
		            <div class="form-row">
		                <label for="link">링크 입력</label>
		                <input type="text" id="link" name="link" placeholder="https://example.com">
		            </div>
		
		            <div class="btn-area">
		                <button type="button" onclick="generateQR()">QR 생성</button>
		                <button type="reset">초기화</button>
		            </div>
		        </form>
		
		        <div class="qr-result">
		            <p>생성된 QR코드 미리보기</p>
		            <img id="qrImage" alt="QR코드" style="display:none;">
		            <div class="btn-area">
		                <input type="hidden" id="qrId" name="qrId">
		                <button id="saveQRBtn" style="display:none;" onclick="saveQR()">저장</button>
		                <button id="downloadQRBtn" style="display:none;" onclick="downloadQR()">다운로드</button>
		            </div>
		        </div>
		    </div>
		
		    <!-- 오른쪽 등록된 QR 리스트 -->
		    <div class="qr-list-container">
		        <h2>등록된 QR코드 리스트</h2>
		        <ul class="qr-list" id="qrList">
		        	<c:forEach var="domain" items="${domainList}"  varStatus="status">
			            <li>
			                <div class="qr-info">
			                	<a href="${pageContext.request.contextPath}/uploads/${domain.qrSaveFilename}" target="_blank">
				                    <img src="${pageContext.request.contextPath}/uploads/${domain.qrSaveFilename}" alt="QR">
			                	</a>
			                    <span>${domain.title}</span>
			                </div>
			                <%-- <button onclick="downloadFromQR('${domain.id}')">다운로드</button> --%>
			                <div class="list-btn-area">
							    <button type="button" class="btn-download" onclick="downloadFromQR('${domain.id}')">다운로드</button>
							    <button type="button" class="btn-delete" onclick="deleteQR('${domain.id}')">삭제</button>
							</div>
			            </li>
		            </c:forEach>
	            	<%@ include file="/WEB-INF/views/common/pagination.jsp" %>
		        </ul>
		    </div>
		</div>
		<!-- 여기까지 -->
</div>
<script>

function downloadFromQR(id){
	  window.location.href = "${pageContext.request.contextPath}/qr/download?id=" + id;
}

function deleteQR(id) {
    if (confirm("정말 이 QR 코드를 삭제하시겠습니까?")) {
        $.ajax({
            url: "${pageContext.request.contextPath}/qr/delete",
            type: "POST", 
            data: { id: id },
            success: function(response) {
                if(response) {
                    alert("삭제가 완료되었습니다.");
                    location.reload();
                } else {
                    alert("삭제에 실패했습니다.");
                }
            },
            error: function(xhr, status, error) {
                alert("삭제 중 오류가 발생했습니다: " + xhr.statusText);
            }
        });
    }
}

function downloadQR() {
    const qrImage = document.getElementById('qrImage');
    if (!qrImage || !qrImage.src.startsWith('data:image')) {
        alert('다운로드할 QR 이미지가 없습니다.');
        return;
    }

    // Data URL → Blob
    const byteString = atob(qrImage.src.split(',')[1]);
    const mimeString = qrImage.src.split(',')[0].split(':')[1].split(';')[0];
    const ab = new ArrayBuffer(byteString.length);
    const ia = new Uint8Array(ab);
    for (let i = 0; i < byteString.length; i++) {
        ia[i] = byteString.charCodeAt(i);
    }
    const blob = new Blob([ab], { type: mimeString });

    // 다운로드 링크 생성
    const link = document.createElement('a');
    link.href = URL.createObjectURL(blob);
    link.download = $('#title').val().trim() + '.png';  // 저장될 파일명
    document.body.appendChild(link);
    link.click();

    // 메모리 해제
    URL.revokeObjectURL(link.href);
    document.body.removeChild(link);
}
function saveQR() {
	
    var qrImage = document.getElementById('qrImage');

    // Data URL -> Blob
    var byteString = atob(qrImage.src.split(',')[1]);
    var mimeString = qrImage.src.split(',')[0].split(':')[1].split(';')[0];
    var ab = new ArrayBuffer(byteString.length);
    var ia = new Uint8Array(ab);
    for (var i = 0; i < byteString.length; i++) {
        ia[i] = byteString.charCodeAt(i);
    }
    var blob = new Blob([ab], {type: mimeString});

    // FormData 생성
    var formData = new FormData();
    formData.append("file", blob, "QR코드.png");
    var qrIdElem = document.getElementById('qrId');
    formData.append("qrId", qrIdElem ? qrIdElem.value : "");
    
    $.ajax({
        url: "${pageContext.request.contextPath}/qr/save",
        type: "POST",
        data: formData,
        processData: false,  // 필수: jQuery가 FormData를 문자열로 변환하지 않도록
        contentType: false,  // 필수: multipart/form-data 설정
        success: function(response) {
        	location.reload();  // 🔄 현재 페이지 새로고침
        },
        error: function(xhr, status, error) {
            //console.error("저장 실패", xhr.responseText);
        }
    });
}

function generateQR() {
	
 	const title = $('#title').val().trim();
    const text = $('#text').val().trim();
    const file = $('#file').val().trim();
    const link = $('#link').val().trim();

    // 🔸 1. 제목(title)은 필수
    if (!title) {
        alert('제목은 필수 입력 항목입니다.');
        return;
    }

    // 🔸 2. text, file, link 중 하나만 입력 가능
    let filledCount = 0;
    if (text) filledCount++;
    if (file) filledCount++;
    if (link) filledCount++;

    if (filledCount === 0) {
        alert('텍스트, 파일, 링크 중 하나를 반드시 입력해야 합니다.');
        return;
    } else if (filledCount > 1) {
        alert('텍스트, 파일, 링크 중 하나만 입력할 수 있습니다.');
        return;
    }
	
	const form = $('#qrForm')[0];
	const formData = new FormData(form);

	$.ajax({
		url: '${pageContext.request.contextPath}/qr/generate',   // 서버에서 QR을 생성하는 엔드포인트
		type: 'POST',
		data: formData,
		processData: false,    // FormData는 jQuery가 처리하지 않도록 설정
		contentType: false,    // 자동으로 multipart/form-data 헤더 설정됨
		success: function(response) {
			if (response.qrBase64) {
                $('#qrImage').attr('src', 'data:image/png;base64,' + response.qrBase64).show();
            } else {
                alert('QR 생성 결과가 없습니다.');
            }
			
			if (response.qrId) {
				//alert(response.qrId);
				$('#qrId').val(response.qrId);
			}
			
		},
		error: function(xhr) {
			alert('QR 생성 중 오류 발생: ' + xhr.statusText);
		}
	});
	
	document.getElementById('saveQRBtn').style.display = 'inline-block';
	document.getElementById('downloadQRBtn').style.display = 'inline-block';
}
</script>
<style>
    /* 전체 컨테이너 */
    .qr-page {
        display: flex;
        gap: 20px;
        padding: 20px;
        font-family: Arial, sans-serif;
    }

    /* 왼쪽 등록 폼 영역 */
    .qr-container {
        width: 40%;
        padding: 20px;
        border: 1px solid #ccc;
        border-radius: 10px;
        background-color: #f9f9f9;
    }

    .qr-container .form-row {
        margin-bottom: 15px;
        display: flex;
        flex-direction: column;
    }

    .qr-container label {
        margin-bottom: 5px;
        font-weight: bold;
    }

    .qr-container input[type="text"],
    .qr-container input[type="file"] {
        padding: 8px;
        border: 1px solid #ccc;
        border-radius: 5px;
    }

    .qr-container .btn-area {
        margin-top: 15px;
        display: flex;
        gap: 10px;
    }

    .qr-container button {
        padding: 8px 12px;
        border: none;
        border-radius: 5px;
        background-color: #007bff;
        color: white;
        cursor: pointer;
    }

    .qr-container button[type="reset"] {
        background-color: #6c757d;
    }

    /* 오른쪽 QR 리스트 영역 */
    .qr-list-container {
        width: 60%;
        padding: 20px;
        border: 1px solid #ccc;
        border-radius: 10px;
        background-color: #fff;
    }

    .qr-list-container h2 {
        margin-bottom: 15px;
    }

    .qr-list {
        list-style: none;
        padding: 0;
        margin: 0;
    }

    .qr-list li {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 10px;
        border-bottom: 1px solid #eee;
    }

    .qr-list img {
        width: 50px;
        height: 50px;
        margin-right: 10px;
    }

    .qr-list .qr-info {
        display: flex;
        align-items: center;
    }

    /* .qr-list button {
        padding: 5px 10px;
        border: none;
        border-radius: 5px;
        background-color: #28a745;
        color: white;
        cursor: pointer;
    } */
    
    .qr-list .list-btn-area {
        display: flex;
        gap: 5px;
    }

    .qr-list button {
        padding: 5px 10px;
        border: none;
        border-radius: 5px;
        color: white;
        cursor: pointer;
        transition: background 0.2s;
    }

    .btn-download {
        background-color: #28a745;
    }
    .btn-download:hover {
        background-color: #1e7e34;
    }

    .btn-delete {
        background-color: #dc3545;
    }
    .btn-delete:hover {
        background-color: #c82333;
    }
     .qr-result {
        margin-top: 20px;
        padding: 15px;
        border: 1px dashed #ccc;
        border-radius: 10px;
        background-color: #fefefe;
        text-align: center;
    }

    .qr-result p {
        font-weight: bold;
        margin-bottom: 15px;
        color: #333;
    }

    .qr-result img {
        width: 150px;
        height: 150px;
        margin-bottom: 15px;
        border: 1px solid #ddd;
        border-radius: 8px;
        box-shadow: 0 2px 6px rgba(0,0,0,0.1);
    }

    .qr-result .btn-area {
        display: flex;
        justify-content: center;
        gap: 10px;
    }

    .qr-result button {
        padding: 8px 15px;
        border: none;
        border-radius: 5px;
        background-color: #007bff;
        color: white;
        cursor: pointer;
        transition: background 0.2s;
    }

    .qr-result button:hover {
        background-color: #0056b3;
    }

    /* 다운로드 버튼 색상 변경 */
    #downloadQRBtn {
        background-color: #28a745;
    }

    #downloadQRBtn:hover {
        background-color: #1e7e34;
    }
</style>
		
		<!-- 여기까지 -->		
	
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
</script>
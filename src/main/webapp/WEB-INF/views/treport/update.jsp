<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/tagLib.jsp" %>
<script type="text/javascript">
	$(document).ready(function() {	
		$('#file').on('change', function() {
			var files = $(this)[0].files[0];
			var fake = $('.upload-name');
			
			fake.val('');
			if ( files != undefined ) {
				fake.val(files.name);
			}
		});
		
	    $('#submitBtn').click( function() {
	    	$('#searchForm').submit();
	    });
		
	});
	
	function formCheck(){
				
		var files = $('#file')[0].files[0];
		if($('#type').val() == ''){
			alert('측정기종류를 입력하세요.');
			return false;
		}else if($('#sn').val() == ''){
			alert('측정기S/N를 입력하세요.');
			return false;
		}
		
		return true;
	}
	
	function goBack(){
		location.href='${pageContext.request.contextPath}/treport/list';
	}
	
</script>
<!--컨텐츠-->
<div class="section-right">
	<p class="sub-tit text-center">시험성적서 수정</p>

	<!--공지내용-->
	<div class="min640">
		<form:form method="POST" commandName="domain" enctype="multipart/form-data">
		<table class="notice-write">
			<tr>
				<td>
					<p class="w-tit">제조사</p>
					<form:select path="mfr" class="select01">
						<form:option value="SOKKIA">SOKKIA</form:option>
						<form:option value="TOPCON">TOPCON</form:option>
					</form:select>
				</td>
				<td>
					<p class="w-tit">측정기종류</p>
					<form:input path="type" class="input02"/>
				</td>
				<td>
					<p class="w-tit">측정기S/N</p>
					<form:input path="sn" class="input02"/>
				</td>
				<td>
					<p class="w-tit">파일 등록</p>
					<div class="filebox">
						<input class="upload-name" value="${domain.fileName}" placeholder="첨부파일" readonly="">
						<label for="file">파일찾기</label> 
						<form:input id="file" type="file" path="file"/>
					</div>
				</td>
				<td>
					<p class="w-tit">비고</p>
					<form:input path="bigo" class="input02"/>
				</td>
			</tr>
		</table>
		<!--//공지내용-->

		<div class="w-btnArea">			
			<input class="wBtn02" type="submit" value="수정하기" onclick="return formCheck();">
			<input class="wBtn01" type="button" value="뒤로가기" onclick="javascript:goBack();">
		</div>
		</form:form>
	</div>
</div>
<!--//컨텐츠-->

<!-- 팝업 -->
<script>
$('.popUp').hide();
$('.popLayer').hide();

$('.popBtn01').on('click', function(e){
	$('.popUp01').show();
	$('.popLayer').show();
	$('body').css('overflow', 'hidden');
});
$('.popBtn02').on('click', function(e){
	$('.popUp02').show();
	$('.popLayer').show();
	$('body').css('overflow', 'hidden');
});
$('.popBtn03').on('click', function(e){
	$('.popUp03').show();
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
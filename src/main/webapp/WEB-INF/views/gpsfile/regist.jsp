<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/tagLib.jsp" %>
<script type="text/javascript">
	$(document).ready(function() {	
		
		var mgs = '${msg}';
		if(mgs != ''){
			alert(mgs);
		}
		
		$('#file').on('change', function() {
			var files = $(this)[0].files[0];
			var fake = $('.upload-name');
			
			fake.val('');
			if ( files != 'undefined' ) {
				fake.val(files.name);
			}
		});
		
	    $('#submitBtn').click( function() {
	    	$('#searchForm').submit();
	    });
		
	});
	
	function formCheck(){

		return true;
	}
	
	function goBack(){
		location.href='${pageContext.request.contextPath}/gpsfile/list?constructionIdx=${param.constructionIdx}'
	}
	

</script>
<!--컨텐츠-->
<div class="section-right">
	<p class="sub-tit text-center">GPS파일 등록</p>

	<!--공지내용-->
	<div class="min640">
		<form:form method="POST" commandName="domain" enctype="multipart/form-data"  action="${pageContext.request.contextPath}/gpsfile/regist2">
		<table class="notice-write">
			<tr>
				<td>
					<p class="w-tit">파일 등록</p>
					<div class="filebox">
						<input class="upload-name" value="" placeholder="첨부파일" readonly="">
						<label for="file">파일찾기</label> 
						<form:input id="file" type="file" path="file"/>
						<form:hidden path="constructionIdx" value="${param.constructionIdx}"/>
					</div>
				</td>
			</tr>
		</table>
		<!--//공지내용-->

		<div class="w-btnArea">			
			<input class="wBtn02" type="submit" value="등록하기" onclick="return formCheck();">
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
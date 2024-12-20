<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/tagLib.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"> 
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
	<meta name="google" content="notranslate">
	<title>PDAM system</title>
	<meta name="description" content="파일 항타 관입량 자동측정 시스템">
	<meta name="keywords" content="PDAM system">
    <meta property="og:title" content="PDAM system">
	<meta property="og:image" content="${pageContext.request.contextPath}/new/img/kakao.jpg?=v8"> 
	<meta property="og:image:width" content="800">
	<meta property="og:image:height" content="400"> 
	<meta property="og:url" content=""> 
	<meta property="og:site_name" content="PDAM system"> 
	<meta property="og:type" content="website">

	<link href="${pageContext.request.contextPath}/new/css/reset.css" rel="stylesheet" />
	<link href="${pageContext.request.contextPath}/new/css/style.css" rel="stylesheet" media="screen and (min-width:1024px)">
	<link href="${pageContext.request.contextPath}/new/css/responsive.css" rel="stylesheet" media="screen and (max-width:1023px)">
	<script src="${pageContext.request.contextPath}/new/js/jquery-3.6.1.min.js"></script>
	<style type="text/css" media="print">  
	</style>
	<style type="text/css" media="screen and (max-width:1023px)">  
		#divpop0{
	 		display: block;
	 	}
	</style>
</head>
<body>
<script type="text/javascript">
    $( document ).ready(function() {
    	
    	var errorMessage = '${errorMessage}';
    	var length  = '${fn:length(errorMessage)}';
    	if(length > 0 ){
    		$('.logPop').show();
   			$('.popLayer').show();
   			$('body').css('overflow', 'hidden');
    	}else{
    		$('.logPop').hide();
    		$('.popLayer').hide();
    		$('body').css('overflow', 'auto');
    	}
    	
    	
    	//배너 컨트롤
    	var banner = getCookie('divpop0');
    	if(banner == 'Y'){
    		 $("#divpop0").hide();
    	}
    });
    
    function formSubmit(){
    	$('#loginForm').submit();
    }
    
    //닫기 버튼 클릭시
    function closeWin(key)
    {	
        if($("#chkbox0").prop("checked"))
        {
            setCookie('divpop'+key, 'Y' , 1 );
        }
        $("#divpop"+key+"").hide();
    }
 
</script>
    <!-- 팝업개수 3개로 고정 팝업 없으면 주석 대신 display:none처리 할 것/  주석처리하면 쿠키 작동 안함 --> 
	<!-- <div id="divpop0" style=" background-color:#ffffff; position:absolute; left:1%; top:30px; z-index:999999; display: block; border : solid black 1px; width: 800px;">
		
		<div>
			
		</div>
		<table border="0" cellspacing="0" cellpadding="0" background="#330099" align="center">
			<tr style="">
				<td style="text-align: center; width: 100px; padding: 15px;"  colspan="7">
					<font size="6" style="font-weight: bold;">우리기술(주) PDAM시스템(파일 관입량 자동 측정) 사용 만족도 조사</font>
				</td>
			</tr>
			<tr style="">
				<td style=" text-align: left; width: 100px; padding: 15px;" colspan="7">
					우리기술(주)에서는 보다 더 나은 PDAM시스템을 제공하기 위하여 이용자의 고견을 듣고자 하오니, 본 설문에 성실히 응답해 주시면 앞으로 귀하의 의견을 적극 반영하도록 노력하겠습니다. 감사합니다.
				</td>
			</tr>
			<tr style="">
				<td style="  text-align: left; width: 100px; padding: 15px;" colspan="7">
					다음은 PDAM시스템에 대한 질문입니다.(해당하는 점수에 체크 해주세요)
				</td>
			</tr>
			<tr style="border: solid #999999 1px;">
				<td style="border: solid #999999 1px;  text-align: center; width: 100px; padding: 15px;" colspan="2">
					문항
				</td>
				<td style="border: solid #999999 1px; width: 50px; text-align: center;">
					매우<br>
					아니다
				</td>
				<td style="border: solid #999999 1px; width: 50px; text-align: center;">
					아니다
				</td >
				<td style="border: solid #999999 1px; width: 50px; text-align: center;">
					보통
				</td>
				<td style="border: solid #999999 1px; width: 50px; text-align: center;">
					그렇다
				</td >
				<td style="border: solid #999999 1px; width: 50px; text-align: center;">
					매우<br>
					그렇다
				</td >
			</tr>
			<tr style="border: solid #999999 1px;">
				<td style="border: solid #999999 1px;  text-align: center; width: 100px; padding: 15px;" rowspan="6">
					만족도
				</td>
				<td style="border: solid #999999 1px; width: 450px; padding: 15px;">
					1) 사용 방법이 알기 쉽고 간단한가?
				</td>
				<td style="border: solid #999999 1px; width: 50px; text-align: center;">
					<input type="checkbox" name="checkbox1" id="checkbox1">
				</td >
				<td style="border: solid #999999 1px; width: 50px; text-align: center;">
					<input type="checkbox" name="checkbox1" >
				</td >
				<td style="border: solid #999999 1px; width: 50px; text-align: center;">
					<input type="checkbox" name="checkbox1" >
				</td>
				<td style="border: solid #999999 1px; width: 50px; text-align: center;">
					<input type="checkbox" name="checkbox1" >
				</td >
				<td style="border: solid #999999 1px; width: 50px; text-align: center;">
					<input type="checkbox" name="checkbox1" >
				</td >
			</tr>
			<tr style="border: solid #999999 1px;">
				<td style="border: solid #999999 1px; width: 450px; padding: 15px;">
					2) 기자재 및 서버 이용은 만족스러운가?
				</td>
				<td style="border: solid #999999 1px; width: 50px; text-align: center;">
					<input type="checkbox" name="checkbox2" >
				</td >
				<td style="border: solid #999999 1px; width: 50px; text-align: center;">
					<input type="checkbox" name="checkbox2" >
				</td >
				<td style="border: solid #999999 1px; width: 50px; text-align: center;">
					<input type="checkbox" name="checkbox2" >
				</td>
				<td style="border: solid #999999 1px; width: 50px; text-align: center;">
					<input type="checkbox" name="checkbox2" >
				</td >
				<td style="border: solid #999999 1px; width: 50px; text-align: center;">
					<input type="checkbox" name="checkbox2" >
				</td >
			</tr>
			<tr style="border: solid #999999 1px;">
				<td style="border: solid #999999 1px; width: 450px; padding: 15px;">
					3) PDAM시스템 도입으로 안전사고예방이 가능한가?
				</td>
				<td style="border: solid #999999 1px; width: 50px; text-align: center;">
					<input type="checkbox" name="checkbox3" >
				</td >
				<td style="border: solid #999999 1px; width: 50px; text-align: center;">
					<input type="checkbox" name="checkbox3" >
				</td >
				<td style="border: solid #999999 1px; width: 50px; text-align: center;">
					<input type="checkbox" name="checkbox3" >
				</td>
				<td style="border: solid #999999 1px; width: 50px; text-align: center;">
					<input type="checkbox" name="checkbox3" >
				</td >
				<td style="border: solid #999999 1px; width: 50px; text-align: center;">
					<input type="checkbox" name="checkbox3" >
				</td >
			</tr>
			<tr style="border: solid #999999 1px;">
				<td style="border: solid #999999 1px; width: 450px; padding: 15px;">
					4) PDAM시스템 도입으로 신뢰성 확보시공이 가능한가?
				</td>
				<td style="border: solid #999999 1px; width: 50px; text-align: center;">
					<input type="checkbox" name="checkbox4" >
				</td >
				<td style="border: solid #999999 1px; width: 50px; text-align: center;">
					<input type="checkbox" name="checkbox4" >
				</td >
				<td style="border: solid #999999 1px; width: 50px; text-align: center;">
					<input type="checkbox" name="checkbox4" >
				</td>
				<td style="border: solid #999999 1px; width: 50px; text-align: center;">
					<input type="checkbox" name="checkbox4" >
				</td >
				<td style="border: solid #999999 1px; width: 50px; text-align: center;">
					<input type="checkbox" name="checkbox4" >
				</td >
			</tr>
			<tr style="border: solid #999999 1px;">
				<td style="border: solid #999999 1px; width: 450px; padding: 15px;">
					5) PDAM 시스템을 다음 현장에도 사용하겠는가?
				</td>
				<td style="border: solid #999999 1px; width: 50px; text-align: center;">
					<input type="checkbox" name="checkbox5" >
				</td >
				<td style="border: solid #999999 1px; width: 50px; text-align: center;">
					<input type="checkbox" name="checkbox5" >
				</td >
				<td style="border: solid #999999 1px; width: 50px; text-align: center;">
					<input type="checkbox" name="checkbox5" >
				</td>
				<td style="border: solid #999999 1px; width: 50px; text-align: center;">
					<input type="checkbox" name="checkbox5" >
				</td >
				<td style="border: solid #999999 1px; width: 50px; text-align: center;">
					<input type="checkbox" name="checkbox5" >
				</td >
			</tr>
			<tr style="border: solid #999999 1px;">
				<td style="border: solid #999999 1px; width: 450px; padding: 15px;">
					6) 사용 설명 서비스에 대해 만족하는가?
				</td>
				<td style="border: solid #999999 1px; width: 50px; text-align: center;">
					<input type="checkbox" name="checkbox6" >
				</td >
				<td style="border: solid #999999 1px; width: 50px; text-align: center;">
					<input type="checkbox" name="checkbox6" >
				</td >
				<td style="border: solid #999999 1px; width: 50px; text-align: center;">
					<input type="checkbox" name="checkbox6" >
				</td>
				<td style="border: solid #999999 1px; width: 50px; text-align: center;">
					<input type="checkbox" name="checkbox6" >
				</td >
				<td style="border: solid #999999 1px; width: 50px; text-align: center;">
					<input type="checkbox" name="checkbox6" >
				</td >
			</tr>
			<tr style="border: solid #999999 1px;">
				<td style="border: solid #999999 1px;  text-align: center; width: 100px; padding: 15px;">
					만족도
				</td>
				<td style="border: solid #999999 1px;" colspan="6">
					<font style="padding: 15px;">
						7) 우리기술이나 PDAM시스템에 바라는 바를 자유롭게 작성해 주세요.
					<font>
					<br>
					<textarea rows="5" cols="20" style="width: 95%; margin-top: 10px;  margin-bottom: 10px; margin-left: 10px;  margin-right: 10px;" ></textarea>
				</td>
			</tr>
			<tr style="border: solid #999999 1px;">
				<td colspan="7" style="text-align: center;">
					<input type="button" value="제출하기" style="margin-top: 10px;  margin-bottom: 10px; margin-left: 10px;  margin-right: 10px;"> 
				</td>
			</tr>
			<tr>
				<td align="right" bgcolor="#333333" width="100%" height="30" colspan="7" style="padding:0px;">
					<input type="checkbox" name="chkbox0" id="chkbox0" value="checkbox" onFocus="this.blur();" onClick="hideMe(3);">
						<font color="#ffffff" style="font-size:12px;">하루 동안 이 창을 열지 않습니다. <b onClick="javascript:closeWin(0);" style="cursor:pointer;">[닫기]</b>
					</font>&nbsp;
				</td>
			</tr>
		</table> 
	</div>  -->
	
	<div id="warp">
		<div class="loginArea">
			<div class="leftBg">
				<img class="loginLogo" src="${pageContext.request.contextPath}/new/img/loginLogo.png" />
				<!-- <div>
					<p class="p1">파일 항타 관입량 자동측정 시스템</p>
					<p class="p2"><span>Pile Driving</span>  Automatic Measurement system</p>
					<p class="p3">우리기술 (주)</p>
				</div> -->
			</div>
			<div class="rightForm">
				<div>
					<p class="s1">Welcome to <span>PDAM</span></p>

					<!-- 입력폼 영역 -->
					<form:form  id="loginForm" action="${pageContext.request.contextPath}/login" commandName="domain" method="POST">
					<div class="loginFrom">
						<div class="inputArea mb-20">
							<p class="inputTxt">아이디</p>
							<div class="iconArea">
								<img src="${pageContext.request.contextPath}/new/img/loginIcon01.png" />
								
								<form:input style="background-color: #ffffff;" path="userId" class="loginInput" placeholder="아이디를 입력하세요." value=""/>
							</div>
						</div>
						<div class="inputArea mb-40">
							<p class="inputTxt">비밀번호</p>
							<div class="iconArea">
								<img src="${pageContext.request.contextPath}/new/img/loginIcon02.png" />
								<form:password style="background-color: #ffffff;" path="password" class="loginInput" placeholder="비밀번호를 입력하세요." value=""  />
							</div>
						</div>
						
						
						<div class="memory">
							<input type="checkbox" name="idsave" id="idsave" value="1" autocomplete="off"><label for="idsave"><span>아이디 저장</span></label>
						</div>
						
					</div>
					
					<div class="loginBtn" id="logAlert">
							<a href="javascript:formSubmit();">로그인</a>

					</div>
					</form:form>
					<!-- //입력폼 영역 -->
				</div>
				
				<div class="downArea">
					<a class="down_login" href="http://www.we8104.co.kr">우리기술 홈페이지</a>
					<a class="down_login02" href="http://www.we8104.co.kr/bbs/sub3_3">자료 다운로드</a>
				</div>
			</div>

			 <div id="logPop" class="logPop">
				<div class="logPop-t">
					<img src="${pageContext.request.contextPath}/new/img/close.png" class="popClose">
				</div>

				<div class="logPop-c">
					<img class="alertIcon" src="${pageContext.request.contextPath}/new/img/alertIcon.png" />

					<p class="pTit"></p>
					<p class="pTxt">${errorMessage}</p>

					<div class="logPopBtn">
						<a href="#" class="bg02">확인</a>
						<a href="#" class="BtnClose bg01">취소</a>
					</div>
				</div>
			</div>
			
			<div class="popLayer"></div>

			
		</div>
		
	</div>
</body>

<script>
$('.logPop').hide();
$('.popLayer').hide();

/* $('#logAlert').on('click', function(e){
	$('.logPop').show();
	$('.popLayer').show();
	$('body').css('overflow', 'hidden');
});
 */
$('.BtnClose, .popClose, .bg02').on('click', function(e){
	$('.logPop').hide();
	$('.popLayer').hide();
	$('body').css('overflow', 'auto');
});
 
 $(".loginInput").on("keyup",function(key){
     if(key.keyCode==13) {
    	 formSubmit();
     }
 });
 
 $(document).ready(function(){
		var key = getCookie("idChk"); //user1
		if(key!=""){
			$("#userId").val(key); 
		}
		 
		if($("#userId").val() != ""){ 
			$("#idsave").attr("checked", true); 
		}
		 
		$("#idsave").change(function(){ 
			if($("#idsave").is(":checked")){ 
				setCookie("idChk", $("#userId").val(), 7); 
			}else{ 
				deleteCookie("idChk");
			}
		});
		 
		$("#userId").keyup(function(){ 
			if($("#idsave").is(":checked")){
				setCookie("idChk", $("#userId").val(), 7); 
			}
		});
	});
	function setCookie(cookieName, value, exdays){
	    var exdate = new Date();
	    exdate.setDate(exdate.getDate() + exdays);
	    var cookieValue = escape(value) + ((exdays==null) ? "" : "; expires=" + exdate.toGMTString());
	    document.cookie = cookieName + "=" + cookieValue;
	}
	 
	function deleteCookie(cookieName){
		var expireDate = new Date();
		expireDate.setDate(expireDate.getDate() - 1);
		document.cookie = cookieName + "= " + "; expires=" + expireDate.toGMTString();
	}
		 
	function getCookie(cookieName) {
		cookieName = cookieName + '=';
		var cookieData = document.cookie;
		var start = cookieData.indexOf(cookieName);
		var cookieValue = '';
		if(start != -1){
			start += cookieName.length;
			var end = cookieData.indexOf(';', start);
			if(end == -1)end = cookieData.length;
			cookieValue = cookieData.substring(start, end);
		}
		return unescape(cookieValue);
	}
</script>

</html>
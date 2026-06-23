<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/tagLib.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
	<!-- head -->
	<tiles:insertAttribute name="head"/>
	<!-- end head -->
</head>
<!-- 페이지인식 -->
<script type="text/javascript">
$(function(){
	
	var menuIndex = ${menuIndex};
	var full_url = $(location).attr('href');
	var urls = full_url.split("?");
	var first_url = urls[0];
	
	if ( first_url.match("construction") || first_url.match("vimmng")) {
		$("#warp").attr('class','company');
    }else if( first_url.match('franchise')){
    	$("#warp").attr('class','franchise');
    }else if( first_url.match('report') || first_url.match('fileinventory')  ||  first_url.match('simple') || first_url.match('trashbin')){
    	$("#warp").attr('class','view');
    }
});

</script>
<body>
	<!--wrap-->
	<div id="warp" class="builder">
		<!-- nav -->
		<tiles:insertAttribute name="nav"/>
		<!-- end nav -->
		<tiles:insertAttribute name="content"/>
	</div>
	<!--wrap end-->
</body>
</html>

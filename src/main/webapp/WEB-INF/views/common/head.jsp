<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<% 
	response.setHeader("Cache-Control","no-store"); 
	response.setHeader("Pragma","no-cache"); 
	response.setDateHeader("Expires",0);
	if (request.getProtocol().equals("HTTP/1.1"))
		response.setHeader("Cache-Control", "no-cache");

	// 정적 리소스 캐시버스팅용 빌드(서버 기동) 시각: 서버 켜진 후 최초 요청 시 1회만 계산해 재사용
	if (application.getAttribute("buildTime") == null) {
		synchronized (application) {
			if (application.getAttribute("buildTime") == null) {
				application.setAttribute("buildTime", System.currentTimeMillis());
			}
		}
	}
%>
	<meta charset="utf-8">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0 user-scalable=no">
	<meta name="google" content="notranslate">
	<title>PDAM system</title>
	<meta name="description" content="���� ��Ÿ ���Է� �ڵ����� �ý���">
	<meta name="keywords" content="PDAM system">
    <meta property="og:title" content="PDAM system">
	<meta property="og:image" content="../img/kakao.jpg?=v8"> 
	<meta property="og:image:width" content="800">
	<meta property="og:image:height" content="400"> 
	<meta property="og:url" content=""> 
	<meta property="og:site_name" content="PDAM system"> 
	<meta property="og:type" content="website">

	<link href="${pageContext.request.contextPath}/new/css/reset.css" rel="stylesheet" />
	<link href="${pageContext.request.contextPath}/new/css/style.css?v=20260805" rel="stylesheet" media="screen and (min-width:1024px)">
	<link href="${pageContext.request.contextPath}/new/css/responsive.css?v=20260805" rel="stylesheet" media="screen and (max-width:1023px)">
	<link href="${pageContext.request.contextPath}/new/css/custom.css?${applicationScope.buildTime}" rel="stylesheet"  rel="stylesheet" media="screen and (min-width:1024px)"/>
	<link href="${pageContext.request.contextPath}/new/css/responsiveCustom.css?${applicationScope.buildTime}" rel="stylesheet"  rel="stylesheet" media="screen and (max-width:1023px)"/>
	<link href="${pageContext.request.contextPath}/new/css/popup.css" rel="stylesheet" />
	
	
	<link href="${pageContext.request.contextPath}/new/css/reset.css" rel="stylesheet" />
	<link href="${pageContext.request.contextPath}/new/css/style.css" rel="stylesheet" media="print">
	<link href="${pageContext.request.contextPath}/new/css/responsive.css?202310241" rel="stylesheet" media="print">
	<link href="${pageContext.request.contextPath}/new/css/customPrint.css202310241123123" rel="stylesheet"  rel="stylesheet" media="print"/>
	<link href="${pageContext.request.contextPath}/new/css/custom.css202310241123123" rel="stylesheet"  rel="stylesheet" media="print"/>
	<link href="${pageContext.request.contextPath}/new/css/responsiveCustomPrint.css202310241123123" rel="stylesheet"  rel="stylesheet" media="print"/>
	<link href="${pageContext.request.contextPath}/new/css/responsiveCustom.css202310241123123" rel="stylesheet"  rel="stylesheet" media="print"/>
	<link href="${pageContext.request.contextPath}/new/css/popup.css" rel="stylesheet" />
	<style>
		.approvalSummaryWrap {
			width: 100% !important;
			max-width: 100% !important;
			overflow-x: auto !important;
			overflow-y: hidden !important;
			box-sizing: border-box;
			-webkit-overflow-scrolling: touch;
		}

		.approvalSummaryTable {
			width: 100% !important;
			min-width: 1200px !important;
			table-layout: fixed !important;
		}

		.approvalSummaryTable th,
		.approvalSummaryTable td {
			width: auto !important;
		}

		.approvalSummaryTable .tdInput {
			width: calc(100% - 10px) !important;
			box-sizing: border-box;
		}

		@media screen and (max-width: 1023px) {
			.approvalSummaryWrap {
				overflow-x: scroll !important;
			}

			.approvalSummaryTable {
				min-width: 800px !important;
			}

			.approvalSummaryWrap::-webkit-scrollbar {
				height: 6px;
			}

			.approvalSummaryWrap::-webkit-scrollbar-thumb {
				background: #999;
				border-radius: 3px;
			}
		}
	</style>
	
	
	<link rel="stylesheet" href="//code.jquery.com/ui/1.13.2/themes/base/jquery-ui.css">
    <link rel="stylesheet" href="/resources/demos/style.css">
	<script src="${pageContext.request.contextPath}/new/js/jquery-3.6.1.min.js"></script>
	<!-- graph -->
	<script src="https://rawgit.com/kottenator/jquery-circle-progress/1.2.2/dist/circle-progress.js"></script>
	<script src="https://cdn.zingchart.com/zingchart.min.js"></script>
	<script  src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.5.0/Chart.min.js"></script>
	<!-- //graph -->
	<script src="https://code.jquery.com/jquery-3.6.0.js"></script>
    <script src="https://code.jquery.com/ui/1.13.2/jquery-ui.js"></script>
	
	<script src="${pageContext.request.contextPath}/js/common.js?${applicationScope.buildTime}"></script>
	<script src="${pageContext.request.contextPath}/js/echarts.js"></script> 
	
	<!-- for dataTable -->
	<script src="https://cdn.datatables.net/v/dt/dt-2.1.3/datatables.min.js"></script>
	<link href="https://cdn.datatables.net/v/dt/dt-2.1.3/datatables.min.css" rel="stylesheet">
	
	<style type="text/css" media="print">  
	    @page{  
	    	size:auto; 
	    	margin : 0mm; 
	    	padding:0mm;  
	    }.warp {
	    	size:auto; margin : 0mm; padding:0mm; 
	    }.section-right {
	    	 margin : 0mm; padding:0mm; 
	    }.sumGrpTb {
	    	visibility: hidden;
	    	display: none
	    }.sumGrpTbMobile {
	    	visibility: hidden;
	    	display: none
	    }.mobileReportTypeDashboard {
	    	visibility: hidden;
	    	display: none
	    }.reportTypeDashboard {
	    	visibility: hidden;
	    	display: none
	    }
	</style>
	
	<!-- <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
	<script src="https://unpkg.com/jspdf@latest/dist/jspdf.umd.min.js"></script> -->
	
	<!-- <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/1.3.2/jspdf.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/2.3.2/jspdf.plugin.autotable.js"></script> -->
	
	<script src="${pageContext.request.contextPath}/new/js/gulim.js"></script> 
	<script src="${pageContext.request.contextPath}/new/js/jspdf.js"></script> 
	<script src="${pageContext.request.contextPath}/new/js/auto_table.js"></script> 
	<script src="https://html2canvas.hertzen.com/dist/html2canvas.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/es6-promise@4/dist/es6-promise.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/es6-promise@4/dist/es6-promise.auto.min.js"></script>
	
	<script src="${pageContext.request.contextPath}/new/js/drbPdf.js?${applicationScope.buildTime}"></script>

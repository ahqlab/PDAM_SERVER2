<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/tagLib.jsp" %>
<script>

</script>
<!--컨텐츠-->
<div class="section-right">
	<div class="TopContArea">
		<div class="titArea">
			<p class="h1Tit">만족도조사 결과 ( 2024-07-04 ~ 진행중 )</p>
		</div>
	</div>
	
	<!--검색된 리스트 10개씩 노출-->
	<div class="surveyResultBox" >
		<div id="survey1" class="surveyResult" style="height:300px;">1</div>
		<div id="survey2" class="surveyResult" style="height:300px;">2</div>
	</div>
	<div class="surveyResultBox" >
		<div id="survey3" class="surveyResult" style="height:300px;">1</div>
		<div id="survey4" class="surveyResult" style="height:300px;">2</div>
	</div>
	<div class="surveyResultBox" >
		<div id="survey5" class="surveyResult" style="height:300px;">1</div>
		<div id="survey4" class="surveyResult" style="height:300px;  visibility: hidden;" >2</div>
	</div>
	
</div>
<!--//컨텐츠-->

<!-- 팝업 -->
<script>
$( document ).ready( function() {
	
	
	jQuery.ajax({
		type : "POST",
		url : "${pageContext.request.contextPath}/survey/result/total",
		dataType : "JSON", // 옵션이므로 JSON으로 받을게 아니면 안써도 됨
		async : false,
		success : function(data) {
			// TODO
			if(data.length > 0){
				$.each(data, function(index, item) {
					var chartDom = document.getElementById('survey' + item.num);
					var myChart = echarts.init(chartDom);
					var option;

					option = {
					  title: {
					    text: item.surveyContent,
					    subtext: '총 설문 인원 : ' + item.totalCnt + '명',
					    left: 'center'
					  },
					  tooltip: {
					    trigger: 'item'
					  },
					  legend: {
					    orient: 'vertical',
					    left: 'left',
					    top : 'middle'
					  },
					  label: {
				          formatter: '{b}: ({d}%)'
				      },
					  series: [
					    {
					      name: '설문인원 : ',
					      type: 'pie',
					      radius: '50%',
					      data: [
					        { value: item.survey1, name: '매우 아니다' ,itemStyle:{color:"#FF0000"} },
					        { value: item.survey2, name: '아니다' ,itemStyle:{color:"#A52A2A"}},
					        { value: item.survey3, name: '보통' ,itemStyle:{color:"#32CD32"}},
					        { value: item.survey4, name: '그렇다' ,itemStyle:{color:"#6495ED"}},
					        { value: item.survey5, name: '매우 그렇다' ,itemStyle:{color:"#0000CD"}}
					      ],
					      emphasis: {
					        itemStyle: {
					          shadowBlur: 10,
					          shadowOffsetX: 0,
					          shadowColor: 'rgba(0, 0, 0, 0.5)'
					        }
					      }
					    }
					  ]
					};
					myChart.setOption(option);
				});
			}
			
		},
		complete : function(data) {
		},
		error : function(xhr, status, error) {
			alert("에러발생");
		}
	});
	
});
</script>

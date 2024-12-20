<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/tagLib.jsp" %>
<script type="text/javascript">

$( document ).ready( function() {
	
});

</script>
<style>
	.conBtn{
		border: 1px; 
		padding-bottom: 5px;
		padding-left: 10px;
		padding-right: 10px;
		padding-top: 5px;
	}.excelBtn{
	
		height: 30px;
	    line-height: 25px;
	    border-radius: 5px;
	    text-align: center;
	    cursor: pointer;
	    margin: 0 auto;
	    display: inline-block;
	    font-size: 14px;
	    width: 100px;
	   	color:white;
    	background-color : #258348;
    	border: 1px solid #258348;
	    margin-left: 5px;
	}
	
</style>
<!--컨텐츠-->
	<div class="section-right">
		<div class="TopContArea">
			<div class="titArea mb-40">
				<p class="h1Tit">작업일보1</p>
				
			</div>
			<!-- <div>
				<table border=1 style="border: 1px solid white; width: 100%; text-align: center; color: white;" >
					<tr>
						<td style="background-color: gray;">1호기</td>
						<td>10공</td>
						<td>150m</td>
						<td>소계</td>
						<td style="background-color: gray;">120공</td>
						<td>1,800m</td>
					</tr>
					<tr>
						<td style="background-color: gray;">&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td style="background-color: gray;">&nbsp;</td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td style="background-color: gray;">&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td style="background-color: gray;">누계</td>
						<td colspan="3"></td>
						<td>10공</td>
						<td>1,800m</td>
					</tr>
				</table>
			</div> -->
		</div>
		<div style="text-align: right;">
			<input class="excelBtn" type="button" value="EXCEL 출력" style="background-color: #258348;">
		</div>
		
		<div style="margin-bottom: 10px;">
			<h3>1. 작업사항</h3>
		</div>
		<div style="display: flex;">
			
			<div style="width: 50%;">
				<div class="tableArea">
					<div class="viewTable viewTable01">
						<div class="tableScroll">
							<div class="viewTable">
								<div style="text-align: right; padding: 5px;">
									<input type="button" value="추가" class="conBtn"/>
									<input type="button" value="삭제" class="conBtn"/>
									<input type="button" value="저장" class="conBtn"/>
								</div>
								<table>
									<thead>
										<tr class="viewTh" style="height: 30px;">
											<th scope="col" style="width: 5%;">&nbsp;</th>
											<th scope="col" style="width: 5%;">순번</th>
											<th scope="col" style="width: 90%;">금일작업내용</th>
										</tr> 
									</thead>
									<tbody>
										<tr>
											<td><input type="checkbox" style="margin: 0; padding: 0;"/></td>
											<td>1</td>
											<td style="text-align: left; padding-left: 20px; padding-right: 20px; "><input type="text" class="tdInput" style="width: 100%;" /></td>
										</tr>
										<tr>
											<td><input type="checkbox" style="margin: 0; padding: 0;"/></td>
											<td>2</td>
											<td style="text-align: left; padding-left: 20px; padding-right: 20px; "><input type="text" class="tdInput" style="width: 100%;" /></td>
										</tr>
										<tr>
											<td><input type="checkbox" style="margin: 0; padding: 0;"/></td>
											<td>3</td>
											<td style="text-align: left; padding-left: 20px; padding-right: 20px; "><input type="text" class="tdInput" style="width: 100%;" /></td>
										</tr>
										<tr>
											<td><input type="checkbox" style="margin: 0; padding: 0;"/></td>
											<td>4</td>
											<td style="text-align: left; padding-left: 20px; padding-right: 20px; "><input type="text" class="tdInput" style="width: 100%;" /></td>
										</tr>
										<tr>
											<td><input type="checkbox" style="margin: 0; padding: 0;"/></td>
											<td>5</td>
											<td style="text-align: left; padding-left: 20px; padding-right: 20px; "><input type="text" class="tdInput" style="width: 100%;" /></td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
					</div>
				</div>
			</div>
			<!--//공지리스트-->
			<!--공지리스트-->
			<div style="width: 50%;">
				<div class="tableArea">
					<div class="viewTable viewTable01">
						<div class="tableScroll">
							<div class="viewTable">
								<div style="text-align: right; padding: 5px;">
									<input type="button" value="추가" class="conBtn"/>
									<input type="button" value="삭제" class="conBtn"/>
									<input type="button" value="저장" class="conBtn"/>
								</div>
								<table>
									<thead>
										<tr class="viewTh" style="height: 30px;">
											<th scope="col" style="width: 5%;">&nbsp;</th>
											<th scope="col" style="width: 5%;">순번</th>
											<th scope="col" style="width: 90%;">명일작업내용</th>
										</tr> 
									</thead>
									<tbody>
										<tr>
											<td><input type="checkbox" style="margin: 0; padding: 0;"/></td>
											<td>1</td>
											<td style="text-align: left; padding-left: 20px; padding-right: 20px; "><input type="text" class="tdInput" style="width: 100%;" /></td>
										</tr>
										<tr>
											<td><input type="checkbox" style="margin: 0; padding: 0;"/></td>
											<td>2</td>
											<td style="text-align: left; padding-left: 20px; padding-right: 20px; "><input type="text" class="tdInput" style="width: 100%;" /></td>
										</tr>
										<tr>
											<td><input type="checkbox" style="margin: 0; padding: 0;"/></td>
											<td>3</td>
											<td style="text-align: left; padding-left: 20px; padding-right: 20px; "><input type="text" class="tdInput" style="width: 100%;" /></td>
										</tr>
										<tr>
											<td><input type="checkbox" style="margin: 0; padding: 0;"/></td>
											<td>4</td>
											<td style="text-align: left; padding-left: 20px; padding-right: 20px; "><input type="text" class="tdInput" style="width: 100%;" /></td>
										</tr>
										<tr>
											<td><input type="checkbox" style="margin: 0; padding: 0;"/></td>
											<td>5</td>
											<td style="text-align: left; padding-left: 20px; padding-right: 20px; "><input type="text" class="tdInput" style="width: 100%;" /></td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
					</div>
				</div>
			</div>
			<!--//공지리스트-->
			
		</div>
		<!-- 두번째줄 -->
		<div style="display: flex; margin-top: 20px;">
			
			<div style="width: 50%;">
				<div class="tableArea">
					<div class="viewTable viewTable01">
						<div class="tableScroll">
							<div class="viewTable">
								<div style="text-align: right; padding: 5px;">
									<input type="button" value="추가" class="conBtn"/>
									<input type="button" value="삭제" class="conBtn"/>
									<input type="button" value="저장" class="conBtn"/>
								</div>
								<table>
									<thead>
										<tr class="viewTh" style="height: 30px;">
											<th scope="col" style="width: 20%;">호기</th>
											<th scope="col" style="width: 20%;">금일작업</th>
											<th scope="col" style="width: 20%;">파일길이</th>
											<th scope="col" style="width: 20%;">총 작업</th>
											<th scope="col" style="width: 20%;">총 파일길이</th>
										</tr> 
									</thead>
									<tbody>
										<tr>
											<td>1호기</td>
											<td>10공</td>
											<td>100m</td>
											<td>120공</td>
											<td>1200m</td>
										</tr>
										<tr>
											<td>2호기</td>
											<td>24공</td>
											<td>240m</td>
											<td>240공</td>
											<td>2400m</td>
										</tr>
										<tr>
											<td>&nbsp;</td>
											<td>&nbsp;</td>
											<td>&nbsp;</td>
											<td>&nbsp;</td>
											<td>&nbsp;</td>
										</tr>
										<tr>
											<td>&nbsp;</td>
											<td>&nbsp;</td>
											<td>&nbsp;</td>
											<td>&nbsp;</td>
											<td>&nbsp;</td>
										</tr>
										<tr>
											<td>&nbsp;</td>
											<td>&nbsp;</td>
											<td>&nbsp;</td>
											<td>&nbsp;</td>
											<td>&nbsp;</td>
										</tr>
										<tr style="background-color: #e6e6e6; height: 49px;">
											<td>합계</td>
											<td></td>
											<td></td>
											<td>360공</td>
											<td>3600m</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
					</div>
				</div>
			</div>
			<!--//공지리스트-->
			<!--공지리스트-->
			<div style="width: 50%; " >
				<div class="tableArea">
					<div class="viewTable viewTable01">
						<div class="tableScroll">
							<div class="viewTable">
								<div style="text-align: right; padding: 5px;">
									<input type="button" value="추가" class="conBtn"/>
									<input type="button" value="삭제" class="conBtn"/>
									<input type="button" value="저장" class="conBtn"/>
								</div>
								<table>
									<thead>
										<tr class="viewTh" style="height: 30px;">
											<th scope="col" style="width: 100%;">특이사항</th>
										</tr> 
									</thead>
									<tbody>
										<tr>
											<td>
												<textarea rows="15" cols="100"></textarea>
											</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
					</div>
				</div>
			</div>
			<!--//공지리스트-->
			
		</div>
		
		
		
	</div>
	
	
<!-- //팝업 -->
<script>
$(document).ready(function() {
	
});
</script>
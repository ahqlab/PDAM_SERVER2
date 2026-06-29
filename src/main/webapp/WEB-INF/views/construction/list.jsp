<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/tagLib.jsp" %>
<script type="text/javascript">
$(function(){
	var menuIndex = ${menuIndex};
	var full_url = $(location).attr('href');
	var urls = full_url.split("?");
	var last_url = urls[1];
	//alert('last_url : ' + last_url + " , urls.length : " + urls.length);
	if(urls.length == 1){
		//alert('전체 협력사를 타고 들어온경우');
	}
	if(urls.length == 2){
		if (last_url.match("fcIdx")) {
			//가맹점 타고 들어온 경우
			//alert('가맹점 타고 들어온 경우');
			setGamengName();
		}else if(last_url.match("groupIdx")){
			//시공사를 타고 들어온 경우
			//alert('시공사를 타고 들어온 경우');
			setGroupName();
		}
	}
});

function setGamengName(){
	<c:choose>
	    <c:when test="${not empty param.fcIdx}">
	    var fcIdx = ${param.fcIdx};
	    </c:when>
	    <c:otherwise>
	    var	fcIdx = 0;
	    </c:otherwise>
	</c:choose>
	
	jQuery.ajax({
		type : "POST",
		contentType: "application/x-www-form-urlencoded; charset=UTF-8",
		url : "${pageContext.request.contextPath}/franchise/get/name",
		data: {
			fcIdx : fcIdx
		}, 
		success : function(data) {
			$('#listTitle').text(data + " 협력사 리스트");
		},
		complete : function(data) {
		},
		error : function(xhr, status, error) {
		}
	}); 
}

function setGroupName(){
	
	<c:choose>
	    <c:when test="${not empty param.groupIdx}">
	    var	groupIdx = ${param.groupIdx};
	    </c:when>
	    <c:otherwise>
	    var	groupIdx = 0;
	    </c:otherwise>
	</c:choose>
	
	jQuery.ajax({
		type : "POST",
		contentType: "application/x-www-form-urlencoded; charset=UTF-8",
		url : "${pageContext.request.contextPath}/group/get/name",
		data: {
			groupIdx : groupIdx
		}, 
		success : function(data) {
			$('#listTitle').text(data + " 협력사 리스트");
		},
		complete : function(data) {
		},
		error : function(xhr, status, error) {
		}
	}); 
}
</script>
<style>
.postit {
    border: 1px solid gray;
    font-size: 16px;
    width: 250px;
    min-height : 100px;
    display: block;
    position: relative;
    cursor: pointer;
    background-color: #FFE699;
    color: black;
    padding-top: 5px;
    overflow: hidden;
}

.postit .memoRow {
    padding: 5px;
    border-bottom: 1px solid gray;
    word-break: break-all;
}.postit .memoRow p{
   font-size: 12px;
}.postit .memoContent:hover{
	color:blue;
	text-decoration: underline;
}.postit:hover::before {
    border-bottom: 15px solid dodgerblue;
}.postit img{
	width: 20px;
	height: 20px;
}.postit img:hover{
	width: 25px;
	height: 25px;
}
.postit::before {
    content: '';
    position: absolute;
    bottom: 0;
    right: 0;
    width: 0;
    border-bottom: 15px solid gray;
    border-left: 15px solid rgba(0, 0, 0, 0);
}

.actionGrid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 6px;
    width: 100%;
    box-sizing: border-box;
}
.actionBtn {
    display: flex;
    flex-direction: row;
    align-items: center;
    justify-content: center;
    gap: 8px;
    min-height: 38px;
    padding: 6px;
    border-radius: 8px;
    font-size: 14px;
    font-weight: 600;
    text-decoration: none;
    box-sizing: border-box;
    text-align: center;
    cursor: pointer;
}
.actionBtn .btnLabel {
    display: flex;
    align-items: center;
    gap: 6px;
    white-space: nowrap;
}
.actionBtn img {
    width: 16px;
    height: 16px;
    flex-shrink: 0;
}
.actionBtn .btnIcon {
    font-size: 14px;
    line-height: 1;
}
.actionBtn.full {
    grid-column: 1 / -1;
}
.actionBtn.c-device { background: #077b9c; color: #fff; }
.actionBtn.c-device img { filter: brightness(10); }
.actionBtn.c-info { background: #337ab7; color: #fff; }
.actionBtn.c-info img { filter: brightness(10); }
.actionBtn.c-memo { background: #FFE699; color: #333; }
.actionBtn.c-contract { background: #004058; color: #fff; }
.actionBtn.c-contract img { filter: brightness(10); }
.actionBtn.c-block { background: #888; color: #fff; }
.actionBtn.c-block.on { background: #d9534f; }
.actionBtn.c-block img { filter: brightness(10); }

.actionBadge {
    font-size: 12px;
    line-height: 1.6;
    padding: 2px 8px;
    border-radius: 8px;
    font-weight: 700;
    white-space: nowrap;
}
.actionBadge.green { background: #28a745; color: #fff; }
.actionBadge.orange { background: #f0ad4e; color: #333; }
.actionBadge.gray { background: #ccc; color: #333; }
.actionBadge.red { background: #d9534f; color: #fff; }
.actionBadge.ivory { background: #FFF8E7; color: #333; }

/* 협력사 카드 (관리자) - 4분할 가로 배치 */
.company .listArea .listUl li.ccard {
    display: flex;
    align-items: stretch;
    gap: 20px;
}
.listArea .listUl li.ccard:hover {
    background: #fff !important;
    box-shadow: 0 4px 16px rgb(0 0 0 / 12%);
}
.listArea .listUl.two li.ccard:nth-of-type(even) {
    background: #fff;
}
.ccard-headWrap,
.ccard-infoArea,
.ccard-actionArea {
    flex: 1 1 0;
    min-width: 0;
}
.ccard-headWrap {
    flex: 0 0 50%;
    max-width: 50%;
    display: flex;
    align-items: stretch;
    gap: 20px;
    padding-right: 20px;
    border-right: 1px solid #f0f0f0;
    box-sizing: border-box;
}
.ccard-head {
    flex: 0 1 auto;
    min-width: 0;
}
.ccard .postit {
    flex: 0 0 240px;
    min-width: 160px;
}
.ccard-infoArea,
.ccard-actionArea {
    flex: 0 1 25%;
}
.ccard-infoArea {
    padding-right: 20px;
    border-right: 1px solid #f0f0f0;
}
.ccard-head {
    display: flex;
    flex-direction: column;
    justify-content: center;
    gap: 8px;
}
.ccard-name {
    font-size: 22px;
    font-weight: 700;
    color: #077b9c;
    text-decoration: underline;
}
.ccard-date {
    align-self: flex-start;
    font-size: 14px;
    color: #888;
    background: #f5f5f5;
    padding: 3px 12px;
    border-radius: 10px;
}
.ccard-addr {
    font-size: 16px;
    color: #777;
    margin: 0;
}
.ccard .postit {
    width: auto;
    min-height: 0;
    max-height: 150px;
    overflow-y: auto;
    margin: 0;
    box-sizing: border-box;
}
.ccard-infoArea {
    display: grid;
    grid-template-columns: 7fr 3fr;
    gap: 10px 20px;
    align-content: center;
}
.ccard-infoCell {
    display: flex;
    flex-direction: column;
    gap: 6px;
    min-width: 0;
}
.ccard-infoTitle {
    font-size: 17px;
    font-weight: 700;
    color: #333;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}
.ccard-infoSub {
    display: inline-flex;
    align-items: center;
    gap: 5px;
    font-size: 16px;
    color: #555;
}
.ccard-infoSub.strong {
    font-size: 15px;
    font-weight: 400;
    color: #333;
}
.ccard-infoSub img {
    width: 16px;
    height: 16px;
}
.ccard-infoDivider {
    grid-column: 1 / -1;
    border-top: 1px dashed #e5e5e5;
}
.ccard-actionArea {
    display: flex;
    flex-direction: column;
    gap: 8px;
}
.company .listArea .listUl li.ccard .ccard-select select.state {
    width: 100%;
    height: 38px;
    line-height: 36px;
    padding: 0 10px;
    border: 1px solid #ccc;
    border-radius: 8px;
    font-size: 16px;
    text-align: center;
    text-align-last: center;
    color: #333;
    cursor: pointer;
    background: #fff;
    box-sizing: border-box;
}
@media (max-width: 1400px) {
    .company .listArea .listUl li.ccard {
        flex-wrap: wrap;
    }
    .ccard-headWrap,
    .ccard-infoArea,
    .ccard-actionArea {
        flex: 1 1 100%;
        max-width: 100%;
        min-width: 0;
        padding-right: 0;
        padding-bottom: 14px;
        border-right: none;
        border-bottom: 1px solid #f0f0f0;
    }
    .ccard-headWrap {
        flex-direction: column;
        gap: 14px;
    }
    .ccard .postit {
        flex: 0 1 auto;
        min-width: 0;
    }
    .ccard-actionArea {
        padding-bottom: 0;
        border-bottom: none;
    }
    .company .TopContArea .searchArea {
        flex-wrap: wrap;
        gap: 15px;
    }
    .company .TopContArea .searchArea01,
    .company .TopContArea .searchArea02 {
        width: 100%;
        margin-right: 0;
    }
    .company .TopContArea .searchArea02 .inputDate {
        width: calc(50% - 53px);
    }
}
</style>

		<!--컨텐츠-->
		<div class="section-right" >
			<%@ include file="/WEB-INF/views/common/welcomeMsg.jsp" %>
			<div class="TopContArea" >
				<div class="titArea">
					<p id="listTitle" class="h1Tit">전체 협력사 리스트</p>
					<c:choose>
						<c:when test="${sessionInfo.role == 0 or sessionInfo.role == 3}">
								<div class="popBtn popBtn01">협력사 등록</div>
						</c:when>
					</c:choose>
				</div>
				<!--검색-->
				<form:form id="searchForm" commandName="domainParam" method="POST">
				<div class="searchArea">
					<div class="searchArea01">
						<form:select path="searchField">
		                	<form:option value="name">협력사</form:option>
		                	<form:option value="location">현장명</form:option>
		                    <form:option value="manager">현장 담당자 & 소장</form:option>
		                    <form:option value="address">현장주소</form:option>
		                    <form:option value="groupName">시공사</form:option>
						</form:select>
						<form:input path="searchWord" class="searchin"  placeholder="검색어를 입력하세요."/>
						<form:hidden path="currentPage"/>
						<div class="searchBtn">
							<img id="submitBtn" src="${pageContext.request.contextPath}/new/img/search.png" style="cursor:pointer;" onclick="javascript:submitFun();">
						</div>
					</div>
					<div class="searchArea02">
						<form:input type="text" class="inputDate datepicker" path="startDate" placeholder="시작일"/>
						<span>~</span>
						<form:input type="text" class="inputDate datepicker" path="endDate" placeholder="종료일"/>
						<div class="searchBtn">
							<img src="${pageContext.request.contextPath}/new/img/search_date.png" style="cursor:pointer;" onclick="javascript:submitFun();">
						</div>
					</div>
				</div>
				</form:form>
			</div>
			
			<!--검색된 리스트 5개씩 노출-->
			<div class="listArea">
				<p class="listCount">노출된 <span>${fn:length(domainList)}</span>개의 리스트</p>
				
				<ul class="listUl two">
					<c:forEach var="domain" items="${domainList}"  varStatus="status">
					<c:choose>
						<c:when test="${sessionInfo.role == 0}">
						<li class="ccard">
							<div class="ccard-headWrap">
							<div class="ccard-head">
								<span class="ccard-date">${domain.createDate}</span>
								<a class="ccard-name" href="${pageContext.request.contextPath}/device/list?constructionIdx=${domain.id}">
									<c:choose>
										<c:when test="${sessionInfo.userId eq 'ji2177'}">
											${domain.location}
										</c:when>
										<c:otherwise>
											[${domain.name}] ${domain.location}
										</c:otherwise>
									</c:choose>
								</a>
								<p class="ccard-addr">${domain.address}</p>
							</div>

							<div id="postit" name="postit" class="postit" style="display: none;">
								<input type="hidden" name="constructionIdx" value="${domain.id}">
								<input type="hidden" name="userId" value="${domain.userId}">
								<div name="memoArea">
								</div>
							</div>
							</div>

							<div class="ccard-infoArea">
								<div class="ccard-infoCell">
									<div class="ccard-infoTitle" style="margin: 0px; padding: 0px;">소장 : ${domain.conManager}</div>
									<div class="ccard-infoSub strong">
										<img src="${pageContext.request.contextPath}/new/img/call.png" style="width:10px; height: 10px;" />
										${domain.conContact}
									</div>
								</div>
								<div class="ccard-infoCell">
									<div class="ccard-infoTitle" style="padding-top: 5px;">아이디</div>
									<div class="ccard-infoSub strong">
										<img src="${pageContext.request.contextPath}/new/img/user_icon.png" style="width:10px; height: 10px;"/>${domain.userId}
									</div>
								</div>
								<div class="ccard-infoDivider"></div>
								<div class="ccard-infoCell">
									<div class="ccard-infoTitle">담당 : ${domain.manager}</div>
									<div class="ccard-infoSub strong">
										<img src="${pageContext.request.contextPath}/new/img/call.png" style="width:10px; height: 10px;"/>${domain.contact}
									</div>
								</div>
								<div class="ccard-infoCell">
									<div class="ccard-infoTitle" style="padding-top: 5px;">비밀번호</div>
									<div class="ccard-infoSub strong">
										<img src="${pageContext.request.contextPath}/new/img/password.png" style="width:10px; height: 10px;"/>
										<c:choose>
											<c:when test="${domain.userId == 'admin'}">
												*******
											</c:when>
											<c:otherwise>
												${domain.password}
											</c:otherwise>
										</c:choose>
									</div>
								</div>
							</div>

								<div class="ccard-actionArea">
									<div class="actionGrid">
										<a class="actionBtn c-device" href="javascript:registDeviceInfo('${domain.id}')">
											<span class="btnLabel">
												<img src="${pageContext.request.contextPath}/new/img/machin.png" />
												기기등록
											</span>
										</a>
										<c:choose>
											<c:when test="${domain.settingRequired > 0}">
												<a class="actionBtn c-info" href="${pageContext.request.contextPath}/construction/settings?constructionIdx=${domain.id}">
													<span class="btnLabel">
														<img src="${pageContext.request.contextPath}/new/img/user.png" />
														정보변경
													</span>
												</a>
											</c:when>
											<c:otherwise>
												<a class="actionBtn c-info" href="javascript:getConstructionInfo('${domain.id}','${domain.fcIdx}');">
													<span class="btnLabel">
														<img src="${pageContext.request.contextPath}/new/img/user.png" />
														정보변경
													</span>
												</a>
											</c:otherwise>
										</c:choose>
										<a class="actionBtn c-memo" href="javascript:showMemoPop('${domain.id}', '${domain.userId}', '${status.index}');">
											<span class="btnLabel">
												<img src="${pageContext.request.contextPath}/new/img/memo_icon.png" />
												메모등록
											</span>
										</a>
										<a class="actionBtn c-contract" href="${pageContext.request.contextPath}/contract/manage?constructionIdx=${domain.id}">
											<span class="btnLabel">
												<span class="btnIcon">&#128196;</span>
												계약서 관리
											</span>
											<c:choose>
												<%-- <c:when test="${domain.contractTargetYn == 0}">
													<span class="actionBadge gray">대상아님</span>
												</c:when> --%>
												<c:when test="${domain.contractCount > 0}">
            										<c:choose>
										                <c:when test="${domain.latestContractSignedYn == 1}">
										                    <span class="actionBadge green">서명됨</span>
										                </c:when>
										                <c:otherwise>
										                    <span class="actionBadge ivory">등록됨</span>
										                </c:otherwise>
										            </c:choose>
										        </c:when>
												<c:when test="${domain.contractTargetYn != 0}">
										            <span class="actionBadge orange">미등록</span>
										        </c:when>
											</c:choose>
										</a>
										<a class="actionBtn c-block ${domain.blockedYn == 1 ? 'on' : ''}" href="javascript:toggleBlocked('${domain.id}', ${domain.blockedYn});">
											<span class="btnLabel">
												<img src="${pageContext.request.contextPath}/new/img/alertIcon.png" />
												<c:choose>
													<c:when test="${domain.blockedYn == 1}">이용제한 해제</c:when>
													<c:otherwise>이용제한 설정</c:otherwise>
												</c:choose>
											</span>
											<c:choose>
												<c:when test="${domain.blockedYn == 1}">
													<span class="actionBadge red">제한중</span>
												</c:when>
												<c:otherwise>
													<span class="actionBadge green">정상</span>
												</c:otherwise>
											</c:choose>
										</a>
										<c:if test="${domain.contractCount == 0}">
										<a class="actionBtn c-block ${domain.contractTargetYn == 1 ? 'on' : ''}" href="javascript:toggleContractTarget('${domain.id}', ${domain.contractTargetYn});">
											<span class="btnLabel">
												<img src="${pageContext.request.contextPath}/new/img/alertIcon.png" />
												<c:choose>
													<c:when test="${domain.contractTargetYn == 1}">계약서 적용 해제</c:when>
													<c:otherwise>계약서 적용 대상 지정</c:otherwise>
												</c:choose>
											</span>
											<c:choose>
												<c:when test="${domain.contractTargetYn == 1}">
													<span class="actionBadge green">적용중</span>
												</c:when>
												<c:otherwise>
													<span class="actionBadge gray">미적용</span>
												</c:otherwise>
											</c:choose>
										</a>
										</c:if>
										<div class="selectArea ccard-select">
											<select id="conductSel" class="state" onchange="conductSel('${domain.id}', this.value)">
												<option value="0" ${domain.conduct == 0 ? 'selected="selected"' : '' }>시행</option>
												<option value="1" ${domain.conduct == 1 ? 'selected="selected"' : '' }>종료</option>
											</select>
										</div>
									</div>
								</div>
						</li>
						</c:when>
						<c:otherwise>
					<li>
						
						
						<c:choose>
							<c:when test="${sessionInfo.role == 3}">
								<div class="listLeft">
									<p class="date">${domain.createDate}</p>
									<p class="" style="margin: 0px;">
										[${domain.groupName}] ${domain.name}
									</p>
									<p class="addr" style="font-size: 20px; color: #999999; margin-top: 0px;" >
										<a  class="name" href="${pageContext.request.contextPath}/device/list?constructionIdx=${domain.id}" >
										 ${domain.location}
										</a>
									</p>
									<p class="addr">
										${domain.address} 
									</p>
								</div>
							</c:when>
							<c:otherwise>
								<div class="listLeft">
							<p class="date">${domain.createDate}</p>
							<p class="name">
								<a  class="name" href="${pageContext.request.contextPath}/device/list?constructionIdx=${domain.id}" >
									<c:choose>
										<c:when test="${sessionInfo.userId eq 'ji2177'}">
											${domain.location}
										</c:when>
										<c:otherwise>
											[${domain.name}] ${domain.location}
										</c:otherwise>
									</c:choose>
								</a>
							</p>
							<p class="addr">
								${domain.address} 
							</p>
						</div>
							</c:otherwise>
						</c:choose>
						<c:choose>
							<c:when test="${sessionInfo.role == 0 or sessionInfo.role == 3 }">
								<div id="postit" name="postit" class="postit" style="margin-left: 20px; display: none;">
									<input type="hidden" name="constructionIdx" value="${domain.id}">
									<input type="hidden" name="userId" value="${domain.userId}">
									<div name="memoArea">
									</div>
								</div>
							</c:when>
						</c:choose>	 
						
						<!--  <img src="${pageContext.request.contextPath}/new/img/memo_icon.png" style="width: 20px; height: 20px;" onclick=""/> -->
						<div class="listRight">
							<c:choose>
								<c:when test="${sessionInfo.role == 0}">
									<div class="info" style="width: 280px;">
										<p class="manager" style="width: 280px; ">협력사 소장  : ${domain.conManager} </p>
										<p class="phoneNm">
											<img src="${pageContext.request.contextPath}/new/img/call.png" />
											${domain.conContact}
										</p>
										<p class="manager" style="width: 280px; margin-top: 10px;">협력사 담당  : ${domain.manager}</p>
										<p class="phoneNm">
											<img src="${pageContext.request.contextPath}/new/img/call.png" />
											${domain.contact}
										</p>
									</div>
									<div class="info userInfo" style="width: 140px;">
										<p class="manager" style="width: 140px;">사용자 아이디</p>
										<p class="phoneNm">
											<img src="${pageContext.request.contextPath}/new/img/user_icon.png" style="width: 15px; height: 15px; margin-bottom: 8px;"/>
											${domain.userId}
										</p>
										<p class="manager" style="width: 140px; margin-top: 10px;">비밀번호</p>
										<p class="phoneNm">
											<img src="${pageContext.request.contextPath}/new/img/password.png" style="width: 15px; height: 15px; margin-bottom: 5px;"/>
											<c:choose>
												<c:when test="${domain.userId == 'admin'}">
												    *******
												</c:when>
												<c:otherwise>
													${domain.password}
												</c:otherwise>
											</c:choose>
										</p>
									</div>
								</c:when>
								<c:otherwise>
									<%-- <div class="info">
										<p class="manager">담당자 : ${domain.conManager} (${domain.userId})</p>
										<p class="phoneNm">
											<img src="${pageContext.request.contextPath}/new/img/call.png" />
											${domain.conContact}
										</p>
									</div> --%>
									<div class="info" style="width: 380px;">
										<p class="manager" style="width: 380px; ">협력사 소장  : ${domain.conManager} (${domain.userId})</p>
										<p class="phoneNm">
											<img src="${pageContext.request.contextPath}/new/img/call.png" />
											${domain.conContact}
										</p>
										<p class="manager" style="width: 380px; margin-top: 10px;">협력사 담당  : ${domain.manager}</p>
										<p class="phoneNm">
											<img src="${pageContext.request.contextPath}/new/img/call.png" />
											${domain.contact}
										</p>
									</div>
								</c:otherwise>
							</c:choose>
							
							<c:choose>
								<c:when test="${sessionInfo.role == 0}">
									<div class="actionGrid">
										<a class="actionBtn c-device" href="javascript:registDeviceInfo('${domain.id}')">
											<span class="btnLabel">
												<img src="${pageContext.request.contextPath}/new/img/machin.png" />
												기기등록
											</span>
										</a>
										<c:choose>
											<c:when test="${domain.settingRequired > 0}">
												<a class="actionBtn c-info" href="${pageContext.request.contextPath}/construction/settings?constructionIdx=${domain.id}">
													<span class="btnLabel">
														<img src="${pageContext.request.contextPath}/new/img/user.png" />
														정보변경
													</span>
												</a>
											</c:when>
											<c:otherwise>
												<a class="actionBtn c-info" href="javascript:getConstructionInfo('${domain.id}','${domain.fcIdx}');">
													<span class="btnLabel">
														<img src="${pageContext.request.contextPath}/new/img/user.png" />
														정보변경
													</span>
												</a>
											</c:otherwise>
										</c:choose>
										<a class="actionBtn c-memo" href="javascript:showMemoPop('${domain.id}', '${domain.userId}', '${status.index}');">
											<span class="btnLabel">
												<img src="${pageContext.request.contextPath}/new/img/memo_icon.png" />
												메모등록
											</span>
										</a>
										<a class="actionBtn c-contract" href="${pageContext.request.contextPath}/contract/manage?constructionIdx=${domain.id}">
											<span class="btnLabel">
												<span class="btnIcon">&#128196;</span>
												계약서 관리
											</span>
											<c:choose>
												<c:when test="${domain.contractTargetYn == 0}">
													<span class="actionBadge gray">대상아님</span>
												</c:when>
												<c:when test="${domain.contractCount > 0}">
													<span class="actionBadge green">등록됨</span>
												</c:when>
												<c:otherwise>
													<span class="actionBadge orange">미등록</span>
												</c:otherwise>
											</c:choose>
										</a>
										<a class="actionBtn c-block full ${domain.blockedYn == 1 ? 'on' : ''}" href="javascript:toggleBlocked('${domain.id}', ${domain.blockedYn});">
											<span class="btnLabel">
												<img src="${pageContext.request.contextPath}/new/img/alertIcon.png" />
												<c:choose>
													<c:when test="${domain.blockedYn == 1}">이용제한 해제</c:when>
													<c:otherwise>이용제한 설정</c:otherwise>
												</c:choose>
											</span>
											<c:choose>
												<c:when test="${domain.blockedYn == 1}">
													<span class="actionBadge red">제한중</span>
												</c:when>
												<c:otherwise>
													<span class="actionBadge green">정상</span>
												</c:otherwise>
											</c:choose>
										</a>
										<c:if test="${domain.contractCount == 0}">
										<a class="actionBtn c-block full ${domain.contractTargetYn == 1 ? 'on' : ''}" href="javascript:toggleContractTarget('${domain.id}', ${domain.contractTargetYn});">
											<span class="btnLabel">
												<img src="${pageContext.request.contextPath}/new/img/alertIcon.png" />
												<c:choose>
													<c:when test="${domain.contractTargetYn == 1}">계약서 적용 해제</c:when>
													<c:otherwise>계약서 적용 대상 지정</c:otherwise>
												</c:choose>
											</span>
											<c:choose>
												<c:when test="${domain.contractTargetYn == 1}">
													<span class="actionBadge green">적용중</span>
												</c:when>
												<c:otherwise>
													<span class="actionBadge gray">미적용</span>
												</c:otherwise>
											</c:choose>
										</a>
										</c:if>
									</div>

									<div class="selectArea">
										<select id="conductSel" class="state"  onchange="conductSel('${domain.id}', this.value)">
											<option value="0" ${domain.conduct == 0 ? 'selected="selected"' : '' }>시행</option>
											<option value="1" ${domain.conduct == 1 ? 'selected="selected"' : '' }>종료</option>
										</select>
									</div>
								</c:when>
								<c:when test="${sessionInfo.role == 3}">
									<div class="BtnArea">
										 <a class="changeBtn popBtn04" style="margin-top: 5px; background-color: #FFE699; color:black;" href="javascript:showMemoPop('${domain.id}', '${domain.userId}', '${status.index}');">
												<img src="${pageContext.request.contextPath}/new/img/memo_icon.png" style="width: 17px; height: 17px;"/>
												메모 등록하기
										</a>
									</div>
								</c:when>
							</c:choose>
						</div>
					</li>
					</c:otherwise>
					</c:choose>
					</c:forEach>
				</ul>
			</div>
			<!--//검색된 리스트 5개씩 노출-->

			<!--페이징-->			
			<%@ include file="/WEB-INF/views/common/pagination.jsp" %>
			<!--//페이징-->

			<!--협력사 등록 팝업 popUp01-->
			<form id="regForm" name="regForm" method="POST">
			<div class="popUp popUp01">
				<div class="popTit">
					<p>협력사 등록</p>
					<img class="popClose" src="${pageContext.request.contextPath}/new/img/popclose.png" />
				</div>
				
				<div class="popCont">
					<c:choose>
					    <c:when test="${not empty param.fcIdx}">
					   	<div class="inputArea02 mb-20">
							<p class="inputTxt02">가맹점 & 협약업체</p>
							<select id="fcIdx" class="Input02"  name="fcIdx">
							</select>
						</div>
					    </c:when>
					</c:choose>
					<div class="inputArea02 mb-20">
						<p class="inputTxt02">시공사</p>
						<input type="text"  autocomplete="off" class="Input02" id="groupName" name="groupName" placeholder="시공사를 선택하세요." onclick="javascript:openPop();">
						<input type="hidden" id="groupIdx" name="groupIdx" class="Input02"/>
					</div>
					<div class="inputArea02 mb-20">
						<p class="inputTxt02">협력사명</p>
						<input type="text" autocomplete="off" class="Input02" id="name" name="name"  placeholder="협력사명을 입력하세요.">
						
					</div>
					<div class="inputArea02 mb-20">
						<p class="inputTxt02">현장명</p>
						<input type="text" autocomplete="off" class="Input02" id="location"  name="location"  placeholder="현장명을 입력하세요.">
					</div>
					<div class="inputArea02 mb-20">
						<p class="inputTxt02">현장주소</p>
						<input type="text" autocomplete="off" class="Input02" id="address"  name="address"  placeholder="현장주소를 입력하세요.">
					</div>
					<div class="inputArea02 mb-20">
						<p class="inputTxt02">협력사 소장</p>
						<input type="text" autocomplete="off" class="Input02" id="conManager"  name="conManager"  placeholder="협력사 소장 이름을 입력하세요.">
					</div>
					<div class="inputArea02 mb-20">
						<p class="inputTxt02">소장 연락처</p>
						<input type="text" autocomplete="off" class="Input02" id="conContact"  name="conContact"  placeholder="협력사 소장 연락처를 입력하세요.">
					</div>
					<div class="inputArea02 mb-20">
						<p class="inputTxt02">담당자</p>
						<input type="text" autocomplete="off" class="Input02" id="manager"  name="manager"  placeholder="협력사 담당자 이름을 입력하세요.">
					</div>
					<div class="inputArea02 mb-20">
						<p class="inputTxt02">담당자 연락처</p>
						<input type="text" autocomplete="off" class="Input02" id="contact"  name="contact"  placeholder="협력사 담당자 연락처를 입력하세요.">
					</div>
					<div class="inputArea02 mb-20">
						<p class="inputTxt02">아이디</p>
						<div class="w100">
							<input type="text" autocomplete="off" class="Input02" id="userId"  name="userId" autocomplete="off" placeholder="아이디를 입력하세요.">
							<div class="confirmBtn" onclick="javascript:duplicateContactCheck();">중복확인</div>
							<input type="hidden" id="isDuplicate" name="isDuplicate" value="false">
						</div>
					</div>
					<div class="inputArea02 mb-20">
						<p class="inputTxt02">비밀번호</p>
						<input type="password"  autocomplete="new-password" class="Input02" id="password"  name="password" placeholder="비밀번호를 입력하세요.">
					</div>
					<div class="inputArea02 mb-20">
						<p class="inputTxt02">비밀번호 확인</p>
						<input type="password" autocomplete="new-password" class="Input02" id="confirmPassword"   name="confirmPassword"  placeholder="비밀번호를 다시 입력하세요.">
					</div>
					<div class="inputArea02 mb-20">
						<p class="inputTxt02">보안코드</p>
						<input type="text" autocomplete="off" class="Input02" id="secretCode"  name="secretCode"  placeholder="보안코드를 입력하세요.">
					</div>
					<div class="inputArea02 mb-20">
						<p class="inputTxt02">시간출력여부</p>
						<select class="Input02"  id="longCalYn" name="longCalYn">
							<option value="0">N</option>
							<option value="1">Y</option>
						</select>
					</div>
					<div class="inputArea02 mb-20">
						<p class="inputTxt02">극한출력여부</p>
						<select class="Input02" id="ubcYn" name="ubcYn">
							<option value="0">N</option>
							<option value="1">Y</option>
						</select>
					</div>	
					<div class="inputArea02 mb-20">
						<p class="inputTxt02">원데이터제공</p>
						<select class="Input02" id="originDataYn" name="originDataYn">
							<option value="0">N</option>
							<option value="1">Y</option>
						</select>
					</div>	
					<div class="inputArea02 mb-20">
						<p class="inputTxt02">기록지PDF여부</p>
						<select class="Input02" id="showPdfYn" name="showPdfYn">
							<option value="0">모두숨김</option>
							<option value="1">수정모드</option>
							<option value="2">수정모드 + 일반모드</option>
						</select>
					</div>	
					<div class="popAdd" onclick="javascript:conRegistFormCheck();" >등록</div>
				</div>
				
			</div>
			</form>
			<!--//협력사 등록 팝업 popUp01-->

			<!--기기 등록 팝업 popUp02-->
			<form id="deviceRegistForm" name="deviceRegistForm" method="POST">
			<div class="popUp popUp02">
				<div class="popTit">
					<p>기기 등록</p>
					<img class="popClose" src="${pageContext.request.contextPath}/new/img/popclose.png" />
				</div>
				<div class="popCont">
					<div class="inputArea02 mb-20">
						<p class="inputTxt02">협력사</p>
						<c:choose>
							<c:when test="${sessionInfo.role gt 0}">
								<input type="text" autocomplete="off" disabled="disabled" class="Input02" id="constructionName" name="constructionName" >
								<input type="hidden" id="constructionIdx" name="constructionIdx">
							</c:when>
							<c:otherwise>
								<select id="constructionIdx" name="constructionIdx" class="Input02"  disabled="disabled" >
								</select>
							</c:otherwise>
						</c:choose>
					</div>
					<div class="inputArea02 mb-20">
						<p class="inputTxt02">PDAM 태블릿 번호</p>
						<div class="w100">
							<input type="text" autocomplete="off" class="Input02" id="tabletNo" name="tabletNo"   placeholder="태블릿 번호를 입력하세요." onkeypress="javascript:pressContact();">
							<input type="hidden" id="isDuplicate" name="isDuplicate" value="false">
							<div class="confirmBtn" onclick="javascript:duplicateDevideContactCheck();">중복확인</div>
						</div>
					</div>
					<div class="inputArea02 mb-20">
						<p class="inputTxt02">호기번호</p>
						<input type="text"  autocomplete="off" class="Input02" id="machineNumber" name="machineNumber"  autocomplete="off" placeholder="호기번호를 입력하세요.">
					</div>
					<div class="inputArea02 mb-20">
						<p class="inputTxt02">블루투스 No</p>
						<input type="text"  autocomplete="off" class="Input02" id="bluetoothNo" name="bluetoothNo"   placeholder="블루투스 번호를 입력하세요.">
					</div>
					<div class="inputArea02 mb-20">
						<p class="inputTxt02">자동측정기 S/N</p>
						<input type="text" autocomplete="off" class="Input02" id="lavelNo" name="lavelNo"  placeholder="자동측정기 번호를 입력하세요.">
					</div>
					<div class="inputArea02 mb-20">
						<p class="inputTxt02">유심 NO</p>
						<input type="text" autocomplete="off" class="Input02" id="usimNo" name="usimNo"  placeholder="자동측정기 번호를 입력하세요.">
					</div>
					<div class="inputArea02 mb-20">
						<p class="inputTxt02">WE매니저</p>
						<select id="weManager" name="weManager" class="Input02" onchange="weManagerSel(this.value)">
						</select>
						<input type="text" style="margin-top: 10px;" disabled="disabled" autocomplete="off" class="Input02" id="tabletManager" name="tabletManager" placeholder="WE매니저를 입력하세요.">
					</div>
					<div class="inputArea02 mb-20">
						<p class="inputTxt02">매니저 연락처</p>
						<input type="text" autocomplete="" disabled="disabled" class="Input02" id="weContact" name="weContact" placeholder="매니저 연락처를 입력하세요.">
					</div>
					<div class="inputArea02 mb-20">
						<p class="inputTxt02">비밀번호</p>
						<input type="password" autocomplete="new-password" class="Input02" id="password" name="password"   placeholder="비밀번호를 입력하세요.">
					</div>
					<div class="inputArea02 mb-20">
						<p class="inputTxt02">비밀번호 확인</p>
						<input type="password" autocomplete="new-password" class="Input02" id="confirmPassword" name="confirmPassword"  placeholder="비밀번호를 다시 입력하세요.">
					</div>
					<div class="inputArea02 mb-20">
						<p class="inputTxt02">시작일</p>
						<input type="text" autocomplete="off" class="inputDate datepicker Input02" id="startDateI" name="startDateI" placeholder="시작일을 입력하세요.">
					</div>
					<div class="inputArea02 mb-20">
						<p class="inputTxt02">종료일</p>
						<input type="text" autocomplete="off" class="inputDate datepicker Input02" id="endDateI" name="endDateI" placeholder="종료일을 입력하세요." >
					</div>
					
					<div class="popAdd" onclick="javascript:deviceRegistFormCheck();">등록</div>
				</div>
			</div>
			</form>
			<!--//기기 등록 팝업 popUp02-->

			<!--정보 변경 팝업 popUp03-->
			<form id="updateForm" name="updateForm" method="POST">
			<div class="popUp popUp03">
				<div class="popTit">
					<p>정보 변경</p>
					<img class="popClose" src="${pageContext.request.contextPath}/new/img/popclose.png" />
				</div>
				<div class="popCont">
					<div class="inputArea02 mb-20">
						<p class="inputTxt02">가맹점 & 협약업체</p>
						<select id="fcIdx" class="Input02"  name="fcIdx">
						</select>
						<input type="hidden" name="id">
					</div>
					<div class="inputArea02 mb-20">
						<p class="inputTxt02">시공사</p>
						<input type="text" autocomplete="off"  class="Input02" disabled="disabled"  id="groupName" name="groupName" onclick="javascript:openPop();" placeholder="시공사명을 입력하세요." >
						<input type="hidden" id="groupIdx" name="groupIdx" class="Input02"/>
					</div>
					<div class="inputArea02 mb-20">
						<p class="inputTxt02">협력사명</p>
						<input type="text" autocomplete="off" class="Input02" id="name" name="name" value="" placeholder="협력사명을 입력하세요." >
					</div>
					<div class="inputArea02 mb-20">
						<p class="inputTxt02">현장명</p>
						<input type="text" autocomplete="off" class="Input02" id="location" name="location" value=""  placeholder="현장명을 입력하세요." >
					</div>
					<div class="inputArea02 mb-20">
						<p class="inputTxt02">현장주소</p>
						<input type="text" autocomplete="off" class="Input02" id="address" name="address" value=""  placeholder="현장주소를 입력하세요." >
					</div>
					<div class="inputArea02 mb-20">
						<p class="inputTxt02">협력사 소장</p>
						<input type="text" autocomplete="off" class="Input02" id="conManager"  name="conManager"  placeholder="협력사 소장을 입력하세요.">
					</div>
					<div class="inputArea02 mb-20">
						<p class="inputTxt02">소장 연락처</p>
						<input type="text" autocomplete="off" class="Input02" id="conContact"  name="conContact"  placeholder="협력사 소장 연락처를 입력하세요.">
					</div>
					<div class="inputArea02 mb-20">
						<p class="inputTxt02">담당자</p>
						<input type="text" autocomplete="off" class="Input02" id="manager" name="manager" value=""  placeholder="협력사 담당자 이름을 입력하세요." >
					</div>
					<div class="inputArea02 mb-20">
						<p class="inputTxt02">담당자 연락처</p>
						<input type="text" autocomplete="off" class="Input02" id="contact" name="contact" value=""  placeholder="협력사 담당자 연락처를 입력하세요." >
					</div>
					<div class="inputArea02 mb-20">
						<p class="inputTxt02">아이디</p>
						<input type="text" autocomplete="off" class="Input02" id="userId" name="userId" disabled="disabled"  value=""  placeholder="아이디를 입력하세요." >
					</div>
					<div class="inputArea02 mb-20">
						<p class="inputTxt02">비밀번호</p>
						<input type="password" autocomplete="off" class="Input02" id="password" name="password" value=""  placeholder="비밀번호를 입력하세요." >
					</div>
					<div class="inputArea02 mb-20">
						<p class="inputTxt02">비밀번호 확인</p>
						<input type="password" autocomplete="off" class="Input02" id="confirmPassword" name="confirmPassword" value=""  placeholder="비밀번호를 입력하세요." >
					</div>
					<div class="inputArea02 mb-20">
						<p class="inputTxt02">보안코드</p>
						<input type="text" autocomplete="off" class="Input02" id="secretCode" name="secretCode" value=""  placeholder="보안코드를 입력하세요." >
					</div>
					<div class="inputArea02 mb-20">
						<p class="inputTxt02">시간출력여부</p>
						<select class="Input02" id="longCalYnU" name="longCalYn"name="longCalYn">
							<option value="0">N</option>
							<option value="1">Y</option>
						</select>
					</div>	
					<div class="inputArea02 mb-20">
						<p class="inputTxt02">극한출력여부</p>
						<select class="Input02" id="ubcYn" name="ubcYn">
							<option value="0">N</option>
							<option value="1">Y</option>
						</select>
					</div>	
					<div class="inputArea02 mb-20">
						<p class="inputTxt02">원데이터제공</p>
						<select class="Input02" id="originDataYn" name="originDataYn">
							<option value="0">N</option>
							<option value="1">Y</option>
						</select>
					</div>		
					<div class="inputArea02 mb-20">
						<p class="inputTxt02">기록지PDF여부</p>
						<select class="Input02" id="showPdfYn" name="showPdfYn">
							<option value="0">모두숨김</option>
							<option value="1">수정모드</option>
							<option value="2">수정모드 + 일반모드</option>
						</select>
					</div>	
					<div class="popAdd" onclick="javascript:updateConstruction();" >변경</div>
				</div>
			</div>
			</form>
			<!--//정보 변경 팝업 popUp03-->

			<div class="popLayer"></div>
			</div>
			
			<!--//컨텐츠-->
			<div class="popup_layer" id="popup_layer" style="display: none;">
				<div class="popup_box">
				    <div class="popup_cont">
						<div class="popup_head">
							<div class="popup_text">
								<font size="5">협력사 조회</font>
							</div>
							<div class="popup_close">
								<a href="javascript:closePop();">닫기</a>
							</div>
			  			</div>
				      	<div class="table_list">
							<table class="display" id="ajaxGroupTable"  style="width: 100%;">
							</table>
				        </div>
				    </div>
				</div>
			</div>
			
			<div class="popUp popUp04">
				<div class="popTit">
					<p>메모장</p>
					<img class="popClose" src="${pageContext.request.contextPath}/new/img/popclose.png" />
				</div>
				<div class="popCont">
					<div class="inputArea02 mb-20">
						<p class="inputTxt02">날짜</p>
						<input type="text" autocomplete="off" class="inputDate datepicker Input02" id="memoDate" name="memoDate" placeholder="">
					</div>
					<div class="inputArea02 mb-20">
						<p class="inputTxt02">내용</p>
						<input type="hidden" id="memoId" name="memoId" />
						<input type="hidden" id="memoConstructionIdx" name="memoConstructionIdx" />
						<input type="hidden" id="memoUserId" name="memoUserId" />
						<input type="hidden" id="memoIndex" name="memoIndex" />
						<textarea name="memoContent" id="memoContent" rows="10"  cols="10" style="width: 100%; border:1px #c2c2c2 solid;" ></textarea>
					</div>
					<c:choose>
						<c:when test="${sessionInfo.role == 0 or sessionInfo.role == 3}">
							<div class="popAdd" onclick="javascript:saveMemo();">저장</div>
						</c:when>
					</c:choose>
				</div>
			</div>
			
			
			
<!-- 팝업 -->
<script>

var mode = null;

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
$('.popClose').on('click', function(e){
	$('.popUp').hide();
	$('.popLayer').hide();
	$('body').css('overflow', 'auto');
});

$( function() {
   $(".datepicker").datepicker();
});
  
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
	
	 $('input[type="checkbox"][name="conduct"]').click(function(){          
		 
         if ($(this).prop('checked')) {
             $('input[type="checkbox"][name="conduct"]').prop('checked', false);
             $(this).prop('checked', true);
         }
     });
	 
	 setMemoToday();
	 getMemo();
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

function deleteMemo(id){
	
	var result = confirm("삭제하시겠습니까?");
	if(result){
		jQuery.ajax({
			type : "POST",
			url : "${pageContext.request.contextPath}/memo/deleteAjax",
			data: {
				id : id
			}, 
			dataType : "JSON", // 옵션이므로 JSON으로 받을게 아니면 안써도 됨
			success : function(data) {
				if(data == true){
					alert('삭제되었습니다.');
					setMemoToday();
					getMemo();
				}
			},
			complete : function(data) {
			},
			error : function(xhr, status, error) {
			}
		}); 
		return;
	}
	return;
}

function getMemo(){
	
	var length = $("div[name=postit]").length;
	var role = ${sessionInfo.role};
	
	for (var i = 0; i < length; i++) {
		var constructionIdx = $("div[name=postit]").eq(i).find("input[name=constructionIdx]").val();
		var userId = $("div[name=postit]").eq(i).find("input[name=userId]").val();
		
		console.log('get Memo : ' + constructionIdx);
		
		jQuery.ajax({
			type : "GET",
			data:  {
				constructionIdx : constructionIdx
			},
			url : "${pageContext.request.contextPath}/memo/list",
			dataType : "JSON", // 옵션이므로 JSON으로 받을게 아니면 안써도 됨
			async : false,
			success : function(data) {
				if(data.length > 0){
					$("div[name=postit]").eq(i).css("display","block");

					$("div[name=postit]").eq(i).find("div[name=memoArea]").html("");
					$.each(data, function(index, item) {
						
						if(role == 0 || role == 3){
							$("div[name=postit]").eq(i).find("div[name=memoArea]").append(
									"<div class=\"memoRow\">" +
										"<p class=\"memoDate\">" + item.memoDate +"</p>" + 
										"<a class=\"memoContent\" href=\"javascript:showUpdateMemoPop('" + item.id + "','" + item.constructionIdx + "', '" + item.memoDate + "', '" + item.content + "');\">" + item.content + "<a>" +
										"&nbsp;<a href=\"javascript:deleteMemo('" + item.id + "');\"><img class=\"deleteImg\" src=\"${pageContext.request.contextPath}/new/img/deleteMemo.png\"/><a>" +
									"</div>");
						}else{
							$("div[name=postit]").eq(i).find("div[name=memoArea]").append(
									"<div class=\"memoRow\">" +
										"<p class=\"memoDate\">" + item.memoDate +"</p>" + 
										"<a class=\"memoContent\" href=\"javascript:showUpdateMemoPop('" + item.id + "','" + item.constructionIdx + "', '" + item.memoDate + "', '" + item.content + "');\">" + item.content + "<a>" +
									"</div>");
						}
						
					});
				}else{
					//메모를 지운다.
					$("div[name=postit]").eq(i).css("display","none"); 
				}
			},
			complete : function(data) {
				// 통신이 실패했어도 완료가 되었을 때 이 함수를 타게 된다.
				//$('#ctmIdx').append("<option value=\"0\">선택</option>");
				//alert("서버와 통신에 실패했습니다. 계속 실패할 경우 관리자에게 문의하세요.");
			},
			error : function(xhr, status, error) {
				alert("에러발생 1 ");
			}
		});
	}
	
	 
}

function saveMemo(){
	
	var memoId = $("#memoId").val();
	var userId = $("#memoUserId").val();
	var constructionIdx = $("#memoConstructionIdx").val();
	var index = $("#memoIndex").val();
	
	var myObject = new Object(); 
	myObject.id = new Number(memoId == "" ? 0 : memoId);
	myObject.userId = userId;
	myObject.constructionIdx = new Number(constructionIdx);
	myObject.content = $("#memoContent").val();
	myObject.memoDate = $("#memoDate").val();
	myObject.createDate = '';
	myObject.modifyDate = '';
	
	var myString = JSON.stringify(myObject); 
	
	if(memoId == ""){
		
		jQuery.ajax({
			type : "POST",
			url : "${pageContext.request.contextPath}/memo/registAjax",
		    contentType : "application/json",
			async : false,  // 요청 시 동기화 여부. 기본은 비동기(asynchronous) 요청 (default: true)
			data:  JSON.stringify(myObject),
			success : function(data) {	
				result = data;
			},
			complete : function(data) {
				if(result == 1){
					$('.popUp04').hide();
					$('.popLayer').hide();
					$('body').css('overflow', 'auto');
					$("#memoContent").val("");
					 setMemoToday();
					 //reloadMemo(index);
					 getMemo();
				}
			},
			error : function(xhr, status, error) {
				alert('error');
				$('.popUp04').hide();
				$('.popLayer').hide();
				$('body').css('overflow', 'auto');
			}
		}); 
	}else{
		jQuery.ajax({
			type : "POST",
			url : "${pageContext.request.contextPath}/memo/updateAjax",
		    contentType : "application/json",
			async : false,  // 요청 시 동기화 여부. 기본은 비동기(asynchronous) 요청 (default: true)
			data:  JSON.stringify(myObject),
			success : function(data) {	
				result = data;
			},
			complete : function(data) {
				if(result == 1){
					$('.popUp04').hide();
					$('.popLayer').hide();
					$('body').css('overflow', 'auto');
					$("#memoContent").val("");
					 setMemoToday();
					 getMemo();
				}
			},
			error : function(xhr, status, error) {
				alert('error');
				$('.popUp04').hide();
				$('.popLayer').hide();
				$('body').css('overflow', 'auto');
			}
		}); 
	}
	/**
	
	
	**/
	return;
}

function setMemoToday(){
	
	var today = new Date();   
	var year = today.getFullYear(); // 년도
	var month = (today.getMonth() + 1).toString().padStart(2, '0');
	var date = today.getDate().toString().padStart(2, '0');

	$("#memoDate").val(year + '-' + month + '-' + date);
}

function showUpdateMemoPop(id, constructionIdx,  memoDate, content){
	$("#memoId").val(id);
	$("#memoConstructionIdx").val(constructionIdx);
	$("#memoDate").val(memoDate);
	$("#memoContent").val(content);
	
	$('.popUp04').show();
	$('.popLayer').show();
	$('body').css('overflow', 'hidden');
}

function showMemoPop(constructionIdx, userId, index){
	
	$('.popUp04').show();
	$('.popLayer').show();
	$('body').css('overflow', 'hidden');
	
	$("#memoId").val("");
	$("#memoConstructionIdx").val(constructionIdx);
	$("#memoUserId").val(userId);
	$("#memoIndex").val(index);
	$("#memoContent").val("");
}

function deviceRegistFormCheck(){
	//숫자와 문자 포함 형태의 6~12자리 이내의 암호 정규식
	if($("#deviceRegistForm input[name='constructionIdx']").val() == 0){
		alert('시공사를 선택하세요.');
		return;
	}else if($("#deviceRegistForm input[name='tabletNo']").val() == ''){
		alert('PDAM테블릿 번호를 입력하세요.');
		return;
	}else if($("#deviceRegistForm input[name='machineNumber']").val() == ''){
		alert('호기번호를 입력하세요.');
		return;
	}else if($("#deviceRegistForm input[name='bluetoothNo']").val() == ''){
		alert('블루투스 번호를 입력하세요.');
		return;
	}else if($("#deviceRegistForm input[name='lavelNo']").val() == ''){
		alert('자동특정기 번호를 입력하세요.');
		return;
	}else if($("#deviceRegistForm input[name='tabletManager']").val() == ''){
		alert('WE매니저 이름을 입력하세요.');
		return;
	}else if($("#deviceRegistForm input[name='weContact']").val() == ''){
		alert('매니저 연락처를 입력하세요.');
		return;
	}else if($("#deviceRegistForm input[name='password']").val() == ''){
		alert('비밀번호를 입력하세요.');
		return;
	}else if($("#deviceRegistForm input[name='confirmPassword']").val() == ''){
		alert('확인 비밀번호를 입력하세요.');
		return;
	}else if($("#deviceRegistForm input[name='password']").val().length < 4){
		alert('4자리 이상의 비밀번호를 입력하세요.');
		$("#deviceRegistForm input[name='password']").focus();
		return false;
	}else if($("#deviceRegistForm input[name='confirmPassword']").val().length < 4){
		alert('4자리 이상의 비밀번호를 입력하세요.');
		$("#deviceRegistForm input[name='confirmPassword']").focus();
		return false;
	}else if($("#deviceRegistForm input[name='password']").val() != $("#deviceRegistForm input[name='confirmPassword']").val()){
		alert('비밀번호가 맞지 않습니다. 비밀번호를 확인하세요.');
		return;
	}else if($("#deviceRegistForm input[name='startDateI']").val() == ''){
		alert('시작일을 입력하세요.');
		return;
	}else if($("#deviceRegistForm input[name='endDateI']").val() == ''){
		alert('종료일을 입력하세요.');
		return;
	}else if($("#deviceRegistForm input[name='isDuplicate']").val() == 'false'){
		alert('PDAM테블릿 번호 중복확인을 체크하시기 바랍니다.');
		return;
	}
	$("#deviceRegistForm select[name='constructionIdx'] option").not(":selected").attr("disabled", "");
	$("#deviceRegistForm select[name='constructionIdx']").attr("disabled", "false"); //1.
	$("#deviceRegistForm select[name='constructionIdx']").removeAttr("disabled");  //2.
	
	var myObject = new Object(); 
	myObject.id = new Number(0);
	
	myObject.constructionIdx = new Number($("#deviceRegistForm select[name='constructionIdx'] option:selected").val());//시공사
	myObject.lavelNo = $("#deviceRegistForm input[name='lavelNo']").val();//자동측정기번호    
	myObject.bluetoothNo = $("#deviceRegistForm input[name='bluetoothNo']").val();//블루투스번호
	myObject.tabletNo = $("#deviceRegistForm input[name='tabletNo']").val();//PDAM 테블릿 번호
	myObject.usimNo = $("#deviceRegistForm input[name='usimNo']").val();//PDAM 테블릿 번호
	myObject.password = $("#deviceRegistForm input[name='password']").val();//비밀번호
	myObject.tabletManager = $("#deviceRegistForm input[name='tabletManager']").val();//우리시스템 매니저
	myObject.weContact= $("#deviceRegistForm input[name='weContact']").val();//우리시스템 매니저 연락처
	myObject.startDate= $("#deviceRegistForm input[name='startDateI']").val();//시작일 
	myObject.endDate= $("#deviceRegistForm input[name='endDateI']").val();//종료일
	myObject.machineNumber= $("#deviceRegistForm input[name='machineNumber']").val();//호기
	myObject.name= '';
	myObject.conduct = new Number(0);//사업시행여부
	myObject.totalCnt = new Number(0);//총 시공수량
	myObject.todayCnt = new Number(0);//금일 시공수량
	myObject.yesterdayCnt = new Number(0);//하루전 시공수량
	
	var myString = JSON.stringify(myObject); 
	jQuery.ajax({
		type : "POST",
		url : "${pageContext.request.contextPath}/device/registAjax",
	    contentType : "application/json",
		async : false,  // 요청 시 동기화 여부. 기본은 비동기(asynchronous) 요청 (default: true)
		data:  JSON.stringify(myObject),
		success : function(data) {	
			result = data;
		},
		complete : function(data) {
			if(result == 1){
				$('.popUp').hide();
				$('.popLayer').hide();
				$('body').css('overflow', 'auto');
				$('#searchForm').submit();
			}
		},
		error : function(xhr, status, error) {
			alert('error');
			$('.popUp').hide();
			$('.popLayer').hide();
			$('body').css('overflow', 'auto');
		}
	}); 
	return;
}

function pressContact(){
	$("#deviceRegistForm input[name='isDuplicate']").val("false");
}

function duplicateDevideContactCheck(){
	
	if($("#deviceRegistForm input[name='tabletNo']").val() == ''){
		alert('PDAM테블릿 번호를 입력하세요.');
		$("#deviceRegistForm input[name='tabletNo']").focus();
	} else {
		//연락처가 입력되었음.
		jQuery.ajax({
			type : "POST",
			url : "${pageContext.request.contextPath}/device/duplicate/tabletNo/confirm",
			data: { tabletNo: $("#deviceRegistForm input[name='tabletNo']").val() }, 
			dataType : "JSON", // 옵션이므로 JSON으로 받을게 아니면 안써도 됨
			success : function(data) {
				if(data.length > 0){
					alert("이미 등록된 PDAM테블릿 번호입니다.");
				}else{
					$("#deviceRegistForm input[name='isDuplicate']").val("true");
					alert("사용가능한 PDAM테블릿 번호입니다.");
				}
			},
			complete : function(data) {
			},
			error : function(xhr, status, error) {
			}
		});
	}
}

function openRegDevicePop(){
	$('.popUp02').show();
	$('.popLayer').show();
	$('body').css('overflow', 'hidden')
}

function registDeviceInfo(constructionIdx){
	openRegDevicePop();
	jQuery.ajax({
		type : "GET",
		url : "${pageContext.request.contextPath}/construction/get/list",
		dataType : "JSON", // 옵션이므로 JSON으로 받을게 아니면 안써도 됨
		success : function(data) {
			// 통신이 성공적으로 이루어졌을 때 이 함수를 타게 된다.
			// TODO
			if(data.length > 0){
				var role = ${sessionInfo.role};
				if(role > 0){
					$.each(data, function(index, item) {
						$("#deviceRegistForm input[name='constructionName']").val(item.name);
						$("#deviceRegistForm input[name='constructionIdx']").val(item.id);
					});
				}else{
					$("#deviceRegistForm select[name='constructionIdx']").append("<option value=\"0\">선택</option>");
					//$('#constructionIdx').append("<option value=\"0\">선택</option>");
					$.each(data, function(index, item) {
						/* $('#constructionIdx').append("<option value='" + item.id + "'>"+ item.name + "</option>"); */
						var idx = constructionIdx;
						if(item.id == idx){
							$("#deviceRegistForm select[name='constructionIdx']").append("<option selected=\"selected\" value='" + item.id + "'>"+ item.name + "</option>");
						}else{
							$("#deviceRegistForm select[name='constructionIdx']").append("<option value='" + item.id + "'>"+ item.name + "</option>");
						}
					});
				}
				
			}
			
		},
		complete : function(data) {
			// 통신이 실패했어도 완료가 되었을 때 이 함수를 타게 된다.
			//$('#ctmIdx').append("<option value=\"0\">선택</option>");
			//alert("서버와 통신에 실패했습니다. 계속 실패할 경우 관리자에게 문의하세요.");
		},
		error : function(xhr, status, error) {
			$("#deviceRegistForm select[name='constructionIdx']").append("<option value=\"0\">선택</option>");
			alert("에러발생");
		}
	});
	
	
	
	jQuery.ajax({
		type : "GET",
		url : "${pageContext.request.contextPath}/wemanager/get/list",
		dataType : "JSON", // 옵션이므로 JSON으로 받을게 아니면 안써도 됨
		success : function(data) {
			
			$("#deviceRegistForm input[name='tabletManager']").attr("disabled", true);  
			$("#deviceRegistForm input[name='weContact']").attr("disabled", true);  
			
			$("#deviceRegistForm select[name='weManager'] option").remove();  
			if(data.length > 0){
				$("#deviceRegistForm select[name='weManager']").append("<option value=\"\">선택</option>");
				$.each(data, function(index, item) {
					$("#deviceRegistForm select[name='weManager']").append("<option value='" + item.phone + '|' + item.name + " " + item.position + "'>"+ item.name + " " + item.position + "</option>");
				});
				$("#deviceRegistForm select[name='weManager']").append("<option value='직접입력'>직접입력</option>");
			}
		},
		complete : function(data) {
		},
		error : function(xhr, status, error) {
			alert("에러발생");
		}
	});
}
function weManagerSel(value)
{
	$("#deviceRegistForm input[name='tabletManager']").val("");  
	$("#deviceRegistForm input[name='weContact']").val("");  
	if(value == '직접입력'){
		$("#deviceRegistForm input[name='tabletManager']").attr("disabled", false);  
		$("#deviceRegistForm input[name='weContact']").attr("disabled", false);  
		$("#deviceRegistForm input[name='tabletManager']").focus();
	}else{
		var info = value.split("|"); 
		$("#deviceRegistForm input[name='tabletManager']").val(info[1]);  
		$("#deviceRegistForm input[name='weContact']").val(info[0]);  
		$("#deviceRegistForm input[name='tabletManager']").attr("disabled", true);  
		$("#deviceRegistForm input[name='weContact']").attr("disabled", true); 
	}
}

function devieGetDevice(constructionIdx){
	
	
}
//협력사등록
function conRegistFormCheck(){

	if($("#regForm input[name='groupIdx']").val() == ''){
		alert('시공사를 선택하세요.');
		return;
	}else if($("#regForm input[name='name']").val() == ''){
		alert('협력사명을 입력하세요.');
		$("#regForm input[name='name']").focus();
		return;
	}else if($("#regForm input[name='location']").val() == ''){
		alert('현장명을 입력하세요.');
		$("#regForm input[name='location']").focus();
		return;
	}else if($("#regForm input[name='address']").val() == ''){
		alert('현장주소를 입력하세요.');
		$("#regForm input[name='address']").focus();
		return;
	/* }else if($("#regForm input[name='conManager']").val() == ''){
		alert('협력사 소장 이름를 입력하세요.');
		$("#regForm input[name='conManager']").focus();
		return;
	}else if($("#regForm input[name='conContact']").val() == ''){
		alert('협력사 소장 연락처를 입력하세요.');
		$("#regForm input[name='conContact']").focus();
		return; 
	}else if($("#regForm input[name='manager']").val() == ''){
		alert('협력사 담당자 이름를 입력하세요.');
		$("#regForm input[name='manager']").focus();
		return;
	}else if($("#regForm input[name='contact']").val() == ''){
		alert('협력사 담당자 연락처를 입력하세요.');
		$("#regForm input[name='contact']").focus();
		return;	
	}*/
	
	
	}else if($("#regForm input[name='userId']").val() == ''){
		alert('아이디를 입력하세요.');
		$("#regForm input[name='userId']").focus();
		return;
	}else if($("#regForm input[name='password']").val() == ''){
		alert('비밀번호를 입력하세요.');
		$("#regForm input[name='password']").focus();
		return;
	}else if($("#regForm input[name='isDuplicate']").val() == 'false'){
		alert('아이디 중복확인을 체크하시기 바랍니다.');
		return;
	}
	
	if($("#regForm input[name='password']").val() != '' && $("#regForm input[name='confirmPassword']").val() != '' ){
		//비밀번호가 입력되었다면
		if($("#regForm input[name='password']").val().length < 4){
			alert('4자리 이상의 비밀번호를 입력하세요.');
			$("#regForm input[name='password']").focus();
			return;
		}else if($("#regForm input[name='confirmPassword']").val().length < 4){
			alert('4자리 이상의 비밀번호를 입력하세요.');
			$("#regForm input[name='confirmPassword']").focus();
			return;
		}else if($("#regForm input[name='password']").val() != $("#regForm input[name='confirmPassword']").val()){
			alert('비밀번호를 다름니다. 비밀번호를 확인하세요.');
			$("#regForm input[name='confirmPassword']").focus();
			return;
		}
	}else{
		if($("#regForm input[name='password']").val() != ''){
			alert('비밀번호를 입력하세요.');
			$("#regForm input[name='password']").focus();
			return;
		}else if($("#regForm input[name='confirmPassword']").val() != ''){
			alert('확인 비밀번호를 입력하세요.');
			$("#regForm input[name='confirmPassword']").focus();
			return;
		}
	}
	registConstruction();
}

function registConstruction(){
	//var fcIdx = ${domainParam.fcIdx};
	var myObject = new Object(); 
	myObject.id = new Number(0);
	myObject.role = new Number(0);
	myObject.name = $("#regForm input[name='name']").val();
	myObject.location = $("#regForm input[name='location']").val();
	myObject.address = $("#regForm input[name='address']").val();
	myObject.conManager = $("#regForm input[name='conManager']").val();
	myObject.conContact = $("#regForm input[name='conContact']").val();
	myObject.manager = $("#regForm input[name='manager']").val();
	myObject.contact = $("#regForm input[name='contact']").val();
	myObject.userId = $("#regForm input[name='userId']").val();
	myObject.password = $("#regForm input[name='password']").val();
	myObject.secretCode = $("#regForm input[name='secretCode']").val();
	myObject.groupIdx = new Number($("#regForm input[name='groupIdx']").val());
	myObject.createDate = '';
	myObject.isDel = new Number(0);
	myObject.conduct = new Number(0);
	<c:choose>
	    <c:when test="${not empty param.fcIdx}">
	    var fcIdx = ${param.fcIdx};
	    myObject.fcIdx = new Number(fcIdx);
	    </c:when>
	    <c:otherwise>
	    myObject.fcIdx = new Number(0);
	    </c:otherwise>
	</c:choose>
	myObject.longCalYn = new Number($("#regForm select[name='longCalYn'] option:selected").val());
	myObject.ubcYn = new Number($("#regForm select[name='ubcYn'] option:selected").val());
	myObject.originDataYn = new Number($("#regForm select[name='originDataYn'] option:selected").val());
	myObject.showPdfYn = new Number($("#regForm select[name='showPdfYn'] option:selected").val());
	
	var result = 0;
	jQuery.ajax({
		type : "POST",
		url : "${pageContext.request.contextPath}/construction/registAjax",
	    contentType : "application/json",
		async : false,  // 요청 시 동기화 여부. 기본은 비동기(asynchronous) 요청 (default: true)
		data:  JSON.stringify(myObject),
		success : function(data) {	
			result = data;
		},
		complete : function(data) {
			if(result == 1){
				$('.popUp').hide();
				$('.popLayer').hide();
				$('body').css('overflow', 'auto');
				$('#searchForm').submit();
			}
		},
		error : function(xhr, status, error) {
			alert('error');
			$('.popUp').hide();
			$('.popLayer').hide();
			$('body').css('overflow', 'auto');
		}
	}); 
}


function hideChangeInfoPop(){
	$('.popUp').hide();
	$('.popLayer').hide();
	$('body').css('overflow', 'auto');
}
function showChangeInfoPop(){
	$('.popUp03').show();
	$('.popLayer').show();
	$('body').css('overflow', 'hidden');
}
function selectFcIdx(fcIdx){
	jQuery.ajax({
		type : "GET",
		url : "${pageContext.request.contextPath}/franchise/get/list",
		dataType : "JSON", // 옵션이므로 JSON으로 받을게 아니면 안써도 됨
		success : function(data) {
			$("#updateForm select[name='fcIdx'] option").remove();    
			if(data.length > 0){
				if(fcIdx == 0){
					$("#updateForm select[name='fcIdx']").append("<option value=\"0\" selected>없음</option>");
				}else{
					$("#updateForm select[name='fcIdx']").append("<option value=\"0\">없음</option>");
				}
				$.each(data, function(index, item) {
					//var fcIdx = '${domain.fcIdx}';
					if(fcIdx == item.idx){
						$("#updateForm select[name='fcIdx']").append("<option selected value='" + item.idx + "'>"+ item.fcName + "</option>");
					}else{
						$("#updateForm select[name='fcIdx']").append("<option value='" + item.idx + "'>"+ item.fcName + "</option>");
					}
				});
			}
		},
		complete : function(data) {
			// 통신이 실패했어도 완료가 되었을 때 이 함수를 타게 된다.
			//$('#ctmIdx').append("<option value=\"0\">선택</option>");
			//alert("서버와 통신에 실패했습니다. 계속 실패할 경우 관리자에게 문의하세요.");
		},
		error : function(xhr, status, error) {
			$("#updateForm select[name='fcIdx']").append("<option value=\"0\">선택</option>");
			alert("에러발생");
		}
	});
	//$("#updateForm select[name='fcIdx']").attr("disabled","disabled");
}


function selectFcIdxForConReg(fcIdx){
	jQuery.ajax({
		type : "GET",
		url : "${pageContext.request.contextPath}/franchise/get/list",
		dataType : "JSON", // 옵션이므로 JSON으로 받을게 아니면 안써도 됨
		success : function(data) {
			if(data.length > 0){
				if(fcIdx == 0){
					$("#regForm select[name='fcIdx']").append("<option value=\"0\" selected>없음</option>");
				}else{
					$("#regForm select[name='fcIdx']").append("<option value=\"0\">없음</option>");
				}
				$.each(data, function(index, item) {
					//var fcIdx = '${domain.fcIdx}';
					if(fcIdx == item.idx){
						$("#regForm select[name='fcIdx']").append("<option selected value='" + item.idx + "'>"+ item.fcName + "</option>");
					}else{
						$("#regForm select[name='fcIdx']").append("<option value='" + item.idx + "'>"+ item.fcName + "</option>");
					}
				});
			}
		},
		complete : function(data) {
			// 통신이 실패했어도 완료가 되었을 때 이 함수를 타게 된다.
			//$('#ctmIdx').append("<option value=\"0\">선택</option>");
			//alert("서버와 통신에 실패했습니다. 계속 실패할 경우 관리자에게 문의하세요.");
		},
		error : function(xhr, status, error) {
			$("#regForm select[name='fcIdx']").append("<option value=\"0\">선택</option>");
			alert("에러발생");
		}
	});
	
	$("#regForm select[name='fcIdx']").attr("disabled","disabled");
}
function getConstructionInfo(constructionIdx, fcIdx){
	
	showChangeInfoPop();
	selectFcIdx(fcIdx);
	var result;
	jQuery.ajax({
		type : "POST",
		url : "${pageContext.request.contextPath}/construction/get/infoOfAjax",
		async : false,  // 요청 시 동기화 여부. 기본은 비동기(asynchronous) 요청 (default: true)
		dataType : "JSON", // 옵션이므로 JSON으로 받을게 아니면 안써도 됨
		data:  {
			id : constructionIdx
		},
		success : function(data) {
			$("#updateForm input[name='groupIdx']").val(data.groupIdx);
			$("#updateForm input[name='groupName']").val(data.groupName);
			$("#updateForm input[name='id']").val(data.id);
			$("#updateForm input[name='name']").val(data.name);
			$("#updateForm input[name='location']").val(data.location);
			$("#updateForm input[name='address']").val(data.address);
			$("#updateForm input[name='conManager']").val(data.conManager);
			$("#updateForm input[name='conContact']").val(data.conContact);
			$("#updateForm input[name='manager']").val(data.manager);
			$("#updateForm input[name='contact']").val(data.contact);
			$("#updateForm input[name='userId']").val(data.userId);
			$("#updateForm input[name='name']").val(data.name);
			$("#updateForm input[name='secretCode']").val(data.secretCode);
			$("#updateForm select[name='longCalYn']").val(data.longCalYn).prop("selected",true);
			$("#updateForm select[name='ubcYn']").val(data.ubcYn).prop("selected",true);
			$("#updateForm select[name='originDataYn']").val(data.originDataYn).prop("selected",true);
			$("#updateForm select[name='showPdfYn']").val(data.showPdfYn).prop("selected",true);
			//$("#updateForm select[name='vimManaged']").val(data.vimManaged).prop("selected",true);
			
		},
		complete : function(data) {
			
		},
		error : function(xhr, status, error) {
			alert('error');
			$('.popUp').hide();
			$('.popLayer').hide();
			$('body').css('overflow', 'auto');
		}
	}); 
	
}

function updateConstruction(){	
	var name = $("#updateForm input[name='name']").val();
	var location = $("#updateForm input[name='location']").val();
	var address = $("#updateForm input[name='address']").val();
	var manager = $("#updateForm input[name='manager']").val();
	var contact = $("#updateForm input[name='contact']").val();
	var conManager = $("#updateForm input[name='conManager']").val();
	var conContact = $("#updateForm input[name='conContact']").val();
	var password = $("#updateForm input[name='password']").val(); 
	var confirmPassword = $("#updateForm input[name='confirmPassword']").val(); 
	var groupIdx = $("#updateForm input[name='groupIdx']").val();
	var groupName = $("#updateForm input[name='groupName']").val();
	var secretCode = $("#updateForm input[name='secretCode']").val();
	var fcIdx = $("#updateForm select[name='fcIdx'] option:selected").val();	
	var longCalYn = $("#updateForm select[name='longCalYn'] option:selected").val();	
	var ubcYn = $("#updateForm select[name='ubcYn'] option:selected").val();	
	var originDataYn = $("#updateForm select[name='originDataYn'] option:selected").val();	
	var showPdfYn = $("#updateForm select[name='showPdfYn'] option:selected").val();	
	
	var id = $("#updateForm input[name='id']").val();
	var fcIdx = $("#updateForm select[name='fcIdx'] option:selected").val().trim();	
	
	if(groupIdx == '' || groupName == ''){
		alert('시공사를 선택하세요.');
		return;
	}else if(name == ''){
		alert('협력사명를 입력하세요.');
		$("#updateForm input[name='name']").focus();
		return;
	}else if(location == ''){
		alert('현장명을 입력하세요.');
		$("#updateForm input[name='location']").focus();
		return;
	}else if(address == ''){
		alert('현장주소를 입력하세요.');
		$("#updateForm input[name='address']").focus();
		return;
	}
	//else if(conManager == ''){
	//	alert('협력사 소장를 이름 입력하세요.');
	//	$("#updateForm input[name='conManager']").focus();
	//	return;
	//}else if(conContact == ''){
	//	alert('협력사 소장 연락처를 입력하세요.');
	//	$("#updateForm input[name='conContact']").focus();
	//	return;
	//}else if(manager == ''){
	//	alert('협력사 담당자를 이름 입력하세요.');
	//	$("#updateForm input[name='manager']").focus();
	//	return;
	//}else if(contact == ''){
	//	alert('협력사 담당자 연락처를 입력하세요.');
	//	$("#updateForm input[name='contact']").focus();
	//	return;
	//}
	
	 if($("#updateForm input[name='password']").val() != '' && $("#updateForm input[name='confirmPassword']").val() != '' ){
		//비밀번호가 입력되었다면
		if($("#updateForm input[name='password']").val().length < 4){
			alert('4자리 이상의 비밀번호를 입력하세요.');
			$("#updateForm input[name='password']").focus();
			return;
		}else if($("#updateForm input[name='confirmPassword']").val().length < 4){
			alert('4자리 이상의 확인 비밀번호를 입력하세요.');
			$("#updateForm input[name='confirmPassword']").focus();
			return;
		}else if($("#updateForm input[name='password']").val() != $("#updateForm input[name='confirmPassword']").val()){
			alert('비밀번호를 다름니다. 비밀번호를 확인하세요.');
			$("#updateForm input[name='confirmPassword']").focus();
			return;
		}
	}else{
		if($("#updateForm input[name='password']").val() != ''){
			alert('비밀번호를 입력하세요.');
			$("#updateForm input[name='confirmPassword']").focus();
			return;
		}else if($("#updateForm input[name='confirmPassword']").val() != ''){
			alert('확인 비밀번호를 입력하세요.');
			$("#updateForm input[name='password']").focus();
			return;
		}
	}
	 
	var myObject = new Object(); 
	myObject.id = new Number(id);
	myObject.role =  new Number(0);
	myObject.name = name;
	myObject.location = location;
	myObject.address = address;
	myObject.manager = manager;
	myObject.contact = contact;
	myObject.conManager = conManager;
	myObject.conContact = conContact;
	myObject.userId = '';
	myObject.password = password; 
	myObject.secretCode = secretCode;
	myObject.groupIdx = new Number(groupIdx);	
	myObject.createDate = '';
	myObject.isDel =  new Number(0);
	myObject.conduct =  new Number(0);
	myObject.fcIdx = new Number(fcIdx);
	myObject.longCalYn = new Number(longCalYn);	
	myObject.ubcYn = new Number(ubcYn);
	myObject.originDataYn = new Number(originDataYn);
	myObject.showPdfYn = new Number(showPdfYn);
	//업데이트 
	var myString = JSON.stringify(myObject); 
	
	jQuery.ajax({
		type : "POST",
		url : "${pageContext.request.contextPath}/construction/updateForAjax",
	    contentType : "application/json",
		async : false,  // 요청 시 동기화 여부. 기본은 비동기(asynchronous) 요청 (default: true)
		data:  JSON.stringify(myObject),
		success : function(data) {
			hideChangeInfoPop();
			submitFun();
		},
		complete : function(data) {
			hideChangeInfoPop();
		},
		error : function(xhr, status, error) {
			hideChangeInfoPop();
		}
	});
	return;

}

$(document).ready(function() {
	
	getGroupList();
	
	var paramGroupIdx = ${domainParam.groupIdx};
	
	
    jQuery.ajax({
		type : "GET",
		url : "${pageContext.request.contextPath}/group/get/list",
		dataType : "JSON", // 옵션이므로 JSON으로 받을게 아니면 안써도 됨
		success : function(data) {
			if(data.length > 0){
				//$("#regForm select[name='groupIdx']").append("<option value=\"0\">선택</option>");
				$.each(data, function(index, item) {
					if(paramGroupIdx == item.idx){
						 $("#regForm input[name='groupIdx']").val(item.idx);
					     $("#regForm input[name='groupName']").val(item.groupName);
					     $("#regForm input[name='groupName']").attr("disabled", true);
					}
				});
				
				$("#updateForm select[name='groupIdx']").append("<option value=\"0\">선택</option>");
				$.each(data, function(index, item) {
					if(paramGroupIdx == item.idx){
						$("#updateForm select[name='groupIdx']").append("<option value='" + item.idx + "' selected>"+ item.groupName + "</option>");
					}else{
						$("#updateForm select[name='groupIdx']").append("<option value='" + item.idx + "'>"+ item.groupName + "</option>");
					}	
					
				});
			}
		},
		complete : function(data) {
			// 통신이 실패했어도 완료가 되었을 때 이 함수를 타게 된다.
			//$('#ctmIdx').append("<option value=\"0\">선택</option>");
			//alert("서버와 통신에 실패했습니다. 계속 실패할 경우 관리자에게 문의하세요.");
		},
		error : function(xhr, status, error) {
			$('#groupIdx').append("<option value=\"0\">선택</option>");
		}
	}); 
    
    <c:choose>
	    <c:when test="${not empty param.fcIdx}">
		    var fcIdx = ${param.fcIdx};
		    selectFcIdxForConReg(fcIdx);
	    </c:when>
	</c:choose>
   
});

function submitFun(){
	$('#searchForm').submit();
}

function duplicateContactCheck(){
	
	if($('#userId').val() == ''){
		alert('연락처를 입력하세요.');
		$('#userId').focus();
	} else {
		//연락처가 입력되었음.
		jQuery.ajax({
			type : "POST",
			url : "${pageContext.request.contextPath}/construction/duplicate/contact/confirm",
			data: { userId: $('#userId').val() }, 
			dataType : "JSON", // 옵션이므로 JSON으로 받을게 아니면 안써도 됨
			success : function(data) {
				if(data.length > 0){
					alert("이미 등록된 아아디입니다.");
				}else{
					$('#isDuplicate').val("true");
					alert("사용가능한 아이디입니다.");
				}
			},
			complete : function(data) {
			},
			error : function(xhr, status, error) {
			}
		});
	}
}
	
function conductSel(idx, selectVal){
	
	var statusMsg = "";
	if(selectVal == '0'){
		statusMsg = "시행";
	}else if(selectVal == '1'){
		statusMsg = "종료";
	}else{
		statusMsg = "가맹";
	} 

	var result = confirm(statusMsg +  ' 상태로 변경하시겠습니까?');
	if(result){
		
		jQuery.ajax({
			type : "POST",
			url : "${pageContext.request.contextPath}/construction/update/conduct",
			data: {
				id : idx
				, conduct : selectVal
			}, 
			dataType : "JSON", // 옵션이므로 JSON으로 받을게 아니면 안써도 됨
			success : function(data) {
				if(data){
					alert('변경이 완료되었습니다.');
				}
			},
			complete : function(data) {
			},
			error : function(xhr, status, error) {
			}
		});
	}
}

function toggleContractTarget(idx, currentTargetYn){
	var newVal = currentTargetYn == 1 ? 0 : 1;
	var msg = newVal == 1
		? '이 현장을 계약서 적용 대상으로 지정하시겠습니까?\n다음 로그인부터 계약 프로세스가 적용됩니다.'
		: '계약서 적용 대상에서 해제하시겠습니까?\n계약 프로세스 없이 바로 로그인됩니다.';
	if(!confirm(msg)) return;
	jQuery.ajax({
		type : "POST",
		url : "${pageContext.request.contextPath}/construction/update/contractTarget",
		data: { id : idx, targetYn : newVal },
		dataType : "JSON",
		success : function(data) {
			if(data){ alert('변경이 완료되었습니다.'); location.reload(); }
			else{ alert('변경에 실패했습니다.'); }
		},
		error : function(xhr, status, error) { alert('변경 중 오류가 발생했습니다.'); }
	});
}

function toggleBlocked(idx, currentBlockedYn){

	var newVal = currentBlockedYn == 1 ? 0 : 1;
	var msg = newVal == 1
		? '이 협력사를 이용요금 미납 상태로 설정하시겠습니까?\n로그인 시 접속이 차단됩니다.'
		: '이 협력사의 이용제한을 해제하시겠습니까?';

	var result = confirm(msg);
	if(result){

		jQuery.ajax({
			type : "POST",
			url : "${pageContext.request.contextPath}/construction/update/blocked",
			data: {
				id : idx
				, blockedYn : newVal
			},
			dataType : "JSON",
			success : function(data) {
				if(data){
					alert('변경이 완료되었습니다.');
					location.reload();
				}else{
					alert('변경에 실패했습니다.');
				}
			},
			error : function(xhr, status, error) {
				alert('변경 중 오류가 발생했습니다.');
			}
		});
	}
}


function getGroupList(){
	jQuery.ajax({
		type : "GET",
		url : "${pageContext.request.contextPath}/group/get/list",
		dataType : "JSON", // 옵션이므로 JSON으로 받을게 아니면 안써도 됨
		async : false,
		success : function(data) {
			$("#ajaxGroupTable").dataTable({
				 autoWidth : false,
			 	 data : data,
			 	 columns: [
			 		{ data : "",  width : '65px' ,
			    		render: function(data,type,row){
			    			return "<input type=\"button\" style=\"width:60px;\" id=\"btn_info\" value=\"선택\" onclick=\"javascript:setGroupInfo('"+row.idx+"','"+row.groupName+"')\"/>";
			    			
			    		}
			    	}, 
			  		{ data: 'groupName'  }
			  		
			  	],
			  	
			    "language": {
			        "decimal" : "",
			        "emptyTable" : "데이터가 없습니다.",
			        "info" : "_START_ - _END_ (총 _TOTAL_ 명)",
			        "infoEmpty" : "0명",
			        "infoFiltered" : "(전체 _MAX_ 명 중 검색결과)",
			        "infoPostFix" : "",
			        "thousands" : ",",
			        "lengthMenu" : "_MENU_ 개씩 보기",
			        "loadingRecords" : "로딩중...",
			        "processing" : "처리중...",
			        "search" : "검색 : ",
			        "zeroRecords" : "검색된 데이터가 없습니다.",
			        "paginate" : {
			            "first" : "첫 페이지",
			            "last" : "마지막 페이지",
			            "next" : "다음",
			            "previous" : "이전"
			        },
			        "aria" : {
			            "sortAscending" : " :  오름차순 정렬",
			            "sortDescending" : " :  내림차순 정렬"
			        }
			    }
			});
			
			//$('#ajaxGroupTable tbody').on('dblclick', 'tr', function () {
	    	//});
		},
		complete : function(data) {
		},
		error : function(xhr, status, error) {
		}
	});
}

function setGroupInfo(idx, groupName){
	 var table = $('#ajaxGroupTable').DataTable();
	 var data = table.row( this ).data();
	 //팝업의 숨김여부에 따라서 groupIdx, groupName 값 부여 form  이 달라진다.
	 var popUp01 = $('.popUp01').is(':visible');
	 var popUp03 = $('.popUp03').is(':visible');
	 if(popUp01){
		 $("#regForm input[name='groupIdx']").val(idx);
	     $("#regForm input[name='groupName']").val(groupName);
	 }else{
		 $("#updateForm input[name='groupIdx']").val(idx);
	     $("#updateForm input[name='groupName']").val(groupName);
	 }
     closePop();
}

function openPop() {
    document.getElementById("popup_layer").style.display = "block";
}

//팝업 닫기
function closePop() {
    document.getElementById("popup_layer").style.display = "none";

}
</script>

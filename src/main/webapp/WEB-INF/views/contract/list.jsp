<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/tagLib.jsp" %>
<div class="section-right">
	<%@ include file="/WEB-INF/views/common/welcomeMsg.jsp" %>
	<div class="TopContArea">
		<div class="titArea">
			<p class="h1Tit">계약서 목록</p>
			<c:if test="${sessionInfo.role == 0}">
				<a href="${pageContext.request.contextPath}/contract/regist" class="popBtn popBtn01" style="text-decoration:none;">계약서 작성</a>
			</c:if>
		</div>
	</div>

	<div class="listArea">
		<p class="listCount">노출된 <span>${fn:length(domainList)}</span>개의 리스트</p>

		<ul class="listUl two">
			<c:choose>
				<c:when test="${empty domainList}">
					<li><div class="listLeft"><p class="name">계약서가 없습니다.</p></div></li>
				</c:when>
				<c:otherwise>
					<c:forEach var="item" items="${domainList}" varStatus="status">
					<li>
						<div class="listLeft">
							<p class="date">${item.createdAt}</p>
							<p class="name">
								<a class="name" href="${pageContext.request.contextPath}/contract/view?contractIdx=${item.contractIdx}">
									[${item.contractNo}] ${item.siteName}
								</a>
							</p>
							<p class="addr">${item.companyName} &nbsp;|&nbsp; ${item.constructionName}</p>
							<p class="addr">
								<c:choose>
									<c:when test="${item.contractType == 'DAILY'}">일사용료</c:when>
									<c:otherwise>월사용료</c:otherwise>
								</c:choose>
								&nbsp;|&nbsp; 공급기간: ${item.supplyDeadline}
							</p>
						</div>
						<div class="listRight">
							<div class="info">
								<p class="manager">
									<c:choose>
										<c:when test="${item.status == 'SIGNED'}">
											<span style="color:#28a745;font-weight:bold;">&#10003; 서명완료</span>
										</c:when>
										<c:otherwise>
											<span style="color:#856404;">서명대기</span>
										</c:otherwise>
									</c:choose>
								</p>
								<p class="phoneNm">${item.signedAt}</p>
							</div>
							<div class="BtnArea">
								<a class="addBtn" href="${pageContext.request.contextPath}/contract/view?contractIdx=${item.contractIdx}">
									보기
								</a>
								<c:if test="${sessionInfo.role == 0}">
									<a class="changeBtn" href="${pageContext.request.contextPath}/contract/update?contractIdx=${item.contractIdx}">
										수정
									</a>
									<a class="changeBtn" href="${pageContext.request.contextPath}/contract/delete?contractIdx=${item.contractIdx}"
									   onclick="return confirm('삭제하시겠습니까?')" style="background-color:#dc3545;color:#fff;">
										삭제
									</a>
								</c:if>
							</div>
						</div>
					</li>
					</c:forEach>
				</c:otherwise>
			</c:choose>
		</ul>
	</div>

	<%@ include file="/WEB-INF/views/common/pagination.jsp" %>
</div>

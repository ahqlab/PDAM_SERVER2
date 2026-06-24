<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/tagLib.jsp" %>
<style>
.settings-wrap {
    padding: 20px;
}
.settings-header {
    background: linear-gradient(135deg, #e8f4f8 0%, #cce8f4 100%);
    border-radius: 12px;
    padding: 20px 28px;
    margin-bottom: 24px;
    font-size: 22px;
    font-weight: 700;
    color: #1a6a8a;
}
.settings-tabs {
    display: flex;
    border-bottom: 2px solid #dee2e6;
    margin-bottom: 24px;
    gap: 0;
}
.settings-tab {
    padding: 12px 28px;
    font-size: 17px;
    font-weight: 600;
    color: #555;
    cursor: pointer;
    border-bottom: 3px solid transparent;
    margin-bottom: -2px;
    transition: all 0.15s;
    white-space: nowrap;
}
.settings-tab:hover {
    color: #337ab7;
}
.settings-tab.active {
    color: #337ab7;
    border-bottom: 3px solid #337ab7;
}
.settings-panel {
    display: none;
    background: #fff;
    border: 1px solid #e5e5e5;
    border-radius: 10px;
    padding: 30px 28px;
}
.settings-panel.active {
    display: block;
}
.settings-panel h3 {
    font-size: 16px;
    font-weight: 700;
    margin-bottom: 24px;
    color: #333;
}
.form-row {
    display: flex;
    align-items: center;
    margin-bottom: 18px;
    gap: 12px;
}
.form-label {
    width: 160px;
    font-size: 16px;
    font-weight: 600;
    color: #555;
    flex-shrink: 0;
}
.form-input {
    flex: 1;
    height: 40px;
    border: 1px solid #ccc;
    border-radius: 6px;
    padding: 0 12px;
    font-size: 16px;
    box-sizing: border-box;
}
.form-input:read-only,
.form-input[disabled] {
    background: #f5f5f5;
    color: #888;
}
.form-select {
    flex: 1;
    height: 40px;
    border: 1px solid #ccc;
    border-radius: 6px;
    padding: 0 8px;
    font-size: 16px;
}
.form-group-btn {
    display: flex;
    gap: 8px;
    align-items: center;
    flex: 1;
}
.form-group-btn .form-input {
    flex: 1;
}
.popup-open-btn {
    height: 40px;
    padding: 0 14px;
    background: #555;
    color: #fff;
    border: none;
    border-radius: 6px;
    font-size: 15px;
    cursor: pointer;
    white-space: nowrap;
}
.save-btn {
    display: block;
    width: 100%;
    height: 46px;
    background: #337ab7;
    color: #fff;
    border: none;
    border-radius: 8px;
    font-size: 18px;
    font-weight: 700;
    cursor: pointer;
    margin-top: 28px;
}
.save-btn:hover {
    background: #286090;
}

/* 권한관리 테이블 */
.perm-table {
    width: 100%;
    border-collapse: collapse;
    font-size: 16px;
}
.perm-table th {
    background: #f5f5f5;
    padding: 12px 16px;
    text-align: center;
    font-weight: 700;
    color: #333;
    border: 1px solid #e0e0e0;
}
.perm-table td {
    padding: 12px 16px;
    text-align: center;
    border: 1px solid #e0e0e0;
    color: #444;
}
.perm-table td:first-child {
    text-align: center;
    font-weight: 500;
}
.toggle-switch {
    position: relative;
    display: inline-block;
    width: 50px;
    height: 26px;
}
.toggle-switch input {
    opacity: 0;
    width: 0;
    height: 0;
}
.toggle-slider {
    position: absolute;
    cursor: pointer;
    top: 0; left: 0; right: 0; bottom: 0;
    background-color: #ccc;
    border-radius: 26px;
    transition: 0.3s;
}
.toggle-slider:before {
    position: absolute;
    content: "";
    height: 20px;
    width: 20px;
    left: 3px;
    bottom: 3px;
    background-color: white;
    border-radius: 50%;
    transition: 0.3s;
}
input:checked + .toggle-slider {
    background-color: #28a745;
}
input:checked + .toggle-slider:before {
    transform: translateX(24px);
}
</style>

<div class="section-right">
    <%@ include file="/WEB-INF/views/common/welcomeMsg.jsp" %>

    <div class="settings-wrap">
        <div class="settings-header">&#9881; 설정</div>

        <div class="settings-tabs">
            <div class="settings-tab active" onclick="showTab('basicInfo', this)">&#128101; 기본정보</div>
            <c:if test="${sessionInfo.role == 0 or (sessionInfo.role == 1 and sessionInfo.hiddenManager)}">
            <div class="settings-tab" onclick="showTab('permission', this)">&#9881; 권한관리</div>
            </c:if>
            <div class="settings-tab" onclick="showTab('password', this)">&#128274; 비밀번호 변경</div>
            <div class="settings-tab" onclick="showTab('secretCode', this)">&#128737; 보안코드 변경</div>
        </div>

        <!-- 기본정보 탭 -->
        <div id="tab-basicInfo" class="settings-panel active">
            <h3>&#128101; 기본정보</h3>
            <input type="hidden" id="basicConstructionId" value="${construction.id}">

            <c:if test="${sessionInfo.role == 0}">
            <div class="form-row">
                <span class="form-label">가맹점 &amp; 협약업체</span>
                <select id="basicFcIdx" class="form-select">
                    <option value="0">없음</option>
                    <c:forEach var="fc" items="${franchiseList}">
                        <option value="${fc.idx}" ${construction.fcIdx == fc.idx ? 'selected' : ''}>${fc.fcName}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="form-row">
                <span class="form-label">시공사</span>
                <div class="form-group-btn">
                    <input type="text" id="basicGroupName" class="form-input" value="${construction.groupName}" readonly placeholder="시공사를 선택하세요.">
                    <input type="hidden" id="basicGroupIdx" value="${construction.groupIdx}">
                    <button class="popup-open-btn" onclick="openGroupPopup()">검색</button>
                </div>
            </div>
            </c:if>
            <c:if test="${sessionInfo.role == 1}">
            <div class="form-row">
                <span class="form-label">시공사</span>
                <input type="text" class="form-input" value="${construction.groupName}" readonly>
            </div>
            </c:if>

            <div class="form-row">
                <span class="form-label">협력사명</span>
                <input type="text" id="basicName" class="form-input" value="${construction.name}" placeholder="협력사명을 입력하세요.">
            </div>
            <div class="form-row">
                <span class="form-label">현장명</span>
                <input type="text" id="basicLocation" class="form-input" value="${construction.location}" placeholder="현장명을 입력하세요.">
            </div>
            <div class="form-row">
                <span class="form-label">현장주소</span>
                <input type="text" id="basicAddress" class="form-input" value="${construction.address}" placeholder="현장주소를 입력하세요.">
            </div>
            <div class="form-row">
                <span class="form-label">협력사 소장</span>
                <input type="text" id="basicConManager" class="form-input" value="${construction.conManager}" placeholder="협력사 소장 이름을 입력하세요.">
            </div>
            <div class="form-row">
                <span class="form-label">소장 연락처</span>
                <input type="text" id="basicConContact" class="form-input" value="${construction.conContact}" placeholder="협력사 소장 연락처를 입력하세요.">
            </div>
            <div class="form-row">
                <span class="form-label">담당자</span>
                <input type="text" id="basicManager" class="form-input" value="${construction.manager}" placeholder="담당자 이름을 입력하세요.">
            </div>
            <div class="form-row">
                <span class="form-label">담당자 연락처</span>
                <input type="text" id="basicContact" class="form-input" value="${construction.contact}" placeholder="담당자 연락처를 입력하세요.">
            </div>

            <button class="save-btn" onclick="saveBasicInfo()">저장</button>
        </div>

        <!-- 권한관리 탭 (role==0 또는 role==1 hiddenManager) -->
        <c:if test="${sessionInfo.role == 0 or (sessionInfo.role == 1 and sessionInfo.hiddenManager)}">
        <div id="tab-permission" class="settings-panel">
            <h3>&#9881; 권한관리</h3>
            <input type="hidden" id="permConstructionIdx" value="${construction.id}">
            <table class="perm-table">
                <thead>
                    <tr>
                        <th style="width:40%">권한 항목</th>
                        <th>관리자 모드<br><small style="font-weight:400;font-size:14px;">(보안코드 로그인)</small></th>
                        <th>게스트 모드<br><small style="font-weight:400;font-size:14px;">(일반 로그인)</small></th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>기록지 시간 사용</td>
                        <td><label class="toggle-switch"><input type="checkbox" id="useAdminReportTime" ${setting.useAdminReportTime ? 'checked' : ''}><span class="toggle-slider"></span></label></td>
                        <td><label class="toggle-switch"><input type="checkbox" id="useGuestReportTime" ${setting.useGuestReportTime ? 'checked' : ''}><span class="toggle-slider"></span></label></td>
                    </tr>
                    <tr>
                        <td>원본 데이터 사용</td>
                        <td><label class="toggle-switch"><input type="checkbox" id="useAdminOriginData" ${setting.useAdminOriginData ? 'checked' : ''}><span class="toggle-slider"></span></label></td>
                        <td><label class="toggle-switch"><input type="checkbox" id="useGuestOriginData" ${setting.useGuestOriginData ? 'checked' : ''}><span class="toggle-slider"></span></label></td>
                    </tr>
                    <tr>
                        <td>파일 반입 메뉴 사용</td>
                        <td><label class="toggle-switch"><input type="checkbox" id="useAdminFileMenu" ${setting.useAdminFileMenu ? 'checked' : ''}><span class="toggle-slider"></span></label></td>
                        <td><label class="toggle-switch"><input type="checkbox" id="useGuestFileMenu" ${setting.useGuestFileMenu ? 'checked' : ''}><span class="toggle-slider"></span></label></td>
                    </tr>
                    <tr>
                        <td>PDF 사용</td>
                        <td><label class="toggle-switch"><input type="checkbox" id="useAdminPdf" ${setting.useAdminPdf ? 'checked' : ''}><span class="toggle-slider"></span></label></td>
                        <td><label class="toggle-switch"><input type="checkbox" id="useGuestPdf" ${setting.useGuestPdf ? 'checked' : ''}><span class="toggle-slider"></span></label></td>
                    </tr>
                    <tr>
                        <td>엑셀 사용</td>
                        <td><label class="toggle-switch"><input type="checkbox" id="useAdminExcel" ${setting.useAdminExcel ? 'checked' : ''}><span class="toggle-slider"></span></label></td>
                        <td><label class="toggle-switch"><input type="checkbox" id="useGuestExcel" ${setting.useGuestExcel ? 'checked' : ''}><span class="toggle-slider"></span></label></td>
                    </tr>
                    <tr>
                        <td>휴지통 사용</td>
                        <td><label class="toggle-switch"><input type="checkbox" id="useAdminTrash" ${setting.useAdminTrash ? 'checked' : ''}><span class="toggle-slider"></span></label></td>
                        <td><label class="toggle-switch"><input type="checkbox" id="useGuestTrash" ${setting.useGuestTrash ? 'checked' : ''}><span class="toggle-slider"></span></label></td>
                    </tr>
                    <tr>
                        <td>극한지지력 사용</td>
                        <td><label class="toggle-switch"><input type="checkbox" id="useAdminUbc" ${setting.useAdminUbc ? 'checked' : ''}><span class="toggle-slider"></span></label></td>
                        <td><label class="toggle-switch"><input type="checkbox" id="useGuestUbc" ${setting.useGuestUbc ? 'checked' : ''}><span class="toggle-slider"></span></label></td>
                    </tr>
                </tbody>
            </table>
            <button class="save-btn" onclick="savePermission()">저장</button>
        </div>
        </c:if>

        <!-- 비밀번호 변경 탭 -->
        <div id="tab-password" class="settings-panel">
            <h3>&#128274; 비밀번호 변경</h3>
            <input type="hidden" id="pwConstructionIdx" value="${construction.id}">
            <div class="form-row">
                <span class="form-label">현재 비밀번호</span>
                <input type="password" id="currentPw" class="form-input" placeholder="현재 비밀번호">
            </div>
            <div class="form-row">
                <span class="form-label">새 비밀번호</span>
                <input type="password" id="newPw" class="form-input" placeholder="새 비밀번호">
            </div>
            <div class="form-row">
                <span class="form-label">새 비밀번호 확인</span>
                <input type="password" id="confirmPw" class="form-input" placeholder="새 비밀번호 확인">
            </div>
            <button class="save-btn" onclick="savePassword()">변경하기</button>
        </div>

        <!-- 보안코드 변경 탭 -->
        <div id="tab-secretCode" class="settings-panel">
            <h3>&#128737; 보안코드 변경</h3>
            <input type="hidden" id="scConstructionIdx" value="${construction.id}">
            <div class="form-row">
                <span class="form-label">현재 보안코드</span>
                <input type="text" id="currentCode" class="form-input" placeholder="현재 보안코드" autocomplete="off">
            </div>
            <div class="form-row">
                <span class="form-label">새 보안코드</span>
                <input type="text" id="newCode" class="form-input" placeholder="새 보안코드" autocomplete="off">
            </div>
            <div class="form-row">
                <span class="form-label">새 보안코드 확인</span>
                <input type="text" id="confirmCode" class="form-input" placeholder="새 보안코드 확인" autocomplete="off">
            </div>
            <button class="save-btn" onclick="saveSecretCode()">변경하기</button>
        </div>
    </div>
</div>

<!-- 시공사 검색 팝업 -->
<div class="popup_layer" id="groupPopupLayer" style="display:none;">
    <div class="popup_box">
        <div class="popup_cont">
            <div class="popup_head">
                <div class="popup_text"><font size="5">시공사 조회</font></div>
                <div class="popup_close"><a href="javascript:closeGroupPopup();">닫기</a></div>
            </div>
            <div class="table_list">
                <table class="display" id="groupPopupTable" style="width:100%;"></table>
            </div>
        </div>
    </div>
</div>

<script>
function showTab(tabName, el) {
    document.querySelectorAll('.settings-panel').forEach(function(p) { p.classList.remove('active'); });
    document.querySelectorAll('.settings-tab').forEach(function(t) { t.classList.remove('active'); });
    document.getElementById('tab-' + tabName).classList.add('active');
    el.classList.add('active');
}

/* ---- 기본정보 저장 ---- */
function saveBasicInfo() {
    var data = {
        id: $('#basicConstructionId').val(),
        name: $('#basicName').val(),
        location: $('#basicLocation').val(),
        address: $('#basicAddress').val(),
        conManager: $('#basicConManager').val(),
        conContact: $('#basicConContact').val(),
        manager: $('#basicManager').val(),
        contact: $('#basicContact').val()
    };
    <c:if test="${sessionInfo.role == 0}">
    data.groupIdx = $('#basicGroupIdx').val();
    data.fcIdx = $('#basicFcIdx').val();
    </c:if>

    if (!data.name) { alert('협력사명을 입력하세요.'); return; }
    if (!data.location) { alert('현장명을 입력하세요.'); return; }
    if (!data.address) { alert('현장주소를 입력하세요.'); return; }

    $.post('${pageContext.request.contextPath}/construction/settings/basic', data, function(result) {
        if (result > 0) {
            alert('기본정보가 저장되었습니다.');
        } else {
            alert('저장에 실패했습니다.');
        }
    });
}

/* ---- 권한관리 저장 ---- */
function savePermission() {
    var data = {
        constructionIdx: $('#permConstructionIdx').val(),
        useAdminReportTime: $('#useAdminReportTime').is(':checked'),
        useGuestReportTime: $('#useGuestReportTime').is(':checked'),
        useAdminOriginData: $('#useAdminOriginData').is(':checked'),
        useGuestOriginData: $('#useGuestOriginData').is(':checked'),
        useAdminFileMenu: $('#useAdminFileMenu').is(':checked'),
        useGuestFileMenu: $('#useGuestFileMenu').is(':checked'),
        useAdminPdf: $('#useAdminPdf').is(':checked'),
        useGuestPdf: $('#useGuestPdf').is(':checked'),
        useAdminExcel: $('#useAdminExcel').is(':checked'),
        useGuestExcel: $('#useGuestExcel').is(':checked'),
        useAdminTrash: $('#useAdminTrash').is(':checked'),
        useGuestTrash: $('#useGuestTrash').is(':checked'),
        useAdminUbc: $('#useAdminUbc').is(':checked'),
        useGuestUbc: $('#useGuestUbc').is(':checked')
    };
    $.post('${pageContext.request.contextPath}/construction/settings/permission', data, function(result) {
        if (result > 0) {
            alert('권한관리 설정이 저장되었습니다.');
        } else {
            alert('저장에 실패했습니다.');
        }
    });
}

/* ---- 비밀번호 변경 ---- */
function savePassword() {
    var currentPw = $('#currentPw').val();
    var newPw = $('#newPw').val();
    var confirmPw = $('#confirmPw').val();
    if (!currentPw) { alert('현재 비밀번호를 입력하세요.'); return; }
    if (!newPw) { alert('새 비밀번호를 입력하세요.'); return; }
    if (newPw.length < 4) { alert('4자리 이상의 비밀번호를 입력하세요.'); return; }
    if (newPw !== confirmPw) { alert('새 비밀번호가 일치하지 않습니다.'); return; }

    $.post('${pageContext.request.contextPath}/construction/settings/password', {
        constructionIdx: $('#pwConstructionIdx').val(),
        currentPw: currentPw,
        newPw: newPw
    }, function(result) {
        if (result > 0) {
            alert('비밀번호가 변경되었습니다.');
            $('#currentPw, #newPw, #confirmPw').val('');
        } else if (result == -1) {
            alert('현재 비밀번호가 맞지 않습니다.');
        } else {
            alert('변경에 실패했습니다.');
        }
    });
}

/* ---- 보안코드 변경 ---- */
function saveSecretCode() {
    var currentCode = $('#currentCode').val();
    var newCode = $('#newCode').val();
    var confirmCode = $('#confirmCode').val();
    if (!currentCode) { alert('현재 보안코드를 입력하세요.'); return; }
    if (!newCode) { alert('새 보안코드를 입력하세요.'); return; }
    if (newCode !== confirmCode) { alert('새 보안코드가 일치하지 않습니다.'); return; }

    $.post('${pageContext.request.contextPath}/construction/settings/secretCode', {
        constructionIdx: $('#scConstructionIdx').val(),
        currentCode: currentCode,
        newCode: newCode
    }, function(result) {
        if (result > 0) {
            alert('보안코드가 변경되었습니다.');
            $('#currentCode, #newCode, #confirmCode').val('');
        } else if (result == -1) {
            alert('현재 보안코드가 맞지 않습니다.');
        } else {
            alert('변경에 실패했습니다.');
        }
    });
}

/* ---- 시공사 팝업 ---- */
var groupTableInit = false;
function openGroupPopup() {
    document.getElementById('groupPopupLayer').style.display = 'block';
    if (!groupTableInit) {
        groupTableInit = true;
        $.getJSON('${pageContext.request.contextPath}/group/get/list', function(data) {
            $('#groupPopupTable').dataTable({
                autoWidth: false,
                data: data,
                columns: [
                    { data: '', width: '65px', render: function(d, t, row) {
                        return '<input type="button" style="width:60px;" value="선택" onclick="selectGroup(' + row.idx + ',\'' + row.groupName + '\')">';
                    }},
                    { data: 'groupName' }
                ],
                language: { emptyTable: '데이터가 없습니다.', search: '검색: ', zeroRecords: '검색 결과가 없습니다.' }
            });
        });
    }
}
function closeGroupPopup() {
    document.getElementById('groupPopupLayer').style.display = 'none';
}
function selectGroup(idx, groupName) {
    $('#basicGroupIdx').val(idx);
    $('#basicGroupName').val(groupName);
    closeGroupPopup();
}
</script>

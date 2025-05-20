<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

<!-- 콘텐츠 래퍼 -->
<div id="content-wrapper">
    <%@ include file="/WEB-INF/views/common/navbar.jsp" %>

    <!-- 페이지 콘텐츠 -->
    <div id="page-content-wrapper">
        <div class="container-fluid">
            <!-- 페이지 헤더 -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h1 class="h3 mb-0 text-gray-800">
                    <i class="fas fa-key me-2"></i>API 키 관리
                </h1>
            </div>

            <!-- 알림 메시지 -->
            <c:if test="${not empty newApiKey}">
                <div class="alert alert-success" role="alert">
                    <div class="d-flex">
                        <div class="me-3">
                            <i class="fas fa-check-circle fa-2x"></i>
                        </div>
                        <div>
                            <h5 class="alert-heading fw-bold">새 API 키가 생성되었습니다.</h5>
                            <p class="mb-1">API 키: <code class="bg-light px-2 py-1 rounded">${newApiKey.keyValue}</code></p>
                            <p class="small mb-0"><i class="fas fa-exclamation-circle me-1"></i>이 키는 다시 표시되지 않으니 안전한 곳에 보관하세요.</p>
                        </div>
                    </div>
                </div>
            </c:if>

            <div class="row">
                <!-- 새 API 키 생성 폼 -->
                <div class="col-lg-12 mb-4">
                    <div class="card shadow">
                        <div class="api-card-header bg-primary text-white d-flex justify-content-between align-items-center">
                            <h5 class="card-title mb-0">
                                <i class="fas fa-plus-circle me-2 text-white" ></i>새 API 키 생성
                            </h5>
                        </div>
                        <div class="card-body">
                            <form action="${pageContext.request.contextPath}/admin/api-keys" method="post">
                                <div class="row g-3">
                                    <div class="col-md-5">
                                        <div class="form-group">
                                            <label for="clientName" class="form-label">클라이언트 이름</label>
                                            <input type="text" class="form-control" id="clientName" name="clientName"
                                                placeholder="예: 모바일 앱, 제휴 서비스 등" required>
                                        </div>
                                    </div>
                                    <div class="col-md-5">
                                        <div class="form-group">
                                            <label for="description" class="form-label">설명</label>
                                            <input type="text" class="form-control" id="description" name="description"
                                                placeholder="API 키 용도 설명" required>
                                        </div>
                                    </div>
                                    <div class="col-md-2 d-flex align-items-end">
                                        <button type="submit" class="btn btn-primary w-100">
                                            <i class="fas fa-key me-2"></i>키 생성
                                        </button>
                                    </div>
                                </div>
                                <div class="form-text small text-muted mt-2">
                                    <i class="fas fa-info-circle me-1"></i>
                                    API 키는 한 번만 표시되므로 안전한 곳에 저장하세요. 키가 노출된 경우 즉시 비활성화하고 새 키를 발급하세요.
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- API 키 목록 -->
                <div class="col-lg-12">
                    <div class="card shadow">
                        <div class="api-card-header bg-primary d-flex justify-content-between align-items-center" style="color: white !important;">
                            <h5 class="card-title mb-0">
                                <i class="fas fa-list me-2"></i>활성 API 키 목록
                            </h5>
                            <span class="badge bg-light text-primary fw-bold">${apiKeys.size()}개</span>
                        </div>
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover table-striped mb-0">
                                    <thead class="table-light">
                                        <tr>
                                            <th>클라이언트</th>
                                            <th>API 키</th>
                                            <th>설명</th>
                                            <th>생성일</th>
                                            <th>마지막 사용</th>
                                            <th>허용 IP</th>
                                            <th>관리</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="apiKey" items="${apiKeys}">
                                            <tr>
                                                <td class="fw-bold">${apiKey.clientName}</td>
                                                <td>
                                                    <div class="input-group">
                                                        <input type="text" class="form-control form-control-sm bg-light"
                                                            value="${apiKey.keyValue}" readonly>
                                                        <button class="btn btn-sm btn-outline-secondary copy-btn"
                                                            data-clipboard-text="${apiKey.keyValue}" type="button"
                                                            title="복사">
                                                            <i class="fas fa-copy"></i>
                                                        </button>
                                                    </div>
                                                </td>
                                                <td>${apiKey.description}</td>
                                                <td>
                                                    <div class="small">
                                                        <i class="fas fa-calendar-alt me-1 text-muted"></i>
                                                        <fmt:parseDate value="${apiKey.createdAt}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedDateTime" type="both" />
                                                        <fmt:formatDate value="${parsedDateTime}" pattern="yyyy-MM-dd" />
                                                    </div>
                                                    <div class="small text-muted">
                                                        <fmt:formatDate value="${parsedDateTime}" pattern="HH:mm:ss" />
                                                    </div>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty apiKey.lastUsedAt}">
                                                            <div class="small">
                                                                <i class="fas fa-clock me-1 text-success"></i>
                                                                <fmt:parseDate value="${apiKey.lastUsedAt}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedLastUsedAt" type="both" />
                                                                <fmt:formatDate value="${parsedLastUsedAt}" pattern="yyyy-MM-dd" />
                                                            </div>
                                                            <div class="small text-muted">
                                                                <fmt:formatDate value="${parsedLastUsedAt}" pattern="HH:mm:ss" />
                                                            </div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-light text-muted">
                                                                <i class="fas fa-minus me-1"></i>미사용
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <form action="${pageContext.request.contextPath}/admin/api-keys/${apiKey.keyValue}/ips" method="post">
                                                        <div class="input-group input-group-sm">
                                                            <input type="text" class="form-control form-control-sm" name="allowedIps"
                                                                value="${apiKey.allowedIps}" placeholder="쉼표로 구분 (비우면 모든 IP 허용)">
                                                            <button class="btn btn-sm btn-outline-primary" type="submit">
                                                                <i class="fas fa-save"></i>
                                                            </button>
                                                        </div>
                                                    </form>
                                                </td>
                                                <td>
                                                    <div class="d-flex">
                                                        <button class="btn btn-sm btn-outline-info me-1"
                                                            onclick="viewApiUsage('${apiKey.keyValue}')" title="사용 내역">
                                                            <i class="fas fa-chart-line"></i>
                                                        </button>
                                                        <form action="${pageContext.request.contextPath}/admin/api-keys/${apiKey.keyValue}/deactivate" method="post">
                                                            <button type="submit" class="btn btn-sm btn-outline-danger"
                                                                onclick="return confirm('정말로 이 API 키를 비활성화하시겠습니까? 이 작업은 되돌릴 수 없습니다.')">
                                                                <i class="fas fa-ban"></i>
                                                            </button>
                                                        </form>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        <c:if test="${empty apiKeys}">
                                            <tr>
                                                <td colspan="7" class="text-center p-4">
                                                    <div class="py-5">
                                                        <i class="fas fa-key text-muted mb-3" style="font-size: 2.5rem;"></i>
                                                        <p class="mb-1">활성화된 API 키가 없습니다.</p>
                                                        <p class="text-muted">위 폼을 통해 새 API 키를 생성하세요.</p>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <div class="card-footer bg-light">
                            <div class="row align-items-center">
                                <div class="col-md-6">
                                    <div class="small text-muted">
                                        <i class="fas fa-info-circle me-1"></i>
                                        외부 시스템에서 API를 호출할 때 <code>apiKey</code> 파라미터를 포함해야 합니다.
                                    </div>
                                </div>
                                <div class="col-md-6 text-md-end">
                                    <a href="${pageContext.request.contextPath}/api/docs" class="btn btn-sm btn-outline-primary">
                                        <i class="fas fa-book me-1"></i>API 문서 보기
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- API 사용 안내 -->
            <div class="row mt-4">
                <div class="col-lg-12">
                    <div class="card shadow-sm">
                        <div class="card-header bg-light">
                            <h5 class="card-title mb-0">
                                <i class="fas fa-question-circle me-2"></i>API 사용 방법
                            </h5>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-6">
                                    <h6><i class="fas fa-code me-2"></i>API 요청 예시</h6>
                                    <pre class="bg-light p-3 rounded"><code>GET /api/v1/football/players?apiKey=YOUR_API_KEY&amp;scheduleId=123</code></pre>
                                    <p class="small text-muted">모든 API 요청에는 <code>apiKey</code> 쿼리 파라미터가 포함되어야 합니다.</p>
                                </div>
                                <div class="col-md-6">
                                    <h6><i class="fas fa-shield-alt me-2"></i>보안 강화 방법</h6>
                                    <ul class="small">
                                        <li>허용 IP 주소를 설정하여 특정 IP에서만 API를 호출할 수 있도록 제한하세요.</li>
                                        <li>API 키를 정기적으로 갱신하고, 사용하지 않는 키는 즉시 비활성화하세요.</li>
                                        <li>HTTPS를 통해서만 API를 호출하세요.</li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- 클립보드 복사 라이브러리 -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/clipboard.js/2.0.8/clipboard.min.js"></script>

<!-- 페이지별 고유 스크립트 -->
<script>
    $(document).ready(function() {
        // 클립보드 복사 기능 초기화
        var clipboard = new ClipboardJS('.copy-btn');

        clipboard.on('success', function(e) {
            const originalTitle = $(e.trigger).attr('title');
            $(e.trigger).attr('title', '복사됨!');
            $(e.trigger).tooltip('show');

            setTimeout(function() {
                $(e.trigger).attr('title', originalTitle);
                $(e.trigger).tooltip('hide');
            }, 1000);

            e.clearSelection();
        });

        // 툴팁 활성화
        $('[title]').tooltip({
            trigger: 'hover'
        });
    });

    // API 사용 내역 조회
    function viewApiUsage(keyValue) {
        // AJAX 요청 또는 페이지 이동
        console.log("API 키 사용 내역 조회:", keyValue);
        // 구현 예정: 사용 내역 모달 또는 페이지 이동
        alert("API 키 사용 내역 기능은 현재 개발 중입니다.");
    }
</script>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <meta name="description" content="Stock Information System" />
    <meta name="author" content="" />
    <title>Stock Analysis</title>
    <link rel="icon" type="image/x-icon" href="assets/favicon.ico" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" />
    <style>
        :root {
            --primary-color: #4361ee;
            --secondary-color: #3f37c9;
            --accent-color: #4cc9f0;
            --text-dark: #2b2d42;
            --text-light: #8d99ae;
            --bg-light: #f8f9fa;
            --bg-dark: #212529;
            --success-color: #4ade80;
            --warning-color: #fb8500;
            --danger-color: #ef233c;
        }

        body {
            font-family: 'Pretendard', -apple-system, BlinkMacSystemFont, system-ui, Roboto, sans-serif;
            background-color: #f5f7fb;
            color: var(--text-dark);
            margin: 0;
            padding: 0;
            overflow-x: hidden;
        }

        .wrapper {
            display: flex;
            width: 100%;
            align-items: stretch;
            height: 100vh;
            overflow: hidden;
        }

        #sidebar-wrapper {
            min-width: 250px;
            max-width: 250px;
            background-color: white;
            border-right: 1px solid rgba(0,0,0,0.1);
            transition: all 0.3s;
            height: 100vh;
            position: fixed;
            z-index: 1000;
            left: 0;
        }

        #sidebar-wrapper.toggled {
            margin-left: -250px;
        }

        #content-wrapper {
            width: 100%;
            min-height: 100vh;
            transition: all 0.3s;
            padding-left: 250px;
            display: flex;
            flex-direction: column;
        }

        #content-wrapper.toggled {
            padding-left: 0;
        }

        #page-content-wrapper {
            flex: 1;
            overflow-y: auto;
            padding: 20px;
        }

        .navbar {
            background-color: white !important;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            padding: 0.75rem 1.5rem;
            width: 100%;
        }

        #sidebarToggle {
            background-color: var(--primary-color);
            border: none;
        }

        .brand-logo {
            font-weight: 700;
            color: var(--primary-color);
        }

        .sidebar-heading {
            padding: 1.5rem;
            font-size: 1.2rem;
            font-weight: 700;
            color: var(--primary-color);
        }

        .list-group-item {
            border: none;
            padding: 1rem 1.5rem;
            font-weight: 500;
            transition: all 0.2s;
        }

        .list-group-item:hover,
        .list-group-item.active {
            background-color: rgba(67, 97, 238, 0.05);
            color: var(--primary-color);
            border-left: 4px solid var(--primary-color);
        }

        .notification-badge {
            position: absolute;
            top: -5px;
            right: -5px;
            width: 20px;
            height: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: var(--danger-color);
            color: white;
            border-radius: 50%;
            font-size: 0.75rem;
            font-weight: 600;
        }

        .profile-thumb {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
        }

        /* 원래 주식 분석 스타일 유지 */
        .card {
            border-radius: 10px;
            margin-bottom: 20px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .card-header {
            border-radius: 10px 10px 0 0 !important;
            font-weight: 600;
        }

        .stock-card {
            transition: transform 0.2s;
        }

        .stock-card:hover {
            transform: translateY(-5px);
        }

        .price-up {
            color: #dc3545;
        }

        .price-down {
            color: #198754;
        }

        /* 반응형 조정 */
        @media (max-width: 991.98px) {
            #sidebar-wrapper {
                margin-left: -250px;
            }

            #sidebar-wrapper.toggled {
                margin-left: 0;
            }

            #content-wrapper {
                padding-left: 0;
            }

            #content-wrapper.toggled {
                padding-left: 250px;
            }
        }
    </style>
</head>
<body>
<!-- 전체 래퍼 -->
    <div class="wrapper" id="wrapper">
        <!-- 사이드바 직접 포함 -->
        <div id="sidebar-wrapper">
            <div class="sidebar-heading border-bottom bg-light d-flex align-items-center">
                <i class="fas fa-cube me-2"></i>영빈
            </div>
            <div class="list-group list-group-flush">
                <a class="list-group-item list-group-item-action list-group-item-light" href="/">
                    <i class="fas fa-home me-2"></i>홈
                </a>
                <a class="list-group-item list-group-item-action list-group-item-light" href="/dashboard">
                    <i class="fas fa-tachometer-alt me-2"></i>지하철 도착 정보
                </a>
                <a class="list-group-item list-group-item-action list-group-item-light" href="/stockinfo">
                    <i class="fas fa-tachometer-alt me-2"></i>주식 종목 정보
                </a>
                <a class="list-group-item list-group-item-action list-group-item-light active" href="/analysis">
                    <i class="fas fa-chart-pie me-2"></i>분석
                </a>
            </div>
        </div>

        <!-- 콘텐츠 래퍼 -->
        <div id="content-wrapper">
            <!-- 상단 내비게이션 직접 포함 -->
            <nav class="navbar navbar-expand-lg navbar-light bg-light">
                <div class="container-fluid">
                    <button class="btn btn-primary" id="sidebarToggle">
                        <i class="fas fa-bars"></i>
                    </button>
                    <a class="navbar-brand ms-3 brand-logo" href="#">
                        <i class="fas fa-cube me-2"></i>영빈
                    </a>
                    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                        <span class="navbar-toggler-icon"></span>
                    </button>
                    <div class="collapse navbar-collapse" id="navbarSupportedContent">
                        <ul class="navbar-nav ms-auto mt-2 mt-lg-0">
                            <li class="nav-item">
                                <a class="nav-link" href="#">
                                    <i class="fas fa-home me-1"></i>대시보드
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="#">
                                    <i class="fas fa-list me-1"></i>프로젝트
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="#">
                                    <i class="fas fa-users me-1"></i>팀원
                                </a>
                            </li>
                            <li class="nav-item position-relative">
                                <a class="nav-link" href="#">
                                    <i class="fas fa-bell me-1"></i>알림
                                    <span class="notification-badge">3</span>
                                </a>
                            </li>
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle d-flex align-items-center" id="navbarDropdown" href="#" role="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                    <img src="/api/placeholder/80/80" alt="Profile" class="profile-thumb me-2">
                                    <span>홍길동</span>
                                </a>
                                <div class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdown">
                                    <a class="dropdown-item" href="#">
                                        <i class="fas fa-user me-2"></i>프로필
                                    </a>
                                    <a class="dropdown-item" href="#">
                                        <i class="fas fa-cog me-2"></i>설정
                                    </a>
                                    <div class="dropdown-divider"></div>
                                    <a class="dropdown-item" href="#">
                                        <i class="fas fa-sign-out-alt me-2"></i>로그아웃
                                    </a>
                                </div>
                            </li>
                        </ul>
                    </div>
                </div>
            </nav>

            <!-- 페이지 콘텐츠 -->
            <div id="page-content-wrapper">
            <div class="container mt-4">
                <h2>📈 주식 정보 조회 시스템</h2>

                <!-- 상세 정보 구간 -->
                <div class="card mb-4">
                    <div class="card-header bg-info text-white">
                        <i class="fas fa-search"></i> 주식 상세 검색
                    </div>
                    <div class="card-body">
                        <!-- 상세 검색 폼 -->
                        <form action="${pageContext.request.contextPath}/stock/detail-search" method="get" class="row g-3">
                            <div class="col-md-4">
                                <label for="stockCode" class="form-label">종목코드</label>
                                <input type="text" class="form-control" id="stockCode" name="stockCode" placeholder="종목코드 입력">
                            </div>
                            <div class="col-md-4">
                                <label for="stockName" class="form-label">종목명</label>
                                <input type="text" class="form-control" id="stockName" name="stockName" placeholder="종목명 입력">
                            </div>
                            <div class="col-md-4">
                                <label for="marketType" class="form-label">시장구분</label>
                                <select class="form-select" id="marketType" name="marketType">
                                    <option value="">전체</option>
                                    <option value="KOSPI">KOSPI</option>
                                    <option value="KOSDAQ">KOSDAQ</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label for="startDate" class="form-label">조회 시작일</label>
                                <input type="date" class="form-control" id="startDate" name="startDate">
                            </div>
                            <div class="col-md-4">
                                <label for="endDate" class="form-label">조회 종료일</label>
                                <input type="date" class="form-control" id="endDate" name="endDate">
                            </div>
                            <div class="col-md-4">
                                <label for="sector" class="form-label">섹터</label>
                                <select class="form-select" id="sector" name="sector">
                                    <option value="">전체</option>
                                    <option value="IT">IT</option>
                                    <option value="금융">금융</option>
                                    <option value="에너지">에너지</option>
                                    <option value="소비재">소비재</option>
                                    <option value="헬스케어">헬스케어</option>
                                    <option value="통신">통신</option>
                                    <option value="산업재">산업재</option>
                                    <option value="원자재">원자재</option>
                                </select>
                            </div>
                            <div class="col-12 mt-3">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-search"></i> 상세 검색
                                </button>
                                <button type="reset" class="btn btn-secondary ms-2">
                                    <i class="fas fa-undo"></i> 초기화
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- 상세 검색 결과 -->
                <c:if test="${not empty detailSearchResults}">
                <div class="card mb-4">
                    <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                        <span>상세 검색 결과</span>
                        <span class="badge bg-light text-dark">${fn:length(allDetailSearchResults)}건</span>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-striped table-hover">
                                <thead class="table-dark">
                                <tr>
                                    <th>종목코드</th>
                                    <th>종목명</th>
                                    <th>일자</th>
                                    <th>시장구분</th>
                                    <th>종가</th>
                                    <th>전일대비</th>
                                    <th>등락률</th>
                                    <th>시가</th>
                                    <th>고가</th>
                                    <th>저가</th>
                                    <th>거래량</th>
                                    <th>시가총액</th>
                                    <th>상세</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="item" items="${detailSearchResults}">
                                <tr>
                                    <td>${item.ISINCD}</td>
                                    <td>${item.ITMSNM}</td>
                                    <td pattern="####-##-##">${item.BASDT}</td>
                                    <td>${item.MRKTCTG}</td>
                                    <td><fmt:formatNumber value="${item.CLPR}" pattern="#,###"/></td>
                                    <td class="${item.VS >= 0 ? 'text-danger' : 'text-primary'}">
                                        <fmt:formatNumber value="${item.VS}" pattern="#,###"/>
                                    </td>
                                    <td class="${item.FLTRT >= 0 ? 'text-danger' : 'text-primary'}">
                                        ${item.FLTRT}%
                                    </td>
                                    <td><fmt:formatNumber value="${item.MKP}" pattern="#,###"/></td>
                                    <td><fmt:formatNumber value="${item.HIPR}" pattern="#,###"/></td>
                                    <td><fmt:formatNumber value="${item.LOPR}" pattern="#,###"/></td>
                                    <td><fmt:formatNumber value="${item.TRQU}" pattern="#,###"/></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty item.MRKTTOTAMT}">
                                                <fmt:formatNumber value="${item.MRKTTOTAMT}" pattern="#,###"/>원
                                            </c:when>
                                            <c:otherwise>N/A</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/stock/detail?stockCode=${item.ISINCD}&date=${item.BASDT}"
                                           class="btn btn-sm btn-outline-info">
                                            <i class="fas fa-info-circle"></i>
                                        </a>
                                    </td>
                                </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>

                        <!-- 검색 결과 페이징 -->
                        <c:if test="${fn:length(detailSearchResults) > 0}">
                        <div class="mt-3">
                            <nav aria-label="Page navigation">
                                <ul class="pagination justify-content-center">
                                    <!-- 이전 페이지 -->
                                    <li class="page-item ${detailCurrentPage == 1 ? 'disabled' : ''}">
                                        <a class="page-link" href="${pageContext.request.contextPath}/stock/detail-search?page=${detailCurrentPage - 1}&stockCode=${param.stockCode}&stockName=${param.stockName}&marketType=${param.marketType}&startDate=${param.startDate}&endDate=${param.endDate}&sector=${param.sector}" aria-label="Previous">
                                            <span aria-hidden="true">&laquo;</span>
                                        </a>
                                    </li>

                                   <!-- 페이지 번호 -->
                                   <c:choose>
                                     <c:when test="${detailTotalPages > 0}">
                                       <c:set var="startPage" value="1"/>
                                       <c:if test="${detailTotalPages > 10}">
                                         <c:choose>
                                           <c:when test="${detailCurrentPage <= 6}">
                                             <c:set var="startPage" value="1"/>
                                           </c:when>
                                           <c:when test="${detailCurrentPage > detailTotalPages - 5}">
                                             <c:choose>
                                               <c:when test="${detailTotalPages - 9 < 1}">
                                                 <c:set var="startPage" value="1"/>
                                               </c:when>
                                               <c:otherwise>
                                                 <c:set var="startPage" value="${detailTotalPages - 9}"/>
                                               </c:otherwise>
                                             </c:choose>
                                           </c:when>
                                           <c:otherwise>
                                             <c:set var="startPage" value="${detailCurrentPage - 5}"/>
                                           </c:otherwise>
                                         </c:choose>
                                       </c:if>

                                       <c:set var="endPage" value="${detailTotalPages}"/>
                                       <c:if test="${detailTotalPages > 10}">
                                         <c:choose>
                                           <c:when test="${detailCurrentPage <= 6}">
                                             <c:choose>
                                               <c:when test="${detailTotalPages < 10}">
                                                 <c:set var="endPage" value="${detailTotalPages}"/>
                                               </c:when>
                                               <c:otherwise>
                                                 <c:set var="endPage" value="10"/>
                                               </c:otherwise>
                                             </c:choose>
                                           </c:when>
                                           <c:when test="${detailCurrentPage > detailTotalPages - 5}">
                                             <c:set var="endPage" value="${detailTotalPages}"/>
                                           </c:when>
                                           <c:otherwise>
                                             <c:set var="endPage" value="${detailCurrentPage + 4}"/>
                                           </c:otherwise>
                                         </c:choose>
                                       </c:if>

                                       <c:forEach var="pageNum" begin="${startPage}" end="${endPage}">
                                         <li class="page-item ${pageNum == detailCurrentPage ? 'active' : ''}">
                                           <a class="page-link" href="${pageContext.request.contextPath}/stock/detail-search?page=${pageNum}&stockCode=${param.stockCode}&stockName=${param.stockName}&marketType=${param.marketType}&startDate=${param.startDate}&endDate=${param.endDate}&sector=${param.sector}">${pageNum}</a>
                                         </li>
                                       </c:forEach>
                                     </c:when>
                                   </c:choose>

                                    <!-- 다음 페이지 -->
                                    <li class="page-item ${detailCurrentPage == detailTotalPages ? 'disabled' : ''}">
                                        <a class="page-link" href="${pageContext.request.contextPath}/stock/detail-search?page=${detailCurrentPage + 1}&stockCode=${param.stockCode}&stockName=${param.stockName}&marketType=${param.marketType}&startDate=${param.startDate}&endDate=${param.endDate}&sector=${param.sector}" aria-label="Next">
                                            <span aria-hidden="true">&raquo;</span>
                                        </a>
                                    </li>
                                </ul>
                            </nav>
                        </div>
                        </c:if>

                        <!-- 다운로드 옵션 -->
                        <div class="d-flex justify-content-end mt-3">
                            <a id="btnAnalyze" href="#" class="btn btn-success">
                                <i class="fas fa-chart-line"></i> 데이터 분석
                            </a>
                            <a href="${pageContext.request.contextPath}/stock/export-csv?stockCode=${param.stockCode}&stockName=${param.stockName}&marketType=${param.marketType}&startDate=${param.startDate}&endDate=${param.endDate}&sector=${param.sector}" class="btn btn-success ms-2">
                                <i class="fas fa-file-csv"></i> CSV 다운로드
                            </a>
                            <a href="${pageContext.request.contextPath}/stock/export-excel?stockCode=${param.stockCode}&stockName=${param.stockName}&marketType=${param.marketType}&startDate=${param.startDate}&endDate=${param.endDate}&sector=${param.sector}" class="btn btn-success ms-2">
                                <i class="fas fa-file-excel"></i> Excel 다운로드
                            </a>
                        </div>
                    </div>
                </div>
                </c:if>

                <!-- Python 분석 요청 섹션 -->
                <div class="card mb-4">
                    <div class="card-header">데이터 분석</div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <form action="${pageContext.request.contextPath}/stock/analyze_python" method="post" class="mb-3">
                                    <div class="mb-3">
                                        <label for="analysisStock" class="form-label">분석할 종목코드</label>
                                        <input type="text" class="form-control" id="analysisStock" name="stockCode" placeholder="종목코드 입력">
                                    </div>
                                    <div class="mb-3">
                                        <label for="analysisType" class="form-label">분석 유형</label>
                                        <select class="form-select" id="analysisType" name="analysisType">
                                            <option value="price_trend">가격 추세 분석</option>
                                            <option value="financial_health">재무건전성 분석</option>
                                            <option value="prediction">주가 예측</option>
                                        </select>
                                    </div>
                                    <button type="submit" class="btn btn-success">Python 분석 요청</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 분석 결과 상세 정보 추가 -->
                <c:if test="${not empty analysisResult}">
                <div class="card mb-4">
                    <div class="card-header bg-success text-white d-flex justify-content-between align-items-center">
                        <span>📊 분석 결과 상세</span>
                        <span class="badge bg-light text-dark">${analysisResult.analysisType}</span>
                    </div>
                    <div class="card-body">
                        <div class="row mb-4">
                            <div class="col-md-6">
                                <h5 class="mb-3">${analysisResult.stockName} (${analysisResult.stockCode})</h5>
                                <div class="mb-3">
                                    <h6>분석 요약</h6>
                                    <p class="text-muted">${analysisResult.summary}</p>
                                </div>

                                <div class="mb-3">
                                    <h6>산업 평균 대비</h6>
                                    <div class="progress mb-2" style="height: 25px;">
                                        <div class="progress-bar" role="progressbar"
                                             style="width: ${analysisResult.industryPercentile}%"
                                             aria-valuenow="${analysisResult.industryPercentile}"
                                             aria-valuemin="0" aria-valuemax="100">${analysisResult.industryPercentile}%</div>
                                    </div>
                                    <small class="text-muted">${analysisResult.industryComparison}</small>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <h6>주요 지표</h6>
                                <table class="table table-sm table-bordered">
                                    <thead class="table-light">
                                    <tr>
                                        <th>지표</th>
                                        <th>값</th>
                                        <th>평가</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="metric" items="${analysisResult.metrics}">
                                    <tr>
                                        <td>${metric.key}</td>
                                        <td>${metric.value}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${metric.evaluation == 'positive'}">
                                                    <span class="text-success">
                                                        <i class="fas fa-arrow-up"></i> 양호
                                                    </span>
                                                </c:when>
                                                <c:when test="${metric.evaluation == 'neutral'}">
                                                    <span class="text-warning">
                                                        <i class="fas fa-minus"></i> 보통
                                                    </span>
                                                </c:when>
                                                <c:when test="${metric.evaluation == 'negative'}">
                                                    <span class="text-danger">
                                                        <i class="fas fa-arrow-down"></i> 주의
                                                    </span>
                                                </c:when>
                                            </c:choose>
                                        </td>
                                    </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <!-- 차트나 그래프가 있다면 표시 -->
                        <c:if test="${not empty analysisResult.chartUrl}">
                        <div class="mb-3">
                            <h6>차트 분석</h6>
                            <div class="card">
                                <div class="card-body text-center">
                                    <img src="${analysisResult.chartUrl}" class="img-fluid" alt="Analysis Chart">
                                    <p class="mt-2 text-muted">${analysisResult.chartDescription}</p>
                                </div>
                            </div>
                        </div>
                        </c:if>

                        <div class="row">
                            <div class="col-md-12">
                                <c:if test="${not empty analysisResult.recommendation}">
                                    <div class="alert ${analysisResult.recommendationType == 'buy' ? 'alert-success' : (analysisResult.recommendationType == 'hold' ? 'alert-warning' : 'alert-danger')}">
                                        <strong>투자 의견:</strong> ${analysisResult.recommendation}
                                        <div class="mt-2">
                                            <small>분석 기준일: ${analysisResult.analysisDate}</small>
                                            <small class="ms-3 text-muted">* 본 분석은 투자 조언이 아닙니다. 투자 결정 시 전문가와 상담하세요.</small>
                                        </div>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
                </c:if>

                <!-- 주식 상세 정보 -->
                <c:if test="${not empty stockDetail}">
                <div class="mb-4">
                    <h4 class="mt-4">종목 상세 정보</h4>

                    <!-- 기본 정보 -->
                    <div class="card mb-3">
                        <div class="card-header">기본 정보</div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-6">
                                    <p><strong>종목명:</strong> ${stockDetail.stockName}</p>
                                    <p><strong>종목코드:</strong> ${stockDetail.stockCode}</p>
                                    <p><strong>시장구분:</strong> ${stockDetail.marketType}</p>
                                </div>
                                <div class="col-md-6">
                                    <p><strong>섹터:</strong> ${stockDetail.sector}</p>
                                    <p><strong>업종:</strong> ${stockDetail.industry}</p>
                                    <p><strong>상장일:</strong> ${stockDetail.listingDate}</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- 가격 정보 -->
                    <div class="card mb-3">
                        <div class="card-header">가격 정보</div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-6">
                                    <p><strong>현재가:</strong> ${stockDetail.currentPrice}</p>
                                    <p><strong>전일대비:</strong> ${stockDetail.priceChange}</p>
                                    <p><strong>등락률:</strong> ${stockDetail.changeRate}%</p>
                                </div>
                                <div class="col-md-6">
                                    <p><strong>시가:</strong> ${stockDetail.openPrice}</p>
                                    <p><strong>고가:</strong> ${stockDetail.highPrice}</p>
                                    <p><strong>저가:</strong> ${stockDetail.lowPrice}</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- 재무 정보 -->
                    <div class="card">
                        <div class="card-header">재무 정보</div>
                        <div class="card-body">
                            <table class="table table-bordered">
                                <thead>
                                <tr>
                                    <th>구분</th>
                                    <th>매출액</th>
                                    <th>영업이익</th>
                                    <th>당기순이익</th>
                                    <th>EPS</th>
                                    <th>PER</th>
                                    <th>ROE</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="finance" items="${stockDetail.financialData}">
                                <tr>
                                    <td>${finance.period}</td>
                                    <td>${finance.revenue}</td>
                                    <td>${finance.operatingProfit}</td>
                                    <td>${finance.netIncome}</td>
                                    <td>${finance.eps}</td>
                                    <td>${finance.per}</td>
                                    <td>${finance.roe}</td>
                                </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                </c:if>
            </div>
        </div>
    </div>
<!-- Core theme JS-->
<!-- JS -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.2.3/js/bootstrap.bundle.min.js"></script>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        // 토글 기능 설정
        document.getElementById('sidebarToggle').addEventListener('click', function(e) {
            e.preventDefault();
            document.getElementById('sidebar-wrapper').classList.toggle('toggled');
            document.getElementById('content-wrapper').classList.toggle('toggled');

        });

        // URL 파라미터 가져오기
        const urlParams = new URLSearchParams(window.location.search);
        const stockCode = urlParams.get('stockCode');
        const autoSearch = urlParams.get('autoSearch');

        if (stockCode && autoSearch === 'true') {
            // 검색창에 값 입력
            const stockCodeInput = document.getElementById('stockCode');
            if (stockCodeInput) {
                stockCodeInput.value = stockCode;
            }
            console.log("TEST");

            // 페이지가 이미 검색 결과를 보여주고 있으므로,
            // 검색창에 값만 자동으로 채워주면 됩니다.
            // detail-search controller가 이미 검색을 수행했기 때문입니다.
        }
    });

    function openDetail(stockCode) {
      const url = `stock_detail.html?code=${stockCode}`;
      window.open(url, "popupWindow", "width=600,height=400,resizable=yes,scrollbars=yes");
    }

    document.getElementById('btnAnalyze').addEventListener('click', function() {
        // 테이블에서 데이터 수집
        const table = document.querySelector('table');
        const rows = table.querySelectorAll('tbody tr');
        const stockDataList = [];

        // 각 행에서 데이터 추출
        rows.forEach(row => {
            const cells = row.querySelectorAll('td');

            const stockData = {
                ISINCD: cells[0].textContent,     // 종목코드
                ITMSNM: cells[1].textContent,     // 종목명
                BASDT: cells[2].textContent,      // 일자
                MRKTCTG: cells[3].textContent,    // 시장구분
                CLPR: parseInt(cells[4].textContent.replace(/,/g, '')),  // 종가
                VS: parseInt(cells[5].textContent.replace(/,/g, '')),    // 전일대비
                FLTRT: parseFloat(cells[6].textContent.replace('%', '')),// 등락률
                MKP: parseInt(cells[7].textContent.replace(/,/g, '')),   // 시가
                HIPR: parseInt(cells[8].textContent.replace(/,/g, '')),  // 고가
                LOPR: parseInt(cells[9].textContent.replace(/,/g, '')),  // 저가
                TRQU: parseInt(cells[10].textContent.replace(/,/g, '')), // 거래량
                MRKTTOTAMT: cells[11].textContent.includes('N/A') ? null :
                    parseInt(cells[11].textContent.replace(/,/g, '').replace('원', '')) // 시가총액
            };

            stockDataList.push(stockData);
        });

        // AJAX로 데이터 전송
        fetch('/stock/analysis', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                // CSRF 토큰이 있다면 추가 (Spring Security 사용 시)
                'X-CSRF-TOKEN': document.querySelector('meta[name="_csrf"]')?.getAttribute('content')
            },
            body: JSON.stringify(stockDataList)
        })
        .then(response => response.json())
        .then(data => {
            if(data.message === "분석 성공") {
                alert(`분석이 완료되었습니다. 총 ${data.count}개의 데이터가 분석되었습니다.`);
                // 분석 결과 페이지로 이동하거나 추가 작업 수행
            } else {
                alert('분석 중 오류가 발생했습니다.');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('요청 처리 중 오류가 발생했습니다.');
        });
    });
</script>
</body>
</html>
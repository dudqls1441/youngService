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

                <a class="list-group-item list-group-item-action list-group-item-light" href="/performance">
                    <i class="fas fa-chart-pie me-2"></i>주식 비교
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
                <div class="card mb-5"> <!-- margin-bottom을 4에서 5로 증가 -->
                    <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                        <span>상세 검색 결과</span>
                        <span class="badge bg-light text-dark">${fn:length(allDetailSearchResults)}건</span>
                    </div>
                    <div class="card-body p-0">
                        <!-- AG Grid 컨테이너 -->
                        <div id="stockGrid" class="ag-theme-alpine" style="width: 100%; height: 500px;"></div>

                        <!-- 데이터 저장용 hidden input 추가 -->
                        <input type="hidden" id="allStockData" value='${allDetailSearchResultsJson}'>

                        <!-- 다운로드 옵션 -->
                        <div class="d-flex justify-content-end p-3">
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

                <!-- 구분선 추가 -->
                <c:if test="${not empty detailSearchResults}">
                <hr class="my-4" style="border-top: 2px dashed #e9ecef;">
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

                <!-- ML 분석 결과 -->
                <div id="mlAnalysisResult" class="card mb-4" style="display: none;">
                    <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                        <span><i class="fas fa-chart-line me-2"></i>머신러닝 분석 결과</span>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <!-- 기본 통계 정보 -->
                            <div class="col-md-6 mb-4">
                                <div class="card h-100 shadow-sm">
                                    <div class="card-header bg-light">
                                        <h5 class="mb-0"><i class="fas fa-calculator me-2"></i>기본 통계</h5>
                                    </div>
                                    <div class="card-body">
                                        <table class="table table-sm">
                                            <tbody id="basicStatsTable">
                                                <!-- 기본 통계 데이터가 여기에 동적으로 추가됩니다 -->
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>

                            <!-- 트렌드 분석 -->
                            <div class="col-md-6 mb-4">
                                <div class="card h-100 shadow-sm">
                                    <div class="card-header bg-light">
                                        <h5 class="mb-0"><i class="fas fa-chart-line me-2"></i>추세 분석</h5>
                                    </div>
                                    <div class="card-body">
                                        <table class="table table-sm">
                                            <tbody id="trendAnalysisTable">
                                                <!-- 트렌드 분석 데이터가 여기에 동적으로 추가됩니다 -->
                                            </tbody>
                                        </table>
                                        <div id="trendIndicator" class="mt-3 text-center">
                                            <!-- 트렌드 표시기가 여기에 표시됩니다 -->
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- 가격 예측 -->
                            <div class="col-md-6 mb-4">
                                <div class="card h-100 shadow-sm">
                                    <div class="card-header bg-light">
                                        <h5 class="mb-0"><i class="fas fa-crystal-ball me-2"></i>가격 예측</h5>
                                    </div>
                                    <div class="card-body">
                                        <div class="mb-3">
                                            <h6>현재 가격: <span id="currentPrice" class="badge bg-secondary"></span></h6>
                                        </div>
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="card mb-3">
                                                    <div class="card-header py-2 bg-light">선형 회귀 예측</div>
                                                    <div class="card-body text-center">
                                                        <h3 id="linearPrediction"></h3>
                                                        <div id="linearDirection" class="mt-2"></div>
                                                        <div class="mt-2 text-muted small">정확도: <span id="linearAccuracy"></span></div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="card mb-3">
                                                    <div class="card-header py-2 bg-light">랜덤 포레스트 예측</div>
                                                    <div class="card-body text-center">
                                                        <h3 id="rfPrediction"></h3>
                                                        <div id="rfDirection" class="mt-2"></div>
                                                        <div class="mt-2 text-muted small">정확도: <span id="rfAccuracy"></span></div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- 위험 지표 -->
                            <div class="col-md-6 mb-4">
                                <div class="card h-100 shadow-sm">
                                    <div class="card-header bg-light">
                                        <h5 class="mb-0"><i class="fas fa-exclamation-triangle me-2"></i>위험 지표</h5>
                                    </div>
                                    <div class="card-body">
                                        <table class="table table-sm">
                                            <tbody id="riskMetricsTable">
                                                <!-- 위험 지표 데이터가 여기에 동적으로 추가됩니다 -->
                                            </tbody>
                                        </table>
                                        <div id="riskIndicator" class="mt-3 pb-4">
                                            <!-- 위험 표시기가 여기에 표시됩니다 -->
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- 특성 중요도 -->
                            <div class="col-md-12">
                                <div class="card shadow-sm">
                                    <div class="card-header bg-light">
                                        <h5 class="mb-0"><i class="fas fa-percentage me-2"></i>특성 중요도</h5>
                                    </div>
                                    <div class="card-body">
                                        <div class="row">
                                            <div class="col-md-12">
                                                <div id="featureImportanceChart" style="height: 280px;">
                                                    <!-- 특성 중요도 차트가 여기에 표시됩니다 -->
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
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
<!-- AG Grid 라이브러리 추가 -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/ag-grid-community@30.0.5/styles/ag-grid.min.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/ag-grid-community@30.0.5/styles/ag-theme-alpine.min.css">
<script src="https://cdn.jsdelivr.net/npm/ag-grid-community@30.0.5/dist/ag-grid-community.min.js"></script>

<!-- Bootstrap JS -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.2.3/js/bootstrap.bundle.min.js"></script>

<script>
    document.addEventListener('DOMContentLoaded', function() {
      // 토글 기능 설정
        document.getElementById('sidebarToggle').addEventListener('click', function(e) {
            e.preventDefault();
            document.getElementById('sidebar-wrapper').classList.toggle('toggled');
            document.getElementById('content-wrapper').classList.toggle('toggled');
        });

        // AG Grid 초기화 (allStockData가 있을 때만)
        if(document.getElementById('allStockData')) {
            initAgGrid();
        }

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
        }

        // 분석 버튼 이벤트 리스너
        const analyzeBtn = document.getElementById('btnAnalyze');
        if (analyzeBtn) {
            analyzeBtn.addEventListener('click', analyzeData);
        }
    });

    // 분석 버튼 클릭 이벤트 핸들러
    function analyzeData(e) {
        e.preventDefault();

        // 전체 검색 결과 데이터 활용 (JSP에서 hidden input으로 제공된 데이터)
        const allStockDataJson = document.getElementById('allStockData').value;
        let stockDataList = [];

        console.log("allStockDataJson:::" + allStockDataJson);

        try {
            stockDataList = JSON.parse(allStockDataJson);
        } catch (error) {
            console.error('JSON 파싱 오류:', error);
            alert('데이터 처리 중 오류가 발생했습니다.');
            return;
        }

        // 데이터가 없는 경우 처리
        if (!stockDataList || stockDataList.length === 0) {
            alert('분석할 데이터가 없습니다.');
            return;
        }

        // 진행 중임을 표시
        const analyzeBtn = document.getElementById('btnAnalyze');
        const originalText = analyzeBtn.innerHTML;
        analyzeBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> 분석 중...';
        analyzeBtn.disabled = true;

        // AJAX로 데이터 전송
        fetch('/stock/analysis', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-CSRF-TOKEN': document.querySelector('meta[name="_csrf"]')?.getAttribute('content')
            },
            body: JSON.stringify(stockDataList)
        })
        .then(response => {
            if (!response.ok) {
                throw new Error('서버 응답 오류: ' + response.status);
            }
            return response.json();
        })
        .then(data => {
            // 버튼 상태 복원
            analyzeBtn.innerHTML = originalText;
            analyzeBtn.disabled = false;

            if(data.message === "분석 성공") {
                alert("분석이 완료되었습니다. 총 " + data.count + " 개의 데이터가 분석되었습니다.");

                // 결과 표시 영역에 데이터 표시
                displayAnalysisResult(data.result);

                console.log(" result = {}", data.result);
            } else {
                alert("분석 중 오류가 발생했습니다: " + data.errorMessage + "");
            }
        })
        .catch(error => {
            // 버튼 상태 복원
            analyzeBtn.innerHTML = originalText;
            analyzeBtn.disabled = false;

            console.error('Error:', error);
            alert('요청 처리 중 오류가 발생했습니다.');
        });
    }

    // AG Grid 초기화 함수
    function initAgGrid() {
        // hidden input에서 데이터 가져오기
        const stockDataElement = document.getElementById('allStockData');
        if (!stockDataElement) return; // 데이터가 없으면 실행하지 않음

        const stockDataJson = stockDataElement.value;
        let stockDataList = [];

        try {
            stockDataList = JSON.parse(stockDataJson);
        } catch (error) {
            console.error('JSON 파싱 오류:', error);
            return;
        }

        // 컬럼 정의
        const columnDefs = [
            { headerName: '종목코드', field: 'ISINCD', sortable: true, filter: true, width: 120 },
            { headerName: '종목명', field: 'ITMSNM', sortable: true, filter: true, width: 150 },
            {
                headerName: '일자',
                field: 'BASDT',
                sortable: true,
                filter: true,
                width: 120,
                valueFormatter: params => {
                    if (!params.value) return '';
                    try {
                        let date;
                        if(String(params.value).length > 10) {
                            date = new Date(parseInt(params.value)); // 밀리초
                        } else {
                            date = new Date(parseInt(params.value) * 1000); // 초
                        }

                        if(isNaN(date.getTime())) {
                            return params.value;
                        }

                        return date.getFullYear() + '-' +
                               String(date.getMonth() + 1).padStart(2, '0') + '-' +
                               String(date.getDate()).padStart(2, '0');
                    } catch(e) {
                        console.error('날짜 변환 오류:', e);
                        return params.value;
                    }
                }
            },
            { headerName: '시장구분', field: 'MRKTCTG', sortable: true, filter: true, width: 100 },
            {
                headerName: '종가',
                field: 'CLPR',
                sortable: true,
                filter: 'agNumberColumnFilter',
                width: 120,
                cellStyle: { 'text-align': 'right' },
                valueFormatter: params => {
                    if (params.value === undefined || params.value === null) return '';
                    return params.value.toLocaleString() + '원';
                }
            },
            {
                headerName: '전일대비',
                field: 'VS',
                sortable: true,
                filter: 'agNumberColumnFilter',
                width: 120,
                cellStyle: params => {
                    const value = params.value || 0;
                    return {
                        color: value >= 0 ? '#dc3545' : '#198754',
                        fontWeight: 'bold',
                        textAlign: 'right'
                    };
                },
                valueFormatter: params => {
                    if (params.value === undefined || params.value === null) return '';
                    const value = params.value;
                    const sign = value >= 0 ? '+' : '';
                    return sign + value.toLocaleString();
                }
            },
            {
                headerName: '등락률',
                field: 'FLTRT',
                sortable: true,
                filter: 'agNumberColumnFilter',
                width: 100,
                cellStyle: params => {
                    const value = params.value || 0;
                    return {
                        color: value >= 0 ? '#dc3545' : '#198754',
                        fontWeight: 'bold',
                        textAlign: 'right'
                    };
                },
                valueFormatter: params => {
                    if (params.value === undefined || params.value === null) return '';
                    const value = params.value;
                    const sign = value >= 0 ? '+' : '';
                    return sign + value.toFixed(2) + '%';
                }
            },
            {
                headerName: '시가',
                field: 'MKP',
                sortable: true,
                filter: 'agNumberColumnFilter',
                width: 120,
                cellStyle: { 'text-align': 'right' },
                valueFormatter: params => {
                    if (params.value === undefined || params.value === null) return '';
                    return params.value.toLocaleString() + '원';
                }
            },
            {
                headerName: '고가',
                field: 'HIPR',
                sortable: true,
                filter: 'agNumberColumnFilter',
                width: 120,
                cellStyle: { 'text-align': 'right' },
                valueFormatter: params => {
                    if (params.value === undefined || params.value === null) return '';
                    return params.value.toLocaleString() + '원';
                }
            },
            {
                headerName: '저가',
                field: 'LOPR',
                sortable: true,
                filter: 'agNumberColumnFilter',
                width: 120,
                cellStyle: { 'text-align': 'right' },
                valueFormatter: params => {
                    if (params.value === undefined || params.value === null) return '';
                    return params.value.toLocaleString() + '원';
                }
            },
            {
                headerName: '거래량',
                field: 'TRQU',
                sortable: true,
                filter: 'agNumberColumnFilter',
                width: 120,
                cellStyle: { 'text-align': 'right' },
                valueFormatter: params => {
                    if (params.value === undefined || params.value === null) return '';
                    return params.value.toLocaleString();
                }
            },
            {
                headerName: '시가총액',
                field: 'MRKTTOTAMT',
                sortable: true,
                filter: 'agNumberColumnFilter',
                width: 150,
                cellStyle: { 'text-align': 'right' },
                valueFormatter: params => {
                    if (params.value === undefined || params.value === null) return 'N/A';
                    return params.value.toLocaleString() + '원';
                }
            },
            {
                headerName: '상세',
                field: 'ISINCD',
                sortable: false,
                filter: false,
                width: 80,
                cellRenderer: params => {
                    return `<a href="/stock/detail?stockCode=${params.value}&date=${params.data.BASDT}" class="btn btn-sm btn-outline-info"><i class="fas fa-info-circle"></i></a>`;
                }
            }
        ];

        // 그리드 옵션
        const gridOptions = {
            columnDefs: columnDefs,
            rowData: stockDataList,
            defaultColDef: {
                resizable: true,
                minWidth: 100,  // 최소 너비 증가
                flex: 1         // flex 속성 추가 (비율에 따라 너비 조정)
            },
            pagination: true,
            paginationPageSize: 15,
            paginationAutoPageSize: false,
            domLayout: 'normal',     // normal로 변경하여 가로 스크롤 적용
            suppressAutoSize: false, // 자동 크기 조정 비활성화
            suppressColumnVirtualisation: true, // 컬럼 가상화 비활성화
            animateRows: true,
            enableCellTextSelection: true,
            suppressMovableColumns: false,
            suppressRowClickSelection: true,
            rowSelection: 'single',
            sortable: true,
            filter: true,
            onGridReady: function(params) {
                // 데이터 로드 후 컬럼 폭 자동 조정
                setTimeout(function() {
                    params.api.sizeColumnsToFit({
                        defaultMinWidth: 100,
                        columnLimits: [
                            { key: 'ISINCD', minWidth: 120 },
                            { key: 'ITMSNM', minWidth: 150 },
                            { key: 'MRKTTOTAMT', minWidth: 150 }
                        ]
                    });
                }, 0);

                // 일자 컬럼을 기준으로 내림차순 정렬
                params.columnApi.applyColumnState({
                    state: [
                        { colId: 'BASDT', sort: 'desc' }
                    ]
                });
            },
            onRowClicked: function(params) {
                console.log('선택된 데이터:', params.data);
            }
        };

        // 그리드 생성
        const gridDiv = document.querySelector('#stockGrid');
            new agGrid.Grid(gridDiv, gridOptions);

            // 커스텀 스타일 적용
            document.head.insertAdjacentHTML('beforeend', `
                <style>
                    .ag-theme-alpine {
                        --ag-font-size: 14px;
                        --ag-font-family: 'Pretendard', -apple-system, BlinkMacSystemFont, system-ui, Roboto, sans-serif;
                        --ag-header-background-color: #343a40;
                        --ag-header-foreground-color: white;
                        --ag-header-font-weight: 600;
                        --ag-row-hover-color: rgba(233, 236, 239, 0.3);
                        --ag-selected-row-background-color: rgba(231, 240, 253, 0.5);
                        --ag-odd-row-background-color: rgba(248, 249, 250, 0.5);
                        --ag-row-border-color: #eee;
                        --ag-cell-horizontal-padding: 10px;

                        /* 가로 스크롤 항상 표시 */
                        overflow-x: auto !important;
                        height: 550px !important; /* 높이 키워 스크롤이 잘 보이도록 함 */
                    }

                    /* 컬럼 헤더 텍스트 스타일 */
                    .ag-header-cell-text {
                        font-size: 15px;
                        white-space: nowrap; /* 헤더 텍스트 줄바꿈 방지 */
                        overflow: visible; /* 오버플로우 표시 */
                    }

                    /* 가로 스크롤바 스타일 */
                    .ag-body-horizontal-scroll {
                        height: 15px !important;
                    }

                    .ag-body-horizontal-scroll-viewport {
                        overflow-x: auto !important;
                    }

                    /* 페이징 스타일 */
                    .ag-paging-panel {
                        font-size: 14px;
                        padding: 10px;
                        background-color: #f8f9fa;
                        border-top: 1px solid #eee;
                    }

                    /* 셀 내용 말줄임 방지 */
                    .ag-cell {
                        white-space: nowrap !important;
                        overflow: visible;
                    }
                </style>
            `);
        }


    function openDetail(stockCode) {
      const url = `stock_detail.html?code=${stockCode}`;
      window.open(url, "popupWindow", "width=600,height=400,resizable=yes,scrollbars=yes");
    }

    document.addEventListener('DOMContentLoaded', function() {
        document.getElementById('btnAnalyze').addEventListener('click', function(e) {
            e.preventDefault();

            // 전체 검색 결과 데이터 활용 (JSP에서 hidden input으로 제공된 데이터)
            const allStockDataJson = document.getElementById('allStockData').value;
            let stockDataList = [];

            console.log("allStockDataJson:::"+allStockDataJson);

            try {
                stockDataList = JSON.parse(allStockDataJson);
            } catch (error) {
                console.error('JSON 파싱 오류:', error);
                alert('데이터 처리 중 오류가 발생했습니다.');
                return;
            }

            // 데이터가 없는 경우 처리
            if (!stockDataList || stockDataList.length === 0) {
                alert('분석할 데이터가 없습니다.');
                return;
            }

            // 진행 중임을 표시
            const analyzeBtn = document.getElementById('btnAnalyze');
            const originalText = analyzeBtn.innerHTML;
            analyzeBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> 분석 중...';
            analyzeBtn.disabled = true;

            // AJAX로 데이터 전송
            fetch('/stock/analysis', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-CSRF-TOKEN': document.querySelector('meta[name="_csrf"]')?.getAttribute('content')
                },
                body: JSON.stringify(stockDataList)
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('서버 응답 오류: ' + response.status);
                }
                return response.json();
            })
            .then(data => {
                // 버튼 상태 복원
                analyzeBtn.innerHTML = originalText;
                analyzeBtn.disabled = false;

                if(data.message === "분석 성공") {

                    // 결과 표시 영역에 데이터 표시
                    displayAnalysisResult(data.result);

                    console.log(" result = {}" , data.result);

                } else {
                    alert("분석 중 오류가 발생했습니다: " + data.errorMessage  + "");
                }
            })
            .catch(error => {
                // 버튼 상태 복원
                analyzeBtn.innerHTML = originalText;
                analyzeBtn.disabled = false;

                console.error('Error:', error);
                alert('요청 처리 중 오류가 발생했습니다.');
            });
        });
    });

    function displayAnalysisResult(data) {
        // 분석 결과 div 표시
        const resultDiv = document.getElementById('mlAnalysisResult');
        resultDiv.style.display = 'block';

        // 결과까지 스크롤
        resultDiv.scrollIntoView({ behavior: 'smooth' });

        console.log("data::", data);

        // 기본 통계 표시
        const basicStats = data.analysis.basic_stats;
        console.log("basicStats::", basicStats);
        console.log("basicStats.data_points::", basicStats.data_points);

        const basicStatsTable = document.getElementById('basicStatsTable');
        // 테이블 내용 초기화
        basicStatsTable.innerHTML = '';

        // 기본 통계 행 추가 함수
        function addBasicStatsRow(label, value) {
            const row = document.createElement('tr');

            const labelCell = document.createElement('td');
            labelCell.textContent = label;

            const valueCell = document.createElement('td');
            valueCell.textContent = value;

            row.appendChild(labelCell);
            row.appendChild(valueCell);
            basicStatsTable.appendChild(row);
        }

        // 기본 통계 데이터 추가
        addBasicStatsRow('데이터 포인트', basicStats.data_points + '개');
        addBasicStatsRow('평균 가격', basicStats.mean_price.toLocaleString() + '원');
        addBasicStatsRow('최고 가격', basicStats.max_price.toLocaleString() + '원');
        addBasicStatsRow('최저 가격', basicStats.min_price.toLocaleString() + '원');
        addBasicStatsRow('평균 거래량', basicStats.volume_mean.toLocaleString());

        // 트렌드 분석 표시
        const trendAnalysis = data.analysis.trend_analysis;
        const trendAnalysisTable = document.getElementById('trendAnalysisTable');
        trendAnalysisTable.innerHTML = '';

        // 트렌드 분석 행 추가 함수
        function addTrendAnalysisRow(label, value) {
            const row = document.createElement('tr');

            const labelCell = document.createElement('td');
            labelCell.textContent = label;

            const valueCell = document.createElement('td');
            valueCell.textContent = value;

            row.appendChild(labelCell);
            row.appendChild(valueCell);
            trendAnalysisTable.appendChild(row);
        }

        // 트렌드 분석 데이터 추가
        addTrendAnalysisRow('단기 이동평균(5일)', trendAnalysis.short_term_ma.toLocaleString() + '원');
        addTrendAnalysisRow('장기 이동평균(20일)', trendAnalysis.long_term_ma.toLocaleString() + '원');
        addTrendAnalysisRow('추세', trendAnalysis.trend);
        addTrendAnalysisRow('거래량 추세', trendAnalysis.volume_trend);

        // 트렌드 표시기
        const trendIndicator = document.getElementById('trendIndicator');
        trendIndicator.innerHTML = '';

        const trendBadgeContainer = document.createElement('h4');
        const trendBadge = document.createElement('span');
        const trendIcon = document.createElement('i');

        // 추세에 따른 스타일 설정
        if (trendAnalysis.trend === '상승세') {
            trendBadge.className = 'badge bg-success';
            trendIcon.className = 'fas fa-arrow-up me-2';
            trendBadge.appendChild(trendIcon);
            trendBadge.appendChild(document.createTextNode('상승세'));
        } else {
            trendBadge.className = 'badge bg-danger';
            trendIcon.className = 'fas fa-arrow-down me-2';
            trendBadge.appendChild(trendIcon);
            trendBadge.appendChild(document.createTextNode('하락세'));
        }

        trendBadgeContainer.appendChild(trendBadge);
        trendIndicator.appendChild(trendBadgeContainer);

        // 가격 예측 표시
        const prediction = data.analysis.prediction;
        const currentPriceElement = document.getElementById('currentPrice');
        currentPriceElement.textContent = prediction.current_price.toLocaleString() + '원';

        // 선형 회귀 예측
        const linearPredictionElement = document.getElementById('linearPrediction');
        linearPredictionElement.textContent = prediction.linear_regression.next_day_price.toLocaleString() + '원';

        const linearDirectionElement = document.getElementById('linearDirection');
        linearDirectionElement.innerHTML = '';

        const linearBadge = document.createElement('span');
        const linearIcon = document.createElement('i');

        if (prediction.linear_regression.direction === '상승') {
            linearBadge.className = 'badge bg-success';
            linearIcon.className = 'fas fa-arrow-up me-1';
            linearBadge.appendChild(linearIcon);
            linearBadge.appendChild(document.createTextNode('상승 예상'));
        } else {
            linearBadge.className = 'badge bg-danger';
            linearIcon.className = 'fas fa-arrow-down me-1';
            linearBadge.appendChild(linearIcon);
            linearBadge.appendChild(document.createTextNode('하락 예상'));
        }

        linearDirectionElement.appendChild(linearBadge);

        const linearAccuracyElement = document.getElementById('linearAccuracy');
        linearAccuracyElement.textContent = prediction.linear_regression.accuracy + '%';

        // 랜덤 포레스트 예측
        const rfPredictionElement = document.getElementById('rfPrediction');
        rfPredictionElement.textContent = prediction.random_forest.next_day_price.toLocaleString() + '원';

        const rfDirectionElement = document.getElementById('rfDirection');
        rfDirectionElement.innerHTML = '';

        const rfBadge = document.createElement('span');
        const rfIcon = document.createElement('i');

        if (prediction.random_forest.direction === '상승') {
            rfBadge.className = 'badge bg-success';
            rfIcon.className = 'fas fa-arrow-up me-1';
            rfBadge.appendChild(rfIcon);
            rfBadge.appendChild(document.createTextNode('상승 예상'));
        } else {
            rfBadge.className = 'badge bg-danger';
            rfIcon.className = 'fas fa-arrow-down me-1';
            rfBadge.appendChild(rfIcon);
            rfBadge.appendChild(document.createTextNode('하락 예상'));
        }

        rfDirectionElement.appendChild(rfBadge);

        const rfAccuracyElement = document.getElementById('rfAccuracy');
        rfAccuracyElement.textContent = prediction.random_forest.accuracy + '%';

        // 위험 지표 표시
        const riskMetrics = data.analysis.risk_metrics;
        const riskMetricsTable = document.getElementById('riskMetricsTable');
        riskMetricsTable.innerHTML = '';

        // 위험 지표 행 추가 함수
        function addRiskMetricsRow(label, value) {
            const row = document.createElement('tr');

            const labelCell = document.createElement('td');
            labelCell.textContent = label;

            const valueCell = document.createElement('td');
            valueCell.textContent = value;

            row.appendChild(labelCell);
            row.appendChild(valueCell);
            riskMetricsTable.appendChild(row);
        }

        // 위험 지표 데이터 추가
        addRiskMetricsRow('변동성', riskMetrics.volatility.toFixed(2) + '%');
        addRiskMetricsRow('최대 낙폭', riskMetrics.max_drawdown.toFixed(2) + '%');

        // 위험 표시기
        const riskIndicator = document.getElementById('riskIndicator');
        riskIndicator.innerHTML = '';

        let riskLevel = '';
        let riskColor = '';
        if (riskMetrics.volatility > 10) {
            riskLevel = '높음';
            riskColor = 'danger';
        } else if (riskMetrics.volatility > 5) {
            riskLevel = '중간';
            riskColor = 'warning';
        } else {
            riskLevel = '낮음';
            riskColor = 'success';
        }

        // 위험 수준 표시 컨테이너
        const riskContainer = document.createElement('div');
        riskContainer.className = 'text-center';

        // 위험 수준 헤더
        const riskHeader = document.createElement('h5');
        riskHeader.textContent = '위험 수준: ';

        // 위험 수준 배지
        const riskBadge = document.createElement('span');
        riskBadge.className = 'badge bg-' + riskColor;
        riskBadge.textContent = riskLevel;

        riskHeader.appendChild(riskBadge);
        riskContainer.appendChild(riskHeader);

        // 프로그레스 바 컨테이너
        const progressContainer = document.createElement('div');
        progressContainer.className = 'progress mt-2';
        progressContainer.style.height = '25px';

        // 프로그레스 바
        const progressBar = document.createElement('div');
        progressBar.className = 'progress-bar bg-' + riskColor;
        progressBar.setAttribute('role', 'progressbar');
        progressBar.style.width = Math.min(riskMetrics.volatility * 5, 100) + '%';
        progressBar.setAttribute('aria-valuenow', riskMetrics.volatility);
        progressBar.setAttribute('aria-valuemin', '0');
        progressBar.setAttribute('aria-valuemax', '100');
        progressBar.textContent = riskMetrics.volatility.toFixed(2) + '%';

        progressContainer.appendChild(progressBar);
        riskContainer.appendChild(progressContainer);
        riskIndicator.appendChild(riskContainer);

        // 특성 중요도 차트
        const featureImportance = prediction.feature_importance;
        const featureImportanceChart = document.getElementById('featureImportanceChart');
        featureImportanceChart.innerHTML = '';

        // 특성 중요도 컨테이너
        const featureContainer = document.createElement('div');
        featureContainer.className = 'row';

        // 특성 중요도 정렬
        const sortedFeatures = Object.entries(featureImportance)
            .sort((a, b) => b[1] - a[1]);

        // 각 특성에 대한 막대 생성
        for (const [feature, importance] of sortedFeatures) {
            const percentImportance = (importance * 100).toFixed(2);
            let featureLabel = feature;

            // 특성 이름 한글화
            switch(feature) {
                case 'CLPR': featureLabel = '종가'; break;
                case 'HIPR': featureLabel = '고가'; break;
                case 'LOPR': featureLabel = '저가'; break;
                case 'MKP': featureLabel = '시가'; break;
                case 'TRQU': featureLabel = '거래량'; break;
                case 'MA5': featureLabel = '5일 이동평균'; break;
                case 'MA20': featureLabel = '20일 이동평균'; break;
                case 'Price_Change': featureLabel = '가격 변화'; break;
                case 'Volume_Change': featureLabel = '거래량 변화'; break;
            }

            // 특성 항목 컨테이너
            const featureItem = document.createElement('div');
            featureItem.className = 'col-md-12 mb-2';

            // 레이블과 프로그레스 바 컨테이너
            const featureRow = document.createElement('div');
            featureRow.className = 'd-flex align-items-center';

            // 레이블 컨테이너
            const labelContainer = document.createElement('div');
            labelContainer.style.width = '120px';
            labelContainer.style.textAlign = 'right';
            labelContainer.style.paddingRight = '10px';
            labelContainer.textContent = featureLabel;

            // 프로그레스 바 컨테이너
            const barContainer = document.createElement('div');
            barContainer.className = 'flex-grow-1';

            const progressWrapper = document.createElement('div');
            progressWrapper.className = 'progress';
            progressWrapper.style.height = '20px';

            const progressBar = document.createElement('div');
            progressBar.className = 'progress-bar bg-info';
            progressBar.setAttribute('role', 'progressbar');
            progressBar.style.width = percentImportance + '%';
            progressBar.setAttribute('aria-valuenow', percentImportance);
            progressBar.setAttribute('aria-valuemin', '0');
            progressBar.setAttribute('aria-valuemax', '100');
            progressBar.textContent = percentImportance + '%';

            progressWrapper.appendChild(progressBar);
            barContainer.appendChild(progressWrapper);

            featureRow.appendChild(labelContainer);
            featureRow.appendChild(barContainer);
            featureItem.appendChild(featureRow);
            featureContainer.appendChild(featureItem);
        }

        featureImportanceChart.appendChild(featureContainer);
    }
</script>
</body>
</html>
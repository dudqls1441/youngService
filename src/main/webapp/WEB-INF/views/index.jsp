<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <meta name="description" content="개인화된 대시보드" />
    <meta name="author" content="" />
    <title>내 대시보드 - 개인화된 정보</title>
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/favicon.ico" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
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

        .welcome-section {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            padding: 2rem;
            border-radius: 0.75rem;
            margin-bottom: 2rem;
            position: relative;
            overflow: hidden;
            box-shadow: 0 4px 20px rgba(67, 97, 238, 0.15);
        }

        .welcome-section::after {
            content: '';
            position: absolute;
            top: 0;
            right: 0;
            width: 30%;
            height: 100%;
            background-image: url('${pageContext.request.contextPath}/api/placeholder/300/300');
            background-size: cover;
            opacity: 0.1;
            border-top-right-radius: 0.75rem;
            border-bottom-right-radius: 0.75rem;
        }

        .welcome-content {
            position: relative;
            z-index: 1;
            max-width: 70%;
        }

        .card {
            border: none;
            border-radius: 0.75rem;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            overflow: hidden;
            margin-bottom: 1.5rem;
            width: 100%;
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }

        .card-header {
            background-color: #fff;
            border-bottom: 1px solid rgba(0,0,0,0.05);
            padding: 1.25rem 1.5rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .card-title {
            font-weight: 600;
            margin-bottom: 0;
            color: var(--text-dark);
            font-size: 1.1rem;
        }

        .section-title {
            font-weight: 600;
            margin-bottom: 1.5rem;
            color: var(--text-dark);
        }

        .stock-item {
            padding: 1rem 1.5rem;
            border-bottom: 1px solid rgba(0,0,0,0.05);
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .stock-item:last-child {
            border-bottom: none;
        }

        .stock-name {
            font-weight: 600;
            margin-bottom: 0.25rem;
        }

        .stock-code {
            font-size: 0.8rem;
            color: var(--text-light);
        }

        .stock-price {
            font-weight: 700;
            font-size: 1.1rem;
        }

        .stock-change {
            font-size: 0.9rem;
            font-weight: 500;
        }

        .price-up {
            color: #dc3545;
        }

        .price-down {
            color: #198754;
        }

        .subway-item {
            padding: 1rem 1.5rem;
            border-bottom: 1px solid rgba(0,0,0,0.05);
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
        }

        .subway-item:last-child {
            border-bottom: none;
        }

        .subway-line {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 700;
            margin-right: 1rem;
        }

        .subway-info {
            flex-grow: 1;
        }

        .subway-station {
            font-weight: 600;
            margin-bottom: 0.25rem;
        }

        .arrival-time {
            font-size: 0.9rem;
            color: var(--text-dark);
        }

        .arrival-direction {
            font-size: 0.8rem;
            color: var(--text-light);
        }

        .weather-info {
            padding: 1.5rem;
            display: flex;
            align-items: center;
        }

        .weather-icon {
            font-size: 3rem;
            margin-right: 1.5rem;
            color: var(--primary-color);
        }

        .weather-temp {
            font-size: 2rem;
            font-weight: 700;
            margin-right: 1rem;
        }

        .weather-details {
            flex-grow: 1;
        }

        .weather-location {
            font-weight: 600;
            margin-bottom: 0.5rem;
        }

        .weather-condition {
            font-size: 0.9rem;
            color: var(--text-dark);
            margin-bottom: 0.5rem;
        }

        .weather-extra {
            display: flex;
            font-size: 0.85rem;
        }

        .weather-extra div {
            margin-right: 1rem;
            color: var(--text-light);
        }

        .recommendation-item {
            display: flex;
            padding: 1rem 1.5rem;
            border-bottom: 1px solid rgba(0,0,0,0.05);
            align-items: center;
        }

        .recommendation-item:last-child {
            border-bottom: none;
        }

        .recommendation-icon {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            background-color: rgba(67, 97, 238, 0.1);
            color: var(--primary-color);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.25rem;
            margin-right: 1rem;
        }

        .recommendation-info {
            flex-grow: 1;
        }

        .recommendation-title {
            font-weight: 600;
            margin-bottom: 0.25rem;
        }

        .recommendation-desc {
            font-size: 0.85rem;
            color: var(--text-light);
        }

        .view-all {
            color: var(--primary-color);
            font-size: 0.875rem;
            font-weight: 500;
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
    <!-- 사이드바 -->
    <div id="sidebar-wrapper">
        <div class="sidebar-heading border-bottom bg-light d-flex align-items-center">
            <i class="fas fa-cube me-2"></i>영빈
        </div>
        <div class="list-group list-group-flush">
            <a class="list-group-item list-group-item-action list-group-item-light active" href="${pageContext.request.contextPath}/">
                <i class="fas fa-home me-2"></i>홈
            </a>
            <a class="list-group-item list-group-item-action list-group-item-light" href="${pageContext.request.contextPath}/dashboard">
                <i class="fas fa-tachometer-alt me-2"></i>지하철 도착 정보
            </a>
            <a class="list-group-item list-group-item-action list-group-item-light" href="${pageContext.request.contextPath}/stockinfo">
                <i class="fas fa-tachometer-alt me-2"></i>주식 종목 정보
            </a>
            <a class="list-group-item list-group-item-action list-group-item-light" href="${pageContext.request.contextPath}/analysis">
                <i class="fas fa-chart-pie me-2"></i>분석
            </a>
            <a class="list-group-item list-group-item-action list-group-item-light" href="/performance">
                <i class="fas fa-chart-pie me-2"></i>주식 비교
            </a>
            <a class="list-group-item list-group-item-action list-group-item-light" href="/managementfootball">
                    <i class="fas fa-futbol me-2"></i>풋살 밸런싱
            </a>
        </div>
    </div>

    <!-- 콘텐츠 래퍼 -->
    <div id="content-wrapper">
        <!-- 상단 내비게이션 -->
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
                            <a class="nav-link active" href="#">
                                <i class="fas fa-home me-1"></i>지하철 도착 정보
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
                                <span class="notification-badge">${notificationCount}</span>
                            </a>
                        </li>
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle d-flex align-items-center" id="navbarDropdown" href="#" role="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                <img src="${pageContext.request.contextPath}/api/placeholder/80/80" alt="Profile" class="profile-thumb me-2">
                                <span>${userName}</span>
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
            <div class="container-fluid">
                <!-- 환영 섹션 -->
                <section class="welcome-section mb-4">
                    <div class="welcome-content">
                        <h2 class="fw-bold mb-2">안녕하세요, ${userName}님!</h2>
                        <p class="mb-4">오늘도 좋은 하루 되세요. 귀하의 대시보드에 새로운 업데이트가 있습니다.</p>
                        <div class="d-flex">
                            <a href="#" class="btn btn-light btn-lg px-4 me-3">
                                <i class="fas fa-plus me-2"></i>새 프로젝트
                            </a>
                            <a href="#" class="btn btn-outline-light btn-lg px-4">
                                <i class="fas fa-chart-line me-2"></i>보고서 보기
                            </a>
                        </div>
                    </div>
                </section>

                <!-- 메인 콘텐츠 -->
                <div class="row">
                    <!-- 왼쪽 컬럼 -->
                    <div class="col-lg-8">
                        <!-- 1. 즐겨찾기 종목의 주가 -->
                        <section class="mb-4">
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="card-title"><i class="fas fa-chart-line me-2"></i>나의 즐겨찾기 종목</h5>
                                    <a href="${pageContext.request.contextPath}/stockinfo" class="view-all">관리하기</a>
                                </div>
                                <div class="card-body p-0">
                                    <c:choose>
                                        <c:when test="${not empty stockList}">
                                            <c:forEach items="${stockList}" var="stock">
                                                <div class="stock-item">
                                                    <div class="stock-info">
                                                        <div class="stock-name">${stock.ITMSNM}</div>
                                                        <div class="stock-code">${stock.SRTNCD}</div>
                                                    </div>
                                                    <div class="text-end">
                                                        <div class="stock-price">
                                                            <fmt:formatNumber value="${stock.CLPR}" type="currency" currencyCode="KRW" />
                                                        </div>
                                                        <div class="stock-change ${stock.VS > 0 ? 'price-up' : 'price-down'}">
                                                            <i class="fas fa-caret-${stock.VS > 0 ? 'up' : 'down'} me-1"></i>
                                                            <fmt:formatNumber value="${stock.VS}" type="number" />원


                                                            (<fmt:formatNumber value="${stock.FLTRT}" type="percent" pattern="0.0'%'"/>)
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="p-3 text-center text-muted">
                                                즐겨찾기한 종목이 없습니다.
                                                <br>
                                                <a href="${pageContext.request.contextPath}/stockinfo" class="btn btn-sm btn-primary mt-2">
                                                    <i class="fas fa-star me-1"></i>즐겨찾기 추가하기
                                                </a>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </section>

                        <!-- 2. 나의 즐겨찾기 역과 호선의 도착정보 -->
                        <section class="mb-4">
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="card-title"><i class="fas fa-subway me-2"></i>나의 즐겨찾기 지하철</h5>
                                    <a href="#" class="view-all">관리하기</a>
                                </div>
                                <div class="card-body p-0">
                                    <!-- 데이터가 있을 때 -->
                                    <c:choose>
                                        <c:when test="${not empty subwayList}">
                                            <c:forEach items="${subwayList}" var="subway">
                                                <div class="subway-item">
                                                    <div class="d-flex align-items-start">
                                                        <c:set var="lineColor" value="#0D6EFD"/>
                                                        <c:set var="shortLineId" value="${subway.SUBWAYID}"/>
                                                        <c:choose>
                                                            <c:when test="${subway.SUBWAYID == '1호선'}">
                                                                <c:set var="lineColor" value="#0052A4"/>
                                                                <c:set var="shortLineId" value="1"/>
                                                            </c:when>
                                                            <c:when test="${subway.SUBWAYID == '2호선'}">
                                                                <c:set var="lineColor" value="#00A84D"/>
                                                                <c:set var="shortLineId" value="2"/>
                                                            </c:when>
                                                            <c:when test="${subway.SUBWAYID == '3호선'}">
                                                                <c:set var="lineColor" value="#EF7C1C"/>
                                                                <c:set var="shortLineId" value="3"/>
                                                            </c:when>
                                                            <c:when test="${subway.SUBWAYID == '4호선'}">
                                                                <c:set var="lineColor" value="#00A4E3"/>
                                                                <c:set var="shortLineId" value="4"/>
                                                            </c:when>
                                                            <c:when test="${subway.SUBWAYID == '5호선'}">
                                                                <c:set var="lineColor" value="#996CAC"/>
                                                                <c:set var="shortLineId" value="5"/>
                                                            </c:when>
                                                            <c:when test="${subway.SUBWAYID == '6호선'}">
                                                                <c:set var="lineColor" value="#CD7C2F"/>
                                                                <c:set var="shortLineId" value="6"/>
                                                            </c:when>
                                                            <c:when test="${subway.SUBWAYID == '7호선'}">
                                                                <c:set var="lineColor" value="#747F00"/>
                                                                <c:set var="shortLineId" value="7"/>
                                                            </c:when>
                                                            <c:when test="${subway.SUBWAYID == '8호선'}">
                                                                <c:set var="lineColor" value="#E6186C"/>
                                                                <c:set var="shortLineId" value="8"/>
                                                            </c:when>
                                                            <c:when test="${subway.SUBWAYID == '9호선'}">
                                                                <c:set var="lineColor" value="#BDB092"/>
                                                                <c:set var="shortLineId" value="9"/>
                                                            </c:when>
                                                        </c:choose>

                                                        <div class="subway-line" style="background-color: ${lineColor};">${shortLineId}</div>
                                                        <div class="subway-info">
                                                            <div class="subway-station">${subway.STATNID}</div>
                                                            <div class="arrival-direction">
                                                                <c:choose>
                                                                    <c:when test="${subway.UPDNLINE eq 'up'}">상행</c:when>
                                                                    <c:when test="${subway.UPDNLINE eq 'down'}">하행</c:when>
                                                                    <c:otherwise>${subway.UPDNLINE}</c:otherwise>
                                                                </c:choose>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="text-end">
                                                        <button class="btn btn-sm btn-outline-primary me-2"
                                                                onclick="loadSubwayInfo('${subway.SUBWAYID}', '${subway.STATNID}', '${subway.UPDNLINE}')">
                                                            <i class="fas fa-search me-1"></i>조회
                                                        </button>
                                                        <button class="btn btn-sm btn-outline-primary">
                                                            <i class="fas fa-bell me-1"></i>알림
                                                        </button>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <!-- 데이터가 없을 때 보여줄 내용 -->
                                            <div class="p-4 text-center">
                                                <i class="fas fa-info-circle text-muted mb-3" style="font-size: 2rem;"></i>
                                                <p class="mb-0">등록된 즐겨찾기가 없습니다.</p>
                                                <p class="text-muted">지하철 정보 페이지에서 즐겨찾기를 추가해보세요.</p>
                                                <a href="/dashboard" class="btn btn-sm btn-primary mt-2">
                                                    <i class="fas fa-plus me-1"></i>즐겨찾기 추가하기
                                                </a>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </section>
                    </div>

                    <!-- 오른쪽 컬럼 -->
                    <div class="col-lg-4">
                        <!-- 3. 날씨 정보 -->
                        <section class="mb-4">
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="card-title"><i class="fas fa-cloud-sun me-2"></i>날씨 정보</h5>
                                    <div class="dropdown">
                                        <button class="btn btn-sm btn-outline-secondary dropdown-toggle" type="button" id="locationDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                                            ${selectedLocation}
                                        </button>
                                        <ul class="dropdown-menu" aria-labelledby="locationDropdown">
                                            <c:forEach items="${locationList}" var="location">
                                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/api/weather?location=${location}">${location}</a></li>
                                            </c:forEach>
                                        </ul>
                                    </div>
                                </div>
                                <div class="card-body">
                                    <div class="weather-info">
                                        <div class="weather-icon">
                                            <i class="fas fa-${weather.icon}"></i>
                                        </div>
                                        <div class="weather-temp">${weather.temperature}°</div>
                                        <div class="weather-details">
                                            <div class="weather-location">${weather.district}, ${weather.city}</div>
                                            <div class="weather-condition">${weather.condition} / 최고 ${weather.maxTemp}° 최저 ${weather.minTemp}°</div>
                                            <div class="weather-extra">
                                                <div><i class="fas fa-tint me-1"></i>습도 ${weather.humidity}%</div>
                                                <div><i class="fas fa-wind me-1"></i>풍속 ${weather.windSpeed}m/s</div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row text-center mt-3">
                                        <c:forEach items="${weather.forecast}" var="forecast">
                                            <div class="col">
                                                <div class="small text-muted">${forecast.timeOfDay}</div>
                                                <div><i class="fas fa-${forecast.icon}"></i> ${forecast.temperature}°</div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                            </div>
                        </section>

                        <!-- 4. 추천 정보 -->
                        <section class="mb-4">
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="card-title"><i class="fas fa-lightbulb me-2"></i>맞춤 추천</h5>
                                    <a href="#" class="view-all">더보기</a>
                                </div>
                                <div class="card-body p-0">
                                    <c:forEach items="${recommendationList}" var="recommendation">
                                        <div class="recommendation-item">
                                            <div class="recommendation-icon">
                                                <i class="fas fa-${recommendation.icon}"></i>
                                            </div>
                                            <div class="recommendation-info">
                                                <div class="recommendation-title">${recommendation.title}</div>
                                                <div class="recommendation-desc">${recommendation.description}</div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </section>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap core JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

<!-- 컴포넌트 로드 스크립트 -->
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // 토글 기능 설정
        document.body.addEventListener('click', function(e) {
            if (e.target.id === 'sidebarToggle' || e.target.closest('#sidebarToggle')) {
                e.preventDefault();
                document.getElementById('sidebar-wrapper').classList.toggle('toggled');
                document.getElementById('content-wrapper').classList.toggle('toggled');
            }
        });
    });

    $(document).ready(function() {
        // 드롭다운 메뉴 항목 클릭 시 이벤트 처리
        $('.dropdown-item').click(function(e) {
            e.preventDefault();
            const location = $(this).text();

            console.log("location");
            console.log(location);

            // AJAX 요청으로 날씨 정보만 업데이트
            $.ajax({
                url: '/api/weather',
                data: { location: location },
                dataType: 'json',  // 명시적으로 JSON 형식 지정
                success: function(data) {
                    // 날씨 정보 업데이트
                    updateWeatherUI(data, location);
                },
                error: function(xhr, status, error) {
                    console.error("AJAX 요청 실패:", error);
                }
            });
        });

        function updateWeatherUI(data, location) {
            console.log("weather::", data);
            const weather = data.weathers;

            // 여기서 날씨 정보를 표시하는 UI 요소들을 업데이트
            $('.weather-temp').text(weather.temperature + '°');
            $('.weather-location').text(weather.district + ', ' + weather.city);
            $('.weather-condition').text(weather.condition + ' / 최고 ' + weather.maxTemp + '° 최저 ' + weather.minTemp + '°');
            $('.weather-icon i').attr('class', 'fas fa-' + weather.icon);

            // 예보 업데이트
            const $forecastCols = $('.row.text-center.mt-3 .col');
            if (weather.forecast) {
                weather.forecast.forEach((forecast, index) => {
                    if (index < $forecastCols.length) {
                        console.log("테스트");
                        console.log(forecast.timeOfDay); // ${forecast.timeOfDay} 대신 forecast.timeOfDay 사용
                        $forecastCols.eq(index).html(
                            '<div class="small text-muted">' + forecast.timeOfDay + '</div>' +
                            '<div><i class="fas fa-' + forecast.icon + '"></i> ' + forecast.temperature + '°</div>'
                        );
                    }
                });
            }

            // 습도, 풍속 업데이트
            $('.weather-extra div:eq(0)').html(`<i class="fas fa-tint me-1"></i>습도 ${weather.humidity}%`);
            $('.weather-extra div:eq(1)').html(`<i class="fas fa-wind me-1"></i>풍속 ${weather.windSpeed}m/s`);

            // 선택된 위치 표시 업데이트
            $('#locationDropdown').text(location);
        }
    });

   function loadSubwayInfo(subwayId, stationId, updnLine) {
        // 지하철 정보 로드 함수 - 구현이 필요합니다
        console.log("지하철 정보 로드:", subwayId, stationId, updnLine);

        // 예시: 지하철 페이지로 이동

    }
</script>
</body>
</html>
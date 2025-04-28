<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <title>지하철 도착 정보 및 위치 지도</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.2.3/css/bootstrap.min.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <script src="https://oapi.map.naver.com/openapi/v3/maps.js?ncpClientId=q7miukj4h8"></script>
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

        /* 원래 대시보드 스타일 유지 */
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        .header {
            background-color: #0d6efd;
            color: white;
            padding: 20px 0;
            margin-bottom: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .main-title {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 0;
            text-align: center;
        }

        .search-card {
            background-color: white;
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 30px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
        }

        .map-container {
            background-color: white;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 30px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
        }

        .section-title {
            color: #0d6efd;
            font-weight: 600;
            margin-bottom: 20px;
            border-bottom: 2px solid #e9ecef;
            padding-bottom: 10px;
        }

        .train-card {
            border-radius: 12px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            transition: transform 0.2s;
            margin-bottom: 16px;
            border-left: 5px solid #0d6efd;
            overflow: hidden;
            background-color: white;
        }

        .train-card:hover {
            transform: translateY(-3px);
        }

        .train-header {
            background-color: #f8f9fa;
            padding: 12px 20px;
            border-bottom: 1px solid rgba(0,0,0,0.1);
            font-weight: 600;
        }

        .train-body {
            padding: 16px 20px;
        }

        .line-badge {
            font-size: 0.85rem;
            border-radius: 50px;
            padding: 4px 12px;
            margin-right: 8px;
            color: white;
            background-color: #0d6efd;
        }

        .status-icon {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            margin-right: 10px;
            color: white;
        }

        .status-arriving {
            background-color: #dc3545;
        }

        .status-approaching {
            background-color: #fd7e14;
        }

        .status-distant {
            background-color: #198754;
        }

        .info-row {
            display: flex;
            align-items: center;
            margin-bottom: 10px;
        }

        .info-row:last-child {
            margin-bottom: 0;
        }

        .info-label {
            width: 100px;
            color: #6c757d;
            font-weight: 500;
        }

        .station-name {
            font-size: 1.2rem;
            font-weight: 700;
        }

        .train-direction {
            font-size: 0.9rem;
            color: #6c757d;
        }

        .time-badge {
            border-radius: 4px;
            padding: 5px 10px;
            font-weight: 600;
            background-color: #e9ecef;
        }

        .bookmark-btn {
            position: absolute;
            top: 15px;
            right: 15px;
            font-size: 1.2rem;
            color: #ffc107;
            background: none;
            border: none;
            cursor: pointer;
        }

        .no-results {
            text-align: center;
            padding: 30px;
            background-color: #f8f9fa;
            border-radius: 12px;
            margin-top: 20px;
        }

        .favorites-container {
            background-color: white;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 30px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
        }

        .favorites-title {
            color: #ffc107;
            margin-bottom: 15px;
            font-weight: 600;
        }

        .btn-primary {
            background-color: #0d6efd;
            border-color: #0077ff;
        }

        .btn-primary:hover {
            background-color: #0b5ed7;
            border-color: #0b5ed7;
        }

        footer {
            text-align: center;
            padding: 20px 0;
            margin-top: 50px;
            color: #6c757d;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 -2px 10px rgba(0, 0, 0, 0.05);
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
            <a class="list-group-item list-group-item-action list-group-item-light active" href="/dashboard">
                <i class="fas fa-tachometer-alt me-2"></i>지하철 도착 정보
            </a>
            <a class="list-group-item list-group-item-action list-group-item-light" href="/stockinfo">
                <i class="fas fa-tachometer-alt me-2"></i>주식 종목 정보
            </a>
            <a class="list-group-item list-group-item-action list-group-item-light" href="/analysis">
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
                            <a class="nav-link active" href="#">
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
            <!-- 여기서부터 원래 대시보드의 콘텐츠 영역 -->
            <div class="container">
                <!-- 헤더 -->
                <header class="header text-center">
                    <h1 class="main-title">🚇 지하철 도착 정보 및 위치 지도</h1>
                    <p class="text-white mt-2">실시간으로 지하철 도착 정보와 위치를 확인하세요</p>
                </header>

                <!-- 즐겨찾기 섹션 -->
                <section class="favorites-container">
                    <h3 class="favorites-title">⭐ 즐겨 찾기</h3>
                    <ul class="list-group" id="favoritesList">
                        <li class="list-group-item d-flex justify-content-between align-items-center">
                            2호선 강남역
                            <div>
                                <button class="btn btn-sm btn-outline-danger me-2" onclick="removeFavorite('2호선', '강남역')">➖ 삭제</button>
                            </div>
                        </li>
                        <li class="list-group-item d-flex justify-content-between align-items-center">
                            9호선 국회의사당역
                            <div>
                                <button class="btn btn-sm btn-outline-danger me-2" onclick="removeFavorite('9호선', '국회의사당역')">➖ 삭제</button>
                            </div>
                        </li>
                    </ul>
                </section>

                <!-- 조회 폼 -->
                <section class="search-card">
                    <h3 class="section-title">🔍 지하철 도착 정보 조회</h3>
                    <form id="subwayForm" action="/subway" method="get" onsubmit="return getStationLocation();">
                        <div class="row align-items-end g-3">
                            <div class="col-md-3">
                                <label for="subwayId" class="form-label">지하철 노선</label>
                                <input type="text" class="form-control" id="subwayId" name="subwayId" placeholder="예: 1호선" value="${subwayId}" required>
                            </div>
                            <div class="col-md-3">
                                <label for="statnId" class="form-label">지하철역 ID</label>
                                <input type="text" class="form-control" id="statnId" name="statnId" placeholder="예: 가산디지털단지" value="${statnId}" required>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label d-block">상행 / 하행</label>
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="updnLine" value="상행" checked>
                                    <label class="form-check-label">상행</label>
                                </div>
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="updnLine" value="하행" >
                                    <label class="form-check-label">하행</label>
                                </div>
                            </div>
                            <div class="col-md-3 d-flex gap-2">
                                <button type="submit" name="action" value="check" class="btn btn-primary w-50">
                                    <i class="fas fa-search me-1"></i> 조회
                                </button>
                                <button type="submit" name="action" value="bookmark" class="btn btn-warning w-50">
                                    <i class="fas fa-star me-1"></i> 즐겨찾기 추가
                                </button>
                            </div>
                        </div>
                    </form>
                </section>

                <!-- 결과 출력 -->
                <section class="search-card" id="resultArea">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h3 class="section-title mb-0"><i class="fas fa-train text-primary me-2"></i> 지하철 도착 정보</h3>
                        <span class="badge bg-secondary">
                            <i class="fas fa-clock me-1"></i> 조회시간:
                            <span id="current-time"></span>
                        </span>
                    </div>

                    <!-- JSP에서 resultList가 비어있는지 확인 -->
                    <c:choose>
                        <c:when test="${empty resultList}">
                            <div class="no-results">
                                <i class="fas fa-exclamation-circle text-warning mb-3" style="font-size: 3rem;"></i>
                                <h5>도착 정보가 없습니다</h5>
                                <p class="text-muted">노선과 역을 선택하여 정보를 조회해주세요.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <!-- 결과가 있는 경우 표시 -->
                            <div class="row">
                                <c:forEach var="item" items="${resultList}">
                                    <div class="col-12">
                                        <div class="train-card position-relative">
                                            <button class="bookmark-btn">
                                                <i class="far fa-star"></i>
                                            </button>

                                            <div class="train-header">
                                                <c:set var="lineColor" value="#0D6EFD"/>
                                                <c:choose>
                                                    <c:when test="${item.subwayId == '1호선'}"><c:set var="lineColor" value="#0052A4"/></c:when>
                                                    <c:when test="${item.subwayId == '2호선'}"><c:set var="lineColor" value="#00A84D"/></c:when>
                                                    <c:when test="${item.subwayId == '3호선'}"><c:set var="lineColor" value="#EF7C1C"/></c:when>
                                                    <c:when test="${item.subwayId == '4호선'}"><c:set var="lineColor" value="#00A4E3"/></c:when>
                                                    <c:when test="${item.subwayId == '5호선'}"><c:set var="lineColor" value="#996CAC"/></c:when>
                                                    <c:when test="${item.subwayId == '6호선'}"><c:set var="lineColor" value="#CD7C2F"/></c:when>
                                                    <c:when test="${item.subwayId == '7호선'}"><c:set var="lineColor" value="#747F00"/></c:when>
                                                    <c:when test="${item.subwayId == '8호선'}"><c:set var="lineColor" value="#E6186C"/></c:when>
                                                    <c:when test="${item.subwayId == '9호선'}"><c:set var="lineColor" value="#BDB092"/></c:when>
                                                </c:choose>
                                                <span class="line-badge" style="background-color: ${lineColor};">${item.subwayId}</span>
                                                <span class="station-name">${item.statnNm}</span>
                                                <span class="train-direction">(${item.trainLineNm})</span>
                                            </div>

                                            <div class="train-body">
                                                <div class="info-row">
                                                    <c:set var="statusClass" value="status-distant"/>
                                                    <c:set var="iconClass" value="fas fa-clock"/>
                                                    <c:choose>
                                                        <c:when test="${fn:contains(item.arvlMsg2, '도착')}">
                                                            <c:set var="statusClass" value="status-arriving"/>
                                                            <c:set var="iconClass" value="fas fa-train"/>
                                                        </c:when>
                                                        <c:when test="${fn:contains(item.arvlMsg2, '분') && (fn:contains(item.arvlMsg2, '1분') || fn:contains(item.arvlMsg2, '2분'))}">
                                                            <c:set var="statusClass" value="status-approaching"/>
                                                            <c:set var="iconClass" value="fas fa-running"/>
                                                        </c:when>
                                                    </c:choose>
                                                    <div class="status-icon ${statusClass}">
                                                        <i class="${iconClass}"></i>
                                                    </div>
                                                    <div>
                                                        <div class="mb-1">
                                                            <span class="info-label">현재 위치</span>
                                                            <span class="fw-bold">${item.arvlMsg3}</span>
                                                        </div>
                                                        <div>
                                                            <span class="info-label">도착 예정</span>
                                                            <span class="time-badge">${item.arvlMsg2}</span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </section>

                <!-- 지도 출력 영역 -->
                <section class="map-container">
                    <h3 class="section-title">🗺 해당 역 지도</h3>
                    <div id="mapPlace" style="width: 100%; height: 400px;" class="border rounded">
                        <!-- 지도 위 버튼 (현재 위치로 이동) -->
                        <div id="currentLocationBtn" style="position: absolute; top: 10px; right: 10px; z-index: 1000;">
                            <button class="btn btn-light btn-sm shadow-sm">📍 현재 위치</button>
                        </div>
                    </div>
                </section>

                <!-- 푸터 -->
                <footer>
                    <p>© 2025 지하철 도착 정보 서비스. All rights reserved.</p>
                    <p class="small">실시간 데이터는 매 10초마다 자동 갱신됩니다.</p>
                </footer>
            </div>
        </div>
    </div>
</div>

<!-- JS -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.2.3/js/bootstrap.bundle.min.js"></script>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        // 사이드바 토글 설정
        document.getElementById('sidebarToggle').addEventListener('click', function(e) {
            e.preventDefault();
            document.getElementById('sidebar-wrapper').classList.toggle('toggled');
            document.getElementById('content-wrapper').classList.toggle('toggled');
        });

        // 시간 업데이트 시작
        updateCurrentTime();
        setInterval(updateCurrentTime, 1000);

        // 각 기능 초기화
        setupCurrentLocationButton();
        setupSubwayForm();
        startAutoRefresh();
    });

    // 현재 검색 조건을 관리할 전역 변수
    let currentSearchParams = {
        subwayId: "",
        statnId: "",
        updnLine: "상행"
    };

    // 자동 갱신 ID를 저장할 변수
    let refreshIntervalId;

    // 현재 시간 표시 함수
    function updateCurrentTime() {
        const now = new Date();
        const timeString = now.getFullYear() + '-' +
            padZero(now.getMonth() + 1) + '-' +
            padZero(now.getDate()) + ' ' +
            padZero(now.getHours()) + ':' +
            padZero(now.getMinutes()) + ':' +
            padZero(now.getSeconds());

        const el = document.getElementById('current-time');
        if (el) {
            el.textContent = timeString;
        }
    }

    // 숫자 앞에 0 붙이기
    function padZero(num) {
        return num < 10 ? '0' + num : num;
    }

    // 폼 설정 함수
    function setupSubwayForm() {
        document.getElementById('subwayForm').addEventListener('submit', function(e) {
            e.preventDefault(); // 기본 폼 제출 방지

            // 폼 데이터 가져오기
            const subwayId = document.getElementById('subwayId').value;
            const statnId = document.getElementById('statnId').value;
            const updnLine = document.querySelector('input[name="updnLine"]:checked').value;
            const action = e.submitter.value; // 어떤 버튼이 눌렸는지 확인

            console.log("updnLine:::"+updnLine);
            console.log("statnId:::"+statnId);
            console.log("action:::"+action);

            // 현재 검색 조건 업데이트
            currentSearchParams = {
                subwayId: subwayId,
                statnId: statnId,
                updnLine: updnLine
            };

            // 액션에 따라 다르게 처리
            if (action === 'check') {
                // 지하철 조회 데이터 요청
                fetchSubwayInfo(subwayId, statnId, updnLine);
                // 지도 위치 업데이트
                getStationLocation(statnId);
            } else if (action === 'bookmark') {
                // 즐겨찾기 추가
                addToBookmarks(subwayId, statnId, updnLine);
            }
        });
    }

    // 지하철 도착 정보 가져오기
    function fetchSubwayInfo(subwayId, statnId, updnLine) {
        // 로딩 인디케이터 표시
        document.getElementById('resultArea').innerHTML = `
            <div class="d-flex justify-content-center my-5">
                <div class="spinner-border text-primary" role="status">
                    <span class="visually-hidden">Loading...</span>
                </div>
            </div>
        `;

        // API 호출
        fetch('/subway/api/arrivalInfo?subwayId=' + encodeURIComponent(subwayId) +
              '&statnId=' + encodeURIComponent(statnId) +
              '&updnLine=' + encodeURIComponent(updnLine))
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }
                return response.json();
            })
            .then(data => {
                if (data.success) {
                    updateSubwayResults(data.data, subwayId, statnId, updnLine);
                } else {
                    showError(data.error || '데이터를 가져오는 중 오류가 발생했습니다.');
                }
            })
            .catch(error => {
                console.error('데이터 가져오기 오류:', error);
                showError('서버 통신 중 오류가 발생했습니다.');
            });
    }

    // 도착 정보 결과 업데이트
    function updateSubwayResults(resultList, subwayId, statnId, updnLine) {
        const resultArea = document.getElementById('resultArea');
        const timeString = getCurrentTimeString();

        // 결과가 없는 경우
        if (!resultList || resultList.length === 0) {
            resultArea.innerHTML =
                '<div class="d-flex justify-content-between align-items-center mb-3">' +
                    '<h3 class="section-title mb-0"><i class="fas fa-train text-primary me-2"></i> 지하철 도착 정보</h3>' +
                    '<span class="badge bg-secondary">' +
                        '<i class="fas fa-clock me-1"></i> 조회시간: ' + timeString +
                    '</span>' +
                '</div>' +
                '<div class="no-results">' +
                    '<i class="fas fa-exclamation-circle text-warning mb-3" style="font-size: 3rem;"></i>' +
                    '<h5>도착 정보가 없습니다</h5>' +
                    '<p class="text-muted">노선과 역을 선택하여 정보를 조회해주세요.</p>' +
                '</div>';
            return;
        }

        // 결과가 있는 경우 HTML 생성
        let resultsHTML =
            '<div class="d-flex justify-content-between align-items-center mb-3">' +
                '<h3 class="section-title mb-0"><i class="fas fa-train text-primary me-2"></i> 지하철 도착 정보</h3>' +
                '<span class="badge bg-secondary">' +
                    '<i class="fas fa-clock me-1"></i> 조회시간: ' + timeString +
                '</span>' +
            '</div>' +
            '<div class="row">';

        // 각 결과 항목에 대한 HTML 생성
        resultList.forEach(item => {
            const lineColor = getLineColor(item.subwayId);
            const statusClass = getStatusClass(item.arvlMsg2);
            const statusIcon = getStatusIcon(item.arvlMsg2);

            resultsHTML +=
                '<div class="col-12">' +
                    '<div class="train-card position-relative">' +
                        '<button class="bookmark-btn" data-line="' + item.subwayId + '" data-station="' + item.statnNm + '">' +
                            '<i class="far fa-star"></i>' +
                        '</button>' +
                        '<div class="train-header">' +
                            '<span class="line-badge" style="background-color: ' + lineColor + ';">' + item.subwayId + '</span>' +
                            '<span class="station-name">' + item.statnNm + '</span>' +
                            '<span class="train-direction">(' + item.trainLineNm + ')</span>' +
                        '</div>' +
                        '<div class="train-body">' +
                            '<div class="info-row">' +
                                '<div class="status-icon ' + statusClass + '">' +
                                    '<i class="' + statusIcon + '"></i>' +
                                '</div>' +
                                '<div>' +
                                    '<div class="mb-1">' +
                                        '<span class="info-label">현재 위치</span>' +
                                        '<span class="fw-bold">' + item.arvlMsg3 + '</span>' +
                                    '</div>' +
                                    '<div>' +
                                        '<span class="info-label">도착 예정</span>' +
                                        '<span class="time-badge">' + item.arvlMsg2 + '</span>' +
                                    '</div>' +
                                '</div>' +
                            '</div>' +
                        '</div>' +
                    '</div>' +
                '</div>';
        });

        resultsHTML += '</div>';
        resultArea.innerHTML = resultsHTML;
    }

    // 노선 색상 가져오기
    function getLineColor(subwayId) {
        const colorMap = {
            '1호선': '#0052A4',
            '2호선': '#00A84D',
            '3호선': '#EF7C1C',
            '4호선': '#00A4E3',
            '5호선': '#996CAC',
            '6호선': '#CD7C2F',
            '7호선': '#747F00',
            '8호선': '#E6186C',
            '9호선': '#BDB092'
        };
        return colorMap[subwayId] || '#0D6EFD';
    }

    // 상태 클래스 가져오기
    function getStatusClass(arvlMsg) {
        if (arvlMsg.includes('도착')) {
            return 'status-arriving';
        } else if (arvlMsg.includes('분') && (arvlMsg.includes('1분') || arvlMsg.includes('2분'))) {
            return 'status-approaching';
        } else {
            return 'status-distant';
        }
    }

    // 상태 아이콘 가져오기
    function getStatusIcon(arvlMsg) {
        if (arvlMsg.includes('도착')) {
            return 'fas fa-train';
        } else if (arvlMsg.includes('분') && (arvlMsg.includes('1분') || arvlMsg.includes('2분'))) {
            return 'fas fa-running';
        } else {
            return 'fas fa-clock';
        }
    }

    // 자동 갱신 시작 함수
    function startAutoRefresh() {
        // 이미 실행 중인 갱신이 있다면 중지
        if (refreshIntervalId) {
            clearInterval(refreshIntervalId);
        }

        // 10초마다 데이터 갱신
        refreshIntervalId = setInterval(function() {
            // 검색 조건이 비어있지 않은 경우에만 갱신
            if (currentSearchParams.subwayId && currentSearchParams.statnId) {
                fetchSubwayInfo(
                    currentSearchParams.subwayId,
                    currentSearchParams.statnId,
                    currentSearchParams.updnLine
                );
            }
        }, 10000);
    }

    // 자동 갱신 중지 함수
    function stopAutoRefresh() {
        if (refreshIntervalId) {
            clearInterval(refreshIntervalId);
            refreshIntervalId = null;
        }
    }

    // 지하철역 위치 검색 및 지도 이동
    function getStationLocation(stationName) {
        fetch('/subway/searchLocation?stationName=' + encodeURIComponent(stationName))
                .then(response => response.json())
            .then(data => {
                if (data.success && data.lat && data.lng) {
                    const latLng = new naver.maps.LatLng(data.lat, data.lng);
                    map.setCenter(latLng);

                    if (currentMarker) currentMarker.setMap(null);

                    currentMarker = new naver.maps.Marker({
                        position: latLng,
                        map: map,
                        title: data.stationName
                    });
                } else {
                    console.warn("역 위치 정보를 찾을 수 없습니다.");
                }
            })
            .catch(error => {
                console.error("역 위치 검색 오류:", error);
            });
    }

    // 북마크 클릭 이벤트 처리를 위한 이벤트 위임
    document.addEventListener('click', function(e) {
        // 클릭된 요소나 그 부모가 .bookmark-btn인지 확인
        const bookmarkBtn = e.target.closest('.bookmark-btn');
        if (bookmarkBtn) {
            e.preventDefault();

            const line = bookmarkBtn.dataset.line;
            const station = bookmarkBtn.dataset.station;

            if (!line || !station) {
                console.warn("버튼에 필요한 데이터 속성이 없습니다!");
                return;
            }

            const icon = bookmarkBtn.querySelector('i');
            if (!icon) {
                console.warn("아이콘을 찾을 수 없습니다!");
                return;
            }

            const isCurrentlyFavorite = icon.classList.contains('fas');

            // 즐겨찾기 토글
            toggleBookmark(line, station, isCurrentlyFavorite);

            // 아이콘 시각적 업데이트
            if (isCurrentlyFavorite) {
                icon.classList.remove('fas');
                icon.classList.add('far');
            } else {
                icon.classList.remove('far');
                icon.classList.add('fas');
            }
        }
    });

    // 즐겨찾기 추가/삭제
    function toggleBookmark(line, station, isCurrentlyFavorite) {
        const action = isCurrentlyFavorite ? 'remove' : 'add';

        fetch('/subway/bookmark', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'line=' + encodeURIComponent(line) +
                  '&station=' + encodeURIComponent(station) +
                  '&action=' + action
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                // 즐겨찾기 목록 새로고침
                refreshFavoritesList();
            } else {
                console.error('즐겨찾기 처리 실패:', data.error);
            }
        })
        .catch(error => {
            console.error('즐겨찾기 처리 중 오류:', error);
        });
    }

    // 즐겨찾기 목록 새로고침
    function refreshFavoritesList() {
        fetch('/subway/favorites')
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    updateFavoritesUI(data.favorites);
                }
            })
            .catch(error => {
                console.error('즐겨찾기 목록 가져오기 오류:', error);
            });
    }

    // 즐겨찾기 목록 UI 업데이트
    function updateFavoritesUI(favorites) {
        const favoritesList = document.getElementById('favoritesList');

        if (!favorites || favorites.length === 0) {
            favoritesList.innerHTML = '<li class="list-group-item text-center text-muted">즐겨찾기 항목이 없습니다</li>';
            return;
        }

        let html = '';
        favorites.forEach(fav => {
            html +=
                '<li class="list-group-item d-flex justify-content-between align-items-center">' +
                    fav.line + ' ' + fav.station +
                    '<div>' +
                        '<button class="btn btn-sm btn-outline-primary me-2" ' +
                                'onclick="loadFavorite(\'' + fav.line + '\', \'' + fav.station + '\')">' +
                            '🔍 조회' +
                        '</button>' +
                        '<button class="btn btn-sm btn-outline-danger" ' +
                                'onclick="removeFavorite(\'' + fav.line + '\', \'' + fav.station + '\')">' +
                            '➖ 삭제' +
                        '</button>' +
                    '</div>' +
                '</li>';
        });

        favoritesList.innerHTML = html;
    }

    // 즐겨찾기 항목 로드 및 조회
    function loadFavorite(line, station) {
        document.getElementById('subwayId').value = line;
        document.getElementById('statnId').value = station;

        // 폼 제출 (조회 실행)
        const submitBtn = document.querySelector('button[value="check"]');
        if (submitBtn) {
            submitBtn.click();
        } else {
            // 직접 데이터 요청
            fetchSubwayInfo(line, station, '상행');
            getStationLocation(station);
        }
    }

    // 즐겨찾기 삭제
    function removeFavorite(line, station) {
        if (confirm(`정말로 ${line} ${station}을(를) 즐겨찾기에서 삭제하시겠습니까?`)) {
            fetch('/subway/bookmark', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'line=' + encodeURIComponent(line) +
                      '&station=' + encodeURIComponent(station) +
                      '&action=remove'
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    refreshFavoritesList();
                } else {
                    alert('즐겨찾기 삭제 실패: ' + (data.error || '알 수 없는 오류'));
                }
            })
            .catch(error => {
                console.error('즐겨찾기 삭제 중 오류:', error);
                alert('즐겨찾기 삭제 중 오류가 발생했습니다.');
            });
        }
    }

    // 즐겨찾기 추가
    function addToBookmarks(line, station, updnLine) {
        console.log("addToBookmarks 함수 start");
        console.log("addToBookmarks 함수 start {}", line, station, updnLine);
        fetch('/subway/bookmark', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'line=' + encodeURIComponent(line) +
                  '&station=' + encodeURIComponent(station) +
                  '&updnLine=' + encodeURIComponent(updnLine) +
                  '&action=add'
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                alert(`${line} ${station}이(가) 즐겨찾기에 추가되었습니다.`);
                refreshFavoritesList();
            } else {
                alert('즐겨찾기 추가 실패: ' + (data.error || '알 수 없는 오류'));
            }
        })
        .catch(error => {
            console.error('즐겨찾기 추가 중 오류:', error);
            alert('즐겨찾기 추가 중 오류가 발생했습니다.');
        });
    }

    // 현재 위치 버튼 설정 - 한 곳에서만 이벤트를 설정하도록 통합
    function setupCurrentLocationButton() {
        document.getElementById('currentLocationBtn').addEventListener('click', function() {
            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(function(position) {
                    const lat = position.coords.latitude;
                    const lng = position.coords.longitude;
                    const userLocation = new naver.maps.LatLng(lat, lng);

                    map.setCenter(userLocation);

                    if (currentMarker) currentMarker.setMap(null);

                    currentMarker = new naver.maps.Marker({
                        position: userLocation,
                        map: map,
                        icon: {
                            content: '<div style="background-color:#4285f4;padding:4px 8px;color:#fff;border-radius:4px;">🧍</div>',
                            size: new naver.maps.Size(22, 22),
                            anchor: new naver.maps.Point(11, 11)
                        }
                    });
                }, function(error) {
                    alert("위치 정보를 가져올 수 없습니다: " + error.message);
                });
            } else {
                alert("브라우저가 위치 정보를 지원하지 않습니다.");
            }
        });
    }

    // 오류 표시
    function showError(message) {
        document.getElementById('resultArea').innerHTML =
            '<div class="d-flex justify-content-between align-items-center mb-3">' +
                '<h3 class="section-title mb-0"><i class="fas fa-train text-primary me-2"></i> 지하철 도착 정보</h3>' +
                '<span class="badge bg-secondary">' +
                    '<i class="fas fa-clock me-1"></i> 조회시간: ' + getCurrentTimeString() +
                '</span>' +
            '</div>' +
            '<div class="alert alert-danger">' +
                '<i class="fas fa-exclamation-triangle me-2"></i> ' + message +
            '</div>';
    }

    // 현재 시간 문자열 가져오기
    function getCurrentTimeString() {
        const now = new Date();
        return now.getFullYear() + '-' +
            padZero(now.getMonth() + 1) + '-' +
            padZero(now.getDate()) + ' ' +
            padZero(now.getHours()) + ':' +
            padZero(now.getMinutes()) + ':' +
            padZero(now.getSeconds());
    }

    // getAddressFromCoords 함수 선언 (누락된 함수)
    function getAddressFromCoords(lat, lng) {
        // 이 함수를 적절히 구현하거나 호출 부분을 제거해야 합니다.
        console.log('좌표(' + lat + ', ' + lng + ')의 주소를 가져오는 API가 구현되어 있지 않습니다.');
    }
</script>
</body>
</html>
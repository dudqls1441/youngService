<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
  <meta name="description" content="Stock Information System" />
  <meta name="author" content="" />
  <title>Stock Favorites</title>
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

    .btn-favorite {
        color: var(--warning-color);
    }

    .btn-favorite.active {
        color: gold;
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
      <i class="fas fa-cube me-2"></i>YOUNG
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
      <a class="list-group-item list-group-item-action list-group-item-light" href="/analysis">
        <i class="fas fa-chart-pie me-2"></i>분석
      </a>
      <a class="list-group-item list-group-item-action list-group-item-light active" href="/performance">
        <i class="fas fa-chart-pie me-2"></i>주식 비교
      </a>
      <a class="list-group-item list-group-item-action list-group-item-light" href="/managementfootball">
        <i class="fas fa-futbol me-2"></i>풋살 밸런싱
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
          <i class="fas fa-cube me-2"></i>YOUNG
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
        <h2>📈 기간별 주가 비교</h2>

        <!-- 검색 기능 -->
        <!-- 주식 성과 비교 섹션 -->
        <div class="card mb-4">
            <div class="card-header bg-info text-white d-flex justify-content-between align-items-center">
                <span><i class="fas fa-exchange-alt me-2"></i>주식 성과 비교</span>
                <span class="badge bg-light text-dark"><span id="performanceCount">0</span>건</span>
            </div>
            <div class="card-body">
                <!-- 성과 비교 필터 -->
                <div class="row mb-3">
                    <div class="col-md-3">
                        <label for="marketType" class="form-label">시장 구분</label>
                        <select id="marketType" class="form-select">
                            <option value="ALL">전체</option>
                            <option value="KOSPI" selected>KOSPI</option>
                            <option value="KOSDAQ">KOSDAQ</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label for="startPeriod" class="form-label">시작일</label>
                        <input type="date" id="startPeriod" class="form-control" value="2025-01-01">
                    </div>
                    <div class="col-md-3">
                        <label for="endPeriod" class="form-label">종료일</label>
                        <input type="date" id="endPeriod" class="form-control" value="2025-03-31">
                    </div>
                    <div class="col-md-3 d-flex align-items-end">
                        <button id="btnLoadPerformance" class="btn btn-primary w-100">
                            <i class="fas fa-search"></i> 성과 조회
                        </button>
                    </div>
                </div>

                <!-- 성과 비교 그리드 -->
                <div id="performanceGrid" class="ag-theme-alpine" style="width: 100%; height: 500px;"></div>

                <!-- 도움말 및 레전드 -->
                <div class="mt-3 small text-muted">
                    <p><i class="fas fa-info-circle"></i> 위 표는 설정한 기간 동안의 주식 가격 변동률(%)을 기준으로 정렬되어 있습니다.</p>
                    <div class="d-flex">
                        <div class="me-3"><span class="badge bg-success">상승</span> 가격 상승</div>
                        <div><span class="badge bg-danger">하락</span> 가격 하락</div>
                    </div>
                </div>
            </div>
        </div>

      </div>
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
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.2.3/js/bootstrap.bundle.min.js"></script>

<script>
    // 전역 변수로 그리드 인스턴스 저장
    let gridInstance = null;

  // 성과 비교 그리드 초기화 및 데이터 로드
  document.addEventListener('DOMContentLoaded', function() {
      // 성과 조회 버튼 이벤트 리스너
      const btnLoadPerformance = document.getElementById('btnLoadPerformance');
      if (btnLoadPerformance) {
          btnLoadPerformance.addEventListener('click', loadPerformanceData);
      }
  });

  // 성과 데이터 로드 함수
  function loadPerformanceData() {
      const marketType = document.getElementById('marketType').value;
      const startPeriod = document.getElementById('startPeriod').value;
      const endPeriod = document.getElementById('endPeriod').value;

      console.log("marketType:::"+marketType);

      // 버튼 로딩 상태로 변경
      const btnLoadPerformance = document.getElementById('btnLoadPerformance');
      const originalText = btnLoadPerformance.innerHTML;
      btnLoadPerformance.innerHTML = '<i class="fas fa-spinner fa-spin"></i> 조회 중...';
      btnLoadPerformance.disabled = true;

      const contextPath = '${pageContext.request.contextPath}';
      // AJAX로 데이터 요청
      fetch(contextPath + "/stock/performance?marketType=" + marketType + "&startDate=" + startPeriod + "&endDate=" + endPeriod, {
          method: 'GET',
          headers: {
              'Content-Type': 'application/json',
              'X-CSRF-TOKEN': document.querySelector('meta[name="_csrf"]')?.getAttribute('content')
          }
      })
      .then(response => {
          if (!response.ok) {
              throw new Error('서버 응답 오류: ' + response.status);
          }
          return response.json();
      })
      .then(data => {
          // 버튼 상태 복원
          btnLoadPerformance.innerHTML = originalText;
          btnLoadPerformance.disabled = false;

          // 성과 데이터 그리드에 표시
          displayPerformanceData(data);
      })
      .catch(error => {
          // 버튼 상태 복원
          btnLoadPerformance.innerHTML = originalText;
          btnLoadPerformance.disabled = false;

          console.error('Error:', error);
          alert('성과 데이터 요청 중 오류가 발생했습니다.');
      });
  }

  // 성과 데이터 표시 함수
  function displayPerformanceData(rawData) {

    // 데이터 확인 및 변환
    console.log("Raw data:", rawData);

    let gridData = [];

    // 데이터 형식에 따른 처리
    if (Array.isArray(rawData)) {
        gridData = rawData;
    } else if (typeof rawData === 'object' && rawData !== null) {
        // 객체인 경우 내부에서 배열 찾기
        for (let key in rawData) {
            if (Array.isArray(rawData[key])) {
                gridData = rawData[key];
                break;
            }
        }

        // 배열을 찾지 못한 경우
        if (gridData.length === 0 && Object.keys(rawData).length > 0) {
            // 객체를 1개 항목 배열로 변환
            gridData = [rawData];
        }
    }

    // 데이터가 없거나 변환 실패한 경우
    if (!gridData || gridData.length === 0) {
        alert('표시할 데이터가 없습니다.');
        return;
    }

    console.log("그리드 Length ::"+ gridData.length);

    // 건수 업데이트
    document.getElementById('performanceCount').textContent = gridData.length;

      // 컬럼 정의
      const columnDefs = [
          {
              headerName: '회사명',
              field: 'COMPANY_NAME',
              sortable: true,
              filter: true,
              width: 200
          },
          {
              headerName: '종목코드',
              field: 'STOCK_CODE',
              sortable: true,
              filter: true,
              width: 120,
              cellRenderer: params => {
                  return `<a href="${pageContext.request.contextPath}/stock/detail-search?stockCode=${params.value}&autoSearch=true">${params.value}</a>`;
              }
          },
          {
              headerName: '시장구분',
              field: 'MARKET_CATEGORY',
              sortable: true,
              filter: true,
              width: 120
          },
          {
              headerName: '시작일',
              field: 'START_DATE',
              sortable: true,
              filter: true,
              width: 120,
              valueFormatter: params => {
                  if (!params.value) return '';
                  try {
                      // 날짜 형식 변환
                      const date = new Date(params.value);
                      return date.getFullYear() + '-' +
                             String(date.getMonth() + 1).padStart(2, '0') + '-' +
                             String(date.getDate()).padStart(2, '0');
                  } catch(e) {
                      return params.value;
                  }
              }
          },
          {
              headerName: '시작가',
              field: 'START_PRICE',
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
              headerName: '종료일',
              field: 'END_DATE',
              sortable: true,
              filter: true,
              width: 120,
              valueFormatter: params => {
                  if (!params.value) return '';
                  try {
                      // 날짜 형식 변환
                      const date = new Date(params.value);
                      return date.getFullYear() + '-' +
                             String(date.getMonth() + 1).padStart(2, '0') + '-' +
                             String(date.getDate()).padStart(2, '0');
                  } catch(e) {
                      return params.value;
                  }
              }
          },
          {
              headerName: '종료가',
              field: 'END_PRICE',
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
              headerName: '변동률(%)',
              field: 'PRICE_CHANGE_PCT',
              sortable: true,
              filter: 'agNumberColumnFilter',
              width: 120,
              cellStyle: params => {
                  const value = params.value || 0;
                  return {
                      color: value >= 0 ? '#dc3545' : '#198754', // 상승 빨강, 하락 녹색 (국내 주식 색상 기준)
                      fontWeight: 'bold',
                      textAlign: 'right',
                      backgroundColor: value >= 0 ? 'rgba(220, 53, 69, 0.1)' : 'rgba(25, 135, 84, 0.1)' // 배경색 추가
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
              headerName: '분석',
              sortable: false,
              filter: false,
              width: 120,
              cellRenderer: params => {
                  return `
                      <div class="btn-group">
                          <a href="${pageContext.request.contextPath}/stock/analysis?stockCode=${params.data.STOCK_CODE}"
                             class="btn btn-sm btn-outline-success">
                              <i class="fas fa-chart-line"></i>
                          </a>
                          <button class="btn btn-sm btn-outline-warning add-favorite"
                                  data-stock-code="${params.data.STOCK_CODE}">
                              <i class="far fa-star"></i>
                          </button>
                      </div>
                  `;
              }
          }
      ];

      // 그리드 옵션
      const gridOptions = {
          columnDefs: columnDefs,
          rowData: gridData,
          defaultColDef: {
              resizable: true,
              minWidth: 100,
              flex: 1
          },
          pagination: true,
          paginationPageSize: 15,
          paginationAutoPageSize: false,
          domLayout: 'normal',
          suppressAutoSize: false,
          suppressColumnVirtualisation: true,
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
                  params.api.sizeColumnsToFit();
              }, 0);

              // 변동률 컬럼을 기준으로 내림차순 정렬
              params.columnApi.applyColumnState({
                  state: [
                      { colId: 'PRICE_CHANGE_PCT', sort: 'desc' }
                  ]
              });
          },
          onFirstDataRendered(params) {

          }
      };

      // 그리드 생성
        const gridDiv = document.querySelector('#performanceGrid');
        // 기존 그리드가 있다면 제거 (중요: 이 부분을 추가합니다)
        if (gridInstance) {
            gridInstance.destroy();
            gridDiv.innerHTML = '';
        }

        // 새 그리드 생성 및 인스턴스 저장
        gridInstance = new agGrid.Grid(gridDiv, gridOptions);
  }
</script>
</body>
</html>
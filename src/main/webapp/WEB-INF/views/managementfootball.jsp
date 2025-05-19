<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
  <meta name="description" content="Futsal Team Balancing System" />
  <meta name="author" content="" />
  <title>풋살팀 밸런싱 시스템</title>
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

    .player-card {
        transition: transform 0.2s;
    }

    .player-card:hover {
        transform: translateY(-5px);
    }

    .btn-select {
        color: var(--primary-color);
    }

    .btn-select.active {
        color: white;
        background-color: var(--primary-color);
    }

    .rating-input {
        width: 60px;
        text-align: center;
    }

    .player-profile {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        object-fit: cover;
    }

    .team-card {
        border: 2px solid rgba(0,0,0,0.1);
        border-radius: 10px;
        padding: 15px;
        margin-bottom: 15px;
    }

    .team-header {
        border-bottom: 1px solid rgba(0,0,0,0.1);
        padding-bottom: 10px;
        margin-bottom: 10px;
    }

    .team-player {
        padding: 5px;
        border-radius: 5px;
        margin-bottom: 5px;
    }

    .team-player:hover {
        background-color: rgba(0,0,0,0.05);
    }

    .position-badge {
        font-size: 0.7rem;
        padding: 3px 6px;
    }

    .position-fw {
        background-color: #dc3545;
    }

    .position-mf {
        background-color: #fd7e14;
    }

    .position-df {
        background-color: #0d6efd;
    }

    .position-gk {
        background-color: #198754;
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
  <!-- 사이드바 include -->
  <jsp:include page="/WEB-INF/views/common/sidebar.jsp" />

  <!-- 콘텐츠 래퍼 -->
  <div id="content-wrapper">
    <!-- 상단 내비게이션 include -->
    <jsp:include page="/WEB-INF/views/common/navbar.jsp" />

    <!-- 페이지 콘텐츠 -->
    <div id="page-content-wrapper">
      <div class="container-fluid mt-4">
        <!-- 상단 탭 메뉴 -->
        <ul class="nav nav-tabs mb-4" id="futsalTab" role="tablist">
          <li class="nav-item" role="presentation">
            <button class="nav-link active" id="player-ratings-tab" data-bs-toggle="tab" data-bs-target="#player-ratings" type="button" role="tab" aria-controls="player-ratings" aria-selected="true">
              <i class="fas fa-user-tag me-2"></i>선수 평가
            </button>
          </li>
          <li class="nav-item" role="presentation">
            <button class="nav-link" id="team-balancing-tab" data-bs-toggle="tab" data-bs-target="#team-balancing" type="button" role="tab" aria-controls="team-balancing" aria-selected="false">
              <i class="fas fa-users-cog me-2"></i>팀 밸런싱
            </button>
          </li>
          <li class="nav-item" role="presentation">
            <button class="nav-link" id="match-history-tab" data-bs-toggle="tab" data-bs-target="#match-history" type="button" role="tab" aria-controls="match-history" aria-selected="false">
              <i class="fas fa-history me-2"></i>경기 기록
            </button>
          </li>
        </ul>

        <!-- 탭 콘텐츠 -->
        <div class="tab-content" id="futsalTabContent">
          <!-- 선수 평가 탭 -->
          <div class="tab-pane fade show active" id="player-ratings" role="tabpanel" aria-labelledby="player-ratings-tab">
            <div class="card">
              <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                <span><i class="fas fa-user-tag me-2"></i>선수 평가</span>
                <button class="btn btn-sm btn-light" id="btnAddPlayerRating">
                  <i class="fas fa-plus me-1"></i>선수 추가
                </button>
              </div>
              <div class="card-body">
                <!-- 날짜 선택기 -->
                <div class="row mb-4">
                  <div class="col-md-4">
                    <label for="matchSchedule" class="form-label">평가 일정</label>
                    <select id="matchSchedule" class="form-select">
                      <option value="base">기본 평가</option>
                      <!-- 서버에서 가져온 경기 일정 데이터 -->
                      <c:forEach var="schedule" items="${matchSchedules}">
                        <option value="${schedule.scheduleId}"
                                ${schedule.scheduleId eq selectedScheduleId ? 'selected' : ''}>
                          ${schedule.matchDate} (${schedule.status eq 'COMPLETED' ? '완료' :
                                              schedule.status eq 'SCHEDULED' ? '예정' : '취소'})
                        </option>
                      </c:forEach>
                    </select>
                  </div>
                  <div class="col-md-8 d-flex align-items-end">
                    <button id="btnLoadRatings" class="btn btn-primary">
                      <i class="fas fa-search"></i> 조회
                    </button>
                    <button id="btnSaveRatings" class="btn btn-success ms-2">
                      <i class="fas fa-save"></i> 저장
                    </button>
                    <button id="btnCopyPrevWeekRatings" class="btn btn-info ms-2">
                        <i class="fas fa-copy"></i> 지난주 데이터 불러오기
                      </button>
                  </div>
                </div>

                <!-- 선수 평가 테이블 -->
                <div class="table-responsive">
                  <table class="table table-hover" id="playerRatingsTable">
                    <thead class="table-light">
                      <tr>
                        <th style="width: 5%">선택</th>
                        <th style="width: 5%" hidden=true>ID</th>
                        <th style="width: 10%">이름</th>
                        <th style="width: 5%">포지션</th>
                        <th style="width: 10%">공격력</th>
                        <th style="width: 10%">수비력</th>
                        <th style="width: 10%">체력</th>
                        <th style="width: 10%">속도</th>
                        <th style="width: 10%">기술</th>
                        <th style="width: 10%">팀워크</th>
                        <th style="width: 10%">평균</th>
                        <th style="width: 5%">관리</th>
                      </tr>
                    </thead>
                    <tbody>
                      <!-- 실제 데이터는 JavaScript로 로드됨 -->
                    </tbody>
                  </table>
                </div>
              </div>
            </div>
          </div>

          <!-- 팀 밸런싱 탭 -->
          <div class="tab-pane fade" id="team-balancing" role="tabpanel" aria-labelledby="team-balancing-tab">
            <div class="card">
              <div class="card-header bg-primary text-white">
                <i class="fas fa-users-cog me-2"></i>팀 밸런싱
              </div>
              <div class="card-body">
                <!-- 선수 선택 섹션 -->
                <div class="row mb-4">
                  <div class="col-12">
                    <div class="alert alert-info">
                      <i class="fas fa-info-circle me-2"></i>이번 경기에 참여할 선수들을 선택하세요.
                    </div>
                  </div>
                </div>

                <div class="row mb-4">
                  <div class="col-md-3">
                    <label for="teamCount" class="form-label">팀 수</label>
                    <select id="teamCount" class="form-select">
                      <option value="2">2팀</option>
                      <option value="3" selected>3팀</option>
                      <option value="4">4팀</option>
                    </select>
                  </div>
                  <div class="col-md-5">
                    <label for="balancingAlgorithm" class="form-label">밸런싱 알고리즘</label>
                    <select id="balancingAlgorithm" class="form-select">
                      <option value="snake">스네이크 드래프트 (종합 점수 기준)</option>
                      <option value="advanced" selected>포지션 밸런싱 (포지션별 분배)</option>
                      <option value="ml_based">ML 클러스터링 밸런싱</option>
                      <option value="deep_learning">DL 최적화 밸런싱</option>
                    </select>
                  </div>
                  <div class="col-md-4 d-flex align-items-end">
                    <button id="btnCreateTeams" class="btn btn-primary w-100">
                      <i class="fas fa-random me-2"></i>팀 자동 구성
                    </button>
                  </div>
                </div>

                <!-- 선수 선택 목록 -->
                <div class="row mb-4">
                  <div class="col-12">
                    <div class="card">
                      <div class="card-header bg-light">
                        <div class="d-flex justify-content-between align-items-center">
                          <span>선수 선택 (<span id="selectedPlayerCount">0</span>명)</span>
                          <div>
                            <button id="btnSelectAll" class="btn btn-sm btn-outline-primary">전체 선택</button>
                            <button id="btnDeselectAll" class="btn btn-sm btn-outline-secondary">전체 해제</button>
                          </div>
                        </div>
                      </div>
                      <div class="card-body">
                        <div class="row" id="playerSelectionList">
                          <!-- 선수 목록은 JavaScript로 채워짐 -->
                        </div>
                      </div>
                    </div>
                  </div>
                </div>

                <!-- 팀 구성 결과 -->
                <div id="teamResultSection" style="display: none;">
                  <div class="row">
                    <div class="col-12">
                      <h4>팀 구성 결과</h4>
                      <div class="alert alert-success">
                        <i class="fas fa-check-circle me-2"></i>팀이 성공적으로 구성되었습니다. 팀 밸런스 점수: <span id="teamBalanceScore">0.0</span> (낮을수록 균형)
                      </div>
                    </div>
                  </div>

                  <div class="row" id="teamResultCards">
                    <!-- 팀 결과는 JavaScript로 채워짐 -->
                  </div>

                  <div class="row mt-3">
                    <div class="col-12 text-center">
                      <button id="btnSaveTeams" class="btn btn-success">
                        <i class="fas fa-save me-2"></i>팀 구성 저장
                      </button>
                      <button id="btnRegenTeams" class="btn btn-primary ms-2">
                        <i class="fas fa-sync me-2"></i>팀 재구성
                      </button>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- 경기 기록 탭 -->
          <div class="tab-pane fade" id="match-history" role="tabpanel" aria-labelledby="match-history-tab">
            <div class="card">
              <div class="card-header bg-primary text-white">
                <i class="fas fa-history me-2"></i>경기 기록
              </div>
              <div class="card-body">
                <div class="table-responsive">
                  <table class="table table-hover" id="matchHistoryTable">
                    <thead class="table-light">
                      <tr>
                        <th>경기 ID</th>
                        <th>날짜</th>
                        <th>장소</th>
                        <th>결과</th>
                        <th>팀 구성</th>
                        <th>밸런스 점수</th>
                        <th>관리</th>
                      </tr>
                    </thead>
                    <tbody>
                      <!-- 경기 기록은 JavaScript로 채워짐 -->
                    </tbody>
                  </table>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- 선수 평가 입력 모달 -->
<div class="modal fade" id="playerRatingModal" tabindex="-1" aria-labelledby="playerRatingModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="playerRatingModalLabel">선수 평가 입력</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <form id="playerRatingForm">
          <input type="hidden" id="playerId" name="playerId">
          <input type="hidden" id="ratingId" name="ratingId">
          <div class="row mb-3">
            <div class="col-md-6">
              <label for="playerName" class="form-label">선수명</label>
              <input type="text" class="form-control" id="playerName" name="playerName" required>
            </div>
            <div class="col-md-3">
              <label for="position" class="form-label">주 포지션</label>
              <select class="form-select" id="position" name="position" required>
                <option value="FW">FW (공격수)</option>
                <option value="MF">MF (미드필더)</option>
                <option value="DF">DF (수비수)</option>
                <option value="GK">GK (골키퍼)</option>
              </select>
            </div>
            <div class="col-md-3">
              <label for="secondaryPosition" class="form-label">보조 포지션</label>
              <select class="form-select" id="secondaryPosition" name="secondaryPosition">
                <option value="">선택 안함</option>
                <option value="FW">FW (공격수)</option>
                <option value="MF">MF (미드필더)</option>
                <option value="DF">DF (수비수)</option>
                <option value="GK">GK (골키퍼)</option>
              </select>
            </div>
          </div>
          <div class="row mb-3">
            <div class="col-md-2">
              <label for="attackScore" class="form-label">공격력</label>
              <input type="number" class="form-control" id="attackScore" name="attackScore" min="1" max="10" step="0.5" required>
            </div>
            <div class="col-md-2">
              <label for="defenseScore" class="form-label">수비력</label>
              <input type="number" class="form-control" id="defenseScore" name="defenseScore" min="1" max="10" step="0.5" required>
            </div>
            <div class="col-md-2">
              <label for="staminaScore" class="form-label">체력</label>
              <input type="number" class="form-control" id="staminaScore" name="staminaScore" min="1" max="10" step="0.5" required>
            </div>
            <div class="col-md-2">
              <label for="speedScore" class="form-label">속도</label>
              <input type="number" class="form-control" id="speedScore" name="speedScore" min="1" max="10" step="0.5" required>
            </div>
            <div class="col-md-2">
              <label for="techniqueScore" class="form-label">기술</label>
              <input type="number" class="form-control" id="techniqueScore" name="techniqueScore" min="1" max="10" step="0.5" required>
            </div>
            <div class="col-md-2">
              <label for="teamworkScore" class="form-label">팀워크</label>
              <input type="number" class="form-control" id="teamworkScore" name="teamworkScore" min="1" max="10" step="0.5" required>
            </div>
          </div>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
        <button type="button" class="btn btn-primary" id="btnSavePlayerRating">저장</button>
      </div>
    </div>
  </div>
</div>

<!-- Core theme JS-->
<!-- JS -->
<!-- Bootstrap JS -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.2.3/js/bootstrap.bundle.min.js"></script>

<script>
// 날짜 기본값 설정
document.addEventListener('DOMContentLoaded', function() {
    // 오늘 날짜 설정
    const today = new Date().toISOString().split('T')[0];

    // 사이드바 토글 이벤트
    const sidebarToggle = document.getElementById('sidebarToggle');
    if (sidebarToggle) {
        sidebarToggle.addEventListener('click', function(e) {
            e.preventDefault();
            document.getElementById('wrapper').classList.toggle('toggled');
            document.getElementById('sidebar-wrapper').classList.toggle('toggled');
            document.getElementById('content-wrapper').classList.toggle('toggled');
        });
    }

    // 경기 일정 로드
    loadMatchSchedules();

    // 선수 데이터 로드
    loadPlayerRatings();


    // 버튼 이벤트 리스너 등록
    document.getElementById('btnLoadRatings').addEventListener('click', loadPlayerRatings);
    document.getElementById('btnSaveRatings').addEventListener('click', saveAllRatings);
    document.getElementById('btnAddPlayerRating').addEventListener('click', showAddPlayerModal);
    document.getElementById('btnSavePlayerRating').addEventListener('click', savePlayerRating);
    document.getElementById('btnCreateTeams').addEventListener('click', createTeams);
    document.getElementById('btnSaveTeams').addEventListener('click', saveTeams);
    document.getElementById('btnRegenTeams').addEventListener('click', createTeams);
    document.getElementById('btnSelectAll').addEventListener('click', selectAllPlayers);
    document.getElementById('btnDeselectAll').addEventListener('click', deselectAllPlayers);

    // 지난주 데이터 불러오기 버튼 이벤트 리스너 추가
    document.getElementById('btnCopyPrevWeekRatings').addEventListener('click', loadPreviousWeekRatings);
});

// 페이지 로드 시 경기 일정 데이터 가져오기
function loadMatchSchedules() {
    fetch('/football/matchSchedules')
        .then(response => response.json())
        .then(data => {
            if (data.success && Array.isArray(data.data)) {

                console.log("data ::", data);
                const matchScheduleSelect = document.getElementById('matchSchedule');

                // 기존 옵션 제거 (기본 평가 옵션 유지)
                while (matchScheduleSelect.options.length > 1) {
                    matchScheduleSelect.remove(1);
                }

                // 경기 일정 옵션 추가
                data.data.forEach(schedule => {
                    const option = document.createElement('option');
                    option.value = schedule.SCHEDULE_ID;

                    const date = new Date(schedule.MATCH_DATE);
                    const dateStr = date.toLocaleDateString();

                    let status = '';
                    if (schedule.STATUS === 'COMPLETED') status = '완료';
                    else if (schedule.STATUS === 'SCHEDULED') status = '예정';
                    else status = '취소';

                    option.textContent = dateStr + ' (' + status + ')';
                    matchScheduleSelect.appendChild(option);
                });

                // 가장 최근 완료된 경기 또는 첫 번째 항목 선택
                const completedOptions = Array.from(matchScheduleSelect.options)
                    .filter(opt => opt.text.includes('완료'));

                if (completedOptions.length > 0) {
                    completedOptions[0].selected = true;
                }

                // 선수 데이터 로드
                loadPlayerRatings();
            }
        })
        .catch(error => {
            console.error('Error loading match schedules:', error);
        });
}


function loadPlayerRatings() {
    const scheduleId = document.getElementById('matchSchedule').value;

    console.log("loadPlayerRatings scheduleId ::", scheduleId);

    // 로딩 상태 표시
    const tableBody = document.querySelector('#playerRatingsTable tbody');
    tableBody.innerHTML = '<tr><td colspan="12" class="text-center">데이터를 불러오는 중...</td></tr>';

    // 기본 평가인지 경기별 평가인지 구분
    const isBaseRating = scheduleId === 'base';
    const apiUrl = isBaseRating
        ? '/football/getPlayers?type=base'
        : '/football/getPlayers?scheduleId=' + scheduleId;

    // API 호출
    fetch(apiUrl)
        .then(response => response.json())
        .then(data => {
            if (data.success && Array.isArray(data.data)) {
                displayPlayerRatings(data.data);

                loadPlayerSelectionList();
                //loadPlayerSelectionList_old(data.data);

                // 제목 업데이트
                const ratingTitle = document.getElementById('ratingTitle');
                if (ratingTitle) {
                    ratingTitle.textContent = isBaseRating
                        ? '기본 평가'
                        : document.getElementById('matchSchedule').options[document.getElementById('matchSchedule').selectedIndex].text;
                }
            } else {
                console.error('Invalid data format:', data);
                tableBody.innerHTML = '<tr><td colspan="12" class="text-center text-danger">데이터 형식이 올바르지 않습니다.</td></tr>';
            }
        })
        .catch(error => {
            console.error('Error:', error);
            tableBody.innerHTML = '<tr><td colspan="12" class="text-center text-danger">데이터 로드 중 오류가 발생했습니다.</td></tr>';
        });
    }

    // 지난주 데이터 가져오기
    function loadPreviousWeekRatings() {
      const scheduleId = document.getElementById('matchSchedule').value;

      // 기본 평가인 경우 경고 표시
      if (scheduleId === 'base') {
        alert('기본 평가에서는 이 기능을 사용할 수 없습니다. 특정 일정을 선택해주세요.');
        return;
      }

      // 확인 메시지
      if (!confirm('지난주 선수 평가 데이터를 불러와 현재 데이터를 덮어쓰시겠습니까?')) {
        return;
      }

      // 로딩 상태 표시
      const tableBody = document.querySelector('#playerRatingsTable tbody');
      tableBody.innerHTML = '<tr><td colspan="12" class="text-center">지난주 데이터를 불러오는 중...</td></tr>';

      // API 호출
      fetch('/football/getPreviousWeekRatings?scheduleId=' + scheduleId)
        .then(response => response.json())
        .then(data => {
          if (data.success && Array.isArray(data.data)) {
            displayPlayerRatings(data.data);

            // 알림 표시
            alert('지난주 데이터를 성공적으로 불러왔습니다. 변경사항을 저장하려면 "저장" 버튼을 클릭하세요.');
          } else {
            console.error('Invalid data format:', data);
            tableBody.innerHTML = '<tr><td colspan="12" class="text-center text-danger">지난주 데이터를 가져오는데 실패했습니다.</td></tr>';
            alert('지난주 데이터를 불러오는데 실패했습니다: ' + (data.message || '알 수 없는 오류'));
          }
        })
        .catch(error => {
          console.error('Error:', error);
          tableBody.innerHTML = '<tr><td colspan="12" class="text-center text-danger">지난주 데이터를 가져오는 중 오류가 발생했습니다.</td></tr>';
          alert('지난주 데이터를 불러오는 중 오류가 발생했습니다.');
        });
    }

// 선수 평가 데이터 화면에 표시
function displayPlayerRatings(players) {

    console.log("players:", players);
    const tableBody = document.querySelector('#playerRatingsTable tbody');
    tableBody.innerHTML = '';

    if (!Array.isArray(players)) {
        console.error('Players is not an array:', players);
        tableBody.innerHTML = '<tr><td colspan="12" class="text-center text-danger">선수 데이터가 배열 형식이 아닙니다.</td></tr>';
        return;
    }

    if (players.length === 0) {
        tableBody.innerHTML = '<tr><td colspan="12" class="text-center">표시할 선수 데이터가 없습니다.</td></tr>';
        return;
    }

    players.forEach(player => {
        const avgScore = ((player.ATTACK_SCORE + player.DEFENSE_SCORE + player.STAMINA_SCORE +
                          player.SPEED_SCORE + player.STAMINA_SCORE + player.TEAMWORK_SCORE) / 6).toFixed(1);

        const positionBadgeClass = getPositionBadgeClass(player.POSITION);

        const row = document.createElement('tr');
        row.innerHTML = `
            <td><input type="checkbox" class="form-check-input player-select-checkbox" data-player-id="\${player.id}"></td>
            <td>\${player.NAME}</td>
            <td><span class="badge \${positionBadgeClass}">\${player.POSITION}</span></td>
            <td><input type="number" class="form-control rating-input" data-field="attackScore" value="\${player.ATTACK_SCORE}" min="1" max="10" step="0.5"></td>
            <td><input type="number" class="form-control rating-input" data-field="defenseScore" value="\${player.DEFENSE_SCORE}" min="1" max="10" step="0.5"></td>
            <td><input type="number" class="form-control rating-input" data-field="staminaScore" value="\${player.STAMINA_SCORE}" min="1" max="10" step="0.5"></td>
            <td><input type="number" class="form-control rating-input" data-field="speedScore" value="\${player.SPEED_SCORE}" min="1" max="10" step="0.5"></td>
            <td><input type="number" class="form-control rating-input" data-field="techniqueScore" value="\${player.TECHNIQUE_SCORE}" min="1" max="10" step="0.5"></td>
            <td><input type="number" class="form-control rating-input" data-field="teamworkScore" value="\${player.TEAMWORK_SCORE}" min="1" max="10" step="0.5"></td>
            <td><strong>\${avgScore}</strong></td>
            <td>
                <button class="btn btn-sm btn-outline-primary btn-edit-player" data-player-id="\${player.PLAYER_ID}">
                    <i class="fas fa-edit"></i>
                </button>
                <button class="btn btn-sm btn-outline-danger btn-delete-player" data-player-id="\${player.PLAYER_ID}">
                    <i class="fas fa-trash"></i>
                </button>
            </td>
        `;
        tableBody.appendChild(row);

        // 선수 데이터 행에 데이터 설정
        row.dataset.player = JSON.stringify(player);
    });

    // 편집 및 삭제 버튼 이벤트 리스너 등록
    document.querySelectorAll('.btn-edit-player').forEach(btn => {
        btn.addEventListener('click', function() {
            const playerId = this.getAttribute('data-player-id');
            const playerRow = this.closest('tr');
            const playerData = JSON.parse(playerRow.dataset.player || '{}');
            showEditPlayerModal(playerData);
        });
    });

    document.querySelectorAll('.btn-delete-player').forEach(btn => {
        btn.addEventListener('click', function() {
            const playerId = this.getAttribute('data-player-id');
            // 행에 저장된 선수 데이터 가져오기
            const playerRow = this.closest('tr');
            const playerData = JSON.parse(playerRow.dataset.player || '{}');
            const playerName = playerData.NAME || '알 수 없음';

            if (confirm(`정말로 "\${playerName}"(\${playerId}번) 선수를 삭제하시겠습니까?`)) {
                deletePlayer(playerId);
            }
        });
    });

    // 입력 값 변경 시 행 데이터 업데이트
    document.querySelectorAll('.rating-input').forEach(input => {
        input.addEventListener('change', function() {
            const row = this.closest('tr');
            const field = this.getAttribute('data-field');
            const value = parseFloat(this.value);

            console.log("value:::", value);

            // 선수 데이터 업데이트
            const player = JSON.parse(row.dataset.player);

            // field 값(camelCase)을 대문자 형식으로 변환 (SNAKE_CASE)
            const fieldUpperCase = field.replace(/([A-Z])/g, "_$1").toUpperCase();
            player[fieldUpperCase] = value;
            row.dataset.player = JSON.stringify(player);

            const avgScore = ((player.ATTACK_SCORE + player.DEFENSE_SCORE + player.STAMINA_SCORE +
                              player.SPEED_SCORE + player.TECHNIQUE_SCORE + player.TEAMWORK_SCORE) / 6).toFixed(1);

            console.log("avgScore:::", avgScore);
            console.log("player:::", player);
            console.log("fieldUpperCase:::", fieldUpperCase);
            console.log("player[fieldUpperCase]:::", player[fieldUpperCase]);

            row.querySelector('td:nth-last-child(2) strong').textContent = avgScore;
        });
    });
}

// 선수 기본 평가 + 선수 한달갈 평균 평가를 조회하여 뿌려줌
function loadPlayerSelectionList() {
    const apiUrl = '/football/getPlayerAverageRatings'
    // API 호출
    fetch(apiUrl)
        .then(response => response.json())
        .then(data => {
            if (data.success && Array.isArray(data.data)) {
                const selectionList = document.getElementById('playerSelectionList');
                selectionList.innerHTML = '';

                // data가 아닌 data.data를 사용해야 함
                data.data.forEach(player => {
                    // 평균 점수는 이미 TOTAL_AVERAGE 필드에 계산되어 있음
                    const avgScore = player.TOTAL_AVERAGE || ((player.AVG_ATTACK + player.AVG_DEFENSE + player.AVG_STAMINA +
                                      player.AVG_SPEED + player.AVG_TECHNIQUE + player.AVG_TEAMWORK) / 6).toFixed(1);

                    const positionBadgeClass = getPositionBadgeClass(player.POSITION);

                    const playerCard = document.createElement('div');
                    playerCard.className = 'col-md-3 col-sm-4 col-6 mb-3';
                    playerCard.innerHTML = `
                        <div class="card player-card h-100">
                            <div class="card-body text-center">
                                <div class="form-check form-switch d-flex justify-content-end mb-2">
                                    <input class="form-check-input player-select" type="checkbox"
                                           data-player-id="\${player.PLAYER_ID}" id="playerCheck\${player.PLAYER_ID}">
                                </div>
                                <h6 class="card-title mb-2 text-truncate" title="\${player.NAME}" style="max-width: 100%; font-size: 0.95rem;">\${player.NAME}</h6>
                                <span class="badge \${positionBadgeClass} mb-3">\${player.POSITION}</span>
                                <div class="small text-muted">평균 점수: <strong>\${avgScore}</strong></div>
                            </div>
                        </div>
                    `;
                    selectionList.appendChild(playerCard);

                    // 선수 카드에 데이터 설정
                    playerCard.dataset.player = JSON.stringify(player);
                });

                // 선수 선택 이벤트 리스너 등록
                document.querySelectorAll('.player-select').forEach(checkbox => {
                    checkbox.addEventListener('change', updateSelectedPlayerCount);
                });

            } else {
                console.error('Invalid data format:', data);
                // tableBody가 정의되지 않음 - selectionList로 변경하거나 에러 처리 방식 수정
                selectionList.innerHTML = '<div class="alert alert-danger">데이터 형식이 올바르지 않습니다.</div>';
            }
        })
        .catch(error => {
            console.error('Error:', error);
            // tableBody가 정의되지 않음 - selectionList로 변경
            const selectionList = document.getElementById('playerSelectionList');
            selectionList.innerHTML = '<div class="alert alert-danger">데이터 로드 중 오류가 발생했습니다.</div>';
        });
}

// 선수 선택 목록 로드(OLD,미사용) 선수 평가 탭에서 조회를 하면 자동으로 호출되는 함수( 선수평가 탭에 평가 일자로 조회되는 데이터를 뿌려줌)
function loadPlayerSelectionList_old(players) {
    const selectionList = document.getElementById('playerSelectionList');
    selectionList.innerHTML = '';

    players.forEach(player => {
        const avgScore = ((player.ATTACK_SCORE + player.DEFENSE_SCORE + player.STAMINA_SCORE +
                          player.SPEED_SCORE + player.TECHNIQUE_SCORE + player.TEAMWORK_SCORE) / 6).toFixed(1);

        const positionBadgeClass = getPositionBadgeClass(player.POSITION);

        const playerCard = document.createElement('div');
        playerCard.className = 'col-md-3 col-sm-4 col-6 mb-3';
        playerCard.innerHTML = `
            <div class="card player-card h-100">
                <div class="card-body text-center">
                    <div class="form-check form-switch d-flex justify-content-end mb-2">
                        <input class="form-check-input player-select" type="checkbox"
                               data-player-id="\${player.PLAYER_ID}" id="playerCheck\${player.PLAYER_ID}">
                    </div>
                    <h6 class="card-title mb-2 text-truncate" title="\${player.NAME}" style="max-width: 100%; font-size: 0.95rem;">\${player.NAME}</h6>
                    <span class="badge \${positionBadgeClass} mb-3">\${player.POSITION}</span>
                    <div class="small text-muted">평균 점수: <strong>\${avgScore}</strong></div>
                </div>
            </div>
        `;
        selectionList.appendChild(playerCard);

        // 선수 카드에 데이터 설정
        playerCard.dataset.player = JSON.stringify(player);
    });

    // 선수 선택 이벤트 리스너 등록
    document.querySelectorAll('.player-select').forEach(checkbox => {
        checkbox.addEventListener('change', updateSelectedPlayerCount);
    });
}

// 선택된 선수 수 업데이트
function updateSelectedPlayerCount() {
    const selectedCount = document.querySelectorAll('.player-select:checked').length;
    document.getElementById('selectedPlayerCount').textContent = selectedCount;
}

// 모든 선수 선택
function selectAllPlayers() {
    document.querySelectorAll('.player-select').forEach(checkbox => {
        checkbox.checked = true;
    });
    updateSelectedPlayerCount();
}

// 모든 선수 선택 해제
function deselectAllPlayers() {
    document.querySelectorAll('.player-select').forEach(checkbox => {
        checkbox.checked = false;
    });
    updateSelectedPlayerCount();
}

// 선수 추가 모달 표시
function showAddPlayerModal() {
    // 모달 초기화
    document.getElementById('playerRatingForm').reset();
    document.getElementById('playerId').value = '';
    document.getElementById('playerRatingModalLabel').textContent = '선수 추가';

    // 모달 표시
    const modal = new bootstrap.Modal(document.getElementById('playerRatingModal'));
    modal.show();
}

// 선수 편집 모달 표시
function showEditPlayerModal(player) {

    console.log("showEditPlayerModal  player ::", player);
    // 모달에 선수 데이터 채우기
    document.getElementById('playerId').value = player.PLAYER_ID;
    document.getElementById('ratingId').value = player.RATING_ID;
    document.getElementById('playerName').value = player.NAME;
    document.getElementById('position').value = player.POSITION;
    document.getElementById('secondaryPosition').value = player.secondaryPosition || '';
    document.getElementById('attackScore').value = player.ATTACK_SCORE;
    document.getElementById('defenseScore').value = player.DEFENSE_SCORE;
    document.getElementById('staminaScore').value = player.STAMINA_SCORE;
    document.getElementById('speedScore').value = player.SPEED_SCORE;
    document.getElementById('techniqueScore').value = player.TECHNIQUE_SCORE;
    document.getElementById('teamworkScore').value = player.TEAMWORK_SCORE;

    document.getElementById('playerRatingModalLabel').textContent = '선수 평가 수정';

    // 모달 표시
    const modal = new bootstrap.Modal(document.getElementById('playerRatingModal'));
    modal.show();
}

// 선수 평가 저장
function savePlayerRating() {
    const form = document.getElementById('playerRatingForm');

    // 폼 유효성 검사
    if (!form.checkValidity()) {
        form.reportValidity();
        return;
    }

    // 폼 데이터 수집
    const playerId = document.getElementById('playerId').value;
    const ratingId = document.getElementById('ratingId').value;
    const playerData = {
        id: playerId ? parseInt(playerId) : null,
        ratingId: ratingId ? parseInt(ratingId) : null,
        name: document.getElementById('playerName').value,
        position: document.getElementById('position').value,
        secondaryPosition: document.getElementById('secondaryPosition').value,
        attackScore: parseFloat(document.getElementById('attackScore').value),
        defenseScore: parseFloat(document.getElementById('defenseScore').value),
        staminaScore: parseFloat(document.getElementById('staminaScore').value),
        speedScore: parseFloat(document.getElementById('speedScore').value),
        techniqueScore: parseFloat(document.getElementById('techniqueScore').value),
        teamworkScore: parseFloat(document.getElementById('teamworkScore').value)
    };

    console.log("playerData::", playerData);

    fetch('/football/registerPlayer', {
        method: playerId ? 'PUT' : 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(playerData)
    })
        .then(response => response.json())
        .then(data => {
            // 성공 처리
            bootstrap.Modal.getInstance(document.getElementById('playerRatingModal')).hide();
            loadPlayerRatings();
        })
        .catch(error => {
            console.error('Error:', error);
            alert('선수 데이터 저장 중 오류가 발생했습니다.');
        });
}

// 모든 선수 평가 저장
function saveAllRatings() {
    const rows = document.querySelectorAll('#playerRatingsTable tbody tr');
    const playerRatings = [];

    const scheduleId = document.getElementById('matchSchedule').value;
    const scheduleText = document.getElementById('matchSchedule').options[document.getElementById('matchSchedule').selectedIndex].text;


    rows.forEach(row => {
        if (row.dataset.player) {
            const playerData = JSON.parse(row.dataset.player);

            // 스케줄 ID 추가 (base 평가인 경우 null로 설정)
            if (scheduleId === 'base') {
                playerData.SCHEDULE_ID = null;
            } else {
                playerData.SCHEDULE_ID = parseInt(scheduleId);
            }

            playerRatings.push(playerData);
        }
    });

    // 전송할 데이터 객체 생성
    const saveData = {
        scheduleInfo: {
            scheduleId: scheduleId === 'base' ? null : parseInt(scheduleId),
            scheduleText: scheduleText
        },
        playerRatings: playerRatings
    };

    // API 호출 (여기서는 가상 처리)
    fetch('/football/saveAllRatings', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(saveData)
    })
        .then(response => response.json())
        .then(data => {
            alert('모든 선수 평가가 저장되었습니다.');
        })
        .catch(error => {
            console.error('Error:', error);
            alert('선수 데이터 저장 중 오류가 발생했습니다.');
        });
}

// 선수 삭제
function deletePlayer(playerId) {
    // API 호출 (여기서는 가상 처리)
    fetch(`/football/deletePlayer?playerId=\${playerId}`)
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                loadPlayerRatings();
                alert('선수가 삭제되었습니다.');
            } else {
                throw new Error(data.message || '서버 응답 오류');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('선수 삭제 중 오류가 발생했습니다.');
        });
}

// 팀 구성 실행
function createTeams() {
    // 선택된 선수 가져오기
    const selectedPlayers = [];
    document.querySelectorAll('.player-select:checked').forEach(checkbox => {
        const playerId = checkbox.getAttribute('data-player-id');
        const playerCard = checkbox.closest('.col-md-3');
        const player = JSON.parse(playerCard.dataset.player);
        selectedPlayers.push(player);
    });

    // 선택된 선수가 충분한지 확인
    const teamCount = parseInt(document.getElementById('teamCount').value);
    if (selectedPlayers.length < teamCount * 2) {
        alert(`최소 ${teamCount * 2}명의 선수를 선택해야 합니다.`);
        return;
    }

    // 알고리즘 선택
    const algorithm = document.getElementById('balancingAlgorithm').value;

    // 팀 구성 요청 (여기서는 가상 처리)
    fetch('/football/teamBalancing', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
            players: selectedPlayers,
            teamCount: teamCount,
            algorithm: algorithm
        })
    })
        .then(response => response.json())
        .then(data => {
            console.log("data:::", data);
            if (data.success) {
                displayTeamResults(data.teams); // teams 배열만 전달
                document.getElementById('teamBalanceScore').textContent = data.balanceScore.toFixed(2);
            } else {
                throw new Error(data.message || '서버 응답 오류');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('팀 구성 중 오류가 발생했습니다.');
        });
}

// 팀 밸런싱 결과 표시
function displayTeamResults(teams) {
    const resultSection = document.getElementById('teamResultSection');
    const cardsContainer = document.getElementById('teamResultCards');

    cardsContainer.innerHTML = '';

    // 팀 밸런스 점수 계산
    const teamScores = teams.map(team => {
        return team.players.reduce((sum, player) => sum + calculateTotalScore(player), 0);
    });

    const avgTeamScore = teamScores.reduce((sum, score) => sum + score, 0) / teams.length;
    const balanceScore = teamScores.reduce((sum, score) => sum + Math.abs(score - avgTeamScore), 0) / teams.length;

    document.getElementById('teamBalanceScore').textContent = balanceScore.toFixed(2);

    // 팀 카드 생성
    teams.forEach((team, index) => {
        const teamCard = document.createElement('div');
        teamCard.className = 'col-md-4 mb-3';

        const teamTotalScore = team.players.reduce((sum, player) => sum + calculateTotalScore(player), 0);
        const teamAvgScore = (teamTotalScore / team.players.length).toFixed(2);

        let playersList = '';
        team.players.forEach(player => {
            const avgScore = calculateTotalScore(player).toFixed(1);

            const position = player.POSITION || player.position;
            const name = player.NAME || player.name;
            const positionBadgeClass = getPositionBadgeClass(position);

            console.log("avgScore:::",avgScore);

            playersList +=
                '<div class="team-player d-flex align-items-center justify-content-between">' +
                    '<div>' +
                        '<span class="badge ' + positionBadgeClass + ' position-badge me-1">' + position + '</span>' +
                        '<strong>' + name + '</strong>' +
                    '</div>' +
                    '<div class="text-muted small">' + avgScore + '</div>' +
                '</div>';
        });



        console.log("countPosition(team.players)" + countPosition(team.players, 'FW'));

        teamCard.innerHTML =
            '<div class="team-card">' +
                '<div class="team-header">' +
                    '<div class="d-flex justify-content-between align-items-center mb-2">' +
                        '<h5 class="mb-0">Team ' + String.fromCharCode(65 + index) + '</h5>' +
                        '<span class="badge bg-primary">' + team.players.length + '명</span>' +
                    '</div>' +
                    '<div class="d-flex justify-content-between align-items-center">' +
                        '<div>' +
                            '<span class="badge bg-light text-dark">FW: ' + countPosition(team.players, 'FW') + '</span> ' +
                            '<span class="badge bg-light text-dark">MF: ' + countPosition(team.players, 'MF') + '</span> ' +
                            '<span class="badge bg-light text-dark">DF: ' + countPosition(team.players, 'DF') + '</span> ' +
                            '<span class="badge bg-light text-dark">GK: ' + countPosition(team.players, 'GK') + '</span>' +
                        '</div>' +
                        '<div class="text-primary fw-bold">' + teamAvgScore + '</div>' +
                    '</div>' +
                '</div>' +
                '<div class="team-players">' +
                    playersList +
                '</div>' +
            '</div>';

        cardsContainer.appendChild(teamCard);
    });

    // 결과 섹션 표시
    resultSection.style.display = 'block';

    // 결과 섹션으로 스크롤
    resultSection.scrollIntoView({ behavior: 'smooth' });
}

// 팀 구성 저장
function saveTeams() {
    // API 호출 (여기서는 가상 처리)
    setTimeout(() => {
        alert('팀 구성이 성공적으로 저장되었습니다.');
    }, 500);
}

// 포지션별 선수 수 계산
function countPosition(players, position) {
    return players.filter(player => player.POSITION === position).length;
}

// 선수 총점 계산
function old_calculateTotalScore(player) {
    return (player.ATTACK_SCORE + player.DEFENSE_SCORE + player.STAMINA_SCORE +
            player.SPEED_SCORE + player.TECHNIQUE_SCORE + player.TEAMWORK_SCORE) / 6;
}

// 선수 총점 계산
function calculateTotalScore(player) {
    return (player.AVG_ATTACK + player.AVG_DEFENSE + player.AVG_STAMINA +
            player.AVG_SPEED + player.AVG_TECHNIQUE + player.AVG_TEAMWORK) / 6;
}

// 포지션 배지 클래스 가져오기
function getPositionBadgeClass(position) {
    switch (position) {
        case 'FW': return 'bg-danger position-fw';
        case 'MF': return 'bg-warning position-mf';
        case 'DF': return 'bg-primary position-df';
        case 'GK': return 'bg-success position-gk';
        default: return 'bg-secondary';
    }
}

</script>
</body>
</html>
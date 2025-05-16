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

  <!-- 사이드바 include -->
  <jsp:include page="/WEB-INF/views/common/sidebar.jsp" />

  <!-- 콘텐츠 래퍼 -->
  <div id="content-wrapper">
    <!-- 상단 내비게이션 include -->
    <jsp:include page="/WEB-INF/views/common/navbar.jsp" />

    <!-- 페이지 콘텐츠 -->
    <div id="page-content-wrapper">
      <div class="container mt-4">
        <h2>⭐ 주식 즐겨찾기</h2>

        <!-- 검색 기능 -->
        <div class="card mb-4">
          <div class="card-header bg-light">
            <i class="fas fa-search"></i> 종목 검색
          </div>
          <div class="card-body">
            <form action="${pageContext.request.contextPath}/stock/search" method="get" class="row g-3">
              <div class="col-md-10">
                <input type="text" class="form-control" id="searchKeyword" name="keyword" placeholder="종목코드 또는 종목명 입력">
              </div>
              <div class="col-md-2">
                <button type="submit" class="btn btn-primary w-100">
                  <i class="fas fa-search"></i> 검색
                </button>
              </div>
            </form>
          </div>
        </div>

        <!-- 즐겨찾는 종목 목록 -->
        <div class="card mb-4">
          <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
            <span><i class="fas fa-star"></i> 즐겨찾는 종목 목록</span>
            <span class="badge bg-light text-dark">
              <c:choose>
                <c:when test="${not empty favoriteStocks}">
                  ${fn:length(favoriteStocks)}건
                </c:when>
                <c:otherwise>0건</c:otherwise>
              </c:choose>
            </span>
          </div>
          <div class="card-body">
            <div class="table-responsive">
              <table class="table table-striped table-hover">
                <thead class="table-dark">
                <tr>
                  <th>종목코드</th>
                  <th>종목명</th>
                  <th>시장구분</th>
                  <th>즐겨찾기</th>
                  <th>관리</th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                  <c:when test="${empty favoriteStocks}">
                    <tr>
                      <td colspan="5" class="text-center">즐겨찾는 종목이 없습니다.</td>
                    </tr>
                  </c:when>
                  <c:otherwise>
                    <c:forEach var="stock" items="${favoriteStocks}">
                      <tr>
                        <td>${stock.SRTNCD}</td>
                        <td>
                          <a href="${pageContext.request.contextPath}/stock/detail?stockCode=${stock.SRTNCD}">${stock.SRTNCD}</a>
                        </td>
                        <td>${stock.marketType}</td>
                        <td>
                          <button class="btn btn-sm btn-warning remove-favorite" data-stock-code="${stock.SRTNCD}">
                            <i class="fas fa-star"></i> 즐겨찾기 삭제하기
                          </button>
                        </td>
                        <td>
                          <div class="btn-group">
                            <a href="${pageContext.request.contextPath}/detail-search?stockCode=${stock.SRTNCD}&autoSearch=true"
                               class="btn btn-sm btn-outline-info">
                              <i class="fas fa-info-circle"></i> 상세
                            </a>
                            <a href="${pageContext.request.contextPath}/analysis?stockCode=${stock.SRTNCD}"
                               class="btn btn-sm btn-outline-success">
                              <i class="fas fa-chart-line"></i> 분석
                            </a>
                          </div>
                        </td>
                      </tr>
                    </c:forEach>
                  </c:otherwise>
                </c:choose>
                </tbody>
              </table>
            </div>
          </div>
        </div>

        <!-- 검색 결과 (종목 추가를 위한) -->
        <c:if test="${not empty stockInfoList}">
          <div class="card mb-4">
            <div class="card-header bg-info text-white d-flex justify-content-between align-items-center">
              <span><i class="fas fa-search"></i> 검색 결과</span>
              <span class="badge bg-light text-dark">${totalCount}건</span>
            </div>
            <div class="card-body">
              <div class="table-responsive">
                <table class="table table-striped table-hover">
                  <thead class="table-dark">
                  <tr>
                    <th>종목코드</th>
                    <th>종목명</th>
                    <th>시장구분</th>
                    <th>즐겨찾기</th>
                    <th>관리</th>
                  </tr>
                  </thead>
                  <tbody>
                  <c:forEach var="result" items="${stockInfoList}">
                    <tr>
                      <td>${result.SRTNCD}</td>
                      <td>${result.ITMSNM}</td>
                      <td>${result.MRKTCTG}</td>
                      <td>
                        <c:choose>
                          <c:when test="${result.IS_FAVORITE}">
                            <button class="btn btn-sm btn-warning remove-favorite"
                                    data-stock-code="${result.SRTNCD}">
                              <i class="fas fa-star"></i> 즐겨찾기 등록됨
                            </button>
                          </c:when>
                          <c:otherwise>
                            <button class="btn btn-sm btn-outline-warning add-favorite"
                                    data-stock-code="${result.SRTNCD}">
                              <i class="far fa-star"></i> 즐겨찾기 추가
                            </button>
                          </c:otherwise>
                        </c:choose>
                      </td>
                      <td>
                        <div class="btn-group">
                          <a href="${pageContext.request.contextPath}/stock/detail-search?stockCode=${result.SRTNCD}"
                             class="btn btn-sm btn-outline-info">
                            <i class="fas fa-info-circle"></i> 상세
                          </a>
                          <a href="${pageContext.request.contextPath}/stock/analysis?stockCode=${result.SRTNCD}"
                             class="btn btn-sm btn-outline-success">
                            <i class="fas fa-chart-line"></i> 분석
                          </a>
                        </div>
                      </td>
                    </tr>
                  </c:forEach>
                  </tbody>
                </table>
              </div>

              <!-- 검색 결과 페이징 -->
              <c:if test="${fn:length(stockInfoList) > 0}">
                <div class="mt-3">
                  <nav aria-label="Page navigation">
                    <ul class="pagination justify-content-center">
                      <!-- 이전 페이지 -->
                      <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                        <a class="page-link" href="${pageContext.request.contextPath}/stock/search?page=${currentPage - 1}&keyword=${param.keyword}" aria-label="Previous">
                          <span aria-hidden="true">&laquo;</span>
                        </a>
                      </li>

                      <!-- 페이지 번호 -->
                      <c:choose>
                        <c:when test="${totalPages > 0}">
                          <c:set var="startPage" value="${totalPages <= 10 ? 1 : (currentPage <= 6 ? 1 : (currentPage > totalPages - 5 ? totalPages - 9 : currentPage - 5))}"/>
                          <c:set var="endPage" value="${totalPages <= 10 ? totalPages : (currentPage <= 6 ? 10 : (currentPage > totalPages - 5 ? totalPages : currentPage + 4))}"/>

                          <c:forEach var="pageNum" begin="${startPage}" end="${endPage}">
                            <li class="page-item ${pageNum == currentPage ? 'active' : ''}">
                              <a class="page-link" href="${pageContext.request.contextPath}/stock/search?page=${pageNum}&keyword=${param.keyword}">${pageNum}</a>
                            </li>
                          </c:forEach>
                        </c:when>
                      </c:choose>

                      <!-- 다음 페이지 -->
                      <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                        <a class="page-link" href="${pageContext.request.contextPath}/stock/search?page=${currentPage + 1}&keyword=${param.keyword}" aria-label="Next">
                          <span aria-hidden="true">&raquo;</span>
                        </a>
                      </li>
                    </ul>
                  </nav>
                </div>
              </c:if>
            </div>
          </div>
        </c:if>
      </div>
    </div>
    <!-- 푸터 include -->
    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
  </div>
</div>

<!-- JS -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.2.3/js/bootstrap.bundle.min.js"></script>

<script>
  document.addEventListener('DOMContentLoaded', function() {
      // 즉시 즐겨찾기 목록 로드
      loadFavorites();

      // 토글 기능 설정
      document.getElementById('sidebarToggle').addEventListener('click', function(e) {
          e.preventDefault();
          document.getElementById('sidebar-wrapper').classList.toggle('toggled');
          document.getElementById('content-wrapper').classList.toggle('toggled');
      });

      // 즐겨찾기 추가 버튼
      document.querySelectorAll('.add-favorite').forEach(button => {
          button.addEventListener('click', function() {
              const stockCode = this.getAttribute('data-stock-code');
              addFavorite(stockCode);
          });
      });

      // 즐겨찾기 삭제 버튼
      document.querySelectorAll('.remove-favorite').forEach(button => {
          button.addEventListener('click', function() {
              const stockCode = this.getAttribute('data-stock-code');
              removeFavorite(stockCode);
          });
      });
  });

  // 즐겨찾기 추가 함수
  function addFavorite(stockCode) {
      console.log("addFavorite 버튼 클릭");
      fetch('${pageContext.request.contextPath}/stock/add-favorite', {
          method: 'POST',
          headers: {
              'Content-Type': 'application/json',
              'X-CSRF-TOKEN': document.querySelector('meta[name="_csrf"]')?.getAttribute('content')
          },
          body: JSON.stringify({
              stockCode: stockCode,
          })
      })
      .then(response => response.json())
      .then(data => {
          if (data.success) {
              alert('즐겨찾기에 추가되었습니다.');

              // 즐겨찾기 목록 재조회
              loadFavorites();

              // 검색 결과가 있는 경우 검색 결과도 재조회
              const searchKeyword = document.getElementById('searchKeyword')?.value;
              if (searchKeyword) {
                  const currentPage = document.querySelector('.page-item.active a')?.textContent || 1;
                  reloadSearchResults(searchKeyword, currentPage);
              } else {
                  location.reload();
              }
          } else {
              alert('즐겨찾기 추가에 실패했습니다: ' + data.message);
          }
      })
      .catch(error => {
          console.error('Error:', error);
          alert('요청 처리 중 오류가 발생했습니다.');
      });
  }

  // 검색 결과 재조회 함수
  function reloadSearchResults(keyword, page = 1) {
      var url = '${pageContext.request.contextPath}/stock/search?keyword=' + encodeURIComponent(keyword) + '&page=' + page;

      fetch(url, {
          method: 'GET',
          headers: {
              'Accept': 'application/json',
              'X-Requested-With': 'XMLHttpRequest'
          }
      })
      .then(response => response.json())
      .then(data => {
          if (data.success) {
              updateSearchResultsTable(data.stockInfoList, data.currentPage, data.totalPages);
          } else {
              alert('검색 결과를 다시 불러오는데 실패했습니다.');
          }
      })
      .catch(error => {
          console.error('Error:', error);
          alert('검색 결과를 다시 불러오는데 실패했습니다.');
      });
  }

  // 검색 결과 테이블 업데이트 함수
  function updateSearchResultsTable(stockInfoList, currentPage, totalPages) {
      const searchResultCard = document.querySelector('.card:has(.card-header.bg-info)');
      if (!searchResultCard) return;

      const searchResultTableBody = searchResultCard.querySelector('tbody');
      searchResultTableBody.innerHTML = '';

      if (stockInfoList && stockInfoList.length > 0) {
          stockInfoList.forEach(result => {
              const row = document.createElement('tr');

              // 즐겨찾기 버튼 생성
              var favoriteButton = "";
              if (result.IS_FAVORITE) {
                  favoriteButton = '<button class="btn btn-sm btn-warning remove-favorite" data-stock-code="' + result.SRTNCD + '">'
                      + '<i class="fas fa-star"></i> 즐겨찾기 등록됨'
                      + '</button>';
              } else {
                  favoriteButton = '<button class="btn btn-sm btn-outline-warning add-favorite" data-stock-code="' + result.SRTNCD + '">'
                      + '<i class="far fa-star"></i> 즐겨찾기 추가'
                      + '</button>';
              }

              row.innerHTML = '<td>' + result.SRTNCD + '</td>'
                  + '<td>' + result.ITMSNM + '</td>'
                  + '<td>' + result.MRKTCTG + '</td>'
                  + '<td>' + favoriteButton + '</td>'
                  + '<td>'
                  + '<div class="btn-group">'
                  + '<a href="${pageContext.request.contextPath}/stock/detail-search?stockCode=' + result.SRTNCD + '" class="btn btn-sm btn-outline-info">'
                  + '<i class="fas fa-info-circle"></i> 상세'
                  + '</a>'
                  + '<a href="${pageContext.request.contextPath}/stock/analysis?stockCode=' + result.SRTNCD + '" class="btn btn-sm btn-outline-success">'
                  + '<i class="fas fa-chart-line"></i> 분석'
                  + '</a>'
                  + '</div>'
                  + '</td>';

              searchResultTableBody.appendChild(row);
          });

          // 새로 추가된 버튼들에 이벤트 리스너 등록
          attachEventListeners();

          // 페이징 업데이트
          updatePagination(currentPage, totalPages);
      } else {
          searchResultTableBody.innerHTML = '<tr><td colspan="5" class="text-center">검색 결과가 없습니다.</td></tr>';
      }
  }

  // 즐겨찾기 삭제 함수
  function removeFavorite(stockCode) {
      console.log("removeFavorite 버튼 클릭");
      if (!confirm(`${stockCode}를 즐겨찾기에서 삭제하시겠습니까?`)) {
          return;
      }

      fetch('${pageContext.request.contextPath}/stock/delete-favorite', {
          method: 'POST',
          headers: {
              'Content-Type': 'application/json',
              'X-CSRF-TOKEN': document.querySelector('meta[name="_csrf"]')?.getAttribute('content')
          },
          body: JSON.stringify({
              stockCode: stockCode
          })
      })
      .then(response => response.json())
      .then(data => {
          if (data.success) {
              alert('즐겨찾기에서 삭제되었습니다.');
              loadFavorites();

              const searchKeyword = document.getElementById('searchKeyword')?.value;
              if (searchKeyword) {
                  const currentPage = document.querySelector('.page-item.active a')?.textContent || 1;
                  reloadSearchResults(searchKeyword, currentPage);
              } else {
                  location.reload();
              }
          } else {
              alert('즐겨찾기 삭제에 실패했습니다: ' + data.message);
          }
      })
      .catch(error => {
          console.error('Error:', error);
          alert('요청 처리 중 오류가 발생했습니다.');
      });
  }

  // 즐겨찾기 목록 로드 함수
  function loadFavorites() {
      console.log("loadFavorites");

      const favoriteCard = document.querySelector('.card:has(.fa-star)');
      const favoriteTableBody = favoriteCard.querySelector('tbody');
      const badge = favoriteCard.querySelector('.badge');

      favoriteTableBody.innerHTML = '<tr><td colspan="5" class="text-center"><i class="fas fa-spinner fa-spin"></i> 즐겨찾기 목록을 불러오는 중...</td></tr>';

      fetch('${pageContext.request.contextPath}/stock/get-favorites', {
          method: 'GET',
          headers: {
              'Content-Type': 'application/json'
          }
      })
      .then(response => response.json())
      .then(data => {
          if (data.success) {
              if (badge) {
                  badge.textContent = (data.favorites ? data.favorites.length : 0) + '건';
              }

              if (data.favorites && data.favorites.length > 0) {
                  favoriteTableBody.innerHTML = '';

                  data.favorites.forEach(stock => {
                      const row = document.createElement('tr');
                      console.log("stock :::", stock);

                      row.innerHTML = '<td>' + stock.SRTNCD + '</td>'
                          + '<td><a href="${pageContext.request.contextPath}/stock/detail-search?stockCode=' + stock.SRTNCD + '&autoSearch=true">' + stock.ITMSNM + '</a></td>'
                          + '<td>' + stock.MRKTCTG + '</td>'
                          + '<td>'
                          + '<button class="btn btn-sm btn-warning remove-favorite" data-stock-code="' + stock.SRTNCD + '">'
                          + '<i class="fas fa-star"></i> 즐겨찾기 등록됨'
                          + '</button>'
                          + '</td>'
                          + '<td>'
                          + '<div class="btn-group">'
                          + '<a href="${pageContext.request.contextPath}/stock/detail-search?stockCode=' + stock.SRTNCD + '&autoSearch=true" class="btn btn-sm btn-outline-info">'
                          + '<i class="fas fa-info-circle"></i> 상세'
                          + '</a>'
                          + '<a href="${pageContext.request.contextPath}/stock/analysis?stockCode=' + stock.SRTNCD + '" class="btn btn-sm btn-outline-success">'
                          + '<i class="fas fa-chart-line"></i> 분석'
                          + '</a>'
                          + '</div>'
                          + '</td>';

                      favoriteTableBody.appendChild(row);
                  });

                  favoriteTableBody.querySelectorAll('.remove-favorite').forEach(button => {
                      button.addEventListener('click', function() {
                          const stockCode = this.getAttribute('data-stock-code');
                          removeFavorite(stockCode);
                      });
                  });
              } else {
                  favoriteTableBody.innerHTML = '<tr><td colspan="5" class="text-center">즐겨찾는 종목이 없습니다.</td></tr>';
              }
          } else {
              favoriteTableBody.innerHTML = '<tr><td colspan="5" class="text-center text-danger">즐겨찾기 목록을 불러오는데 실패했습니다: ' + (data.message || '알 수 없는 오류') + '</td></tr>';
          }
      })
      .catch(error => {
          console.error('Error:', error);
          favoriteTableBody.innerHTML = '<tr><td colspan="5" class="text-center text-danger">네트워크 오류가 발생했습니다.</td></tr>';
      });
  }

  // 이벤트 리스너 연결 함수
  function attachEventListeners() {
      document.querySelectorAll('.add-favorite').forEach(button => {
          button.addEventListener('click', function() {
              const stockCode = this.getAttribute('data-stock-code');
              addFavorite(stockCode);
          });
      });

      document.querySelectorAll('.remove-favorite').forEach(button => {
          button.addEventListener('click', function() {
              const stockCode = this.getAttribute('data-stock-code');
              removeFavorite(stockCode);
          });
      });
  }

  // 페이징 업데이트 함수
  // 페이징 업데이트 함수
  function updatePagination(currentPage, totalPages) {
      const paginationContainer = document.querySelector('.pagination');
      if (!paginationContainer) return;

      paginationContainer.innerHTML = '';

      // 이전 페이지 버튼
      const prevLi = document.createElement('li');
      if (currentPage === 1) {
          prevLi.className = 'page-item disabled';
      } else {
          prevLi.className = 'page-item';
      }

      prevLi.innerHTML = '<a class="page-link" href="${pageContext.request.contextPath}/stock/search?page=' + (currentPage - 1) + '&keyword=' + document.getElementById('searchKeyword').value + '" aria-label="Previous">'
          + '<span aria-hidden="true">&laquo;</span>'
          + '</a>';
      paginationContainer.appendChild(prevLi);

      // 페이지 번호
      const startPage = totalPages <= 10 ? 1 :
          (currentPage <= 6 ? 1 :
          (currentPage > totalPages - 5 ? totalPages - 9 : currentPage - 5));
      const endPage = totalPages <= 10 ? totalPages :
          (currentPage <= 6 ? 10 :
          (currentPage > totalPages - 5 ? totalPages : currentPage + 4));

      for (let i = startPage; i <= endPage; i++) {
          const pageLi = document.createElement('li');
          if (i === currentPage) {
              pageLi.className = 'page-item active';
          } else {
              pageLi.className = 'page-item';
          }

          pageLi.innerHTML = '<a class="page-link" href="${pageContext.request.contextPath}/stock/search?page=' + i + '&keyword=' + document.getElementById('searchKeyword').value + '">' + i + '</a>';
          paginationContainer.appendChild(pageLi);
      }

      // 다음 페이지 버튼
      const nextLi = document.createElement('li');
      if (currentPage === totalPages) {
          nextLi.className = 'page-item disabled';
      } else {
          nextLi.className = 'page-item';
      }

      nextLi.innerHTML = '<a class="page-link" href="${pageContext.request.contextPath}/stock/search?page=' + (currentPage + 1) + '&keyword=' + document.getElementById('searchKeyword').value + '" aria-label="Next">'
          + '<span aria-hidden="true">&raquo;</span>'
          + '</a>';
      paginationContainer.appendChild(nextLi);
  }
</script>
</body>
</html>
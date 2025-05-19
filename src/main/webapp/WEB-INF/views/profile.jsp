<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
  <meta name="description" content="User Profile Management" />
  <meta name="author" content="" />
  <title>프로필 설정</title>
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

    .card {
        border-radius: 10px;
        margin-bottom: 20px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    }

    .card-header {
        border-radius: 10px 10px 0 0 !important;
        font-weight: 600;
    }

    .form-label {
        font-weight: 500;
    }

    .certificate-item {
        background-color: #f8f9fa;
        border-radius: 8px;
        padding: 15px;
        margin-bottom: 15px;
        position: relative;
    }

    .certificate-item .remove-btn {
        position: absolute;
        top: 10px;
        right: 10px;
    }

    .profile-picture {
        width: 150px;
        height: 150px;
        border-radius: 50%;
        object-fit: cover;
        margin-bottom: 15px;
        border: 3px solid var(--primary-color);
    }

    .profile-upload-btn {
        margin-bottom: 20px;
    }

    .input-with-icon {
        position: relative;
    }

    .input-with-icon .form-control {
        padding-right: 40px;
    }

    .input-with-icon .icon {
        position: absolute;
        right: 10px;
        top: 50%;
        transform: translateY(-50%);
    }

    .verification-badge {
        padding: 3px 8px;
        border-radius: 10px;
        font-size: 0.75rem;
        margin-left: 10px;
    }

    .address-container {
        position: relative;
    }

    .address-search-btn {
        position: absolute;
        right: 0;
        top: 0;
        height: 38px;
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
        <h2><i class="fas fa-user-cog"></i> 프로필 설정</h2>
        <p class="text-muted">회원님의 프로필 정보를 설정하세요. 정보는 언제든지 수정 가능합니다.</p>

        <form id="profileForm" action="${pageContext.request.contextPath}/member/update-profile" method="post" enctype="multipart/form-data">
          <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

          <!-- 기본 정보 섹션 -->
          <div class="card mb-4">
            <div class="card-header bg-primary text-white">
              <i class="fas fa-id-card"></i> 기본 정보
            </div>
            <div class="card-body">
              <div class="row">
                <!-- 프로필 사진 영역 -->
                <div class="col-md-3 text-center mb-4 mb-md-0">
                  <img src="${memberDetail.profileImage != null ? memberDetail.profileImage.replace('/resources/static', '') : '/profile/default_profile.png'}"
                         alt="프로필 사진" class="profile-picture" id="profileImagePreview">
                  <div class="mb-3">
                    <label for="profileImage" class="btn btn-outline-primary btn-sm profile-upload-btn">
                      <i class="fas fa-camera"></i> 사진 변경
                    </label>
                    <input type="file" class="d-none" id="profileImage" name="profileImage" accept="image/*">
                  </div>
                </div>

                <!-- 기본 정보 입력 필드 -->
                <div class="col-md-9">
                    <div class="row mb-3">
                      <div class="col-md-6">
                        <label for="memberId" class="form-label">아이디</label>
                        <input type="text" class="form-control" id="memberId" name="memberId" value="${sessionScope.loginId}" readonly tabindex="-1">
                      </div>
                      <div class="col-md-6">
                        <label for="memberName" class="form-label">이름</label>
                        <input type="text" class="form-control" id="memberName" name="memberName" value="${sessionScope.loginUserName}" readonly tabindex="-1">
                      </div>
                    </div>

                  <div class="row mb-3">
                    <div class="col-md-6">
                      <label for="birthDate" class="form-label">생년월일</label>
                      <input type="date" class="form-control" id="birthDate" name="birthDate" value="${memberDetail.birthDate}" required>
                    </div>
                    <div class="col-md-6">
                      <label for="phoneNumber" class="form-label">핸드폰 번호</label>
                      <input type="tel" class="form-control" id="phoneNumber" name="phoneNumber" value="${memberDetail.phoneNumber}"
                             placeholder="010-0000-0000" pattern="[0-9]{3}-[0-9]{4}-[0-9]{4}" required>
                    </div>
                  </div>

                  <div class="row mb-3">
                    <div class="col-md-6">
                      <label for="email" class="form-label">이메일</label>
                      <div class="input-with-icon">
                        <input type="email" class="form-control" id="email" name="email" value="${sessionScope.loginUserEmail}" tabindex="-1">
                        <span class="icon">
                          <c:choose>
                            <c:when test="${member.emailVerified eq '1'}">
                              <span class="badge bg-success verification-badge">인증됨</span>
                            </c:when>
                            <c:otherwise>
                              <button type="button" class="btn btn-sm btn-outline-warning" id="verifyEmailBtn">인증하기</button>
                            </c:otherwise>
                          </c:choose>
                        </span>
                      </div>
                    </div>
                    <div class="col-md-6">
                      <label for="gender" class="form-label">성별</label>
                      <select class="form-select" id="gender" name="gender">
                        <option value="">선택하세요</option>
                        <option value="M" ${memberDetail.gender eq 'M' ? 'selected' : ''}>남성</option>
                        <option value="F" ${memberDetail.gender eq 'F' ? 'selected' : ''}>여성</option>
                        <option value="O" ${memberDetail.gender eq 'O' ? 'selected' : ''}>기타</option>
                      </select>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- 주소 정보 섹션 -->
          <div class="card mb-4">
            <div class="card-header bg-primary text-white">
              <i class="fas fa-map-marker-alt"></i> 주소 정보
            </div>
            <div class="card-body">
              <div class="row mb-3">
                <div class="col-md-6">
                  <label for="postcode" class="form-label">우편번호</label>
                  <div class="input-group">
                    <input type="text" class="form-control" id="postcode" name="postcode" value="${memberDetail.postcode}" readonly>
                    <button type="button" class="btn btn-primary" id="addressSearchBtn">
                      <i class="fas fa-search"></i> 주소 검색
                    </button>
                  </div>
                </div>
              </div>

              <div class="row mb-3">
                <div class="col-md-12">
                  <label for="address1" class="form-label">기본주소</label>
                  <input type="text" class="form-control" id="address1" name="address1" value="${memberDetail.address1}" readonly>
                </div>
              </div>

              <div class="row mb-3">
                <div class="col-md-12">
                  <label for="address2" class="form-label">상세주소</label>
                  <input type="text" class="form-control" id="address2" name="address2" value="${memberDetail.address2}">
                </div>
              </div>
            </div>
          </div>

          <!-- 학력 정보 섹션 -->
          <div class="card mb-4">
            <div class="card-header bg-primary text-white">
              <i class="fas fa-graduation-cap"></i> 학력 정보
            </div>
            <div class="card-body">
              <div class="row mb-3">
                <div class="col-md-6">
                  <label for="highSchool" class="form-label">고등학교</label>
                  <input type="text" class="form-control" id="highSchool" name="highSchool" value="${memberDetail.highSchool}" placeholder="고등학교 이름">
                </div>
                <div class="col-md-6">
                  <label for="highSchoolGraduationYear" class="form-label">졸업년도</label>
                  <input type="number" class="form-control" id="highSchoolGraduationYear" name="highSchoolGraduationYear"
                         value="${memberDetail.highSchoolGraduationYear}" placeholder="YYYY" min="1900" max="2100">
                </div>
              </div>

              <hr class="my-4">

              <div class="row mb-3">
                <div class="col-md-6">
                  <label for="university" class="form-label">대학교</label>
                  <div class="input-group">
                    <input type="text" class="form-control" id="university" name="university" value="${memberDetail.university}" placeholder="대학교 이름">
                    <button type="button" class="btn btn-secondary" id="searchUniversityBtn">검색</button>
                  </div>
                </div>
                <div class="col-md-6">
                  <label for="universityStatus" class="form-label">대학 상태</label>
                  <select class="form-select" id="universityStatus" name="universityStatus">
                    <option value="">선택하세요</option>
                    <option value="재학" ${memberDetail.universityStatus eq '재학' ? 'selected' : ''}>재학</option>
                    <option value="휴학" ${memberDetail.universityStatus eq '휴학' ? 'selected' : ''}>휴학</option>
                    <option value="졸업" ${memberDetail.universityStatus eq '졸업' ? 'selected' : ''}>졸업</option>
                    <option value="중퇴" ${memberDetail.universityStatus eq '중퇴' ? 'selected' : ''}>중퇴</option>
                  </select>
                </div>
              </div>

              <div class="row mb-3">
                <div class="col-md-6">
                  <label for="major" class="form-label">학과/전공</label>
                  <input type="text" class="form-control" id="major" name="major" value="${memberDetail.major}" placeholder="학과 또는 전공명">
                </div>
                <div class="col-md-6">
                  <label for="gpa" class="form-label">학점</label>
                  <div class="input-group">
                    <input type="number" class="form-control" id="gpa" name="gpa" value="${memberDetail.gpa}" step="0.01" min="0" max="4.5" placeholder="0.00">
                    <span class="input-group-text">/ 4.5</span>
                  </div>
                </div>
              </div>

              <div class="row mb-3">
                <div class="col-md-6">
                  <label for="universityEntranceYear" class="form-label">입학년도</label>
                  <input type="number" class="form-control" id="universityEntranceYear" name="universityEntranceYear"
                         value="${memberDetail.universityEntranceYear}" placeholder="YYYY" min="1900" max="2100">
                </div>
                <div class="col-md-6">
                  <label for="universityGraduationYear" class="form-label">졸업(예정)년도</label>
                  <input type="number" class="form-control" id="universityGraduationYear" name="universityGraduationYear"
                         value="${memberDetail.universityGraduationYear}" placeholder="YYYY" min="1900" max="2100">
                </div>
              </div>
            </div>
          </div>

          <!-- 자격증 정보 섹션 -->
          <div class="card mb-4">
            <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
              <div>
                <i class="fas fa-certificate"></i> 자격증 정보
              </div>
              <button type="button" id="addCertificateBtn" class="btn btn-light btn-sm">
                <i class="fas fa-plus"></i> 자격증 추가
              </button>
            </div>
            <div class="card-body">
              <div id="certificatesContainer">
                <c:choose>
                  <c:when test="${not empty certificates}">
                    <c:forEach var="cert" items="${certificates}" varStatus="status">
                      <div class="certificate-item">
                        <div class="row">
                          <div class="col-md-6 mb-3">
                            <label class="form-label">자격증 이름</label>
                            <input type="text" class="form-control" name="certificates[${status.index}].name" value="${cert.name}" required>
                          </div>
                          <div class="col-md-6 mb-3">
                            <label class="form-label">발급 기관</label>
                            <input type="text" class="form-control" name="certificates[${status.index}].issuer" value="${cert.issuer}" required>
                          </div>
                        </div>
                        <div class="row">
                          <div class="col-md-6 mb-3">
                            <label class="form-label">취득일</label>
                            <input type="date" class="form-control" name="certificates[${status.index}].acquisitionDate" value="${cert.acquisitionDate}" required>
                          </div>
                          <div class="col-md-6 mb-3">
                            <label class="form-label">만료일 (선택사항)</label>
                            <input type="date" class="form-control" name="certificates[${status.index}].expirationDate" value="${cert.expirationDate}">
                          </div>
                        </div>
                        <button type="button" class="btn btn-danger btn-sm remove-btn remove-certificate">
                          <i class="fas fa-times"></i>
                        </button>
                      </div>
                    </c:forEach>
                  </c:when>
                  <c:otherwise>
                    <div class="text-center py-4 text-muted">
                      <i class="fas fa-certificate fa-2x mb-3"></i>
                      <p>등록된 자격증이 없습니다. 자격증 추가 버튼을 클릭하여 자격증을 등록해 주세요.</p>
                    </div>
                  </c:otherwise>
                </c:choose>
              </div>
            </div>
          </div>

          <!-- 제출 버튼 -->
          <div class="d-flex justify-content-between mb-5">
            <button type="button" class="btn btn-light" id="cancelBtn">
              <i class="fas fa-times"></i> 취소
            </button>
            <button type="submit" class="btn btn-primary px-4">
              <i class="fas fa-save"></i> 저장하기
            </button>
          </div>
        </form>
      </div>
    </div>

    <!-- 푸터 include -->
    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
  </div>
</div>

<!-- 대학교 검색 모달 -->
<div class="modal fade" id="universitySearchModal" tabindex="-1" aria-labelledby="universitySearchModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="universitySearchModalLabel">대학교 검색</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <div class="input-group mb-3">
          <input type="text" class="form-control" id="universitySearchInput" placeholder="대학교 이름 입력">
          <button class="btn btn-primary" id="searchUniversityModalBtn">검색</button>
        </div>
        <div id="universitySearchResults" class="mt-3">
          <!-- 검색 결과가 여기에 표시됩니다 -->
        </div>
      </div>
    </div>
  </div>
</div>

<!-- 이메일 인증 모달 -->
<div class="modal fade" id="emailVerificationModal" tabindex="-1" aria-labelledby="emailVerificationModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="emailVerificationModalLabel">이메일 인증</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <p>입력하신 이메일 주소로 인증 코드를 발송했습니다. 받으신 인증 코드를 입력해 주세요.</p>
        <div class="mb-3">
          <label for="verificationCode" class="form-label">인증 코드</label>
          <input type="text" class="form-control" id="verificationCode" placeholder="인증 코드 6자리 입력">
        </div>
        <div id="verificationResult"></div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
        <button type="button" class="btn btn-primary" id="submitVerificationBtn">확인</button>
      </div>
    </div>
  </div>
</div>

<!-- JS 라이브러리 -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.2.3/js/bootstrap.bundle.min.js"></script>
<!-- 카카오 주소 API -->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<script>
  $(document).ready(function() {
    // 사이드바 토글
    $('#sidebarToggle').on('click', function(e) {
      e.preventDefault();
      $('#sidebar-wrapper').toggleClass('toggled');
      $('#content-wrapper').toggleClass('toggled');
    });

    // 프로필 이미지 미리보기
    $('#profileImage').on('change', function(e) {
      const file = e.target.files[0];
      if (file) {
        const reader = new FileReader();
        reader.onload = function(e) {
          $('#profileImagePreview').attr('src', e.target.result);
        }
        reader.readAsDataURL(file);
      }
    });

    // 주소 검색 API 연동
    $('#addressSearchBtn').on('click', function() {
      new daum.Postcode({
        oncomplete: function(data) {
          $('#postcode').val(data.zonecode);
          $('#address1').val(data.address);
          $('#address2').focus();
        }
      }).open();
    });

    // 대학교 검색 모달 열기
    $('#searchUniversityBtn').on('click', function() {
      $('#universitySearchModal').modal('show');
    });

    // 대학교 검색 API 호출
    $('#searchUniversityModalBtn').on('click', function() {
      const keyword = $('#universitySearchInput').val();
      if (!keyword) {
        alert('검색어를 입력해주세요.');
        return;
      }

      console.log("keyword:::{}",keyword);

      // AJAX로 대학교 검색 API 호출
      $.ajax({
        url: '${pageContext.request.contextPath}/member/api/university/search',
        type: 'GET',
        data: { keyword: keyword },
        success: function(data) {
            console.log("API 응답:", data);
            console.log("응답 데이터 타입:", typeof data);
            console.log("배열 여부:", Array.isArray(data));

            displayUniversitySearchResults(data);
        },
        error: function(error) {
          $('#universitySearchResults').html('<div class="alert alert-danger">검색 중 오류가 발생했습니다.</div>');
          console.error('Error:', error);
        }
      });
    });

    // 대학교 검색 결과 표시 함수
    function displayUniversitySearchResults(data) {
      const resultsContainer = $('#universitySearchResults');

      if (!data || data.length === 0) {
        resultsContainer.html('<div class="alert alert-info">검색 결과가 없습니다.</div>');
        return;
      }

      let html = '<div class="list-group">';

      // 템플릿 리터럴 대신 표준 문자열 연결 사용
      for (let i = 0; i < data.length; i++) {
        const univ = data[i];
        console.log("대학 항목 #" + (i+1) + ":", univ); // 올바른 console.log 형식

        html += '<button type="button" class="list-group-item list-group-item-action univ-item" ' +
                'data-name="' + univ.name + '" data-id="' + univ.id + '">' +
                '<strong>' + univ.name + '</strong><br>' +
                '<small class="text-muted">' + univ.address + '</small>' +
                '</button>';
      }

      html += '</div>';
      console.log("생성된 HTML:", html);
      resultsContainer.html(html);

      // 대학교 선택 이벤트 처리
      $('.univ-item').on('click', function() {
        const univName = $(this).data('name');

        console.log("선택된 대학:", univName); // 선택된 대학 확인
        $('#university').val(univName);
        $('#universitySearchModal').modal('hide');
      });
    }

    // 이메일 인증 모달 열기
    $('#verifyEmailBtn').on('click', function() {
      const email = $('#email').val();
      if (!email) {
        alert('이메일 주소를 입력해주세요.');
        return;
      }

      // 이메일 인증 코드 발송 요청
      $.ajax({
        url: '${pageContext.request.contextPath}/member/send-verification-email',
        type: 'POST',
        data: {
          email: email,
          _csrf: $("input[name='_csrf']").val()
        },
        success: function(response) {
          if (response.success) {
            $('#emailVerificationModal').modal('show');
          } else {
            alert('인증 이메일 발송에 실패했습니다: ' + response.message);
          }
        },
        error: function(error) {
          alert('인증 이메일 발송 중 오류가 발생했습니다.');
          console.error('Error:', error);
        }
      });
    });

    // 인증 코드 확인
    $('#submitVerificationBtn').on('click', function() {
      const code = $('#verificationCode').val();
      if (!code) {
        alert('인증 코드를 입력해주세요.');
        return;
      }

      $.ajax({
        url: '${pageContext.request.contextPath}/member/verify-email-code',
        type: 'POST',
        data: {
          code: code,
          email: $('#email').val(),
          _csrf: $("input[name='_csrf']").val()
        },
        success: function(response) {
          if (response.success) {
            $('#verificationResult').html('<div class="alert alert-success">이메일이 성공적으로 인증되었습니다.</div>');
            setTimeout(function() {
              $('#emailVerificationModal').modal('hide');
              // 인증 성공 UI 업데이트
              $('#verifyEmailBtn').replaceWith('<span class="badge bg-success verification-badge">인증됨</span>');
            }, 1500);
          } else {
            $('#verificationResult').html('<div class="alert alert-danger">인증에 실패했습니다: ' + response.message + '</div>');
          }
        },
        error: function(error) {
          $('#verificationResult').html('<div class="alert alert-danger">인증 처리 중 오류가 발생했습니다.</div>');
          console.error('Error:', error);
        }
      });
    });

    // 자격증 추가 버튼 클릭 이벤트
    $('#addCertificateBtn').on('click', function() {
      addCertificateItem();
    });

     // 자격증 항목 추가 함수
     function addCertificateItem() {
       // 자격증 빈 안내 메시지 제거
       $('#certificatesContainer .text-center').remove();

       // 현재 자격증 항목 개수 확인
       const index = $('.certificate-item').length;

       // 새 자격증 항목 HTML 생성
       const certificateHtml = `
         <div class="certificate-item">
           <div class="row">
             <div class="col-md-6 mb-3">
               <label class="form-label">자격증 이름</label>
               <input type="text" class="form-control" name="certificates[${index}].name" required>
             </div>
             <div class="col-md-6 mb-3">
               <label class="form-label">발급 기관</label>
               <input type="text" class="form-control" name="certificates[${index}].issuer" required>
             </div>
           </div>
           <div class="row">
             <div class="col-md-6 mb-3">
               <label class="form-label">취득일</label>
               <input type="date" class="form-control" name="certificates[${index}].acquisitionDate" required>
             </div>
             <div class="col-md-6 mb-3">
               <label class="form-label">만료일 (선택사항)</label>
               <input type="date" class="form-control" name="certificates[${index}].expirationDate">
             </div>
           </div>
           <button type="button" class="btn btn-danger btn-sm remove-btn remove-certificate">
             <i class="fas fa-times"></i>
           </button>
         </div>
       `;

       // 자격증 컨테이너에 새 항목 추가
       $('#certificatesContainer').append(certificateHtml);

       // 삭제 버튼에 이벤트 핸들러 연결
       attachRemoveCertificateEvent();
     }

     // 자격증 삭제 버튼 이벤트 핸들러 연결
     function attachRemoveCertificateEvent() {
       $('.remove-certificate').off('click').on('click', function() {
         $(this).closest('.certificate-item').remove();

         // 자격증 항목이 없는 경우 안내 메시지 표시
         if ($('.certificate-item').length === 0) {
           $('#certificatesContainer').html(`
             <div class="text-center py-4 text-muted">
               <i class="fas fa-certificate fa-2x mb-3"></i>
               <p>등록된 자격증이 없습니다. 자격증 추가 버튼을 클릭하여 자격증을 등록해 주세요.</p>
             </div>
           `);
         } else {
           // 인덱스 재정렬
           reindexCertificates();
         }
       });
     }

     // 자격증 인덱스 재정렬
     function reindexCertificates() {
       $('.certificate-item').each(function(idx) {
         $(this).find('input[name^="certificates"]').each(function() {
           const fieldName = $(this).attr('name').split('.')[1];
           $(this).attr('name', `certificates[${idx}].${fieldName}`);
         });
       });
     }

     // 초기 자격증 삭제 버튼 이벤트 등록
     attachRemoveCertificateEvent();

     // 취소 버튼 클릭 이벤트
     $('#cancelBtn').on('click', function() {
       if (confirm('변경 사항을 취소하고 이전 페이지로 돌아가시겠습니까?')) {
         window.history.back();
       }
     });

     // 폼 제출 이벤트
     $('#profileForm').on('submit', function(e) {
      // 기본 제출 동작 방지 - 페이지 리로드 없이 AJAX로 처리하기 위함
       e.preventDefault();

      // 새로운 FormData 객체 생성
      const formData = new FormData();

      // 자격증 외 모든 필드 추가
      // 'not'으로 자격증 관련 필드는 제외하고 나머지 모든 입력 요소를 선택
      $(this).find('input, select, textarea').not('[name^="certificates"]').each(function() {
        const name = $(this).attr('name');
        if (name && name !== '') {
          if ($(this).attr('type') === 'file' && this.files.length > 0) {
            formData.append(name, this.files[0]);
          } else {
            formData.append(name, $(this).val());
          }
        }
      });

      // 자격증 데이터 수동 추가
      $('.certificate-item').each(function(idx) {
        console.log("인덱스:", idx);  // 인덱스 확인

        // 각 자격증 항목에서 입력 필드 찾기
        // eq(0)은 첫 번째 입력 필드, eq(1)은 두 번째... 순으로 접근
        const nameValue = $(this).find('input').eq(0).val();
        const issuerValue = $(this).find('input').eq(1).val();
        const acquisitionDateValue = $(this).find('input').eq(2).val();
        const expirationDateValue = $(this).find('input').eq(3).val();

        // 값 확인
        console.log("자격증 정보:", nameValue, issuerValue, acquisitionDateValue, expirationDateValue);

        // FormData에 추가 - 문자열 보간법 대신 문자열 연결 사용


        // FormData에 추가 - 문자열 보간법 대신 문자열 연결 사용
        // 배열 인덱스를 명시적으로 포함하여 서버에서 올바르게 처리될 수 있도록 함
        formData.append("certificates[" + idx + "].name", nameValue);
        formData.append("certificates[" + idx + "].issuer", issuerValue);
        formData.append("certificates[" + idx + "].acquisitionDate", acquisitionDateValue);

        if (expirationDateValue) {
          formData.append("certificates[" + idx + "].expirationDate", expirationDateValue);
        }
      });

      // 디버깅용 로그
      console.log("시작----");
      for (var pair of formData.entries()) {
        console.log(pair[0] + ': ' + pair[1]);
      }

       // AJAX 요청
       $.ajax({
         url: $(this).attr('action'),
         type: 'POST',
         data: formData,
         processData: false,
         contentType: false,
         success: function(response) {
           if (response.success) {
             alert('프로필이 성공적으로 업데이트되었습니다.');
             window.location.href = '${pageContext.request.contextPath}/member/profile';
           } else {
             alert('프로필 업데이트에 실패했습니다: ' + response.message);
           }
         },
         error: function(error) {
           alert('프로필 업데이트 중 오류가 발생했습니다.');
           console.error('Error:', error);
         }
       });
     });

     // 전화번호 자동 형식 처리
     $('#phoneNumber').on('input', function() {
       let value = $(this).val().replace(/[^0-9]/g, '');

       // 11자리까지만 입력 가능
       if (value.length > 11) {
         value = value.substring(0, 11);
       }

       // 전화번호 형식으로 변환 (000-0000-0000)
       if (value.length > 3 && value.length <= 7) {
         value = value.substring(0, 3) + '-' + value.substring(3);
       } else if (value.length > 7) {
         value = value.substring(0, 3) + '-' + value.substring(3, 7) + '-' + value.substring(7);
       }

       $(this).val(value);
     });

     // 이메일 변경 감지 및 인증 상태 업데이트
     $('#email').on('change', function() {
       const currentEmail = $(this).data('original-email');
       const newEmail = $(this).val();

       if (currentEmail && currentEmail !== newEmail) {
         // 이메일이 변경되었으면 인증 상태 초기화
         $('.verification-badge').remove();
         $('#verifyEmailBtn').remove();
         $(this).parent().find('.icon').html('<button type="button" class="btn btn-sm btn-outline-warning" id="verifyEmailBtn">인증하기</button>');

         // 새로운 인증 버튼에 이벤트 연결
         $('#verifyEmailBtn').on('click', function() {
           const email = $('#email').val();
           if (!email) {
             alert('이메일 주소를 입력해주세요.');
             return;
           }

           // 이메일 인증 코드 발송 요청
           $.ajax({
             url: '${pageContext.request.contextPath}/member/send-verification-email',
             type: 'POST',
             data: {
               email: email,
               _csrf: $("input[name='_csrf']").val()
             },
             success: function(response) {
               if (response.success) {
                 $('#emailVerificationModal').modal('show');
               } else {
                 alert('인증 이메일 발송에 실패했습니다: ' + response.message);
               }
             },
             error: function(error) {
               alert('인증 이메일 발송 중 오류가 발생했습니다.');
               console.error('Error:', error);
             }
           });
         });
       }
     });

     // 이메일 초기값 저장
     $('#email').data('original-email', $('#email').val());
  });

</script>


<%@ include file="/WEB-INF/views/common/footer.jsp" %>
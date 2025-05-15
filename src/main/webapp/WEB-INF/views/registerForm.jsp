<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <meta name="description" content="회원가입 페이지" />
    <meta name="author" content="" />
    <title>회원가입 - YOUNG 대시보드</title>
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
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            margin: 0;
            padding: 20px;
        }

        .auth-container {
            width: 100%;
            max-width: 420px;
            padding: 30px;
            border-radius: 20px;
            background-color: white;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.05);
            margin: 0 auto; /* 중앙 정렬을 위해 추가 */
        }

        .logo-container {
            text-align: center;
            margin-bottom: 30px;
        }

        .brand-logo {
            font-weight: 700;
            font-size: 1.8rem;
            color: var(--primary-color);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
        }

        .form-title {
            font-weight: 700;
            margin-bottom: 25px;
            text-align: center;
            color: var(--text-dark);
        }

        .form-control {
            height: 50px;
            padding: 10px 16px;
            border-radius: 10px;
            border: 1px solid rgba(0, 0, 0, 0.1);
            font-size: 1rem;
            margin-bottom: 15px;
            transition: all 0.3s;
            box-shadow: none;
        }

        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(67, 97, 238, 0.2);
        }

        .form-label {
            font-weight: 600;
            color: var(--text-dark);
            margin-bottom: 8px;
        }

        .btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
            height: 50px;
            border-radius: 10px;
            font-weight: 600;
            transition: all 0.3s;
            width: 100%;
            margin-top: 10px;
        }

        .btn-primary:hover {
            background-color: var(--secondary-color);
            border-color: var(--secondary-color);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(67, 97, 238, 0.2);
        }

        .auth-footer {
            text-align: center;
            margin-top: 20px;
            color: var(--text-light);
            font-size: 0.9rem;
        }

        .auth-footer a {
            color: var(--primary-color);
            font-weight: 600;
            text-decoration: none;
        }

        .auth-footer a:hover {
            text-decoration: underline;
        }

        .input-group {
            position: relative;
            margin-bottom: 15px;
        }

        .input-icon {
            position: absolute;
            left: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-light);
            z-index: 10;
        }

        .input-group .form-control {
            padding-left: 45px;
        }

        .error-message {
            color: var(--danger-color);
            font-size: 0.85rem;
            margin-top: -8px;
            margin-bottom: 15px;
            display: block;
        }

        .card-image {
            position: absolute;
            top: 0;
            right: 0;
            width: 45%;
            height: 100%;
            background-image: url('${pageContext.request.contextPath}/api/placeholder/500/700');
            background-size: cover;
            background-position: center;
            border-top-right-radius: 20px;
            border-bottom-right-radius: 20px;
            display: none;
        }

        @media (min-width: 768px) {
            .auth-container {
                max-width: 500px; /* 더 작게 조정 */
                overflow: hidden;
                padding: 40px;
            }

            .form-container {
                width: 100%; /* 전체 너비 사용 */
                padding: 0;
            }

            .card-image {
                display: none; /* 이미지 숨기기 */
            }
        }

        /* 큰 화면에서도 중앙 정렬 유지 */
        @media (min-width: 992px) {
            .auth-container {
                max-width: 550px;
            }
        }
    </style>
</head>
<body>
    <div class="auth-container">
        <div class="form-container">
            <div class="logo-container">
                <a href="${pageContext.request.contextPath}/" class="brand-logo">
                    <i class="fas fa-cube me-2"></i>YOUNG
                </a>
                <p class="mt-2 text-muted">개인화된 대시보드 서비스</p>
            </div>

            <h2 class="form-title">회원가입</h2>

            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger" role="alert">
                    <i class="fas fa-exclamation-circle me-2"></i>${errorMessage}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/member/register" method="post">
                <div class="input-group">
                    <i class="fas fa-id-card input-icon"></i>
                    <input type="text" class="form-control" id="id" name="id" placeholder="사용자 ID" required>
                </div>

                <div class="input-group">
                    <i class="fas fa-user input-icon"></i>
                    <input type="text" class="form-control" id="username" name="username" placeholder="사용자 이름" required>
                </div>

                <div class="input-group">
                    <i class="fas fa-lock input-icon"></i>
                    <input type="password" class="form-control" id="password" name="password" placeholder="비밀번호" required>
                </div>

                <div class="input-group">
                    <i class="fas fa-lock input-icon"></i>
                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" placeholder="비밀번호 확인" required>
                </div>

                <div class="input-group">
                    <i class="fas fa-envelope input-icon"></i>
                    <input type="email" class="form-control" id="email" name="email" placeholder="이메일" required>
                </div>

                <button type="submit" class="btn btn-primary">가입하기</button>
            </form>

            <div class="auth-footer">
                <p>이미 계정이 있으신가요? <a href="/member/login">로그인</a></p>
            </div>
        </div>
        <div class="card-image"></div>
    </div>

    <!-- Bootstrap core JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

    <!-- 간단한 비밀번호 일치 검증 -->
    <script>
        $(document).ready(function(){
            $('form').submit(function(e){
                var password = $('#password').val();
                var confirmPassword = $('#confirmPassword').val();

                if(password !== confirmPassword) {
                    e.preventDefault();
                    alert('비밀번호가 일치하지 않습니다.');
                    return false;
                }
            });
        });
    </script>
</body>
</html>
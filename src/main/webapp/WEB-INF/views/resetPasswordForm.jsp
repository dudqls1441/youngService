<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <meta name="description" content="비밀번호 재설정 페이지" />
    <meta name="author" content="" />
    <title>비밀번호 재설정 - 영빈 대시보드</title>
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
            margin: 0 auto;
        }

        .form-container {
            width: 100%;
            padding: 20px;
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

        .form-description {
            text-align: center;
            color: var(--text-light);
            margin-bottom: 25px;
            font-size: 0.95rem;
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

        .step-indicator {
            display: flex;
            justify-content: center;
            margin-bottom: 25px;
        }

        .step {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            background-color: var(--bg-light);
            color: var(--text-light);
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 10px;
            font-weight: 600;
            font-size: 0.9rem;
            position: relative;
        }

        .step.active {
            background-color: var(--primary-color);
            color: white;
        }

        .step::after {
            content: '';
            position: absolute;
            width: 20px;
            height: 2px;
            background-color: var(--bg-light);
            right: -20px;
            top: 50%;
            transform: translateY(-50%);
        }

        .step:last-child::after {
            display: none;
        }

        .step.completed {
            background-color: var(--success-color);
            color: white;
        }

        .step.completed::after {
            background-color: var(--success-color);
        }

        .verification-code {
            letter-spacing: 0.5em;
            font-weight: 600;
        }

        .password-strength {
            margin-top: 5px;
            font-size: 0.85rem;
        }

        .password-strength .weak {
            color: var(--danger-color);
        }

        .password-strength .medium {
            color: var(--warning-color);
        }

        .password-strength .strong {
            color: var(--success-color);
        }

        .password-match {
            font-size: 0.85rem;
            margin-top: 5px;
        }

        .password-match .match {
            color: var(--success-color);
        }

        .password-match .not-match {
            color: var(--danger-color);
        }

        @media (min-width: 768px) {
            .auth-container {
                max-width: 500px;
                overflow: hidden;
                padding: 40px;
            }

            .form-container {
                width: 100%;
                padding: 0;
            }
        }

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

            <h2 class="form-title">비밀번호 재설정</h2>

            <div class="step-indicator">
                <div class="step completed">1</div>
                <div class="step active">2</div>
            </div>

            <p class="form-description">이메일로 전송된 인증번호를 입력하고 새 비밀번호를 설정하세요.</p>

            <c:if test="${not empty successMessage}">
                <div class="alert alert-success" role="alert">
                    <i class="fas fa-check-circle me-2"></i>${successMessage}
                </div>
            </c:if>

            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger" role="alert">
                    <i class="fas fa-exclamation-circle me-2"></i>${errorMessage}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/member/resetPassword" method="post">
                <input type="hidden" name="email" value="${email}">

                <div class="input-group">
                    <i class="fas fa-key input-icon"></i>
                    <input type="text" class="form-control verification-code" id="verificationCode" name="verificationCode" placeholder="인증번호" required maxlength="6">
                </div>

                <div class="input-group">
                    <i class="fas fa-lock input-icon"></i>
                    <input type="password" class="form-control" id="newPassword" name="newPassword" placeholder="새 비밀번호" required minlength="8">
                </div>
                <div class="password-strength">
                    <span id="passwordStrength"></span>
                </div>

                <div class="input-group">
                    <i class="fas fa-lock input-icon"></i>
                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" placeholder="새 비밀번호 확인" required minlength="8">
                </div>
                <div class="password-match">
                    <span id="passwordMatch"></span>
                </div>

                <button type="submit" class="btn btn-primary" id="resetBtn" disabled>비밀번호 재설정</button>
            </form>

            <div class="auth-footer">
                <p>계정이 기억나셨나요? <a href="${pageContext.request.contextPath}/member/login">로그인</a></p>
            </div>
        </div>
    </div>

    <!-- Bootstrap core JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script>
        $(document).ready(function() {
            // 비밀번호 강도 체크
            $('#newPassword').on('input', function() {
                const password = $(this).val();
                let strength = '';
                let strengthClass = '';

                if (password.length < 8) {
                    strength = '비밀번호는 최소 8자 이상이어야 합니다.';
                    strengthClass = 'weak';
                } else if (password.match(/[a-z]/) && password.match(/[A-Z]/) && password.match(/[0-9]/) && password.match(/[^a-zA-Z0-9]/)) {
                    strength = '강함: 안전한 비밀번호입니다.';
                    strengthClass = 'strong';
                } else if ((password.match(/[a-z]/) || password.match(/[A-Z]/)) && password.match(/[0-9]/)) {
                    strength = '중간: 특수문자를 추가하면 더 안전합니다.';
                    strengthClass = 'medium';
                } else {
                    strength = '약함: 영문 대/소문자, 숫자, 특수문자를 조합하세요.';
                    strengthClass = 'weak';
                }

                $('#passwordStrength').html(strength).removeClass('weak medium strong').addClass(strengthClass);
                checkFormValidity();
            });

            // 비밀번호 일치 확인
            $('#confirmPassword').on('input', function() {
                const password = $('#newPassword').val();
                const confirmPassword = $(this).val();

                if (confirmPassword === '') {
                    $('#passwordMatch').html('');
                } else if (password === confirmPassword) {
                    $('#passwordMatch').html('비밀번호가 일치합니다.').removeClass('not-match').addClass('match');
                } else {
                    $('#passwordMatch').html('비밀번호가 일치하지 않습니다.').removeClass('match').addClass('not-match');
                }

                checkFormValidity();
            });

            // 인증번호 입력 확인
            $('#verificationCode').on('input', function() {
                checkFormValidity();
            });

            // 폼 유효성 검사 및 버튼 활성화
            function checkFormValidity() {
                const verificationCode = $('#verificationCode').val();
                const password = $('#newPassword').val();
                const confirmPassword = $('#confirmPassword').val();

                if (verificationCode.length === 6 && password.length >= 8 && password === confirmPassword) {
                    $('#resetBtn').prop('disabled', false);
                } else {
                    $('#resetBtn').prop('disabled', true);
                }
            }
        });
    </script>
</body>
</html>
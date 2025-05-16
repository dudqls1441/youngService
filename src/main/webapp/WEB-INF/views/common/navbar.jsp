<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- 상단 내비게이션 -->
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
                        <c:choose>
                            <c:when test="${empty sessionScope.loginId}">
                                <!-- 로그인 되어 있지 않은 경우 -->
                                <a class="dropdown-item" href="${pageContext.request.contextPath}/member/login">
                                    <i class="fas fa-sign-in-alt me-2"></i>로그인
                                </a>
                            </c:when>
                            <c:otherwise>
                                <!-- 로그인 되어 있는 경우 -->
                                <a class="dropdown-item" href="${pageContext.request.contextPath}/member/logout">
                                    <i class="fas fa-sign-out-alt me-2"></i>로그아웃
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </li>
            </ul>
        </div>
    </div>
</nav>
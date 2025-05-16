<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- 사이드바 -->
<div id="sidebar-wrapper">
    <div class="sidebar-heading border-bottom bg-light d-flex align-items-center">
        <i class="fas fa-cube me-2"></i>YOUNG
    </div>
    <div class="list-group list-group-flush">
        <a class="list-group-item list-group-item-action list-group-item-light ${pageContext.request.servletPath eq '/' ? 'active' : ''}" href="${pageContext.request.contextPath}/">
            <i class="fas fa-home me-2"></i>홈
        </a>
        <a class="list-group-item list-group-item-action list-group-item-light ${pageContext.request.servletPath eq '/dashboard' ? 'active' : ''}" href="${pageContext.request.contextPath}/dashboard">
            <i class="fas fa-tachometer-alt me-2"></i>지하철 도착 정보
        </a>
        <a class="list-group-item list-group-item-action list-group-item-light ${pageContext.request.servletPath eq '/stockinfo' ? 'active' : ''}" href="${pageContext.request.contextPath}/stockinfo">
            <i class="fas fa-tachometer-alt me-2"></i>주식 종목 정보
        </a>
        <a class="list-group-item list-group-item-action list-group-item-light ${pageContext.request.servletPath eq '/analysis' ? 'active' : ''}" href="${pageContext.request.contextPath}/analysis">
            <i class="fas fa-chart-pie me-2"></i>분석
        </a>
        <a class="list-group-item list-group-item-action list-group-item-light ${pageContext.request.servletPath eq '/performance' ? 'active' : ''}" href="/performance">
            <i class="fas fa-chart-pie me-2"></i>주식 비교
        </a>
        <a class="list-group-item list-group-item-action list-group-item-light ${pageContext.request.servletPath eq '/managementfootball' ? 'active' : ''}" href="/managementfootball">
            <i class="fas fa-futbol me-2"></i>풋살 밸런싱
        </a>
    </div>
</div>
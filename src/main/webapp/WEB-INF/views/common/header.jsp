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
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
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

        .page-container {
            width: 100%;
            padding-right: 15px;
            padding-left: 15px;
            margin-right: auto;
            margin-left: auto;
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

        .card-stockinfo {
            border-radius: 10px;
            margin-bottom: 20px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .card-football {
            border-radius: 10px;
            margin-bottom: 20px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
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
            text-align: left !important;
        }

        .card-header-left {
            border-radius: 10px 10px 0 0 !important;
            font-weight: 600;
        }

        .api-card-header {
            color : white !important;
            border-radius: 10px 10px 0 0 !important;
            font-weight: 500;
            padding: 1.25rem 1.5rem;
            display: flex;
            text-align: left !important;
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

        //풋볼

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
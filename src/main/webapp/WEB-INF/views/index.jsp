<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/sidebar.jsp" %>

<!-- 콘텐츠 래퍼 -->
<div id="content-wrapper">
    <%@ include file="/WEB-INF/views/common/navbar.jsp" %>

    <!-- 페이지 콘텐츠 -->
    <div id="page-content-wrapper">
        <div class="container-fluid">
            <!-- 환영 섹션 -->
            <section class="welcome-section mb-4">
                <div class="welcome-content">
                    <h2 class="fw-bold mb-2">안녕하세요, ${sessionScope.loginUserName}님!</h2>
                    <p class="mb-4">오늘도 좋은 하루 되세요. 귀하의 대시보드에 새로운 업데이트가 있습니다.</p>
                    <div class="d-flex">
                        <a href="#" class="btn btn-light btn-lg px-4 me-3">
                            <i class="fas fa-plus me-2"></i>새 프로젝트
                        </a>
                        <a href="#" class="btn btn-outline-light btn-lg px-4">
                            <i class="fas fa-chart-line me-2"></i>보고서 보기
                        </a>
                    </div>
                </div>
            </section>

            <!-- 메인 콘텐츠 -->
            <div class="row">
                <!-- 왼쪽 컬럼 -->
                <div class="col-lg-8">
                    <!-- 1. 즐겨찾기 종목의 주가 -->
                    <section class="mb-4">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="card-title"><i class="fas fa-chart-line me-2"></i>나의 즐겨찾기 종목</h5>
                                <a href="${pageContext.request.contextPath}/stockinfo" class="view-all">관리하기</a>
                            </div>
                            <div class="card-body p-0">
                                <c:choose>
                                    <c:when test="${not empty stockList}">
                                        <c:forEach items="${stockList}" var="stock">
                                            <div class="stock-item">
                                                <div class="stock-info">
                                                    <div class="stock-name">${stock.ITMSNM}</div>
                                                    <div class="stock-code">${stock.SRTNCD}</div>
                                                </div>
                                                <div class="text-end">
                                                    <div class="stock-price">
                                                        <fmt:formatNumber value="${stock.CLPR}" type="currency" currencyCode="KRW" />
                                                    </div>
                                                    <div class="stock-change ${stock.VS > 0 ? 'price-up' : 'price-down'}">
                                                        <i class="fas fa-caret-${stock.VS > 0 ? 'up' : 'down'} me-1"></i>
                                                        <fmt:formatNumber value="${stock.VS}" type="number" />원
                                                        (<fmt:formatNumber value="${stock.FLTRT}" type="percent" pattern="0.0'%'"/>)
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="p-3 text-center text-muted">
                                            즐겨찾기한 종목이 없습니다.
                                            <br>
                                            <a href="${pageContext.request.contextPath}/stockinfo" class="btn btn-sm btn-primary mt-2">
                                                <i class="fas fa-star me-1"></i>즐겨찾기 추가하기
                                            </a>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </section>

                    <!-- 2. 나의 즐겨찾기 역과 호선의 도착정보 -->
                    <section class="mb-4">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="card-title"><i class="fas fa-subway me-2"></i>나의 즐겨찾기 지하철</h5>
                                <a href="#" class="view-all">관리하기</a>
                            </div>
                            <div class="card-body p-0">
                                <!-- 데이터가 있을 때 -->
                                <c:choose>
                                    <c:when test="${not empty subwayList}">
                                        <c:forEach items="${subwayList}" var="subway">
                                            <div class="subway-item">
                                                <div class="d-flex align-items-start">
                                                    <c:set var="lineColor" value="#0D6EFD"/>
                                                    <c:set var="shortLineId" value="${subway.SUBWAYID}"/>
                                                    <c:choose>
                                                        <c:when test="${subway.SUBWAYID == '1001'}">
                                                            <c:set var="lineColor" value="#0052A4"/>
                                                            <c:set var="shortLineId" value="1"/>
                                                        </c:when>
                                                        <c:when test="${subway.SUBWAYID == '1002'}">
                                                            <c:set var="lineColor" value="#00A84D"/>
                                                            <c:set var="shortLineId" value="2"/>
                                                        </c:when>
                                                        <c:when test="${subway.SUBWAYID == '1003'}">
                                                            <c:set var="lineColor" value="#EF7C1C"/>
                                                            <c:set var="shortLineId" value="3"/>
                                                        </c:when>
                                                        <c:when test="${subway.SUBWAYID == '1004'}">
                                                            <c:set var="lineColor" value="#00A4E3"/>
                                                            <c:set var="shortLineId" value="4"/>
                                                        </c:when>
                                                        <c:when test="${subway.SUBWAYID == '1005'}">
                                                            <c:set var="lineColor" value="#996CAC"/>
                                                            <c:set var="shortLineId" value="5"/>
                                                        </c:when>
                                                        <c:when test="${subway.SUBWAYID == '1006'}">
                                                            <c:set var="lineColor" value="#CD7C2F"/>
                                                            <c:set var="shortLineId" value="6"/>
                                                        </c:when>
                                                        <c:when test="${subway.SUBWAYID == '1007'}">
                                                            <c:set var="lineColor" value="#747F00"/>
                                                            <c:set var="shortLineId" value="7"/>
                                                        </c:when>
                                                        <c:when test="${subway.SUBWAYID == '1008'}">
                                                            <c:set var="lineColor" value="#E6186C"/>
                                                            <c:set var="shortLineId" value="8"/>
                                                        </c:when>
                                                        <c:when test="${subway.SUBWAYID == '1009'}">
                                                            <c:set var="lineColor" value="#BDB092"/>
                                                            <c:set var="shortLineId" value="9"/>
                                                        </c:when>
                                                    </c:choose>

                                                    <div class="subway-line" style="background-color: ${lineColor};">${shortLineId}</div>
                                                    <div class="subway-info">
                                                        <div class="subway-station">${subway.STATNID}</div>
                                                        <div class="arrival-direction">
                                                            <c:choose>
                                                                <c:when test="${subway.UPDNLINE eq 'up'}">상행</c:when>
                                                                <c:when test="${subway.UPDNLINE eq 'down'}">하행</c:when>
                                                                <c:otherwise>${subway.UPDNLINE}</c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="text-end">
                                                    <button class="btn btn-sm btn-outline-primary me-2"
                                                            onclick="loadSubwayInfo('${subway.SUBWAYID}', '${subway.STATNID}', '${subway.UPDNLINE}')">
                                                        <i class="fas fa-search me-1"></i>조회
                                                    </button>
                                                    <button class="btn btn-sm btn-outline-primary">
                                                        <i class="fas fa-bell me-1"></i>알림
                                                    </button>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <!-- 데이터가 없을 때 보여줄 내용 -->
                                        <div class="p-4 text-center">
                                            <i class="fas fa-info-circle text-muted mb-3" style="font-size: 2rem;"></i>
                                            <p class="mb-0">등록된 즐겨찾기가 없습니다.</p>
                                            <p class="text-muted">지하철 정보 페이지에서 즐겨찾기를 추가해보세요.</p>
                                            <a href="/dashboard" class="btn btn-sm btn-primary mt-2">
                                                <i class="fas fa-plus me-1"></i>즐겨찾기 추가하기
                                            </a>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </section>
                </div>

                <!-- 오른쪽 컬럼 -->
                <div class="col-lg-4">
                    <!-- 3. 날씨 정보 -->
                    <section class="mb-4">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="card-title"><i class="fas fa-cloud-sun me-2"></i>날씨 정보</h5>
                                <div class="dropdown">
                                    <button class="btn btn-sm btn-outline-secondary dropdown-toggle" type="button" id="locationDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                                        ${selectedLocation}
                                    </button>
                                    <ul class="dropdown-menu" aria-labelledby="locationDropdown">
                                        <c:forEach items="${locationList}" var="location">
                                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/api/weather?location=${location}">${location}</a></li>
                                        </c:forEach>
                                    </ul>
                                </div>
                            </div>
                            <div class="card-body">
                                <div class="weather-info">
                                    <div class="weather-icon">
                                        <i class="fas fa-${weather.icon}"></i>
                                    </div>
                                    <div class="weather-temp">${weather.temperature}°</div>
                                    <div class="weather-details">
                                        <div class="weather-location">${weather.district}, ${weather.city}</div>
                                        <div class="weather-condition">${weather.condition} / 최고 ${weather.maxTemp}° 최저 ${weather.minTemp}°</div>
                                        <div class="weather-extra">
                                            <div><i class="fas fa-tint me-1"></i>습도 ${weather.humidity}%</div>
                                            <div><i class="fas fa-wind me-1"></i>풍속 ${weather.windSpeed}m/s</div>
                                        </div>
                                    </div>
                                </div>
                                <div class="row text-center mt-3">
                                    <c:forEach items="${weather.forecast}" var="forecast">
                                        <div class="col">
                                            <div class="small text-muted">${forecast.timeOfDay}</div>
                                            <div><i class="fas fa-${forecast.icon}"></i> ${forecast.temperature}°</div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>
                    </section>

                    <!-- 4. 추천 정보 -->
                    <section class="mb-4">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="card-title"><i class="fas fa-lightbulb me-2"></i>맞춤 추천</h5>
                                <a href="#" class="view-all">더보기</a>
                            </div>
                            <div class="card-body p-0">
                                <c:forEach items="${recommendationList}" var="recommendation">
                                    <div class="recommendation-item">
                                        <div class="recommendation-icon">
                                            <i class="fas fa-${recommendation.icon}"></i>
                                        </div>
                                        <div class="recommendation-info">
                                            <div class="recommendation-title">${recommendation.title}</div>
                                            <div class="recommendation-desc">${recommendation.description}</div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </section>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- 페이지별 고유 스크립트 -->
<script>
    $(document).ready(function() {
        $('.dropdown-item:not([href*="/member/"])').click(function(e) {
            e.preventDefault();
            const location = $(this).text();

            console.log("Selected location:", location);

            // AJAX 요청으로 날씨 정보만 업데이트
            $.ajax({
                url: '${pageContext.request.contextPath}/api/weather',
                data: { location: location },
                dataType: 'json',
                success: function(data) {
                    console.log("AJAX 응답:", data);
                    if (data.weathers) {
                        // 날씨 정보 업데이트
                        updateWeatherUI(data.weathers, location);
                    } else {
                        console.error("날씨 정보를 가져오는데 실패했습니다.");
                    }
                },
                error: function(xhr, status, error) {
                    console.error("AJAX 요청 실패:", error);
                }
            });
        });

        function updateWeatherUI(data, location) {
            console.log("weather::{}", data);
            const weather = data;

            // 여기서 날씨 정보를 표시하는 UI 요소들을 업데이트
            $('.weather-temp').text(weather.temperature + '°');
            $('.weather-location').text(weather.district + ', ' + weather.city);
            $('.weather-condition').text(weather.condition + ' / 최고 ' + weather.maxTemp + '° 최저 ' + weather.minTemp + '°');
            $('.weather-icon i').attr('class', 'fas fa-' + weather.icon);

            // 예보 업데이트
            const $forecastCols = $('.row.text-center.mt-3 .col');
            if (weather.forecast) {
                weather.forecast.forEach((forecast, index) => {
                    if (index < $forecastCols.length) {
                        $forecastCols.eq(index).html(
                            '<div class="small text-muted">' + forecast.timeOfDay + '</div>' +
                            '<div><i class="fas fa-' + forecast.icon + '"></i> ' + forecast.temperature + '°</div>'
                        );
                    }
                });
            }

            // 습도, 풍속 업데이트
            $('.weather-extra div:eq(0)').html(`<i class="fas fa-tint me-1"></i>습도 ${weather.humidity}%`);
            $('.weather-extra div:eq(1)').html(`<i class="fas fa-wind me-1"></i>풍속 ${weather.windSpeed}m/s`);

            // 선택된 위치 표시 업데이트
            $('#locationDropdown').text(location);
        }
    });

    function loadSubwayInfo(subwayId, stationId, updnLine) {
        // 지하철 정보 로드 함수
        console.log("지하철 정보 로드:", subwayId, stationId, updnLine);
        // 여기에 AJAX 요청 추가 가능
    }
</script>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
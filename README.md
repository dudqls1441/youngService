# 실시간 데이터 통합 대시보드 플랫폼


## 프로젝트 개요
공공 API와 주식 정보를 활용한 통합 데이터 분석 및 시각화 플랫폼으로, 다양한 실시간 데이터를 한 눈에 파악할 수 있는 대시보드를 제공합니다.

개발 기간: 2025.04 - 현재 진행중
개발 형태: 개인 프로젝트
기술 스택:

백엔드: Java, Python, Oracle DB
프론트엔드: JSP, HTML/CSS, JavaScript
인프라: Linux 서버
개발 도구: IntelliJ, Git/GitHub
API: RESTful API, 공공 데이터 포털 API, 금융 데이터 API



## 주요 기능
### 1. 실시간 공공 데이터 시각화

지하철 도착 정보 실시간 업데이트 및 시각화
날씨 정보 JSON 파싱 및 직관적 UI 제공
교통 정보 데이터 분석 및 대시보드 표시

#### 공공 데이터 포털에서 실시간 (30초 마다)으로 호출하여 즐겨찾기 및 검색을 통해 역과 호선에 해당하는 열차의 도착 정보를 보여준다.
#### 네이버지도 API를 연동해 검색된 역의 위치를 표시한다.

<div align="center">
  <img src="https://github.com/dudqls1441/youngService/blob/master/20250508_v0.1/2.%EC%8B%A4%EC%8B%9C%EA%B0%84%20%EB%8F%84%EC%B0%A9%20%EC%A0%95%EB%B3%B4.PNG" alt="실시간 지하철 도착 정보" width="80%">
  <p><em>역별 실시간 도착 정보 화면</em></p>
  <img src="https://github.com/dudqls1441/youngService/blob/master/20250508_v0.1/2.2.%EC%8B%A4%EC%8B%9C%EA%B0%84%20%EB%8F%84%EC%B0%A9%20%EC%A0%95%EB%B3%B4.PNG" alt="실시간 지하철 도착 정보 상세" width="80%">
  <p><em>지도 연동 및 상세 정보 화면</em></p>
</div>

### 2. 금융 데이터 분석 플랫폼

#### 자동화된 데이터 파이프라인: Python 스크립트를 통한 일일 주식 데이터 자동 수집 및 DB 저장
#### 종합 CRUD 시스템: 주식 정보의 완전한 관리 기능 제공
#### 개인화된 즐겨찾기: 관심 종목을 즐겨찾기하여 빠른 정보 접근
#### 머신러닝 기반 예측: Python ML 모델을 활용한 주가 예측 시각화
#### 데이터 기반 분석: 기간별, 종목별 비교 분석 및 통계 데이터 제공

<div align="center">
  <img src="https://github.com/dudqls1441/youngService/blob/master/20250508_v0.1/3.%EC%A3%BC%EC%8B%9D%20%EC%A0%95%EB%B3%B4.PNG" alt="주식 정보 대시보드" width="80%">
  <p><em>주식 정보 대시보드 메인 화면</em></p>
  <img src="https://github.com/dudqls1441/youngService/blob/master/20250508_v0.1/4.%EC%A3%BC%EC%8B%9D%20%EC%83%81%EC%84%B8%20%EC%A0%95%EB%B3%B4.PNG" alt="주식 상세 정보" width="80%">
  <p><em>종목별 상세 정보 및 차트</em></p>
  <img src="https://github.com/dudqls1441/youngService/blob/master/20250508_v0.1/4.2.%EC%A3%BC%EC%8B%9D%20%EC%83%81%EC%84%B8%20%EC%A0%95%EB%B3%B4%20%EB%8D%B0%EC%9D%B4%ED%84%B0%20%EB%B6%84%EC%84%9D.PNG" alt="주식 데이터 분석" width="80%">
  <p><em>머신러닝 기반 주가 분석 및 예측</em></p>
  <img src="https://github.com/dudqls1441/youngService/blob/master/20250508_v0.1/5.%EC%A3%BC%EC%8B%9D%20%EB%B9%84%EA%B5%90.PNG" alt="주식 변동 비교 정보" width="80%">
  <p><em>기간별 주가 변동 비교 분석</em></p>
</div>

### 3. 풋살팀 관리 시스템

풋살팀 인원 등록 및 관리 기능
매주 팀원의 능력치 기록 및 추적 시스템
Java 알고리즘을 활용한 최적의 팀 밸런스 자동 계산

## 기술 구현 상세
### 백엔드 아키텍처

Java 기반 백엔드 서비스: RESTful API 서버 구축으로 클라이언트-서버 통신 구현
Python 데이터 처리: 금융 데이터 분석 및 예측 모델 개발
Oracle DB: 효율적인 데이터 모델링과 저장소 구축

### 데이터 파이프라인

Linux 크론 작업을 통한 주기적 데이터 수집 및 처리 자동화
Python-Java 연동을 통한 실시간 데이터 처리 및 전달
데이터 정합성 검증 및 오류 처리 로직 구현

### 프론트엔드 및 데이터 시각화

JSP 기반 동적 웹 페이지 구현
반응형 대시보드 UI 설계
데이터 시각화 라이브러리를 활용한 직관적 차트 구현

## 주요 성과

다중 기술 스택 통합: Java와 Python의 장점을 결합한 효율적인 풀스택 아키텍처 구현
자동화 배치 처리: 주기적 데이터 수집 및 분석 자동화로 실시간 정보 제공 시스템 구축
고성능 데이터 시각화: 복잡한 금융 및 공공 데이터를 직관적으로 이해할 수 있는 대시보드 구현
팀 밸런싱 알고리즘: 풋살팀 멤버의 능력치를 분석하여 가장 공정한 팀 구성을 자동 계산하는 시스템 개발
클라우드 인프라 경험: Linux 기반 서버 환경 구축 및 관리 역량 강화

## 향후 개발 계획

AI 기반 데이터 예측 모델 추가
모바일 앱 버전 개발
사용자 계정 시스템 및 개인화 기능 강화
추가 데이터 소스 통합 및 API 확장

## 홈 화면 
![홈화면](https://github.com/dudqls1441/youngService/blob/master/20250508_v0.1/1.%ED%99%88.PNG)

![홈화면 날씨 정보](https://github.com/dudqls1441/youngService/blob/master/20250508_v0.1/1.2.%ED%99%88%20%EB%82%A0%EC%8B%9C.PNG)


## 실시간 지하철 도착 정보
공공 데이터 포털에서 실시간 (30초 마다)으로 호출하여 즐겨찾기 및 검색을 통해 역과 호선에 해당하는 열차의 도착 정보를 보여준다.
네이버지도 API를 연동해 검색된 역의 위치를 표시한다.


![실시간 지하철 도착 정보](https://github.com/dudqls1441/youngService/blob/master/20250508_v0.1/2.%EC%8B%A4%EC%8B%9C%EA%B0%84%20%EB%8F%84%EC%B0%A9%20%EC%A0%95%EB%B3%B4.PNG)

![실시간 지하철 도착 정보](https://github.com/dudqls1441/youngService/blob/master/20250508_v0.1/2.2.%EC%8B%A4%EC%8B%9C%EA%B0%84%20%EB%8F%84%EC%B0%A9%20%EC%A0%95%EB%B3%B4.PNG)

## 주식 정보 조회
Python에서 ORALCE을 연동하고 공공데이터포털 API를 호출하여 DB에 매일 저장하는 로직을 구현하고 
화면에서 CRUD와 즐겨찾기 기능을 제공한다. 
주식별 주가 예측 데이터 분석을 python ML구현 및 연동을 통해 시각화하여 화면에서 보여주는 기능을 제공하고,
기간별 전체 주식의 통계 데이터를 제공한다.

![주식 정보](https://github.com/dudqls1441/youngService/blob/master/20250508_v0.1/3.%EC%A3%BC%EC%8B%9D%20%EC%A0%95%EB%B3%B4.PNG)

![주식 상세 정보](https://github.com/dudqls1441/youngService/blob/master/20250508_v0.1/4.%EC%A3%BC%EC%8B%9D%20%EC%83%81%EC%84%B8%20%EC%A0%95%EB%B3%B4.PNG)

![주식 데이터 분석](https://github.com/dudqls1441/youngService/blob/master/20250508_v0.1/4.2.%EC%A3%BC%EC%8B%9D%20%EC%83%81%EC%84%B8%20%EC%A0%95%EB%B3%B4%20%EB%8D%B0%EC%9D%B4%ED%84%B0%20%EB%B6%84%EC%84%9D.PNG)

![주식 변동 정보](https://github.com/dudqls1441/youngService/blob/master/20250508_v0.1/5.%EC%A3%BC%EC%8B%9D%20%EB%B9%84%EA%B5%90.PNG)

![풋살팀 관리](https://github.com/dudqls1441/youngService/blob/master/20250508_v0.1/6.%ED%92%8B%EC%82%B4%20%EB%B0%B8%EB%9F%B0%EC%8B%B1.PNG)

![팀 밸런싱](https://github.com/dudqls1441/youngService/blob/master/20250508_v0.1/6.2%20%ED%8C%80%20%EB%B0%B8%EB%9F%B0%EC%8B%B1.PNG)

![팀 밸런싱 - 스네이크 드레프트](https://github.com/dudqls1441/youngService/blob/master/20250508_v0.1/6.3%20%ED%8C%80%EB%B0%B8%EB%9F%B0%EC%8B%B1%20_%20%EC%8A%A4%EB%84%A4%EC%9D%B4%ED%81%AC.PNG)

![팀 밸런싱 - 포지션](https://github.com/dudqls1441/youngService/blob/master/20250508_v0.1/6.4.%20%ED%8F%AC%EC%A7%80%EC%85%98%20%EB%B0%B8%EB%9F%B0%EC%8B%B1.PNG)

![주식 정보 배치 처리](https://github.com/dudqls1441/youngService/blob/master/20250508_v0.1/8.python%20%EB%B0%B0%EC%B9%98%EC%B2%98%EB%A6%AC%20%EC%A3%BC%EC%8B%9D%20%EC%A0%95%EB%B3%B4%20%EB%8B%A4%EC%9A%B4%EB%A1%9C%EB%93%9C%20%EB%B0%8F%20DB%20%EC%A0%80%EC%9E%A5.PNG)

![pythonn FLASK 서버](https://github.com/dudqls1441/youngService/blob/master/20250508_v0.1/9.%20%EC%86%8C%EC%8A%A4%20java%20flask%20%EC%84%9C%EB%B2%84%20%ED%86%B5%EC%8B%A0.PNG)

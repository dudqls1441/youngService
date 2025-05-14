# 실시간 데이터 통합 대시보드 플랫폼

[![Java](https://img.shields.io/badge/Java-ED8B00?style=for-the-badge&logo=java&logoColor=white)](https://www.java.com/)
[![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)](https://www.python.org/)
[![Oracle](https://img.shields.io/badge/Oracle-F80000?style=for-the-badge&logo=oracle&logoColor=white)](https://www.oracle.com/)
[![JSP](https://img.shields.io/badge/JSP-007396?style=for-the-badge&logo=java&logoColor=white)](https://www.oracle.com/)

<div align="center">
  <img src="https://github.com/dudqls1441/youngService/blob/master/20250508_v0.1/1.%ED%99%88.PNG" alt="프로젝트 메인 화면" width="80%">
</div>

## 📋 프로젝트 개요
공공 API와 주식 정보를 활용한 통합 데이터 분석 및 시각화 플랫폼으로, 다양한 실시간 데이터를 한 눈에 파악할 수 있는 대시보드와 풋살팀 관리 기능을 제공합니다.

- **개발 기간**: 2025.04 - 현재 진행중
- **개발 형태**: 개인 프로젝트
- **기술 스택**:
  - **백엔드**: Java, Python, Oracle DB
  - **프론트엔드**: JSP, HTML/CSS, JavaScript
  - **인프라**: Linux 서버
  - **개발 도구**: IntelliJ, Git/GitHub
  - **API**: RESTful API, 공공 데이터 포털 API, 금융 데이터 API

## 🛠️ 주요 기능

### 🌤️ 실시간 공공 데이터 시각화

**주요 특징:**
- **날씨 정보 시각화**: 공공 데이터 API를 통한 실시간 날씨 정보 JSON 파싱 및 직관적 UI 제공
- **실시간 업데이트**: 30초마다 최신 데이터 자동 갱신
- **맞춤형 즐겨찾기**: 자주 이용하는 역을 즐겨찾기하여 빠른 정보 확인
- **통합 검색 시스템**: 역명과 호선으로 간편하게 도착 정보 조회
- **지도 연동**: 네이버 지도 API를 활용한 역 위치 시각화

<div align="center">
  <img src="https://github.com/dudqls1441/youngService/blob/master/20250508_v0.1/1.2.%ED%99%88%20%EB%82%A0%EC%8B%9C.PNG" alt="날씨 정보" width="80%">
  <p><em>날씨 정보 화면</em></p>
  
  <img src="https://github.com/dudqls1441/youngService/blob/master/20250508_v0.1/2.%EC%8B%A4%EC%8B%9C%EA%B0%84%20%EB%8F%84%EC%B0%A9%20%EC%A0%95%EB%B3%B4.PNG" alt="실시간 지하철 도착 정보" width="80%">
  <p><em>역별 실시간 도착 정보 화면</em></p>
  
  <img src="https://github.com/dudqls1441/youngService/blob/master/20250508_v0.1/2.2.%EC%8B%A4%EC%8B%9C%EA%B0%84%20%EB%8F%84%EC%B0%A9%20%EC%A0%95%EB%B3%B4.PNG" alt="실시간 지하철 도착 정보 상세" width="80%">
  <p><em>지도 연동 및 상세 정보 화면</em></p>
</div>

### 📈 금융 데이터 분석 플랫폼

**주요 특징:**
- **자동화된 데이터 파이프라인**: Python 스크립트를 통한 일일 주식 데이터 자동 수집 및 DB 저장
- **종합 CRUD 시스템**: 주식 정보의 완전한 관리 기능 제공
- **개인화된 즐겨찾기**: 관심 종목을 즐겨찾기하여 빠른 정보 접근
- **머신러닝 기반 예측**: Python ML 모델을 활용한 주가 예측 시각화
- **데이터 기반 분석**: 기간별, 종목별 비교 분석 및 통계 데이터 제공

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

### ⚽ 풋살팀 관리 시스템

**주요 특징:**
- **팀원 관리 시스템**: 선수 정보 등록 및 데이터베이스 기반 체계적 관리
- **능력치 트래킹**: 매주 경기 결과에 따른 팀원별 능력치 기록 및 시간에 따른 변화 추적
- **알고리즘 기반 팀 밸런싱**: Java 알고리즘을 활용한 최적의 팀 구성 자동 계산
- **다양한 팀 구성 방식**: 랜덤, 스네이크 드래프트, 포지션별 밸런싱 등 다양한 팀 구성 옵션 제공
- **데이터 기반 의사결정**: 객관적인 능력치 데이터를 기반으로 공정한 팀 구성 지원

<div align="center">
  <img src="https://github.com/dudqls1441/youngService/blob/master/20250508_v0.1/6.2%20%ED%8C%80%20%EB%B0%B8%EB%9F%B0%EC%8B%B1.PNG" alt="팀 밸런싱 시스템" width="80%">
  <p><em>능력치 기반 자동 팀 밸런싱 화면</em></p>
  
  <img src="https://github.com/dudqls1441/youngService/blob/master/20250508_v0.1/6.3%20%ED%8C%80%EB%B0%B8%EB%9F%B0%EC%8B%B1%20_%20%EC%8A%A4%EB%84%A4%EC%9D%B4%ED%81%AC.PNG" alt="스네이크 드래프트 방식 팀 구성" width="80%">
  <p><em>스네이크 드래프트 방식의 균형 잡힌 팀 구성</em></p>
  
  <img src="https://github.com/dudqls1441/youngService/blob/master/20250508_v0.1/6.4.%20%ED%8F%AC%EC%A7%80%EC%85%98%20%EB%B0%B8%EB%9F%B0%EC%8B%B1.PNG" alt="포지션별 팀 밸런싱" width="80%">
  <p><em>포지션별 특성을 고려한 팀 밸런싱 결과</em></p>
</div>

## 🔧 기술 구현 상세

### 백엔드 아키텍처
- **Java 기반 백엔드 서비스**: RESTful API 서버 구축으로 클라이언트-서버 통신 구현
- **Python 데이터 처리**: 금융 데이터 분석 및 예측 모델 개발
- **Oracle DB**: 효율적인 데이터 모델링과 저장소 구축

### 데이터 파이프라인
- **자동화 배치 처리**: Linux 크론 작업을 통한 주기적 데이터 수집 및 처리 자동화
- **데이터 연동**: Python-Java 연동을 통한 실시간 데이터 처리 및 전달
- **데이터 검증**: 데이터 정합성 검증 및 오류 처리 로직 구현

<div align="center">
  <img src="https://github.com/dudqls1441/youngService/blob/master/20250508_v0.1/8.python%20%EB%B0%B0%EC%B9%98%EC%B2%98%EB%A6%AC%20%EC%A3%BC%EC%8B%9D%20%EC%A0%95%EB%B3%B4%20%EB%8B%A4%EC%9A%B4%EB%A1%9C%EB%93%9C%20%EB%B0%8F%20DB%20%EC%A0%80%EC%9E%A5.PNG" alt="주식 정보 배치 처리" width="80%">
  <p><em>Python 배치 처리를 통한 주식 정보 수집 및 DB 저장</em></p>
</div>

### 시스템 통합 및 서버 구성
- **멀티 서버 아키텍처**: Java 웹 서버와 Python Flask 서버의 효율적 연동
- **API 기반 통신**: RESTful API를 통한 서버 간 데이터 교환
- **확장 가능한 설계**: 모듈화된 시스템 구조로 새로운 기능 추가 용이

<div align="center">
  <img src="https://github.com/dudqls1441/youngService/blob/master/20250508_v0.1/9.%20%EC%86%8C%EC%8A%A4%20java%20flask%20%EC%84%9C%EB%B2%84%20%ED%86%B5%EC%8B%A0.PNG" alt="Python FLASK 서버" width="80%">
  <p><em>Java와 Python Flask 서버 간 통신 구조</em></p>
</div>

### 프론트엔드 및 데이터 시각화
- **JSP 기반 동적 웹 페이지**: 사용자 인터랙션에 반응하는 동적 UI 구현
- **반응형 대시보드**: 다양한 화면 크기에 최적화된 UI 설계
- **데이터 시각화**: 차트 라이브러리를 활용한 직관적 데이터 표현

## 🌟 주요 성과

- **다중 기술 스택 통합**: Java와 Python의 장점을 결합한 효율적인 풀스택 아키텍처 구현
- **자동화 배치 처리**: 주기적 데이터 수집 및 분석 자동화로 실시간 정보 제공 시스템 구축
- **고성능 데이터 시각화**: 복잡한 금융 및 공공 데이터를 직관적으로 이해할 수 있는 대시보드 구현
- **팀 밸런싱 알고리즘**: 풋살팀 멤버의 능력치를 분석하여 가장 공정한 팀 구성을 자동 계산하는 시스템 개발
- **클라우드 인프라 경험**: Linux 기반 서버 환경 구축 및 관리 역량 강화

## 📈 향후 개발 계획

- **AI 고도화**: 머신러닝 기반 금융 데이터 예측 모델 정확도 향상 및 풋살팀 성과 예측 기능 추가
- **모바일 지원**: 반응형 웹 및 전용 모바일 앱 버전 개발로 접근성 향상
- **사용자 경험 개선**: 계정 시스템 도입 및 개인화된 대시보드 설정 기능 구현
- **데이터 소스 확장**: 추가 공공 API 및 금융 데이터 소스 연동으로 정보 다양성 증대
- **실시간 알림 시스템**: 중요 이벤트 및 데이터 변화에 대한 푸시 알림 기능 구현
- **커뮤니티 기능**: 풋살팀 경기 일정 관리 및 결과 기록 시스템 추가

## 📞 연락처 및 라이센스

- **이메일**: [dudqls1441@naver.com](mailto:dudqls1441@naver.com)
- **GitHub**: [github.com/dudqls1441](https://github.com/dudqls1441)

이 프로젝트는 MIT 라이센스 하에 배포됩니다.

# 북스타 📚 - 알라딘 API와 함께하는 도서 관련 애플리케이션

[![Flutter Version](https://img.shields.io/badge/Flutter-3.29.2-blue.svg)](https://flutter.dev/)
[![Dart Version](https://img.shields.io/badge/Dart-3.7.2-blue.svg)](https://dart.dev/)
[![Java Version](https://img.shields.io/badge/Java-17-orange.svg)](https://www.oracle.com/java/technologies/javase/jdk17-archive-downloads.html)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Lints](https://img.shields.io/badge/Lints-flutter__lints_v5.0.0-blueviolet.svg)](https://pub.dev/packages/flutter_lints)

알라딘 API를 활용하여 도서 정보를 검색하고 관리할 수 있는 Flutter 기반의 모바일 애플리케이션입니다. BLoC (Cubit) 패턴을 기반으로 상태를 관리합니다.

## ✨ 주요 기능

* [ ] 도서 검색 (키워드, ISBN 등)
* [ ] 도서 상세 정보 조회

## 🛠️ 기술 스택 및 환경

* **Frontend:** Flutter `3.29.2`, Dart `3.7.2`
* **Backend:** Java `17`
* **상태 관리:** BLoC / Cubit
* **네트워킹:** Dio (`http` 통신 라이브러리), Interceptors (요청/응답 가로채기)
* **코드 스타일:** `flutter_lints: ^5.0.0`
* **API:** [Aladin Open API](https://www.aladin.co.kr/ttb/api/Default.aspx), [자체 백엔드 API (Swagger)](http://15.164.30.67:8080/api/)

## 📂 프로젝트 구조

이 프로젝트는 다음과 같은 폴더 구조를 따릅니다.

lib/
├── api/
│   └── service/        # API 통신 관련 서비스 로직
├── constants/          # 앱 전역 상수 (색상, 문자열 등)
├── global/
│   ├── functions/      # 전역 유틸리티 함수
│   └── state/          # 전역 상태 관리 로직 (필요시)
├── model/              # 데이터 모델 (DTOs, Entities)
├── pages/              # 각 화면(페이지) 단위 모듈
│   └── [feature_name]/ # 기능별 폴더 (예: search, detail, my_books)
│       ├── screen/     # UI 위젯 (View)
│       ├── state/      # 상태 관리 로직 (Cubit/Bloc)
│       └── widget/     # 해당 페이지 내에서 사용되는 공통 위젯
├── main.dart           # 앱 시작점
└── ...                 # 기타 설정 파일

## 🧱 상태 관리 (BLoC / Cubit)

* 이 프로젝트는 **BLoC 라이브러리 (주로 Cubit)** 를 사용하여 상태를 관리합니다.
* 서버에서 비동기 데이터를 가져오는 경우, `api/service`의 비동기 함수를 호출하고 `pages/[feature]/state` 내의 Cubit/Bloc에서 상태를 업데이트합니다. 이때 `BlocProvider`를 사용하여 위젯 트리에 상태 관리 객체를 제공합니다.
* 일부 전역적으로 관리되어야 하거나 간단한 상태는 `global/state` 에서 관리될 수 있습니다.

## 🚀 시작하기

### 사전 요구 사항

* Flutter SDK `3.29.2` 버전 설치
* Dart SDK `3.7.2` 버전 (Flutter SDK에 포함)
* Java `17` JDK 설치
* API 키 설정

### 설치 및 실행

1.  **저장소 클론:**
    ```bash
    git clone [GitHub 저장소 URL]
    cd [프로젝트 폴더 이름]
    ```
2.  **의존성 설치:**
    ```bash
    flutter pub get
    ```
3.  **(필요 시) 환경 변수 설정:**
    `lib/.env` 파일을 생성하고 필요한 API 키 등을 입력합니다.
    ```dotenv
    # lib/.env
    KAKAO_NATIVE_KEY=YOUR_KAKAO_API_KEY
    BASE_URL=[http://15.164.30.67:8080/api/](http://15.164.30.67:8080/api/)
    ```
    _참고: `.env` 파일은 보안을 위해 `.gitignore`에 추가하는 것을 강력히 권장합니다._
    ```gitignore
    # .gitignore
    *.env
    ```

4.  **앱 실행:**
    ```bash
    flutter run
    ```

## 📡 API 통신

* **Dio:** 서버와의 HTTP 통신을 위해 `Dio` 라이브러리를 사용합니다. `api/service` 디렉토리 내에서 주로 활용됩니다.
* **Interceptors:** 요청 전/후, 응답 전/후, 오류 발생 시 공통 로직(로깅, 헤더 추가, 에러 핸들링 등)을 처리하기 위해 Dio의 `Interceptors`를 활용합니다.
* **Swagger API 문서:** 백엔드 API 명세는 [여기](http://15.164.30.67:8080/api/)에서 확인할 수 있습니다.

## 📜 라이선스

이 프로젝트는 [MIT 라이선스](./LICENSE) 하에 배포됩니다.

##  roadmap 향후 계획

* **UI 개선:** 사용자 경험 향상을 위한 전반적인 UI 디자인 수정 및 개선 작업 진행 예정입니다.
* **기능 추가:**
    * [ ] (추가할 구체적인 기능 1)
    * [ ] (추가할 구체적인 기능 2)
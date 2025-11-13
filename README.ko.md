# PotG

[English](README.md) | [한국어](README.ko.md)

[![Flutter Version](https://img.shields.io/badge/Flutter-3.35.5-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![build and publish (android, iOS)](https://github.com/gsainfoteam/pot-g-flutter/actions/workflows/upload.yml/badge.svg)](https://github.com/gsainfoteam/pot-g-flutter/actions/workflows/upload.yml)
[![All Contributors](https://img.shields.io/github/all-contributors/gsainfoteam/pot-g-flutter?color=orange)](#기여자-)
[![Star on GitHub](https://img.shields.io/github/stars/gsainfoteam/pot-g-flutter?style=social)](https://github.com/gsainfoteam/pot-g-flutter/stargazers)

## 아키텍처

이 프로젝트는 **Clean Architecture**와 **BLoC 패턴**을 기반으로 구축되었습니다.

### 아키텍처 패턴

- **Clean Architecture**: 각 모듈은 `data`, `domain`, `presentation` 레이어로 분리되어 있습니다
- **BLoC**: BLoC 패턴을 사용한 상태 관리
- **의존성 주입**: `get_it`과 `injectable`을 사용한 의존성 주입
- **모듈 기반 구조**: 기능별로 독립적인 모듈로 구성

### 디렉토리 구조

```text
lib/
├── app/
│   ├── di/               # 의존성 주입 설정
│   ├── modules/          # 기능 모듈
│   │   ├── auth/         # 인증
│   │   ├── chat/         # 채팅 및 정산
│   │   ├── common/       # 공통 UI/유틸리티
│   │   ├── core/         # 핵심 인프라 (네트워크, 스토리지)
│   │   ├── create/       # 팟 생성
│   │   ├── device/       # 디바이스 정보
│   │   ├── list/         # 팟 목록
│   │   ├── main/         # 메인 네비게이션
│   │   ├── socket/       # WebSocket 통신
│   │   ├── splash/       # 스플래시 화면
│   │   └── user/         # 사용자 프로필/설정
│   ├── router.dart       # 라우팅 설정 (auto_route)
│   ├── pot_app.dart      # 앱 진입점
│   └── values/           # 테마, 색상, 폰트 등
└── main.dart             # 앱 시작점
```

### 기술 스택

- **상태 관리**: `flutter_bloc`, `bloc_concurrency`
- **라우팅**: `auto_route`
- **네트워킹**: `dio`, `retrofit`
- **로컬 스토리지**: `hive_ce`, `flutter_secure_storage`
- **코드 생성**: `freezed`, `json_serializable`, `injectable`
- **국제화**: `slang`

## 다운로드

[![Play Store](https://img.shields.io/badge/Google%20Play-Download-green?logo=google-play&logoColor=white)](https://play.google.com/store/apps/details?id=me.gistory.pot_g)
[![App Store](https://img.shields.io/badge/App%20Store-Download-blue?logo=app-store&logoColor=white)](https://apps.apple.com/app/id6744280856)

## 기여하기

[기여 가이드](.github/CONTRIBUTING.md)를 확인해주세요

## 기여자 ✨

이 프로젝트에 기여해주신 멋진 분들께 감사드립니다
([이모지 키](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tbody>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://blog.paperst.ar/"><img src="https://avatars.githubusercontent.com/u/125528915?v=4?s=100" width="100px;" alt="Boseong"/><br /><sub><b>Boseong</b></sub></a><br /><a href="https://github.com/gsainfoteam/pot-g-flutter/commits?author=2paperstar" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/GwanLiZa"><img src="https://avatars.githubusercontent.com/u/144007144?v=4?s=100" width="100px;" alt="GwanLiZa"/><br /><sub><b>GwanLiZa</b></sub></a><br /><a href="https://github.com/gsainfoteam/pot-g-flutter/commits?author=GwanLiZa" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/controlZ"><img src="https://avatars.githubusercontent.com/u/101192718?v=4?s=100" width="100px;" alt="controlZ"/><br /><sub><b>controlZ</b></sub></a><br /><a href="#projectManagement-controlZ" title="Project Management">📆</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/Yejin-02"><img src="https://avatars.githubusercontent.com/u/110380670?v=4?s=100" width="100px;" alt="Yejin-02"/><br /><sub><b>Yejin-02</b></sub></a><br /><a href="#design-Yejin-02" title="Design">🎨</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/BranKein"><img src="https://avatars.githubusercontent.com/u/32633156?v=4?s=100" width="100px;" alt="YeonhyukKim"/><br /><sub><b>YeonhyukKim</b></sub></a><br /><a href="https://github.com/gsainfoteam/pot-g-flutter/commits?author=BranKein" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/enc2586"><img src="https://avatars.githubusercontent.com/u/85762538?v=4?s=100" width="100px;" alt="Hongje Choi"/><br /><sub><b>Hongje Choi</b></sub></a><br /><a href="#translation-enc2586" title="Translation">🌍</a></td>
    </tr>
  </tbody>
  <tfoot>
    <tr>
      <td align="center" size="13px" colspan="7">
        <img src="https://raw.githubusercontent.com/all-contributors/all-contributors-cli/1b8533af435da9854653492b1327a23a4dbd0a10/assets/logo-small.svg">
          <a href="https://all-contributors.js.org/docs/en/bot/usage">기여 추가하기</a>
        </img>
      </td>
    </tr>
  </tfoot>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

이 프로젝트는
[all-contributors](https://github.com/all-contributors/all-contributors)
스펙을 따릅니다. 모든 종류의 기여를 환영합니다!

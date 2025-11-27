# PotG

[English](README.md) | [한국어](README.ko.md)

[![Flutter Version](https://img.shields.io/badge/Flutter-3.38.3-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![build and publish (android, iOS)](https://github.com/gsainfoteam/pot-g-flutter/actions/workflows/upload.yml/badge.svg)](https://github.com/gsainfoteam/pot-g-flutter/actions/workflows/upload.yml)
[![All Contributors](https://img.shields.io/github/all-contributors/gsainfoteam/pot-g-flutter?color=orange)](#contributors-)
[![Star on GitHub](https://img.shields.io/github/stars/gsainfoteam/pot-g-flutter?style=social)](https://github.com/gsainfoteam/pot-g-flutter/stargazers)

## Architecture

This project is built on **Clean Architecture** and **BLoC pattern**.

### Architecture Patterns

- **Clean Architecture**: Each module is separated into `data`, `domain`, and `presentation` layers
- **BLoC**: State management using BLoC pattern
- **Dependency Injection**: Dependency injection using `get_it` and `injectable`
- **Module-based Structure**: Independent modules organized by feature

### Directory Structure

```text
lib/
├── app/
│   ├── di/               # Dependency Injection configuration
│   ├── modules/          # Feature modules
│   │   ├── auth/         # Authentication
│   │   ├── chat/         # Chat and accounting
│   │   ├── common/       # Common UI/utilities
│   │   ├── core/         # Core infrastructure (network, storage)
│   │   ├── create/       # Pot creation
│   │   ├── device/       # Device information
│   │   ├── list/         # Pot list
│   │   ├── main/         # Main navigation
│   │   ├── socket/       # WebSocket communication
│   │   ├── splash/       # Splash screen
│   │   └── user/         # User profile/settings
│   ├── router.dart       # Routing configuration (auto_route)
│   ├── pot_app.dart      # App entry point
│   └── values/           # Theme, colors, fonts, etc.
└── main.dart             # App starting point
```

### Tech Stack

- **State Management**: `flutter_bloc`, `bloc_concurrency`
- **Routing**: `auto_route`
- **Networking**: `dio`, `retrofit`
- **Local Storage**: `hive_ce`, `flutter_secure_storage`
- **Code Generation**: `freezed`, `json_serializable`, `injectable`
- **Internationalization**: `slang`

## Download

[![Play Store](https://img.shields.io/badge/Google%20Play-Download-green?logo=google-play&logoColor=white)](https://play.google.com/store/apps/details?id=me.gistory.pot_g)
[![App Store](https://img.shields.io/badge/App%20Store-Download-blue?logo=app-store&logoColor=white)](https://apps.apple.com/app/id6744280856)

## Contribution

Check [Contributing](.github/CONTRIBUTING.md)

### Setup

Use flutter version manager(fvm) or mise

fvm follows `.fvmrc`

for mise user, set `dart.getFlutterSdkCommand` as follows

```json
{
  "dart.getFlutterSdkCommand": {
    "executable": "mise",
    "args": ["where", "flutter"]
  }
}
```

## Contributors ✨

Thanks goes to these wonderful people
([emoji key](https://allcontributors.org/docs/en/emoji-key)):

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
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/akrnwl"><img src="https://avatars.githubusercontent.com/u/117907042?v=4?s=100" width="100px;" alt="akrnwl"/><br /><sub><b>akrnwl</b></sub></a><br /><a href="https://github.com/gsainfoteam/pot-g-flutter/commits?author=akrnwl" title="Code">💻</a></td>
    </tr>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/rhseung"><img src="https://avatars.githubusercontent.com/u/56152093?v=4?s=100" width="100px;" alt="Hyunseung Ryu"/><br /><sub><b>Hyunseung Ryu</b></sub></a><br /><a href="https://github.com/gsainfoteam/pot-g-flutter/commits?author=rhseung" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/tkjftkjf"><img src="https://avatars.githubusercontent.com/u/72309529?v=4?s=100" width="100px;" alt="tkjftkjf"/><br /><sub><b>tkjftkjf</b></sub></a><br /><a href="https://github.com/gsainfoteam/pot-g-flutter/commits?author=tkjftkjf" title="Code">💻</a></td>
    </tr>
  </tbody>
  <tfoot>
    <tr>
      <td align="center" size="13px" colspan="7">
        <img src="https://raw.githubusercontent.com/all-contributors/all-contributors-cli/1b8533af435da9854653492b1327a23a4dbd0a10/assets/logo-small.svg">
          <a href="https://all-contributors.js.org/docs/en/bot/usage">Add your contributions</a>
        </img>
      </td>
    </tr>
  </tfoot>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the
[all-contributors](https://github.com/all-contributors/all-contributors)
specification. Contributions of any kind are welcome!

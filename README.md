# Crypto Currency

A Flutter cryptocurrency wallet and market dashboard built with **Clean Architecture**, **BLoC**, and **GetIt**. The app brings wallet information, cryptocurrency market data, price charts, news, and collectibles into a single interface, with optional biometric protection for wallet access.

> **Project status:** This repository is an application/demo project, not a production-ready wallet. Review the authentication flow, backend security, and transaction capabilities carefully before using it with real funds.

## Features

- **Wallet dashboard** — view wallet balance and available assets.
- **Market overview** — retrieve cryptocurrency market data.
- **Coin charts** — load historical price-chart data for a selected coin.
- **News feed** — display cryptocurrency news returned by the configured API.
- **Collectibles** — browse collectible items.
- **App authentication** — passcode entry and optional biometric authentication.
- **Biometric wallet lock** — lock the wallet when the app moves to the background and request authentication when it resumes.
- **Dark theme** — a centralized application theme.
- **Multi-platform Flutter project** — platform scaffolding is included for Android, iOS, web, Windows, macOS, and Linux; platform-specific behavior and plugins may vary.

## Tech Stack

| Area | Technology |
| --- | --- |
| Framework | Flutter |
| Language | Dart |
| State management | BLoC / flutter_bloc |
| Architecture | Feature-first Clean Architecture |
| Dependency injection | GetIt |
| Networking | Dio |
| Value equality | Equatable |
| Local authentication | local_auth |
| Secure storage | flutter_secure_storage |
| Navigation | Named routes and persistent bottom navigation |
| Testing | flutter_test |

## Architecture

The codebase is organized by feature. Most feature modules separate data, domain, and presentation responsibilities.

~~~text
lib/
├── config/
│   └── services/                 # Biometric and preference services
├── core/
│   ├── resources/                # Shared data-state and use-case abstractions
│   └── utils/                    # Theme and application constants
├── feature/
│   ├── coinlist/
│   │   ├── data/                 # API provider, models, repository implementation
│   │   ├── domain/               # Entities, repository contracts, use cases
│   │   └── presentation/         # Market BLoC and widgets
│   ├── collectibles/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── login/                    # Passcode and biometric login
│   │   ├── bloc/
│   │   ├── data/
│   │   ├── domain/
│   │   └── pressentation/
│   ├── news/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── wallet/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── chart/                    # Chart screens
│   └── coindetail/               # Coin detail screens
├── routes/
├── locator.dart                  # GetIt dependency registrations
└── main.dart                     # App initialization and providers
~~~

### Request flow

The typical data flow follows the Clean Architecture boundaries:

~~~text
Presentation (Widgets + BLoC)
          |
          v
       Use Case
          |
          v
  Domain Repository Contract
          ^
          |
 Data Repository Implementation
          |
          v
     API Provider
          |
          v
      Remote API
~~~

- **Presentation** handles UI and state through BLoC.
- **Domain** contains feature entities, repository contracts, and use cases.
- **Data** implements repository contracts and maps remote responses into domain models.
- **GetIt** registers services, providers, repositories, use cases, and BLoCs in lib/locator.dart.

## API Integration

The app currently uses the following API base URL:

https://projects.dunijet.ir/tonkeeper/

Requests are selected using query parameters:

| Feature | Method parameter | Additional parameters |
| --- | --- | --- |
| Wallet | wallet | — |
| Market coins | coins | per_page=50, page=1 |
| Coin chart | coins_chart | id, days |
| News | news | limit=30 |
| Collectibles | collectibles | limit=30 |

The wallet request can include an Authorization header. The value is read at build time through Dart's String.fromEnvironment; it is not intended to be committed to source control.

## Getting Started

### Prerequisites

- Flutter SDK with a Dart SDK compatible with the constraint in pubspec.yaml (^3.13.5).
- A configured platform toolchain for the target you want to run (Android Studio/Xcode, or the relevant desktop toolchain).

### 1. Clone the repository

~~~bash
git clone https://github.com/mahdiizakerii/crypto_currency.git
cd crypto_currency
~~~

### 2. Install dependencies

~~~bash
flutter pub get
~~~

### 3. Run the application

If your API environment requires wallet authorization, pass the token at build/run time:

~~~bash
flutter run --dart-define=WALLET_AUTHORIZATION=YOUR_TOKEN
~~~

If authorization is not required by your API environment, run:

~~~bash
flutter run
~~~

For a production build, provide the same compile-time define through your build pipeline rather than hardcoding credentials in the repository. Treat build-time defines as configuration, not as a substitute for a secure secret-management strategy in a distributed client application.

## Running Tests

Run the automated test suite with:

~~~bash
flutter test
~~~

The repository includes tests for selected data models, biometric preference service behavior, dependency registration, login UI and routing, wallet UI, and the send screen.

## Security and Project Limitations

- **Demo authentication:** the current passcode flow contains a hard-coded demo passcode in the login UI/state flow. It must be replaced with a proper authentication design before production use.
- **Biometrics:** biometric authentication is an additional local device check; it does not replace server-side authorization.
- **Wallet authorization:** do not commit real tokens. A value embedded in a client application should not be considered a durable secret.
- **Transfers:** the current send screen is a placeholder and does not implement transaction creation or blockchain signing.
- **Backend dependency:** wallet, market, chart, news, and collectibles data depend on the configured remote API.

## AI-Assisted Development

AI tools were used as part of the development workflow. The resulting application code is organized around explicit feature boundaries and conventional Flutter architecture patterns; generated or AI-assisted code should still be reviewed, tested, and maintained like any other code.

## Contributing

Contributions, bug reports, and suggestions are welcome. For substantial changes, please open an issue first to discuss the proposed approach.

## License

No license file was identified in the repository at the time this README was prepared. Unless a license is added, the project should not be assumed to be available for reuse, modification, or redistribution under an open-source license.

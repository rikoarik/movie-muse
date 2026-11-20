# Reelora

Flutter application structured with **MVVM** and **Clean Architecture** (feature-first).

## Architecture Overview

```text
lib/
├── main.dart                     # Entry point & DI bootstrap
├── app/
│   ├── app.dart                  # Root MaterialApp.router
│   ├── di/injection.dart         # Dependency injection (get_it)
│   ├── router/                   # Navigation (go_router)
│   └── theme/                    # App colors & Material 3 themes
├── core/
│   ├── config/env_config.dart    # Environment & API configuration
│   ├── error/                    # Exceptions (data) & Failures (domain)
│   ├── network/api_client.dart   # Dio HTTP wrapper
│   ├── result/result.dart        # Sealed Result<T> (Success / ErrorResult)
│   ├── usecase/usecase.dart      # Base UseCase<T, Params>
│   └── viewmodel/                # BaseViewModel & ViewState
└── features/
    └── home/                     # Example feature
        ├── data/                 # DataSources, Models, Repository Impl
        ├── domain/               # Entities, Repository Interface, UseCases
        └── presentation/         # ViewModels (ChangeNotifier), Views, Widgets
```

## Layer Rules

- **Domain** (`domain/`): Pure Dart business rules (Entities, Repository contracts, UseCases). No Flutter UI or HTTP dependencies.
- **Data** (`data/`): Implements Domain repositories, maps DTO/Models to Entities, and catches DataSource exceptions into `Failure`.
- **Presentation** (`presentation/`): MVVM using `BaseViewModel` (`ChangeNotifier`) + `Provider`. Views only render state and forward user actions to the ViewModel.

## Getting Started

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

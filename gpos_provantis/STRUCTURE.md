lib/
├── main.dart                      # Entry point (ProviderScope goes here)
├── src/                           # All internal code (keeps the root clean)
│   ├── app.dart                   # MaterialApp/CupertinoApp setup
│   │
│   ├── core/
│   │   ├── constants/
│   │   ├── exceptions/
│   │   ├── theme/
│   │   ├── utils/
│   │   ├── widgets/
│   │   └── database/                  # NEW: Centralized Drift Infrastructure
│   │       ├── app_database.dart      # Main connection & Riverpod Provider
│   │       ├── app_database.g.dart    # (Auto-generated file)
│   │       ├── tables/                # All your DB table definitions
│   │       │   ├── employees_table.dart
│   │       │   └── users_table.dart
│   │       │
│   │       ├── migrations/            # All your DB migrations
│   │       │   ├── migration_date_r1.dart
│   │       │   └── migration_date_r2.dart
│   │       │
│   │       ├── schema/                # All your DB schema
│   │       │   ├── schema_migrator.dart
│   │       │   └── schema_seeder.dart
│   │       │
│   │       └── seeders/               # All your DB seeders
│   │           ├── employees_seeder.dart
│   │           ├── users_seeder.dart
│   │           └── seed_constants.dart
│   │ 
│   ├── routing/                   # GoRouter configuration
│   │   ├── app_router.dart        # GoRouter provider and route definitions
│   │   └── app_routes.dart        # Route name/path constants (Enums)
│   │
│   ├── services/                  # Third-party wrappers (Firebase, Analytics, Dio)
│   │   └── api_client.dart        
│   │
│   └── features/                  # The core of your application
│       ├── employees/             # Example Feature
│       │   ├── application/       # Use cases / Services (logic tying multiple repos)
│       │   ├── data_sources/
│       │   │   └── employees_api.dart   # Handles local storage (SQLite)
│       │   │
│       │   ├── dtos/
│       │   │   └── employee_dto.dart                  # API Response mapping (JSON)
│       │   │
│       │   ├── data/                                  # Coordinates Remote -> Local sync
│       │   │   └── employees_repository.dart
│       │   │
│       │   ├── domain/            # Models & Entities
│       │   └── presentation/      # UI (Screens, Widgets, Controllers)
│       │       ├── screens/
│       │       ├── widgets/
│       │       └── controllers/
│       │
│       ├── users/                 # Another Example Feature
│       │   ├── application/       # Use cases / Services (logic tying multiple repos)
│       │   ├── data_sources/
│       │   │   └── users_api.dart  # Handles API calls (Server)
│       │   │   
│       │   │
│       │   ├── dtos/
│       │   │   └── user_dto.dart                  # API Response mapping (JSON)
│       │   │
│       │   ├── data/                                  # Coordinates Remote -> Local sync
│       │   │   └── users_repository.dart
│       │   │
│       │   ├── domain/
│       │   └── presentation/
│       │       ├── screens/
│       │       ├── widgets/
│       │       └── controllers/
│       │
│       └── login/                 # Another Example Feature
│           ├── application/       # Use cases / Services (logic tying multiple repos)
│           ├── data_sources/
│           │   ├── login_remote_data_source.dart  # Handles API calls (Server)
│           │   └── login_local_data_source.dart   # Handles local storage (SQLite)
│           │
│           ├── dtos/
│           │   └── login_dto.dart                  # API Response mapping (JSON)
│           │
│           ├── data/                                  # Coordinates Remote -> Local sync
│           │   └── login_repository.dart
│           │
│           ├── domain/
│           └── presentation/
│               ├── screens/
│               ├── widgets/
│               └── controllers/

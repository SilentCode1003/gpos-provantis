# Developer Onboarding Guide

This guide helps a new developer get productive in the GPOS Provantis project quickly.

It covers setup, project understanding, daily workflow, and key areas to inspect when making changes.

## 1. Project purpose

GPOS Provantis is a Flutter-based point-of-sale application for retail operations.

It supports:

- sales processing
- local data persistence
- cash and shift operations
- receipt printing
- setup and branch configuration
- reporting and summary data

The project is built for local-first POS workflows, especially in store or counter environments.

## 2. Prerequisites

Before working on the project, install:

- Flutter SDK
- Dart SDK
- Android Studio / Android SDK (for Android builds)
- Visual Studio / Windows build tools (for Windows builds)
- Git
- VS Code or another preferred editor

Check that your environment can run:

- `flutter --version`
- `dart --version`

## 3. Repository setup

Clone the repository and open the project folder:

- `gpos_provantis`

Important: the project folder is named `gpos_provantis`, not `gpos-provantis`.

## 4. Initial setup steps

Run the project setup script once from the project root:

```powershell
powershell -ExecutionPolicy Bypass -File .\tool\install-command.ps1
```

Then close and reopen the editor or terminal.

After that, use the project build commands:

```powershell
gpos-provantis android
```

```powershell
gpos-provantis windows
```

```powershell
gpos-provantis
```

The app is expected to build both Android and Windows release targets using the project command wrapper.

## 5. First-time development workflow

After setup, run the code generation step when needed:

```bash
dart run build_runner build -d
```

For active development with database and Riverpod generation:

```bash
dart run build_runner watch --delete-conflicting-outputs
```

This is required because the project uses generated code from:

- Drift
- Riverpod

## 6. Main project structure

Key directories:

- `lib/main.dart` – entry point
- `lib/src/app.dart` – app root and main app wiring
- `lib/src/routing/` – navigation and route definitions
- `lib/src/features/` – business features
- `lib/src/core/database/` – database, tables, schema, migrations, DAOs
- `lib/src/services/` – sync, printing, templates, email, health checks
- `lib/src/shared/` – reusable widgets and common UI pieces
- `windows/`, `android/`, `linux/`, `macos/`, `web/` – platform targets

## 7. Important architecture areas

### Database layer

Key file:

- `lib/src/core/database/app_database.dart`

This is the heart of the app’s local persistence. The database contains tables for:

- branch configuration
- POS configuration
- sales and sold items
- shift and cash handling
- printers
- settings
- reports
- customer and receipt data

If you add a new table or field, you likely need to update:

- the table definition
- the database annotation
- generated code via build_runner
- migrations if the schema changes in a meaningful way

### Routing

Key file:

- `lib/src/routing/app_router.dart`

This file contains app routes for:

- startup
- login
- setup
- dashboard
- receipts and reports
- settings

When adding new screens, update the router and route configuration.

### Features

Important feature folders:

- `lib/src/features/login`
- `lib/src/features/setup`
- `lib/src/features/dashboard`
- `lib/src/features/settings`
- `lib/src/features/startup`

Each feature is organized around screen and controller logic, with the database and service layers separated from UI code.

### Printing and reporting

Look at:

- `lib/src/core/printutil/`
- `lib/src/services/printing/`
- `lib/src/services/templates/`

These are essential for:

- thermal receipt generation
- shift and cash reporting
- invoice or receipt formatting
- local operational summaries

## 8. Development conventions

Follow these habits while working in the project:

- keep feature logic organized under the feature folder
- avoid spreading business logic across unrelated widgets
- use Riverpod providers for state and dependency access
- keep database access in repository/DAO layers rather than UI classes
- prefer small, testable services for printing and sync flows
- run code generation after database or provider changes

## 9. Typical developer tasks

### Add a new feature

1. Create or update the feature folder under `lib/src/features/`
2. Add domain/data/service logic as needed
3. Add state management via Riverpod if needed
4. Add screens/widgets
5. Update the router if a new screen is added
6. Run build_runner if required

### Add or change a database table

1. Update the relevant table file under `lib/src/core/database/tables/`
2. Add the table to `app_database.dart`
3. Run `dart run build_runner build -d`
4. Update migration logic if needed
5. Validate your data access in app logic

### Fix a UI issue

1. Identify the feature screen or widget
2. Verify whether the issue is state-based or view-based
3. Confirm if the screen is reading from the correct provider
4. Validate the data source and route state

## 10. Common commands

Run app:

```bash
flutter run
```

Generate code:

```bash
dart run build_runner build -d
```

Watch generated files:

```bash
dart run build_runner watch --delete-conflicting-outputs
```

Run analyzer:

```bash
flutter analyze
```

Run tests:

```bash
flutter test
```

## 11. Testing guidance

The project currently contains a practical Flutter app structure, but coverage may vary by feature.

As a developer, prioritize testing for:

- shift open/close logic
- payment and totals logic
- database migrations
- receipt generation
- cash report calculations

## 12. Good debugging practices

- inspect the DB state before and after a transaction
- confirm printers are assigned correctly before testing printing
- validate setup state before login or dashboard flows
- watch the route transitions when debugging screen navigation
- confirm provider scopes and lifecycles when using Riverpod

## 13. Working with release builds

Before shipping or validating a release:

- run code generation
- run analyzer
- test key POS flows
- verify printer setup
- verify shift workflow and closing operations
- validate startup and setup screens
- build the target platform

## 14. Documentation map

Use the project docs together:

- `README.md` – project overview and build steps
- `USAGE.md` – day-to-day user usage
- `TECHNICAL.md` – technical architecture and limitations
- `DEVELOPER_ONBOARDING.md` – developer setup and workflow
- `MAINTENANCE.md` – operational upkeep and troubleshooting

## 15. Final note

The app is a local-first POS system with real operational needs. Treat setup consistency, printer configuration, and data integrity as high-priority concerns while developing and maintaining it.

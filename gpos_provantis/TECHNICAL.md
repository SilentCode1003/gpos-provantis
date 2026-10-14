# GPOS Provantis Technical Documentation

This document describes the technical structure, runtime behavior, and current development limitations of the GPOS Provantis project.

## 1. Project summary

GPOS Provantis is a Flutter desktop/mobile POS application built around a local-first retail workflow. It is designed for point-of-sale operations, shift management, receipt printing, and transactional record keeping.

The app currently combines:

- Flutter + Dart as the application framework
- Riverpod for dependency injection and state management
- GoRouter for navigation
- Drift with SQLite for local persistence
- local setup and configuration screens
- printer integration for thermal receipt output
- reporting and sales summary data management

The project is operationally oriented toward retail and service counters running local transactions with device-specific settings.

## 2. Technical stack

### Frontend / app framework

- Flutter
- Dart SDK 3.11.5+
- Material Design UI via Flutter widgets

### State management

- `flutter_riverpod`
- `riverpod`
- `riverpod_annotation`

This is used across the app for:

- app-wide configuration
- feature controllers
- screen state
- database-backed view models
- async operations like sync and health polling

### Routing

- `go_router`

The app uses a centralized router configured in `lib/src/routing/app_router.dart`.

### Persistence

- `drift`
- SQLite
- `path_provider`

The application stores local data in a SQLite database at the application document directory.

### Printing

- `esc_pos_utils_plus`
- `flutter_thermal_printer`

Printing is implemented through dedicated services and generator utilities that prepare ESC/POS ticket output for thermal printers.

### Other notable libraries

- `device_preview_plus`
- `window_manager`
- `shared_preferences`
- `dio` and `pretty_dio_logger`
- `google_fonts`
- `mailer`
- `crypto`
- `uuid`

## 3. Application architecture

The app follows a feature-oriented structure with a clean separation between domain, data, and UI concerns.

### Main runtime entry

- `lib/main.dart`

The entry point initializes Flutter bindings and configures the desktop window on Windows. It then starts the `ProviderScope` and runs the app.

### App root

- `lib/src/app.dart`

This file creates the root `MaterialApp.router` and wires:

- the router config
- theme mode
- toast host
- a catalog sync overlay
- app health polling and sales sync watchers

### Routing

- `lib/src/routing/app_router.dart`

The router defines routes such as:

- `/startup`
- `/login`
- `/setup`
- `/dashboard`
- `/settings`
- reporting and receipt-related routes

This gives the app a single structured navigation flow for startup, login, setup, dashboard, and operational screens.

## 4. Data layer

### Local database

The core database is defined in:

- `lib/src/core/database/app_database.dart`

This is a Drift database with a large set of tables representing the store and POS domain, including:

- POS config
- branch config
- sales
- sold items
- cash drawer events
- printers
- settings
- employees
- payments
- shift reports
- receipt history
- customer records
- login credentials
- email configuration

The database uses:

- `@DriftDatabase(tables: [...])`
- DAO classes for specialized database access
- migration support through `SchemaMigrator`
- initial seeding via `SchemaSeeder`

### Database file location

The SQLite database is created in the app documents directory, using a file named:

- `gpos_provantis_local.sqlite`

This makes the database local to the device and suitable for offline retail operation.

### Schema versioning

The app declares:

- `schemaVersion => 2`

Migration logic lives under:

- `lib/src/core/database/schema/`

The database is designed to support gradual evolution without manual file replacement.

## 5. Features and responsibilities

### Startup and login

The app is built around a setup-first flow.

Important screens and flows include:

- startup screen
- login screen
- setup screen

These screens support initial device and branch configuration before sales can be processed.

### Dashboard

The dashboard is the core retail workflow area. It is the screen where:

- products are searched or scanned
- cart operations occur
- totals are calculated
- cashier actions are triggered
- shifts are opened or closed
- cash reports are managed

### Shift and cash operations

The project contains dedicated services and tables for:

- start/end shift handling
- drawer counts
- cash drops
- cash reports
- payment summaries

This suggests the application is intended to support reconciliation, shift accountability, and operational closing procedures.

### Reporting

The project includes reporting tables and generator logic such as:

- shift reports
- sold items reports
- payment summary reports
- staff sales reports
- receipt history
- cash reports

These data models indicate the app is designed for both daily operations and managerial review.

### Printing

The printing subsystem appears to support:

- receipt generation
- shift reports
- sale summaries
- printer assignment by role
- Wi-Fi or USB printer configuration

The application treats printing as part of the business workflow and not as an optional extra.

## 6. Runtime flow

A typical runtime flow is:

1. App launches.
2. Startup screen loads.
3. App checks whether configuration exists.
4. If configuration is missing, the user is guided into setup.
5. User logs in.
6. Dashboard opens.
7. User scans or selects products.
8. Sale is finalized.
9. Payment is processed.
10. Receipt is printed if a printer is configured.
11. Shift status is tracked through the day.
12. End-of-shift flow generates closure data and reports.

## 7. State and dependency patterns

The project uses Riverpod providers extensively.

Typical patterns include:

- provider-based database access
- singleton-like service providers
- UI consumers that rebuild on state changes
- async notifiers for controller logic

The app also uses auto-generated Riverpod files and Drift-generated files, which means build generation is part of the normal development lifecycle.

## 8. Build and generation workflow

The project expects generated files to be updated using build_runner.

The typical regeneration flow is:

- `dart run build_runner build -d`
- or `dart run build_runner watch --delete-conflicting-outputs`

These steps are necessary due to the generated code for:

- Riverpod providers
- Drift DAOs and database classes

Without generation, the app may not compile or may use stale model code.

## 9. Platform support

The workspace includes platform folders for:

- Android
- Windows
- Linux
- macOS
- Web

The project is primarily configured around desktop and Android use, and the Windows build/install tooling is explicitly included.

## 10. Security and operational considerations

The technical design suggests strong local operational logic, but also points to several operational realities:

- local SQLite data is not automatically a cloud backup system
- setup and device configuration are essential for correct operation
- signed or secure credentials are not described as a primary architecture feature in the visible code
- printing and local device access are highly environment-dependent

## 11. Current limitations and known constraints

The following are current limitations of the project as implemented in this codebase.

### 11.1 Local-first only

The app currently uses a local SQLite database rather than a fully central cloud-backed system. This is powerful for offline workflows, but it also means:

- data consistency across multiple shops or terminals requires additional sync logic
- export/import and backup procedures are important
- device failure can affect local sales records if no backup exists

### 11.2 Setup dependency

The app appears to require branch and POS configuration before normal operation. This is sound for store deployment, but it creates a dependency on:

- a correct setup process
- proper device initialization
- correct configuration of printers and branch details

Without it, functionality may be blocked or incomplete.

### 11.3 Printer dependence

Receipt printing is a first-class feature, but it depends on external hardware and environment configuration.

That means:

- device-specific printer setup is required
- Wi-Fi or USB printer issues can interrupt the workflow
- the app can be limited by hardware availability or network reliability

### 11.4 Desktop-oriented workflow with mobile compatibility

The project is structured as a desktop-first retail POS, but includes Android support. In practice, this means:

- some UI assumptions may favor larger screens or touch-friendly layouts
- performance and UX may vary across devices
- not every feature may be equally optimized for all platforms

### 11.5 Limited visibility into external integration maturity

The code includes services for sync, email, and local configuration, but the visible project structure does not yet show a fully mature external API ecosystem or full enterprise integration layer.

This means the current implementation is best understood as:

- a strong local POS base
- operationally useful for local retail scenarios
- still evolving toward broader enterprise features

### 11.6 No explicit multi-user concurrency model documented

The app includes tables for employees, shift flows, and reports, but there is no evidence in this snapshot of a fully hardened multi-user concurrency model, centralized locking, or detailed audit trail framework.

This is acceptable for a single-device or branch-local POS, but it is a limitation for multi-terminal or multi-user distributed deployments.

### 11.7 Report and analytics depth may remain limited

The presence of summary tables and reports suggests useful operational reporting, but this project does not yet show a broad, advanced analytics engine or a large business intelligence layer.

This means the system is better treated as a practical POS and operational reporting tool rather than a full ERP solution.

### 11.8 Production-hardening is still a work in progress

The app includes local persistence, setup flows, shift accounting, and device configuration, but the current project snapshot does not yet show a full production proofing layer such as:

- centralized authentication and role enforcement
- full cloud sync architecture
- end-to-end backup and restore tooling
- advanced monitoring and alerting
- full enterprise deployment automation

## 12. Recommendations for future enhancement

The following are natural next steps for the project:

- add centralized sync for multi-device stores
- improve admin and role-based access control
- strengthen data backup and restoration mechanisms
- standardize a deployment checklist for branch setup
- improve testing coverage for cash, shift, and printer workflows
- formalize API and integration contracts for external systems
- add stronger auditing for sales, returns, and staff actions

## 13. Summary

GPOS Provantis is a local-first retail POS system built with Flutter and SQLite. It includes core POS behaviors such as product scanning, sales processing, cash management, shift tracking, receipt printing, and store configuration.

Its strength is that it is designed around a real operational workflow used in retail and service environments. Its current limitation is that it still behaves like a practical local business application rather than a fully centralized multi-store enterprise platform.

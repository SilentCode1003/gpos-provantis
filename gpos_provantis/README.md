# GPOS Provantis

GPOS Provantis is a Flutter-based Point of Sale (POS) and retail management system designed for business operations that need fast sales processing, shift control, receipt printing, and local transaction management.

This project is built to support practical retail workflows such as scanning products, creating sales, managing shifts, handling cash drawers, issuing receipts, and syncing store information locally before or during operations.

It is a full-featured POS application with a desktop-first workflow, but it is also compatible with Android builds and can be extended to other Flutter-supported targets.

## What this project does

GPOS Provantis helps a cashier or store operator do the following:

- Process sales quickly through a dashboard-style POS interface
- Search, scan, or add products to a transaction cart
- Apply discounts, promotions, and custom sale flows
- Track shift open/close activity and drawer counts
- Print receipts to thermal printers over Wi-Fi or USB
- Generate and store sale, staff, and report records locally
- Manage branch, POS, and printer settings in-app
- Support customer and receipt history tracking
- Send e-receipts via email templates when configured
- Operate as an offline-first local system using SQLite via Drift

## Main features

- Point-of-sale checkout and transaction processing
- Barcode-based item lookup and scan workflow
- Cash drawer and cash management support
- Multi-printer support with thermal receipt printing
- Shift reports and sales summaries
- Product, category, and pricing management
- Local database persistence for sales records and configuration
- Local login and setup flow for branch/POS configuration
- Printer and email integration for receipts and reports
- Flutter Riverpod state management architecture

## Tech stack

- Flutter
- Dart
- Riverpod for state management
- GoRouter for navigation
- Drift + SQLite for local persistence
- Material Design UI
- Thermal printing libraries for receipt generation
- Desktop and Android build targets

## Project purpose

This is not just a demo app. It is structured as a functional retail POS system for real-store use, with operational pieces such as:

- sales processing
- shift timing and drawer counts
- configuration for branch and terminal settings
- printing receipts and daily reports
- storing transactional data locally for offline reliability

## Typical use cases

- Retail shops
- Convenience stores
- Mini marts
- Service-based stores with products and receipts
- Branch-based POS environments with local terminal configuration

## Architecture overview

The project follows a feature-based structure with a clean separation between:

- app startup and configuration
- database and local persistence
- services and printing pipelines
- POS dashboard workflow
- settings and setup modules
- login and sync flows

The application uses a local SQLite database for core store data and transactions, while supporting the operational needs of POS terminals with fixed configurations and local reporting.

## Project structure

- `lib/main.dart` – app entry point
- `lib/src/features/` – feature modules such as login, dashboard, setup, and settings
- `lib/src/core/database/` – local database, tables, and DAO providers
- `lib/src/services/` – printing, syncing, API, and helper service logic
- `lib/src/routing/` – app routing
- `windows/`, `android/`, `linux/`, `macos/`, `web/` – platform targets

## Prerequisites

Before building the app, make sure you have:

- Flutter SDK installed and configured
- Android Studio / Android SDK setup for Android builds
- Windows desktop tools for native Windows builds
- A terminal environment with PowerShell available on Windows

## Build and setup steps

Important: do not remove the project steps below. These are the required setup instructions for new users building this project.

Step 1. Change directory inside the project folder: "gpos_provantis" not "gpos-provantis"
Step 2. Run this command `powershell -ExecutionPolicy Bypass -File .\tool\install-command.ps1` (Only run once!)
Step 3. Close and Open the project (VS Code/Zed).
Step 4.
Open a NEW terminal, then try:
gpos-provantis android - builds an Android Release
gpos-provantis windows - builds a Windows Release
gpos-provantis - builds Both releases

## Recommended workflow

1. Open the project in your IDE.
2. Run the install script once from the project root.
3. Restart the editor or terminal after setup.
4. Use the configured build commands to generate a release build for Android and/or Windows.
5. Configure branch, POS, and printer settings in the app before normal use.
6. Open the terminal and start a sales shift when the store is ready to operate.

## Notes for new users

- This project is built around local, offline-first POS operations.
- Some functions depend on printer configuration and operating environment setup.
- The application expects store configuration to be completed early in setup.
- The app is intended for real retail operations, not just UI mockups.

## License

This project is currently set up as a local Flutter application without a public package publishing target. Refer to the repository rules and project ownership for licensing details if needed.

## Summary

GPOS Provantis is a retail point-of-sale solution built in Flutter for fast sales, shift management, local data storage, and receipt printing. It is designed to help businesses run a practical POS terminal on desktop and Android, with operational features tailored for direct retail use.

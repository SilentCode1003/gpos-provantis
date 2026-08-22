# Welcome to your FMU Architecture 🚀
**Project:** GposProvantisApp

This project was generated using the FMU CLI. It is pre-configured with **Riverpod**, **GoRouter**, and **Drift (SQLite)** using a feature-first clean architecture pattern.

---

## 🛠 Quick Start

Because this architecture relies on code generation (Riverpod & Drift), you **must** run the build runner before launching the app for the first time, and anytime you modify a database table or a `@riverpod` controller:

```bash
dart run build_runner build -d

```

Then, you can proceed to use this command to have a real time migration for your database:

```bash
dart run build_runner watch --delete-conflicting-outputs

```

---

## 📁 Where Do Things Go? (Structure Guide)

* **`lib/src/core/`**: The foundation. Put your global UI themes, app-wide constants, exceptions, and the **Drift database** here.
* **`lib/src/routing/`**: GoRouter configuration (`app_router.dart`) and your route name enums.
* **`lib/src/services/`**: Third-party integrations (e.g., Firebase, Dio/HTTP clients, Analytics wrappers).
* **`lib/src/features/`**: The heart of your app. Every distinct slice of your app (like `employees`, `auth`, `products`) gets its own isolated folder here.

### Inside a Feature Folder:

1. **`domain/`**: Data models (`.dart` classes).
2. **`data/`**: Repositories. This is where you write functions to query Drift or fetch data from an API.
3. **`application/`**: (Optional) Complex business logic services that tie multiple repositories together.
4. **`presentation/`**: Your UI. This contains `screens`, reusable `widgets`, and Riverpod `controllers`.

---

## 💾 How to Use the Database (Drift)

We use **Drift** for a robust, offline-first SQLite database.

**To add a new table:**

1. Create a file in `lib/src/core/database/tables/` (e.g., `products_table.dart`).
2. Define your columns extending `Table`.
3. Open `lib/src/core/database/app_database.dart` and add your new table to the `@DriftDatabase(tables: [...])` annotation.
4. Run `dart run build_runner build -d`.
5. *Optional but recommended:* Increment the `schemaVersion` and add migration logic in `schema_migrator.dart`.

**To read/write data:**
Create a Repository inside your feature's `data/` folder. Use Riverpod to watch the `appDatabaseProvider` and execute your queries. See `employees_repository.dart` for a complete CRUD stream example.

---

## ⚡ How to Use State Management (Riverpod)

1. **Controllers:** Keep your business logic in Riverpod controllers inside the `presentation/controllers` folder using the `@riverpod` annotation.
2. **UI Binding:** Your screens should extend `ConsumerWidget` (or `ConsumerStatefulWidget`). Use `ref.watch(myControllerProvider)` to listen to state changes and rebuild the UI automatically.
3. **Database Streaming:** For lists of data, have your controller watch a Stream from your Drift repository. When the database updates, Drift pushes the new data to Riverpod, and Riverpod updates your screen instantly.

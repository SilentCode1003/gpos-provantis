# Database Recovery Guide
### Drift + SQLite — `AppDatabase` / `gpos_provantis_local.sqlite`

---

## The Core Principle

> **The `.sqlite` file is the source of truth. Your code is just a bridge to it.**

A migration mistake almost never destroys user data. It usually just **breaks the bridge**. Fix the code, bump the version, and the bridge is rebuilt on the next app launch.

---

## Error Matrix — What Went Wrong & How to Fix It

| Mistake | Symptom | Salvageable? | Fix |
|---|---|---|---|
| Forgot to increment `schemaVersion` | App runs, but crashes on data access: `no such column` / `no such table` | ✅ 100% | Increment version → restart |
| Forgot the `onUpgrade` loop | New tables never created → crash on access | ✅ 100% | Add loop back → bump version → restart |
| Forgot `addColumn` line | Column exists in code, not in DB → crash on read/write | ✅ 100% | Add the missing line → bump version → restart |
| Syntax error in migration | App crashes at startup (DB init fails) | ✅ 100% | Fix the Dart/SQL error → restart |
| Wrote `DROP TABLE` / `DELETE FROM` | Data is gone from the affected table | ⚠️ Partial | Restore from backup; structure recovers on next migration |

---

## Recovery Playbook

### Scenario A — App Crashes on Launch (Dev)

```
Error: DatabaseException — no such table / no such column
```

**Steps:**

1. Check `schemaVersion` — did you forget to increment it?
2. Check `onUpgrade` — is the `for (final table in allTables)` loop present?
3. Check `addColumn` lines — is every new column covered under the correct `if (from < N)` guard?
4. Fix the issue, then **Hot Restart** (not Hot Reload).
5. Watch the console for your migration print statement.

**Nuclear option (dev only):**
Delete the local `.sqlite` file and relaunch. The database will be recreated from scratch.

```
Android: /data/data/<your.package>/files/gpos_provantis_local.sqlite
iOS:     <App Documents>/gpos_provantis_local.sqlite
```

---

### Scenario B — Update Shipped with Broken Migration (Production)

1. User updates → app crashes immediately.
2. **Do not panic.** The `.sqlite` file on the user's device is intact.
3. Fix the migration in code.
4. Release a hotfix (new version number).
5. User installs hotfix → `onUpgrade` runs correctly → data is recovered automatically.

**No data is lost** as long as you haven't run `DROP TABLE` or `DELETE FROM`.

---

### Scenario C — `schemaVersion` Was Correct But Migration Still Didn't Run

This usually means `schemaVersion` was bumped but the app was never closed and reopened. The version check only fires when the database is **opened**, not during a Hot Reload.

**Fix:** Force a full Hot Restart, or close and reopen the app.

---

### Scenario D — Database in an Unknown / Corrupted State (Dev)

1. Stop the app.
2. Delete the `.sqlite` file (path above).
3. Re-seed mock data.
4. Relaunch.

---

## Debugging Checklist

Add this print statement inside `onUpgrade` to confirm migrations are firing:

```dart
onUpgrade: (m, from, to) async {
  print('>>> MIGRATING DATABASE FROM v$from TO v$to');
  // ... your logic ...
  print('>>> MIGRATION COMPLETE');
},
```

If you see no output, the version was not incremented or the app was not fully restarted.

---

## Version Increment Guide

Every schema change requires **one version bump**. Use comments to track why.

```dart
// v1 — initial schema: employees table
// v2 — added employees.age
// v3 — added employees.salary
@override
int get schemaVersion => 3;
```

And a corresponding guard in `onUpgrade`:

```dart
if (from < 2) {
  await m.addColumn(employeesTable, employeesTable.age);
}
if (from < 3) {
  await m.addColumn(employeesTable, employeesTable.salary);
}
```

The `if (from < N)` guards ensure that:
- A fresh install runs **no** migration logic.
- A user on v1 upgrading to v3 runs **both** v2 and v3 migrations.
- A user on v2 upgrading to v3 runs **only** the v3 migration.

---

## What Is Always Safe

| Operation | Safe? |
|---|---|
| Adding a new table | ✅ Always safe |
| Adding a nullable column | ✅ Always safe |
| Adding a column with a default value | ✅ Always safe |
| Renaming a column | ⚠️ Requires manual migration |
| Dropping a column | ⚠️ SQLite does not support `DROP COLUMN` natively |
| Dropping a table | ❌ Destroys data permanently |
| `DELETE FROM` in migration | ❌ Destroys data permanently |

---

## Quick Reference — The Golden Rules

1. **Change a table → bump `schemaVersion`**
2. **Bump version → add the migration guard**
3. **Test with Hot Restart, not Hot Reload**
4. **Never use `DROP TABLE` or `DELETE FROM` in migration logic**
5. **In production, a bad migration = a hotfix, not data loss**

---

*Generated for: `AppDatabase` · `gpos_provantis_local.sqlite` · Drift + Riverpod*

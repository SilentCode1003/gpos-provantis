# Maintenance Guide

This guide explains how to maintain the GPOS Provantis project after deployment or during active development.

It covers routine upkeep, environment checks, database health, printer service checks, app updates, and common maintenance tasks.

## 1. Maintenance goals

The project is a local POS application used for daily retail operations. Maintenance should focus on:

- stable app performance
- reliable data persistence
- correct printer operation
- smooth branch and POS configuration
- accurate sales and shift reporting
- safe updates without breaking local records

## 2. Regular maintenance checklist

Perform these checks on a regular schedule:

### Daily checks

- confirm the app launches successfully
- verify login works for the active cashier or admin user
- check that the configured printer is online and connected
- confirm the system can print a test receipt
- verify shift status before opening or closing the day
- review cash totals and shift closing data

### Weekly checks

- review report summaries for unusual drops or spikes
- confirm database file integrity and app stability
- verify that setup and branch configuration still match store details
- inspect printer driver and hardware status
- confirm no stale or duplicate configuration remains in local settings

### Monthly checks

- review app version and build status
- refresh branch/POS configuration if store setup changes
- confirm backup procedures are still working
- check if code generation or dependencies need updating
- assess whether printer settings or hardware still match store needs

## 3. Environment maintenance

### Flutter environment

Keep the project running on a consistent Flutter/Dart toolchain.

Check:

- Flutter version
- Dart version
- platform-specific build tools

Run:

```bash
flutter --version
dart --version
```

If the project is being rebuilt or moved to another machine, ensure the correct SDK version is installed before building.

### Local machine health

For local store or workstation use, maintain:

- stable power and system health
- operating system updates
- acceptable free disk space
- valid printer connections and network conditions
- proper permissions for application data storage

## 4. Database maintenance

The app stores sales and operational data locally in SQLite.

### Key database file

- `gpos_provantis_local.sqlite`

This file lives in the application documents directory for the installed app.

### Database maintenance tasks

- confirm the database is being created and updated correctly
- verify the app can open the database after restart
- monitor for unexpected data loss or duplicate rows
- check schema migrations after code updates
- validate generated code after schema changes

### When schema changes occur

Always run:

```bash
dart run build_runner build -d
```

If migration logic changes, test it carefully for existing data compatibility.

## 5. Build maintenance

### Code generation

Because the app uses generated code, always regenerate when:

- a database table changes
- a Riverpod provider changes
- generated classes become stale

Run:

```bash
dart run build_runner build -d
```

or during heavy development:

```bash
dart run build_runner watch --delete-conflicting-outputs
```

### Build verification

Before release or major deployment, verify:

- app builds successfully
- login works
- setup works
- dashboard loads
- print test passes
- shift open/close functions work
- reports generate correctly

## 6. Printer maintenance

Printers are a critical dependency in POS operations.

### Check printer status regularly

- confirm the printer is powered on
- confirm network connectivity or USB connection
- verify correct paper roll is installed
- confirm the assigned printer still matches the device configuration
- run a receipt test before the business day begins

### Common printer issues

- printer not detected
- printer assigned but not active
- print jobs failing silently
- repeated paper jams or poor print quality
- mismatched printer role configuration

### Maintenance response

When a printer issue happens:

1. confirm the printer is selected in settings
2. check driver or connection status
3. test a simple print job
4. validate the configured role and device details
5. restart the app if needed
6. re-test after configuration is corrected

## 7. Shift and cash management maintenance

The app tracks cash and shift states. These routines should be reviewed carefully.

### Daily operational checks

- confirm the shift is opened before sales begin
- confirm the opening cash count is recorded
- confirm transactions are being saved properly
- verify the closing count before ending a shift
- review cash reports for anomalies

### If a shift issue happens

- inspect current shift state
- verify whether the drawer count was recorded
- review the relevant shift report and cash report records
- confirm no stale or partial shift state remains in local storage

## 8. Setup and configuration maintenance

Branch and POS setup should be treated as a critical system configuration area.

### Check the following regularly

- branch name and address are still correct
- POS ID matches the actual device
- printer assignment is still valid
- local settings reflect the current store layout
- no duplicate or outdated configuration remains

If a branch changes or a device is replaced:

- update the configuration carefully
- re-test login and dashboard access
- verify printer and report generation still work

## 9. Reporting and data integrity checks

The app stores sales summaries, reports, and receipt history.

Monitor for:

- missing sales records
- duplicate transactions
- incorrect totals
- missing shift closure data
- date-range mismatches in reports

When reports look wrong:

1. verify the correct business day or shift is selected
2. confirm sale records were saved
3. inspect payment and sold item tables
4. validate print and report generation logic
5. check whether the local database has stale or partial records

## 10. Backup and restore procedures

Because the app uses a local SQLite database, backups matter.

Recommended practice:

- back up the application database regularly
- keep configuration records accessible
- keep printer configuration notes for each device
- maintain a simple restore plan for workstation replacement

## 11. Update and deployment strategy

### Before deployment

- update and test the codebase
- regenerate files
- run the analyzer
- validate key POS features
- test printer setup and receipt output
- test shift opening and closing

### During deployment

- deploy to a controlled environment first
- keep a rollback plan for the app build
- verify the local database is compatible with the new app version
- confirm setup screens still work after upgrade

## 12. Common maintenance problems and fixes

### App fails to start

Check:

- Flutter environment health
- generated file state
- local database integrity
- recent code or dependency changes

### Login does not work

Check:

- local credentials data
- setup status
- branch and POS configuration
- database state

### Store data seems missing

Check:

- whether the app is reading the correct local data directory
- whether setup was reset or a device changed
- whether the database file was recreated
- whether migration logic dropped or altered expected data

### Shift cannot be opened or closed

Check:

- drawer count / cash record state
- current shift status
- setup validity
- whether action logic depends on a required config value

### Receipt printing fails

Check:

- printer connection
- printer configuration
- assigned main/sub printer
- network or hardware state
- app permission issues

## 13. Documentation and handoff

When making changes, document:

- what changed
- why it changed
- which screens or services were affected
- whether database schema or setup flow changed
- whether printer configuration or branch setup changed
- whether deployment notes are required for store staff

## 14. Recommended maintenance routine

A practical maintenance routine for the project is:

1. Start the app and confirm it loads without errors
2. Verify the configured printer is active
3. Confirm setup information is correct
4. Log in to the POS
5. Run a quick sample sale
6. Print a receipt
7. Open and close a shift to verify accounting flow
8. Review daily reports
9. Check for any anomalies in stored data

## 15. Summary

Maintenance for GPOS Provantis centers on reliability, local data integrity, and hardware readiness. The most important operational areas are:

- app and Flutter environment consistency
- database integrity
- printer health
- shift and cash correctness
- setup and configuration accuracy

If these are maintained well, the POS system remains stable and useful in a real retail environment.

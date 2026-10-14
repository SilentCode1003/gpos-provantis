# GPOS Provantis Usage Guide

This document explains how to use the GPOS Provantis system in a real retail or service environment.

It covers the basic workflow from first launch to daily operations, including setup, login, sales, shift management, printing receipts, and daily closing tasks.

## 1. Overview

GPOS Provantis is a point-of-sale application for businesses that need:

- a fast sales workflow
- barcode or manual item entry
- local receipt and transaction storage
- shift start/end tracking
- cash drawer handling
- printer support for receipts and reports
- branch/POS configuration for store operations

The app is designed for daily operations in a store, cashier desk, or retail counter.

## 2. Before you start

Before using the system, make sure:

- the project has been set up successfully
- the app has been built for the required platform
- your printer is configured if you plan to print receipts
- branch and POS settings are complete
- the correct user credentials are available

For initial setup, follow the build instructions in the project `README.md` first.

## 3. First-time launch

When the app starts for the first time:

1. The system may open to a startup or splash screen.
2. You will be prompted to complete the setup if no branch or POS configuration exists.
3. If no configuration is saved, the app may instruct you to run setup first.

Important:

- If setup is not complete, the app may not allow normal sales processing.
- Branch and POS configuration are required for a proper cashier workflow.

## 4. Initial setup workflow

Before selling anything, complete the setup process.

### 4.1 Access setup

From the login screen, use the setup option if available.

This setup typically includes:

- branch configuration
- POS configuration
- terminal setup
- printer assignment
- local device settings

### 4.2 Configure branch and POS

Enter the required business details such as:

- branch name
- branch location
- POS ID or terminal ID
- store identifiers
- any required serial or configuration data

This ensures the app knows which device is operating and which store account it belongs to.

### 4.3 Configure printers

If your store uses thermal printers, set up the printer configuration before using the POS.

Typical settings may include:

- printer name
- type (Wi-Fi or USB)
- IP address or device configuration
- paper size
- cash drawer support
- main or sub printer assignment

Once configured, the app can print receipts and reports at the right times.

## 5. Login

After setup is complete:

1. Open the app
2. Enter your username and password
3. Continue to the dashboard

If your account has the correct permissions, you will be taken to the sales dashboard.

If the app detects missing setup information, it may require you to finish configuration before login is allowed.

## 6. Dashboard overview

The main dashboard is the working area for daily retail operations.

Typical elements on the dashboard include:

- product or item search
- barcode scanner input
- item list or catalog panel
- current cart or transaction area
- payment and checkout controls
- shift controls
- report and settings access

The dashboard is where cashiers add products, review totals, and finalize sales.

## 7. Starting a shift

Before taking sales, open a shift.

### To start a shift:

1. Open the dashboard.
2. Locate the shift action button.
3. Choose Start shift.
4. Enter or confirm the opening cash drawer count, if required.
5. Confirm the action.

The system tracks the shift so the app knows:

- when sales began
- what cash started the shift
- what transactions happened during the shift
- how much money should be counted at closing

## 8. Adding products to a sale

There are usually two common ways to add items:

### 8.1 Barcode scan

- scan a product barcode using the barcode input field
- the app looks up the item in local product data
- the product is added to the current sale

### 8.2 Manual search or add

- type a product name or code in the search field
- select the product from the list
- add it to the cart

Depending on product setup, the app may also use:

- categories
- pricing tables
- discounts
- promotional offers
- service items or packages

## 9. Working with the cart

The cart displays the items selected for the current sale.

Common actions include:

- add quantity
- remove an item
- update item quantity
- apply discount or promotion
- review subtotal and total amount
- cancel or clear the transaction if needed

Before finalizing, confirm the order details are correct.

## 10. Payment and checkout

After all items are added:

1. Review the total due
2. Choose the payment method
3. Enter or confirm the amount received
4. Complete the payment

The app may support multiple payment flow styles depending on configuration, such as:

- cash
- card or digital payment
- split payments
- Vouchers or custom payment methods

When the transaction is saved, a receipt can be generated.

## 11. Receipt printing

GPOS Provantis includes support for thermal receipt printing.

Once payment is confirmed:

- the system creates the receipt record
- printer output is sent
- the receipt is printed to the configured main or sub printer

If your printer is not configured correctly:

- no receipt may print
- the app may show an error or warning
- you may need to verify the printer connection settings

### Receipt best practices

- confirm the printer is connected and online
- confirm correct paper is loaded
- verify the configured printer is the active one
- test print before peak business hours

## 12. Ending a shift

At the end of the business day or staffing period:

1. Go to the dashboard
2. Open the shift actions
3. Select End shift
4. Confirm the closing cash count or drawer count if prompted
5. Complete the closing flow

The app may generate a shift report or summary during this step.

This reporting is important for:

- total sales tracking
- cash reconciliation
- productivity monitoring
- store closing procedures

## 13. Reports and summaries

GPOS Provantis includes reporting features related to sales and shift operations.

Typical reports may include:

- shift reports
- sales summaries
- cash reports
- receipts history
- staff sales information
- payment breakdown

These reports help managers review how the store performed during a period.

## 14. Settings and maintenance

Use the settings area to manage ongoing store configuration.

Common tasks include:

- adjusting branch details
- changing terminal or POS settings
- reassigning printers
- reviewing local data and report settings
- managing system preferences

Only admins or authorized users should change system-level settings.

## 15. Daily operational workflow

A typical daily use flow is:

1. Start the machine
2. Open the GPOS Provantis app
3. Log in
4. Verify printer and setup status
5. Open shift
6. Scan or add products for each sale
7. Process payment
8. Print receipt
9. Continue servicing customers
10. End shift at the close of the work period
11. Review reports and close cash as needed

## 16. Troubleshooting common issues

### App asks for setup again

- check whether branch configuration was saved
- confirm POS configuration exists
- verify your database or local storage is not reset unexpectedly

### No receipt prints

- confirm the printer is connected
- check printer assignment in settings
- verify Wi-Fi or USB connection
- test printer configuration

### Shift cannot be started or ended

- confirm the drawer count is recorded
- check if the required settings are configured
- ensure the current shift status is valid

### Sale does not appear in reports

- confirm the transaction was completed successfully
- verify data was saved locally
- check whether the report is generated for the correct time range

## 17. Best practices

- always complete setup before business operation
- start a shift before taking customer orders
- reconcile cash before ending a shift
- keep printer settings updated
- verify receipt printing before peak store hours
- avoid changing key terminal settings during active sales periods
- back up local data when required by store policy

## 18. Security and access

This app handles operational retail data and business sales records.

Recommended practices:

- assign secure login credentials
- limit admin permissions to trusted users
- do not leave the POS terminal logged in when unattended
- protect store and POS configuration data
- keep local workstation security in place

## 19. Summary

GPOS Provantis is designed to run the daily sales workflow of a retail or service business with:

- product sales
- receipt printing
- cash management
- shift control
- reporting
- local transactional storage

With proper setup and daily operational discipline, it can serve as a practical POS workstation for a business environment.

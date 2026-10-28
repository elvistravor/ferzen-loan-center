# Ferzen Loan Services (LoanPro) — Loan Management MVP

Ferzen Loan Services (LoanPro) is a small full-stack web application for a Uganda lending business. It includes a browser UI and a Node.js server with SQLite persistence, server-side sessions, password hashing, CSRF protection, login rate limiting, role-based authorization, and an audit log.

## Features

- First-run owner account setup; owner account creation is closed once the first owner exists.
- Login/logout with bcrypt password hashes and server-side sessions stored in SQLite.
- Owner-only staff account creation, enable/disable controls, reports, CSV export, and audit log.
- Staff can register borrowers, issue loans, and record repayments.
- Borrower directory, loan portfolio, repayment history, dashboard totals, and reports.
- UGX display and annual flat-rate interest calculation: principal × annual rate × term months / 12.
- Validates repayments on the server and rejects payments larger than the outstanding balance.
- SQLite database stored in `data/loanpro.sqlite` by default.

## Requirements

- Node.js 20 or newer and npm.
- On systems where `better-sqlite3` does not have a prebuilt binary, the local build tools required by that package.

## Run locally

1. Extract this project folder.
2. Open a terminal in the `loanpro-project` folder.
3. Install packages:

   ```bash
   npm install
   ```

4. Copy `.env.example` to `.env` and set `SESSION_SECRET` to a long random secret (at least 32 characters). Keep `.env` private.
5. Start the server:

   ```bash
   npm start
   ```

6. Open `http://localhost:3000` in your browser.
7. Create the first owner account. Use a unique username and a strong password of at least 12 characters.
8. Sign in and add borrowers, loans, repayments, and staff accounts.

The app stores its database in `data/loanpro.sqlite` by default. Keep a secure backup of that file and the session database file (`data/sessions.sqlite`). Stop the app before making a manual file copy, or use SQLite's online backup mechanism for a live deployment.

## Roles

**Owner:** all staff permissions, staff account management, reports, CSV export, and audit log.

**Staff:** borrower registration, loan creation, repayment entry, and viewing the operational dashboard and loan records.

Role checks are performed on the server API, not just by hiding interface controls.

## Important security and business limitations

This is a functional MVP starter project, not a certified production financial system. Before storing real customer data or exposing it to the internet:

- Deploy behind HTTPS and set `NODE_ENV=production` and a strong `SESSION_SECRET`.
- Configure secure server hosting, firewalling, monitoring, and tested off-site encrypted backups.
- Add an operational process for password resets, owner recovery, staff offboarding, data retention, and incident response.
- Have a qualified reviewer assess the deployment, privacy practices, Ugandan data-protection requirements, and applicable lending/consumer-credit rules.
- Review the interest method, fees, penalties, due-date schedules, arrears calculations, receipts, reversals, and accounting with the business before relying on the numbers.
- The current loan model calculates flat interest over the term. It does not yet build a detailed instalment schedule, calculate reducing-balance interest, assess late fees, or integrate mobile money/SMS.
- Staff can record a repayment but cannot edit/delete financial records. Corrections should be handled through a future audited reversal workflow.
- The first owner setup endpoint is designed for first-run use. Restrict initial setup to a trusted environment before deploying publicly.

## Project structure

```text
loanpro-project/
  server.js             Express API, auth, permissions, database
  public/
    index.html          App pages and forms
    style.css           Responsive styling
    app.js              Front-end logic
  data/                 Created automatically for SQLite data
  .env.example          Environment variable template
  package.json          Dependencies and scripts
```

## Troubleshooting

- If `npm install` fails compiling `better-sqlite3`, install the build prerequisites for your operating system and retry with a supported Node.js LTS release.
- If port 3000 is occupied, set `PORT=3001` in `.env` and open `http://localhost:3001`.
- If login fails, verify the username and password; passwords are case-sensitive, usernames are normalized to lowercase.
- Do not delete the database files to reset a live app: doing so removes records and user accounts.


## Client KYC documents
Client registration supports NIN, phone/SIM registered name, passport photo, National ID front and back images, occupation/income, and next-of-kin details. Images are limited to JPG/PNG/WebP and 5 MB each, stored in the configured persistent upload directory, and served only through authenticated API routes. Treat NIN and ID images as highly sensitive personal data; collect only with appropriate consent, restrict staff access, set a retention policy, and verify Uganda data-protection and lending requirements before production use. The uploaded user photo is used as the app/browser icon.

## Client consent, signature and registration audit

Client registration now requires the client consent checkbox and a drawn signature (finger or stylus). The server validates the consent and signature, stores the signature image in the configured upload directory, records the consent timestamp, and attributes the client record to the currently authenticated owner or staff account. The borrower list shows who registered each client and when, and owners can filter by loan officer and registration date, search client details, filter by loan/consent status, and sort by date, name, or officer. The signed signature can be opened only through an authenticated application session.

The consent text in the form is a starting point, not legal advice. Have it reviewed for your business and applicable Ugandan data-protection and lending requirements before production use. Store ID images and signatures only with a lawful basis, clear notice, appropriate access controls, and retention/deletion procedures.

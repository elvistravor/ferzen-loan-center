# Ferzen Loan Services — Netlify + Supabase migration

This package adapts the existing Ferzen browser UI to a Netlify Function API backed by Supabase PostgreSQL and a private Supabase Storage bucket. It is a migration build that must be tested in a separate staging site before real customer data is entered.

## Included
- Existing `public/` user interface.
- `netlify/functions/api.mjs`: server-side API for setup/login, clients and consent uploads, loans, repayments, staff, reports, CSV export and audit log.
- `netlify.toml`: Netlify static hosting and `/api/*` rewrite.
- `supabase/001_ferzen_schema.sql`: original schema reference.
- `supabase/002_auth_migration.sql`: add password hash column to existing staff table and ensure private document bucket.

## 1. Database
Because the `fls_*` tables already exist, do NOT rerun `001_ferzen_schema.sql` blindly. In Supabase → SQL Editor, review and run `supabase/002_auth_migration.sql` once. Verify `fls_staff_profiles.password_hash` exists and bucket `fls-private-documents` is private.

Existing owner/staff profiles made before this migration will not have passwords. After confirming the existing profiles, create a new owner only if no owner exists; otherwise a database administrator must securely set/reset the relevant `password_hash` using a reviewed procedure. Do not store passwords in plaintext.

## 2. Deploy
1. Create a private GitHub repository and upload the contents of this folder to the repository root (`public/`, `netlify.toml`, `netlify/functions/`, `supabase/`, `package.json`).
2. In Netlify, Add new site → Import an existing project → choose the repository.
3. Build command: `npm run build`; publish directory: `public`; functions directory is `netlify/functions` from `netlify.toml`.
4. Add environment variables in Netlify Site configuration → Environment variables:
   - `SUPABASE_URL`: project URL
   - `SUPABASE_SERVICE_ROLE_KEY`: Supabase server-side secret/service-role key (never browser-side)
   - `SETUP_KEY`: a unique random value of at least 24 characters
   - `JWT_SECRET`: unique random secret of at least 32 bytes
5. Redeploy after setting variables.

## 3. First login
Open the deployed URL. If no owner exists, the setup page asks for `SETUP_KEY`, name, username and a password of at least 12 characters. Save the key privately; rotate/remove it after owner setup. If an owner profile already exists but has no password hash, don't create duplicate owners—perform a controlled password reset first.

## Security/testing warning
The function uses a server-side service-role client and therefore relies on authorization checks in every route. Never expose the service-role key. Before production, test all routes and upload/download permissions, check Netlify logs, review the schema against your actual live columns, and have a qualified reviewer assess security, data protection, backups, and loan calculations. This is a migration build, not a certified production financial system. Test with fake data only until sign-off.

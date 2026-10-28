-- Apply this once to the existing fls_* schema. Safe to rerun.
-- This migration keeps the app's username/password login model on the server.
alter table public.fls_staff_profiles
  add column if not exists password_hash text;

-- Ensure the KYC bucket stays private.
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('fls-private-documents', 'fls-private-documents', false, 5242880,
        array['image/jpeg','image/png','image/webp'])
on conflict (id) do update set public = false, file_size_limit = 5242880,
  allowed_mime_types = excluded.allowed_mime_types;

-- Do not create broad client-side policies. The Netlify function accesses data server-side.

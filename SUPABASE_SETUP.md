# Supabase Setup Guide

Step-by-step walkthrough for standing up the Supabase backend this project expects. Follow this after cloning the repo and running `flutter pub get`.

**Before you screenshot anything for this doc:** crop out your database password and API keys. This guide lives in the repo — nothing in it should be a live secret.

---

## 1. Create an organization (skip if you already have one)

From the Organizations page, click **New organization**. Give it a name, leave Type as Personal and Plan as Free.

## 2. Create a new project

Inside the organization, click **New Project**.

- **Project name**: whatever you'd like (e.g. `multi-role-auth-dev`)
- **Database Password**: generate a strong one and save it somewhere safe — you won't need it for this app (we only use the anon key), but you'll want it if you ever connect directly to Postgres
- **Region**: pick whatever's closest to you

**Security section** — leave the defaults:
- **Enable Data API**: checked (required — this is how the app talks to Supabase at all)
- **Automatically expose new tables**: checked (without it, `user_profiles` won't be reachable through the API once created)
- **Enable automatic RLS**: **unchecked**. This one matters — turning it on enables Row Level Security on every table you create from here on, with zero policies defined, which means Postgres defaults to blocking *all* access, including from the app itself. We're deliberately not writing RLS policies yet (see step 6), so this needs to stay off for now.

<!-- SCREENSHOT 1: the New Project form, filled in, with the Security checkboxes visible. Crop out the password field entirely. -->

## 3. Wait for provisioning

Takes about 1-2 minutes. Grab a coffee.

## 4. Get your API credentials

You need two values:

- **Project URL** (shown right on the project's home page, looks like `https://xxxxx.supabase.co`) — not sensitive, safe to show in screenshots
- **anon key** — go to **Project Settings → API Keys**

Supabase now shows two tabs there: "Publishable and secret API keys" (their new format, `sb_publishable_...`/`sb_secret_...`) and **"Legacy anon, service_role API keys"**. Use the **Legacy** tab and grab the `anon` key from there — the app's pinned `supabase_flutter` version (2.10.3) is the one we've actually verified against the classic JWT-format anon key, so there's no reason to risk the newer format until we deliberately upgrade and test it.

<!-- SCREENSHOT 2: the Legacy API keys tab. Crop tightly to just the "anon" key row — don't include "service_role" in frame, that one's much more sensitive and should never appear anywhere. -->

## 5. Create the `user_profiles` table

Go to **SQL Editor → New Query**, paste in the contents of [`schema.sql`](schema.sql) (repo root), and click **Run**.

<!-- SCREENSHOT 3: the SQL Editor after running the query, showing "Success. No rows returned" or similar. -->

## 6. About Row Level Security (deliberately left off)

You'll likely see a banner nudging you to enable RLS on this table. **Leave it off for now** — this is the same reasoning as the "Enable automatic RLS" checkbox back in step 2. The app generates a unique `custom_user_id` (like `MEM0042`) by checking whether a candidate already exists across *all* rows — a standard "only see your own row" RLS policy would break that check, since you can't see other users' rows to detect collisions. Enabling RLS properly needs either a narrower policy (public read on just the `custom_user_id` column) or moving the uniqueness check server-side — that's follow-up work, not a day-one setup step.

## 7. Update your local `.env`

In the project root, edit `.env` (copy from `.env.example` if it doesn't exist yet):

```
SUPABASE_URL=<your project URL from step 4>
SUPABASE_ANON_KEY=<your anon key from step 4>
```

## 8. Test it

Run the app, sign up with a real-looking email/password, and confirm:
- Signup succeeds and lands on the dashboard
- Logging out and back in works
- Closing and reopening the app keeps you signed in (session-restore)

> **Signup succeeds but login fails right after?** Supabase requires email confirmation by default — the account gets created, but you can't log in until you click a confirmation link, which needs SMTP configured to even receive one. For local testing, go to **Authentication → Providers → Email** and toggle **Confirm email** off. Worth turning back on before shipping anything real.

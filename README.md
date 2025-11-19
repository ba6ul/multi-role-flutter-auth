<<<<<<< HEAD
# multi_role_flutter_auth

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
=======
# multi-role-flutter-auth
# 📦 Database Setup (Supabase)

This project needs Supabase table named `user_profiles`.  

## Follow the steps (Required)

Open your Supabase project and run the SQL below.

### Steps
1. Open **Supabase Dashboard**
2. Go to **SQL Editor**
3. Copy–paste the content of `supabase/schema.sql` (below)
4. Click **Run**

---

## `supabase/schema.sql`

```sql
CREATE TABLE IF NOT EXISTS user_profiles (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  custom_user_id TEXT UNIQUE, -- e.g. "MEM0001"
  email TEXT,
  name TEXT,
  role TEXT,
  phone TEXT,
  date_of_birth DATE,
  gender TEXT,
  department TEXT,
  location TEXT,
  profile_image_url TEXT
);


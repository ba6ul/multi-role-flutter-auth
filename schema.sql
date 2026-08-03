-- Supabase schema for multi-role-flutter-auth
-- Run this in the Supabase SQL Editor (New Query) after creating your project.
-- See SUPABASE_SETUP.md for the full walkthrough.

CREATE TABLE IF NOT EXISTS user_profiles (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  custom_user_id TEXT UNIQUE,
  email TEXT,
  name TEXT,
  role TEXT,
  phone TEXT,
  date_of_birth DATE,
  gender TEXT,
  department TEXT,
  location TEXT,
  profile_image_url TEXT,
  profile_completed BOOLEAN DEFAULT false,
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- Row Level Security is deliberately left off for now. The app generates a
-- unique custom_user_id by checking whether a candidate already exists
-- across ALL rows - a standard "only see your own row" RLS policy would
-- break that check. Enable RLS once you've either narrowed a policy to
-- allow public read of just custom_user_id, or moved the uniqueness check
-- server-side.

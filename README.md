# multi-role-flutter-auth
# 📦 Database Setup (Supabase)

This project needs Supabase table named `user_profiles`.  

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

  -- You can add custom columns or modify the above columns if needed.
  -- Note: If you change the schema, you must update the code accordingly.
  -- Example:
  -- custom_field TEXT,
  -- another_field INTEGER
);



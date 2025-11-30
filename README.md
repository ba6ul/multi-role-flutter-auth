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
```

---

## 🚀 Dual-Mode Authentication Flows

This library supports two distinct authentication architectures out of the box, controlled via a simple configuration.

### 1. Enterprise Mode (Multi-Role)
* **Best for:** Admin panels, Organization apps, SaaS platforms.
* **The Flow:** User explicitly selects a role (e.g., *Admin, Director, Writer*) → System generates a standardized ID (e.g., `ADM-4521`).
* **UI Experience:** Includes a "Pick your Role" screen during sign-up.

### 2. Consumer Mode (Single-Role)
* **Best for:** Social apps, Games, E-commerce, Standard User apps.
* **The Flow:** User picks a unique Username → System assigns a default hidden role (e.g., `DEF`) → System generates a unique ID (e.g., `DEF-alian22`).
* **UI Experience:** Skips the Role Picker. The role assignment happens invisibly in the background for a seamless sign-up experience.

> **💡 Future-Proof:** Even in Single-Role mode, the backend maintains a role-based structure. This means you can scale a simple social app into a multi-role ecosystem (adding Moderators, VIPs, etc.) later without rewriting your database or migrating data.

---

    UI: Skips the Role Picker. Seamless sign-up experience.

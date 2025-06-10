-- SQL Queries to Remove RLS Policies from Users Table

-- 1. First, check what RLS policies exist on the users table
SELECT 
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd,
    qual,
    with_check
FROM pg_policies 
WHERE tablename = 'users' AND schemaname = 'public';

-- 2. Disable RLS on the users table (this will disable all policies)
ALTER TABLE public.users DISABLE ROW LEVEL SECURITY;

-- 3. Alternative: Drop specific RLS policies (if you want to keep RLS enabled but remove specific policies)
-- First, get the list of policy names:
-- SELECT policyname FROM pg_policies WHERE tablename = 'users' AND schemaname = 'public';

-- Then drop each policy individually (replace 'policy_name' with actual policy names):
-- DROP POLICY IF EXISTS "policy_name" ON public.users;

-- Common RLS policy names that might exist on users table:
-- DROP POLICY IF EXISTS "Users can view own profile" ON public.users;
-- DROP POLICY IF EXISTS "Users can update own profile" ON public.users;
-- DROP POLICY IF EXISTS "Users can insert own profile" ON public.users;
-- DROP POLICY IF EXISTS "Users can delete own profile" ON public.users;
-- DROP POLICY IF EXISTS "Enable read access for all users" ON public.users;
-- DROP POLICY IF EXISTS "Enable insert for authenticated users only" ON public.users;
-- DROP POLICY IF EXISTS "Enable update for users based on hushh_id" ON public.users;
-- DROP POLICY IF EXISTS "Enable delete for users based on hushh_id" ON public.users;

-- 4. If you want to completely remove RLS and all policies:
ALTER TABLE public.users DISABLE ROW LEVEL SECURITY;

-- 5. To re-enable RLS later (if needed):
-- ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

-- 6. Verify that RLS is disabled and no policies exist:
SELECT 
    schemaname,
    tablename,
    rowsecurity
FROM pg_tables 
WHERE tablename = 'users' AND schemaname = 'public';

-- 7. Check if any policies still exist:
SELECT COUNT(*) as policy_count
FROM pg_policies 
WHERE tablename = 'users' AND schemaname = 'public';

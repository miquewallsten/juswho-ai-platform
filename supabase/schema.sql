
-- Users Table (handled by Supabase Auth)
create table profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text,
  email text,
  phone text,
  curp text,
  rfc text,
  address text,
  photo_url text,
  created_at timestamp with time zone default timezone('utc'::text, now()),
  updated_at timestamp with time zone default timezone('utc'::text, now())
);

-- Cases Table
create table cases (
  id uuid primary key default gen_random_uuid(),
  customer_id uuid,
  user_id uuid references profiles(id) on delete cascade,
  status text check (status in ('open', 'submitted', 'verified', 'not_certified')) default 'open',
  seal_url text,
  tags text[],
  submitted_at timestamp with time zone,
  verified_at timestamp with time zone,
  created_at timestamp with time zone default timezone('utc'::text, now())
);

-- Customers Table
create table customers (
  id uuid primary key default gen_random_uuid(),
  company_name text,
  email text,
  phone text,
  is_contract boolean default false,
  case_limit int default 0,
  credits_available int default 0,
  created_at timestamp with time zone default timezone('utc'::text, now())
);

-- Case Invites
create table invites (
  id uuid primary key default gen_random_uuid(),
  customer_id uuid references customers(id),
  email text,
  token text,
  status text check (status in ('pending', 'accepted', 'expired')) default 'pending',
  expires_at timestamp with time zone,
  created_at timestamp with time zone default timezone('utc'::text, now())
);

-- Templates for Roles
create table templates (
  id uuid primary key default gen_random_uuid(),
  customer_id uuid references customers(id),
  role_name text,
  required_fields text[],
  created_at timestamp with time zone default timezone('utc'::text, now())
);

-- Tags (System + Custom)
create table tags (
  id uuid primary key default gen_random_uuid(),
  case_id uuid references cases(id),
  label text,
  type text check (type in ('system', 'custom')) default 'custom',
  created_at timestamp with time zone default timezone('utc'::text, now())
);

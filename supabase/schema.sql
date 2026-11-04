-- Supabase schema starter. Run in a new project only after reviewing with the practice.
create extension if not exists pgcrypto;

create table if not exists public.admin_users (
  user_id uuid primary key references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);

create table if not exists public.consultation_requests (
  id uuid primary key default gen_random_uuid(),
  reference text not null unique default ('BT-' || upper(substr(encode(gen_random_bytes(8),'hex'),1,10))),
  full_name text not null check (length(full_name) between 1 and 160),
  email text not null check (length(email) <= 254),
  phone text not null check (length(phone) between 10 and 24),
  client_type text not null check (client_type in ('Individual','Business')),
  service text,
  preferred_date date,
  preferred_time text,
  mode text,
  message text check (length(message) <= 1200),
  status text not null default 'new' check (status in ('new','confirmed','rescheduled','cancelled')),
  admin_note text,
  created_at timestamptz not null default now()
);

create table if not exists public.contact_enquiries (
  id uuid primary key default gen_random_uuid(),
  full_name text not null check (length(full_name) between 1 and 160),
  email text not null check (length(email) <= 254),
  phone text check (length(phone) <= 24),
  subject text not null check (length(subject) <= 200),
  message text not null check (length(message) between 1 and 2000),
  status text not null default 'new' check (status in ('new','read','closed')),
  created_at timestamptz not null default now()
);

create table if not exists public.consultation_slots (
  id uuid primary key default gen_random_uuid(),
  starts_at timestamptz not null,
  ends_at timestamptz not null check (ends_at > starts_at),
  is_open boolean not null default true,
  created_at timestamptz not null default now(),
  unique (starts_at, ends_at)
);

create table if not exists public.articles (
  id uuid primary key default gen_random_uuid(),
  slug text not null unique,
  title text not null,
  category text not null,
  excerpt text not null,
  body text not null,
  image_url text,
  status text not null default 'draft' check (status in ('draft','published')),
  published_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.leads (
  id uuid primary key default gen_random_uuid(),
  lead_type text not null check (lead_type in ('consultation', 'contact')),
  full_name text not null check (length(trim(full_name)) between 1 and 160),
  email text not null check (length(trim(email)) between 3 and 254),
  phone text check (phone is null or length(trim(phone)) <= 24),
  subject text check (subject is null or length(trim(subject)) <= 200),
  service text check (service is null or length(trim(service)) <= 120),
  client_type text check (client_type is null or client_type in ('Individual', 'Business')),
  consultation_mode text check (consultation_mode is null or consultation_mode in ('Online', 'In person', 'Phone')),
  message text check (message is null or length(message) <= 2000),
  status text not null default 'new' check (status in ('new', 'read', 'closed')),
  created_at timestamptz not null default now(),
  consent_at timestamptz not null default now()
);

alter table public.admin_users enable row level security;
alter table public.consultation_requests enable row level security;
alter table public.contact_enquiries enable row level security;
alter table public.consultation_slots enable row level security;
alter table public.articles enable row level security;
alter table public.leads enable row level security;

-- Browser visitors can submit validated leads, but have no read, update or delete access.
grant usage on schema public to anon, authenticated;
revoke all privileges on table public.leads from anon, authenticated;
grant insert (lead_type, full_name, email, phone, subject, service, client_type, consultation_mode, message)
  on public.leads to anon, authenticated;
create policy "website visitors can submit leads" on public.leads for insert to anon, authenticated
  with check (status = 'new');

-- Private records are intentionally inaccessible to browser clients. All form
-- writes and admin reads/updates must pass through authenticated server functions.
create policy "admins can read admin roster" on public.admin_users for select to authenticated
  using (user_id = auth.uid());
create policy "admins manage consultation requests" on public.consultation_requests for all to authenticated
  using (exists(select 1 from public.admin_users a where a.user_id = auth.uid()))
  with check (exists(select 1 from public.admin_users a where a.user_id = auth.uid()));
create policy "admins manage contact enquiries" on public.contact_enquiries for all to authenticated
  using (exists(select 1 from public.admin_users a where a.user_id = auth.uid()))
  with check (exists(select 1 from public.admin_users a where a.user_id = auth.uid()));
create policy "admins manage consultation slots" on public.consultation_slots for all to authenticated
  using (exists(select 1 from public.admin_users a where a.user_id = auth.uid()))
  with check (exists(select 1 from public.admin_users a where a.user_id = auth.uid()));
create policy "public can read published articles" on public.articles for select to anon, authenticated
  using (status = 'published');
create policy "admins manage articles" on public.articles for all to authenticated
  using (exists(select 1 from public.admin_users a where a.user_id = auth.uid()))
  with check (exists(select 1 from public.admin_users a where a.user_id = auth.uid()));

-- Add the first administrator manually after creating their Supabase Auth user:
-- insert into public.admin_users(user_id) values ('AUTH-USER-UUID');

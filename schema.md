# Database Schema Documentation

## Users Table Schema

```sql
create table public.users (
  first_name text null,
  last_name text null,
  gender text null,
  email text null default ''::text,
  phone json null,
  device json null,
  address character varying null,
  avatar text null,
  password character varying null,
  role text null,
  country character varying null,
  zipcode bigint null,
  city character varying null,
  creationtime text null,
  "fcmToken" text null,
  private_mode boolean null,
  user_coins integer null,
  conversations text[] null,
  gpt_token_usage integer null,
  last_used_token_date_time text null,
  dob text null,
  hushh_id text not null,
  "profileVideo" text null,
  name text null,
  "uploadedVideos" text[] null,
  demographic_card_questions jsonb[] null,
  hushh_id_card_questions jsonb[] null,
  is_hushh_app_user boolean null default false,
  is_hushh_button_user boolean null,
  is_hushh_vibe_user boolean null,
  is_browser_companion_user boolean null,
  phone_number text null,
  country_code text null,
  phonenumberwithoutcountrycode text null,
  "phoneNumber" text null,
  onboard_status public.onboard_status_enum not null default 'authenticated'::onboard_status_enum,
  hushh_id_uuid uuid GENERATED ALWAYS as ((hushh_id)::uuid) STORED null,
  "accountCreation" timestamp with time zone not null default now(),
  selected_reason_for_using_hushh text null,
  dummy boolean null,
  dob_updated_at timestamp with time zone null,
  education_updated_at timestamp with time zone null,
  income_updated_at timestamp with time zone null,
  constraint users_pkey primary key (hushh_id),
  constraint users_email_key unique (email),
  constraint users_hushh_id_uuid_fkey foreign KEY (hushh_id_uuid) references auth.users (id) on delete CASCADE
) TABLESPACE pg_default;
```

## New Timestamp Fields

### Purpose
Track when users update their preference card information.

### Fields Added
- **`dob_updated_at`**: Timestamp when user updates Date of Birth
- **`education_updated_at`**: Timestamp when user updates Education information  
- **`income_updated_at`**: Timestamp when user updates Income information

### Data Type
- Type: `timestamp with time zone`
- Default: `null`
- Nullable: Yes

### Usage
These fields are automatically updated when users modify their corresponding preference card data through the mobile app.

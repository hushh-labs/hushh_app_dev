# Database Schema Documentation

## Complete Supabase Database Schema

### Users Table Schema

```sql
CREATE TABLE public.users (
  first_name text,
  last_name text,
  gender text,
  email text DEFAULT ''::text UNIQUE,
  phone json,
  device json,
  address character varying,
  avatar text,
  password character varying,
  role text,
  country character varying,
  zipcode bigint,
  city character varying,
  creationtime text,
  fcmToken text,
  private_mode boolean,
  user_coins integer,
  conversations ARRAY,
  gpt_token_usage integer,
  last_used_token_date_time text,
  dob text,
  hushh_id text NOT NULL,
  profileVideo text,
  name text,
  uploadedVideos ARRAY,
  demographic_card_questions ARRAY,
  hushh_id_card_questions ARRAY,
  is_hushh_app_user boolean DEFAULT false,
  is_hushh_button_user boolean,
  is_hushh_vibe_user boolean,
  is_browser_companion_user boolean,
  phone_number text,
  country_code text,
  phonenumberwithoutcountrycode text,
  phoneNumber text,
  onboard_status USER-DEFINED NOT NULL DEFAULT 'authenticated'::onboard_status_enum,
  hushh_id_uuid uuid DEFAULT (hushh_id)::uuid,
  accountCreation timestamp with time zone NOT NULL DEFAULT now(),
  selected_reason_for_using_hushh text,
  dummy boolean,
  dob_updated_at timestamp with time zone,
  education_updated_at timestamp with time zone,
  income_updated_at timestamp with time zone,
  CONSTRAINT users_pkey PRIMARY KEY (hushh_id),
  CONSTRAINT users_hushh_id_uuid_fkey FOREIGN KEY (hushh_id_uuid) REFERENCES auth.users(id)
);
```

### Consent & Request Tables

```sql
CREATE TABLE public.accepted_consent_request (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  accepted_at timestamp with time zone DEFAULT now(),
  created_at timestamp with time zone NOT NULL,
  request_id text NOT NULL,
  user_id text NOT NULL,
  card_id integer NOT NULL,
  expiry date NOT NULL,
  requestor_id uuid NOT NULL,
  bid_value numeric,
  CONSTRAINT accepted_consent_request_pkey PRIMARY KEY (id),
  CONSTRAINT accepted_consent_request_card_id_fkey FOREIGN KEY (card_id) REFERENCES public.card_market(id)
);

CREATE TABLE public.card_consent_request (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  user_id text NOT NULL,
  card_id integer NOT NULL,
  expiry date,
  request_id uuid NOT NULL DEFAULT gen_random_uuid() UNIQUE,
  requestor_id uuid NOT NULL,
  bid_value numeric,
  CONSTRAINT card_consent_request_pkey PRIMARY KEY (id),
  CONSTRAINT card_consent_request_card_id_fkey FOREIGN KEY (card_id) REFERENCES public.card_market(id)
);

CREATE TABLE public.rejected_consent_request (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  rejected_at timestamp with time zone NOT NULL DEFAULT now(),
  created_at timestamp with time zone NOT NULL,
  request_id text NOT NULL,
  user_id text NOT NULL,
  card_id integer NOT NULL,
  expiry date NOT NULL,
  requestor_id uuid NOT NULL,
  bid_value numeric,
  CONSTRAINT rejected_consent_request_pkey PRIMARY KEY (id)
);

CREATE TABLE public.revoked_consent_request (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  revoked_at timestamp with time zone NOT NULL DEFAULT now(),
  request_id text,
  request_metadata jsonb,
  CONSTRAINT revoked_consent_request_pkey PRIMARY KEY (id)
);

CREATE TABLE public.consent_request_status (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  request_id text NOT NULL,
  status boolean NOT NULL,
  CONSTRAINT consent_request_status_pkey PRIMARY KEY (id)
);
```

### Agent Tables

```sql
CREATE TABLE public.agents (
  agent_work_email text,
  agent_approval_status text,
  agent_conversations ARRAY,
  agent_name text,
  agent_card jsonb,
  agent_desc text,
  agent_image text,
  agent_coins integer,
  agent_categories ARRAY,
  created_at timestamp with time zone DEFAULT (now() AT TIME ZONE 'utc'::text),
  hushh_id text NOT NULL,
  agent_brand_id integer,
  CONSTRAINT agents_pkey PRIMARY KEY (hushh_id),
  CONSTRAINT agents_agent_brand_id_fkey FOREIGN KEY (agent_brand_id) REFERENCES public.brand_details(id),
  CONSTRAINT agents_hushh_id_fkey FOREIGN KEY (hushh_id) REFERENCES public.users(hushh_id)
);

CREATE TABLE public.agent_categories (
  name text,
  id integer NOT NULL DEFAULT nextval('agent_categories_id_seq'::regclass),
  type text,
  icon text,
  CONSTRAINT agent_categories_pkey PRIMARY KEY (id)
);

CREATE TABLE public.agent_lookbooks (
  name text,
  createdAt text,
  id text NOT NULL,
  numberOfProducts integer,
  images ARRAY,
  hushhId text,
  CONSTRAINT agent_lookbooks_pkey PRIMARY KEY (id),
  CONSTRAINT public_agent_lookbooks_hushhId_fkey FOREIGN KEY (hushhId) REFERENCES public.users(hushh_id)
);

CREATE TABLE public.agent_products (
  productCurrency text,
  productImage text,
  productName text,
  productDescription text,
  addedAt text,
  productSkuUniqueId text,
  productPrice double precision,
  lookbook_id text,
  productId text NOT NULL,
  hushh_id text,
  CONSTRAINT agent_products_pkey PRIMARY KEY (productId),
  CONSTRAINT agent_products_lookbook_id_fkey FOREIGN KEY (lookbook_id) REFERENCES public.agent_lookbooks(id),
  CONSTRAINT public_agent_products_hushh_id_fkey FOREIGN KEY (hushh_id) REFERENCES public.users(hushh_id)
);

CREATE TABLE public.agent_services (
  title text,
  desc text,
  hushh_id text,
  task_type USER-DEFINED,
  date_time text,
  id text NOT NULL,
  registered_by_hushh_id text NOT NULL,
  status text DEFAULT 'pending'::text,
  card_id integer,
  is_card_shared_with_service boolean NOT NULL DEFAULT false,
  CONSTRAINT agent_services_pkey PRIMARY KEY (id),
  CONSTRAINT agent_services_card_id_fkey FOREIGN KEY (card_id) REFERENCES public.card_market(id),
  CONSTRAINT agent_tasks_registered_by_hushh_id_fkey FOREIGN KEY (registered_by_hushh_id) REFERENCES public.users(hushh_id),
  CONSTRAINT public_agent_tasks_hushh_id_fkey FOREIGN KEY (hushh_id) REFERENCES public.users(hushh_id)
);

CREATE TABLE public.agent_meetings (
  id text NOT NULL,
  title text,
  desc text,
  dateTime text,
  duration bigint,
  lat text,
  long text,
  organizerId text,
  participantsIds ARRAY,
  meetingType USER-DEFINED,
  gMeetLink text,
  gEventId text,
  CONSTRAINT agent_meetings_pkey PRIMARY KEY (id),
  CONSTRAINT public_agent_meetings_organizerId_fkey FOREIGN KEY (organizerId) REFERENCES public.users(hushh_id)
);

CREATE TABLE public.agent_setup_meets (
  isActivated boolean DEFAULT false,
  name text,
  duration integer,
  dayTimings json,
  selectedSlots json,
  collectPayment boolean DEFAULT false,
  amount double precision DEFAULT 0,
  currency text,
  timeZone text,
  hushh_id text NOT NULL,
  CONSTRAINT agent_setup_meets_pkey PRIMARY KEY (hushh_id),
  CONSTRAINT public_agent_setup_meets_hushh_id_fkey FOREIGN KEY (hushh_id) REFERENCES public.users(hushh_id)
);

CREATE TABLE public.agent_notifications (
  id integer NOT NULL DEFAULT nextval('agent_notifications_id_seq'::regclass),
  title text,
  description text,
  route text,
  date_time text,
  type text,
  user_id text,
  CONSTRAINT agent_notifications_pkey PRIMARY KEY (id),
  CONSTRAINT public_agent_notifications_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(hushh_id)
);
```

### Card Market Tables

```sql
CREATE TABLE public.card_market (
  brand_name text,
  image text,
  category text NOT NULL,
  type bigint,
  audio_url text,
  body_image text,
  logo text,
  featured bigint,
  id integer GENERATED ALWAYS AS IDENTITY NOT NULL UNIQUE,
  category_id integer,
  domain text,
  brandId integer,
  gradient ARRAY,
  created_at timestamp with time zone DEFAULT (now() AT TIME ZONE 'utc'::text),
  CONSTRAINT card_market_pkey PRIMARY KEY (id),
  CONSTRAINT card_market_brandId_fkey FOREIGN KEY (brandId) REFERENCES public.brand_details(id),
  CONSTRAINT card_market_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.brand_categories(id)
);

CREATE TABLE public.card_market_questions (
  question_text text,
  type bigint,
  card_market_id integer,
  id integer GENERATED ALWAYS AS IDENTITY NOT NULL,
  card_question_type USER-DEFINED NOT NULL DEFAULT 'multiSelectQuestion'::"CardQuestionType",
  CONSTRAINT card_market_questions_pkey PRIMARY KEY (id),
  CONSTRAINT card_market_questions_card_market_id_fkey FOREIGN KEY (card_market_id) REFERENCES public.card_market(id)
);

CREATE TABLE public.card_market_answers (
  answer_text text,
  status bigint,
  card_market_id integer,
  id integer GENERATED ALWAYS AS IDENTITY NOT NULL,
  question_id integer,
  CONSTRAINT card_market_answers_pkey PRIMARY KEY (id),
  CONSTRAINT card_market_answers_card_market_id_fkey FOREIGN KEY (card_market_id) REFERENCES public.card_market(id),
  CONSTRAINT card_market_answers_question_id_fkey FOREIGN KEY (question_id) REFERENCES public.card_market_questions(id)
);

CREATE TABLE public.user_installed_cards (
  cid integer GENERATED ALWAYS AS IDENTITY NOT NULL,
  id integer NOT NULL,
  audio_url text,
  user_id text NOT NULL,
  card_value text,
  is_installed integer,
  coins text,
  attached_brand_cards_coins text,
  attached_pref_cards_coins text,
  access_list ARRAY,
  installed_time timestamp with time zone DEFAULT now(),
  attached_card_ids ARRAY DEFAULT '{}'::text[],
  attached_pref_card_ids ARRAY DEFAULT '{}'::text[],
  payment_time timestamp without time zone,
  answers ARRAY,
  audio_transcription jsonb,
  card_currency text DEFAULT 'USD'::text,
  CONSTRAINT user_installed_cards_pkey PRIMARY KEY (cid),
  CONSTRAINT user_installed_cards_id_fkey FOREIGN KEY (id) REFERENCES public.card_market(id),
  CONSTRAINT user_installed_cards_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(hushh_id)
);

CREATE TABLE public.user_shared_cards (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  from_user_id text,
  to_user_id text,
  shared_card_id integer,
  to_brand_id integer,
  CONSTRAINT user_shared_cards_pkey PRIMARY KEY (id),
  CONSTRAINT user_shared_cards_shared_card_id_fkey FOREIGN KEY (shared_card_id) REFERENCES public.user_installed_cards(cid),
  CONSTRAINT user_shared_cards_to_brand_id_fkey FOREIGN KEY (to_brand_id) REFERENCES public.brand_details(id),
  CONSTRAINT user_shared_cards_to_user_id_fkey FOREIGN KEY (to_user_id) REFERENCES public.users(hushh_id),
  CONSTRAINT user_shared_cards_from_user_id_fkey FOREIGN KEY (from_user_id) REFERENCES public.users(hushh_id)
);

CREATE TABLE public.cards_purchased_by_agent (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  shared_id bigint,
  card_id integer NOT NULL,
  agent_id text NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT cards_purchased_by_agent_pkey PRIMARY KEY (id),
  CONSTRAINT public_cards_purchased_by_agent_agent_id_fkey FOREIGN KEY (agent_id) REFERENCES public.users(hushh_id),
  CONSTRAINT public_cards_purchased_by_agent_card_id_fkey FOREIGN KEY (card_id) REFERENCES public.user_installed_cards(cid),
  CONSTRAINT cards_purchased_by_agent_shared_id_fkey FOREIGN KEY (shared_id) REFERENCES public.user_shared_cards(id)
);

CREATE TABLE public.recommended_cards (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  user_id text NOT NULL,
  card_ids ARRAY NOT NULL,
  CONSTRAINT recommended_cards_pkey PRIMARY KEY (id),
  CONSTRAINT recommended_cards_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(hushh_id)
);
```

### Brand Tables

```sql
CREATE TABLE public.brand_details (
  id integer GENERATED ALWAYS AS IDENTITY NOT NULL,
  domain text UNIQUE,
  brand_name text NOT NULL,
  brand_category_id integer NOT NULL,
  brand_logo text NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT (now() AT TIME ZONE 'utc'::text),
  custom_brand boolean NOT NULL DEFAULT true,
  palette jsonb,
  team_id integer,
  brand_approval_status USER-DEFINED,
  configurations ARRAY,
  CONSTRAINT brand_details_pkey PRIMARY KEY (id),
  CONSTRAINT brand_details_brand_category_id_fkey FOREIGN KEY (brand_category_id) REFERENCES public.brand_categories(id)
);

CREATE TABLE public.brand_categories (
  id integer GENERATED ALWAYS AS IDENTITY NOT NULL,
  brand_category text NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT brand_categories_pkey PRIMARY KEY (id)
);

CREATE TABLE public.brand_locations (
  location_id integer NOT NULL DEFAULT nextval('brand_locations_location_id_seq'::regclass),
  brand_id integer,
  location USER-DEFINED NOT NULL,
  registered_by text,
  created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
  address text,
  CONSTRAINT brand_locations_pkey PRIMARY KEY (location_id),
  CONSTRAINT brand_locations_brand_id_fkey FOREIGN KEY (brand_id) REFERENCES public.brand_details(id),
  CONSTRAINT brand_locations_registered_by_fkey FOREIGN KEY (registered_by) REFERENCES public.users(hushh_id)
);

CREATE TABLE public.brand_teams (
  brand_id integer NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  hushh_id text NOT NULL,
  id integer GENERATED ALWAYS AS IDENTITY NOT NULL,
  role USER-DEFINED NOT NULL,
  status USER-DEFINED DEFAULT 'pending'::"ApprovalStatus",
  CONSTRAINT brand_teams_pkey PRIMARY KEY (id),
  CONSTRAINT brand_teams_brand_id_fkey FOREIGN KEY (brand_id) REFERENCES public.brand_details(id),
  CONSTRAINT brand_teams_hushh_id_fkey FOREIGN KEY (hushh_id) REFERENCES public.agents(hushh_id)
);

CREATE TABLE public.brand_configurations (
  configuration_id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  inventory_name text NOT NULL,
  product_image_identifier text NOT NULL,
  product_name_identifier text NOT NULL,
  product_sku_unique_id_identifier text NOT NULL,
  product_price_identifier text NOT NULL,
  product_currency_identifier text NOT NULL,
  product_description_identifier text NOT NULL,
  configuration_server_type USER-DEFINED NOT NULL,
  brand_id integer,
  CONSTRAINT brand_configurations_pkey PRIMARY KEY (configuration_id),
  CONSTRAINT brand_configurations_brand_id_fkey FOREIGN KEY (brand_id) REFERENCES public.brand_details(id)
);

CREATE TABLE public.brand_offers (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  offer_desc text,
  discount_tag text,
  brand_id integer,
  brand_inventory_view_name text,
  product_sku integer,
  updated_price integer,
  is_highlighted boolean NOT NULL DEFAULT false,
  CONSTRAINT brand_offers_pkey PRIMARY KEY (id)
);

CREATE TABLE public.brand_logos (
  Rank bigint,
  company_name text,
  Location text,
  Industry text,
  Size text,
  logo_URL text,
  id integer GENERATED ALWAYS AS IDENTITY NOT NULL,
  source text,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT brand_logos_pkey PRIMARY KEY (id)
);

CREATE TABLE public.brand_groups (
  gId bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  location_ids ARRAY,
  CONSTRAINT brand_groups_pkey PRIMARY KEY (gId)
);

CREATE TABLE public.brands (
  brand_name text NOT NULL UNIQUE,
  brand_category character varying,
  brand_segment character varying,
  CONSTRAINT brands_pkey PRIMARY KEY (brand_name)
);
```

### Communication Tables

```sql
CREATE TABLE public.conversations (
  participants json,
  lastMessage jsonb,
  lastUpdated timestamp with time zone,
  id text NOT NULL,
  unreadCount integer DEFAULT 0,
  type text,
  CONSTRAINT conversations_pkey PRIMARY KEY (id)
);

CREATE TABLE public.messages (
  author json,
  createdAt bigint,
  height double precision,
  id text NOT NULL,
  metadata json,
  name text,
  remoteId text,
  repliedMessage json,
  roomId text NOT NULL,
  showStatus boolean,
  size integer,
  status text,
  type text,
  updatedAt bigint,
  uri text,
  width double precision,
  previewData json,
  text text,
  isLoading boolean,
  mimeType text,
  waveForm ARRAY,
  CONSTRAINT messages_pkey PRIMARY KEY (id),
  CONSTRAINT messages_roomId_fkey FOREIGN KEY (roomId) REFERENCES public.conversations(id)
);

CREATE TABLE public.ai_messages (
  author json,
  createdAt bigint,
  height double precision,
  id text NOT NULL,
  metadata json,
  name text,
  remoteId text,
  repliedMessage json,
  roomId text,
  showStatus boolean,
  size integer,
  status text,
  type text,
  updatedAt bigint,
  uri text,
  width double precision,
  previewData json,
  text text DEFAULT ''::text,
  isLoading boolean,
  mimeType text,
  waveForm ARRAY,
  CONSTRAINT ai_messages_pkey PRIMARY KEY (id)
);
```

### App & Usage Tables

```sql
CREATE TABLE public.app_categories (
  id integer GENERATED ALWAYS AS IDENTITY NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  category_name text NOT NULL,
  CONSTRAINT app_categories_pkey PRIMARY KEY (id)
);

CREATE TABLE public.user_apps (
  app_id text NOT NULL,
  added_by text,
  scraped_on timestamp with time zone DEFAULT now(),
  icon_url text,
  app_category_id integer,
  developer_name text,
  ratings double precision,
  downloads bigint,
  app_support_website text,
  app_support_number text,
  app_support_email text,
  app_support_address text,
  app_privacy_policy text,
  app_data_shared ARRAY,
  app_data_collected ARRAY,
  can_connect boolean NOT NULL DEFAULT false,
  app_name text,
  CONSTRAINT user_apps_pkey PRIMARY KEY (app_id),
  CONSTRAINT user_apps_app_category_id_fkey FOREIGN KEY (app_category_id) REFERENCES public.app_categories(id),
  CONSTRAINT user_apps_added_by_fkey FOREIGN KEY (added_by) REFERENCES public.users(hushh_id)
);

CREATE TABLE public.app_connections (
  connection_id integer GENERATED ALWAYS AS IDENTITY NOT NULL,
  created_at timestamp with time zone DEFAULT now(),
  app_id text NOT NULL,
  hushh_id text NOT NULL,
  CONSTRAINT app_connections_pkey PRIMARY KEY (connection_id),
  CONSTRAINT app_connections_app_id_fkey FOREIGN KEY (app_id) REFERENCES public.user_apps(app_id),
  CONSTRAINT app_connections_hushh_id_fkey FOREIGN KEY (hushh_id) REFERENCES public.users(hushh_id)
);

CREATE TABLE public.app_usage (
  hushh_id text,
  created_at timestamp with time zone DEFAULT now(),
  start_data timestamp with time zone,
  end_data timestamp with time zone,
  app_id text,
  app_usage_id integer GENERATED ALWAYS AS IDENTITY NOT NULL,
  usage integer,
  last_foreground timestamp with time zone,
  CONSTRAINT app_usage_pkey PRIMARY KEY (app_usage_id),
  CONSTRAINT app_usage_hushh_id_fkey FOREIGN KEY (hushh_id) REFERENCES public.users(hushh_id)
);

CREATE TABLE public.app_brand_categories (
  id integer NOT NULL DEFAULT nextval('app_brand_categories_id_seq'::regclass),
  app_category_id integer NOT NULL,
  brand_category_id integer NOT NULL,
  created_at timestamp with time zone NOT NULL,
  CONSTRAINT app_brand_categories_pkey PRIMARY KEY (id),
  CONSTRAINT app_brand_categories_app_category_id_fkey FOREIGN KEY (app_category_id) REFERENCES public.app_categories(id),
  CONSTRAINT app_brand_categories_brand_category_id_fkey FOREIGN KEY (brand_category_id) REFERENCES public.brand_categories(id)
);
```

### Health & Location Tables

```sql
CREATE TABLE public.health_data (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  hushh_id text NOT NULL,
  data_type text NOT NULL,
  date_from timestamp with time zone,
  date_to timestamp with time zone,
  value real,
  CONSTRAINT health_data_pkey PRIMARY KEY (id),
  CONSTRAINT health_data_hushh_id_fkey FOREIGN KEY (hushh_id) REFERENCES public.users(hushh_id)
);

CREATE TABLE public.locations (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  hushh_id text NOT NULL,
  location USER-DEFINED NOT NULL,
  CONSTRAINT locations_pkey PRIMARY KEY (id),
  CONSTRAINT locations_hushh_id_fkey FOREIGN KEY (hushh_id) REFERENCES public.users(hushh_id)
);

CREATE TABLE public.user_brand_location_triggers (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  trigger_type USER-DEFINED NOT NULL,
  user_id text NOT NULL,
  brand_id integer NOT NULL,
  created_at timestamp with time zone DEFAULT now(),
  brand_location_id integer NOT NULL,
  CONSTRAINT user_brand_location_triggers_pkey PRIMARY KEY (id),
  CONSTRAINT user_brand_location_triggers_brand_location_id_fkey FOREIGN KEY (brand_location_id) REFERENCES public.brand_locations(location_id),
  CONSTRAINT user_brand_location_triggers_brand_id_fkey FOREIGN KEY (brand_id) REFERENCES public.brand_details(id),
  CONSTRAINT user_brand_location_triggers_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(hushh_id)
);
```

### Email & Receipt Processing Tables

```sql
CREATE TABLE public.gmail_receipts_data (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  user_id text NOT NULL,
  message_id text,
  domain text,
  attachment_extension text,
  attachment_id text,
  session_id text,
  email text,
  html_body text,
  batch_id text,
  CONSTRAINT gmail_receipts_data_pkey PRIMARY KEY (id),
  CONSTRAINT gmail_receipts_data_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(hushh_id)
);

CREATE TABLE public.user_gmail_token_details (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  access_token text,
  refresh_token text,
  email text NOT NULL UNIQUE,
  user_id text,
  CONSTRAINT user_gmail_token_details_pkey PRIMARY KEY (id),
  CONSTRAINT user_gmail_token_details_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(hushh_id)
);

CREATE TABLE public.receipt_radar_structured_data_duplicate (
  user_id text NOT NULL,
  time_stamp timestamp with time zone DEFAULT now(),
  brand text,
  location text,
  purchase_category text,
  brand_category text,
  Date text,
  currency text,
  filename text,
  payment_method text,
  logo text,
  metadata text,
  session_id text,
  message_id text,
  total_cost real,
  inr_total_cost real,
  usd_total_cost real,
  company text,
  attachment_id text,
  body text,
  id integer GENERATED ALWAYS AS IDENTITY NOT NULL,
  attachment_extension text,
  receipt_date timestamp without time zone DEFAULT parse_date_to_timestamp("Date"),
  email text,
  CONSTRAINT receipt_radar_structured_data_duplicate_pkey PRIMARY KEY (id),
  CONSTRAINT receipt_radar_structured_data_duplicate_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(hushh_id)
);

CREATE TABLE public.receipt_radar_authenticate (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  hushh_id text,
  email text UNIQUE,
  isAuthorised boolean NOT NULL,
  CONSTRAINT receipt_radar_authenticate_pkey PRIMARY KEY (id),
  CONSTRAINT receipt_radar_authenticate_hushh_id_fkey FOREIGN KEY (hushh_id) REFERENCES public.users(hushh_id)
);

CREATE TABLE public.receipt_ocr_data (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  message_id text,
  user_id text,
  receipt_text text,
  email text,
  status text DEFAULT 'processing not started'::text,
  file_type text DEFAULT 'html'::text,
  CONSTRAINT receipt_ocr_data_pkey PRIMARY KEY (id),
  CONSTRAINT receipt_ocr_data_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(hushh_id)
);

CREATE TABLE public.document_ai_entities (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  due_date text,
  invoice_date text,
  total_amount text,
  total_tax_amount text,
  receiver_name text,
  invoice_id text,
  currency text,
  receiver_address text,
  invoice_type text,
  supplier_name text,
  payment_terms text,
  line_item text,
  line_item_description text,
  line_item_quantity text,
  line_item_amount text,
  line_item_unit_price text,
  raw_text text,
  user_id text,
  email text,
  message_id text,
  categorised_data text,
  CONSTRAINT document_ai_entities_pkey PRIMARY KEY (id),
  CONSTRAINT document_ai_entities_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(hushh_id)
);

CREATE TABLE public.email_processing_metrics (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  created_at time without time zone NOT NULL,
  user_id text,
  user_email text,
  mail_total_count bigint,
  processed_email_count bigint,
  priority bigint,
  CONSTRAINT email_processing_metrics_pkey PRIMARY KEY (id),
  CONSTRAINT email_processing_metrics_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(hushh_id)
);

CREATE TABLE public.ingested_gmail_data_count (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  user_id text,
  total_emails_synced bigint,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT ingested_gmail_data_count_pkey PRIMARY KEY (id),
  CONSTRAINT ingested_gmail_data_count_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(hushh_id)
);
```

### Browsing & Companion Tables

```sql
CREATE TABLE public.browsing_behavior (
  website_url text NOT NULL,
  visit_time timestamp with time zone DEFAULT now(),
  product_clicks integer,
  interest_keywords jsonb,
  email text,
  hushh_id text NOT NULL,
  brand text NOT NULL,
  source text,
  duration double precision,
  CONSTRAINT browsing_behavior_pkey PRIMARY KEY (hushh_id, brand)
);

CREATE TABLE public.browser_history (
  hushh_id integer NOT NULL,
  website_url text,
  search_intent text,
  visit_time timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT browser_history_pkey PRIMARY KEY (hushh_id, visit_time),
  CONSTRAINT browser_history_website_url_fkey FOREIGN KEY (website_url) REFERENCES public.website(website_url)
);

CREATE TABLE public.companion_weblinks (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  url text,
  hushh_id text DEFAULT gen_random_uuid(),
  brand_id text,
  category text,
  title text DEFAULT 'No Title Captured'::text,
  CONSTRAINT companion_weblinks_pkey PRIMARY KEY (id),
  CONSTRAINT companion_weblinks_hushh_id_fkey FOREIGN KEY (hushh_id) REFERENCES public.users(hushh_id)
);

CREATE TABLE public.companion_google_searches (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  hushh_id text NOT NULL,
  category text,
  google_search text,
  CONSTRAINT companion_google_searches_pkey PRIMARY KEY (id),
  CONSTRAINT companion_google_searches_hushh_id_fkey FOREIGN KEY (hushh_id) REFERENCES public.users(hushh_id)
);

CREATE TABLE public.companion_collections (
  collection_id uuid NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  product_id uuid NOT NULL,
  collection_product_id uuid NOT NULL DEFAULT gen_random_uuid(),
  CONSTRAINT companion_collections_pkey PRIMARY KEY (collection_product_id),
  CONSTRAINT companion_collections_id_fkey1 FOREIGN KEY (collection_id) REFERENCES public.user_collections(collection_id),
  CONSTRAINT companion_collections_id_fkey FOREIGN KEY (collection_id) REFERENCES public.user_collections(collection_id),
  CONSTRAINT companion_collections_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(product_id)
);

CREATE TABLE public.companion_link_collections_metadata (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  name text,
  hushh_id text NOT NULL,
  CONSTRAINT companion_link_collections_metadata_pkey PRIMARY KEY (id),
  CONSTRAINT companion_link_collections_metadata_hushh_id_fkey FOREIGN KEY (hushh_id) REFERENCES public.users(hushh_id)
);

CREATE TABLE public.companion_linkcollections (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  link_id bigint,
  collection_id bigint,
  CONSTRAINT companion_linkcollections_pkey PRIMARY KEY (id),
  CONSTRAINT companion_linkcollections_link_id_fkey FOREIGN KEY (link_id) REFERENCES public.companion_weblinks(id)
);
```

### Products & Collections Tables

```sql
CREATE TABLE public.products (
  product_title text,
  image_url text,
  description text,
  product_page_url text,
  brand_name text,
  product_category text,
  price text,
  user_id uuid NOT NULL DEFAULT gen_random_uuid(),
  currency text,
  product_url text NOT NULL,
  timestamp timestamp with time zone DEFAULT now(),
  product_id uuid NOT NULL DEFAULT gen_random_uuid() UNIQUE,
  CONSTRAINT products_pkey PRIMARY KEY (user_id, product_url),
  CONSTRAINT products_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id),
  CONSTRAINT products_brand_name_fkey FOREIGN KEY (brand_name) REFERENCES public.brands(brand_name)
);

CREATE TABLE public.user_collections (
  hushh_id text NOT NULL,
  collection_name text NOT NULL,
  collection_data json,
  collection_id uuid NOT NULL DEFAULT gen_random_uuid() UNIQUE,
  timestamp timestamp with time zone DEFAULT now(),
  CONSTRAINT user_collections_pkey PRIMARY KEY (collection_id)
);
```

### Notifications & Preferences Tables

```sql
CREATE TABLE public.notifications (
  id integer NOT NULL DEFAULT nextval('notifications_id_seq'::regclass),
  title text,
  description text,
  route text,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  status USER-DEFINED,
  user_id text NOT NULL,
  notification_type USER-DEFINED NOT NULL,
  payload jsonb,
  notify boolean DEFAULT false,
  CONSTRAINT notifications_pkey PRIMARY KEY (id)
);

CREATE TABLE public.user_notifications (
  id integer NOT NULL DEFAULT nextval('user_notifications_id_seq'::regclass),
  title text,
  description text,
  route text,
  date_time timestamp with time zone,
  type text,
  user_id text,
  CONSTRAINT user_notifications_pkey PRIMARY KEY (id)
);

CREATE TABLE public.shared_preferences (
  question_id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  question text,
  questionType USER-DEFINED,
  answers ARRAY,
  audio_url text,
  metadata jsonb,
  hushh_id text NOT NULL,
  card_id integer,
  content text,
  CONSTRAINT shared_preferences_pkey PRIMARY KEY (question_id),
  CONSTRAINT shared_preferences_hushh_id_fkey FOREIGN KEY (hushh_id) REFERENCES public.users(hushh_id),
  CONSTRAINT shared_preferences_card_id_fkey FOREIGN KEY (card_id) REFERENCES public.card_market(id)
);

CREATE TABLE public.shared_assets_receipts (
  type text,
  fileType text,
  fileId text,
  thumbnail text,
  path text,
  createdTime text,
  hushhId text NOT NULL,
  id integer GENERATED ALWAYS AS IDENTITY NOT NULL,
  cardId integer,
  CONSTRAINT shared_assets_receipts_pkey PRIMARY KEY (id),
  CONSTRAINT public_shared_assets_receipts_hushhId_fkey FOREIGN KEY (hushhId) REFERENCES public.users(hushh_id),
  CONSTRAINT public_shared_assets_receipts_cardId_fkey FOREIGN KEY (cardId) REFERENCES public.card_market(id)
);

CREATE TABLE public.info_units (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  text_content text,
  file_url text,
  info_unit_type text NOT NULL CHECK (info_unit_type = ANY (ARRAY['SharedAsset'::text, 'SharedPreference'::text, 'ReceiptRadar'::text, 'Other'::text, 'SharedAudioPreference'::text])),
  inserted_at timestamp with time zone NOT NULL DEFAULT (now() AT TIME ZONE 'utc'::text),
  shared_preference_type text,
  hushh_id text NOT NULL,
  card_id integer,
  question_id integer,
  is_custom_preference boolean DEFAULT false,
  CONSTRAINT info_units_pkey PRIMARY KEY (id),
  CONSTRAINT info_units_card_id_fkey FOREIGN KEY (card_id) REFERENCES public.card_market(id),
  CONSTRAINT info_units_hushh_id_fkey FOREIGN KEY (hushh_id) REFERENCES public.users(hushh_id)
);

CREATE TABLE public.info_units_embeddings (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  info_unit_id bigint,
  embedding USER-DEFINED NOT NULL,
  CONSTRAINT info_units_embeddings_pkey PRIMARY KEY (id),
  CONSTRAINT info_units_embeddings_info_unit_id_fkey FOREIGN KEY (info_unit_id) REFERENCES public.info_units(id)
);

CREATE TABLE public.button_preference (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  question text,
  preference text,
  preferenceSet boolean,
  email text,
  CONSTRAINT button_preference_pkey PRIMARY KEY (id)
);
```

### Payment & Authentication Tables

```sql
CREATE TABLE public.payment_requests (
  id text NOT NULL,
  initiated_uuid text,
  to_uuid text,
  amount_raised double precision,
  amount_payed double precision,
  title text,
  description text,
  status text,
  currency text NOT NULL,
  image text,
  receipt_url text,
  amount_paid_dt timestamp with time zone,
  share_info_after_payment_with_initiated_uuid boolean DEFAULT false,
  shared_card_id integer,
  initiated_brand_id integer,
  CONSTRAINT payment_requests_pkey PRIMARY KEY (id)
);

CREATE TABLE public.registration_tokens (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  token text NOT NULL,
  hushh_id text NOT NULL UNIQUE,
  device USER-DEFINED NOT NULL,
  CONSTRAINT registration_tokens_pkey PRIMARY KEY (id),
  CONSTRAINT registration_tokens_hushh_id_fkey FOREIGN KEY (hushh_id) REFERENCES public.users(hushh_id)
);

CREATE TABLE public.app_extension_qr_login (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  hushh_id text,
  code text NOT NULL,
  CONSTRAINT app_extension_qr_login_pkey PRIMARY KEY (id),
  CONSTRAINT app_extension_qr_login_hushh_id_fkey FOREIGN KEY (hushh_id) REFERENCES public.users(hushh_id)
);
```

### Developer & API Tables

```sql
CREATE TABLE public.dev_api_userprofile (
  mail character varying NOT NULL UNIQUE,
  password character varying NOT NULL,
  api_key character varying,
  firstname character varying,
  lastname character varying,
  mobilenumber character varying,
  companyname character varying,
  website character varying,
  purpose text,
  consent boolean,
  user_id uuid NOT NULL,
  CONSTRAINT dev_api_userprofile_pkey PRIMARY KEY (user_id),
  CONSTRAINT dev_api_userprofile_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id)
);

CREATE TABLE public.dev_user_profile (
  user_id integer NOT NULL DEFAULT nextval('dev_user_profile_user_id_seq'::regclass),
  mail character varying NOT NULL UNIQUE,
  name character varying,
  created_at timestamp without time zone DEFAULT now(),
  updated_at timestamp without time zone DEFAULT now(),
  CONSTRAINT dev_user_profile_pkey PRIMARY KEY (user_id)
);

CREATE TABLE public.dev_user_token (
  id integer NOT NULL DEFAULT nextval('dev_user_token_id_seq'::regclass),
  token text NOT NULL,
  user_id uuid,
  CONSTRAINT dev_user_token_pkey PRIMARY KEY (id)
);
```

### Logging & Monitoring Tables

```sql
CREATE TABLE public.activity_log (
  id integer NOT NULL DEFAULT nextval('activity_log_id_seq'::regclass),
  timestamp timestamp with time zone DEFAULT now(),
  query text,
  user_id text,
  table_name text,
  action text,
  CONSTRAINT activity_log_pkey PRIMARY KEY (id)
);

CREATE TABLE public.app_logs (
  log_id integer NOT NULL DEFAULT nextval('app_logs_log_id_seq'::regclass),
  hushh_id text,
  log_type text NOT NULL CHECK (log_type = ANY (ARRAY['ERROR'::character varying::text, 'EXCEPTION'::character varying::text, 'INFO'::character varying::text, 'DEBUG'::character varying::text, 'WARN'::character varying::text])),
  log_message text NOT NULL,
  log_timestamp timestamp with time zone DEFAULT (now() AT TIME ZONE 'utc'::text),
  additional_info text,
  duration text,
  log_title text,
  CONSTRAINT app_logs_pkey PRIMARY KEY (log_id)
);

CREATE TABLE public.func_logs (
  id integer NOT NULL DEFAULT nextval('func_logs_id_seq'::regclass),
  function_name text NOT NULL,
  log_message text NOT NULL,
  log_timestamp timestamp with time zone DEFAULT now(),
  CONSTRAINT func_logs_pkey PRIMARY KEY (id)
);

CREATE TABLE public.batch_processing_details (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  batch_job_status boolean,
  error text,
  batch_job_id text,
  CONSTRAINT batch_processing_details_pkey PRIMARY KEY (id)
);
```

### Miscellaneous Tables

```sql
CREATE TABLE public.website (
  website_url text NOT NULL,
  website_name character varying,
  website_category character varying,
  CONSTRAINT website_pkey PRIMARY KEY (website_url)
);

CREATE TABLE public.vibe_search_query (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  hushh_id uuid DEFAULT gen_random_uuid(),
  search_history json,
  CONSTRAINT vibe_search_query_pkey PRIMARY KEY (id)
);

CREATE TABLE public.hush_for_students_v01 (
  id character varying NOT NULL,
  first_name character varying NOT NULL,
  last_name character varying,
  phone_number character varying,
  email_address character varying,
  birthday character varying,
  CONSTRAINT hush_for_students_v01_pkey PRIMARY KEY (id)
);

CREATE TABLE public.receipt_radar_fine_tuning_data (
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  message_id text NOT NULL UNIQUE,
  raw_text text NOT NULL,
  CONSTRAINT receipt_radar_fine_tuning_data_pkey PRIMARY KEY (message_id)
);

CREATE TABLE public.priority_emails (
  json_agg json
);

CREATE TABLE public.inventories.187 (
  id text NOT NULL,
  retailer_id text,
  name text,
  description text,
  url text,
  currency text,
  price text,
  is_hidden boolean,
  max_available integer,
  availability text,
  checkmark boolean,
  whatsapp_product_can_appeal boolean,
  videos jsonb,
  is_approved boolean,
  approval_status text,
  images jsonb,
  CONSTRAINT inventories.187_pkey PRIMARY KEY (id)
);
```

## Schema Summary

This comprehensive Supabase database schema includes:

- **Core User Management**: Users, authentication, profiles
- **Agent System**: Agent profiles, services, meetings, products
- **Card Marketplace**: Cards, questions, answers, installations
- **Brand Management**: Brand details, locations, teams, configurations
- **Communication**: Messages, conversations, notifications
- **Data Processing**: Email processing, receipt parsing, document AI
- **App Integration**: App usage tracking, connections, categories
- **Health & Location**: Health data, location tracking, geofencing
- **Payment & Commerce**: Payment requests, consent management
- **Developer Tools**: API access, logging, monitoring

All tables are properly linked with foreign key relationships and include appropriate constraints for data integrity.

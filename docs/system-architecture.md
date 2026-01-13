# System Architecture

High-level technical design and component interactions for Rails LLM.

## Architecture Overview

```
┌─────────────────────────────────────────────────────────┐
│                     Browser / Client                     │
│  (Tailwind CSS, Turbo Navigation, Stimulus JS)          │
└────────────────────┬────────────────────────────────────┘
                     │
                     ↓
         ┌───────────────────────┐
         │   Kamal Container     │
         │   (Docker Image)      │
         └───────────┬───────────┘
                     │
        ┌────────────┴────────────┐
        ↓                         ↓
   ┌─────────────┐        ┌──────────────┐
   │ Puma Server │        │ SolidQueue   │
   │ (Rails 8.1) │        │ Job Processor│
   │ ─────────── │        │              │
   │ - Routes    │        │ (optional,   │
   │ - Auth      │        │  in-process) │
   │ - Templates │        └──────────────┘
   └──────┬──────┘
          │
          ├─────────────────────────────────────┐
          │                                     │
          ↓                                     ↓
    ┌──────────────┐              ┌──────────────────┐
    │  PostgreSQL  │              │  SolidCache      │
    │  Primary DB  │              │  (Database)      │
    │              │              │                  │
    │ - users      │              │ Cache Store      │
    │ - migrations │              │ Session Store    │
    └──────────────┘              └──────────────────┘
          │                              │
          ├─────────────────────────────┘
          │
          ↓
    ┌──────────────┐
    │ PostgreSQL   │
    │ Queue DB     │
    │ (SolidQueue) │
    └──────────────┘
```

## Request Flow

### Chat Message Flow (Real-time Streaming)

```
1. User submits message via chat form
   ↓
2. MessagesController#create receives message
   ↓
3. Message saved to database (role: 'user')
   ↓
4. Turbo Stream broadcasts message to chat subscribers
   ↓
5. LlmResponseJob enqueued for async processing
   ↓
6. Job calls ruby_llm with chat history
   ↓
7. LLM response streamed in chunks
   ↓
8. Each chunk broadcast via Turbo Stream
   ↓
9. Browser updates message container in real-time
   ↓
10. Assistant message persisted to database
```

### ActionCable Real-time Update

```
Client → Chat Form Submit
           ↓
Rails Controller → Message Create
                   ↓
Database → Turbo Stream Broadcast
            ↓
ActionCable → WebSocket → All Subscribed Clients
                          ↓
                      Stimulus Updates DOM
```

### Typical Authentication Request

1. **Browser Request** → `/users/sign_in`
2. **Rack Router** → Maps to `Devise::SessionsController#new`
3. **Controller Action** → Renders template
4. **View Layer** → Renders ERB with Tailwind CSS classes
5. **JavaScript** → Stimulus controllers auto-attach (password toggle)
6. **Response** → HTML sent to browser

### Unauthenticated User Flow

```
GET / (Home)
  → HomeController#index
    → Renders app/views/home/index.html.erb
    → Shows "Sign In" / "Sign Up" links
    → No database queries required
```

### Authentication Flow (Sign In)

```
POST /users/sign_in
  ↓
Devise::SessionsController#create
  ↓
User.find_by(email:) + password verification
  ↓
Success: Create session, redirect to home
Failure: Re-render form with flash[:alert]
  ↓
Response to browser (session cookie in response)
```

### Password Reset Flow

```
1. GET /users/password/new
   → Shows password reset request form

2. POST /users/password (email provided)
   → Devise generates reset_password_token
   → Saves token + timestamp to users table
   → Sends email with reset link

3. User clicks email link
   → GET /users/password/edit?reset_password_token=XXX
   → Validates token (not expired, matches DB)
   → Shows reset form

4. PATCH /users/password
   → Updates password in users table
   → Clears reset_password_token
   → Redirects to sign in
```

### Session Management

```
Browser Session Flow:
  1. User signs in → Rails creates session in SolidCache
  2. Session cookie sent to browser (secure, httponly)
  3. Subsequent requests include session cookie
  4. Rails validates session against SolidCache
  5. User signed out → Session removed from SolidCache

Remember-Me Flow:
  1. User checks "Remember me" on sign in
  2. Devise creates remember_created_at timestamp
  3. Browser receives remember cookie (long-lived, 2 weeks)
  4. Cookie contains secure token linked to user
  5. If session expires, cookie allows auto-login
  6. Signing out invalidates remember cookie
```

## Database Schema

### Chats Table

```sql
CREATE TABLE chats (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  user_id BIGINT NOT NULL REFERENCES users(id),
  model_id BIGINT REFERENCES models(id),
  title VARCHAR(255),
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL,

  INDEX idx_chats_user_id (user_id),
  INDEX idx_chats_model_id (model_id)
);
```

### Messages Table

```sql
CREATE TABLE messages (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  chat_id BIGINT NOT NULL REFERENCES chats(id),
  role INT NOT NULL, -- 0: user, 1: assistant, 2: system
  content TEXT NOT NULL,
  tokens INT, -- Token count for LLM billing
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL,

  INDEX idx_messages_chat_id (chat_id),
  INDEX idx_messages_role (role)
);
```

### Models Table

```sql
CREATE TABLE models (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL UNIQUE, -- gemini-2.0-flash, gpt-4, etc.
  provider VARCHAR(255) NOT NULL, -- gemini, openai
  context_window INT, -- Max tokens
  pricing JSON, -- {input_per_token: 0.00001, output_per_token: 0.00003}
  capabilities JSON, -- {streaming: true, function_calling: true}
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL,

  INDEX idx_models_provider (provider)
);
```

### ToolCalls Table

```sql
CREATE TABLE tool_calls (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  message_id BIGINT NOT NULL REFERENCES messages(id),
  tool_call_id VARCHAR(255), -- LLM tool call ID
  name VARCHAR(255), -- Function name
  arguments JSON, -- Function arguments
  result TEXT, -- Function result
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL,

  INDEX idx_tool_calls_message_id (message_id)
);
```

### Users Table

```sql
CREATE TABLE users (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  email VARCHAR(255) NOT NULL UNIQUE,
  encrypted_password VARCHAR(255) NOT NULL,
  reset_password_token VARCHAR(255) UNIQUE,
  reset_password_sent_at TIMESTAMP,
  remember_created_at TIMESTAMP,
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL,

  INDEX idx_users_email (email),
  INDEX idx_users_reset_password_token (reset_password_token)
);
```

**Column Purposes:**

| Column | Purpose | Devise Module |
|--------|---------|---------------|
| `email` | User identifier, unique | database_authenticatable |
| `encrypted_password` | Bcrypt hash, 12 rounds | database_authenticatable |
| `reset_password_token` | Secure token for password reset | recoverable |
| `reset_password_sent_at` | Timestamp for token expiry (6 hours) | recoverable |
| `remember_created_at` | Timestamp for remember-me cookie | rememberable |
| `created_at`, `updated_at` | Audit timestamps | - |

### SolidCache Tables (Production)

```sql
CREATE TABLE solid_cache_entries (
  id BIGINT PRIMARY KEY,
  key VARCHAR(1024) NOT NULL UNIQUE,
  value LONGBLOB NOT NULL,
  created_at TIMESTAMP,

  INDEX idx_solid_cache_entries_created_at (created_at)
);
```

Used for:
- HTTP session storage
- Fragment cache storage
- General application cache

### SolidQueue Tables (Production)

```sql
CREATE TABLE solid_queue_jobs (
  id BIGINT PRIMARY KEY,
  class_name VARCHAR(255),
  arguments JSON,
  queue_name VARCHAR(255),
  priority INTEGER,
  created_at TIMESTAMP,
  scheduled_at TIMESTAMP,
  locked_by VARCHAR(255),
  locked_at TIMESTAMP,
  failed_at TIMESTAMP,
  error_message TEXT
);

CREATE TABLE solid_queue_executions (
  id BIGINT PRIMARY KEY,
  job_id BIGINT,
  started_at TIMESTAMP,
  finished_at TIMESTAMP,
  error_message TEXT
);
```

Used for:
- Background job queuing
- Job execution tracking
- Failed job retry logic

## Component Architecture

### Frontend Stack

**Tailwind CSS 4.1**
- Utility-first CSS framework
- Responsive design via `sm:`, `md:`, `lg:` breakpoints
- Dark mode support via `dark:` variant
- Compiled to `app/assets/builds/application.css`

**Stimulus 3.2 (JavaScript Controllers)**
- Lightweight JS framework
- Three active controllers:
  - `PasswordToggleController` - Show/hide password fields
  - `FlashController` - Auto-dismiss notifications
  - `HelloController` - Example/unused
- Auto-loaded via manifest (`app/javascript/controllers/index.js`)

**Turbo 8.0 (Hotwire)**
- Drive: Navigate without full page reload
- Frame: Replace page segments
- Stream: Push updates to browser
- Status: Installed but minimal usage (mostly standard form submits)

### Backend Stack

**Rails 8.1.2**
- MVC framework
- Routes: 3 defined + Devise auto-routes
- Controllers: 2 (Home, Devise-managed)
- Models: 2 (User + ApplicationRecord)
- Mailers: Devise-managed email templates

**Devise 4.9**
- Authentication framework
- Modules enabled:
  - `database_authenticatable` - Email/password auth
  - `registerable` - Self-registration
  - `recoverable` - Password reset
  - `rememberable` - Remember-me functionality
  - `validatable` - Email/password validation
- Modules disabled: confirmable, lockable, trackable, omniauthable

**Puma 6.4+**
- Web server
- Thread pool: Dynamic (ENV RAILS_MAX_THREADS, default 5)
- Port: 3000 (development), ENV PORT (production)
- Optional: SolidQueue in-process (SOLID_QUEUE_IN_PUMA=true)

### Infrastructure Stack

**PostgreSQL**
- Primary database: `rails_llm_production`
- Cache database: `rails_llm_production_cache`
- Queue database: `rails_llm_production_queue`
- Cable database: `rails_llm_production_cable`

**SolidCache** (Production Only)
- Database-backed HTTP cache store
- Session storage
- No external Redis required
- Separate database connection pool

**SolidQueue** (Production Only)
- Database-backed job queue
- Optional in-process processing via Puma
- Separate database connection pool
- Failed job tracking and retry

**Solid Cable** (Production Only)
- Database-backed WebSocket backend
- Fallback for production ActionCable
- Separate database connection pool

**Kamal** (Deployment)
- Docker containerization
- Single-server deployment model
- Service name: `rails_llm`
- Registry: localhost:5555 (development only)
- Volumes: Persistent storage for uploads

**Docker**
- Multi-stage build
- Build stage: Compile gems, precompile assets
- Final stage: Non-root user (uid 1000, gid 1000)
- Base image: ruby:3.4.4-slim
- Entry point: `/rails/bin/docker-entrypoint`

## Caching Strategy

### HTTP Cache
- **Store:** SolidCache (database-backed)
- **Type:** Server-side cache
- **TTL:** Configurable per cache entry
- **Production:** Enabled with fragment caching
- **Development:** Memory store (toggle via `rails dev:cache`)

### Session Cache
- **Store:** SolidCache (database-backed)
- **Key Pattern:** `session:#{session_id}`
- **TTL:** Session timeout (no explicit timeout configured)
- **Remember:** 2-week cookie + database timestamp

### Asset Cache
- **Digest Stamping:** SHA256 hash in filename
- **HTTP Headers:** Cache-Control: public, max-age=31536000 (1 year)
- **CDN:** Not configured (static files served by Rails)
- **Compression:** Brotli/Gzip via asset pipeline

## Security Architecture

### Authentication Security

**Password Storage:**
- Algorithm: bcrypt
- Cost factor: 12 (production), 1 (test)
- Salt: Automatic per-password
- No plain-text passwords stored

**Session Security:**
- Storage: SolidCache (database)
- Transport: HTTPS only (production)
- Cookie flags: Secure, HttpOnly
- Regeneration: On sign in

**Token Security:**
- Reset tokens: 32 random characters
- Expiry: 6 hours
- One-time use: Token cleared on password update
- No token reuse

### CSRF Protection

- **Mechanism:** Rails CSRF tokens
- **Implementation:** Meta tags in layout (`csrf-meta-tags`)
- **Validation:** Automatic in POST/PUT/DELETE
- **Token Generation:** Unique per session

### Content Security Policy

- **File:** `config/initializers/content_security_policy.rb`
- **Default:** Script/style/image sources restricted
- **Inline Scripts:** Disabled (nonce required)
- **External Scripts:** Whitelist maintained
- **Reporting:** Optional CSP violation reporting

### Input Validation

- **Parameters:** Automatically filtered (Rails Strong Parameters)
- **Email:** Regex validation `/\A[^@\s]+@[^@\s]+\z/`
- **Password:** Length 6-128 characters
- **Whitespace:** Stripped on email before save

### Logging & Audit Trail

- **Sensitive Parameters:** Automatically filtered (email, password)
- **Logs:** STDOUT output (12-factor compliance)
- **Request IDs:** X-Request-Id header for tracing
- **Health Checks:** `/up` excluded from logs (Kamal health probe)

## Deployment Architecture

### Docker Container

**Multi-Stage Build:**
```
Stage 1: Builder
  - Installs system dependencies
  - Installs Ruby gems
  - Precompiles assets
  - Generates bootsnap cache

Stage 2: Final
  - Copy artifacts from builder
  - Create non-root user (rails:1000)
  - Set working directory
  - Expose port 3000
  - Health check via curl /up
```

**Container Environment:**
- User: `rails` (uid 1000, gid 1000)
- Work dir: `/rails`
- Storage: `/rails/storage` (persistent volume)
- Port: 3000
- Entry: `bin/docker-entrypoint`

### Kamal Deployment

**Configuration:**
- Service: `rails_llm` (Docker image name)
- Servers: Single server (192.168.0.1, development only)
- Registry: localhost:5555 (development only)
- Volumes: `rails_llm_storage:/rails/storage`
- Asset bridging: Between versions (avoid 404s)

**Environment Variables:**
- Required: `RAILS_MASTER_KEY` (secret)
- Optional: `SOLID_QUEUE_IN_PUMA`, `RAILS_MAX_THREADS`, `PORT`, etc.

**Database Initialization:**
```
Kamal deploy
  → Push Docker image to registry
  → Pull image on server
  → Create containers
  → Run migrations on primary DB
  → Run cache_migrate on cache DB
  → Run queue_migrate on queue DB
  → Run cable_migrate on cable DB
  → Start services
```

### Production Readiness Checklist

**Before Production Deploy:**
- [ ] Update Devise mailer sender email
- [ ] Configure SMTP credentials
- [ ] Set RAILS_MASTER_KEY via Kamal secrets
- [ ] Set RAILS_LLM_DATABASE_PASSWORD
- [ ] Update server IP in deploy.yml (current: 192.168.0.1)
- [ ] Update container registry (current: localhost:5555)
- [ ] Configure SSL/TLS (reverse proxy or force_ssl)
- [ ] Test all Devise email flows (sign up, reset password, etc.)
- [ ] Run security audits (brakeman, bundler-audit)
- [ ] Load test with expected traffic

## Performance Considerations

### Database Performance

**Indexes:**
- `email` (unique) - For user lookup
- `reset_password_token` (unique) - For recovery flow
- Consider adding: `users.email_lower` for case-insensitive searches

**Query Optimization:**
- Avoid N+1 queries (typically not applicable with minimal associations)
- Use `.limit()` for pagination if user list grows large

### Caching Performance

**Fragment Cache Keys:**
- Include user id for per-user cache
- Include updated_at timestamp for invalidation
- Avoid cache stampedes with lock wait

**Cache Warming:**
- No pre-warming implemented (optional)
- Could warm user lookup cache on deploy

### Asset Performance

**CSS:** Minified, 1-year cache expiry
**JavaScript:** Import maps (no bundling overhead for Rails code)
**Images:** WebP format with PNG fallbacks (modern browsers only)

## Monitoring & Health Checks

**Health Endpoint:** `GET /up`
- Response: JSON with status
- Used by: Load balancers, monitoring systems
- SLA: <100ms response time
- Logging: Excluded from log output (production)

**Logging:**
- Format: STDOUT (JSON-structured optional)
- Level: INFO (production), DEBUG (development)
- Request IDs: Included for tracing
- Startup time: Should boot in <30 seconds

**Error Tracking:**
- Not configured (optional: Sentry, Honeybadger, etc.)
- Devise email errors: Critical to monitor
- Database connection failures: Check logs

## Unresolved Architecture Questions

1. Should we implement API (REST/GraphQL) authentication layer?
2. Should we add API rate limiting (rack-attack gem)?
3. Should we separate read/write database replicas?
4. Should we implement request tracing (OpenTelemetry)?
5. Should we add health checks for SolidCache/SolidQueue availability?
6. What's the disaster recovery plan for database backups?
7. Should we implement feature flags for gradual rollouts?

---

**Last Updated:** 2026-01-13 | **Rails Version:** 8.1.2

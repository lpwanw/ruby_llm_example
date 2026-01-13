# Deployment Guide

Instructions for deploying Rails LLM to production via Kamal and Docker.

## Pre-Deployment Checklist

### Configuration

- [ ] Update Devise mailer sender in `config/initializers/devise.rb:27`
  - Change: `please-change-me-at-config-initializers-devise@example.com`
  - To: Your application email address (e.g., `noreply@example.com`)

- [ ] Configure SMTP for email delivery
  - Edit `config/environments/production.rb`
  - Uncomment and configure `config.action_mailer.smtp_settings`
  - Set credentials via `bin/rails credentials:edit`
  - Test with: `User.find(1).send_reset_password_instructions`

- [ ] Update server IP in `config/deploy.yml:10`
  - Current: `192.168.0.1` (development only)
  - Replace with: Your production server IP/hostname

- [ ] Update container registry in `config/deploy.yml:30`
  - Current: `localhost:5555` (local development)
  - Options: Docker Hub, GitHub Container Registry, DigitalOcean, AWS ECR, etc.
  - Configure authentication if required

- [ ] Configure Kamal secrets
  - Create `.kamal/secrets` directory (gitignored)
  - Add: `RAILS_MASTER_KEY` (from `config/master.key`)
  - Add: `RAILS_LLM_DATABASE_PASSWORD` (production DB password)

### Security

- [ ] Enable SSL/TLS
  - Option 1: Reverse proxy (nginx/Caddy) with SSL termination
  - Option 2: Rails force_ssl
    - Edit `config/environments/production.rb`
    - Uncomment: `config.assume_ssl = true`
    - Uncomment: `config.force_ssl = true`

- [ ] Configure CSP headers
  - Review: `config/initializers/content_security_policy.rb`
  - Add trusted domains if needed
  - Test in staging first

- [ ] Run security audits
  ```bash
  ./bin/brakeman          # Rails-specific vulnerabilities
  ./bin/bundler-audit     # Gem vulnerabilities
  ```

### Testing

- [ ] Run full test suite
  ```bash
  ./bin/rails test
  ```

- [ ] Test authentication flows manually
  - Sign up flow
  - Sign in flow
  - Password reset flow
  - Profile edit flow
  - Account deletion

- [ ] Test Devise email templates
  - Confirmation email (if confirmable enabled later)
  - Password reset email
  - Email changed notification

## Kamal Setup

### Install Kamal

```bash
gem install kamal
# Or: already in Gemfile

kamal version
```

### Initial Configuration

**File:** `config/deploy.yml` (already created)

Current settings:
```yaml
service: rails_llm
image: rails_llm
registry:
  server: localhost:5555

servers:
  web:
    hosts:
      - 192.168.0.1

env:
  clear:
    SOLID_QUEUE_IN_PUMA: true
```

**Customize:**
```yaml
service: rails_llm                    # Keep as-is
image: rails_llm                      # Docker image name

registry:
  server: docker.io                   # Docker Hub or other
  username: your_registry_user
  password: ENV["REGISTRY_PASSWORD"]

servers:
  web:
    hosts:
      - your.production.server.com    # Update hostname/IP
      - 192.168.1.5
    options:
      add-host: db.internal:10.0.0.5  # If needed

env:
  clear:
    SOLID_QUEUE_IN_PUMA: true
    RAILS_MAX_THREADS: 5
    RAILS_LOG_LEVEL: info
```

### First Deployment

```bash
# Setup production servers (SSH keys, Docker, etc.)
kamal server bootstrap

# Build and push image
kamal build push

# Deploy
kamal deploy

# Verify
kamal logs
kamal ps
```

## Database Setup

### Create Production Databases

SSH to production server:
```bash
psql -U postgres -c "CREATE DATABASE rails_llm_production;"
psql -U postgres -c "CREATE DATABASE rails_llm_production_cache;"
psql -U postgres -c "CREATE DATABASE rails_llm_production_queue;"
psql -U postgres -c "CREATE DATABASE rails_llm_production_cable;"

# Create app user with password
psql -U postgres -c "CREATE USER rails_llm WITH PASSWORD 'your_secure_password';"

# Grant permissions
psql -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE rails_llm_production TO rails_llm;"
psql -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE rails_llm_production_cache TO rails_llm;"
psql -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE rails_llm_production_queue TO rails_llm;"
psql -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE rails_llm_production_cable TO rails_llm;"
```

### Configure Database Connection

**File:** `config/database.yml`

Production section (customize):
```yaml
production:
  <<: *default
  database: rails_llm_production
  username: rails_llm
  password: <%= ENV["RAILS_LLM_DATABASE_PASSWORD"] %>
  host: localhost
  port: 5432
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>

  cache_database: rails_llm_production_cache
  queue_database: rails_llm_production_queue
  cable_database: rails_llm_production_cable
```

### Run Migrations

After first deploy:
```bash
kamal app exec rails db:migrate
kamal app exec rails db:migrate MULTI_DB=true  # All databases
```

Or from local machine:
```bash
# Set production environment
export RAILS_ENV=production
export DATABASE_URL="postgresql://user:pass@host/db"

rails db:migrate
rails db:migrate:status
```

## Environment Variables

### Required (Production)

```bash
# Credentials encryption key (from config/master.key)
RAILS_MASTER_KEY=xxxx...

# Database password
RAILS_LLM_DATABASE_PASSWORD=your_secure_password

# LLM Provider (Required for Chat features)
GEMINI_API_KEY=your_gemini_key     # For Gemini models
# OR
OPENAI_API_KEY=your_openai_key     # For OpenAI-compatible endpoints

# Database URL (alternative to config/database.yml)
# DATABASE_URL=postgresql://rails_llm:password@db.example.com/rails_llm_production
```

### Optional

```bash
# LLM Configuration
LLM_PROVIDER=gemini                # gemini, openai (default: gemini)
LLM_MODEL=gemini-2.0-flash        # Model ID to use

# Server configuration
PORT=3000                           # Puma port
RAILS_MAX_THREADS=5                 # Thread pool size
WEB_CONCURRENCY=2                   # Puma workers (if using cluster mode)
JOB_CONCURRENCY=3                   # SolidQueue concurrency

# Logging
RAILS_LOG_LEVEL=info               # debug, info, warn, error, fatal

# Caching & Jobs
SOLID_QUEUE_IN_PUMA=true           # Run queue in web process
CACHE_REDIS_URL=redis://...        # If using Redis cache

# Email (Devise)
# Add via credentials: bin/rails credentials:edit
MAIL_ADDRESS=smtp.sendgrid.net
MAIL_PORT=587
MAIL_USERNAME=your_username
MAIL_PASSWORD=your_password
```

### Set Variables in Kamal

**File:** `config/deploy.yml`

```yaml
env:
  clear:
    SOLID_QUEUE_IN_PUMA: true
    RAILS_LOG_LEVEL: info

  secret:
    - RAILS_MASTER_KEY
    - RAILS_LLM_DATABASE_PASSWORD
```

Or with `.kamal/secrets` file:
```bash
RAILS_MASTER_KEY=xxxx...
RAILS_LLM_DATABASE_PASSWORD=password123
```

## SSL/TLS Configuration

### Option 1: Reverse Proxy (Recommended)

Use Caddy or Nginx in front of Rails.

**Caddy example:**
```
example.com {
  reverse_proxy localhost:3000
}
```

**Nginx example:**
```nginx
server {
  listen 443 ssl http2;
  server_name example.com;

  ssl_certificate /etc/letsencrypt/live/example.com/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;

  location / {
    proxy_pass http://localhost:3000;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto https;
  }
}
```

### Option 2: Rails Force SSL

**File:** `config/environments/production.rb`

Uncomment:
```ruby
config.assume_ssl = true
config.force_ssl = true
config.ssl_options = {
  hsts: { expires_in: 1.year, preload: true }
}
```

## Monitoring & Logging

### Health Check

Test health endpoint:
```bash
curl https://your.production.server.com/up
# Response: {"status":"ok"}
```

### View Logs

```bash
# Real-time logs
kamal logs

# Last 100 lines
kamal logs -n 100

# Follow specific service
kamal logs -s web
```

### Monitor Processes

```bash
# List running containers
kamal ps

# SSH to server and check Docker
docker ps
docker logs container_id
```

### Performance Monitoring

Consider adding:
- **Sentry** - Error tracking
- **Honeybadger** - Exception monitoring
- **New Relic/Datadog** - APM
- **Prometheus** - Metrics collection
- **ELK Stack** - Centralized logging

## Backup & Recovery

### Database Backups

Regular backups recommended (critical data):
```bash
# Daily backup
pg_dump rails_llm_production > backup_$(date +%Y%m%d).sql

# Backup all databases
pg_dumpall > all_databases_backup.sql

# Restore
psql < all_databases_backup.sql
```

### Configuration Backups

- Backup `.kamal/secrets` (separately from Git)
- Backup `config/master.key` (keep secure)
- Document all environment variables

## Troubleshooting

### Container Won't Start

```bash
# Check container logs
kamal logs

# SSH to server and check manually
docker logs -f container_id

# Verify environment variables are set
kamal app exec env | grep RAILS
```

### Database Connection Failed

```bash
# Verify database is accessible
kamal app exec rails dbconsole

# Check database.yml settings
kamal app exec rails db:info

# Test connection from local machine
psql -h production.server -U rails_llm -d rails_llm_production
```

### Migration Errors

```bash
# Check migration status
kamal app exec rails db:migrate:status

# Rollback last migration
kamal app exec rails db:rollback

# Full reset (⚠️ DESTRUCTIVE, data loss)
kamal app exec rails db:drop db:create db:migrate
```

### Asset Issues

```bash
# Precompile assets
kamal app exec rails assets:precompile

# Clear cached assets
kamal app exec rails assets:clobber
```

### SolidCache Issues

```bash
# Clear cache
kamal app exec rails cache:clear

# Check cache store
kamal app exec rails db:cache:migrate
```

### Memory Issues

Increase thread pool or worker count gradually:
```bash
# In config/deploy.yml
env:
  clear:
    RAILS_MAX_THREADS: 3          # From 5
    WEB_CONCURRENCY: 1            # Add workers
```

## Post-Deployment

### Verify Deployment

- [ ] Health check responds (`/up`)
- [ ] Home page loads
- [ ] Sign up flow works
- [ ] Sign in flow works
- [ ] Password reset email sent/received
- [ ] Profile edit works
- [ ] Account deletion works

### Monitor First 24 Hours

- [ ] Check error logs for exceptions
- [ ] Monitor database query performance
- [ ] Verify email delivery working
- [ ] Check system resource usage
- [ ] Test with real user data load

### Common Issues

| Issue | Cause | Solution |
|-------|-------|----------|
| 500 errors | Missing env vars | Check `.kamal/secrets`, verify RAILS_MASTER_KEY |
| Email not sent | SMTP not configured | Update credentials, test manually |
| Slow page loads | N+1 queries, missing indexes | Run performance profiling, add indexes |
| Session lost | Cache database issue | Check SolidCache database |
| Jobs not processing | Queue database issue | Check SolidQueue database, verify migrations |

## Scaling Considerations

**Current:** Single-server deployment

**To scale horizontally:**
- [ ] Use Kamal with multiple web servers
- [ ] Move database to separate RDS instance
- [ ] Use external Redis (instead of SolidCache)
- [ ] Configure load balancer (HAProxy, AWS ALB)
- [ ] Set up session sharing (currently uses database)
- [ ] Monitor with centralized logging

## Unresolved Questions

1. What's the backup retention policy?
2. Should we implement automated database backups?
3. What's the target uptime SLA?
4. Should we implement canary deployments?
5. How do we handle zero-downtime migrations?
6. What's the disaster recovery RTO/RPO?
7. Should we implement database read replicas for scale?

---

**Last Updated:** 2026-01-13 | **Kamal Version:** 1.9+

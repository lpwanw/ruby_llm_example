# Codebase Summary

Quick reference guide to Rails LLM project structure and key files.

## Directory Structure

```
rails_llm/
├── app/
│   ├── controllers/          # Request handlers (2 files)
│   ├── models/              # Data models (2 files)
│   ├── views/               # UI templates (22 files)
│   ├── javascript/          # JS/Stimulus code (6 files)
│   ├── helpers/             # View helpers (2 files, mostly empty)
│   ├── assets/              # Static assets (CSS, images)
│   ├── jobs/                # Background jobs (empty)
│   └── mailers/             # Email templates (basic)
├── config/
│   ├── environments/        # Per-environment settings (dev/test/prod)
│   ├── initializers/        # Rails initializers (6 files)
│   ├── locales/             # i18n translations
│   ├── routes.rb            # URL routing
│   ├── database.yml         # Database configuration
│   ├── puma.rb              # Web server config
│   ├── cable.yml            # Action Cable config
│   └── deploy.yml           # Kamal deployment config
├── db/
│   ├── migrate/             # Database migrations
│   ├── schema.rb             # Current schema snapshot
│   └── cache_migrate/       # SolidCache migrations
├── test/
│   ├── controllers/         # Controller specs
│   ├── models/              # Model specs
│   ├── integration/         # Integration tests
│   ├── fixtures/            # Test data
│   └── helpers/             # Helper specs
├── docs/
│   ├── project-overview-pdr.md
│   ├── codebase-summary.md  # (this file)
│   ├── code-standards.md
│   ├── system-architecture.md
│   ├── deployment-guide.md
│   ├── design-guidelines.md
│   └── project-roadmap.md
├── .kamal/                  # Kamal deployment secrets
├── bin/                     # Executable scripts
├── Gemfile                  # Ruby dependencies
├── package.json             # Node/Bun dependencies
├── Dockerfile               # Container definition
├── Procfile.dev             # Development process management
├── CLAUDE.md                # Claude AI instructions
├── AGENTS.md                # Agent coordination docs
└── README.md                # Project overview
```

## Key Files Reference

### Application Core

| File | Purpose | Lines | Type |
|------|---------|-------|------|
| `app/controllers/home_controller.rb` | Root page handler | 5 | Controller |
| `app/models/user.rb` | User entity with Devise | 8 | Model |
| `app/views/layouts/application.html.erb` | Main layout wrapper | 30 | View |
| `app/views/home/index.html.erb` | Landing page | 20 | View |

### Authentication (Devise)

| Path | Purpose | Files |
|------|---------|-------|
| `app/views/devise/sessions/` | Sign in form | 1 |
| `app/views/devise/registrations/` | Sign up & profile edit | 2 |
| `app/views/devise/passwords/` | Password reset flow | 2 |
| `app/views/devise/mailer/` | Email templates | 5 |
| `app/views/devise/shared/` | Reusable components | 3 |

### Configuration Files

| File | Purpose |
|------|---------|
| `config/routes.rb` | URL routing rules |
| `config/database.yml` | Database connection settings |
| `config/puma.rb` | Web server thread/worker config |
| `config/initializers/devise.rb` | Devise authentication setup |
| `config/deploy.yml` | Kamal deployment configuration |
| `config/environments/production.rb` | Production-specific settings |

### Frontend Assets

| Path | Purpose |
|------|---------|
| `app/assets/stylesheets/application.tailwind.css` | Tailwind CSS entry point |
| `app/assets/builds/application.css` | Compiled CSS (generated) |
| `app/javascript/application.js` | JS entry point |
| `app/javascript/controllers/password_toggle_controller.js` | Password visibility toggle |
| `app/javascript/controllers/flash_controller.js` | Toast notification auto-dismiss |

### Database

| File | Purpose |
|------|---------|
| `db/schema.rb` | Current database schema snapshot |
| `db/migrate/*_devise_create_users.rb` | Initial Devise user table |
| `db/cache_migrate/` | SolidCache table migrations |
| `db/queue_migrate/` | SolidQueue table migrations |

### Testing

| Path | Purpose | Files |
|------|---------|-------|
| `test/controllers/` | Controller tests | - |
| `test/models/` | Model unit tests | - |
| `test/fixtures/` | Test data | - |
| `test/integration/` | Full-flow integration tests | - |

## Code Statistics

| Metric | Count |
|--------|-------|
| Controllers | 2 |
| Models | 2 |
| View Templates | 22 |
| Stimulus Controllers | 3 |
| Database Tables (dev) | 2 (users + schema_migrations) |
| Routes | 3 + Devise auto-routes |
| Gems | 42+ |
| NPM Packages | 4 |
| Initializers | 6 |
| Migration Files | 1 |

## Navigation Guide

### For Authentication Development
1. Start: `app/models/user.rb` - Devise modules
2. Routes: `config/routes.rb` - devise_for :users
3. Views: `app/views/devise/` - All auth UI
4. Config: `config/initializers/devise.rb` - Settings

### For UI/Styling
1. Layout: `app/views/layouts/application.html.erb`
2. CSS: `app/assets/stylesheets/application.tailwind.css`
3. Components: `app/views/shared/`, `app/views/devise/shared/`
4. JS: `app/javascript/controllers/`

### For Deployment
1. Docker: `Dockerfile` - Container definition
2. Kamal: `config/deploy.yml` - Deployment config
3. Database: `config/database.yml` - DB connections
4. Puma: `config/puma.rb` - Web server settings

### For Development Setup
1. Install: `Gemfile`, `package.json`
2. Database: `config/database.yml` + `db/schema.rb`
3. Start: `bin/dev` (uses Procfile.dev)
4. Test: `test/` directory

## File Size Analysis

| Directory | Est. Size | Purpose |
|-----------|-----------|---------|
| `app/views/` | 3.5 KB | HTML templates (mostly Devise views) |
| `app/controllers/` | 0.5 KB | Minimal logic, mostly Devise routing |
| `config/` | 4 KB | Configuration files |
| `db/` | 2 KB | Migrations and schema |
| `app/javascript/` | 1.5 KB | Stimulus controllers |
| `app/assets/` | 1 KB | CSS and static assets |

## Integration Points

### Devise Integration
- **Routes:** Autogenerated by `devise_for :users`
- **Database:** Users table with encrypted_password, reset token columns
- **Views:** Customized Devise views in `app/views/devise/`
- **Mailers:** Email templates in `app/views/devise/mailer/`
- **Config:** `config/initializers/devise.rb`

### Hotwire Integration (Turbo + Stimulus)
- **Turbo:** Installed via `turbo-rails` gem, auto-loaded in layout
- **Stimulus:** Manifest in `app/javascript/controllers/index.js`
- **Controllers:** 3 functional controllers (password_toggle, flash, hello)
- **Data Attributes:** Used for Stimulus targeting/actions

### Tailwind CSS Integration
- **Build:** `bun run build:css` compiles to `app/assets/builds/application.css`
- **Config:** Tailwind configured in `app/assets/stylesheets/application.tailwind.css`
- **Watch:** `css` process in Procfile.dev for development

### Database Integration
- **Primary:** `rails_llm_development` / `_production`
- **Cache:** `rails_llm_production_cache` (SolidCache)
- **Queue:** `rails_llm_production_queue` (SolidQueue)
- **Cable:** `rails_llm_production_cable` (Solid Cable)

## Common Commands Reference

```bash
# Development
./bin/setup                     # Initial project setup
./bin/dev                       # Start dev server + watchers
./bin/rails console            # Rails REPL
./bin/rails db:migrate         # Run migrations

# Testing
./bin/rails test               # Run all tests
./bin/rails test test/models/user_test.rb

# Code Quality
./bin/rubocop                  # Lint code
./bin/brakeman                 # Security audit
./bin/bundler-audit            # Dependency check

# Deployment
./bin/kamal deploy             # Deploy via Kamal
./bin/kamal console            # Remote Rails console
./bin/kamal logs              # Tail remote logs

# Database
./bin/rails db:create         # Create databases
./bin/rails db:schema:load    # Load schema
./bin/rails db:seed           # Seed data (if defined)
```

## Important Notes

### No External Dependencies (Production)
- No Redis required (uses SolidCache/SolidQueue)
- No separate job processing server (uses SolidQueue in Puma)
- No external storage (uses local Rails storage)

### Devise Modules Enabled
- `:database_authenticatable` - Email/password login
- `:registerable` - User self-registration
- `:recoverable` - Password reset
- `:rememberable` - Remember-me cookie
- `:validatable` - Email/password validation

### Modules NOT Enabled
- `:confirmable` - No email confirmation required
- `:lockable` - No account lockout
- `:trackable` - No login tracking
- `:timeoutable` - Sessions don't auto-expire
- `:omniauthable` - No OAuth/social login

### Asset Pipeline
- Uses Propshaft (modern Rails 8+ default)
- Import maps for JS (no bundler needed for Rails code)
- Bun for CSS/JS asset bundling
- Digest-stamped for cache busting (1-year cache expiry in prod)

## Next Steps for Development

1. **Read:** `./docs/system-architecture.md` for technical design
2. **Read:** `./docs/code-standards.md` for conventions
3. **Read:** `./docs/deployment-guide.md` for production setup
4. **Start:** Modify controllers/views or add new features
5. **Test:** Run `./bin/rails test` before committing

---

**Last Updated:** 2026-01-13 | **Scope:** Rails 8.1.2, Devise 4.9, PostgreSQL

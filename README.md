# Rails LLM

Modern Rails 8.1 authentication application with Devise, PostgreSQL, and a Hotwire stack (Turbo + Stimulus). Production-ready with database-backed caching/queuing and containerized deployment via Kamal.

## Quick Start

### System Requirements
- **Ruby:** 3.4.4
- **PostgreSQL:** 12+
- **Node/Bun:** Latest LTS (for CSS/JS bundling)

### Setup
```bash
./bin/setup              # Install dependencies & setup database
./bin/dev               # Start development server (web, js, css watchers)
```

### Core Commands
```bash
./bin/rails db:migrate  # Run database migrations
./bin/rails test        # Run test suite
./bin/rubocop          # Lint code
./bin/brakeman         # Security audit
./bin/bundler-audit    # Dependency audit
```

## Project Structure

- **`./app`** - Rails application code (controllers, models, views, JS)
- **`./config`** - Configuration files and initializers
- **`./db`** - Database migrations and schema
- **`./test`** - Test suite (models, controllers, integration)
- **`./docs`** - Project documentation

## Key Features

- **Authentication** - Devise-powered sign up, sign in, password reset
- **User Profiles** - Edit profile and account management
- **Dark Mode** - Full dark mode support via Tailwind CSS
- **Responsive Design** - Mobile-first Tailwind styling
- **Flash Notifications** - Auto-dismissing toast messages
- **Password Toggle** - Show/hide password fields UX

## Technology Stack

| Component | Version |
|-----------|---------|
| Rails | 8.1.2 |
| Ruby | 3.4.4 |
| PostgreSQL | - |
| Devise | 4.9 |
| Tailwind CSS | 4.1 |
| Stimulus | 3.2 |
| Turbo | 8.0 |

## Documentation

- **[Project Overview & PDR](./docs/project-overview-pdr.md)** - Vision, features, requirements
- **[Code Standards](./docs/code-standards.md)** - Conventions and patterns
- **[System Architecture](./docs/system-architecture.md)** - High-level design
- **[Codebase Summary](./docs/codebase-summary.md)** - Directory structure and file guide
- **[Deployment Guide](./docs/deployment-guide.md)** - Kamal deployment steps
- **[Design Guidelines](./docs/design-guidelines.md)** - UI/styling patterns
- **[Project Roadmap](./docs/project-roadmap.md)** - Status and next features

## Development

### Database
- **Dev:** `rails_llm_development`
- **Test:** `rails_llm_test`
- **Prod:** Multiple databases for cache, queue, cable

### Testing
```bash
rails test                    # Run all tests
rails test:system            # System/integration tests
```

## Deployment

See **[Deployment Guide](./docs/deployment-guide.md)** for:
- Kamal containerized deployment
- Environment variables setup
- SSL/HTTPS configuration
- Database initialization on production

## Security

- CSRF protection enabled
- Content Security Policy configured
- Password stretching (12 rounds)
- Devise security modules enabled
- Static security analysis (Brakeman, Bundler Audit)

## License

TBD

---

**For detailed guides and API documentation, see `./docs` folder.**

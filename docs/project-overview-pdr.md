# Project Overview & Product Development Requirements

## Project Vision

**Rails LLM** is a modern, production-ready Rails 8.1 authentication application designed to serve as a foundation for building user-centric web applications. The project demonstrates contemporary Rails patterns with Hotwire (Turbo + Stimulus), professional UX design, and enterprise-grade deployment infrastructure.

## Project Purpose

Provide a reference implementation and starting point for Rails applications requiring:
- Robust user authentication and management
- Professional user interface with dark mode support
- Production-ready deployment pipeline
- Best practices in Rails 8.1 development
- Security-first approach to authentication

## Target Users

1. **End Users:** Individuals creating accounts, managing profiles, resetting passwords
2. **Developers:** Rails developers learning modern patterns and authentication flows
3. **Organizations:** Teams bootstrapping new Rails projects with authentication

## Core Features

### Authentication (Current - Complete)
- **User Registration** - Email/password account creation with validation
- **Sign In** - Session-based authentication with remember-me option
- **Password Recovery** - Email-based password reset with 6-hour expiry window
- **Profile Management** - Edit profile, change password, delete account
- **Session Management** - Persistent sessions with configurable remember duration

### User Experience (Current - Complete)
- **Responsive Design** - Mobile-first Tailwind CSS styling
- **Dark Mode** - Full dark/light theme support across all pages
- **Flash Notifications** - Auto-dismissing toast messages with visual feedback
- **Form Validation** - Client-side and server-side validation with error display
- **Accessibility** - ARIA labels, semantic HTML, focus management

### Infrastructure (Current - Complete)
- **Database Persistence** - PostgreSQL with Devise-managed user table
- **Caching Layer** - SolidCache (database-backed, no external Redis needed)
- **Job Queue** - SolidQueue for background jobs
- **Containerization** - Docker multi-stage build with non-root user
- **Deployment Automation** - Kamal-based single-server deployment

## Technical Requirements

### Non-Functional Requirements

| Requirement | Implementation |
|------------|-----------------|
| **Performance** | Sub-100ms first contentful paint, database query optimization |
| **Security** | HTTPS enforcement, CSRF tokens, CSP headers, password stretching (12 rounds) |
| **Reliability** | 99.5% uptime target, database-backed queue for job reliability |
| **Scalability** | Horizontal scaling via containerization, connection pooling, SolidCache |
| **Maintainability** | Rails conventions, DRY components, clear separation of concerns |
| **Accessibility** | WCAG 2.1 AA compliance target |
| **Testing** | Minimum 80% code coverage for critical paths |

### Functional Requirements

#### User Account Management
- `REQ-001` Users must create accounts with email and password
- `REQ-002` Password must be 6-128 characters with validation
- `REQ-003` Email addresses must be unique and validated
- `REQ-004` Users can reset password via email token (6-hour expiry)
- `REQ-005` Authenticated users can edit profile and password
- `REQ-006` Account deletion must be irreversible

#### Authentication & Sessions
- `REQ-007` Sessions persist across browser closes (via remember-me option)
- `REQ-008` Session invalidation on sign out must be immediate
- `REQ-009` Concurrent sessions allowed (no session limiting)
- `REQ-010` Failed login attempts do not trigger account lockout (no lockable module)

#### UI/UX
- `REQ-011` All forms must show field-level validation errors
- `REQ-012` Flash messages must auto-dismiss after 5 seconds
- `REQ-013` Dark mode toggle must persist across sessions
- `REQ-014` Mobile viewport must be responsive at 320px minimum width
- `REQ-015` All interactive elements must have visible focus indicators

#### Deployment & Operations
- `REQ-016` Application must deploy via Docker container
- `REQ-017` Health check endpoint (`/up`) must respond within 100ms
- `REQ-018` All logs must output to STDOUT (12-factor app compliance)
- `REQ-019` Configuration via environment variables only (no hardcoded secrets)

## Technical Architecture

### Stack Components

```
Frontend: Tailwind CSS 4.1 + Stimulus 3.2 + Turbo 8.0
Framework: Rails 8.1.2 + Ruby 3.4.4
Database: PostgreSQL 12+ (primary + cache + queue + cable)
Web Server: Puma 6.4+
Deployment: Kamal + Docker
Authentication: Devise 4.9
Caching: SolidCache (database-backed)
Queue: SolidQueue (database-backed)
```

### Data Model

**Users Table**
- `id` - Primary key
- `email` - Unique, case-insensitive
- `encrypted_password` - bcrypt-hashed, 12 rounds
- `reset_password_token` - For password recovery flow
- `reset_password_sent_at` - Token expiry tracking
- `remember_created_at` - For remember-me functionality
- `created_at`, `updated_at` - Timestamps

## Success Metrics

### Development Metrics
- [ ] All endpoints documented
- [ ] 80%+ code test coverage achieved
- [ ] Zero Brakeman security warnings
- [ ] Zero high-severity bundler-audit vulnerabilities
- [ ] Rubocop compliance with omakase style

### User Metrics
- [ ] Sign up process completable in <2 minutes
- [ ] Password reset email delivered in <5 seconds
- [ ] Profile edit page loads in <500ms
- [ ] Zero 500-error user-facing issues in production

### Operations Metrics
- [ ] Application boots in <30 seconds
- [ ] Health check responds in <100ms
- [ ] Database connection pool optimization verified
- [ ] Asset precompilation <5 minutes

## Dependencies & Constraints

### External Dependencies
- PostgreSQL 12+ (must be installed and configured)
- Ruby 3.4.4 (via asdf or rbenv recommended)
- Docker (for local development and production)
- SMTP service (for Devise email sending)

### Known Constraints
- Single-server deployment model (not horizontally scalable without additional work)
- Database-backed queue requires separate database connection pool
- Devise modules: `database_authenticatable, registerable, recoverable, rememberable, validatable` only
- No OAuth/social login currently implemented
- No email confirmation requirement (confirmable disabled)

## Future Roadmap

### Phase 1 (Potential Next)
- [ ] Role-based access control (RBAC) system
- [ ] User invitation system
- [ ] API authentication (JWT tokens)
- [ ] OAuth social login (Google, GitHub)

### Phase 2
- [ ] Background job processing UI
- [ ] User activity audit trail
- [ ] Email notification preferences
- [ ] Two-factor authentication (TOTP/SMS)

### Phase 3
- [ ] Multi-tenant support
- [ ] Custom domain mapping
- [ ] Advanced reporting dashboards
- [ ] Webhook system for integrations

## Version History

| Version | Date | Status | Notes |
|---------|------|--------|-------|
| 1.0.0 | 2026-01-13 | In Progress | Initial authentication system implementation |

## Contact & Support

For questions or issues, refer to:
- **Documentation:** `./docs/` directory
- **Code Scout Reports:** `./plans/reports/` directory
- **Development Rules:** `./.claude/rules/` directory

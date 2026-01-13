# Project Overview & Product Development Requirements

## Project Vision

**Rails LLM** is a production-ready Rails 8.1 LLM chat application showcasing modern web development with real-time streaming, AI integration, and professional UX. Built with Hotwire (ActionCable + Turbo Streams), ruby_llm gem integration, and enterprise-grade deployment infrastructure (Kamal + Docker).

## Project Purpose

Provide a reference implementation demonstrating:
- Robust user authentication and session management
- Real-time chat with LLM response streaming (ActionCable + Turbo Streams)
- LLM provider integration (Gemini, OpenAI-compatible APIs) via ruby_llm gem
- Multi-turn conversation persistence and message threading
- Professional UI with dark mode and responsive design
- Production-ready deployment pipeline with Kamal
- Best practices in Rails 8.1 development with Hotwire patterns
- Security-first approach to authentication and API integration

## Target Users

1. **End Users:** Individuals engaging in real-time chat conversations with LLM assistants
2. **Developers:** Rails developers learning Hotwire, real-time updates, LLM integration patterns
3. **Organizations:** Teams building LLM-powered chat applications with Rails
4. **AI Teams:** Building AI-first web applications with chat interfaces

## Core Features

### Authentication (Current - Complete)
- **User Registration** - Email/password account creation with validation
- **Sign In** - Session-based authentication with remember-me option
- **Password Recovery** - Email-based password reset with 6-hour expiry window
- **Profile Management** - Edit profile, change password, delete account
- **Session Management** - Persistent sessions with configurable remember duration

### Chat & LLM Integration (Current - In Progress)
- **Real-time Chat** - Multi-turn conversations with streaming LLM responses
- **Message Streaming** - ActionCable + Turbo Streams for instant updates
- **LLM Provider Integration** - Gemini API, OpenAI-compatible endpoints via ruby_llm gem
- **Conversation Persistence** - Chat model with title auto-generation and message threading
- **Tool Calls** - LLM function calling with structured arguments and result tracking
- **Model Registry** - Model table tracking available LLM providers, context windows, pricing
- **Sidebar Navigation** - Chat list with real-time updates via Turbo Streams

### User Experience (Current - Complete)
- **Responsive Design** - Mobile-first Tailwind CSS with sidebar navigation
- **Dark Mode** - Full dark/light theme support across all pages
- **Chat UI** - Message bubbles with role-based styling (user/assistant/system)
- **Typing Indicators** - Real-time feedback during LLM response generation
- **Flash Notifications** - Auto-dismissing toast messages with visual feedback
- **Form Validation** - Client-side and server-side validation with error display
- **Accessibility** - ARIA labels, semantic HTML, focus management

### Infrastructure (Current - Complete)
- **Database Persistence** - PostgreSQL with Users, Chats, Messages, Models, ToolCalls tables
- **Caching Layer** - SolidCache (database-backed, no external Redis needed)
- **Job Queue** - SolidQueue for async LLM response processing
- **Real-time Transport** - ActionCable with database-backed Solid Cable
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

**Users Table** (Devise-managed)
- `id` - Primary key
- `email` - Unique, case-insensitive
- `encrypted_password` - bcrypt-hashed, 12 rounds
- `reset_password_token` - For password recovery flow
- `reset_password_sent_at` - Token expiry tracking
- `remember_created_at` - For remember-me functionality
- `created_at`, `updated_at` - Timestamps

**Chats Table** (Conversation containers)
- `id` - Primary key
- `user_id` - Foreign key to Users
- `model_id` - Foreign key to Models (optional, selected LLM)
- `title` - Auto-generated from first message
- `created_at`, `updated_at` - Timestamps

**Messages Table** (acts_as_chat)
- `id` - Primary key
- `chat_id` - Foreign key to Chats
- `role` - Enum: user, assistant, system
- `content` - Message text
- `tokens` - Token count for billing/tracking
- `created_at`, `updated_at` - Timestamps

**Models Table** (LLM provider registry)
- `id` - Primary key
- `name` - Model identifier (gemini-2.0-flash, gpt-4, etc.)
- `provider` - LLM provider (gemini, openai)
- `context_window` - Max tokens
- `pricing` - JSON: {input_per_token, output_per_token}
- `capabilities` - JSON: {streaming, function_calling, etc.}
- `created_at`, `updated_at` - Timestamps

**ToolCalls Table** (Function calls)
- `id` - Primary key
- `message_id` - Foreign key to Messages
- `tool_call_id` - LLM tool call ID
- `name` - Function name
- `arguments` - JSON arguments
- `result` - Function execution result
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
| 2.0.0 | 2026-01-13 | In Progress | Chat/LLM integration (real-time streaming, ruby_llm) |
| 1.0.0 | 2026-01-13 | Complete | Authentication system with Devise |

## Contact & Support

For questions or issues, refer to:
- **Documentation:** `./docs/` directory
- **Code Scout Reports:** `./plans/reports/` directory
- **Development Rules:** `./.claude/rules/` directory

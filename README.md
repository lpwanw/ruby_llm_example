# Rails LLM

Modern Rails 8.1 LLM chat application with real-time streaming, Devise authentication, and Hotwire integration. Features multi-turn conversations powered by ruby_llm gem (Gemini, OpenAI), real-time message streaming via ActionCable + Turbo Streams, and production-ready deployment via Kamal.

## Quick Start

### System Requirements
- **Ruby:** 3.4.4
- **PostgreSQL:** 12+
- **Node/Bun:** Latest LTS (for CSS/JS bundling)
- **LLM API Key:** Gemini API key (or compatible OpenAI endpoint)

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

- **`./app`** - Rails application code (6 models, 4 controllers, 40+ views, 10 JS controllers)
- **`./config`** - Configuration files including ruby_llm LLM provider setup
- **`./db`** - Database migrations with chat, message, model schemas
- **`./test`** - Test suite (models, controllers, integration)
- **`./docs`** - Project documentation

## Key Features

- **Authentication** - Devise-powered sign up, sign in, password reset
- **Real-time Chat** - Multi-turn conversations with streaming LLM responses via ActionCable
- **LLM Integration** - ruby_llm gem supporting Gemini, OpenAI-compatible providers
- **Message History** - Persistent chat conversations with role-based messages (user/assistant/system)
- **Tool Calls** - LLM function calling with structured arguments and results
- **Dark Mode** - Full dark/light theme support via Tailwind CSS
- **Responsive Design** - Mobile-first Tailwind styling with sidebar navigation
- **Real-time Updates** - Turbo Streams for instant message broadcasting
- **Flash Notifications** - Auto-dismissing toast messages
- **Password Toggle** - Show/hide password fields UX

## Technology Stack

| Component | Version |
|-----------|---------|
| Rails | 8.1.2 |
| Ruby | 3.4.4 |
| PostgreSQL | 12+ |
| ruby_llm | Latest (Gemini/OpenAI support) |
| Devise | 4.9 |
| ActionCable | 8.1 |
| Turbo Rails | 8.0 |
| Stimulus | 3.2 |
| Tailwind CSS | 4.1 |
| Solid Queue | Database-backed jobs |
| Solid Cache | Database-backed sessions |

## Documentation

- **[Project Overview & PDR](./docs/project-overview-pdr.md)** - Vision, features, requirements
- **[Code Standards](./docs/code-standards.md)** - Conventions and patterns
- **[System Architecture](./docs/system-architecture.md)** - High-level design
- **[Codebase Summary](./docs/codebase-summary.md)** - Directory structure and file guide
- **[Deployment Guide](./docs/deployment-guide.md)** - Kamal deployment steps
- **[Design Guidelines](./docs/design-guidelines.md)** - UI/styling patterns
- **[Project Roadmap](./docs/project-roadmap.md)** - Status and next features

## Development

### Environment Variables
```bash
# Required for LLM features
GEMINI_API_KEY=your_api_key  # For Gemini models
# OR
OPENAI_API_KEY=your_key     # For OpenAI-compatible endpoints

# Optional
LLM_PROVIDER=gemini         # gemini, openai (default: gemini)
LLM_MODEL=gemini-2.0-flash  # Model ID
```

### Database
- **Dev:** `rails_llm_development`
- **Test:** `rails_llm_test`
- **Prod:** Primary + separate cache, queue, cable databases

### Testing
```bash
rails test                    # Run all tests
rails test:system            # System/integration tests with browser
```

### Chat Development
```bash
# Create new chat conversation
rails console
user = User.first
chat = user.chats.create!

# Send message and trigger LLM response
message = chat.messages.create!(role: 'user', content: 'Hello!')
LlmResponseJob.perform_later(message.id)
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

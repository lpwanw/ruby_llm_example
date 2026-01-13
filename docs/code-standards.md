# Code Standards & Conventions

Development guidelines for Rails LLM codebase.

## General Principles

- **DRY (Don't Repeat Yourself)** - Extract shared logic into helpers, components, or services
- **KISS (Keep It Simple, Stupid)** - Prefer clarity over cleverness
- **YAGNI (You Aren't Gonna Need It)** - Don't implement speculative features
- **Convention over Configuration** - Follow Rails defaults unless strongly justified

## Ruby & Rails Conventions

### File Organization

**Naming:**
- Classes: PascalCase (`app/models/user.rb`, `app/controllers/home_controller.rb`)
- Files: snake_case (`user.rb`, `password_toggle_controller.js`)
- Directories: plural lowercase (`app/controllers/`, `app/models/`)

**Structure:**
```ruby
# app/controllers/home_controller.rb
class HomeController < ApplicationController
  def index
    # Minimal logic, mostly data access
  end
end

# app/models/user.rb
class User < ApplicationRecord
  devise :database_authenticatable, # List modules
         :registerable,
         :recoverable,
         :rememberable,
         :validatable

  # Validations
  validates :email, presence: true, uniqueness: true

  # Associations (none yet)

  # Methods (app-specific logic)
end
```

### Code Style

**Ruby Style Guide Adherence:**
- Use 2-space indentation (no tabs)
- Line length: ~100 characters (hard limit 120)
- Use single quotes unless interpolation needed
- Use double splat `**` for keyword arguments
- Use safe navigation operator `&.` when appropriate

**Methods:**
```ruby
# Good: Clear intent, short
def authenticate_user
  redirect_to new_user_session_path unless user_signed_in?
end

# Bad: Too long, implicit behavior
def make_sure_the_user_is_authenticated_before_proceeding
  unless current_user.present? && current_user.active?
    flash[:alert] = "You must sign in"
    redirect_to new_user_session_path
  end
end
```

**Variables & Constants:**
```ruby
# Good: Descriptive
users_awaiting_confirmation = User.where(confirmed_at: nil)

# Bad: Ambiguous abbreviations
u_await_conf = User.where(confirmed_at: nil)

# Constants: SCREAMING_SNAKE_CASE
MAX_PASSWORD_LENGTH = 128
MIN_PASSWORD_LENGTH = 6
```

### Controllers

**Size:** Keep under 100 lines if possible. Extract complex logic to services.

```ruby
class HomeController < ApplicationController
  # Minimal logic - use Devise helpers
  def index
    # Render default template
    # No instance variables unless needed in view
  end
end
```

**Filters:**
- Use `before_action` for authentication/authorization
- Use `rescue_from` for exception handling
- Specify `:only` or `:except` when appropriate

### Models

**Devise Integration:**
```ruby
class User < ApplicationRecord
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable

  # Validations
  validates :email, presence: true, uniqueness: true, case_sensitive: false
  validates :password, length: { minimum: 6, maximum: 128 }
end
```

**No Additional Devise Modules Currently:**
- `:confirmable` - Not enabled (no email confirmation required)
- `:lockable` - Not enabled (no account lockout)
- `:trackable` - Not enabled (no sign-in tracking)

**Database Columns (Devise-managed):**
- `id` - Primary key
- `email` - Unique user identifier
- `encrypted_password` - Bcrypt-hashed (12 rounds in production, 1 in test)
- `reset_password_token` - For password recovery
- `reset_password_sent_at` - Token expiry tracking
- `remember_created_at` - Remember-me functionality
- `created_at`, `updated_at` - Timestamps

### Views & Templates

**ERB Files:**
```erb
<!-- Layout wrapper -->
<div class="container mx-auto">
  <!-- Semantic HTML -->
  <h1 class="text-2xl font-bold"><%= page_title %></h1>

  <!-- Proper indentation -->
  <%= form_with(model: @user, local: true) do |f| %>
    <%= f.email_field :email, class: "..." %>
  <% end %>
</div>
```

**Tailwind CSS Classes:**
- Use utility-first approach
- Group related utilities: spacing, colors, layout
- Keep class lists readable (break into multiple lines if >80 chars)

```erb
<!-- Good: Clear structure -->
<div class="flex flex-col gap-4 p-4 rounded-lg border border-gray-200 bg-white
            dark:border-gray-800 dark:bg-gray-900">
  <h2 class="text-lg font-semibold text-gray-900 dark:text-white">Profile</h2>
</div>

<!-- Bad: Unreadable class list -->
<div class="flex flex-col gap-4 p-4 rounded-lg border border-gray-200 bg-white dark:border-gray-800 dark:bg-gray-900">
```

**Dark Mode:**
- Use `dark:` variant for all color/background classes
- Test both light and dark modes during development
- Maintain equal contrast in both modes

```erb
<!-- Always include dark variant -->
<button class="bg-indigo-600 text-white hover:bg-indigo-700
               dark:bg-indigo-500 dark:hover:bg-indigo-600">
  Sign In
</button>
```

**Devise Views:**
Located in `app/views/devise/`. All customized with Tailwind CSS.

- `sessions/new.html.erb` - Sign in form
- `registrations/new.html.erb` - Sign up form
- `registrations/edit.html.erb` - Profile edit
- `passwords/new.html.erb` - Password reset request
- `passwords/edit.html.erb` - Password reset form
- `shared/_error_messages.html.erb` - Validation errors
- `shared/_auth_container.html.erb` - Centered card layout
- `shared/_links.html.erb` - Navigation between auth pages

**Forms:**
```erb
<%= form_with(model: @user, local: true) do |f| %>
  <!-- Error display (DRY component) -->
  <%= render 'devise/shared/error_messages', object: @user %>

  <!-- Email field -->
  <%= f.email_field :email,
                   placeholder: 'Email',
                   class: 'w-full px-4 py-2 border rounded-lg...' %>

  <!-- Password field with toggle -->
  <div class="relative">
    <%= f.password_field :password, class: 'w-full...' %>
  </div>
<% end %>
```

### Stimulus Controllers

**File Naming:** `{name}_controller.js` (kebab-case)

**Structure:**
```javascript
// app/javascript/controllers/password_toggle_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "iconShow", "iconHide"]
  static values = { }

  connect() {
    // Called when controller attaches to DOM
  }

  toggle() {
    const isPassword = this.inputTarget.type === "password"
    this.inputTarget.type = isPassword ? "text" : "password"
    // Toggle icon visibility
  }

  disconnect() {
    // Cleanup if needed
  }
}
```

**Usage in Views:**
```erb
<div data-controller="password-toggle">
  <%= f.password_field :password,
                      data: { "password_toggle-target": "input" },
                      class: "..." %>
  <button type="button" data-action="password-toggle#toggle">
    Show/Hide
  </button>
</div>
```

**Current Controllers:**
1. `password_toggle_controller.js` - Show/hide password fields
2. `flash_controller.js` - Auto-dismiss notifications (5000ms default)
3. `hello_controller.js` - Example (unused, remove if not needed)

### Flash Notifications

**Flash Types & Styling:**
- `notice` / `success` - Green (bg-green-100, text-green-700)
- `alert` / `error` - Red (bg-red-100, text-red-700)
- `warning` - Amber (bg-amber-100, text-amber-700)
- `info` / `default` - Blue (bg-blue-100, text-blue-700)

**Usage in Controllers:**
```ruby
redirect_to home_path, notice: 'Account created successfully'
redirect_to home_path, alert: 'Email already exists'
```

**Display Component:**
Located in `app/views/shared/_flash.html.erb`. Uses Stimulus controller for auto-dismiss.

## Testing Standards

### Test Structure

**Location:** `test/` directory

```
test/
├── models/              # Model unit tests
├── controllers/         # Controller tests
├── integration/         # Full-flow tests
├── fixtures/           # Test data
└── helpers/            # Helper tests
```

### Test Naming

```ruby
# test/models/user_test.rb
class UserTest < ActiveSupport::TestCase
  # Fixtures available: users(:one), users(:two)

  test 'validates presence of email' do
    user = User.new(email: '', password: 'password')
    assert_not user.valid?
    assert user.errors[:email].any?
  end
end
```

### Coverage Goals

- Model logic: 100% coverage
- Controller filters: 100% coverage
- Happy-path flows: 95% coverage
- Error scenarios: 80% minimum
- View rendering: 70% coverage (less critical)

### Fixtures

Test data in `test/fixtures/users.yml`:

```yaml
one:
  email: user1@example.com
  encrypted_password: <%= BCrypt::Password.create('password') %>

two:
  email: user2@example.com
  encrypted_password: <%= BCrypt::Password.create('password') %>
```

## Security Standards

### Authentication
- Devise handles password hashing (bcrypt, 12 rounds production)
- Reset token expiry: 6 hours
- Remember-me cookie: 2 weeks default
- Session invalidation: Immediate on sign out

### CSRF Protection
- Rails automatic CSRF tokens (meta tags in layout)
- All form submits protected automatically
- AJAX requests use `X-CSRF-Token` header

### Content Security Policy (CSP)
- Configured in `config/initializers/content_security_policy.rb`
- Default policies: script-src, style-src, img-src, font-src

### Password Field Security
- Use `f.password_field` (renders type="password")
- Auto-hide in browser history
- Password toggle shows as text (client-side only)

### Sensitive Data
- Filter parameters: email, password, password_confirmation
- Do not log passwords or tokens
- Strip whitespace from email before saving (Devise default)

### Environment Variables
- Production secrets stored in `ENV['RAILS_MASTER_KEY']`
- Database password: `ENV['RAILS_LLM_DATABASE_PASSWORD']`
- SMTP credentials: `ENV['MAIL_USERNAME']`, `ENV['MAIL_PASSWORD']`
- No hardcoded secrets in code or config files

## Performance Standards

### Database
- Use database indexes on frequently queried columns
- Eager load associations with `includes(:association)`
- Avoid N+1 queries in controllers/views
- Profile queries with `rails db:slow_queries`

### Caching
- Fragment caching for expensive views: `<% cache ... %>`
- Cache store: SolidCache in production (database-backed)
- Cache key should include version/dependencies
- Invalidate cache on data changes

### Assets
- Minify CSS/JS in production (automatic via asset pipeline)
- Lazy-load non-critical images
- Use WebP format with fallbacks (modern browser only)

## Accessibility Standards

### HTML Semantics
- Use proper heading hierarchy (h1, h2, h3)
- Use semantic tags: `<button>`, `<nav>`, `<main>`, `<section>`
- Avoid empty links or buttons

### ARIA Attributes
```erb
<!-- Error message ARIA -->
<div role="alert" aria-live="polite" class="...">
  <%= f.error_messages.first %>
</div>

<!-- Icon buttons need text -->
<button type="button" aria-label="Show password">
  <%= icon('eye') %>
</button>
```

### Form Accessibility
- Label all inputs: `<label for="email">Email</label>`
- Use `form_with` helpers (auto-generate proper attributes)
- Focus indicators: `:focus-ring` classes
- Error messages linked to inputs: `aria-describedby="error-id"`

### Dark Mode
- Maintain sufficient color contrast in both modes
- Use Tailwind `dark:` variant consistently
- Test with: Chrome DevTools > Rendering > Emulate CSS media feature

## Code Quality Tools

### Rubocop
- **Style:** rubocop-rails-omakase
- **Run:** `./bin/rubocop`
- **Config:** `.rubocop.yml`
- **Violations:** Fix before committing

### Brakeman
- **Security scanner** for Rails-specific vulnerabilities
- **Run:** `./bin/brakeman`
- **Config:** `config/brakeman.json`
- **Fix:** All high-severity warnings before production

### Bundler Audit
- **Dependency vulnerability scanner**
- **Run:** `./bin/bundler-audit`
- **Whitelist:** `config/bundler-audit.yml` (as last resort)
- **Update gems:** `bundle update gem-name` when vulnerabilities found

## Git & Commits

### Commit Message Format

```
[type]: Brief description (50 chars max)

Optional longer explanation (72 chars per line).
Explain why, not what.

Type: feat, fix, refactor, test, docs, style, security, perf
```

**Examples:**
```
feat: Add password visibility toggle to auth forms
fix: Correct flash notification auto-dismiss timing
docs: Update deployment guide with SSL instructions
test: Add user validation specs
security: Update Devise password stretching to 12 rounds
```

### Branch Naming

- Feature: `feature/user-profile-management`
- Fix: `fix/password-reset-email`
- Docs: `docs/deployment-guide`

### Pre-commit Checks

Before committing:
```bash
./bin/rubocop              # Lint
./bin/brakeman -q         # Security
./bin/bundler-audit       # Dependencies
rails test                # Tests
```

## Documentation Standards

### Code Comments

Keep comments minimal. Code should be self-documenting.

```ruby
# Good: Explains WHY, not WHAT
# Devise reset token expires after 6 hours; using shorter window for security
config.reset_password_within = 6.hours

# Bad: Explains WHAT (code is obvious)
# Set reset_password_within to 6 hours
config.reset_password_within = 6.hours
```

### API Documentation

Use inline documentation for public methods:

```ruby
# Devise authentication configuration
# Configures password strength, reset token window, and session behavior
module Devise
  # ... configuration
end
```

### Changelog

Update `./docs/project-changelog.md` with significant changes:
- New features
- Bug fixes
- Security patches
- Breaking changes

## Unresolved Questions

1. Should we create custom form builders to reduce Tailwind class duplication?
2. Should we extract view components from ERB partials for better reusability?
3. What's the target test coverage percentage?
4. Should we implement i18n for all user-facing strings?
5. Are there specific accessibility standards beyond WCAG 2.1 AA we should target?

---

**Last Updated:** 2026-01-13 | **Version:** 1.0.0

# Project Roadmap

Status, features, and next phases for Rails LLM development.

## Current Status

**Version:** 2.0.0 (In Progress)
**Date:** 2026-01-13
**Overall Progress:** 65% Complete

### Phase 1: Authentication Foundation (Complete - 100%)

**Status:** Core authentication system implemented and tested.

| Feature | Status | % Done | Notes |
|---------|--------|--------|-------|
| User registration | Complete | 100% | Email/password sign up |
| User sign in | Complete | 100% | Session-based, remember-me |
| Password reset | Complete | 100% | Email token, 6-hour expiry |
| Profile editing | Complete | 100% | Change password, edit profile |
| Account deletion | Complete | 100% | Irreversible deletion |
| Email notifications | Complete | 100% | Devise templates configured |
| Dark mode UI | Complete | 100% | Full light/dark theme |
| Mobile responsive | Complete | 100% | Mobile-first Tailwind design |
| Flash notifications | Complete | 100% | Auto-dismissing toasts |
| Accessibility | Complete | 100% | WCAG 2.1 AA target |
| Documentation | In Progress | 90% | All docs created |
| Tests | Pending | 0% | Unit & integration tests needed |
| Deployment setup | Complete | 100% | Kamal/Docker configured |

**Dependencies Met:**
- ✓ Rails 8.1.2 setup
- ✓ PostgreSQL database configured
- ✓ Devise 4.9 installed
- ✓ Tailwind CSS 4.1 integrated
- ✓ Stimulus 3.2 controllers
- ✓ Docker containerization

**Known Issues:**
- None identified

**Blockers:**
- Tests not yet written (lower priority for MVP)

---

## Completed Features

✓ User authentication system (email/password)
✓ Account management (edit, delete)
✓ Password reset workflow
✓ Session management with remember-me
✓ Professional UI with dark mode
✓ Flash message notifications
✓ Password visibility toggle
✓ Responsive mobile design
✓ Docker containerization
✓ Kamal deployment setup
✓ Database schema (users table)
✓ Devise configuration
✓ CSS bundling (Tailwind)
✓ JavaScript controllers (Stimulus)

---

## Next Phases

### Phase 2: Chat & LLM Integration (Current - In Progress - 60%)

**Status:** Core chat, message streaming, and LLM integration implemented.

| Feature | Status | % Done | Notes |
|---------|--------|--------|-------|
| Chat model & conversations | Complete | 100% | Multi-turn message threading via acts_as_chat |
| Real-time message streaming | Complete | 100% | ActionCable + Turbo Streams for instant updates |
| LLM provider integration | Complete | 100% | ruby_llm gem with Gemini/OpenAI support |
| Message persistence | Complete | 100% | Role-based messages (user/assistant/system) |
| Tool calls (function calling) | Complete | 100% | LLM tool call tracking with results |
| Model registry | Complete | 100% | Track LLM providers, pricing, capabilities |
| Sidebar navigation | Complete | 100% | Real-time chat list with title auto-generation |
| Async response processing | Complete | 100% | LlmResponseJob for background LLM calls |
| UI Chat Components | In Progress | 80% | Message bubbles, typing indicator, input form |
| Keyboard shortcuts | Complete | 100% | Cmd/Ctrl+K for new chat |
| Error handling | In Progress | 70% | LLM API error handling, timeout management |
| Tests | Pending | 0% | Unit & integration tests for Chat features |

**Blockers:** None

**Next Steps:** Complete UI testing, error handling, documentation

**Time Estimate:** 1-2 weeks to completion

---

### Phase 3: Testing & Quality Assurance (Next - Estimated 3-5 days)

**Goal:** Achieve 80%+ code coverage, all tests passing, zero security warnings.

**Tasks:**
- [ ] Write unit tests for User model
  - Email validation
  - Password validation
  - Devise module behavior
  - Uniqueness constraints

- [ ] Write controller tests
  - Home controller (public access)
  - Devise routing
  - Flash message handling

- [ ] Write integration tests
  - Full sign up flow
  - Full sign in flow
  - Password reset flow (email simulation)
  - Profile editing
  - Account deletion

- [ ] System tests (Capybara)
  - User journey for sign up
  - Browser-based password reset
  - Dark mode toggle (if implemented)

- [ ] Security audits
  - Brakeman scan (zero warnings)
  - Bundler audit (patch vulnerabilities)
  - Rubocop linting (omakase style)

- [ ] Performance testing
  - Database query optimization
  - Asset loading performance
  - Health check response time (<100ms)

**Success Criteria:**
- 80%+ code coverage
- All tests passing (CI green)
- Zero Brakeman high/medium severity
- Zero Rubocop violations
- Health check <100ms

**Time Estimate:** 3-5 days
**Priority:** High (blocks production)

---

### Phase 4: Production Deployment (Estimated 2-3 days)

**Goal:** Deploy to production with monitoring and backups.

**Tasks:**
- [ ] Configure production environment
  - Update server IP in deploy.yml
  - Select container registry
  - Configure SMTP for email

- [ ] SSL/TLS setup
  - Reverse proxy (Caddy/Nginx)
  - Or: Force SSL via Rails config

- [ ] Database setup
  - Create production databases
  - Configure connection pooling
  - Backup strategy

- [ ] Kamal deployment
  - Build and push Docker image
  - First deploy
  - Verify health checks

- [ ] Monitoring setup
  - Log aggregation (optional: Sentry, Datadog)
  - Error tracking
  - Performance monitoring

- [ ] Documentation
  - Update deployment guide with real server details
  - Create runbook for common operations
  - Document backup procedures

**Success Criteria:**
- Application running on production server
- Health checks passing
- Email notifications working
- Database backups configured
- Monitoring/logging active

**Time Estimate:** 2-3 days
**Priority:** High
**Blockers:** Phase 2 completion

---

### Phase 5: User Experience Enhancements (Estimated 1-2 weeks)

**Goal:** Improve user experience and add quality-of-life features.

**Potential Features:**

#### 4.1: Email Confirmation
- [ ] Enable `:confirmable` Devise module
- [ ] Update migration to add confirmation columns
- [ ] Modify sign up flow to require confirmation
- [ ] Add resend confirmation email feature
- Estimated: 2-3 days

#### 4.2: Account Lockout
- [ ] Enable `:lockable` Devise module
- [ ] Lock accounts after N failed attempts
- [ ] Unlock via email or time-based
- [ ] Add user feedback for locked accounts
- Estimated: 2-3 days

#### 4.3: Light/Dark Mode Toggle
- [ ] Add theme switcher in UI
- [ ] Persist preference in user profile or cookies
- [ ] Add system preference detection
- Estimated: 1-2 days

#### 4.4: Two-Factor Authentication (2FA)
- [ ] Add TOTP support (Google Authenticator, Authy)
- [ ] Optional SMS-based 2FA
- [ ] Backup codes for recovery
- Estimated: 3-5 days

#### 4.5: User Profile Enhancement
- [ ] Add name, avatar fields
- [ ] Add phone number (optional)
- [ ] Add account preferences/settings
- [ ] Profile visibility toggle
- Estimated: 2-3 days

**Priority:** Medium
**Timeline:** 1-2 weeks (parallel with other work)

---

### Phase 6: API & Integration (Estimated 2-3 weeks)

**Goal:** Expose API for external integrations.

**Potential Features:**

#### 5.1: REST API
- [ ] Create API namespace (v1)
- [ ] Implement JWT authentication
- [ ] User endpoints (CRUD)
- [ ] Authentication endpoints
- Estimated: 5-7 days

#### 5.2: OAuth/Social Login
- [ ] Google OAuth integration
- [ ] GitHub OAuth integration
- [ ] Optional: Facebook, Apple
- Estimated: 3-5 days

#### 5.3: Webhooks
- [ ] User signup event webhook
- [ ] Password reset webhook
- [ ] Account deletion webhook
- Estimated: 2-3 days

#### 5.4: API Documentation
- [ ] OpenAPI/Swagger spec
- [ ] API client SDK (optional)
- Estimated: 1-2 days

**Priority:** Medium-Low
**Timeline:** 2-3 weeks (after Phase 4)

---

### Phase 7: Admin & Monitoring (Estimated 1-2 weeks)

**Goal:** Add admin dashboard and operational tools.

**Potential Features:**

#### 6.1: Admin Panel
- [ ] User management (view, edit, delete)
- [ ] User statistics/analytics
- [ ] Email logs
- [ ] System health dashboard
- Estimated: 3-5 days

#### 6.2: Audit Trail
- [ ] Log all user actions
- [ ] Account activity history
- [ ] Login attempt tracking
- Estimated: 2-3 days

#### 6.3: Advanced Monitoring
- [ ] Database performance metrics
- [ ] Queue job monitoring
- [ ] Cache hit/miss rates
- [ ] Resource utilization
- Estimated: 2-3 days

**Priority:** Low-Medium
**Timeline:** 1-2 weeks (Phase 4-5 completion)

---

### Phase 8: Infrastructure & Scale (Estimated 1-2 weeks)

**Goal:** Prepare for horizontal scaling and high availability.

**Potential Features:**

#### 7.1: Load Balancing
- [ ] Multi-server Kamal deployment
- [ ] Load balancer setup (HAProxy/AWS ALB)
- [ ] Session sharing (Redis or stick sessions)
- Estimated: 2-3 days

#### 7.2: Database Optimization
- [ ] Read replicas for scaling
- [ ] Connection pooling tuning
- [ ] Query optimization
- Estimated: 2-3 days

#### 7.3: Cache Strategy
- [ ] Redis caching layer
- [ ] Cache invalidation strategy
- [ ] Performance benchmarking
- Estimated: 2-3 days

#### 7.4: Disaster Recovery
- [ ] Automated backups
- [ ] Point-in-time recovery testing
- [ ] Failover procedures
- [ ] RTO/RPO SLAs
- Estimated: 2-3 days

**Priority:** Low
**Timeline:** 1-2 weeks (when needed for scale)

---

## Technical Debt & Maintenance

### Known Items

| Item | Priority | Effort | Status |
|------|----------|--------|--------|
| Add test suite | High | 3-5d | Todo |
| Extract view components | Low | 2-3d | Backlog |
| Create form builder | Low | 1-2d | Backlog |
| Remove unused hello_controller | Low | 0.5d | Todo |
| Document API contracts | Medium | 1-2d | Todo |
| Add EditorConfig | Low | 0.5d | Backlog |
| Add pre-commit hooks | Low | 1d | Backlog |
| Create CI/CD pipeline | Medium | 2-3d | Todo |
| Add SVG icon system | Low | 2-3d | Backlog |

### Maintenance Tasks (Recurring)

- [ ] Weekly: Patch security vulnerabilities (bundler-audit)
- [ ] Monthly: Update dependencies (Dependabot)
- [ ] Monthly: Review and update documentation
- [ ] Quarterly: Performance analysis and optimization
- [ ] Quarterly: Security audit (Brakeman)

---

## Dependencies & Blockers

### Required Before Production

- ✓ Phase 1: Authentication system (done)
- [ ] Phase 2: Test suite completion
- [ ] Phase 3: Deployment & monitoring
- [ ] SSL/TLS certificate
- [ ] SMTP/email delivery service
- [ ] Database backups configured

### Dependencies Between Phases

```
Phase 1 (Authentication)
  ↓
Phase 2 (Testing) ← BLOCKS production
  ↓
Phase 3 (Production Deployment)
  ├─→ Phase 4 (UX Enhancements) [parallel]
  ├─→ Phase 5 (API) [sequential]
  └─→ Phase 6 (Admin) [after Phase 4]
      ↓
      Phase 7 (Infrastructure)
```

---

## Success Metrics

### Phase 1: Authentication (Current)

- [x] All Devise flows functional
- [x] UI/UX polish complete
- [x] Dark mode working
- [x] Mobile responsive
- [ ] 80%+ test coverage

### Phase 2: Testing & QA

- [ ] 80%+ code coverage achieved
- [ ] All tests passing
- [ ] Zero Brakeman warnings
- [ ] Rubocop clean
- [ ] Performance benchmarks recorded

### Phase 3: Production

- [ ] App running on production server
- [ ] <5s page load time
- [ ] 99.5% uptime target
- [ ] Email delivery working
- [ ] Monitoring alerts configured

### Phase 4+: Features

- [ ] User satisfaction (NPS) score
- [ ] Feature adoption rate
- [ ] Performance improvements (measured)
- [ ] Security incidents (zero target)

---

## Resource Planning

### Team

- **Developers:** 1-2 (primary development)
- **QA:** 0-1 (testing support)
- **DevOps:** 0-1 (deployment support)
- **PM:** 0.5 (planning, prioritization)

### Time Allocation (Next 4 Weeks)

| Phase | Week 1 | Week 2 | Week 3 | Week 4 |
|-------|--------|--------|--------|--------|
| Phase 2 (Testing) | 80% | 20% | — | — |
| Phase 3 (Deploy) | — | 80% | 80% | — |
| Phase 4 (UX) | — | — | 20% | 80% |

---

## Risks & Mitigation

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|-----------|
| Security vulnerability | Medium | High | Regular audits, Brakeman, updates |
| Email delivery failure | Low | High | Test SMTP early, fallback service |
| Database migration issue | Low | High | Automated backups, test scripts |
| Performance degradation | Medium | Medium | Load testing, monitoring, optimization |
| Deployment failure | Low | High | Staging environment, rollback plan |

---

## Unresolved Questions

1. What's the target launch date for Phase 3 (production)?
2. Should we prioritize Phase 4 (UX) or Phase 5 (API) after testing?
3. Do we need GraphQL API or REST is sufficient?
4. What's the user acquisition/growth plan?
5. Should we implement analytics/telemetry?
6. What's the content/marketing strategy?
7. Should we support multiple languages (i18n)?
8. What's the compliance requirement (GDPR, CCPA)?

---

## Version History

| Version | Date | Status | Notes |
|---------|------|--------|-------|
| 1.0.0 | 2026-01-13 | In Progress | Authentication system MVP |
| 0.5.0 | — | Planned | Testing suite completion |
| 1.0.0 | — | Planned | Production launch |

---

**Last Updated:** 2026-01-13 | **Next Review:** 2026-01-20

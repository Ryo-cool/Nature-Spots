# Task Completion Checklist

When completing a coding task in the Nature-Spots project, follow this checklist:

## 1. Code Quality Checks

### Frontend (if frontend code was modified)
```bash
cd front && yarn lint                # Check for linting errors
cd front && yarn type-check          # Verify TypeScript types
cd front && yarn format:check        # Check code formatting
# OR run all at once:
cd front && yarn check               # Run lint + type-check
```

If any issues found, fix them:
```bash
cd front && yarn lint:fix            # Auto-fix linting errors
cd front && yarn format              # Auto-format code
```

### Backend (if backend code was modified)
```bash
cd back && bundle exec rubocop       # Check Ruby style
cd back && bundle exec rubocop -a    # Auto-fix style issues
```

## 2. Security Checks (for production or security-sensitive changes)

### Backend Security Audit
```bash
cd back && bundle exec brakeman              # Security vulnerabilities scan
cd back && bundle exec bundle-audit          # Check for vulnerable dependencies
```

## 3. Testing

### Backend Tests (REQUIRED if backend code modified)
```bash
cd back && bundle exec rspec                 # Run all tests
# OR run specific tests:
cd back && bundle exec rspec spec/models/    # Model tests only
cd back && bundle exec rspec spec/requests/  # Request tests only
```

**Requirement**: Maintain at least 80% test coverage

### Frontend Tests
Currently, the project doesn't have automated frontend tests configured.
Manual testing is required for frontend changes.

## 4. Build Verification (for major changes)

### Frontend Build Check
```bash
cd front && yarn build               # Ensure production build works
```

### Full Application Test
```bash
docker compose up --build            # Rebuild and start all services
```

## 5. Documentation Updates

Check if any of these need updating:
- [ ] Update `CLAUDE.md` if development guidelines changed
- [ ] Update `README.md` if features or setup process changed
- [ ] Add/update code comments for complex logic
- [ ] Update API documentation if endpoints changed

## 6. Git Best Practices

### Before Committing
```bash
git status                           # Review changed files
git diff                             # Review changes
```

### Commit Message Format
```
type(scope): description

Examples:
feat(auth): add JWT refresh token functionality
fix(spot): resolve location search API error
docs(readme): update setup instructions
test(user): add validation specs
refactor(api): extract common response helpers
```

### Branch Strategy
- `master`: Production-ready code
- `develop`: Integration branch
- `feature/*`: New features
- `bugfix/*`: Bug fixes
- `hotfix/*`: Emergency fixes

## 7. Pre-Push Checklist

Before pushing code:
- [ ] All tests passing
- [ ] No linting errors
- [ ] No type errors (frontend)
- [ ] Code formatted properly
- [ ] Security audit clean (if applicable)
- [ ] Documentation updated
- [ ] Commit messages follow convention

## Quick CI-Like Check

Run this to simulate CI environment checks:
```bash
make ci-test
```

This runs:
- Backend: RSpec + RuboCop + Brakeman
- Frontend: ESLint + Type check + Format check

## Minimal Checklist (for small changes)

For quick bug fixes or minor changes:
1. Run relevant tests: `cd back && bundle exec rspec` or manual test for frontend
2. Run linter: `cd front && yarn lint` or `cd back && bundle exec rubocop`
3. Verify types: `cd front && yarn type-check`

## Notes

- **Don't skip tests**: Tests ensure your changes don't break existing functionality
- **Security first**: Always run security checks before deploying
- **Type safety**: TypeScript strict mode catches errors early
- **Code style**: Consistent style makes code easier to maintain
- **80% coverage**: Minimum requirement for backend code

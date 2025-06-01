# Nature-Spots Project Guide

## Project Overview

Nature-Spots は自然スポットの口コミサイトです。位置情報付きでスポットを共有し、レビューやいいね機能でユーザー同士の交流を促進します。

### 技術スタック

- **Frontend**: Nuxt.js 3 + Vue.js 3 + TypeScript + Vuetify + Pinia
- **Backend**: Rails 7.1.3 + Ruby 3.3.0 + MySQL 5.7 + JWT 認証
- **Infrastructure**: Docker + Docker Compose
- **API**: Google Maps JavaScript API, Geocoding API
- **Internationalization**: Vue I18n (日本語・英語対応)

## Development Environment Setup

### Prerequisites

- Docker & Docker Compose
- Node.js (推奨: v18+)
- Ruby 3.3.0
- Yarn

### Initial Setup

```bash
# 1. Clone and setup
git clone <repository-url>
cd Nature-Spots

# 2. Backend environment setup
cp back/environments/db.env.example back/environments/db.env
# Edit db.env with actual database credentials

# 3. Start with Docker
docker compose up

# Or run separately:
# Frontend: cd front && yarn install && yarn dev
# Backend: cd back && bundle install && bundle exec rails s
```

## Build/Run Commands

### Docker (Recommended)

- `docker compose up` - Run entire application
- `docker compose up --build` - Rebuild and run
- `docker compose down` - Stop all services

### Frontend (Nuxt.js 3)

- `cd front && yarn dev` - Development server (localhost:3000)
- `cd front && yarn build` - Production build
- `cd front && yarn start` - Start production server
- `cd front && yarn lint` - Run ESLint
- `cd front && yarn lint:fix` - Fix linting errors
- `cd front && yarn type-check` - TypeScript type checking
- `cd front && yarn format` - Format code with Prettier
- `cd front && yarn check` - Run lint + type-check

### Backend (Rails 7)

- `cd back && bundle exec rails s` - Start Rails server
- `cd back && bundle exec rails c` - Rails console
- `cd back && bundle exec rspec` - Run all tests
- `cd back && bundle exec rspec spec/models/user_spec.rb` - Single test file
- `cd back && bundle exec rspec spec/models/user_spec.rb:25` - Specific test line
- `cd back && bundle exec brakeman` - Security audit
- `cd back && bundle exec bundle-audit` - Dependency security check

## Architecture & Project Structure

### Frontend Structure

```
front/
├── assets/          # Static assets (SCSS, images)
├── components/      # Vue components
│   ├── beforeLogin/ # Pre-authentication components
│   ├── loggedIn/    # Post-authentication components
│   ├── spot/        # Spot-related components
│   ├── ui/          # Reusable UI components
│   └── user/        # User-related components
├── composables/     # Vue composition functions
├── layouts/         # Nuxt layouts
├── middleware/      # Route middleware
├── pages/           # File-based routing pages
├── plugins/         # Nuxt plugins
├── stores/          # Pinia stores
└── types/           # TypeScript type definitions
```

### Backend Structure

```
back/
├── app/
│   ├── controllers/api/v1/ # API controllers
│   ├── models/             # ActiveRecord models
│   ├── serializers/        # JSON serializers
│   ├── services/           # Service objects
│   ├── policies/           # Authorization policies
│   └── validators/         # Custom validators
├── config/                 # Rails configuration
├── db/                     # Database migrations & seeds
└── spec/                   # RSpec tests
```

## Development Rules & Guidelines

### General Principles

1. **Security First**: セキュリティを最優先に考慮
2. **Type Safety**: TypeScript の型安全性を活用
3. **Test Coverage**: 最低 80%のテストカバレッジを維持
4. **Performance**: パフォーマンスを意識した実装
5. **Accessibility**: アクセシビリティ対応を考慮
6. **Internationalization**: 多言語対応を前提とした設計

### Frontend (Nuxt.js/Vue.js) Guidelines

#### Code Style

- **TypeScript**: Strict mode enabled, 明示的な型定義必須
- **Formatting**: Prettier (2-space indentation)
- **Linting**: ESLint with Vue recommended rules
- **Components**:
  - PascalCase naming (e.g., `UserProfile.vue`)
  - Multi-word component names required
  - Composition API preferred over Options API
- **Naming Conventions**:
  - Variables/Functions: camelCase
  - Constants: UPPER_SNAKE_CASE
  - Files: kebab-case or PascalCase for components

#### Import Organization

```typescript
// 1. Vue/Nuxt imports
import { ref, computed } from 'vue'
import { useRouter } from 'vue-router'

// 2. External libraries
import { format } from 'date-fns'

// 3. Internal modules
import { useAuthStore } from '~/stores/auth'
import type { User } from '~/types'
```

#### State Management (Pinia)

- Use Pinia stores for global state
- Define typed stores with explicit interfaces
- Avoid direct state mutation outside stores

#### Error Handling

- Use typed error responses
- Implement proper error boundaries
- Provide user-friendly error messages
- Log errors appropriately

### Backend (Rails) Guidelines

#### Code Style

- Follow Rails conventions and best practices
- Use RuboCop for style enforcement
- Service objects for complex business logic
- Serializers for API responses

#### Security

- Use strong parameters
- Implement proper authorization with policies
- Validate all inputs
- Use secure headers
- Rate limiting with Rack::Attack

#### Database

- Use migrations for schema changes
- Add proper indexes for performance
- Use foreign key constraints
- Follow naming conventions

#### API Design

- RESTful design principles
- Consistent JSON response format
- Proper HTTP status codes
- API versioning (v1, v2, etc.)

#### Testing (RSpec)

- Model specs: validations, associations, methods
- Controller/Request specs: API endpoints
- Service specs: business logic
- Use FactoryBot for test data
- Maintain minimum 80% coverage

### Git Workflow

#### Branch Strategy

- `master`: Production-ready code
- `develop`: Integration branch
- `feature/*`: Feature development
- `bugfix/*`: Bug fixes
- `hotfix/*`: Emergency fixes

#### Commit Messages

```
type(scope): description

feat(auth): add JWT refresh token functionality
fix(spot): resolve location search API error
docs(readme): update setup instructions
test(user): add validation specs
refactor(api): extract common response helpers
```

#### Pull Request Process

1. Create feature branch from `develop`
2. Implement feature with tests
3. Ensure all tests pass
4. Update documentation if needed
5. Create PR to `develop`
6. Code review required
7. Merge after approval

### Environment Variables

#### Frontend (.env)

```bash
GOOGLE_MAPS_API_KEY=your_key_here
CRYPTO_KEY=your_crypto_key
NODE_ENV=development
```

#### Backend (db.env)

```bash
MYSQL_ROOT_PASSWORD=root_password
MYSQL_DATABASE=nature_spots_development
MYSQL_USER=app_user
MYSQL_PASSWORD=app_password
```

### Performance Guidelines

#### Frontend

- Use lazy loading for components
- Optimize images (WebP format)
- Implement virtual scrolling for long lists
- Use Nuxt's built-in performance optimizations

#### Backend

- Use database indexes appropriately
- Implement caching where needed
- Optimize N+1 queries
- Use background jobs for heavy processing

### Security Checklist

#### Frontend

- [ ] Sanitize user inputs
- [ ] Use HTTPS in production
- [ ] Implement CSP headers
- [ ] Validate API responses

#### Backend

- [ ] Use strong parameters
- [ ] Implement rate limiting
- [ ] Add security headers
- [ ] Regular dependency updates
- [ ] Use environment variables for secrets

### Deployment

#### Production Checklist

- [ ] All tests passing
- [ ] Security audit clean
- [ ] Performance benchmarks met
- [ ] Environment variables configured
- [ ] Database migrations applied
- [ ] Monitoring setup

## Troubleshooting

### Common Issues

1. **Docker Build Fails**: Clear Docker cache with `docker system prune`
2. **Database Connection**: Check db.env configuration
3. **Frontend Build Errors**: Clear node_modules and reinstall
4. **Type Errors**: Run `yarn type-check` for detailed errors

### Debug Commands

```bash
# Frontend debugging
yarn dev --debug
yarn type-check --verbose

# Backend debugging
bundle exec rails console
bundle exec rspec --format documentation
```

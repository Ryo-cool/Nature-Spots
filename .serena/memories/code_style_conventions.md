# Code Style and Conventions

## General Principles
1. **Security First**: セキュリティを最優先に考慮
2. **Type Safety**: TypeScript の型安全性を活用
3. **Test Coverage**: 最低 80%のテストカバレッジを維持
4. **Performance**: パフォーマンスを意識した実装
5. **Accessibility**: アクセシビリティ対応を考慮
6. **Internationalization**: 多言語対応を前提とした設計

## Frontend Code Style (Nuxt.js/Vue.js/TypeScript)

### TypeScript
- **Strict mode**: Enabled in tsconfig.json
- **Explicit types**: Always provide explicit type definitions
- **No `any`**: ESLint rule disabled but should be avoided when possible

### Naming Conventions
- **Components**: PascalCase (e.g., `UserProfile.vue`)
- **Files**: kebab-case or PascalCase for components
- **Variables/Functions**: camelCase
- **Constants**: UPPER_SNAKE_CASE
- **Multi-word component names**: Required by Vue style guide

### Code Organization
- **Composition API**: Preferred over Options API
- **Import order**:
  1. Vue/Nuxt imports
  2. External libraries
  3. Internal modules (composables, stores, types)
  
### Formatting
- **Indentation**: 2 spaces (enforced by Prettier)
- **Quotes**: Configurable by Prettier
- **Semicolons**: Configurable by Prettier
- **Max line length**: Auto-formatted by Prettier

### ESLint Rules
- Vue3 recommended rules enabled
- TypeScript recommended rules enabled
- Prettier integration for formatting
- No console/debugger in production (warn only)
- Unused vars with `_` prefix ignored
- No explicit `any` allowed (rule off but discouraged)

### State Management (Pinia)
- Use Pinia stores for global state
- Define typed stores with explicit interfaces
- Avoid direct state mutation outside stores

### Component Structure
```vue
<script setup lang="ts">
// 1. Imports
import { ref, computed } from 'vue'
import type { User } from '~/types'

// 2. Props/Emits
interface Props {
  user: User
}
const props = defineProps<Props>()

// 3. State
const isLoading = ref(false)

// 4. Computed
const fullName = computed(() => ...)

// 5. Methods
const handleClick = () => {...}
</script>

<template>
  <!-- Template -->
</template>

<style scoped lang="scss">
/* Styles */
</style>
```

## Backend Code Style (Rails/Ruby)

### Ruby Style
- Follow **Rails conventions and best practices**
- Use **RuboCop** for style enforcement (default Rails config)
- Ruby version: 3.2.3

### Naming Conventions
- **Classes/Modules**: PascalCase
- **Methods/Variables**: snake_case
- **Constants**: UPPER_SNAKE_CASE
- **Files**: snake_case

### Code Organization
- **Service objects**: Complex business logic
- **Serializers**: JSON API responses
- **Policies**: Authorization logic
- **Validators**: Custom validation logic

### API Design
- **RESTful principles**: Use standard REST conventions
- **API versioning**: v1, v2, etc. in routes (api/v1/)
- **JSON responses**: Consistent format with proper status codes
- **Strong parameters**: Always use for security

### Security Practices
- **Strong parameters**: Required for all controller inputs
- **Authorization**: Use policies for access control
- **Input validation**: Validate all user inputs
- **Secure headers**: Configure in Rails
- **Rate limiting**: Use Rack::Attack
- **Password encryption**: bcrypt
- **JWT**: For stateless authentication

### Database Conventions
- **Migrations**: Use for all schema changes
- **Indexes**: Add for performance-critical queries
- **Foreign keys**: Use constraints
- **Naming**: Follow Rails conventions (plural table names)

## Testing Conventions

### Frontend
- Type checking with `vue-tsc`
- Manual testing workflow (no automated tests configured yet)

### Backend (RSpec)
- **Model specs**: Validations, associations, methods
- **Request specs**: API endpoint testing
- **Service specs**: Business logic testing
- **Use FactoryBot**: For test data generation
- **Minimum 80% coverage**: Required with SimpleCov
- **shoulda-matchers**: For clean, readable specs

## File Encoding
- **UTF-8**: All files use UTF-8 encoding

## Comments and Documentation
- Prefer self-documenting code
- Add comments for complex logic
- Document API endpoints
- Keep CLAUDE.md and README.md updated

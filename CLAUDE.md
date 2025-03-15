# Nature-Spots Project Guide

## Build/Run Commands
- Frontend (Nuxt.js):
  - `docker-compose up` - Run entire app with Docker
  - `cd front && yarn dev` - Run frontend only
  - `cd front && yarn lint` - Run ESLint
  - `cd front && yarn lint:fix` - Fix linting errors
  - `cd front && yarn type-check` - Check TypeScript
  - `cd front && yarn format` - Format code with Prettier

- Backend (Rails):
  - `cd back && bundle exec rails s` - Run Rails server
  - `cd back && bundle exec rspec` - Run all tests
  - `cd back && bundle exec rspec spec/models/user_spec.rb` - Run single test file
  - `cd back && bundle exec rspec spec/models/user_spec.rb:25` - Run specific test line

## Code Style Guidelines
- **TypeScript**: Strict mode, explicit types for functions & variables
- **Formatting**: Use Prettier with 2-space indentation
- **Components**: Vue components use multi-word names, PascalCase
- **Naming**: camelCase for methods/variables, PascalCase for classes
- **Imports**: Group by type (Vue/external libs/local), prefer named imports
- **Error Handling**: Use typed error responses, validate inputs
- **State Management**: Use Vuex with types via vuex-module-decorators
- **Backend**: Follow Rails conventions, use RSpec for testing
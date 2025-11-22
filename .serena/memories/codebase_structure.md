# Nature-Spots Codebase Structure

## Root Directory
```
Nature-Spots/
├── front/              # Nuxt.js 3 frontend application
├── back/               # Rails 7 backend API
├── .github/            # GitHub workflows and CI/CD
├── .circleci/          # CircleCI configuration
├── docker-compose.yml  # Docker Compose configuration
├── Makefile            # Build and development commands
├── CLAUDE.md           # Development guidelines and instructions
└── README.md           # Project documentation
```

## Frontend Structure (front/)
```
front/
├── assets/             # Static assets (SCSS, images)
├── components/         # Vue components
│   ├── beforeLogin/    # Pre-authentication components
│   ├── loggedIn/       # Post-authentication components
│   ├── spot/           # Spot-related components
│   ├── ui/             # Reusable UI components
│   └── user/           # User-related components
├── composables/        # Vue composition functions
├── layouts/            # Nuxt layouts
├── middleware/         # Route middleware (auth, etc.)
├── pages/              # File-based routing pages
├── plugins/            # Nuxt plugins
├── stores/             # Pinia stores (global state)
├── types/              # TypeScript type definitions
├── locales/            # i18n translation files
├── static/             # Static files
├── .config/            # Configuration files
├── app.vue             # Root component
├── error.vue           # Error page
├── nuxt.config.ts      # Nuxt configuration
├── tsconfig.json       # TypeScript configuration
├── .eslintrc.js        # ESLint configuration
├── package.json        # Dependencies and scripts
└── Dockerfile          # Docker configuration
```

## Backend Structure (back/)
```
back/
├── app/
│   ├── controllers/api/v1/  # API controllers (versioned)
│   ├── models/              # ActiveRecord models
│   ├── serializers/         # JSON serializers
│   ├── services/            # Service objects (business logic)
│   ├── policies/            # Authorization policies
│   └── validators/          # Custom validators
├── config/                  # Rails configuration
│   ├── routes.rb            # API routes
│   ├── database.yml         # Database configuration
│   └── ...
├── db/                      # Database
│   ├── migrate/             # Migrations
│   └── seeds.rb             # Seed data
├── spec/                    # RSpec tests
│   ├── models/              # Model specs
│   ├── requests/            # Request/controller specs
│   ├── factories/           # FactoryBot factories
│   └── ...
├── environments/            # Environment variables
│   └── db.env.example       # Database config example
├── Gemfile                  # Ruby dependencies
├── Rakefile                 # Rake tasks
├── config.ru                # Rack configuration
└── Dockerfile               # Docker configuration
```

## Key Configuration Files

### Frontend
- `nuxt.config.ts`: Nuxt configuration (modules, plugins, build settings)
- `tsconfig.json`: TypeScript strict mode and path mappings
- `.eslintrc.js`: ESLint + Prettier + Vue + TypeScript rules
- `i18n.config.ts`: Internationalization configuration
- `package.json`: Scripts (dev, build, lint, type-check, format)

### Backend
- `Gemfile`: Ruby gem dependencies
- `config/routes.rb`: API routing configuration
- `config/database.yml`: Database connection settings
- `.rspec`: RSpec configuration
- No .rubocop.yml found (RuboCop uses default Rails conventions)

## Docker Services
- **db**: MySQL 5.7 database (port: internal only)
- **back**: Rails API server (port: 3000)
- **front**: Nuxt.js dev server (port: 8080 → 3000 internal)

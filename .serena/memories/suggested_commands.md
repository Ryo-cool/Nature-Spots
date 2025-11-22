# Suggested Commands for Nature-Spots

## Quick Start
```bash
# Start entire application with Docker
make dev
# OR
docker compose up

# Stop application
make stop
# OR
docker compose stop
```

## Development Commands

### Docker (Recommended)
```bash
make dev                  # Start all services
make stop                 # Stop all services
make restart              # Restart all services
make logs                 # View all logs
make logs-front           # View frontend logs only
make logs-back            # View backend logs only
docker compose ps         # Check container status
```

### Frontend (Nuxt.js 3)
```bash
cd front && yarn dev                 # Start dev server (localhost:8080)
cd front && yarn build               # Production build
cd front && yarn start               # Start production server
cd front && yarn lint                # Run ESLint
cd front && yarn lint:fix            # Fix linting errors
cd front && yarn type-check          # TypeScript type checking
cd front && yarn format              # Format code with Prettier
cd front && yarn format:check        # Check if code is formatted
cd front && yarn check               # Run lint + type-check
```

### Backend (Rails 7)
```bash
cd back && bundle exec rails s       # Start Rails server (port 3000)
cd back && bundle exec rails c       # Rails console
cd back && bundle exec rspec         # Run all tests
cd back && bundle exec rspec spec/models/user_spec.rb        # Single file
cd back && bundle exec rspec spec/models/user_spec.rb:25     # Specific line
cd back && bundle exec rubocop       # Run RuboCop linter
cd back && bundle exec rubocop -a    # Auto-fix RuboCop issues
cd back && bundle exec brakeman      # Security audit
cd back && bundle exec bundle-audit  # Dependency security check
```

### Testing
```bash
make test                 # Run all tests (backend + frontend)
make backend-test         # Run backend tests in Docker
make backend-test-local   # Run backend tests locally
make frontend-test        # Run frontend tests
make ci-test              # Run full CI test suite
```

### Code Quality
```bash
make lint                 # Lint frontend + backend
make lint-fix             # Auto-fix lint errors
make format               # Format all code
make type-check           # TypeScript type check
make check                # Run all quality checks
```

### Database
```bash
make db-create            # Create database
make db-migrate           # Run migrations
make db-seed              # Seed database
make db-reset             # Reset database
make db-console           # Open database console
make rails-console        # Open Rails console
```

### Docker Utilities
```bash
make docker-up            # Start containers in detached mode
make docker-down          # Stop and remove containers
make docker-restart       # Restart containers
make docker-logs          # View all logs
make docker-ps            # Container status
make docker-exec-front    # Access frontend container shell
make docker-exec-back     # Access backend container shell
make docker-exec-db       # Access MySQL database
```

### Build
```bash
make build                # Production build (frontend + backend)
make build-docker         # Build Docker images
```

### Cleanup
```bash
make clean                # Clean build files and caches
make clean-all            # Clean everything including dependencies
```

### Setup
```bash
make install              # Install all dependencies
make setup                # Initial project setup (env + DB)
```

### Git/Status
```bash
make status               # Show Docker status + git status
git status                # Standard git status
```

## macOS (Darwin) System Commands

### File Operations
```bash
ls -la                    # List files with details
find . -name "*.rb"       # Find files by pattern
grep -r "pattern" .       # Search in files recursively
cat file.txt              # Display file contents
```

### Process Management
```bash
ps aux | grep rails       # Find Rails processes
kill -9 <pid>             # Force kill process
lsof -i :3000             # Check what's using port 3000
```

### Docker Debugging
```bash
docker compose logs -f back       # Follow backend logs
docker compose exec back bash     # Shell into backend
docker system prune               # Clean Docker cache
docker volume ls                  # List Docker volumes
```

## Environment Configuration

### First Time Setup
```bash
# 1. Copy environment files
cp back/environments/db.env.example back/environments/db.env

# 2. Edit with your credentials
# Edit back/environments/db.env

# 3. Setup and start
make setup
```

### Environment Variables
- **Backend**: `back/environments/db.env` (MySQL config)
- **Frontend**: `front/.env` (Google Maps API key, crypto key)

## Port Information
- **Frontend**: http://localhost:8080 (Docker) or http://localhost:3000 (local)
- **Backend API**: http://localhost:3000
- **Database**: MySQL 5.7 (internal only)

# Git Workflow for Nature-Spots

## Branch Strategy

### Main Branches
- **`master`**: Production-ready code (currently main branch)
- **`develop`**: Integration branch for ongoing development

### Supporting Branches
- **`feature/*`**: New feature development
- **`bugfix/*`**: Bug fixes
- **`hotfix/*`**: Emergency production fixes

## Workflow

### 1. Starting a New Feature
```bash
# Make sure you're on develop (or master if no develop)
git checkout master
git pull origin master

# Create a new feature branch
git checkout -b feature/add-user-profile-page
```

### 2. Working on the Feature
```bash
# Make changes, then stage them
git add .

# Commit with conventional commit message
git commit -m "feat(user): add user profile page with avatar upload"

# Push to remote
git push origin feature/add-user-profile-page
```

### 3. Before Creating PR

Run the task completion checklist:
```bash
# Run all quality checks
make ci-test

# Or individually:
cd front && yarn check           # Frontend lint + type-check
cd back && bundle exec rspec     # Backend tests
cd back && bundle exec rubocop   # Backend linting
```

### 4. Creating Pull Request

1. Ensure all tests pass
2. Push your branch
3. Create PR to `develop` (or `master`)
4. Fill in PR description with:
   - Summary of changes
   - Testing done
   - Screenshots (if UI changes)
   - Breaking changes (if any)

### 5. After Code Review

```bash
# Address review comments
git add .
git commit -m "fix(user): address code review comments"
git push origin feature/add-user-profile-page
```

### 6. Merging

- Require code review approval
- Ensure CI passes
- Merge to target branch
- Delete feature branch after merge

## Commit Message Convention

### Format
```
type(scope): description

[optional body]

[optional footer]
```

### Types
- **feat**: New feature
- **fix**: Bug fix
- **docs**: Documentation changes
- **test**: Adding or updating tests
- **refactor**: Code refactoring
- **style**: Code style changes (formatting, etc.)
- **perf**: Performance improvements
- **chore**: Build process or auxiliary tool changes
- **ci**: CI/CD changes

### Scope Examples
- **auth**: Authentication
- **spot**: Spot-related features
- **user**: User-related features
- **review**: Review functionality
- **api**: Backend API
- **ui**: UI components
- **db**: Database

### Examples
```bash
# New feature
git commit -m "feat(auth): add JWT refresh token functionality"

# Bug fix
git commit -m "fix(spot): resolve location search API error"

# Documentation
git commit -m "docs(readme): update Docker setup instructions"

# Test
git commit -m "test(user): add validation specs for user model"

# Refactoring
git commit -m "refactor(api): extract common response helpers"

# With body
git commit -m "feat(spot): add autocomplete search

- Implement debounced search input
- Add API endpoint for search suggestions
- Update UI to show dropdown with results"
```

## Useful Git Commands

### Status and Information
```bash
git status                           # Check current status
git status -s                        # Short status
git log --oneline --graph            # Visual commit history
git log --oneline -n 10              # Last 10 commits
git show <commit-hash>               # Show commit details
git diff                             # Show unstaged changes
git diff --staged                    # Show staged changes
```

### Branching
```bash
git branch                           # List local branches
git branch -a                        # List all branches (including remote)
git branch -d feature/old-feature    # Delete local branch
git checkout -b feature/new-feature  # Create and switch to new branch
git switch master                    # Switch to master (modern way)
```

### Updating
```bash
git pull origin master               # Pull latest from master
git fetch origin                     # Fetch without merging
git rebase master                    # Rebase current branch on master
```

### Undoing Changes
```bash
git restore file.txt                 # Discard changes in working directory
git restore --staged file.txt        # Unstage file
git reset HEAD~1                     # Undo last commit (keep changes)
git reset --hard HEAD~1              # Undo last commit (discard changes)
git revert <commit-hash>             # Create new commit that undoes a commit
```

### Stashing
```bash
git stash                            # Stash current changes
git stash list                       # List stashes
git stash pop                        # Apply and remove latest stash
git stash apply                      # Apply latest stash (keep in stash)
git stash drop                       # Remove latest stash
```

### Remote
```bash
git remote -v                        # Show remote repositories
git push origin feature/my-feature   # Push branch to remote
git push -u origin feature/new       # Push and set upstream
git push --force-with-lease          # Safe force push (after rebase)
```

## Current Repository Status

Based on the git status output:
- **Current branch**: `master`
- **Main branch**: `master` (used for PRs)
- **Status**: Clean working directory

## Best Practices

1. **Commit often**: Make small, focused commits
2. **Write clear messages**: Follow the commit message convention
3. **Pull before push**: Always pull latest changes before pushing
4. **Test before commit**: Run tests and linters before committing
5. **Review before push**: Use `git diff --staged` to review changes
6. **Branch naming**: Use descriptive names with type prefix
7. **Keep branches short-lived**: Merge frequently to avoid conflicts
8. **Don't commit secrets**: Never commit `.env` files or credentials
9. **Use `.gitignore`**: Ensure build artifacts are ignored
10. **Code review**: Always get code reviewed before merging

## Protected Files (Never Commit)

These files are gitignored and should NEVER be committed:
- `back/environments/db.env` (database credentials)
- `front/.env` (API keys)
- `.DS_Store` (macOS files)
- `node_modules/`
- `.nuxt/`, `.output/`
- `log/*.log`
- `tmp/`
- `coverage/`

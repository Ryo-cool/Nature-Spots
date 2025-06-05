.PHONY: help install dev stop restart logs test lint format check build clean docker-build docker-up docker-down docker-restart docker-logs backend-test frontend-test ci-test

# デフォルトターゲット - ヘルプを表示
.DEFAULT_GOAL := help

# ヘルプ
help: ## このヘルプを表示
	@echo "Nature-Spots Makefile Commands:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

# =============================================================================
# Setup Commands
# =============================================================================

install: ## 依存関係をインストール（フロントエンド・バックエンド両方）
	@echo "Installing frontend dependencies..."
	cd front && yarn install
	@echo "Installing backend dependencies..."
	cd back && bundle install

setup: ## 初期セットアップ（環境ファイルのコピー、DBセットアップ）
	@echo "Setting up environment files..."
	@if [ ! -f back/environments/db.env ]; then \
		cp back/environments/db.env.example back/environments/db.env; \
		echo "Created back/environments/db.env - Please update with actual values"; \
	fi
	@echo "Setting up database..."
	$(MAKE) docker-up
	@sleep 5
	docker compose exec back bundle exec rails db:create db:migrate db:seed

# =============================================================================
# Development Commands
# =============================================================================

dev: ## 開発サーバーを起動（Docker Compose）
	docker compose up

dev-front: ## フロントエンドの開発サーバーのみ起動
	cd front && yarn dev

dev-back: ## バックエンドの開発サーバーのみ起動
	cd back && bundle exec rails s

stop: ## 開発サーバーを停止
	docker compose stop

restart: ## 開発サーバーを再起動
	docker compose restart

logs: ## ログを表示
	docker compose logs -f

logs-front: ## フロントエンドのログを表示
	docker compose logs -f front

logs-back: ## バックエンドのログを表示
	docker compose logs -f back

# =============================================================================
# Test Commands
# =============================================================================

test: backend-test frontend-test ## すべてのテストを実行

backend-test: ## バックエンドのテストを実行
	@echo "Running backend tests..."
	docker compose exec back bundle exec rspec

backend-test-local: ## バックエンドのテストをローカルで実行
	cd back && bundle exec rspec

frontend-test: ## フロントエンドのテストを実行
	@echo "Running frontend tests..."
	cd front && yarn test

ci-test: ## CI環境でのテストを実行
	@echo "Running CI tests..."
	@echo "Backend CI:"
	cd back && bundle exec rspec && bundle exec rubocop && bundle exec brakeman --no-pager
	@echo "Frontend CI:"
	cd front && yarn lint && yarn type-check && yarn format:check

# =============================================================================
# Code Quality Commands
# =============================================================================

lint: ## コードの品質チェック（フロントエンド・バックエンド両方）
	@echo "Linting frontend..."
	cd front && yarn lint
	@echo "Linting backend..."
	cd back && bundle exec rubocop

lint-fix: ## Lintエラーを自動修正
	@echo "Fixing frontend lint errors..."
	cd front && yarn lint:fix
	@echo "Fixing backend lint errors..."
	cd back && bundle exec rubocop -a

format: ## コードをフォーマット
	@echo "Formatting frontend code..."
	cd front && yarn format
	@echo "Formatting backend code..."
	cd back && bundle exec rubocop -a

type-check: ## TypeScriptの型チェック
	cd front && yarn type-check

check: ## すべての品質チェックを実行
	@echo "Running all quality checks..."
	$(MAKE) lint
	$(MAKE) type-check
	cd front && yarn format:check

# =============================================================================
# Build Commands
# =============================================================================

build: ## プロダクションビルド
	@echo "Building frontend..."
	cd front && yarn build
	@echo "Building backend..."
	cd back && RAILS_ENV=production bundle exec rails assets:precompile

build-docker: ## Dockerイメージをビルド
	docker compose build

# =============================================================================
# Docker Commands
# =============================================================================

docker-up: ## Dockerコンテナを起動
	docker compose up -d

docker-down: ## Dockerコンテナを停止・削除
	docker compose down

docker-restart: ## Dockerコンテナを再起動
	docker compose restart

docker-logs: ## Dockerコンテナのログを表示
	docker compose logs -f

docker-ps: ## Dockerコンテナの状態を表示
	docker compose ps

docker-exec-front: ## フロントエンドコンテナにアクセス
	docker compose exec front sh

docker-exec-back: ## バックエンドコンテナにアクセス
	docker compose exec back bash

docker-exec-db: ## データベースコンテナにアクセス
	docker compose exec db mysql -u root -p

# =============================================================================
# Database Commands
# =============================================================================

db-create: ## データベースを作成
	docker compose exec back bundle exec rails db:create

db-migrate: ## データベースマイグレーションを実行
	docker compose exec back bundle exec rails db:migrate

db-seed: ## シードデータを投入
	docker compose exec back bundle exec rails db:seed

db-reset: ## データベースをリセット
	docker compose exec back bundle exec rails db:drop db:create db:migrate db:seed

db-console: ## データベースコンソールを起動
	docker compose exec db mysql -u root -p nature_spots_development

# =============================================================================
# Rails Commands
# =============================================================================

rails-console: ## Railsコンソールを起動
	docker compose exec back bundle exec rails c

rails-routes: ## ルーティングを表示
	docker compose exec back bundle exec rails routes

# =============================================================================
# Utility Commands
# =============================================================================

clean: ## ビルドファイルとキャッシュをクリーン
	@echo "Cleaning frontend build files..."
	cd front && rm -rf .nuxt .output node_modules/.cache
	@echo "Cleaning backend tmp files..."
	cd back && rm -rf tmp/cache tmp/pids tmp/sockets log/*.log
	@echo "Cleaning Docker volumes..."
	docker compose down -v

clean-all: clean ## すべてをクリーン（node_modules、vendor/bundleを含む）
	@echo "Removing all dependencies..."
	cd front && rm -rf node_modules
	cd back && rm -rf vendor/bundle
	docker compose down -v --rmi all

status: ## プロジェクトの状態を表示
	@echo "=== Docker Status ==="
	docker compose ps
	@echo "\n=== Git Status ==="
	git status -s
	@echo "\n=== Branch Info ==="
	git branch --show-current

# =============================================================================
# Release Commands
# =============================================================================

release-patch: ## パッチバージョンをリリース
	@echo "Creating patch release..."
	npm version patch
	git push && git push --tags

release-minor: ## マイナーバージョンをリリース
	@echo "Creating minor release..."
	npm version minor
	git push && git push --tags

release-major: ## メジャーバージョンをリリース
	@echo "Creating major release..."
	npm version major
	git push && git push --tags
.PHONY: install lint type-check format test clean

# デフォルトのターゲット
all: lint type-check

# 依存関係のインストール
install:
	cd front && yarn install

# ESLintによるコード検証
lint:
	cd front && yarn eslint .

# TypeScriptの型チェック
type-check:
	cd front && yarn vue-tsc --noEmit

# Prettierによるコードフォーマット
format:
	cd front && yarn prettier --write "**/*.{js,ts,vue,json,md}"

# テストの実行
test:
	cd front && yarn test

# ビルドファイルのクリーン
clean:
	cd front && yarn clean

# 開発サーバーの起動
dev:
	cd front && yarn dev

# プロダクションビルド
build:
	cd front && yarn build

# すべての検証を実行
check: lint type-check 
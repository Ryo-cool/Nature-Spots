module.exports = {
  root: true,
  env: {
    browser: true,
    node: true,
    mocha: true,
  },
  parserOptions: {
    // parser: "babel-eslint",
    parser: "@typescript-eslint/parser",
  },
  extends: [
    "eslint:recommended",
    // https://github.com/vuejs/eslint-plugin-vue#priority-a-essential-error-prevention
    "plugin:vue/recommended",
    "plugin:prettier/recommended",
  ],
  // *.vue ファイルを lint にかけるために必要
  plugins: ["vue", "@typescript-eslint"],
  // ここにカスタムルールを追加します。
  rules: {
    semi: [2, "never"],
    "no-console": "off",
    "vue/max-attributes-per-line": "off",
    "prettier/prettier": ["error", { semi: false }],
    "@typescript-eslint/no-unused-vars": "error",
  },
}

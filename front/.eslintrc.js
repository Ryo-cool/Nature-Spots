module.exports = {
  root: true,
  env: {
    browser: true,
    node: true,
  },
  extends: [
    "@nuxtjs/eslint-config-typescript",
    "plugin:vue/recommended",
    "plugin:prettier/recommended",
  ],
  plugins: ["@typescript-eslint"],
  parserOptions: {
    parser: "@typescript-eslint/parser",
    sourceType: "module",
    ecmaVersion: 2020,
  },
  rules: {
    "vue/multi-word-component-names": "off",
    "no-console": process.env.NODE_ENV === "production" ? "warn" : "off",
    "no-debugger": process.env.NODE_ENV === "production" ? "warn" : "off",
  },
  overrides: [
    {
      files: ["**/*.{js,ts,vue}"],
    },
  ],
};

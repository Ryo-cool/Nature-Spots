module.exports = {
  root: true,
  env: {
    browser: true,
    node: true,
  },
  extends: [
    "@nuxtjs/eslint-config-typescript",
    "plugin:vue/vue3-recommended",
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
    "@typescript-eslint/no-unused-vars": ["error", { argsIgnorePattern: "^_" }],
    "vue/no-v-text-v-html-on-component": "off",
    "vue/no-v-for-template-key-on-child": "off",
    "vue/require-explicit-emits": "warn",
    "require-await": "off",
    "no-lonely-if": "off",
    "vue/valid-v-slot": ["error", { allowModifiers: true }],
    "@typescript-eslint/no-var-requires": "off",
    "import/namespace": "off",
    "no-useless-catch": "off",
    "vue/no-deprecated-html-element-is": "off",
    "no-unused-expressions": "off",
    "no-sequences": "off",
  },
  overrides: [
    {
      files: ["**/*.{js,ts,vue}"],
    },
  ],
};

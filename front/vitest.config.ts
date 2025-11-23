/* eslint-disable @typescript-eslint/ban-ts-comment */
// @ts-nocheck
import { defineConfig } from "vitest/config";
import vue from "@vitejs/plugin-vue";
import path from "path";
import type { PluginOption } from "vite";

export default defineConfig({
  plugins: [vue() as PluginOption],
  test: {
    environment: "jsdom",
    globals: true,
    setupFiles: "./tests/setup.ts",
  },
  resolve: {
    alias: {
      "~": path.resolve(__dirname, "."),
      "@": path.resolve(__dirname, "."),
    },
  },
});

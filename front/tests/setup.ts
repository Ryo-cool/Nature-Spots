import { vi } from "vitest";

// Nuxtで自動提供されるメタ定義をテスト環境でスタブ
vi.stubGlobal("definePageMeta", () => {});

// useRuntimeConfig をグローバルスタブ
vi.stubGlobal("useRuntimeConfig", () => ({
  public: {
    apiBaseUrl: "http://localhost:3000",
  },
}));

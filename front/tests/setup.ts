import { vi, beforeEach } from "vitest";

// Nuxtで自動提供されるメタ定義をテスト環境でスタブ
vi.stubGlobal("definePageMeta", () => {});

// useRuntimeConfig をグローバルスタブ
vi.stubGlobal("useRuntimeConfig", () => ({
  public: {
    apiBaseUrl: "http://localhost:3000",
    guestEmail: "guest@example.com",
    guestPassword: "guestpassword123",
  },
}));

// 各テスト前に必要なグローバルを再設定
beforeEach(() => {
  vi.stubGlobal("definePageMeta", () => {});
  vi.stubGlobal("useRuntimeConfig", () => ({
    public: {
      apiBaseUrl: "http://localhost:3000",
      guestEmail: "guest@example.com",
      guestPassword: "guestpassword123",
    },
  }));
});

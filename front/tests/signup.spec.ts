import { mount } from "@vue/test-utils";
import { describe, expect, test, vi, beforeEach, afterEach } from "vitest";
import SignupPage from "../pages/signup.vue";

const mockShowToast = vi.fn();
const mockRouterPush = vi.fn();
const mockAuthLogin = vi.fn();

vi.mock("~/composables/useAuth", () => ({
  useAuth: () => ({
    login: mockAuthLogin,
  }),
}));

vi.mock("~/stores/toast", () => ({
  useToastStore: () => ({
    showToast: mockShowToast,
  }),
}));

vi.mock("vue-router", () => ({
  useRouter: () => ({
    push: mockRouterPush,
  }),
}));

// useRuntimeConfig は #app から提供されるため、仮想モジュールでスタブする
vi.mock("#app", () => ({
  useRuntimeConfig: () => ({
    public: { apiBaseUrl: "http://localhost:3000" },
  }),
}));

const globalStubs = {
  "bef-login-form-card": {
    template: '<div><slot name="form-card-content" /></div>',
  },
  "toast-notification": { template: "<div />" },
  "user-form-name": { template: "<input />" },
  "user-form-email": { template: "<input />" },
  "user-form-password": { template: "<input />" },
  "v-form": { template: "<form><slot /></form>" },
  "v-btn": { template: "<button><slot /></button>" },
};

interface ExposedSignup {
  signup: () => Promise<void>;
  params: { user: { name: string; email: string; password: string } };
  isValid: { value: boolean };
  loading: { value: boolean };
}

interface AuthResponse {
  token: string;
  exp: number;
  user: unknown | null;
}

const successAuthResponse: AuthResponse = {
  token: "token-123",
  exp: 123456,
  user: null,
};

describe("pages/signup.vue", () => {
  const mountPage = () =>
    mount(SignupPage, {
      global: {
        stubs: globalStubs,
      },
    });

  beforeEach(() => {
    mockShowToast.mockClear();
    mockRouterPush.mockClear();
    mockAuthLogin.mockClear();
  });

  afterEach(() => {
    // $fetch をリセット
    (global as typeof globalThis & { $fetch?: unknown }).$fetch = undefined;
  });

  test("有効な入力ならサインアップして自動ログインする", async () => {
    const fetchSpy = vi
      .fn()
      .mockResolvedValueOnce({})
      .mockResolvedValueOnce(successAuthResponse);
    vi.stubGlobal("$fetch", fetchSpy);

    const wrapper = mountPage();
    const exposed = wrapper.vm.$.exposed as ExposedSignup;

    exposed.isValid.value = true;
    exposed.params.user = {
      name: "Alice",
      email: "alice@example.com",
      password: "Password1",
    };

    await exposed.signup();

    expect(fetchSpy).toHaveBeenNthCalledWith(
      1,
      "/api/v1/users",
      expect.objectContaining({
        method: "POST",
        body: {
          name: "Alice",
          email: "alice@example.com",
          password: "Password1",
        },
        baseURL: "http://localhost:3000",
      }),
    );

    expect(fetchSpy).toHaveBeenNthCalledWith(
      2,
      "/api/v1/user_token",
      expect.objectContaining({
        method: "POST",
        body: {
          auth: {
            email: "alice@example.com",
            password: "Password1",
          },
        },
        baseURL: "http://localhost:3000",
      }),
    );

    expect(mockAuthLogin).toHaveBeenCalledWith(successAuthResponse);
    expect(mockRouterPush).toHaveBeenCalledWith("/spots");
    expect(mockShowToast).toHaveBeenCalledWith({
      message: "アカウントを作成しました",
      color: "success",
    });
    expect(exposed.loading.value).toBe(false);
  });

  test("APIエラー時にエラーメッセージを表示する", async () => {
    const fetchSpy = vi.fn().mockRejectedValueOnce({
      data: { errors: { email: ["メールアドレスが無効です"] } },
      message: "",
    });
    vi.stubGlobal("$fetch", fetchSpy);

    const wrapper = mountPage();
    const exposed = wrapper.vm.$.exposed as ExposedSignup;

    exposed.isValid.value = true;
    await exposed.signup();

    expect(fetchSpy).toHaveBeenCalledTimes(1);
    expect(mockShowToast).toHaveBeenCalledWith({
      message: "メールアドレスが無効です",
      color: "error",
    });
    expect(exposed.loading.value).toBe(false);
  });
});

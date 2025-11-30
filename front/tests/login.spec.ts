import { mount } from "@vue/test-utils";
import { describe, expect, test, vi, beforeEach, afterEach } from "vitest";
import LoginPage from "../pages/login.vue";

const mockShowToast = vi.fn();
const mockRouterPush = vi.fn();
const mockAuthLogin = vi.fn();
const mockGetItem = vi.fn();

vi.mock("~/composables/useAuth", () => ({
  useAuth: () => ({
    login: mockAuthLogin,
  }),
}));

vi.mock("~/composables/useSecureStorage", () => ({
  useSecureStorage: () => ({
    getItem: mockGetItem,
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

vi.mock("#app", () => ({
  useRuntimeConfig: () => ({
    public: {
      apiBaseUrl: "http://localhost:3000",
      guestEmail: "guest@example.com",
      guestPassword: "guestpassword123",
    },
  }),
}));

const globalStubs = {
  "bef-login-form-card": {
    template: '<div><slot name="form-card-content" /></div>',
  },
  "toast-notification": { template: "<div />" },
  "user-form-email": { template: "<input />" },
  "user-form-password": { template: "<input />" },
  "v-form": { template: "<form><slot /></form>" },
  "v-btn": { template: "<button><slot /></button>" },
  "v-card-actions": { template: "<div><slot /></div>" },
  "v-card-text": { template: "<div><slot /></div>" },
  "nuxt-link": { template: "<a><slot /></a>" },
};

interface ExposedLogin {
  login: () => Promise<void>;
  guestLogin: () => Promise<void>;
  params: { auth: { email: string; password: string } };
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
  user: { id: 1, name: "Test User" },
};

describe("pages/login.vue", () => {
  const mountPage = () =>
    mount(LoginPage, {
      global: {
        stubs: globalStubs,
      },
    });

  beforeEach(() => {
    mockShowToast.mockClear();
    mockRouterPush.mockClear();
    mockAuthLogin.mockClear();
    mockGetItem.mockClear();
  });

  afterEach(() => {
    vi.unstubAllGlobals();
  });

  test("有効な入力でログインが成功する", async () => {
    const fetchSpy = vi.fn().mockResolvedValueOnce(successAuthResponse);
    vi.stubGlobal("$fetch", fetchSpy);
    mockGetItem.mockReturnValue(null);

    const wrapper = mountPage();
    const exposed = wrapper.vm.$.exposed as ExposedLogin;

    exposed.isValid.value = true;
    exposed.params.auth = {
      email: "test@example.com",
      password: "Password1",
    };

    await exposed.login();

    expect(fetchSpy).toHaveBeenCalledWith(
      "/api/v1/user_token",
      expect.objectContaining({
        method: "POST",
        body: {
          auth: {
            email: "test@example.com",
            password: "Password1",
          },
        },
        baseURL: "http://localhost:3000",
      }),
    );

    expect(mockAuthLogin).toHaveBeenCalledWith(successAuthResponse);
    expect(mockRouterPush).toHaveBeenCalledWith("/");
    expect(exposed.loading.value).toBe(false);
  });

  test("保存されたルートがある場合はそこにリダイレクトする", async () => {
    const fetchSpy = vi.fn().mockResolvedValueOnce(successAuthResponse);
    vi.stubGlobal("$fetch", fetchSpy);
    mockGetItem.mockReturnValue("/spots/123");

    const wrapper = mountPage();
    const exposed = wrapper.vm.$.exposed as ExposedLogin;

    exposed.isValid.value = true;
    exposed.params.auth = {
      email: "test@example.com",
      password: "Password1",
    };

    await exposed.login();

    expect(mockRouterPush).toHaveBeenCalledWith("/spots/123");
  });

  test("ゲストログインが成功する", async () => {
    const fetchSpy = vi.fn().mockResolvedValueOnce(successAuthResponse);
    vi.stubGlobal("$fetch", fetchSpy);
    mockGetItem.mockReturnValue(null);

    const wrapper = mountPage();
    const exposed = wrapper.vm.$.exposed as ExposedLogin;

    await exposed.guestLogin();

    expect(fetchSpy).toHaveBeenCalledWith(
      "/api/v1/user_token",
      expect.objectContaining({
        method: "POST",
        body: {
          auth: {
            email: "guest@example.com",
            password: "guestpassword123",
          },
        },
        baseURL: "http://localhost:3000",
      }),
    );

    expect(mockAuthLogin).toHaveBeenCalledWith(successAuthResponse);
    expect(mockRouterPush).toHaveBeenCalledWith("/");
  });

  test("ユーザーが見つからない場合はエラーメッセージを表示する", async () => {
    const fetchSpy = vi.fn().mockRejectedValueOnce({
      response: { status: 404 },
    });
    vi.stubGlobal("$fetch", fetchSpy);

    const wrapper = mountPage();
    const exposed = wrapper.vm.$.exposed as ExposedLogin;

    exposed.isValid.value = true;
    exposed.params.auth = {
      email: "notfound@example.com",
      password: "Password1",
    };

    await exposed.login();

    expect(mockShowToast).toHaveBeenCalledWith({
      message: "ユーザーが見つかりません😷",
      color: "error",
    });
    expect(exposed.loading.value).toBe(false);
  });

  test("ログイン失敗時にエラーメッセージを表示する", async () => {
    const fetchSpy = vi.fn().mockRejectedValueOnce({
      response: { status: 500 },
    });
    vi.stubGlobal("$fetch", fetchSpy);

    const wrapper = mountPage();
    const exposed = wrapper.vm.$.exposed as ExposedLogin;

    exposed.isValid.value = true;
    exposed.params.auth = {
      email: "test@example.com",
      password: "wrongpassword",
    };

    await exposed.login();

    expect(mockShowToast).toHaveBeenCalledWith({
      message: "ログインに失敗しました",
      color: "error",
    });
    expect(exposed.loading.value).toBe(false);
  });

  test("不正なレスポンス形式の場合はエラーを処理する", async () => {
    const fetchSpy = vi.fn().mockResolvedValueOnce({ invalid: "response" });
    vi.stubGlobal("$fetch", fetchSpy);

    const wrapper = mountPage();
    const exposed = wrapper.vm.$.exposed as ExposedLogin;

    exposed.isValid.value = true;
    exposed.params.auth = {
      email: "test@example.com",
      password: "Password1",
    };

    await exposed.login();

    expect(mockShowToast).toHaveBeenCalledWith({
      message: "ログインに失敗しました",
      color: "error",
    });
  });
});

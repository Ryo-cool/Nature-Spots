import cryptoJs from "crypto-js";
import { computed } from "vue";
import { useAuthStore } from "~/stores/auth";
import type { User } from "~/types";

interface AuthPayload {
  exp: number;
  token: string;
  user: User | null;
}

export const useAuth = () => {
  const authStore = useAuthStore();
  const config = useRuntimeConfig();
  const keys = { exp: "exp" } as const;

  // LocalStorageはクライアントサイドでのみ利用可能
  const storage: Storage | null = import.meta.client ? localStorage : null;

  // 有効期限を暗号化
  const encrypt = (exp: number): string => {
    const expire = String(exp * 1000);
    return cryptoJs.AES.encrypt(expire, config.public.cryptoKey).toString();
  };

  // 有効期限を複合化
  const decrypt = (exp: string): number | null => {
    try {
      const bytes = cryptoJs.AES.decrypt(exp, config.public.cryptoKey);
      const expire = bytes.toString(cryptoJs.enc.Utf8);
      return expire ? Number(expire) : removeStorage();
    } catch (e) {
      return removeStorage();
    }
  };

  // storageに保存
  const setStorage = (exp: number): void => {
    if (storage) {
      storage.setItem(keys.exp, encrypt(exp));
    }
  };

  // storageを削除
  const removeStorage = (): null => {
    if (storage) {
      for (const key of Object.values(keys)) {
        storage.removeItem(key);
      }
    }
    return null;
  };

  // storageの有効期限を複合して返す
  const getExpire = (): number | null => {
    if (!storage) return null;
    const expire = storage.getItem(keys.exp);
    return expire ? decrypt(expire) : null;
  };

  // 有効期限内の場合はtrueを返す
  const isAuthenticated = (): boolean => {
    const expire = getExpire();
    return expire ? new Date().getTime() < Number(expire) : false;
  };

  // ユーザーオブジェクトがある場合にtrueを返す
  const isUserPresent = (): boolean => {
    return authStore.user !== null && "id" in (authStore.user || {});
  };

  // 有効期限内、かつユーザーが存在する場合にtrueを返す
  const loggedIn = computed(() => {
    return isAuthenticated() && isUserPresent();
  });

  // ログイン業務
  const login = async ({ exp, token, user }: AuthPayload): Promise<void> => {
    setStorage(exp);
    authStore.setToken(token);
    authStore.setUser(user);
    authStore.setAuth(true);
  };

  // ログアウト業務
  const logout = async (): Promise<void> => {
    await authStore.logout();
    removeStorage();
  };

  // 初期化処理
  const initialize = async (): Promise<void> => {
    if (isAuthenticated() && !authStore.user) {
      await authStore.fetchUser();
    } else if (!isAuthenticated()) {
      removeStorage();
      authStore.setAuth(false);
      authStore.setUser(null);
    }
  };

  return {
    login,
    logout,
    initialize,
    isAuthenticated,
    loggedIn,
    user: computed(() => authStore.user),
  };
};

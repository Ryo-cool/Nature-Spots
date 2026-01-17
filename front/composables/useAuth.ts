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
  const keys = { exp: "exp" } as const;

  // LocalStorageはクライアントサイドでのみ利用可能
  const storage: Storage | null = import.meta.client ? localStorage : null;

  // storageに保存（ミリ秒に変換してJSON保存）
  const setStorage = (exp: number): void => {
    if (storage) {
      storage.setItem(keys.exp, JSON.stringify(exp * 1000));
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

  // storageの有効期限を取得して返す
  const getExpire = (): number | null => {
    if (!storage) return null;
    const expire = storage.getItem(keys.exp);
    if (!expire) return null;
    try {
      const parsed = JSON.parse(expire);
      if (typeof parsed !== "number" || !Number.isFinite(parsed)) {
        return removeStorage();
      }
      return parsed;
    } catch {
      return removeStorage();
    }
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

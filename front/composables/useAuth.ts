import cryptoJs from "crypto-js";
import { computed } from "vue";
import { useAuthStore } from "~/stores/auth";

export const useAuth = () => {
  const authStore = useAuthStore();
  const config = useRuntimeConfig();
  const keys = { exp: "exp" };

  // LocalStorageはクライアントサイドでのみ利用可能
  const storage = import.meta.client ? localStorage : null;

  // 有効期限を暗号化
  const encrypt = (exp: number) => {
    const expire = String(exp * 1000);
    return cryptoJs.AES.encrypt(expire, config.public.cryptoKey).toString();
  };

  // 有効期限を複合化
  const decrypt = (exp: string) => {
    try {
      const bytes = cryptoJs.AES.decrypt(exp, config.public.cryptoKey);
      return bytes.toString(cryptoJs.enc.Utf8) || removeStorage();
    } catch (e) {
      return removeStorage();
    }
  };

  // storageに保存
  const setStorage = (exp: number) => {
    if (storage) {
      storage.setItem(keys.exp, encrypt(exp));
    }
  };

  // storageを削除
  const removeStorage = () => {
    if (storage) {
      for (const key of Object.values(keys)) {
        storage.removeItem(key);
      }
    }
    return null;
  };

  // storageの有効期限を複合して返す
  const getExpire = () => {
    if (!storage) return null;
    const expire = storage.getItem(keys.exp);
    return expire ? decrypt(expire) : null;
  };

  // 有効期限内の場合はtrueを返す
  const isAuthenticated = () => {
    const expire = getExpire();
    return expire ? new Date().getTime() < Number(expire) : false;
  };

  // ユーザーオブジェクトがある場合にtrueを返す
  const isUserPresent = () => {
    return authStore.user !== null && "id" in (authStore.user || {});
  };

  // 有効期限内、かつユーザーが存在する場合にtrueを返す
  const loggedIn = computed(() => {
    return isAuthenticated() && isUserPresent();
  });

  // ログイン業務
  const login = async ({
    exp,
    token,
    user,
  }: {
    exp: number;
    token: string;
    user: any;
  }) => {
    setStorage(exp);
    authStore.setToken(token);
    authStore.setUser(user);
    authStore.setAuth(true);
  };

  // ログアウト業務
  const logout = async () => {
    await authStore.logout();
    removeStorage();
  };

  // 初期化処理
  const initialize = async () => {
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

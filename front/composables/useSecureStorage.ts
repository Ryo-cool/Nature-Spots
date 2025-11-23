// セッションストレージを安全に扱うためのラッパー
export const useSecureStorage = () => {
  const isClient = process.client;

  const setItem = (key: string, value: unknown) => {
    if (!isClient) return;

    try {
      sessionStorage.setItem(key, JSON.stringify(value));
    } catch (error) {
      console.error("Failed to save to storage:", error);
    }
  };

  const getItem = <T>(key: string): T | null => {
    if (!isClient) return null;

    try {
      const item = sessionStorage.getItem(key);
      return item ? (JSON.parse(item) as T) : null;
    } catch (error) {
      console.error("Failed to read from storage:", error);
      return null;
    }
  };

  const removeItem = (key: string) => {
    if (!isClient) return;

    try {
      sessionStorage.removeItem(key);
    } catch (error) {
      console.error("Failed to remove from storage:", error);
    }
  };

  const clear = () => {
    if (!isClient) return;

    try {
      sessionStorage.clear();
    } catch (error) {
      console.error("Failed to clear storage:", error);
    }
  };

  return {
    setItem,
    getItem,
    removeItem,
    clear,
  };
};

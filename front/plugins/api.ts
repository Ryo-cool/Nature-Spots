import { useAuthStore } from "~/stores/auth";

export default defineNuxtPlugin(() => {
  const config = useRuntimeConfig();
  const isDev = process.env.NODE_ENV !== "production";
  const authStore = useAuthStore();

  // Nuxt 3ではaxiosではなく組み込みのfetchを使用
  const apiFetch = $fetch.create({
    baseURL: config.public.apiBaseUrl,
    headers: {
      "Content-Type": "application/json",
    },
    onRequest({ options }: { options: any }) {
      // リクエストにトークンを添付
      if (authStore.token) {
        options.headers = {
          ...options.headers,
          Authorization: `Bearer ${authStore.token}`,
        };
      }

      // リクエストログ
      if (isDev) {
        console.log("API Request:", options);
      }
    },
    onResponse({ response }: { response: any }) {
      // レスポンスログ
      if (isDev) {
        console.log("API Response:", response);
      }
    },
    onResponseError({ response }: { response: any }) {
      // エラーログ
      console.error("API Error:", response?.status, response?._data);
    },
  });

  return {
    provide: {
      api: apiFetch,
    },
  };
});

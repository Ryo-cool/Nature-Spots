import type { FetchContext, FetchResponse } from "ofetch";
import { useAuthStore } from "~/stores/auth";

type ApiResponse<T = any> = { data: T };
type ApiRequestOptions = Omit<RequestInit, "body" | "method"> & {
  params?: Record<string, unknown>;
};
type RequestBody = Record<string, unknown> | FormData | null;
type ApiClient = {
  get<T = any>(
    url: string,
    options?: ApiRequestOptions,
  ): Promise<ApiResponse<T>>;
  post<T = any>(
    url: string,
    body?: RequestBody,
    options?: ApiRequestOptions,
  ): Promise<ApiResponse<T>>;
  delete<T = any>(
    url: string,
    options?: ApiRequestOptions,
  ): Promise<ApiResponse<T>>;
};

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
    onRequest({ options }: FetchContext<unknown>) {
      // リクエストにトークンを添付
      if (authStore.token) {
        const headers = new Headers(options.headers as HeadersInit | undefined);
        headers.set("Authorization", `Bearer ${authStore.token}`);
        options.headers = headers;
      }

      // リクエストログ
      if (isDev) {
        console.log("API Request:", options);
      }
    },
    onResponse({ response }: { response: FetchResponse<unknown> }) {
      // レスポンスログ
      if (isDev) {
        console.log("API Response:", response);
      }
    },
    onResponseError({
      response,
    }: {
      response: FetchResponse<unknown> | undefined;
    }) {
      // エラーログ
      console.error("API Error:", response?.status, response?._data);
    },
  });

  const request = async <T = any>(
    url: string,
    options: ApiRequestOptions & {
      method: "GET" | "POST" | "DELETE";
      body?: RequestBody;
    },
  ): Promise<ApiResponse<T>> => {
    const data = await apiFetch<T>(url, options);
    return { data };
  };

  const api: ApiClient = {
    get: (url, options) => request(url, { ...options, method: "GET" }),
    post: (url, body, options) =>
      request(url, { ...options, method: "POST", body }),
    delete: (url, options) => request(url, { ...options, method: "DELETE" }),
  };

  return {
    provide: {
      api,
    },
  };
});

import type { FetchContext, FetchResponse } from "ofetch";
import { useAuthStore } from "~/stores/auth";

type ApiResponse<T = any> = { data: T };
type ApiRequestOptions = Omit<RequestInit, "body" | "method"> & {
  params?: Record<string, unknown>;
};
type RequestBody = Record<string, unknown> | FormData | null;
type HttpMethod = "GET" | "POST" | "PUT" | "PATCH" | "DELETE";
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
  put<T = any>(
    url: string,
    body?: RequestBody,
    options?: ApiRequestOptions,
  ): Promise<ApiResponse<T>>;
  patch<T = any>(
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

  const apiFetch = $fetch.create({
    baseURL: config.public.apiBaseUrl,
    headers: {
      "Content-Type": "application/json",
    },
    onRequest({ options }: FetchContext<unknown>) {
      const headers = new Headers(options.headers as HeadersInit | undefined);

      if (authStore.token) {
        headers.set("Authorization", `Bearer ${authStore.token}`);
      }

      // FormData のときはブラウザに Content-Type (boundary付き) を任せる
      if (options.body instanceof FormData) {
        headers.delete("Content-Type");
      }

      options.headers = headers;

      if (isDev) {
        console.log("API Request:", options);
      }
    },
    onResponse({ response }: { response: FetchResponse<unknown> }) {
      if (isDev) {
        console.log("API Response:", response);
      }
    },
    onResponseError({
      response,
    }: {
      response: FetchResponse<unknown> | undefined;
    }) {
      console.error("API Error:", response?.status, response?._data);
    },
  });

  const request = async <T = any>(
    url: string,
    options: ApiRequestOptions & {
      method: HttpMethod;
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
    put: (url, body, options) =>
      request(url, { ...options, method: "PUT", body }),
    patch: (url, body, options) =>
      request(url, { ...options, method: "PATCH", body }),
    delete: (url, options) => request(url, { ...options, method: "DELETE" }),
  };

  return {
    provide: {
      api,
    },
  };
});

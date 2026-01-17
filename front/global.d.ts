/// <reference types="vite/client" />
/// <reference types="vue/macros-global" />

import type { RouteLocationNormalized } from "vue-router";
import type {
  useRuntimeConfig as useRuntimeConfigFn,
  useNuxtApp as useNuxtAppFn,
  defineNuxtPlugin as defineNuxtPluginFn,
  defineNuxtRouteMiddleware as defineNuxtRouteMiddlewareFn,
  definePageMeta as definePageMetaFn,
  navigateTo as navigateToFn,
  useHead as useHeadFn,
  useRoute as useRouteFn,
  useRouter as useRouterFn,
  useError as useErrorFn,
  clearError as clearErrorFn,
} from "nuxt/app";
import type { defineNuxtConfig as defineNuxtConfigFn } from "nuxt/schema";
import type { $Fetch } from "ofetch";
import type { defineI18nConfig as defineI18nConfigFn } from "@nuxtjs/i18n";

declare module "#app" {
  interface PageMeta {
    layout?: string | ((route: RouteLocationNormalized) => string);
    middleware?: string | string[];
    auth?: boolean;
  }
}

declare module "nuxt/schema" {
  interface PublicRuntimeConfig {
    apiBaseUrl: string;
    appName: string;
    guestEmail?: string;
    guestPassword?: string;
    googleMapsApiKey: string;
  }
}

// 画像ファイルのimport用型定義
declare module "*.png" {
  const value: string;
  export default value;
}

declare module "*.jpg" {
  const value: string;
  export default value;
}

declare module "*.jpeg" {
  const value: string;
  export default value;
}

type ApiResponse<T = any> = { data: T };

type ApiRequestOptions = Omit<RequestInit, "body" | "method"> & {
  params?: Record<string, unknown>;
};

type RequestBody = Record<string, unknown> | FormData | null;

interface ApiClient {
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
}

interface ImageOptimizationService {
  convertToWebP: (
    file: File | Blob,
    options?: Record<string, unknown>,
  ) => Promise<Blob>;
  createResponsiveImage: (
    file: File,
    sizes: number[],
  ) => Promise<Record<string, Blob>>;
  checkWebPSupport: () => boolean;
}

declare global {
  const useRuntimeConfig: typeof useRuntimeConfigFn;
  const useNuxtApp: typeof useNuxtAppFn;
  const defineNuxtPlugin: typeof defineNuxtPluginFn;
  const defineNuxtConfig: typeof defineNuxtConfigFn;
  const defineNuxtRouteMiddleware: typeof defineNuxtRouteMiddlewareFn;
  const definePageMeta: typeof definePageMetaFn;
  const defineI18nConfig: typeof defineI18nConfigFn;
  const useHead: typeof useHeadFn;
  const useRoute: typeof useRouteFn;
  const useRouter: typeof useRouterFn;
  const navigateTo: typeof navigateToFn;
  const useError: typeof useErrorFn;
  const clearError: typeof clearErrorFn;
  const $fetch: $Fetch;

  interface ImportMeta {
    readonly client: boolean;
    readonly server: boolean;
  }

  // Google Maps API (lightweight declaration for global usage)
  const google: typeof globalThis.google;
}

declare module "nuxt/app" {
  interface NuxtApp {
    $api?: ApiClient;
    $imageOptimization?: ImageOptimizationService;
    $my?: {
      pageTitle(routeName: string): string;
      format(date: string | Date): string;
      spotLinkTo(
        id: number | string,
        name?: string,
      ): { name: string; params: { id: number | string } };
    };
  }
}

export {};

/// <reference types="vite/client" />
/// <reference types="vue/macros-global" />

// Nuxt関連型定義
declare module "#app" {
  interface PageMeta {
    layout?: string | ((route: any) => string);
    middleware?: string | string[];
    auth?: boolean;
  }
}

// .vueファイルの型定義
declare module "*.vue" {
  import type { DefineComponent } from "vue";
  const component: DefineComponent<{}, {}, any>;
  export default component;
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

// Nuxt 3の$fetch型定義
declare const $fetch: typeof globalThis.$fetch;

// Nuxt 3のcomposablesの型定義
declare const useRuntimeConfig: () => {
  public: {
    apiBaseUrl: string;
    appName: string;
    cryptoKey: string;
    guestEmail?: string;
    guestPassword?: string;
    googleMapsApiKey: string;
  };
};

declare const useNuxtApp: () => {
  $imageOptimization?: {
    convertToWebP: (file: File | Blob, options?: any) => Promise<Blob>;
    createResponsiveImage: (
      file: File,
      sizes: any[],
    ) => Promise<{ [key: string]: Blob }>;
    checkWebPSupport: () => boolean;
  };
  $api?: any;
  $my?: any;
  provide: (name: string, value: any) => void;
};

declare const defineNuxtPlugin: (plugin: any) => any;
declare const defineNuxtConfig: (config: any) => any;
declare const defineNuxtRouteMiddleware: (
  middleware: (to: any, from: any) => any,
) => any;
declare const definePageMeta: (meta: any) => void;
declare const defineI18nConfig: (config: any) => any;
declare const useHead: (head: any) => any;
declare const useRoute: () => any;
declare const useRouter: () => any;
declare const navigateTo: (path: string) => any;
declare const useError: () => any;
declare const clearError: (options?: { redirect?: string }) => void;
declare const useAuth: () => any;
declare const useAuthStore: () => any;

// Vite/Meta型定義
interface ImportMeta {
  client: boolean;
  server: boolean;
}

// Google Maps API
declare const google: any;
